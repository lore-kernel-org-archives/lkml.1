Return-Path: <linux-kernel-owner+w=401wt.eu-S2992753AbXDDSkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992753AbXDDSkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbXDDSkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:40:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20927 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993023AbXDDSkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:40:04 -0400
Date: Wed, 4 Apr 2007 11:41:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 12/90] ARM: OMAP: Fix apollon boot
Message-Id: <20070404114147.29bd3872.randy.dunlap@oracle.com>
In-Reply-To: <1175709988265-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757099743984-git-send-email-tony@atomide.com>
	<1175709977545-git-send-email-tony@atomide.com>
	<1175709988265-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:04:51 -0400 Tony Lindgren wrote:

> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> In previous GPMC patch, there was a typo. Fix typo and add header files for
> set_irq_type() warnings.

It looks like there's more to this patch than in the description above...


> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/board-apollon.c |   99 +++++++++++++++++++++++++++++++---
>  1 files changed, 90 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
> index 878ff91..3bb49c1 100644
> --- a/arch/arm/mach-omap2/board-apollon.c
> +++ b/arch/arm/mach-omap2/board-apollon.c
> @@ -25,6 +25,8 @@
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> +#include <linux/leds.h>
> +#include <linux/irq.h>
>  
>  #include <asm/hardware.h>
>  #include <asm/mach-types.h>
> @@ -32,10 +34,12 @@
>  #include <asm/mach/flash.h>
>  
>  #include <asm/arch/gpio.h>
> +#include <asm/arch/led.h>
>  #include <asm/arch/mux.h>
>  #include <asm/arch/usb.h>
>  #include <asm/arch/board.h>
>  #include <asm/arch/common.h>
> +#include <asm/arch/gpmc.h>
>  #include "prcm-regs.h"
>  
>  /* LED & Switch macros */
> @@ -46,6 +50,9 @@
>  #define SW_UP_GPIO17		17
>  #define SW_DOWN_GPIO58		58
>  
> +#define APOLLON_FLASH_CS	0
> +#define APOLLON_ETH_CS		1
> +
>  static struct mtd_partition apollon_partitions[] = {
>  	{
>  		.name		= "X-Loader + U-Boot",
> @@ -85,10 +92,10 @@ static struct flash_platform_data apollon_flash_data = {
>  	.nr_parts	= ARRAY_SIZE(apollon_partitions),
>  };
>  
> -static struct resource apollon_flash_resource = {
> -	.start		= APOLLON_CS0_BASE,
> -	.end		= APOLLON_CS0_BASE + SZ_128K,
> -	.flags		= IORESOURCE_MEM,
> +static struct resource apollon_flash_resource[] = {
> +	[0] = {
> +		.flags		= IORESOURCE_MEM,
> +	},
>  };
>  
>  static struct platform_device apollon_onenand_device = {
> @@ -97,14 +104,24 @@ static struct platform_device apollon_onenand_device = {
>  	.dev		= {
>  		.platform_data	= &apollon_flash_data,
>  	},
> -	.num_resources	= ARRAY_SIZE(&apollon_flash_resource),
> -	.resource	= &apollon_flash_resource,
> +	.num_resources	= ARRAY_SIZE(apollon_flash_resource),
> +	.resource	= apollon_flash_resource,
>  };
>  
> +static void __init apollon_flash_init(void)
> +{
> +	unsigned long base;
> +
> +	if (gpmc_cs_request(APOLLON_FLASH_CS, SZ_128K, &base) < 0) {
> +		printk(KERN_ERR "Cannot request OneNAND GPMC CS\n");
> +		return;
> +	}
> +	apollon_flash_resource[0].start = base;
> +	apollon_flash_resource[0].end   = base + SZ_128K - 1;
> +}
> +
>  static struct resource apollon_smc91x_resources[] = {
>  	[0] = {
> -		.start	= APOLLON_ETHR_START,		/* Physical */
> -		.end	= APOLLON_ETHR_START + 0xf,
>  		.flags  = IORESOURCE_MEM,
>  	},
>  	[1] = {
> @@ -126,14 +143,51 @@ static struct platform_device apollon_lcd_device = {
>  	.id		= -1,
>  };
>  
> +static struct omap_led_config apollon_led_config[] = {
> +	{
> +		.cdev	= {
> +			.name	= "apollon:led0",
> +		},
> +		.gpio	= LED0_GPIO13,
> +	},
> +	{
> +		.cdev	= {
> +			.name	= "apollon:led1",
> +		},
> +		.gpio	= LED1_GPIO14,
> +	},
> +	{
> +		.cdev	= {
> +			.name	= "apollon:led2",
> +		},
> +		.gpio	= LED2_GPIO15,
> +	},
> +};
> +
> +static struct omap_led_platform_data apollon_led_data = {
> +	.nr_leds	= ARRAY_SIZE(apollon_led_config),
> +	.leds		= apollon_led_config,
> +};
> +
> +static struct platform_device apollon_led_device = {
> +	.name		= "omap-led",
> +	.id		= -1,
> +	.dev		= {
> +		.platform_data	= &apollon_led_data,
> +	},
> +};
> +
>  static struct platform_device *apollon_devices[] __initdata = {
>  	&apollon_onenand_device,
>  	&apollon_smc91x_device,
>  	&apollon_lcd_device,
> +	&apollon_led_device,
>  };
>  
>  static inline void __init apollon_init_smc91x(void)
>  {
> +	unsigned long base;
> +
>  	/* Make sure CS1 timings are correct */
>  	GPMC_CONFIG1_1 = 0x00011203;
>  	GPMC_CONFIG2_1 = 0x001f1f01;
> @@ -141,13 +195,20 @@ static inline void __init apollon_init_smc91x(void)
>  	GPMC_CONFIG4_1 = 0x1c091c09;
>  	GPMC_CONFIG5_1 = 0x041f1f1f;
>  	GPMC_CONFIG6_1 = 0x000004c4;
> -	GPMC_CONFIG7_1 = 0x00000f40 | (APOLLON_CS1_BASE >> 24);
> +
> +	if (gpmc_cs_request(APOLLON_ETH_CS, SZ_16M, &base) < 0) {
> +		printk(KERN_ERR "Failed to request GPMC CS for smc91x\n");
> +		return;
> +	}
> +	apollon_smc91x_resources[0].start = base + 0x300;
> +	apollon_smc91x_resources[0].end   = base + 0x30f;
>  	udelay(100);
>  
>  	omap_cfg_reg(W4__24XX_GPIO74);
>  	if (omap_request_gpio(APOLLON_ETHR_GPIO_IRQ) < 0) {
>  		printk(KERN_ERR "Failed to request GPIO%d for smc91x IRQ\n",
>  			APOLLON_ETHR_GPIO_IRQ);
> +		gpmc_cs_free(APOLLON_ETH_CS);
>  		return;
>  	}
>  	omap_set_gpio_direction(APOLLON_ETHR_GPIO_IRQ, 1);
> @@ -175,6 +236,13 @@ static struct omap_mmc_config apollon_mmc_config __initdata = {
>  	},
>  };
>  
> +static struct omap_usb_config apollon_usb_config __initdata = {
> +	.register_dev	= 1,
> +	.hmc_mode	= 0x14,	/* 0:dev 1:host1 2:disable */
> +
> +	.pins[0]	= 6,
> +};
> +
>  static struct omap_lcd_config apollon_lcd_config __initdata = {
>  	.ctrl_name	= "internal",
>  };
> @@ -182,6 +250,7 @@ static struct omap_lcd_config apollon_lcd_config __initdata = {
>  static struct omap_board_config_kernel apollon_config[] = {
>  	{ OMAP_TAG_UART,	&apollon_uart_config },
>  	{ OMAP_TAG_MMC,		&apollon_mmc_config },
> +	{ OMAP_TAG_USB,		&apollon_usb_config },
>  	{ OMAP_TAG_LCD,		&apollon_lcd_config },
>  };
>  
> @@ -250,10 +319,22 @@ static void __init apollon_sw_init(void)
>  		return;
>  }
>  
> +static void __init apollon_usb_init(void)
> +{
> +	/* USB device */
> +	/* DEVICE_SUSPEND */
> +	omap_cfg_reg(P21_242X_GPIO12);
> +	omap_request_gpio(12);
> +	omap_set_gpio_direction(12, 0);		/* OUT */
> +	omap_set_gpio_dataout(12, 0);
> +}
> +
>  static void __init omap_apollon_init(void)
>  {
>  	apollon_led_init();
>  	apollon_sw_init();
> +	apollon_flash_init();
> +	apollon_usb_init();
>  
>  	/* REVISIT: where's the correct place */
>  	omap_cfg_reg(W19_24XX_SYS_NIRQ);
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
