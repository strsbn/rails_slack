class SlackNotifier
  WEBHOOK_URL = Rails.application.credentials.dig(:SLACK_WEBHOOK)
  USER_NAME = "slack-notifier"

  def initialize
    channel = Rails.env.production? ? ENV['SLACK_PROD_CHANNEL'] : ENV['SLACK_NON_PROD_CHANNEL']
    @client = Slack::Notifier.new(WEBHOOK_URL,
                                  channel: channel,
                                  username: USER_NAME,
                                  unfurl_links: true,
    )
  end

  def send message, title: "Title", coloer: "#00ff00"
    message = {
      "color": coloer,
      "pretext": title,
      "fields": [
        {
          "value": "```" + message + "```"
        }]
    }
    @client.post attachments: message
  end
end
