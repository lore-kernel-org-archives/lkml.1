Return-Path: <linux-kernel-owner+w=401wt.eu-S1764294AbZFOQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764294AbZFOQAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764055AbZFOQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:00:14 -0400
Received: from mail.atmel.fr ([81.80.104.162]:56524 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764085AbZFOQAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:00:10 -0400
Message-ID: <4A366FFA.80700@atmel.com>
Date: Mon, 15 Jun 2009 17:59:54 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Subject: Re: [PATCH 2/6] Unified AVR32/AT91 MCI Platform Driver
References: <c8284b5b0906121759o4057deb6kf59f818fa759ce57@mail.gmail.com>
In-Reply-To: <c8284b5b0906121759o4057deb6kf59f818fa759ce57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I continue my comments.

Rob Emanuele :
> Updated the at91sam9g20 evaluation kit and device support to make use
> of the updated atmel-mci driver.
> 
> This patch shows how an AT91 developer could add support for both SD
> slots on their processors.
> 
> Please read the whole set, try it out, and comment.
> 
> Thank you,
> 
> Rob Emanuele
> 
> ---
>  arch/arm/mach-at91/Kconfig               |    6 ++
>  arch/arm/mach-at91/at91sam9260_devices.c |   95 ++++++++++++++++++++++++++++++
>  arch/arm/mach-at91/board-sam9g20ek.c     |   37 +++++++++++-
>  arch/arm/mach-at91/include/mach/board.h  |    7 ++
>  4 files changed, 144 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 323b47f..7f6c96a 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -326,6 +326,12 @@ config MTD_NAND_ATMEL_BUSWIDTH_16
>  	  On AT91SAM926x boards both types of NAND flash can be present
>  	  (8 and 16 bit data bus width).
> 
> +config AT91_2MMC
> +	bool "Use both MMC Ports"
> +	depends on MACH_AT91SAM9G20EK
> +	help
> +	  Select this if you have connected both MMC Slots.  Answer No if unsure.
> +

Well I do not like this configuration addition. If it is created 
to differencing your custom board with the -EK, we will have to 
consider something else.

>  # ----------------------------------------------------------
> 
>  comment "AT91 Feature Selections"
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c
> b/arch/arm/mach-at91/at91sam9260_devices.c
> index d74c9ac..e7cc46a 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -2,6 +2,7 @@
>   * arch/arm/mach-at91/at91sam9260_devices.c
>   *
>   *  Copyright (C) 2006 Atmel
> + *  Copyright (C) 2009 Rob Emanuele

In my opinion, no copyright addition.

>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -275,8 +276,102 @@ void __init at91_add_device_mmc(short mmc_id,
> struct at91_mmc_data *data)
>  	platform_device_register(&at91sam9260_mmc_device);
>  }
>  #else
> +
> +/* --------------------------------------------------------------------
> + *  MMC / SD Slot for Unified Atmel Driver
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
> +void __init at91_add_device_mmc(short mmc_id, struct mci_platform_data *data)
> +{
> +        unsigned int i;
> +        unsigned int slot_count = 0;
> +
> +	if (!data)
> +		return;
> +
> +        for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +                if (data->slot[i].bus_width) {
> +                        /* input/irq */
> +                        if (data->slot[i].detect_pin) {
> +
> at91_set_gpio_input(data->slot[i].detect_pin, 1);
> +                                at91_set_deglitch(data->slot[i].detect_pin, 1);
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
> +				break;
> +			default:
> +				printk("Configuration Error, No MMC Port %d\n",i);
> +				break;
> +			};
> +			slot_count++;
> +                }
> +        }
> +
> +        if (slot_count) {
> +                /* CLK */
> +                at91_set_A_periph(AT91_PIN_PA8, 0);
> +
> +                mmc_data = *data;
> +                platform_device_register(&at91sam9260_mmc_device);
> +        }
> +}
> +#else
>  void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
>  #endif
> +#endif
> +
> 
> 
>  /* --------------------------------------------------------------------
> diff --git a/arch/arm/mach-at91/board-sam9g20ek.c
> b/arch/arm/mach-at91/board-sam9g20ek.c
> index 438efbb..ca70042 100644
> --- a/arch/arm/mach-at91/board-sam9g20ek.c
> +++ b/arch/arm/mach-at91/board-sam9g20ek.c
> @@ -1,6 +1,7 @@
>  /*
>   *  Copyright (C) 2005 SAN People
>   *  Copyright (C) 2008 Atmel
> + *  Copyright (C) 2009 Rob Emanuele

Ditto.

>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -89,7 +90,7 @@ static struct at91_udc_data __initdata ek_udc_data = {
>   * SPI devices.
>   */
>  static struct spi_board_info ek_spi_devices[] = {
> -#if !defined(CONFIG_MMC_AT91)
> +#if !defined(CONFIG_MMC_AT91) && !defined(CONFIG_MMC_ATMELMCI)
>  	{	/* DataFlash chip */
>  		.modalias	= "mtd_dataflash",
>  		.chip_select	= 1,
> @@ -112,7 +113,11 @@ static struct spi_board_info ek_spi_devices[] = {
>   * MACB Ethernet device
>   */
>  static struct at91_eth_data __initdata ek_macb_data = {
> +#if defined(CONFIG_AT91_2MMC)
> +	.phy_irq_pin	= AT91_PIN_PC12,
> +#else
>  	.phy_irq_pin	= AT91_PIN_PA7,
> +#endif

Configuration option has nothing to do with Ethernet... You should 
create your own board configuration.

>  	.is_rmii	= 1,
>  };
> 
> @@ -195,11 +200,33 @@ static void __init ek_add_device_nand(void)
>   * MCI (SD/MMC)
>   * det_pin, wp_pin and vcc_pin are not connected
>   */
> +#if defined(CONFIG_MMC_AT91) || defined(CONFIG_MMC_AT91_MODULE)
>  static struct at91_mmc_data __initdata ek_mmc_data = {
>  	.slot_b		= 1,
>  	.wire4		= 1,
>  };
> +#elif defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
> +static struct mci_platform_data __initdata ek_mmc_data = {
> +	.slot[0] = {
> +#if defined(CONFIG_AT91_2MMC)
> +		.bus_width	= 4,
> +#else
> +		.bus_width	= 0,
> +#endif
> +		.detect_pin	= -ENODEV,
> +		.wp_pin		= -ENODEV,
> +	},
> +	.slot[1] = {
> +		.bus_width	= 4,
> +		.detect_pin	= -ENODEV,
> +		.wp_pin		= -ENODEV,
> +	},
> 
> +};
> +#else
> +static struct amci_platform_data __initdata ek_mmc_data = {
> +};
> +#endif
>  /*
>   * LEDs
> @@ -207,13 +234,21 @@ static struct at91_mmc_data __initdata ek_mmc_data = {
>  static struct gpio_led ek_leds[] = {
>  	{	/* "bottom" led, green, userled1 to be defined */
>  		.name			= "ds5",
> +#if defined(CONFIG_AT91_2MMC)
> +		.gpio			= AT91_PIN_PB12,
> +#else
>  		.gpio			= AT91_PIN_PA6,
> +#endif

Ditto.

>  		.active_low		= 1,
>  		.default_trigger	= "none",
>  	},
>  	{	/* "power" led, yellow */
>  		.name			= "ds1",
> +#if defined(CONFIG_AT91_2MMC)
> +		.gpio			= AT91_PIN_PB13,
> +#else
>  		.gpio			= AT91_PIN_PA9,
> +#endif
>  		.default_trigger	= "heartbeat",
>  	}
>  };
> diff --git a/arch/arm/mach-at91/include/mach/board.h
> b/arch/arm/mach-at91/include/mach/board.h
> index e6afff8..8aa310a 100644
> --- a/arch/arm/mach-at91/include/mach/board.h
> +++ b/arch/arm/mach-at91/include/mach/board.h
> @@ -37,6 +37,9 @@
>  #include <linux/leds.h>
>  #include <linux/spi/spi.h>
>  #include <linux/usb/atmel_usba_udc.h>
> +#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
> +#include <linux/atmel-mci.h>
> +#endif

Not needed.

> 
>   /* USB Device */
>  struct at91_udc_data {
> @@ -63,6 +66,7 @@ struct at91_cf_data {
>  extern void __init at91_add_device_cf(struct at91_cf_data *data);
> 
>   /* MMC / SD */
> +#if defined(CONFIG_MMC_AT91) || defined(CONFIG_MMC_AT91_MODULE)
>  struct at91_mmc_data {
>  	u8		det_pin;	/* card detect IRQ */
>  	unsigned	slot_b:1;	/* uses Slot B */
> @@ -71,6 +75,9 @@ struct at91_mmc_data {
>  	u8		vcc_pin;	/* power switching (high == on) */
>  };
>  extern void __init at91_add_device_mmc(short mmc_id, struct
> at91_mmc_data *data);
> +#else
> +extern void __init at91_add_device_mmc(short mmc_id, struct
> mci_platform_data *data);
> +#endif

Maybe we can be much simpler adding another function for atmel-mci 
initialization: I propose at91_add_device_mci()


diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 13640b0..7c9a703 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -37,6 +37,7 @@
 #include <linux/leds.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
+#include <linux/atmel-mci.h>
 
  /* USB Device */
 struct at91_udc_data {
@@ -71,6 +72,7 @@ struct at91_mmc_data {
 	u8		vcc_pin;	/* power switching (high == on) */
 };
 extern void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data);
+extern void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data);
 
  /* Ethernet (EMAC & MACB) */
 struct at91_eth_data {


Bye,
-- 
Nicolas Ferre

