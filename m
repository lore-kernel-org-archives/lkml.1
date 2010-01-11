Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685Ab0AKWsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab0AKWsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372Ab0AKWsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:48:00 -0500
Received: from waste.org ([173.11.57.241]:39247 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab0AKWr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:47:59 -0500
Subject: Re: [PATCH] Use AB3100 MFD core IRQ for interrupt randomness
From: Matt Mackall <mpm@selenic.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       Robin Getz <rgetz@blackfin.uclinux.org>
In-Reply-To: <1262997509-5680-1-git-send-email-linus.walleij@stericsson.com>
References: <1262997509-5680-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 16:47:55 -0600
Message-ID: <1263250075.29868.4750.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 01:38 +0100, Linus Walleij wrote:
> This reintroduces the entropy sampling of the AB3100 IRQ as the
> IRQF_SAMPLE_RANDOM is going out according to the feature removal
> schedule. I'm trying to do this the right way then, so CC:ing some
> random people for a quick review. We add entropy for interrupt
> events in the AB3100 which are truly random in nature, like
> external cables being connected, voltages on batteries dropping
> below certain ranges, ADC triggers or overheating.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Robin Getz <rgetz@blackfin.uclinux.org>
> Cc: Matt Mackall <mpm@selenic.com>
> ---
>  drivers/mfd/ab3100-core.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
> index aa3824a..a2ce3b6 100644
> --- a/drivers/mfd/ab3100-core.c
> +++ b/drivers/mfd/ab3100-core.c
> @@ -1,5 +1,5 @@
>  /*
> - * Copyright (C) 2007-2009 ST-Ericsson
> + * Copyright (C) 2007-2010 ST-Ericsson
>   * License terms: GNU General Public License (GPL) version 2
>   * Low-level core for exclusive access to the AB3100 IC on the I2C bus
>   * and some basic chip-configuration.
> @@ -14,6 +14,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
> +#include <linux/random.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/uaccess.h>
> @@ -376,6 +377,8 @@ static irqreturn_t ab3100_irq_handler(int irq, void *data)
>  	u32 fatevent;
>  	int err;
>  
> +	add_interrupt_randomness(irq);
> +
>  	err = ab3100_get_register_page_interruptible(ab3100, AB3100_EVENTA1,
>  				       event_regs, 3);
>  	if (err)
> @@ -720,10 +723,7 @@ static struct platform_device ab3100_##devname##_device = {	\
>  	.id		= -1,					\
>  }
>  
> -/*
> - * This lists all the subdevices and corresponding register
> - * ranges.
> - */
> +/* This lists all the subdevices */
>  AB3100_DEVICE(dac, "ab3100-dac");
>  AB3100_DEVICE(leds, "ab3100-leds");
>  AB3100_DEVICE(power, "ab3100-power");
> @@ -889,10 +889,11 @@ static int __init ab3100_probe(struct i2c_client *client,
>  	if (err)
>  		goto exit_no_setup;
>  
> -	/* This real unpredictable IRQ is of course sampled for entropy */
>  	err = request_threaded_irq(client->irq, NULL, ab3100_irq_handler,
> -			  IRQF_ONESHOT,
> -			  "ab3100-core", ab3100);
> +				IRQF_ONESHOT, "ab3100-core", ab3100);
> +	/* This real unpredictable IRQ is of course sampled for entropy */
> +	rand_initialize_irq(client->irq);
> +
>  	if (err)
>  		goto exit_no_irq;

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


