Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbZBSWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbZBSWvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZBSWu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:50:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442AbZBSWuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:50:55 -0500
Date: Thu, 19 Feb 2009 14:47:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kim Kyuwon <chammoru@gmail.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, kyungmin.park@samsung.com
Subject: Re: [PATCH] leds: Add BD2802GU LED driver
Message-Id: <20090219144713.192894dd.akpm@linux-foundation.org>
In-Reply-To: <4d34a0a70902181923h75a34efx5ff9dc67d83830b7@mail.gmail.com>
References: <4d34a0a70902181905v20b0971ep80af49686b8b27dd@mail.gmail.com>
	<4d34a0a70902181923h75a34efx5ff9dc67d83830b7@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 12:23:18 +0900
Kim Kyuwon <chammoru@gmail.com> wrote:

> ROHM BD2802GU is a RGB LED controller attached to i2c bus and specifically
> engineered for decoration purposes. This RGB controller incorporates lighting
> patterns and illuminates.
> 
> This driver is designed to minimize power consumption, so when there is no
> emitting LED, it enters to reset state. And because the BD2802GU has lots of
> features that can't be covered by the current LED framework, it provides
> Advanced Configuration Function(ADF) mode, so that user applications can set
> registers of BD2802GU directly.
> 
> Here are basic usage examples :
> ; to turn on LED (not blink)
> $ echo 1 > /sys/class/leds/led1_R/brightness
> ; to blink LED
> $ echo timer > /sys/class/leds/led1_R/trigger
> $ echo 1 > /sys/class/leds/led1_R/delay_on
> $ echo 1 > /sys/class/leds/led1_R/delay_off
> ; to turn off LED
> $ echo 0 > /sys/class/leds/led1_R/brightness
> 

Your email client has wordwrapped the patch and has replaced all tabs
with eight spaces.  Please fix that up when resending. 
Documentation/email-clients.txt has some gmail tips.

I had a go at cleaning it up, and found lots of code whcih was indented
with seven-spaces.  Perhaps this file was origininaly edited with
space-space-space-space indenting.  If so, please don't do that - use
hard tab characters.

Anyway, I ended up with soemthing reasonable-looking which actually
compiles.  Please check the result.

