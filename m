Return-Path: <linux-kernel-owner+w=401wt.eu-S966022AbZLHUVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966022AbZLHUVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbZLHUVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:21:48 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:33788 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934914AbZLHUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:21:46 -0500
Message-ID: <4B1EB57D.6070408@bluewatersys.com>
Date: Wed, 09 Dec 2009 09:22:21 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
References: <20091208102842.GH12264@elf.ucw.cz>
In-Reply-To: <20091208102842.GH12264@elf.ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Add GPIO support for HTC Dream.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

You might want to run this through checkpatch, I suspect it is going to
give you several errors. Some other comments inline.

> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index f780086..774c50e 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -40,4 +40,8 @@ config MACH_TROUT
>  	help
>  	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
>  
> +config GENERIC_GPIO
> +	bool
> +	default y
> +
>  endif
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
> index 0000000..1b23a84
> --- /dev/null
> +++ b/arch/arm/mach-msm/board-dream-gpio.c
> @@ -0,0 +1,301 @@
> +/* arch/arm/mach-msm/board-dream-gpio.c
> + *
> + * Copyright (C) 2008 Google, Inc.
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
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/irq.h>
> +#include <linux/pm.h>
> +#include <linux/sysdev.h>
> +#include <linux/io.h> 
> +
> +#include <asm/gpio.h>
> +#include <asm/mach-types.h>
> +
> +#include "board-dream.h"
> +#include "gpio_chip.h"
> +
> +#undef MODULE_PARAM_PREFIX
> +#define MODULE_PARAM_PREFIX "board_dream."

This looks a bit dodgy. Is this
(http://lkml.indiana.edu/hypermail/linux/kernel/0903.0/02768.html) the
preferred way?

> +static uint cpld_usb_h2w_sw;
> +module_param_named(usb_h2w_sw, cpld_usb_h2w_sw, uint, 0);
> +
> +static uint8_t dream_cpld_shadow[4] = {
> +#if defined(CONFIG_MSM_DEBUG_UART1)
> +	/* H2W pins <-> UART1 */
> +        [0] = 0x40, // for serial debug, low current
> +#else
> +	/* H2W pins <-> UART3, Bluetooth <-> UART1 */
> +        [0] = 0x80, // for serial debug, low current
> +#endif
> +        [1] = 0x04, // I2C_PULL
> +        [3] = 0x04, // mmdi 32k en
> +};
> +static uint8_t dream_int_mask[2] = {
> +        [0] = 0xff, /* mask all interrupts */
> +        [1] = 0xff,
> +};
> +static uint8_t dream_sleep_int_mask[] = {
> +        [0] = 0xff,
> +        [1] = 0xff,
> +};
> +static int dream_suspended;
> +
> +static int dream_gpio_read(struct gpio_chip *chip, unsigned n)
> +{
> +	uint8_t b;
> +	int reg;
> +	if (n >= DREAM_GPIO_VIRTUAL_BASE)
> +		n += DREAM_GPIO_VIRTUAL_TO_REAL_OFFSET;
> +	b = 1U << (n & 7);
> +	reg = (n & 0x78) >> 2; // assumes base is 128
> +	return !!(readb(DREAM_CPLD_BASE + reg) & b);
> +}
> +
> +static void update_pwrsink(unsigned gpio, unsigned on)
> +{
> +	switch(gpio) {
> +	case DREAM_GPIO_UI_LED_EN:
> +		break;
> +	case DREAM_GPIO_QTKEY_LED_EN:
> +		break;
> +	}
> +}

What is this function for?

