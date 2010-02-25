Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab0BYKVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:21:08 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:40741 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab0BYKVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:21:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jImIOhjqirZ8bzixZAIlyS4QjBVu/t60fxPgfKU5ekDYsshgaNPROGAzD2i/6Kkill
         z8d97s13ajTiHZEA1dwgRs1sy/sCbXQrIm4rFtdgSEqdqnEiqbK/X/ZIV2hQnPIKxwds
         hlTd8RI63cLMbNhvRuuaD4FHA+CXnwR+NZtQo=
Date: Thu, 25 Feb 2010 02:20:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl,
       linux-input@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd leds through the generic leds layer (3rd
 version)
Message-ID: <20100225102056.GG10823@core.coreip.homeip.net>
References: <20100224012010.GA4062@const>
 <20100225013840.GA5519@const.homenet.telecomitalia.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225013840.GA5519@const.homenet.telecomitalia.it>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 02:38:40AM +0100, Samuel Thibault wrote:
> Route keyboard leds through the generic leds layer.
> 
> This permits to reassign keyboard LEDs to something else than keyboard
> "leds" state, and also permits to fix #7063 from userland by using a
> modifier to implement proper CapsLock behavior and have the keyboard
> caps lock led show that caps lock state.
> 

I am aunsure about this patch. It ties all LEDs together whereas
currently it is possible to operate keyboards and their leds
independently (as long as legacy keyboard driver is out of picture, i.e.
in X or otherwise when we have console in raw mode).

> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> ---
> 
> Hello,
> 
> Here is a third version of the patch and should now be fine for
> inclusion e.g. in the mm tree and eventually pushed to 2.6.34. The main
> difference with the first version is that now only input leds actually
> available on some device are registered. The difference with the second
> version is a refresh against 2.6.33 and a locking fix.
> 
> The first version was acked by Pavel Machek.
> 
> Samuel
> 
> diff -ur linux-2.6.33-orig/Documentation/leds-class.txt linux-2.6.33-perso/Documentation/leds-class.txt
> --- linux-2.6.33-orig/Documentation/leds-class.txt	2009-12-03 13:41:42.000000000 +0100
> +++ linux-2.6.33-perso/Documentation/leds-class.txt	2010-02-25 01:45:28.000000000 +0100
> @@ -2,9 +2,6 @@
>  LED handling under Linux
>  ========================
>  
> -If you're reading this and thinking about keyboard leds, these are
> -handled by the input subsystem and the led class is *not* needed.
> -
>  In its simplest form, the LED class just allows control of LEDs from
>  userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
>  LED is defined in max_brightness file. The brightness file will set the brightness
> diff -ur linux-2.6.33-orig/drivers/char/keyboard.c linux-2.6.33-perso/drivers/char/keyboard.c
> --- linux-2.6.33-orig/drivers/char/keyboard.c	2010-02-25 01:41:19.000000000 +0100
> +++ linux-2.6.33-perso/drivers/char/keyboard.c	2010-02-25 01:52:11.000000000 +0100
> @@ -34,6 +34,7 @@
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/irq.h>
> +#include <linux/leds.h>
>  
>  #include <linux/kbd_kern.h>
>  #include <linux/kbd_diacr.h>
> @@ -139,6 +140,9 @@
>  static char rep;					/* flag telling character repeat */
>  
>  static unsigned char ledstate = 0xff;			/* undefined */
> +#ifdef CONFIG_LEDS_INPUT
> +static unsigned char lockstate = 0xff;			/* undefined */
> +#endif
>  static unsigned char ledioctl;
>  
>  static struct ledptr {
> @@ -971,6 +975,23 @@
>  	}
>  }
>  
> +#ifdef CONFIG_LEDS_INPUT
> +/* When input-based leds are enabled, we route keyboard "leds" through triggers
> + */
> +DEFINE_LED_TRIGGER(ledtrig_scrolllock);
> +DEFINE_LED_TRIGGER(ledtrig_numlock);
> +DEFINE_LED_TRIGGER(ledtrig_capslock);
> +DEFINE_LED_TRIGGER(ledtrig_kanalock);
> +DEFINE_LED_TRIGGER(ledtrig_shiftlock);
> +DEFINE_LED_TRIGGER(ledtrig_altgrlock);
> +DEFINE_LED_TRIGGER(ledtrig_ctrllock);
> +DEFINE_LED_TRIGGER(ledtrig_altlock);
> +DEFINE_LED_TRIGGER(ledtrig_shiftllock);
> +DEFINE_LED_TRIGGER(ledtrig_shiftrlock);
> +DEFINE_LED_TRIGGER(ledtrig_ctrlllock);
> +DEFINE_LED_TRIGGER(ledtrig_ctrlrlock);
> +#endif
> +
>  /*
>   * The leds display either (i) the status of NumLock, CapsLock, ScrollLock,
>   * or (ii) whatever pattern of lights people want to show using KDSETLED,
> @@ -1019,9 +1040,12 @@
>  	unsigned char leds = *(unsigned char *)data;
>  
>  	if (test_bit(EV_LED, handle->dev->evbit)) {
> -		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
> -		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
> -		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
> +		input_inject_event(handle, EV_LED, LED_SCROLLL,
> +				!!(leds & VC_SCROLLOCK));
> +		input_inject_event(handle, EV_LED, LED_NUML,
> +				!!(leds & VC_NUMLOCK));
> +		input_inject_event(handle, EV_LED, LED_CAPSL,
> +				!!(leds & VC_CAPSLOCK));
>  		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
>  	}
>  
> @@ -1040,10 +1064,51 @@
>  	unsigned char leds = getleds();
>  
>  	if (leds != ledstate) {
> +#ifdef CONFIG_LEDS_INPUT
> +		led_trigger_event(ledtrig_scrolllock,
> +				leds & (1 << VC_SCROLLOCK) ? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_numlock,
> +				leds & (1 << VC_NUMLOCK)   ? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_capslock,
> +				leds & (1 << VC_CAPSLOCK)  ? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_kanalock,
> +				leds & (1 << VC_KANALOCK)  ? INT_MAX : LED_OFF);
> +#else
>  		input_handler_for_each_handle(&kbd_handler, &leds,
>  					      kbd_update_leds_helper);
> +#endif
>  		ledstate = leds;
>  	}
> +
> +#ifdef CONFIG_LEDS_INPUT
> +	if (kbd->lockstate != lockstate) {
> +		led_trigger_event(ledtrig_shiftlock,
> +			kbd->lockstate & (1<<VC_SHIFTLOCK)
> +				? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_altgrlock,
> +			kbd->lockstate & (1<<VC_ALTGRLOCK)
> +				? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_ctrllock,
> +			kbd->lockstate & (1<<VC_CTRLLOCK)
> +				? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_altlock,
> +			kbd->lockstate & (1<<VC_ALTLOCK)
> +				? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_shiftllock,
> +			kbd->lockstate & (1<<VC_SHIFTLLOCK)
> +				? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_shiftrlock,
> +			kbd->lockstate & (1<<VC_SHIFTRLOCK)
> +				? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_ctrlllock,
> +			kbd->lockstate & (1<<VC_CTRLLLOCK)
> +				? INT_MAX : LED_OFF);
> +		led_trigger_event(ledtrig_ctrlrlock,
> +			kbd->lockstate & (1<<VC_CTRLRLOCK)
> +				? INT_MAX : LED_OFF);
> +		lockstate = kbd->lockstate;
> +	}
> +#endif
>  }
>  
>  DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
> @@ -1380,6 +1445,7 @@
>  	kfree(handle);
>  }
>  
> +#ifndef CONFIG_LEDS_INPUT
>  /*
>   * Start keyboard handler on the new keyboard by refreshing LED state to
>   * match the rest of the system.
> @@ -1393,6 +1459,7 @@
>  
>  	tasklet_enable(&keyboard_tasklet);
>  }
> +#endif
>  
>  static const struct input_device_id kbd_ids[] = {
>  	{
> @@ -1414,7 +1481,9 @@
>  	.event		= kbd_event,
>  	.connect	= kbd_connect,
>  	.disconnect	= kbd_disconnect,
> +#ifndef CONFIG_LEDS_INPUT
>  	.start		= kbd_start,
> +#endif
>  	.name		= "kbd",
>  	.id_table	= kbd_ids,
>  };
> @@ -1438,6 +1507,21 @@
>  	if (error)
>  		return error;
>  
> +#ifdef CONFIG_LEDS_INPUT
> +	led_trigger_register_simple("scrolllock", &ledtrig_scrolllock);
> +	led_trigger_register_simple("numlock", &ledtrig_numlock);
> +	led_trigger_register_simple("capslock", &ledtrig_capslock);
> +	led_trigger_register_simple("kanalock", &ledtrig_kanalock);
> +	led_trigger_register_simple("shiftlock", &ledtrig_shiftlock);
> +	led_trigger_register_simple("altgrlock", &ledtrig_altgrlock);
> +	led_trigger_register_simple("ctrllock", &ledtrig_ctrllock);
> +	led_trigger_register_simple("altlock", &ledtrig_altlock);
> +	led_trigger_register_simple("shiftllock", &ledtrig_shiftllock);
> +	led_trigger_register_simple("shiftrlock", &ledtrig_shiftrlock);
> +	led_trigger_register_simple("ctrlllock", &ledtrig_ctrlllock);
> +	led_trigger_register_simple("ctrlrlock", &ledtrig_ctrlrlock);
> +#endif
> +
>  	tasklet_enable(&keyboard_tasklet);
>  	tasklet_schedule(&keyboard_tasklet);
>  
> diff -ur linux-2.6.33-orig/drivers/leds/Kconfig linux-2.6.33-perso/drivers/leds/Kconfig
> --- linux-2.6.33-orig/drivers/leds/Kconfig	2010-02-25 01:41:27.000000000 +0100
> +++ linux-2.6.33-perso/drivers/leds/Kconfig	2010-02-25 01:45:28.000000000 +0100
> @@ -4,9 +4,6 @@
>  	  Say Y to enable Linux LED support.  This allows control of supported
>  	  LEDs from both userspace and optionally, by kernel events (triggers).
>  
> -	  This is not related to standard keyboard LEDs which are controlled
> -	  via the input system.
> -
>  if NEW_LEDS
>  
>  config LEDS_CLASS
> @@ -17,6 +14,13 @@
>  
>  comment "LED drivers"
>  
> +config LEDS_INPUT
> +	tristate "LED Support using input keyboards"
> +	depends on LEDS_CLASS
> +	help
> +	  This option enables support for the LEDs on keyboard managed
> +	  by the input layer.
> +
>  config LEDS_ATMEL_PWM
>  	tristate "LED Support using Atmel PWM outputs"
>  	depends on LEDS_CLASS && ATMEL_PWM
> diff -ur linux-2.6.33-orig/drivers/leds/leds-input.c linux-2.6.33-perso/drivers/leds/leds-input.c
> --- linux-2.6.33-orig/drivers/leds/leds-input.c	2010-02-21 04:13:41.000000000 +0100
> +++ linux-2.6.33-perso/drivers/leds/leds-input.c	2010-02-25 01:45:28.000000000 +0100
> @@ -0,0 +1,195 @@
> +/*
> + * LED support for the input layer
> + *
> + * Copyright 2010 Samuel Thibault <samuel.thibault@ens-lyon.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/leds.h>
> +#include <linux/input.h>
> +
> +/* Protects concurrency of led state */
> +static DEFINE_SPINLOCK(input_leds_lock);
> +/* Current state */
> +static unsigned long input_led_leds[BITS_TO_LONGS(LED_CNT)];
> +/* array of all led classes */
> +static struct led_classdev input_leds[LED_CNT];
> +/* Protects concurrency of led registration */
> +static DEFINE_SPINLOCK(input_led_registered_lock);
> +/* which led classes are registered */
> +static unsigned long input_led_registered[BITS_TO_LONGS(LED_CNT)];
> +/* our handler */
> +static struct input_handler input_led_handler;
> +
> +/* Led state change, update all keyboards */
> +static void input_led_set(struct led_classdev *cdev,
> +			  enum led_brightness brightness)
> +{
> +	int led = cdev - input_leds;
> +	unsigned long flags;
> +	struct input_handle *handle;
> +
> +	spin_lock_irqsave(&input_leds_lock, flags);
> +	list_for_each_entry(handle, &input_led_handler.h_list, h_node) {
> +		input_inject_event(handle, EV_LED, led, !!brightness);
> +		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
> +	}
> +	if (brightness)
> +		set_bit(led, input_led_leds);
> +	else
> +		clear_bit(led, input_led_leds);
> +	spin_unlock_irqrestore(&input_leds_lock, flags);
> +}
> +
> +static struct led_classdev input_leds[LED_CNT] = {
> +#define DEFINE_INPUT_LED(input_led, nam, deftrig) \
> +	[input_led] = { \
> +		.name = "input::"nam, \
> +		.max_brightness = 1, \
> +		.brightness_set = input_led_set, \
> +		.default_trigger = deftrig, \
> +	}
> +DEFINE_INPUT_LED(LED_NUML, "numlock", "numlock"),
> +DEFINE_INPUT_LED(LED_CAPSL, "capslock", "capslock"),
> +DEFINE_INPUT_LED(LED_SCROLLL, "scrolllock", "scrolllock"),
> +DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
> +DEFINE_INPUT_LED(LED_KANA, "kana", "kanalock"),
> +DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
> +DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
> +DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
> +DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
> +DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
> +DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
> +};
> +
> +static int input_led_connect(struct input_handler *handler,
> +			      struct input_dev *dev,
> +			      const struct input_device_id *id)
> +{
> +	struct input_handle *handle;
> +	int i, error;
> +	unsigned long flags;
> +
> +	if (!test_bit(EV_LED, dev->keybit))
> +		return -ENODEV;
> +
> +	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
> +	if (!handle)
> +		return -ENOMEM;
> +
> +	handle->dev = dev;
> +	handle->handler = handler;
> +	handle->name = "input leds";
> +
> +	error = input_register_handle(handle);
> +	if (error) {
> +		kfree(handle);
> +		return error;
> +	}
> +
> +	spin_lock_irqsave(&input_led_registered_lock, flags);
> +	for (i = 0; i < LED_CNT; i++)
> +		if (input_leds[i].name
> +				&& !test_bit(i, input_led_registered)
> +				&& test_bit(i, dev->ledbit))
> +			/* This keyboard has led i, try to register it */
> +			if (!led_classdev_register(NULL, &input_leds[i]))
> +				set_bit(i, input_led_registered);
> +	spin_unlock_irqrestore(&input_led_registered_lock, flags);
> +
> +	return 0;
> +}
> +
> +static void input_led_disconnect(struct input_handle *handle)
> +{
> +	int unregister, i;
> +	unsigned long flags;
> +
> +	input_unregister_handle(handle);
> +	kfree(handle);
> +
> +	spin_lock_irqsave(&input_led_registered_lock, flags);
> +	for (i = 0; i < LED_CNT; i++) {
> +		if (!test_bit(i, input_led_registered))
> +			continue;
> +
> +		unregister = 1;
> +		list_for_each_entry(handle, &input_led_handler.h_list, h_node) {
> +			if (test_bit(i, handle->dev->ledbit)) {
> +				unregister = 0;
> +				break;
> +			}
> +		}
> +		if (!unregister)
> +			continue;
> +
> +		led_classdev_unregister(&input_leds[i]);
> +		clear_bit(i, input_led_registered);
> +	}
> +	spin_unlock_irqrestore(&input_led_registered_lock, flags);
> +}
> +
> +/* New keyboard, update its leds */
> +static void input_led_start(struct input_handle *handle)
> +{
> +	unsigned long flags;
> +	int i;
> +
> +	spin_lock_irqsave(&input_leds_lock, flags);
> +	for (i = 0; i < LED_CNT; i++)
> +		if (input_leds[i].name && test_bit(i, handle->dev->ledbit))
> +			input_inject_event(handle, EV_LED, i,
> +					test_bit(i, input_led_leds));
> +	input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
> +	spin_unlock_irqrestore(&input_leds_lock, flags);
> +}
> +
> +static const struct input_device_id input_led_ids[] = {
> +	{
> +		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
> +		.evbit = { BIT_MASK(EV_LED) },
> +	},
> +
> +	{ },	/* Terminating entry */
> +};
> +
> +static struct input_handler input_led_handler = {
> +	.connect	= input_led_connect,
> +	.disconnect	= input_led_disconnect,
> +	.start		= input_led_start,
> +	.name		= "input leds",
> +	.id_table	= input_led_ids,
> +};
> +
> +static int __init input_led_init(void)
> +{
> +	return input_register_handler(&input_led_handler);
> +}
> +
> +static void __exit input_led_exit(void)
> +{
> +	int i;
> +	unsigned long flags;
> +
> +	input_unregister_handler(&input_led_handler);
> +
> +	spin_lock_irqsave(&input_leds_lock, flags);
> +	for (i = 0; i < LED_CNT; i++)
> +		if (test_bit(i, input_led_registered)) {
> +			led_classdev_unregister(&input_leds[i]);
> +			clear_bit(i, input_led_registered);
> +		}
> +	spin_unlock_irqrestore(&input_leds_lock, flags);
> +}
> +
> +module_init(input_led_init);
> +module_exit(input_led_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("User LED support for input layer");
> +MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
> diff -ur linux-2.6.33-orig/drivers/leds/Makefile linux-2.6.33-perso/drivers/leds/Makefile
> --- linux-2.6.33-orig/drivers/leds/Makefile	2010-02-25 01:41:27.000000000 +0100
> +++ linux-2.6.33-perso/drivers/leds/Makefile	2010-02-25 01:45:28.000000000 +0100
> @@ -5,6 +5,7 @@
>  obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
>  
>  # LED Platform Drivers
> +obj-$(CONFIG_LEDS_INPUT)		+= leds-input.o
>  obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
>  obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
>  obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o

-- 
Dmitry
