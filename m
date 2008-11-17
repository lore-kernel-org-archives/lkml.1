Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYKQWtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYKQWtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKQWtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:49:00 -0500
Received: from tim.rpsys.net ([194.106.48.114]:32869 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYKQWs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:48:59 -0500
Subject: Re: [PATCH 4/4] leds: Let GPIO LEDs keep their current state
From: Richard Purdie <rpurdie@rpsys.net>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <1224889741-4167-4-git-send-email-tpiepho@freescale.com>
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
	 <1224889741-4167-4-git-send-email-tpiepho@freescale.com>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 14:50:27 +0000
Message-Id: <1226933427.17109.15.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 16:09 -0700, Trent Piepho wrote:
> Let GPIO LEDs get their initial value from whatever the current state of
> the GPIO line is.  On some systems the LEDs are put into some state by the
> firmware or hardware before Linux boots, and it is desired to have them
> keep this state which is otherwise unknown to Linux.
> 
> This requires that the underlying GPIO driver support reading the value of
> output GPIOs.  Some drivers support this and some do not.
> 
> The platform data for the platform device binding gets a new field
> 'keep_state' which turns this on.  keep_state overrides default_state.
> 
> For the OpenFirmware bindings, the "default-state" property gains a new
> allowable setting "keep".
> 
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 0dbad87..bb2a234 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -92,10 +92,13 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
>  		led_dat->cdev.blink_set = gpio_blink_set;
>  	}
>  	led_dat->cdev.brightness_set = gpio_led_set;
> -	led_dat->cdev.brightness = template->default_state ? LED_FULL : LED_OFF;
> +	if (template->keep_state)
> +		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
> +	else
> +		state = template->default_state;
> +	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
>  
> -	gpio_direction_output(led_dat->gpio,
> -	                      led_dat->active_low ^ template->default_state);
> +	gpio_direction_output(led_dat->gpio, led_dat->active_low ^ state);
>  
>  	INIT_WORK(&led_dat->work, gpio_led_work);
>  
> @@ -266,6 +269,7 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
>  			of_get_property(child, "linux,default-trigger", NULL);
>  		state = of_get_property(child, "default-state", NULL);
>  		led.default_state = state && !strcmp(state, "on");
> +		led.keep_state = state && !strcmp(state, "keep");
>  
>  		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
>  				      &ofdev->dev, NULL);
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index caa3987..c51b625 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -138,7 +138,8 @@ struct gpio_led {
>  	const char *default_trigger;
>  	unsigned 	gpio;
>  	u8 		active_low;
> -	u8		default_state;
> +	u8		default_state;	/* 0 = off, 1 = on */
> +	u8		keep_state; /* overrides default_state */
>  };

How about something simpler here, just make default state have three
different values - "keep", "on" and "off"? I'm not keen on having two
different state variables like this.

Regards,

Richard



