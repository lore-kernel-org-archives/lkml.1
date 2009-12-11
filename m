Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbZLKXEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbZLKXEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZLKXD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:03:59 -0500
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:46256 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754165AbZLKXD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:03:58 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: GPIO support for HTC Dream
Date: Fri, 11 Dec 2009 18:04:04 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
In-Reply-To: <20091211221015.GB24456@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: GPIO support for HTC Dream
Thread-Index: Acp6rwQyKcB7S5QgRw2P37a+ppr72AAApCvQ
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Ryan Mallon" <ryan@bluewatersys.com>,
       "Daniel Walker" <dwalker@codeaurora.org>,
       "Iliyan Malchev" <malchev@google.com>,
       "Brian Swetland" <swetland@google.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 11 Dec 2009 23:04:03.0976 (UTC) FILETIME=[3BD26080:01CA7AB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 11, 2009 3:10 PM, Pavel Machek wrote:
> Hi!
>
> Ok, thanks to Ryan and everyone... You were right, the code was way
> too complex.

This looks MUCH better!

>
> Cleaning it up according to Hartley's great howto resulted in:

Glad to help.  Couple of comments follow...

> arch/arm/Kconfig                     |    1
> arch/arm/mach-msm/board-dream-gpio.c |  327 +++++++++--------------------------
> arch/arm/mach-msm/board-dream.c      |   24 --
> arch/arm/mach-msm/generic_gpio.c     |  270 ----------------------------
> arch/arm/mach-msm/gpio_chip.h        |   30 ---
> kernel/printk.c                      |    6
> 6 files changed, 102 insertions(+), 556 deletions(-)

Please update (or remove) this diffstat.  It no longer matches the patch.

>> As Ryan says, using gpiolib will clean this up immensely.
>> 
>> It appears the what you really have for gpio's is 7 8-bit ports that start
>> with gpio number 128.  Each port appears to only have one control register.
>> This register is written with a '1' to drive the gpio as a high output and
>> '0' to drive it as a low output or to use it as an input.  Not really
>> sure if this is correct since the code is a bit screwy.
>
> It seems it is, because it seems to work.

Ok.  The hardware still seems a bit strange. Is there any datasheet available?

>> Your current code is written so that all of the gpio's are in one "chip".
>> Because of this you are having to calculate the 'reg' needed to access the
>> gpio whenever you need to read or write to a gpio.
>> 
>> If you follow the ep93xx implementation you can break the whole thing down
>> into 'banks' and simplify everything.  Something like:
>
> ...and get 100 lines of results, instead of 600... Yep, thanks.
>
> Now, it will still need some cleanups -- I'm not sure if gpios are
> dream-specific or generic for whole msm.... I kind of assume they
> should be generic for msm. Google people, can you help?
>
>> static struct dream_gpio_chip dream_gpio_banks[] = {
>> 	DREAM_GPIO_BANK("MISC2", 0x00, DREAM_GPIO_MISC2_BASE),
>> 	DREAM_GPIO_BANK("MISC3", 0x02, DREAM_GPIO_MISC3_BASE),
>> 	DREAM_GPIO_BANK("MISC4", 0x04, DREAM_GPIO_MISC4_BASE),
>> 	DREAM_GPIO_BANK("MISC5", 0x06, DREAM_GPIO_MISC5_BASE),
>> 	DREAM_GPIO_BANK("INT2", 0x08, DREAM_GPIO_INT2_BASE),
>> 	DREAM_GPIO_BANK("MISC1", 0x0a, DREAM_GPIO_MISC1_BASE),
>> 	DREAM_GPIO_BANK("VIRTUAL", 0x12, DREAM_GPIO_VIRTUAL_BASE),
>> };
>
> Yep, that did the trick.
>
>> With this you can now just access the dream_gpio_chip data in all
>> the member function using the to_dream_gpio_chip() macro.
>> 
>> I agree with Ryan and think you would be better off in the long
>> run to re-code this and use gpiolib.  You might also want to break
>> out all the gpio interrupt stuff and submit it as a seperate patch.
>
> Will do. Here's how the patch looks now.
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

I think you need to move these to MACH_TROUT since this is 'dream'
specific.

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
> index 0000000..d90b8f9
> --- /dev/null
> +++ b/arch/arm/mach-msm/board-dream-gpio.c
> @@ -0,0 +1,135 @@
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
> +#include <linux/clk.h>
> +#include <linux/errno.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +
> +#include <mach/hardware.h>
> +#include <mach/gpio.h>
> +
> +#include <asm/gpio.h>
> +
> +#include "board-dream.h"
> +

Please remove all the unnecessary headers.  I think you only need:

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/io.h>
#include <linux/gpio.h>

#include <mach/hardware.h>
#include <mach/gpio.h>

#include "board-dream.h"

> +struct msm_gpio_chip {
> +	struct gpio_chip	chip;
> +	void __iomem		*reg;	/* Base of register bank */
> +	u8			shadow;
> +};
> +
> +#define to_msm_gpio_chip(c) container_of(c, struct msm_gpio_chip, chip)
> +
> +static void msm_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val);
> +static int msm_gpiolib_get(struct gpio_chip *chip, unsigned offset);
> +static int msm_gpiolib_direction_output(struct gpio_chip *chip,
> +					 unsigned offset, int val);
> +static int msm_gpiolib_direction_input(struct gpio_chip *chip,
> +					unsigned offset);
> +

