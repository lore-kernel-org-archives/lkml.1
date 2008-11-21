Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYKUBMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYKUBMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYKUBMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:12:21 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:60877 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbYKUBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:12:19 -0500
Date: Thu, 20 Nov 2008 17:05:56 -0800 (PST)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Richard Purdie <rpurdie@rpsys.net>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/4] leds: Let GPIO LEDs keep their current state
In-Reply-To: <1226933427.17109.15.camel@ted>
Message-ID: <Pine.LNX.4.64.0811201640570.11673@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp> 
 <1224889741-4167-4-git-send-email-tpiepho@freescale.com> <1226933427.17109.15.camel@ted>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Richard Purdie wrote:
> On Fri, 2008-10-24 at 16:09 -0700, Trent Piepho wrote:
>> +	if (template->keep_state)
>> +		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
>> +	else
>> +		state = template->default_state;
>>
>>  		state = of_get_property(child, "default-state", NULL);
>>  		led.default_state = state && !strcmp(state, "on");
>> +		led.keep_state = state && !strcmp(state, "keep");
>>
>> +++ b/include/linux/leds.h
>> @@ -138,7 +138,8 @@ struct gpio_led {
>>  	const char *default_trigger;
>>  	unsigned 	gpio;
>>  	u8 		active_low;
>> -	u8		default_state;
>> +	u8		default_state;	/* 0 = off, 1 = on */
>> +	u8		keep_state; /* overrides default_state */
>>  };
>
> How about something simpler here, just make default state have three
> different values - "keep", "on" and "off"? I'm not keen on having two
> different state variables like this.

I thought of that, but it ends up being more complex.  Instead of just
using:
static const struct gpio_led myled = {
 	.name = "something",
 	.keep_state = 1,
}

You'd do something like this:
 	.default_state = LEDS_GPIO_DEFSTATE_KEEP,

Is that better?  The constants for on/off/keep are one more thing you have
to look-up and remember when defining leds.  The code in the leds-gpio
driver ends up getting more complex to deal with one tristate vs two
booleans.

This is a patch to change to a tristate.  I don't think it's an
improvement.  More symbols defined, more code, extra stuff to remember
when defining leds, and removing the field from struct gpio_led doesn't
make it smaller due to padding.

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index bb2a234..8a7303c 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -92,10 +92,10 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
  		led_dat->cdev.blink_set = gpio_blink_set;
  	}
  	led_dat->cdev.brightness_set = gpio_led_set;
-	if (template->keep_state)
+	if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP)
  		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
  	else
-		state = template->default_state;
+		state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
  	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;

  	gpio_direction_output(led_dat->gpio, led_dat->active_low ^ state);
@@ -268,8 +268,15 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
  		led.default_trigger =
  			of_get_property(child, "linux,default-trigger", NULL);
  		state = of_get_property(child, "default-state", NULL);
-		led.default_state = state && !strcmp(state, "on");
-		led.keep_state = state && !strcmp(state, "keep");
+		if (state) {
+			if (!strcmp(state, "keep")) {
+				led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
+			} else if(!strcmp(state, "on")) {
+				led.default_state = LEDS_GPIO_DEFSTATE_ON;
+			} else {
+				led.default_state = LEDS_GPIO_DEFSTATE_OFF;
+			}
+		}

  		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
  				      &ofdev->dev, NULL);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index c51b625..f4a125c 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -138,9 +138,12 @@ struct gpio_led {
  	const char *default_trigger;
  	unsigned 	gpio;
  	u8 		active_low;
-	u8		default_state;	/* 0 = off, 1 = on */
-	u8		keep_state; /* overrides default_state */
+	u8		default_state;
+	/* default_state should be one of LEDS_GPIO_DEFSTATE_(ON|OFF|KEEP) */
  };
+#define LEDS_GPIO_DEFSTATE_OFF	0
+#define LEDS_GPIO_DEFSTATE_ON	1
+#define LEDS_GPIO_DEFSTATE_KEEP	2

  struct gpio_led_platform_data {
  	int 		num_leds;