> +static uint8_t dream_gpio_write_shadow(unsigned n, unsigned on)
> +{
> +	uint8_t b = 1U << (n & 7);
> +	int reg = (n & 0x78) >> 2; // assumes base is 128
> +
> +	if(on)
> +		return dream_cpld_shadow[reg >> 1] |= b;
> +	else
> +		return dream_cpld_shadow[reg >> 1] &= ~b;
> +}
> +
> +static int dream_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on)
> +{
> +	int reg = (n & 0x78) >> 2; // assumes base is 128
> +	unsigned long flags;
> +	uint8_t reg_val;
> +
> +	if ((reg >> 1) >= ARRAY_SIZE(dream_cpld_shadow)) {
> +		printk(KERN_ERR "dream_gpio_write called on input %d\n", n);
> +		return -ENOTSUPP;
> +	}
> +
> +	local_irq_save(flags);
> +	update_pwrsink(n, on);
> +	reg_val = dream_gpio_write_shadow(n, on);
> +	writeb(reg_val, DREAM_CPLD_BASE + reg);
> +	local_irq_restore(flags);
> +	return 0;
> +}
> +
> +static int dream_gpio_configure(struct gpio_chip *chip, unsigned int gpio, unsigned long flags)
> +{
> +	if(flags & (GPIOF_OUTPUT_LOW | GPIOF_OUTPUT_HIGH))
> +		dream_gpio_write(chip, gpio, flags & GPIOF_OUTPUT_HIGH);
> +	return 0;
> +}
> +
> +static int dream_gpio_get_irq_num(struct gpio_chip *chip, unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp)
> +{
> +	if ((gpio < DREAM_GPIO_BANK0_FIRST_INT_SOURCE ||
> +	     gpio > DREAM_GPIO_BANK0_LAST_INT_SOURCE) &&
> +	    (gpio < DREAM_GPIO_BANK1_FIRST_INT_SOURCE ||
> +	     gpio > DREAM_GPIO_BANK1_LAST_INT_SOURCE))
> +		return -ENOENT;
> +	*irqp = DREAM_GPIO_TO_INT(gpio);
> +	if(irqnumflagsp)
> +		*irqnumflagsp = 0;
> +	return 0;
> +}
> +
> +static void dream_gpio_irq_ack(unsigned int irq)
> +{
> +	int bank = DREAM_INT_TO_BANK(irq);
> +	uint8_t mask = DREAM_INT_TO_MASK(irq);
> +	int reg = DREAM_BANK_TO_STAT_REG(bank);
> +	/*printk(KERN_INFO "dream_gpio_irq_ack irq %d\n", irq);*/

pr_debug, or just remove it?

> +	writeb(mask, DREAM_CPLD_BASE + reg);
> +}
> +
> +static void dream_gpio_irq_mask(unsigned int irq)
> +{
> +	unsigned long flags;
> +	uint8_t reg_val;
> +	int bank = DREAM_INT_TO_BANK(irq);
> +	uint8_t mask = DREAM_INT_TO_MASK(irq);
> +	int reg = DREAM_BANK_TO_MASK_REG(bank);
> +
> +	local_irq_save(flags);
> +	reg_val = dream_int_mask[bank] |= mask;
> +	/*printk(KERN_INFO "dream_gpio_irq_mask irq %d => %d:%02x\n",
> +	       irq, bank, reg_val);*/
> +	if (!dream_suspended)
> +		writeb(reg_val, DREAM_CPLD_BASE + reg);
> +	local_irq_restore(flags);
> +}
> +
> +static void dream_gpio_irq_unmask(unsigned int irq)
> +{
> +	unsigned long flags;
> +	uint8_t reg_val;
> +	int bank = DREAM_INT_TO_BANK(irq);
> +	uint8_t mask = DREAM_INT_TO_MASK(irq);
> +	int reg = DREAM_BANK_TO_MASK_REG(bank);
> +
> +	local_irq_save(flags);
> +	reg_val = dream_int_mask[bank] &= ~mask;
> +	/*printk(KERN_INFO "dream_gpio_irq_unmask irq %d => %d:%02x\n",
> +	       irq, bank, reg_val);*/
> +	if (!dream_suspended)
> +		writeb(reg_val, DREAM_CPLD_BASE + reg);
> +	local_irq_restore(flags);
> +}
> +
> +int dream_gpio_irq_set_wake(unsigned int irq, unsigned int on)
> +{
> +	unsigned long flags;
> +	int bank = DREAM_INT_TO_BANK(irq);
> +	uint8_t mask = DREAM_INT_TO_MASK(irq);
> +
> +	local_irq_save(flags);
> +	if(on)
> +		dream_sleep_int_mask[bank] &= ~mask;
> +	else
> +		dream_sleep_int_mask[bank] |= mask;
> +	local_irq_restore(flags);
> +	return 0;
> +}
> +
> +static void dream_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	int j, m;
> +	unsigned v;
> +	int bank;
> +	int stat_reg;
> +	int int_base = DREAM_INT_START;
> +	uint8_t int_mask;
> +
> +	for (bank = 0; bank < 2; bank++) {
> +		stat_reg = DREAM_BANK_TO_STAT_REG(bank);
> +		v = readb(DREAM_CPLD_BASE + stat_reg);
> +		int_mask = dream_int_mask[bank];
> +		if (v & int_mask) {
> +			writeb(v & int_mask, DREAM_CPLD_BASE + stat_reg);
> +			printk(KERN_ERR "dream_gpio_irq_handler: got masked "
> +			       "interrupt: %d:%02x\n", bank, v & int_mask);
> +		}
> +		v &= ~int_mask;
> +		while (v) {
> +			m = v & -v;
> +			j = fls(m) - 1;
> +			/*printk(KERN_INFO "msm_gpio_irq_handler %d:%02x %02x b"
> +			       "it %d irq %d\n", bank, v, m, j, int_base + j);*/
> +			v &= ~m;
> +			generic_handle_irq(int_base + j);
> +		}
> +		int_base += DREAM_INT_BANK0_COUNT;
> +	}
> +	desc->chip->ack(irq);
> +}

