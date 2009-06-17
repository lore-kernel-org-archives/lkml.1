Return-Path: <linux-kernel-owner+w=401wt.eu-S1765333AbZFQJ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765333AbZFQJ4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764993AbZFQJ4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:56:39 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64316 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764951AbZFQJ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:56:37 -0400
Message-ID: <4A38BDB8.5030804@atmel.com>
Date: Wed, 17 Jun 2009 11:56:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <rob@emanuele.us>, haavard.skinnemoen@atmel.com
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] atmel-mci: Unified Atmel MCI drivers (AVR32 & AT91)
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
In-Reply-To: <1245200079-6323-1-git-send-email-rob@emanuele.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob, Haavard,

Rob Emanuele :
> Unification of the atmel-mci driver to support the AT91 processors MCI interface.  The atmel-mci driver currently supports the AVR32 and this patch adds AT91 support.
> 
> To use this new driver on a at91 the platform driver for your board needs to updated.  See the following patch for an example of how to do that.

I format those lines remove last sentence and add :
"Add read/write proof selection switch dependent on chip availability
 of this feature."


> Signed-off-by: Rob Emanuele <rob@emanuele.us>
> ---
>  drivers/mmc/host/Kconfig     |   16 ++++++++++++----
>  drivers/mmc/host/atmel-mci.c |   37 +++++++++++++++++++++++++++++++++----
>  2 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 40111a6..a0eaf69 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -135,6 +135,12 @@ config MMC_AU1X
>  
>  	  If unsure, say N.
>  
> +choice
> +	prompt "Atmel MMC Driver"

I add SD/MMC

> +	default MMC_ATMELMCI if AVR32
> +	help
> +	  Choose which driver to use for the Atmel MCI Silicon
> +
>  config MMC_AT91
>  	tristate "AT91 SD/MMC Card Interface support"
>  	depends on ARCH_AT91
> @@ -145,17 +151,19 @@ config MMC_AT91
>  
>  config MMC_ATMELMCI
>  	tristate "Atmel Multimedia Card Interface support"
> -	depends on AVR32
> +	depends on AVR32 || ARCH_AT91
>  	help
>  	  This selects the Atmel Multimedia Card Interface driver. If
> -	  you have an AT32 (AVR32) platform with a Multimedia Card
> -	  slot, say Y or M here.
> +	  you have an AT32 (AVR32) or AT91 platform with a Multimedia
> +	  Card slot, say Y or M here.
>  
>  	  If unsure, say N.
>  
> +endchoice
> +
>  config MMC_ATMELMCI_DMA
>  	bool "Atmel MCI DMA support (EXPERIMENTAL)"
> -	depends on MMC_ATMELMCI && DMA_ENGINE && EXPERIMENTAL
> +	depends on MMC_ATMELMCI && AVR32 && DMA_ENGINE && EXPERIMENTAL
>  	help
>  	  Say Y here to have the Atmel MCI driver use a DMA engine to
>  	  do data transfers and thus increase the throughput and
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 7b603e4..98b25de 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -30,11 +30,14 @@
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

Haavard, is it ok to add those flags on an AVR32 platform for now ?

>  #define ATMCI_DMA_THRESHOLD	16
>  
>  enum {
> @@ -210,6 +213,18 @@ struct atmel_mci_slot {
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
>   * The debugfs stuff below is mostly optimized away when
>   * CONFIG_DEBUG_FS is not set.
>   */
> @@ -276,8 +291,13 @@ static void atmci_show_status_reg(struct seq_file *s,
>  		[3]	= "BLKE",
>  		[4]	= "DTIP",
>  		[5]	= "NOTBUSY",
> +		[6]	= "ENDRX",
> +		[7]	= "ENDTX",
>  		[8]	= "SDIOIRQA",
>  		[9]	= "SDIOIRQB",
> +		[12]	= "SDIOWAIT",
> +		[14]	= "RXBUFF",
> +		[15]	= "TXBUFE",
>  		[16]	= "RINDE",
>  		[17]	= "RDIRE",
>  		[18]	= "RCRCE",
> @@ -285,6 +305,11 @@ static void atmci_show_status_reg(struct seq_file *s,
>  		[20]	= "RTOE",
>  		[21]	= "DCRCE",
>  		[22]	= "DTOE",
> +		[23]    = "CSTOE",
> +		[24]    = "BLKOVRE",
> +		[25]    = "DMADONE",
> +		[26]    = "FIFOEMPTY",
> +		[27]    = "XFRDONE",

Little indentation modifications.

>  		[30]	= "OVRE",
>  		[31]	= "UNRE",
>  	};
> @@ -849,13 +874,15 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
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
> @@ -1648,8 +1675,10 @@ static int __init atmci_probe(struct platform_device *pdev)
>  			nr_slots++;
>  	}
>  
> -	if (!nr_slots)
> +	if (!nr_slots) {
> +		printk(KERN_ERR "Atmel MCI controller init failed.  atmci_init_slot error or no slots with bus_width > 0.\n");

I change this to :
dev_err(&pdev->dev, "init failed: no slot defined\n");

>  		goto err_init_slot;
> +	}
>  
>  	dev_info(&pdev->dev,
>  			"Atmel MCI controller at 0x%08lx irq %d, %u slots\n",

If Haavard is ok, I post the patch to Pierre Ossman with the tiny
modifications above (your SOB & From: preserved of course).

Thanks, Bye,
-- 
Nicolas Ferre

