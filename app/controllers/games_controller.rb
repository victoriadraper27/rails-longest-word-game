require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @game_letters = params[:letters]
    @scoring = word_checking
  end

  def word_checking
    if can_build?
      if english_word?
        "Congradulations! #{@word} is a valid English word!"
      else
        "Sorry but #{@word} doesn't seem to be a valid English word..."
      end
    else
      "Sorry but #{@word} can't be built out of #{@letters.join}"
    end
  end

  def can_build?
    @word.chars.all? { |letter| @word.count(letter) <= @game_letters.count(letter) }
  end

  def english_word?
    response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
