Return-Path: <linux-kernel-owner+w=401wt.eu-S965873AbXCLOMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965873AbXCLOMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965876AbXCLOMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:12:17 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:55793 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965873AbXCLOMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:12:16 -0400
Date: Mon, 12 Mar 2007 15:11:03 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070312151103.44284b20@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070310211550.c694555d.khali@linux-fr.org>
References: <200703091345.44744.david-b@pacbell.net>
	<11735324081261-git-send-email-hskinnemoen@atmel.com>
	<20070310211550.c694555d.khali@linux-fr.org>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007 21:15:50 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> I like the idea very much. Would this let us get rid of i2c-ixp2000?
> i2c-ixp4xx? scx200_i2c? Other drivers?

Any platform that implements the generic gpio api should be able to use
this driver. So yes, I hope we might be able to get rid of a few
existing bitbanging drivers.

> > +/*
> > + * Bitbanging i2c bus driver using the GPIO API
> > + *
> > + * Copyright (C) 2006 Atmel Corporation
> 
> I'm told we're in year 2007 ;)

I'm also told that copyright protection lasts infinitely long in
practice ;)

I'll update it. I probably just copied it blindly from a different
driver.

> > +int i2c_gpio_getsda(void *data)
> > +{
> > +	struct i2c_gpio_platform_data *pdata = data;
> > +
> > +	return gpio_get_value(pdata->sda_pin);
> > +}
> 
> 
> What value will you get if the SDA pin is open-drain and currently in
> output mode? Are such GPIO pins actually able to detect that the pin is
> low while they are not themselves driving it low?

I guess that depends on the GPIO controller. But being able to read the
pin state even when the pin is configured as an output is a
prerequisite for using this driver with "open drain" pins, so if the
hardware doesn't support this, the board code should just set
{sda,scl}_is_opendrain to zero.

> > +	bit_data->udelay	= 5,			/* 100 kHz */
> 
> Actually, no, i2c-algo-bit has a 1/3-2/3 duty cycle, so a complete
> cycle is 3 times the udelay value. So udelay=5 gives you 66 kHz. If
> someone wants to fix that...

Ok. I guess we should move this parameter into the platform data struct
anyway.

> Also, I wouldn't recommend such a low value when SCL cannot be sensed,
> if a slave stretches the line even very briefly, you won't notice and
> havoc will ensue. udelay=50 sounds more reasonable for such half-baked
> busses.

Makes sense.

> > +	ret = platform_driver_probe(&i2c_gpio_driver, i2c_gpio_probe);
> > +	if (ret)
> > +		printk("i2c-gpio: probe failed: %d\n", ret);
> 
> Add KERN_ERR or similar.

Will do.

> Would you mind also adding yourself to MAINTAINERS for this driver? I
> would appreciate it.

Sure. I'm hoping this driver won't cause that much maintenance overhead
anyway since all the complicated stuff is in i2c-algo-bit. But I agree
it needs a maintainer.

Haavard