Please reorganize the code so that the function prototypes are not
needed.

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
> +	BUG();
> +}

return -EINVAL;

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

Your original patch was initially writing the shadow values to the registers.
Do you still need to do that?

> +
> +postcore_initcall(dream_init_gpio);
> +
> diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
> index 4f345a5..aab1faf 100644
> --- a/arch/arm/mach-msm/board-dream.h
> +++ b/arch/arm/mach-msm/board-dream.h
> @@ -1,5 +1,153 @@
>  
> -#define TROUT_CPLD_BASE   0xE8100000
> -#define TROUT_CPLD_START  0x98000000
> -#define TROUT_CPLD_SIZE   SZ_4K
> +#define MSM_SMI_BASE		0x00000000
> +#define MSM_SMI_SIZE		0x00800000
>  
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
> +#define DREAM_GPIO_CABLE_IN1		(83)
> +#define DREAM_GPIO_CABLE_IN2		(49)
> +
> +#define DREAM_GPIO_START (128)
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
> +#define DREAM_GPIO_VIRTUAL_TO_REAL_OFFSET \
> +	(DREAM_GPIO_INT5_BASE - DREAM_GPIO_VIRTUAL_BASE)
> +
> +#define DREAM_INT_START (NR_MSM_IRQS + NR_GPIO_IRQS)
> +#define DREAM_INT_BANK0_COUNT (8)
> +#define DREAM_INT_BANK1_START (DREAM_INT_START + DREAM_INT_BANK0_COUNT)
> +#define DREAM_INT_BANK1_COUNT (1)
> +#define DREAM_INT_END (DREAM_INT_START + DREAM_INT_BANK0_COUNT + \
> +			DREAM_INT_BANK1_COUNT - 1)
> +#define DREAM_GPIO_TO_INT(n) (((n) <= DREAM_GPIO_BANK0_LAST_INT_SOURCE) ? \
> +	(DREAM_INT_START - DREAM_GPIO_BANK0_FIRST_INT_SOURCE + (n)) : \
> +	(DREAM_INT_BANK1_START - DREAM_GPIO_BANK1_FIRST_INT_SOURCE + (n)))
> +
> +#define DREAM_INT_TO_BANK(n) ((n - DREAM_INT_START) / DREAM_INT_BANK0_COUNT)
> +#define DREAM_INT_TO_MASK(n) (1U << ((n - DREAM_INT_START) & 7))
> +#define DREAM_BANK_TO_MASK_REG(bank) \
> +	(bank ? DREAM_GPIO_INT_MASK1_REG : DREAM_GPIO_INT_MASK0_REG)
> +#define DREAM_BANK_TO_STAT_REG(bank) \
> +	(bank ? DREAM_GPIO_INT_STAT1_REG : DREAM_GPIO_INT_STAT0_REG)

I think all the DREAM_GPIO_* stuff needs to be moved into
arch/arm/mach-msm/include/mach/gpio.h so that board drivers can pick up
the defines with #include <linux/gpio.h>.

> diff --git a/arch/arm/mach-msm/include/mach/gpio.h b/arch/arm/mach-msm/include/mach/gpio.h
> new file mode 100644
> index 0000000..92ce18d
> --- /dev/null
> +++ b/arch/arm/mach-msm/include/mach/gpio.h
> @@ -0,0 +1,36 @@
> +/* linux/include/asm-arm/arch-msm/gpio.h
> + *
> + * Copyright (C) 2007 Google, Inc.
> + * Author: Mike Lockwood <lockwood@android.com>
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
> +#include <linux/interrupt.h>

Unneeded include.

> +
> +int gpio_request(unsigned gpio, const char *label);
> +void gpio_free(unsigned gpio);
> +int gpio_direction_input(unsigned gpio);
> +int gpio_direction_output(unsigned gpio, int value);
> +int gpio_get_value(unsigned gpio);
> +void gpio_set_value(unsigned gpio, int value);
> +int gpio_to_irq(unsigned gpio);
> +

The prototypes are not needed.  They will get picked up by the
following include.

> +#include <asm-generic/gpio.h>
> +
> +extern int gpio_configure(unsigned int gpio, unsigned long flags);
> +extern int gpio_read_detect_status(unsigned int gpio);
> +extern int gpio_clear_detect_status(unsigned int gpio);

These are not needed since they are not defined in the patch.

I think you will need to add the following also so that gpiolib will
use the default functions.

#define gpio_get_value	__gpio_get_value
#define gpio_set_value	__gpio_set_value
#define gpio_cansleep	__gpio_cansleep

> +
> +#endif

Regards,
Hartley
