class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create], :raise => false
    before_action :set_user, only: [:show, :destroy]


    #GET /users

    def index
        @users = User.all
        render json: @users, status: :ok
    end

    def show
        render json: @user, status: :ok
    end

    # POST /users

    def create
        begin
            User.transaction do
                @users = User.create!(user_params)
            end
        rescue ActiveRecord::RecordInvalid => exception
            @users = { 
                error: { 
                    status: 422,
                    messages: exception    
                }
            }
        end
        #@user = User.new(user_params)
        #if @user.save
        #    render json: @user, status: :created
        #else
        #    render json: { errors: @user.errors.full.messages }, status: :unprocessable_entity
        #end

        #if params[:user].is_a? Array
        #    params[:user].map { |hash| User.create(user_params(hash)) }
        #end
    end

    # PUT /users/{username}
    def update
        unless @user.update(user_params)
            render json: { errors: @user.errors.full.messages }, status: :unprocessable_entity
        end
    end

    # DELETE /users/{username}
    def destroy
        @user.destroy
    end


    private
        def user_params
            params.permit(:username, :password, :email)
        end

        def set_user
            @user = User.find(params[:id])
        end 
    
end
