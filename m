Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYEQNCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYEQNCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYEQNCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:02:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44585 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbYEQNB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:01:59 -0400
Date: Sat, 17 May 2008 15:01:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Pau Oliva Fora <pau@eslack.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for HTC Shift Touchscreen
Message-ID: <20080517130158.GB19741@uranus.ravnborg.org>
References: <482ED31E.2000009@eslack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482ED31E.2000009@eslack.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pau.

Some nitpick comments - looks good overall.


On Sat, May 17, 2008 at 02:44:14PM +0200, Pau Oliva Fora wrote:
> From: Pau Oliva Fora <pau@eslack.org>
> 
> The patch below adds support for HTC Shift UMPC touchscreen.
> 
> Signed-off-by: Pau Oliva Fora <pau@eslack.org>
> 
> ---
> 
> Patch against linux-2.6.25.4, should apply clean on other versions too.
> 
> 
> diff -uprN linux-2.6.25.4/drivers/input/touchscreen/htcpen.c 
> linux/drivers/input/touchscreen/htcpen.c
> --- linux-2.6.25.4/drivers/input/touchscreen/htcpen.c	1970-01-01 
> 01:00:00.000000000 +0100
> +++ linux/drivers/input/touchscreen/htcpen.c	2008-05-17 
> 13:48:57.000000000 +0200
> @@ -0,0 +1,148 @@
> +/*
> + * HTC Shift touchscreen driver
> + *
> + * Copyright (C) 2008 Pau Oliva Fora <pof@eslack.org>
> + *
> + * Thanks to:
> + * 	Heikki Linnakangas - Penmount LPC touchscreen driver
> + * 	Wacom / Ping Cheng - Help on linuxwacom-devel
> + * 	Esteve Espuna      - Ideas, tips, moral support :)
> + *
> + * Changelog:
> + *   29980517 v0.5 - code cleanup
> + *   29980517 v0.4 - initialization works (thanks esteve!)
> + *   20080514 v0.3 - works best with TouchKit egalax xorg driver
> + *   20080511 v0.2 - little hacks to make it more usable
> + *   20080510 v0.1 - works with evtouch driver
> + *   20080428 first non-working attempt
Drop changelog - we do not keep them in-kernel.
Here we rely on git.
You can add it to your commit message if your prefer to
have it saved.

> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +
> +#define DRIVER_VERSION		"v0.5"
> +#define DRIVER_DESC	"HTC Shift touchscreen driver"
> +
> +MODULE_AUTHOR("Pau Oliva Fora <pau@eslack.org>");
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE("GPL");
> +
> +#define HTCPEN_PORT0 0x068
> +#define HTCPEN_PORT1 0x06c
> +#define HTCPEN_PORT2 0x0250
> +#define HTCPEN_PORT3 0x0251
The use of the four ports would be nice to be documented

> +#define HTCPEN_IRQ 3
> +
> +static int inverse_y;
> +module_param(inverse_y, bool, 0644);
> +MODULE_PARM_DESC(inverse_y, "If set Y axe is inversed.");
> +
> +struct input_dev *htcpen_dev;
> +
> +static void poll_htcpen(void)
> +{
> +
> +	unsigned short x, y, xy;
General comment.
In kernel we usually do not have an empty line following the
opening '{'

> +	unsigned short touch;
> +
> +	/* 0=press ; 1=release */
> +	outb_p(0xb, HTCPEN_PORT2);
> +	touch = inb_p(HTCPEN_PORT3);
> +	if (touch)
> +		touch = 0;
> +	else
> +		touch = 1;
> +
> +	input_report_key(htcpen_dev, BTN_TOUCH, touch);
> +
> +	/* only update x/y when screen is being touched */
> +	if (touch) {
> +		outb_p(3, HTCPEN_PORT2);
What is the semantic of 3 here.
Add a comment or a DEFINE
> +		x = inb_p(HTCPEN_PORT3);
> +
> +		outb_p(5, HTCPEN_PORT2);
Same here.

> +		y = inb_p(HTCPEN_PORT3);
> +
> +		outb_p(0xc, HTCPEN_PORT2);
Same here.

> +		xy = inb_p(HTCPEN_PORT3);
> +
> +		x = 8*255-((x*8)+((xy>>4)&0xf));
> +		y = (y*8)+(xy&0xf);
> +		if (inverse_y)
> +			y = 8*255-y;
These calculations needs spaces and comments.


> +
> +		input_report_abs(htcpen_dev, ABS_X, x);
> +		input_report_abs(htcpen_dev, ABS_Y, y);
> +	}
> +
> +	input_sync(htcpen_dev);
> +
> +	inb_p(HTCPEN_PORT0);
> +}
> +
> +static irqreturn_t htcpen_interrupt(int irq, void *handle)
> +{
> +	poll_htcpen();
> +	return IRQ_HANDLED;
> +}
> +
> +
> +static int __init htcpen_init(void)
> +{
> +
> +	printk(KERN_INFO "htcpen: module inserted\n");
> +
> +	inb_p(HTCPEN_PORT0);
> +
> +	htcpen_dev = input_allocate_device();
> +	if (!htcpen_dev) {
> +		printk(KERN_ERR "htcpen: can't allocate device\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (request_irq(HTCPEN_IRQ, htcpen_interrupt, 0, "htcpen", NULL)) {
> +		printk(KERN_ERR "htcpen: irq busy\n");
> +		return -EBUSY;
> +	}
I would asusme you are missing a: input_unregister_device(htcpen_dev);?

> +
> +	htcpen_dev->name = "HTC Pen TouchScreen";
> +	htcpen_dev->id.bustype = BUS_ISA;
> +	htcpen_dev->id.vendor = 0;
> +	htcpen_dev->id.product = 0;
> +	htcpen_dev->id.version = 0;
> +
> +	input_set_abs_params(htcpen_dev, ABS_X, 0, 255*8, 0, 0);
> +	input_set_abs_params(htcpen_dev, ABS_Y, 0, 255*8, 0, 0);
Again a 'magic' calculation

> +
> +	htcpen_dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
> +	htcpen_dev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y);
> +	htcpen_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +
> +	input_register_device(htcpen_dev);
> +
> +	outb_p(0xa2, HTCPEN_PORT1);
> +
> +	return 0;
> +}
> +
> +static void __exit htcpen_exit(void)
> +{
> +	input_unregister_device(htcpen_dev);
> +	free_irq(HTCPEN_IRQ, NULL);
> +	printk(KERN_INFO "htcpen: module removed\n");
> +}
> +
> +module_init(htcpen_init);
> +module_exit(htcpen_exit);


	Sam
