class EventsController < ApplicationController
  def index
    if !session[:id]
      redirect_to '/users'
    else
      @user = User.find(session[:id])
      @event = Event.where(state: @user.state)
      @other_event = Event.where.not(state: @user.state)
    end
  end

  def show
    @user = User.find(session[:id])
    @event = Event.find(params[:id])
    @comment = Comment.where(event_id:@event.id)
  end

  def create
    if !session[:id]
      redirect_to '/users'
    else
      @event = Event.new(events_params)
      @event.host_id = session[:id]
      if @event.save
        redirect_to :root
      else
        flash[:errors] = @event.errors.full_messages
        redirect_to :back
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    if !session[:id]
      redirect_to '/users'
    else
      @event = Event.find(params[:id])
      if @event.update(events_params)
        redirect_to :root
      else
        flash[:errors] = @event.errors.full_messages
        redirect_to :back
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to :back
  end

  private
    def events_params
      params.require(:event).permit(:name, :date, :city, :state)
    end
end
