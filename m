Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbZJMWVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbZJMWVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZJMWVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:21:12 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41558 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753296AbZJMWVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:21:11 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 18:21:11 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YcLsvMiK14cqPBj3XumLATzq3P6ChzPjY7CdI2aoVm4zFTllhDsq5o8CaIyBbwIMcyLr2iGvANv9gQB/n4OxZpr4UTeAmcgVgTOCDloLbt6NUBM5tiPBMW4u9q/JjwTnmoZ03uI3QW8sbWzQWwmnJnsf8G3OqOdqsq6hCTqKpa8=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: mcJ4VwsVM1kLs1LAW6VX5f_p5E0yLkgEYzeorEpV7o9BkOuqDgP4USw12lkw1uHIBnadimHZPV87GvS8S9bV.kGsSdlLTJgzX9RzWvbZO1VAv__E7._AS9i55gEk4MUvHv.8KNYPRMhxpsQNfIpF0i6pVLShcqpKrmONakNqRA.jtWMvx_n8Vaf..GqrBrSQJedownQPG0AkPVTpCZtep3MH7S_nwnZ7uYsV42coxl46uX1QeVBYn_Mv8Z6Cdxwd1eUdCymhEanRwLw3SIDtM657wOh6wa0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Date: Tue, 13 Oct 2009 14:10:40 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091010134814.0bac8624@bike.lwn.net> <20091010135343.775e535f@bike.lwn.net>
In-Reply-To: <20091010135343.775e535f@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910131410.40305.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009, Jonathan Corbet wrote:
> GPIO: add gpio_lookup()
> 
> GPIOs have names associated with them, but drivers cannot use those names
> and must thus rely on hardwired GPIO numbers.  That, in turn, makes dynamic
> assignment hard to use.  This patch adds a little function gpio_lookup()
> which returns the GPIO number associated with a name.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Not real keen on this; see separate emails, and below.


> ---
>  Documentation/gpio.txt     |    8 ++++++++
>  drivers/gpio/gpiolib.c     |   25 +++++++++++++++++++++++++
>  include/asm-generic/gpio.h |    1 +
>  include/linux/gpio.h       |    5 +++++
>  4 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
> index fa4dc07..b3b3dd5 100644
> --- a/Documentation/gpio.txt
> +++ b/Documentation/gpio.txt
> @@ -253,6 +253,14 @@ pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
>  Also note that it's your responsibility to have stopped using a GPIO
>  before you free it.
>  
> +GPIO users can look up GPIO numbers using the names which were provided by
> +the GPIO driver, using:
> +
> +	int gpio_lookup(const char *name);

This is missing a handle for the GPIO driver.

So for example if two video cards register a "backlight" GPIO,
nothing prevents this from returning the wrong one ... :(


> +
> +The return value will be the associated GPIO number, or -EINVAL if no GPIO
> +with the given name is found.

Easier all around to not presume lookup() functionality for GPIOs.


> +
>  
>  GPIOs mapped to IRQs
>  --------------------
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 662ed92..99d796c 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1102,6 +1102,31 @@ void gpio_free(unsigned gpio)
>  }
>  EXPORT_SYMBOL_GPL(gpio_free);
>  
> +/**
> + * gpio_lookup - Look up a GPIO by name
> + * @name: the name of the desired GPIO
> + *
> + * Returns the GPIO number associated with name, or -EINVAL if
> + * the GPIO is not found.
> + */
> +int gpio_lookup(const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARCH_NR_GPIOS; i++) {
> +		struct gpio_chip *chip = gpio_desc[i].chip;
> +
> +		if (chip == NULL || chip->names == NULL)
> +			continue;
> +		if (!strcmp(name, chip->names[i - chip->base])) {

But *any* chip can register such a name; nothing establishes or verifies
uniquness in any scope larger than that single chip...


> +			printk(KERN_NOTICE "grbn found %d\n", i);

We know the grbn should not have escaped.  But we don't
exactly know what it is!  Who is he/she?  And what is their
involvement with GPIOs?  :)


> +			return i;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(gpio_lookup);
> +
>  
>  /**
>   * gpiochip_is_requested - return string iff signal was requested
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 66d6106..667b86a 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -116,6 +116,7 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
>   */
>  extern int gpio_request(unsigned gpio, const char *label);
>  extern void gpio_free(unsigned gpio);
> +extern int gpio_lookup(const char *name);
>  
>  extern int gpio_direction_input(unsigned gpio);
>  extern int gpio_direction_output(unsigned gpio, int value);
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 059bd18..2c3f179 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -41,6 +41,11 @@ static inline void gpio_free(unsigned gpio)
>  	WARN_ON(1);
>  }
>  
> +static inline int gpio_lookup(const char *name)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int gpio_direction_input(unsigned gpio)
>  {
>  	return -ENOSYS;
> -- 
> 1.6.2.5
> 
> 


