Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbZLNTAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbZLNTAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZLNTAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:00:34 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:48922 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098AbZLNTAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:00:31 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: GPIO support for HTC Dream
Date: Mon, 14 Dec 2009 14:00:24 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com>
In-Reply-To: <20091214064545.GK5114@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: GPIO support for HTC Dream
Thread-Index: Acp8iRhhJN0f6m+0RU2SyKLnlO3r6wAYq8dg
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com> <20091214064545.GK5114@elf.ucw.cz>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Ryan Mallon" <ryan@bluewatersys.com>,
       "Daniel Walker" <dwalker@codeaurora.org>,
       "Iliyan Malchev" <malchev@google.com>,
       "Brian Swetland" <swetland@google.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 19:00:27.0576 (UTC) FILETIME=[B301FB80:01CA7CEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 13, 2009 11:46 PM, Pavel Machek wrote:

<snip>

> It now looks like this. I still need to test it and clean up
> warnings. (and move those selects)
> 									Pavel
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1c4119c..8bb8546 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -565,6 +565,8 @@ config ARCH_MSM
>  	select CPU_V6
>  	select GENERIC_TIME
>  	select GENERIC_CLOCKEVENTS
> +	select GENERIC_GPIO
> +	select ARCH_REQUIRE_GPIOLIB
>  	help
>  	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
>  	  apps processor of the MSM7K and depends on a shared memory
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 91e6f5c..4c2567e 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -6,4 +6,4 @@ obj-y += clock.o clock-7x01a.o
>  
>  obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o
>  
> -obj-$(CONFIG_MACH_TROUT) += board-dream.o
> +obj-$(CONFIG_MACH_TROUT) += board-dream.o board-dream-gpio.o generic_gpio.o 
> diff --git a/arch/arm/mach-msm/board-dream-gpio.c b/arch/arm/mach-msm/board-dream-gpio.c
> new file mode 100644
> index 0000000..4cf6ec0
> --- /dev/null
> +++ b/arch/arm/mach-msm/board-dream-gpio.c
> @@ -0,0 +1,116 @@
> +/*
> + * linux/arch/arm/mach-msm/gpio.c
> + *
> + * Copyright (C) 2005 HP Labs
> + * Copyright (C) 2008 Google, Inc.
> + * Copyright (C) 2009 Pavel Machek <pavel@ucw.cz>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +
> +#include "board-dream.h"
> +
> +struct msm_gpio_chip {
> +	struct gpio_chip	chip;
> +	void __iomem		*reg;	/* Base of register bank */
> +	u8			shadow;
> +};
> +
> +#define to_msm_gpio_chip(c) container_of(c, struct msm_gpio_chip, chip)
> +
> +static int msm_gpiolib_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct msm_gpio_chip *msm_gpio = to_msm_gpio_chip(chip);
> +	unsigned mask = 1 << offset;
> +
> +	return !! (readb(msm_gpio->reg) & mask);
> +}
> +
> +static void msm_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
> +{
> +	struct msm_gpio_chip *msm_gpio = to_msm_gpio_chip(chip);
> +	unsigned mask = 1 << offset;
> +
> +	if (val)
> +		msm_gpio->shadow |= mask;
> +	else
> +		msm_gpio->shadow &= ~mask;
> +
> +	writeb(msm_gpio->shadow, msm_gpio->reg);
> +}
> +
> +static int msm_gpiolib_direction_input(struct gpio_chip *chip,
> +					unsigned offset)
> +{
> +	msm_gpiolib_set(chip, offset, 0);
> +	return 0;
> +}
> +
> +static int msm_gpiolib_direction_output(struct gpio_chip *chip,
> +					 unsigned offset, int val)
> +{
> +	msm_gpiolib_set(chip, offset, val);
> +	return 0;
> +}
> +
> +int gpio_to_irq(unsigned gpio)
> +{
> +	return -EINVAL;
> +}

