Return-Path: <linux-kernel-owner+w=401wt.eu-S936794AbXGSACh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936794AbXGSACh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936151AbXGSACG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:02:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937117AbXGSACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:02:04 -0400
Date: Wed, 18 Jul 2007 17:01:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       rubini@vision.unipv.it, kernel-avr32 <kernel@avr32linux.org>
Subject: Re: [PATCH 1/1] Driver for the Atmel on-chip SSC on AT32AP and
 AT91.
Message-Id: <20070718170120.8a031cdf.akpm@linux-foundation.org>
In-Reply-To: <1184568752.15535.9.camel@localhost.localdomain>
References: <1184568752.15535.9.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 08:52:32 +0200
Hans-Christian Egtvedt <hcegtvedt@atmel.com> wrote:

> The Synchronous Serial Controller (SSC) on Atmel microprocessors are capable of
> tranceiving many frame based protocols, like I2S. Tested on the
> AT32AP7000/ATSTK1000.
> 
> This driver is used in the ALSA sound driver for the AT73C213 external DAC on
> the ATSTK1000 development board for AVR32. This sound driver will be submitted
> soon.
> 
> Hardware documentation can be found in the AT32AP7000 data sheet, which can be
> downloaded from http://www.atmel.com/dyn/products/datasheets.asp?family_id=682
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 616eee9..0810d83 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -187,5 +187,15 @@ config THINKPAD_ACPI_BAY
>  
>  	  If you are not sure, say Y here.
>  
> +config ATMEL_SSC
> +	tristate "Device driver for Atmel SSC peripheral"
> +	depends on AVR32 || ARCH_AT91
> +	---help---
> +	  This option enables device driver support for Atmel Syncronized
> +	  Serial Communication peripheral (SSC).
> +
> +	  The SSC peripheral supports a wide variety of serial frame based
> +	  communications, i.e. I2S, SPI, etc.
>  
> +	  If unsure, say N.
>  endmenu
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 8abbf2f..2d52cc6 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -14,3 +14,4 @@ obj-$(CONFIG_PHANTOM)		+= phantom.o
>  obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
>  obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
>  obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
> +obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
> diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
> new file mode 100644
> index 0000000..240a538
> --- /dev/null
> +++ b/drivers/misc/atmel-ssc.c
> @@ -0,0 +1,175 @@
> +/*
> + * Atmel SSC driver
> + *
> + * Copyright (C) 2007 Atmel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/list.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/atmel-ssc.h>
> +
> +/* Serialize access to ssc_list and user count */
> +static spinlock_t user_lock;

Use DEFINE_SPINLOCK() here, remove the runtime initialisation.

> +static LIST_HEAD(ssc_list);
> +
> +struct ssc_device *ssc_request(unsigned int ssc_num)
> +{
> +	int ssc_valid = 0;
> +	struct ssc_device *ssc;
> +
> +	spin_lock(&user_lock);
> +	list_for_each_entry(ssc, &ssc_list, list) {
> +		if (ssc->pdev->id == ssc_num) {
> +			ssc_valid = 1;
> +			break;
> +		}
> +	}
> +
> +	if (!ssc_valid) {
> +		spin_unlock(&user_lock);
> +		dev_dbg(&ssc->pdev->dev, "could not find requested device\n");
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	if (ssc->user) {
> +		spin_unlock(&user_lock);
> +		dev_dbg(&ssc->pdev->dev, "module busy\n");
> +		return ERR_PTR(-EBUSY);
> +	}
> +	ssc->user++;
> +	spin_unlock(&user_lock);
> +
> +	clk_enable(ssc->clk);
> +
> +	return ssc;
> +}
> +EXPORT_SYMBOL(ssc_request);

All exports need justification, please.  An additional paragraph in the
changelog would suit.

I added this:

--- a/drivers/misc/atmel-ssc.c~driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix
+++ a/drivers/misc/atmel-ssc.c
@@ -18,7 +18,7 @@
 #include <linux/atmel-ssc.h>
 
 /* Serialize access to ssc_list and user count */
-static spinlock_t user_lock;
+static DEFINE_SPINLOCK(user_lock);
 static LIST_HEAD(ssc_list);
 
 struct ssc_device *ssc_request(unsigned int ssc_num)
@@ -159,7 +159,6 @@ static struct platform_driver ssc_driver
 
 static int __init ssc_init(void)
 {
-	spin_lock_init(&user_lock);
 	return platform_driver_probe(&ssc_driver, ssc_probe);
 }
 module_init(ssc_init);