Some blank lines here and there would make this more readable. All your
code is wedged together :-).

> +static int dream_sysdev_suspend(struct sys_device *dev, pm_message_t state)
> +{
> +	dream_suspended = 1;
> +	writeb(dream_sleep_int_mask[0],
> +	       DREAM_CPLD_BASE + DREAM_GPIO_INT_MASK0_REG);
> +	writeb(dream_sleep_int_mask[1],
> +	       DREAM_CPLD_BASE + DREAM_GPIO_INT_MASK1_REG);
> +	writeb(dream_sleep_int_mask[0],
> +	       DREAM_CPLD_BASE + DREAM_GPIO_INT_STAT0_REG);
> +	writeb(dream_sleep_int_mask[1],
> +	       DREAM_CPLD_BASE + DREAM_GPIO_INT_STAT1_REG);
> +	return 0;
> +}
> +
> +int dream_sysdev_resume(struct sys_device *dev)
> +{
> +	writeb(dream_int_mask[0], DREAM_CPLD_BASE + DREAM_GPIO_INT_MASK0_REG);
> +	writeb(dream_int_mask[1], DREAM_CPLD_BASE + DREAM_GPIO_INT_MASK1_REG);
> +	dream_suspended = 0;
> +	return 0;
> +}
> +
> +static struct irq_chip dream_gpio_irq_chip = {
> +	.name      = "dreamgpio",
> +	.ack       = dream_gpio_irq_ack,
> +	.mask      = dream_gpio_irq_mask,
> +	.unmask    = dream_gpio_irq_unmask,
> +	.set_wake  = dream_gpio_irq_set_wake,
> +	//.set_type  = dream_gpio_irq_set_type,
> +};
> +
> +static struct gpio_chip dream_gpio_chip = {
> +	.start = DREAM_GPIO_START,
> +	.end = DREAM_GPIO_END,
> +	.configure = dream_gpio_configure,
> +	.get_irq_num = dream_gpio_get_irq_num,
> +	.read = dream_gpio_read,
> +	.write = dream_gpio_write,
> +//	.read_detect_status = dream_gpio_read_detect_status,
> +//	.clear_detect_status = dream_gpio_clear_detect_status
> +};
> +
> +struct sysdev_class dream_sysdev_class = {
> +	.name = "dreamgpio_irq",
> +	.suspend = dream_sysdev_suspend,
> +	.resume = dream_sysdev_resume,
> +};
> +
> +static struct sys_device dream_irq_device = {
> +	.cls    = &dream_sysdev_class,
> +};
> +
> +static int __init dream_init_gpio(void)
> +{
> +	int i;
> +
> +	if (!machine_is_trout())
> +		return 0;
> +
> +	/* adjust GPIOs based on bootloader request */
> +	pr_info("dream_init_gpio: cpld_usb_hw2_sw = %d\n", cpld_usb_h2w_sw);
> +	dream_gpio_write_shadow(DREAM_GPIO_USB_H2W_SW, cpld_usb_h2w_sw);
> +
> +	for(i = 0; i < ARRAY_SIZE(dream_cpld_shadow); i++)
> +		writeb(dream_cpld_shadow[i], DREAM_CPLD_BASE + i * 2);
> +
> +	for(i = DREAM_INT_START; i <= DREAM_INT_END; i++) {
> +		set_irq_chip(i, &dream_gpio_irq_chip);
> +		set_irq_handler(i, handle_edge_irq);
> +		set_irq_flags(i, IRQF_VALID);
> +	}
> +
> +	register_gpio_chip(&dream_gpio_chip);
> +
> +	set_irq_type(MSM_GPIO_TO_INT(17), IRQF_TRIGGER_HIGH);
> +	set_irq_chained_handler(MSM_GPIO_TO_INT(17), dream_gpio_irq_handler);
> +	set_irq_wake(MSM_GPIO_TO_INT(17), 1);
> +
> +	if(sysdev_class_register(&dream_sysdev_class) == 0)
> +		sysdev_register(&dream_irq_device);
> +
> +	return 0;
> +}
> +
> +postcore_initcall(dream_init_gpio);
> diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
> index d238e2c..4758957 100644
> --- a/arch/arm/mach-msm/board-dream.c
> +++ b/arch/arm/mach-msm/board-dream.c
> @@ -18,11 +18,13 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
> +#include <linux/delay.h>
>  
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/setup.h>
> +#include <asm/gpio.h>
>  
>  #include <mach/board.h>
>  #include <mach/hardware.h>
> @@ -62,9 +64,9 @@ static void __init dream_init(void)
>  
>  static struct map_desc dream_io_desc[] __initdata = {
>  	{
> -		.virtual = TROUT_CPLD_BASE,
> -		.pfn     = __phys_to_pfn(TROUT_CPLD_START),
> -		.length  = TROUT_CPLD_SIZE,
> +		.virtual = DREAM_CPLD_BASE,
> +		.pfn     = __phys_to_pfn(DREAM_CPLD_START),
> +		.length  = DREAM_CPLD_SIZE,
>  		.type    = MT_DEVICE_NONSHARED
>  	}
>  };
> @@ -76,7 +78,7 @@ static void __init dream_map_io(void)
>  
>  #ifdef CONFIG_MSM_DEBUG_UART3
>  	/* route UART3 to the "H2W" extended usb connector */
> -	writeb(0x80, TROUT_CPLD_BASE + 0x00);
> +	writeb(0x80, DREAM_CPLD_BASE + 0x00);
>  #endif
>  
>  	msm_clock_init();
> diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
> index 4f345a5..eadfd17 100644
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
> +#define MSM_PMEM_GPU1_BASE	MSM_RAM_CONSOLE_BASE - MSM_PMEM_GPU1_SIZE
> +
> +#define MSM_RAM_CONSOLE_BASE	MSM_EBI_BASE + 0x6d00000
> +#define MSM_RAM_CONSOLE_SIZE	128 * SZ_1K
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

