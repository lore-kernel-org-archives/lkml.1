Return-Path: <linux-kernel-owner+w=401wt.eu-S1763737AbZFQK2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763737AbZFQK2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbZFQK1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:27:53 -0400
Received: from mail.atmel.fr ([81.80.104.162]:42225 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZFQK1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:27:52 -0400
Message-ID: <4A38C51B.1070209@atmel.com>
Date: Wed, 17 Jun 2009 12:27:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <rob@emanuele.us>, Andrew Victor <avictor.za@gmail.com>
CC: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] atmel-mci: Platform configuration to the the atmel-mci
 driver
References: <1245200079-6323-1-git-send-email-rob@emanuele.us> <1245200079-6323-2-git-send-email-rob@emanuele.us>
In-Reply-To: <1245200079-6323-2-git-send-email-rob@emanuele.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele :
> Created a modified version of the at91sam9g20 evaluation kit platform (board-sam9g20ek-2slot-mmc.c) and device support to make use of the updated atmel-mci driver.
> 
> This patch shows how an AT91 developer could add support for both SD slots for their project.

Comment formated.

> This requires getting the most updated arch/arm/tools/mach-types from http://www.arm.linux.org.uk/developer/machines/download.php to have the machine type for the modified at91sam9g20ek.

Ok moved below "---"