This should probably just be an inline function in
arch/arm/mach-msm/include/mach/gpio.h

> +
> +#define DREAM_GPIO_BANK(name, reg_num, base_gpio, shadow_val)		\
> +	{								\
> +		.chip = {						\
> +			.label		  = name,			\
> +			.direction_input  = msm_gpiolib_direction_input, \
> +			.direction_output = msm_gpiolib_direction_output, \
> +			.get		  = msm_gpiolib_get,		\
> +			.set		  = msm_gpiolib_set,		\
> +			.base		  = base_gpio,			\
> +			.ngpio		  = 8,				\
> +		},							\
> +		.reg = reg_num + DREAM_CPLD_BASE,			\
> +		.shadow = shadow_val,					\
> +	}
> +
> +static struct msm_gpio_chip msm_gpio_banks[] = {
> +#if defined(CONFIG_MSM_DEBUG_UART1)
> +        /* H2W pins <-> UART1 */
> +        DREAM_GPIO_BANK("MISC2", 0x00,   DREAM_GPIO_MISC2_BASE, 0x40),
> +#else
> +	/* H2W pins <-> UART3, Bluetooth <-> UART1 */
> +        DREAM_GPIO_BANK("MISC2", 0x00,   DREAM_GPIO_MISC2_BASE, 0x80),
> +#endif
> +	/* I2C pull */
> +        DREAM_GPIO_BANK("MISC3", 0x02,   DREAM_GPIO_MISC3_BASE, 0x04),
> +        DREAM_GPIO_BANK("MISC4", 0x04,   DREAM_GPIO_MISC4_BASE, 0),
> +	/* mmdi 32k en */
> +        DREAM_GPIO_BANK("MISC5", 0x06,   DREAM_GPIO_MISC5_BASE, 0x04),
> +        DREAM_GPIO_BANK("INT2", 0x08,    DREAM_GPIO_INT2_BASE,  0),
> +        DREAM_GPIO_BANK("MISC1", 0x0a,   DREAM_GPIO_MISC1_BASE, 0),
> +        DREAM_GPIO_BANK("VIRTUAL", 0x12, DREAM_GPIO_VIRTUAL_BASE, 0),
> +};
> +
> +/*
> + * Called from the processor-specific init to enable GPIO pin support.
> + */
> +int __init dream_init_gpio(void)
> +{
> +        int i;
> +
> +        for (i = 0; i < ARRAY_SIZE(msm_gpio_banks); i++)
> +                gpiochip_add(&msm_gpio_banks[i].chip);
> +
> +	return 0;
> +}
> +
> +postcore_initcall(dream_init_gpio);
> +
> diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
> index 4f345a5..dbd78b9 100644
> --- a/arch/arm/mach-msm/board-dream.h
> +++ b/arch/arm/mach-msm/board-dream.h
> @@ -1,5 +1,58 @@
>  
> -#define TROUT_CPLD_BASE   0xE8100000
> -#define TROUT_CPLD_START  0x98000000
> -#define TROUT_CPLD_SIZE   SZ_4K
> +#define MSM_SMI_BASE		0x00000000
> +#define MSM_SMI_SIZE		0x00800000
> +
> +#define MSM_EBI_BASE		0x10000000
> +#define MSM_EBI_SIZE		0x06e00000
> +
> +#define MSM_PMEM_GPU0_BASE	0x00000000
> +#define MSM_PMEM_GPU0_SIZE	0x00700000
> +
> +#define MSM_PMEM_MDP_BASE	0x02000000
> +#define MSM_PMEM_MDP_SIZE	0x00800000
> +
> +#define MSM_PMEM_ADSP_BASE      0x02800000
> +#define MSM_PMEM_ADSP_SIZE	0x00800000
> +
> +#define MSM_PMEM_CAMERA_BASE	0x03000000
> +#define MSM_PMEM_CAMERA_SIZE	0x00800000
> +
> +#define MSM_FB_BASE		0x03800000
> +#define MSM_FB_SIZE		0x00100000
> +
> +#define MSM_LINUX_BASE		MSM_EBI_BASE
> +#define MSM_LINUX_SIZE		0x06500000
> +
> +#define MSM_PMEM_GPU1_SIZE	0x800000
> +#define MSM_PMEM_GPU1_BASE	(MSM_RAM_CONSOLE_BASE - MSM_PMEM_GPU1_SIZE)
> +
> +#define MSM_RAM_CONSOLE_BASE	(MSM_EBI_BASE + 0x6d00000)
> +#define MSM_RAM_CONSOLE_SIZE	(128 * SZ_1K)
> +
> +#if (MSM_FB_BASE + MSM_FB_SIZE) >= (MSM_PMEM_GPU1_BASE)
> +#error invalid memory map
> +#endif
> +
> +#define DECLARE_MSM_IOMAP
> +#include <mach/msm_iomap.h>
> +
> +#define DREAM_4_BALL_UP_0     1
> +#define DREAM_4_BALL_LEFT_0   18
> +#define DREAM_4_BALL_DOWN_0   57
> +#define DREAM_4_BALL_RIGHT_0  91
> +
> +#define DREAM_5_BALL_UP_0     94
> +#define DREAM_5_BALL_LEFT_0   18
> +#define DREAM_5_BALL_DOWN_0   90
> +#define DREAM_5_BALL_RIGHT_0  19
> +
> +#define DREAM_POWER_KEY     20
> +
> +#define DREAM_4_TP_LS_EN    19
> +#define DREAM_5_TP_LS_EN    1
> +
> +#define DREAM_CPLD_BASE   0xE8100000
> +#define DREAM_CPLD_START  0x98000000
> +#define DREAM_CPLD_SIZE   SZ_4K
> +