Are these needed outside of the gpiolib code? If not, they should be
moved there. I also think they should have lower case names since they
act like a function, and make the code where they are used nicer to read.

> diff --git a/arch/arm/mach-msm/generic_gpio.c b/arch/arm/mach-msm/generic_gpio.c
> new file mode 100644
> index 0000000..fe24d38
> --- /dev/null
> +++ b/arch/arm/mach-msm/generic_gpio.c
> @@ -0,0 +1,274 @@
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
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <asm/gpio.h>
> +#include "gpio_chip.h"
> +
> +#define GPIO_NUM_TO_CHIP_INDEX(gpio) ((gpio)>>5)
> +
> +struct gpio_state {
> +	unsigned long flags;
> +	int refcount;
> +};
> +
> +static DEFINE_SPINLOCK(gpio_chips_lock);
> +static LIST_HEAD(gpio_chip_list);
> +static struct gpio_chip **gpio_chip_array;
> +static unsigned long gpio_chip_array_size;
> +
> +int register_gpio_chip(struct gpio_chip *new_gpio_chip)
> +{
> +	int err = 0;
> +	struct gpio_chip *gpio_chip;
> +	int i;
> +	unsigned long irq_flags;
> +	unsigned int chip_array_start_index, chip_array_end_index;
> +
> +	new_gpio_chip->state = kzalloc((new_gpio_chip->end + 1 - new_gpio_chip->start) * sizeof(new_gpio_chip->state[0]), GFP_KERNEL);
> +	if (new_gpio_chip->state == NULL) {
> +		printk(KERN_ERR "register_gpio_chip: failed to allocate state\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip_array_start_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->start);
> +	chip_array_end_index = GPIO_NUM_TO_CHIP_INDEX(new_gpio_chip->end);
> +	if (chip_array_end_index >= gpio_chip_array_size) {
> +		struct gpio_chip **new_gpio_chip_array;
> +		unsigned long new_gpio_chip_array_size = chip_array_end_index + 1;
> +
> +		new_gpio_chip_array = kmalloc(new_gpio_chip_array_size * sizeof(new_gpio_chip_array[0]), GFP_ATOMIC);
> +		if (new_gpio_chip_array == NULL) {
> +			printk(KERN_ERR "register_gpio_chip: failed to allocate array\n");
> +			err = -ENOMEM;
> +			goto failed;
> +		}
> +		for (i = 0; i < gpio_chip_array_size; i++)
> +			new_gpio_chip_array[i] = gpio_chip_array[i];
> +		for (i = gpio_chip_array_size; i < new_gpio_chip_array_size; i++)
> +			new_gpio_chip_array[i] = NULL;
> +		gpio_chip_array = new_gpio_chip_array;
> +		gpio_chip_array_size = new_gpio_chip_array_size;
> +	}
> +	list_for_each_entry(gpio_chip, &gpio_chip_list, list) {
> +		if (gpio_chip->start > new_gpio_chip->end) {
> +			list_add_tail(&new_gpio_chip->list, &gpio_chip->list);
> +			goto added;
> +		}
> +		if (gpio_chip->end >= new_gpio_chip->start) {
> +			printk(KERN_ERR "register_gpio_source %u-%u overlaps with %u-%u\n",
> +			       new_gpio_chip->start, new_gpio_chip->end,
> +			       gpio_chip->start, gpio_chip->end);
> +			err = -EBUSY;
> +			goto failed;
> +		}
> +	}
> +	list_add_tail(&new_gpio_chip->list, &gpio_chip_list);
> +added:
> +	for (i = chip_array_start_index; i <= chip_array_end_index; i++) {
> +		if (gpio_chip_array[i] == NULL || gpio_chip_array[i]->start > new_gpio_chip->start)
> +			gpio_chip_array[i] = new_gpio_chip;
> +	}
> +failed:
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	if (err)
> +		kfree(new_gpio_chip->state);
> +	return err;
> +}

Thats big, hard to read, has about 3 blank lines total and no comments.

> +
> +static struct gpio_chip *get_gpio_chip_locked(unsigned int gpio)
> +{
> +	unsigned long i;
> +	struct gpio_chip *chip;
> +
> +	i = GPIO_NUM_TO_CHIP_INDEX(gpio);
> +	if (i >= gpio_chip_array_size)
> +		return NULL;
> +	chip = gpio_chip_array[i];
> +	if (chip == NULL)
> +		return NULL;
> +	list_for_each_entry_from(chip, &gpio_chip_list, list) {
> +		if (gpio < chip->start)
> +			return NULL;
> +		if (gpio <= chip->end)
> +			return chip;
> +	}
> +	return NULL;
> +}
> +
> +static int request_gpio(unsigned int gpio, unsigned long flags)
> +{
> +	int err = 0;
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +	unsigned long chip_index;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip == NULL) {
> +		err = -EINVAL;
> +		goto err;
> +	}
> +	chip_index = gpio - chip->start;
> +	if (chip->state[chip_index].refcount == 0) {
> +		chip->configure(chip, gpio, flags);
> +		chip->state[chip_index].flags = flags;
> +		chip->state[chip_index].refcount++;
> +	} else if ((flags & IRQF_SHARED) && (chip->state[chip_index].flags & IRQF_SHARED))
> +		chip->state[chip_index].refcount++;
> +	else
> +		err = -EBUSY;
> +err:
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	return err;
> +}
> +
> +int gpio_request(unsigned gpio, const char *label)
> +{
> +	return request_gpio(gpio, 0);
> +}
> +EXPORT_SYMBOL(gpio_request);
> +
> +void gpio_free(unsigned gpio)
> +{
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +	unsigned long chip_index;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip) {
> +		chip_index = gpio - chip->start;
> +		chip->state[chip_index].refcount--;
> +	}
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +}
> +EXPORT_SYMBOL(gpio_free);
> +
> +static int gpio_get_irq_num(unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp)
> +{
> +	int ret = -ENOTSUPP;
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip && chip->get_irq_num)
> +		ret = chip->get_irq_num(chip, gpio, irqp, irqnumflagsp);
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	return ret;
> +}
> +
> +int gpio_to_irq(unsigned gpio)
> +{
> +	int ret, irq;
> +	ret = gpio_get_irq_num(gpio, &irq, NULL);
> +	if (ret)
> +		return ret;
> +	return irq;
> +}
> +EXPORT_SYMBOL(gpio_to_irq);
> +
> +int gpio_configure(unsigned int gpio, unsigned long flags)
> +{
> +	int ret = -ENOTSUPP;
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip)
> +		ret = chip->configure(chip, gpio, flags);
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(gpio_configure);
> +
> +int gpio_direction_input(unsigned gpio)
> +{
> +	return gpio_configure(gpio, GPIOF_INPUT);
> +}
> +EXPORT_SYMBOL(gpio_direction_input);
> +
> +int gpio_direction_output(unsigned gpio, int value)
> +{
> +	gpio_set_value(gpio, value);
> +	return gpio_configure(gpio, GPIOF_DRIVE_OUTPUT);
> +}
> +EXPORT_SYMBOL(gpio_direction_output);
> +
> +int gpio_get_value(unsigned gpio)
> +{
> +	int ret = -ENOTSUPP;
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip && chip->read)
> +		ret = chip->read(chip, gpio);
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(gpio_get_value);
> +
> +void gpio_set_value(unsigned gpio, int on)
> +{
> +	int ret = -ENOTSUPP;
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip && chip->write)
> +		ret = chip->write(chip, gpio, on);
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +}
> +EXPORT_SYMBOL(gpio_set_value);
> +
> +int gpio_read_detect_status(unsigned int gpio)
> +{
> +	int ret = -ENOTSUPP;
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip && chip->read_detect_status)
> +		ret = chip->read_detect_status(chip, gpio);
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(gpio_read_detect_status);
> +
> +int gpio_clear_detect_status(unsigned int gpio)
> +{
> +	int ret = -ENOTSUPP;
> +	struct gpio_chip *chip;
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&gpio_chips_lock, irq_flags);
> +	chip = get_gpio_chip_locked(gpio);
> +	if (chip && chip->clear_detect_status)
> +		ret = chip->clear_detect_status(chip, gpio);
> +	spin_unlock_irqrestore(&gpio_chips_lock, irq_flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL(gpio_clear_detect_status);
> diff --git a/arch/arm/mach-msm/gpio_chip.h b/arch/arm/mach-msm/gpio_chip.h
> new file mode 100644
> index 0000000..ee4eddc
> --- /dev/null
> +++ b/arch/arm/mach-msm/gpio_chip.h
> @@ -0,0 +1,50 @@
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
> +#include <linux/list.h>
> +
> +struct gpio_chip {
> +	struct list_head list;
> +	struct gpio_state *state;
> +
> +	unsigned int start;
> +	unsigned int end;
> +
> +	int (*configure)(struct gpio_chip *chip, unsigned int gpio, unsigned long flags);
> +	int (*get_irq_num)(struct gpio_chip *chip, unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp);
> +	int (*read)(struct gpio_chip *chip, unsigned int gpio);
> +	int (*write)(struct gpio_chip *chip, unsigned int gpio, unsigned on);
> +	int (*read_detect_status)(struct gpio_chip *chip, unsigned int gpio);
> +	int (*clear_detect_status)(struct gpio_chip *chip, unsigned int gpio);
> +};
> +
> +int register_gpio_chip(struct gpio_chip *gpio_chip);
> +
> +/* extended gpio api */
> +
> +#define GPIOF_IRQF_MASK         0x0000ffff /* use to specify edge detection without */
> +#define GPIOF_IRQF_TRIGGER_NONE 0x00010000 /* IRQF_TRIGGER_NONE is 0 which also means "as already configured" */
> +#define GPIOF_INPUT             0x00020000
> +#define GPIOF_DRIVE_OUTPUT      0x00040000
> +#define GPIOF_OUTPUT_LOW        0x00080000
> +#define GPIOF_OUTPUT_HIGH       0x00100000
> +
> +#define GPIOIRQF_SHARED         0x00000001 /* the irq line is shared with other inputs */
> +
> +
> +#endif
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
> +
> +int gpio_request(unsigned gpio, const char *label);
> +void gpio_free(unsigned gpio);
> +int gpio_direction_input(unsigned gpio);
> +int gpio_direction_output(unsigned gpio, int value);
> +int gpio_get_value(unsigned gpio);
> +void gpio_set_value(unsigned gpio, int value);
> +int gpio_to_irq(unsigned gpio);
> +
> +#include <asm-generic/gpio.h>
> +
> +extern int gpio_configure(unsigned int gpio, unsigned long flags);
> +extern int gpio_read_detect_status(unsigned int gpio);
> +extern int gpio_clear_detect_status(unsigned int gpio);
> +
> +#endif
> 
> 


-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