>
> ...
>
> --- /dev/null
> +++ b/drivers/leds/leds-bd2802.c
> @@ -0,0 +1,765 @@
> +/*
> + * leds-bd2802.c - RGB LED Driver
> + *
> + * Copyright (C) 2009 Samsung Electronics
> + * Kim Kyuwon <q1.kim@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Datasheet: http://www.rohm.com/products/databook/driver/pdf/bd2802gu-e.pdf
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +#include <linux/leds.h>
> +#include <linux/leds-bd2802.h>
> +
> +
> +#define LED_CTL(rgb2en, rgb1en) ((rgb2en) << 4 | (rgb1en << 0))

Argument `rgb1en' should have been parenthesised.

It would be better to implement this as a regular C function.

> +#define BD2802_LED_OFFSET              0xa
> +#define BD2802_COLOR_OFFSET            0x3
> +
> +#define BD2802_REG_CLKSETUP            0x00
> +#define BD2802_REG_CONTROL             0x01
> +#define BD2802_REG_HOURSETUP           0x02
> +#define BD2802_REG_CURRENT1SETUP       0x03
> +#define BD2802_REG_CURRENT2SETUP       0x04
> +#define BD2802_REG_WAVEPATTERN         0x05
> +
> +#define BD2802_CURRENT_032             0x10 /* 3.2mA */
> +#define BD2802_CURRENT_000             0x00 /* 0.0mA */
> +
> +#define BD2802_PATTERN_FULL            0x07
> +#define BD2802_PATTERN_HALF            0x03
> +
>
> ...
>
> +struct bd2802_led {
> +       struct bd2802_led_platform_data *pdata;
> +       struct i2c_client               *client;
> +       struct rw_semaphore             rwsem;
> +       struct work_struct              work;
> +
> +       struct led_state                led[2];
> +
> +       /*
> +        * Making led_classdev as array is not recommended, because array
> +        * members prevent using 'container_of' macro. So repetitive works
> +        * are needed.

hm.  Interesting.  I bet there's a way of using container_of(), but it
might end up being unpleasant.

> +        */
> +       struct led_classdev             cdev_led1r;
> +       struct led_classdev             cdev_led1g;
> +       struct led_classdev             cdev_led1b;
> +       struct led_classdev             cdev_led2r;
> +       struct led_classdev             cdev_led2g;
> +       struct led_classdev             cdev_led2b;
> +
> +       /*
> +        * Advanced Configuration Function(ADF) mode:
> +        * In ADF mode, user can set registers of BD2802GU directly,
> +        * therefore BD2802GU doesn't enter reset state.
> +        */
> +       int                             adf_on;
> +
> +       enum led_ids                    led_id;
> +       enum led_colors                 color;
> +       enum led_bits                   state;
> +};
>
> ...
>
> +
> +/*--------------------------------------------------------------*/
> +/*     BD2802GU core functions                                 */
> +/*--------------------------------------------------------------*/
> +
> +static int bd2802_write_byte(struct i2c_client *client, u8 reg, u8 val)
> +{
> +       int ret = i2c_smbus_write_byte_data(client, reg, val);
> +       if (ret >= 0)
> +               return 0;
> +
> +       dev_err(&client->dev, "%s: reg 0x%x, val 0x%x, err %d\n",
> +                                               __func__, reg, val, ret);
> +
> +       return ret;
> +}
> +
> +static void bd2802_update_state(struct bd2802_led *led, enum led_ids id,
> +                               enum led_colors color, enum led_bits led_bit)
> +{
> +       int i;
> +       u8 value;
> +
> +       for (i = 0 ; i < LED_NUM ; i++) {

We normally omit the spaces before the semicolons, and this driver omit
them in some places.

scripts/checkpatch.pl is supposed to detect this, but it seems that it
broke.

> +               if (i == id) {
> +                       switch (color) {
> +                       case RED:
> +                               led->led[i].r = led_bit;
> +                               break;
> +                       case GREEN:
> +                               led->led[i].g = led_bit;
> +                               break;
> +                       case BLUE:
> +                               led->led[i].b = led_bit;
> +                               break;
> +                       default:
> +                               dev_err(&led->client->dev,
> +                                       "%s: Invalid color\n", __func__);
> +                               return;
> +                       }
> +               }
> +       }
>
> ...
>
> +static inline void bd2802_turn_on(struct bd2802_led *led, enum led_ids id,
> +                               enum led_colors color, enum led_bits led_bit)
> +{
> +       if (led_bit == BD2802_OFF) {
> +               dev_err(&led->client->dev,
> +                                       "Only 'blink' and 'on' are allowed\n");
> +               return;
> +       }
> +
> +       if (led_bit == BD2802_BLINK)
> +               bd2802_set_blink(led, id, color);
> +       else
> +               bd2802_set_on(led, id, color);
> +}

The driver attemtps to inline a large number of large functions.  This
will (depending upon Kconfig options) produce a lot more code and is
probably slower than not inlining them.

>
> ...
>
> --- /dev/null
> +++ b/include/linux/leds-bd2802.h
> @@ -0,0 +1,26 @@
> +/*
> + * leds-bd2802.h - RGB LED Driver
> + *
> + * Copyright (C) 2009 Samsung Electronics
> + * Kim Kyuwon <q1.kim@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Datasheet: http://www.rohm.com/products/databook/driver/pdf/bd2802gu-e.pdf
> + *
> + */
> +#ifndef _LEDS_BD2802_H_
> +#define _LEDS_BD2802_H_
> +
> +struct bd2802_led_platform_data{
> +       int     reset_gpio;
> +       u8      rgb_time;
> +};
> +
> +#define RGB_TIME(slopedown, slopeup, waveform) \
> +       ((slopedown) << 6 | ((slopeup) << 4) | (waveform))

Again, it would be better to implement this as a plain old C function.

After all that - it's a nice-looking driver.