This header might need to be a separate patch.  The only thing in it
related to the rest of this is DREAM_CPLD_BASE.
  
> diff --git a/arch/arm/mach-msm/generic_gpio.c b/arch/arm/mach-msm/generic_gpio.c
> new file mode 100644
> index 0000000..357e63e
> --- /dev/null
> +++ b/arch/arm/mach-msm/generic_gpio.c
> @@ -0,0 +1,15 @@
> +/* arch/arm/mach-msm/generic_gpio.c
> + *
> + * Copyright (C) 2007 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +

Is this header really needed?

> diff --git a/arch/arm/mach-msm/gpio_chip.h b/arch/arm/mach-msm/gpio_chip.h
> new file mode 100644
> index 0000000..ffc4d54
> --- /dev/null
> +++ b/arch/arm/mach-msm/gpio_chip.h
> @@ -0,0 +1,20 @@
> +/* arch/arm/mach-msm/gpio_chip.h
> + *
> + * Copyright (C) 2007 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _LINUX_GPIO_CHIP_H
> +#define _LINUX_GPIO_CHIP_H
> +
> +
> +#endif

Same with this one?

> diff --git a/arch/arm/mach-msm/include/mach/gpio.h b/arch/arm/mach-msm/include/mach/gpio.h
> new file mode 100644
> index 0000000..e92bc31
> --- /dev/null
> +++ b/arch/arm/mach-msm/include/mach/gpio.h
> @@ -0,0 +1,105 @@
> +/*
> + * Copyright (C) 2007 Google, Inc.
> + * Author: Mike Lockwood <lockwood@android.com>
> + * Copyright (C) 2009 Pavel Machek <pavel@ucw.cz>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __ASM_ARCH_MSM_GPIO_H
> +#define __ASM_ARCH_MSM_GPIO_H
> +
> +extern int gpio_to_irq(unsigned gpio);

This should probably be an inline as mentioned above.

For completeness you should probably also add:

static inline int irq_to_gpio(unsigned irq)
{
	return -EINVAL;
}

And, nitpick, move both of them after the gpio_cansleep below.

> +
> +#include <asm-generic/gpio.h>
> +
> +#define gpio_get_value __gpio_get_value
> +#define gpio_set_value __gpio_set_value
> +#define gpio_cansleep __gpio_cansleep
> +
> +#define DREAM_GPIO_CABLE_IN1		(83)
> +#define DREAM_GPIO_CABLE_IN2		(49)
> +
> +#define DREAM_GPIO_START (128)

Nitpick.  Tab align these three with the ones below.

> +
> +#define DREAM_GPIO_INT_MASK0_REG            (0x0c)
> +#define DREAM_GPIO_INT_STAT0_REG            (0x0e)
> +#define DREAM_GPIO_INT_MASK1_REG            (0x14)
> +#define DREAM_GPIO_INT_STAT1_REG            (0x10)
> +
> +#define DREAM_GPIO_HAPTIC_PWM               (28)
> +#define DREAM_GPIO_PS_HOLD                  (25)
> +
> +#define DREAM_GPIO_MISC2_BASE               (DREAM_GPIO_START + 0x00)
> +#define DREAM_GPIO_MISC3_BASE               (DREAM_GPIO_START + 0x08)
> +#define DREAM_GPIO_MISC4_BASE               (DREAM_GPIO_START + 0x10)
> +#define DREAM_GPIO_MISC5_BASE               (DREAM_GPIO_START + 0x18)
> +#define DREAM_GPIO_INT2_BASE                (DREAM_GPIO_START + 0x20)
> +#define DREAM_GPIO_MISC1_BASE               (DREAM_GPIO_START + 0x28)
> +#define DREAM_GPIO_VIRTUAL_BASE             (DREAM_GPIO_START + 0x30)
> +#define DREAM_GPIO_INT5_BASE                (DREAM_GPIO_START + 0x48)
> +
> +#define DREAM_GPIO_CHARGER_EN               (DREAM_GPIO_MISC2_BASE + 0)
> +#define DREAM_GPIO_ISET                     (DREAM_GPIO_MISC2_BASE + 1)
> +#define DREAM_GPIO_H2W_DAT_DIR              (DREAM_GPIO_MISC2_BASE + 2)
> +#define DREAM_GPIO_H2W_CLK_DIR              (DREAM_GPIO_MISC2_BASE + 3)
> +#define DREAM_GPIO_H2W_DAT_GPO              (DREAM_GPIO_MISC2_BASE + 4)
> +#define DREAM_GPIO_H2W_CLK_GPO              (DREAM_GPIO_MISC2_BASE + 5)
> +#define DREAM_GPIO_H2W_SEL0                 (DREAM_GPIO_MISC2_BASE + 6)
> +#define DREAM_GPIO_H2W_SEL1                 (DREAM_GPIO_MISC2_BASE + 7)
> +
> +#define DREAM_GPIO_SPOTLIGHT_EN             (DREAM_GPIO_MISC3_BASE + 0)
> +#define DREAM_GPIO_FLASH_EN                 (DREAM_GPIO_MISC3_BASE + 1)
> +#define DREAM_GPIO_I2C_PULL                 (DREAM_GPIO_MISC3_BASE + 2)
> +#define DREAM_GPIO_TP_I2C_PULL              (DREAM_GPIO_MISC3_BASE + 3)
> +#define DREAM_GPIO_TP_EN                    (DREAM_GPIO_MISC3_BASE + 4)
> +#define DREAM_GPIO_JOG_EN                   (DREAM_GPIO_MISC3_BASE + 5)
> +#define DREAM_GPIO_UI_LED_EN                (DREAM_GPIO_MISC3_BASE + 6)
> +#define DREAM_GPIO_QTKEY_LED_EN             (DREAM_GPIO_MISC3_BASE + 7)
> +
> +#define DREAM_GPIO_VCM_PWDN                 (DREAM_GPIO_MISC4_BASE + 0)
> +#define DREAM_GPIO_USB_H2W_SW               (DREAM_GPIO_MISC4_BASE + 1)
> +#define DREAM_GPIO_COMPASS_RST_N            (DREAM_GPIO_MISC4_BASE + 2)
> +#define DREAM_GPIO_HAPTIC_EN_UP             (DREAM_GPIO_MISC4_BASE + 3)
> +#define DREAM_GPIO_HAPTIC_EN_MAIN           (DREAM_GPIO_MISC4_BASE + 4)
> +#define DREAM_GPIO_USB_PHY_RST_N            (DREAM_GPIO_MISC4_BASE + 5)
> +#define DREAM_GPIO_WIFI_PA_RESETX           (DREAM_GPIO_MISC4_BASE + 6)
> +#define DREAM_GPIO_WIFI_EN                  (DREAM_GPIO_MISC4_BASE + 7)
> +
> +#define DREAM_GPIO_BT_32K_EN                (DREAM_GPIO_MISC5_BASE + 0)
> +#define DREAM_GPIO_MAC_32K_EN               (DREAM_GPIO_MISC5_BASE + 1)
> +#define DREAM_GPIO_MDDI_32K_EN              (DREAM_GPIO_MISC5_BASE + 2)
> +#define DREAM_GPIO_COMPASS_32K_EN           (DREAM_GPIO_MISC5_BASE + 3)
> +
> +#define DREAM_GPIO_NAVI_ACT_N               (DREAM_GPIO_INT2_BASE + 0)
> +#define DREAM_GPIO_COMPASS_IRQ              (DREAM_GPIO_INT2_BASE + 1)
> +#define DREAM_GPIO_SLIDING_DET              (DREAM_GPIO_INT2_BASE + 2)
> +#define DREAM_GPIO_AUD_HSMIC_DET_N          (DREAM_GPIO_INT2_BASE + 3)
> +#define DREAM_GPIO_SD_DOOR_N                (DREAM_GPIO_INT2_BASE + 4)
> +#define DREAM_GPIO_CAM_BTN_STEP1_N          (DREAM_GPIO_INT2_BASE + 5)
> +#define DREAM_GPIO_CAM_BTN_STEP2_N          (DREAM_GPIO_INT2_BASE + 6)
> +#define DREAM_GPIO_TP_ATT_N                 (DREAM_GPIO_INT2_BASE + 7)
> +#define DREAM_GPIO_BANK0_FIRST_INT_SOURCE   (DREAM_GPIO_NAVI_ACT_N)
> +#define DREAM_GPIO_BANK0_LAST_INT_SOURCE    (DREAM_GPIO_TP_ATT_N)
> +
> +#define DREAM_GPIO_H2W_DAT_GPI              (DREAM_GPIO_MISC1_BASE + 0)
> +#define DREAM_GPIO_H2W_CLK_GPI              (DREAM_GPIO_MISC1_BASE + 1)
> +#define DREAM_GPIO_CPLD128_VER_0            (DREAM_GPIO_MISC1_BASE + 4)
> +#define DREAM_GPIO_CPLD128_VER_1            (DREAM_GPIO_MISC1_BASE + 5)
> +#define DREAM_GPIO_CPLD128_VER_2            (DREAM_GPIO_MISC1_BASE + 6)
> +#define DREAM_GPIO_CPLD128_VER_3            (DREAM_GPIO_MISC1_BASE + 7)
> +
> +#define DREAM_GPIO_SDMC_CD_N                (DREAM_GPIO_VIRTUAL_BASE + 0)
> +#define DREAM_GPIO_END                      (DREAM_GPIO_SDMC_CD_N)
> +#define DREAM_GPIO_BANK1_FIRST_INT_SOURCE   (DREAM_GPIO_SDMC_CD_N)
> +#define DREAM_GPIO_BANK1_LAST_INT_SOURCE    (DREAM_GPIO_SDMC_CD_N)
> +
> +#endif

Otherwise, looks good to me.  Just test it to make sure it works :-).

Since I have no way of compiling or testing this...

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Regards,
Hartley
