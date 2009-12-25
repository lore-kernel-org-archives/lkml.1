Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZLYRKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZLYRKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 12:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZLYRKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 12:10:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57829 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbZLYRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 12:10:44 -0500
Date: Fri, 25 Dec 2009 18:10:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch] GPIO support for HTC Dream
Message-ID: <20091225171031.GD1581@ucw.cz>
References: <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com> <20091214064545.GK5114@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com> <20091215194725.GH24406@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE19090200EBE8@mi8nycmail19.Mi8.com> <20091215211634.GP24406@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215211634.GP24406@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Daniel, can we get it merged? It is perfect(TM) :-).
							Pavel

On Tue 2009-12-15 22:16:35, Pavel Machek wrote:
> 
> Add GPIO support for HTC Dream.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> This should be very correct, including some nitpicking.
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index f780086..fab64f1 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -36,6 +36,8 @@ config MACH_HALIBUT
>  
>  config MACH_TROUT
>  	default y
> +	select GENERIC_GPIO
> +	select ARCH_REQUIRE_GPIOLIB
>  	bool "HTC Dream (aka trout)"
>  	help
>  	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 91e6f5c..595881d 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -6,4 +6,4 @@ obj-y += clock.o clock-7x01a.o
>  
>  obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o
>  
> -obj-$(CONFIG_MACH_TROUT) += board-dream.o
> +obj-$(CONFIG_MACH_TROUT) += board-dream.o board-dream-gpio.o
> diff --git a/arch/arm/mach-msm/board-dream-gpio.c b/arch/arm/mach-msm/board-dream-gpio.c
> new file mode 100644
> index 0000000..f5ea3af
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
> +
> +#define DREAM_GPIO_BANK(name, reg_num, base_gpio, shadow_val)		\
> +	{								\
> +		.chip = {						\
> +			.label		  = name,			\
> +			.direction_input  = msm_gpiolib_direction_input,\
> +			.direction_output = msm_gpiolib_direction_output, \
> +			.get		  = msm_gpiolib_get,		\
> +			.set		  = msm_gpiolib_set,		\
> +			.base		  = base_gpio,			\
> +			.ngpio		  = 8,				\
> +		},							\
> +		.reg = (void *) reg_num + DREAM_CPLD_BASE,		\
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
> diff --git a/arch/arm/mach-msm/include/mach/gpio.h b/arch/arm/mach-msm/include/mach/gpio.h
> new file mode 100644
> index 0000000..6c07b85
> --- /dev/null
> +++ b/arch/arm/mach-msm/include/mach/gpio.h
> @@ -0,0 +1,106 @@
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
> +#include <asm-generic/gpio.h>
> +
> +#define gpio_get_value __gpio_get_value
> +#define gpio_set_value __gpio_set_value
> +#define gpio_cansleep __gpio_cansleep
> +
> +extern int gpio_to_irq(unsigned gpio);
> +
> +
> +#define DREAM_GPIO_CABLE_IN1		    (83)
> +#define DREAM_GPIO_CABLE_IN2		    (49)
> +
> +#define DREAM_GPIO_START		    (128)
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
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
