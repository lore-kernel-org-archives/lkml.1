Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYJXX7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYJXX7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYJXX7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:59:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:4341 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYJXX7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:59:41 -0400
Message-ID: <fa686aa40810241659n7aa71870x6da2819b308ee5af@mail.gmail.com>
Date: Fri, 24 Oct 2008 17:59:40 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Trent Piepho" <tpiepho@freescale.com>
Subject: Re: [PATCH 3/4] leds: Add option to have GPIO LEDs start on
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Richard Purdie" <rpurdie@rpsys.net>,
       "Sean MacLennan" <smaclennan@pikatech.com>,
       "Wolfram Sang" <w.sang@pengutronix.de>
In-Reply-To: <1224889741-4167-3-git-send-email-tpiepho@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
	 <1224889741-4167-3-git-send-email-tpiepho@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 5:09 PM, Trent Piepho <tpiepho@freescale.com> wrote:
> Yes, there is the "default-on" trigger but there are problems with that.
[...]
> The platform device binding gains a field in the platform data "default_state"
> that controls this.  The OpenFirmware binding uses a property named
> "default-state" that can be set to "on" or "off".  The default the property
> isn't present is off.

This look much preferred to setting the the default-on trigger.  Why
not remove the default-on trigger entirely from the binding
documentation so there is no confusion?

Also, my preference would be an empty "led-default-on" property
instead of "default-state" with a value that needs to be parsed, but
I'm not concerned about it enough to argue.

Otherwise:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

>
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> ---
>  Documentation/powerpc/dts-bindings/gpio/led.txt |    7 +++++++
>  drivers/leds/leds-gpio.c                        |    8 ++++++--
>  include/linux/leds.h                            |    1 +
>  3 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/powerpc/dts-bindings/gpio/led.txt
> index 9f969c2..544ded7 100644
> --- a/Documentation/powerpc/dts-bindings/gpio/led.txt
> +++ b/Documentation/powerpc/dts-bindings/gpio/led.txt
> @@ -20,6 +20,11 @@ LED sub-node properties:
>     "heartbeat" - LED "double" flashes at a load average based rate
>     "ide-disk" - LED indicates disk activity
>     "timer" - LED flashes at a fixed, configurable rate
> +- default-state:  (optional) The initial state of the LED.  Valid
> +  values are "on" and "off".  If the LED is already on or off and the
> +  default-state property is set the to same value, then no glitch
> +  should be produced where the LED momentarily turns off (or on).
> +  The default is off if this property is not present.
>
>  Examples:
>
> @@ -36,8 +41,10 @@ run-control {
>        compatible = "gpio-leds";
>        red {
>                gpios = <&mpc8572 6 0>;
> +               default-state = "off";
>        };
>        green {
>                gpios = <&mpc8572 7 0>;
> +               default-state = "on";
>        };
>  }
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index f41b841..0dbad87 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -92,9 +92,10 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
>                led_dat->cdev.blink_set = gpio_blink_set;
>        }
>        led_dat->cdev.brightness_set = gpio_led_set;
> -       led_dat->cdev.brightness = LED_OFF;
> +       led_dat->cdev.brightness = template->default_state ? LED_FULL : LED_OFF;
>
> -       gpio_direction_output(led_dat->gpio, led_dat->active_low);
> +       gpio_direction_output(led_dat->gpio,
> +                             led_dat->active_low ^ template->default_state);
>
>        INIT_WORK(&led_dat->work, gpio_led_work);
>
> @@ -256,12 +257,15 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
>        memset(&led, 0, sizeof(led));
>        for_each_child_of_node(np, child) {
>                unsigned int flags;
> +               const char *state;
>
>                led.gpio = of_get_gpio(child, 0, &flags);
>                led.active_low = flags & OF_GPIO_ACTIVE_LOW;
>                led.name = of_get_property(child, "label", NULL) ? : child->name;
>                led.default_trigger =
>                        of_get_property(child, "linux,default-trigger", NULL);
> +               state = of_get_property(child, "default-state", NULL);
> +               led.default_state = state && !strcmp(state, "on");
>
>                ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
>                                      &ofdev->dev, NULL);
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index d3a73f5..caa3987 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -138,6 +138,7 @@ struct gpio_led {
>        const char *default_trigger;
>        unsigned        gpio;
>        u8              active_low;
> +       u8              default_state;
>  };
>
>  struct gpio_led_platform_data {
> --
> 1.5.4.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