> Signed-off-by: Rob Emanuele <rob@emanuele.us>
> ---
>  arch/arm/mach-at91/Kconfig                     |    7 +
>  arch/arm/mach-at91/Makefile                    |    1 +
>  arch/arm/mach-at91/at91sam9260_devices.c       |   95 ++++++++
>  arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |  277 ++++++++++++++++++++++++
>  arch/arm/mach-at91/include/mach/board.h        |    5 +
>  5 files changed, 385 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 323b47f..5c8d770 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -276,6 +276,13 @@ config MACH_AT91SAM9G20EK
>  	help
>  	  Select this if you are using Atmel's AT91SAM9G20-EK Evaluation Kit.
>  
> +config MACH_AT91SAM9G20EK_2MMC
> +	bool "Atmel AT91SAM9G20-EK Evaluation Kit modified for 2 MMC Slots"
> +	depends on ARCH_AT91SAM9G20
> +	help
> +	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
> +	  Rev A or B modified for 2 MMC Slots.
> +
>  endif
>  
>  # ----------------------------------------------------------
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index c69ff23..cdddba8 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -54,6 +54,7 @@ obj-$(CONFIG_MACH_AT91SAM9RLEK)	+= board-sam9rlek.o
>  
>  # AT91SAM9G20 board-specific support
>  obj-$(CONFIG_MACH_AT91SAM9G20EK) += board-sam9g20ek.o
> +obj-$(CONFIG_MACH_AT91SAM9G20EK_2MMC) += board-sam9g20ek-2slot-mmc.o
>  
>  # AT91CAP9 board-specific support
>  obj-$(CONFIG_MACH_AT91CAP9ADK)	+= board-cap9adk.o
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index d74c9ac..c372f4f 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -278,6 +278,101 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data)
>  void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
>  #endif
>  
> +/* --------------------------------------------------------------------
> + *  MMC / SD Slot for Atmel MCI Driver
> + * -------------------------------------------------------------------- */
> +
> +#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
> +static u64 mmc_dmamask = DMA_BIT_MASK(32);
> +static struct mci_platform_data mmc_data;
> +
> +static struct resource mmc_resources[] = {
> +	[0] = {
> +		.start	= AT91SAM9260_BASE_MCI,
> +		.end	= AT91SAM9260_BASE_MCI + SZ_16K - 1,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start	= AT91SAM9260_ID_MCI,
> +		.end	= AT91SAM9260_ID_MCI,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device at91sam9260_mmc_device = {
> +	.name		= "atmel_mci",
> +	.id		= -1,
> +	.dev		= {
> +				.dma_mask		= &mmc_dmamask,
> +				.coherent_dma_mask	= DMA_BIT_MASK(32),
> +				.platform_data		= &mmc_data,
> +	},
> +	.resource	= mmc_resources,
> +	.num_resources	= ARRAY_SIZE(mmc_resources),
> +};
> +
> +void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data)
> +{
> +	unsigned int i;
> +	unsigned int slot_count = 0;
> +
> +	if (!data)
> +		return;
> +
> +	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +	   if (data->slot[i].bus_width) {

Indentation.

> +			/* input/irq */
> +			if (data->slot[i].detect_pin) {
> +				at91_set_gpio_input(data->slot[i].detect_pin, 1);
> +				at91_set_deglitch(data->slot[i].detect_pin, 1);
> +			}
> +			if (data->slot[i].wp_pin)
> +				at91_set_gpio_input(data->slot[i].wp_pin, 1);
> +
> +			switch(i) {
> +			case 0:
> +				/* CMD */
> +				at91_set_A_periph(AT91_PIN_PA7, 1);
> +				/* DAT0, maybe DAT1..DAT3 */
> +				at91_set_A_periph(AT91_PIN_PA6, 1);
> +				if (data->slot[i].bus_width == 4) {
> +					at91_set_A_periph(AT91_PIN_PA9, 1);
> +					at91_set_A_periph(AT91_PIN_PA10, 1);
> +					at91_set_A_periph(AT91_PIN_PA11, 1);
> +				}

I put slot_count here...
+			slot_count++;

> +				break;
> +			case 1:
> +				/* CMD */
> +				at91_set_B_periph(AT91_PIN_PA1, 1);
> +				/* DAT0, maybe DAT1..DAT3 */
> +				at91_set_B_periph(AT91_PIN_PA0, 1);
> +				if (data->slot[i].bus_width == 4) {
> +					at91_set_B_periph(AT91_PIN_PA5, 1);
> +					at91_set_B_periph(AT91_PIN_PA4, 1);
> +					at91_set_B_periph(AT91_PIN_PA3, 1);
> +				}

and here...
+			slot_count++;

> +				break;
> +			default:
> +				printk("Configuration Error, No MMC Port %d\n",i);

Replaced with:
                      printk(KERN_ERR
                            "AT91: SD/MMC slot %d not available\n", i);


> +				break;
> +			};

removed here.

> +			slot_count++;
> +		}
> +	}
> +
> +	if (slot_count) {
> +		/* CLK */
> +		at91_set_A_periph(AT91_PIN_PA8, 0);
> +
> +		mmc_data = *data;
> +		platform_device_register(&at91sam9260_mmc_device);
> +	}
> +}
> +#else
> +void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data) {}
> +#endif
> +
> +
>  
>  /* --------------------------------------------------------------------
>   *  NAND / SmartMedia
> diff --git a/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c b/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
> new file mode 100644
> index 0000000..a28e53f
> --- /dev/null
> +++ b/arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c

Ok. True that it duplicates code but it is simpler.
It also can be a testbed for future -EK revision D and following.

[..]


> diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
> index e6afff8..a635dad 100644
> --- a/arch/arm/mach-at91/include/mach/board.h
> +++ b/arch/arm/mach-at91/include/mach/board.h
> @@ -37,6 +37,7 @@
>  #include <linux/leds.h>
>  #include <linux/spi/spi.h>
>  #include <linux/usb/atmel_usba_udc.h>
> +#include <linux/atmel-mci.h>
>  
>   /* USB Device */
>  struct at91_udc_data {
> @@ -63,6 +64,7 @@ struct at91_cf_data {
>  extern void __init at91_add_device_cf(struct at91_cf_data *data);
>  
>   /* MMC / SD */
> +  /* at91_mci platform config */
>  struct at91_mmc_data {
>  	u8		det_pin;	/* card detect IRQ */
>  	unsigned	slot_b:1;	/* uses Slot B */
> @@ -72,6 +74,9 @@ struct at91_mmc_data {
>  };
>  extern void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data);
>  
> +  /* atmel-mci platform config */
> +extern void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data);
> +
>   /* Ethernet (EMAC & MACB) */
>  struct at91_eth_data {
>  	u32		phy_mask;

Ok.


I post the patch to Andrew Victor with the tiny
modifications above (your SOB & From: preserved of course).

Thanks, Bye,

-- 
Nicolas Ferre

