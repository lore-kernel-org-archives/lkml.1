Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbZFOPSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbZFOPSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762295AbZFOPSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:18:30 -0400
Received: from mail.atmel.fr ([81.80.104.162]:54679 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761390AbZFOPS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:18:29 -0400
Message-ID: <4A366631.6090904@atmel.com>
Date: Mon, 15 Jun 2009 17:18:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH 1/6] Unified AVR32/AT91 MCI Driver
References: <c8284b5b0906121802l4c944581r83e55d199f9a5b05@mail.gmail.com>
In-Reply-To: <c8284b5b0906121802l4c944581r83e55d199f9a5b05@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all thank you for this splitting effort. It is definitively the
good way of presenting things and ease reading a lot.

Rob Emanuele :
> Unification of the atmel-mci driver to support the AT91 processors MCI
> interface.  The atmel-mci driver currently supports the AVR32 and this
> patch adds AT91 support.
> 
> To use this new driver on a at91 the platform driver for your board
> needs to updated.  See the following patch for an example of how to do
> that.
> 
> Please read the whole set, try it out, and comment.

Ok, I try to make my comments. I try to collect your ideas and sometimes
submit modified patches. Comment them back if the modifications I make
to your code seams no so good to you.

> ---
>  drivers/mmc/host/Kconfig     |   16 ++++++++++++----
>  drivers/mmc/host/atmel-mci.c |   33 +++++++++++++++++++++++++++++----
>  2 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index b4cf691..6e2f52b 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -124,6 +124,12 @@ config MMC_AU1X
> 
>  	  If unsure, say N.
> 
> +choice
> +	prompt "Atmel MMC Driver"
> +	default MMC_ATMELMCI
> +	help
> +	  Choose which driver to use for the Atmel MCI Silicon

I suggest :

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index b4cf691..e779049 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -124,6 +124,12 @@ config MMC_AU1X

 	  If unsure, say N.

+choice
+	prompt "Atmel SD/MMC Driver"
+	default MMC_ATMELMCI if AVR32
+	help
+	  Choose which driver to use for the Atmel MCI Silicon
+
 config MMC_AT91
 	tristate "AT91 SD/MMC Card Interface support"
 	depends on ARCH_AT91

It will keep present default configuration for both AVR32 and AT91.

[..]

> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index cf6a100..497dd51 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -2,11 +2,13 @@
>   * Atmel MultiMedia Card Interface driver
>   *
>   * Copyright (C) 2004-2008 Atmel Corporation
> + * Copyright (C) 2009 Rob Emanuele

I think you can add your copyright on a file that you create or copy and
modify from another file.

>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +

Not needed. Can be the subject of a "presentation" only patch.

>  #include <linux/blkdev.h>
>  #include <linux/clk.h>
>  #include <linux/debugfs.h>
> @@ -30,11 +32,14 @@
>  #include <asm/io.h>
>  #include <asm/unaligned.h>
> 
> +#include <mach/cpu.h>
>  #include <mach/board.h>
> 
>  #include "atmel-mci-regs.h"
> 
> -#define ATMCI_DATA_ERROR_FLAGS	(MCI_DCRCE | MCI_DTOE | MCI_OVRE | MCI_UNRE)
> +#define ATMCI_DATA_ERROR_FLAGS	(MCI_RINDE | MCI_RDIRE | MCI_RCRCE  \
> +				 | MCI_RENDE | MCI_RTOE | MCI_DCRCE \
> +				 | MCI_DTOE | MCI_OVRE | MCI_UNRE)

We will have to consider what Haavard said: some are not data errors.
But indeed, if you experienced errors not beeing addressed, we have to
deal with them.

>  #define ATMCI_DMA_THRESHOLD	16
> 
>  enum {
> @@ -208,6 +213,18 @@ struct atmel_mci_slot {
>  	set_bit(event, &host->pending_events)
> 
>  /*
> + * Enable or disable features/registers based on
> + * whether the processor supports them
> + */
> +static bool mci_has_rwproof(void)
> +{
> +	if (cpu_is_at91sam9261() || cpu_is_at91rm9200())
> +		return false;
> +	else
> +		return true;
> +}
> +
> +/*

Ok for this.

>   * The debugfs stuff below is mostly optimized away when
>   * CONFIG_DEBUG_FS is not set.
>   */
> @@ -274,8 +291,12 @@ static void atmci_show_status_reg(struct seq_file *s,
>  		[3]	= "BLKE",
>  		[4]	= "DTIP",
>  		[5]	= "NOTBUSY",
> +		[6]	= "ENDRX",
> +		[7]	= "ENDTX",
>  		[8]	= "SDIOIRQA",
>  		[9]	= "SDIOIRQB",
> +		[14]	= "RXBUFF",
> +		[15]	= "TXBUFE",
>  		[16]	= "RINDE",
>  		[17]	= "RDIRE",
>  		[18]	= "RCRCE",

I add some MCI2 bits:

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -276,8 +276,13 @@ static void atmci_show_status_reg(struct seq_file *s,
 		[3]	= "BLKE",
 		[4]	= "DTIP",
 		[5]	= "NOTBUSY",
+		[6]	= "ENDRX",
+		[7]	= "ENDTX",
 		[8]	= "SDIOIRQA",
 		[9]	= "SDIOIRQB",
+		[12]	= "SDIOWAIT",
+		[14]	= "RXBUFF",
+		[15]	= "TXBUFE",
 		[16]	= "RINDE",
 		[17]	= "RDIRE",
 		[18]	= "RCRCE",
@@ -285,6 +290,11 @@ static void atmci_show_status_reg(struct seq_file *s,
 		[20]	= "RTOE",
 		[21]	= "DCRCE",
 		[22]	= "DTOE",
+		[23]	= "CSTOE",
+		[24]	= "BLKOVRE",
+		[25]	= "DMADONE",
+		[26]	= "FIFOEMPTY",
+		[27]	= "XFRDONE",
 		[30]	= "OVRE",
 		[31]	= "UNRE",
 	};


> @@ -847,13 +868,15 @@ static void atmci_set_ios(struct mmc_host *mmc,
> struct mmc_ios *ios)
>  			clkdiv = 255;
>  		}
> 
> +		host->mode_reg = MCI_MR_CLKDIV(clkdiv);
> +
>  		/*
>  		 * WRPROOF and RDPROOF prevent overruns/underruns by
>  		 * stopping the clock when the FIFO is full/empty.
>  		 * This state is not expected to last for long.
>  		 */
> -		host->mode_reg = MCI_MR_CLKDIV(clkdiv) | MCI_MR_WRPROOF
> -					| MCI_MR_RDPROOF;
> +		if (mci_has_rwproof())
> +			host->mode_reg |= (MCI_MR_WRPROOF | MCI_MR_RDPROOF);
> 
>  		if (list_empty(&host->queue))
>  			mci_writel(host, MR, host->mode_reg);

Ok for this.

> @@ -1642,8 +1665,10 @@ static int __init atmci_probe(struct
> platform_device *pdev)
>  			nr_slots++;
>  	}
> 
> -	if (!nr_slots)
> +	if (!nr_slots) {
> +		printk(KERN_ERR "Atmel MCI controller init failed.  atmci_init_slot
> error or no slots with bus_width > 0.\n");
>  		goto err_init_slot;
> +	}
> 
>  	dev_info(&pdev->dev,
>  			"Atmel MCI controller at 0x%08lx irq %d, %u slots\n",

Ok (maybe in a different patch)

Best regards,
-- 
Nicolas Ferre

