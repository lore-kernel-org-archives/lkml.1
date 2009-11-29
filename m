Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZK2XoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZK2XoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 18:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZK2XoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 18:44:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:33857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZK2XoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 18:44:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,308,1257148800"; 
   d="scan'208";a="574025892"
Date: Mon, 30 Nov 2009 00:46:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Andrey A. Porodko" <andrey.porodko@gmail.com>
Cc: "A. Porodko" <panda@chelcom.ru>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Balaji Rao <balajirrao@openmoko.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Patch for MSP430 support on Neuros OSD2 board
Message-ID: <20091129234605.GA4292@sortiz.org>
References: <4B0E7E07.4080404@chelcom.ru>
 <4B0E7FE2.7060204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0E7FE2.7060204@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Thu, Nov 26, 2009 at 06:17:22PM +0500, Andrey A. Porodko wrote:
> Hello,
> 
> Here is a patch for MSP430 chip support for Neuros OSD2 (Davinci DM6446
> based) board.
> Patch made against 2.6.32-rc6 kernel.
Thanks for the patch, here are some comments about it:

- Renaming a file may be acceptable, but you have to delete the prvious one.
Also, as you're changing the Kconfig symbol, you should evaluate the impact on
the current users (in config_* files for example).

- Then about the code itself: ifdefs as the one you're doing here is not
exactly nice, and leads to a lot of code replication and maintenance burden.
It seems that you're trying to have a common MSP430 driver support for 2
different boards, which is a good idea. The main problem, if I understand it
correctly, is those 2 boards are running the same MSP430 HW running different
FWs.
What I'd really like to see here would be to have a generic MSP430 support.
You'd need to define a FW definition structure (it seems it would mostly be
GPIO settings), then have different static definitions for every known firmware
revision, and finally have a common probe routine that would go through this
firmware structure and sets thing accordingly. You would pass the firmware
revision you're using from your board definitions, unless there are some
registers on that chip that would let us know about this firmware.

Cheers,
Samuel.


> 
> ---------------------------
> 
> From 2324abe6d10a592e0f179b162a691540f10a4f70 Mon Sep 17 00:00:00 2001
> From: Andrey Porodko <panda@chelcom.ru>
> Date: Thu, 19 Nov 2009 15:32:03 +0500
> Subject: [PATCH] Attempt to introduce common MFD driver for MSP430 microprocessor support.
>  Currently DM355 EVM and Neuros OSD2 boards are supported.
>  Driver has name davinci_msp (I couldn't invent anything better).
> 
> Signed-off-by: Andrey Porodko <panda@chelcom.ru>
> ---
>  drivers/mfd/Kconfig                 |    9 +-
>  drivers/mfd/Makefile                |    2 +-
>  drivers/mfd/davinci_msp.c           |  505 +++++++++++++++++++++++++++++++++++
>  include/linux/i2c/dm355evm_msp.h    |    7 +-
>  include/linux/i2c/neuros_osd2_msp.h |   45 +++
>  5 files changed, 560 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/mfd/davinci_msp.c
>  create mode 100644 include/linux/i2c/neuros_osd2_msp.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 570be13..becab4c 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -35,13 +35,14 @@ config MFD_ASIC3
>  	  This driver supports the ASIC3 multifunction chip found on many
>  	  PDAs (mainly iPAQ and HTC based ones)
>  
> -config MFD_DM355EVM_MSP
> -	bool "DaVinci DM355 EVM microcontroller"
> -	depends on I2C && MACH_DAVINCI_DM355_EVM
> +config MFD_DAVINCI_MSP
> +	bool "DaVinci MSP430 microcontroller"
> +	depends on I2C && (MACH_DAVINCI_DM355_EVM || MACH_NEUROS_OSD2)
>  	help
>  	  This driver supports the MSP430 microcontroller used on these
>  	  boards.  MSP430 firmware manages resets and power sequencing,
> -	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
> +	  inputs from buttons and the IR remote, LEDs, an RTC, and more
> +	  (full set of features depends on particular board).
>  
>  config HTC_EGPIO
>  	bool "HTC EGPIO support"
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f3b277b..aeff3a2 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -8,7 +8,7 @@ obj-$(CONFIG_MFD_ASIC3)		+= asic3.o
>  obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
>  obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
>  
> -obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
> +obj-$(CONFIG_MFD_DAVINCI_MSP)	+= davinci_msp.o
>  
>  obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o
>  obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o
> diff --git a/drivers/mfd/davinci_msp.c b/drivers/mfd/davinci_msp.c
> new file mode 100644
> index 0000000..6164b24
> --- /dev/null
> +++ b/drivers/mfd/davinci_msp.c
> @@ -0,0 +1,505 @@
> +/*
> + * davinci_msp.c - driver for MSP430 firmware on some Davinci boards
> + *
> + * 2008 (c) David Brownell	(DM355 EVM support)
> + * 2009 (c) 2009 Andrey A. Porodko <Andrey.Porodko@gmail.com> (Neuros OSD2
> + * support)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +
> +static struct device *add_child(struct i2c_client *client, const char *name,
> +			void *pdata, unsigned pdata_len,
> +			bool can_wakeup, int irq);
> +
> +/* REVISIT for paranoia's sake, retry reads/writes on error */
> +
> +static struct i2c_client *msp430;
> +
> +/**
> + * davinci_msp_write - Writes a register in msp
> + * @value: the value to be written
> + * @reg: register address
> + *
> + * Returns result of operation - 0 is success, else negative errno
> + */
> +int davinci_msp_write(u8 value, u8 reg)
> +{
> +	return i2c_smbus_write_byte_data(msp430, reg, value);
> +}
> +EXPORT_SYMBOL(davinci_msp_write);
> +
> +/**
> + * davinci_msp_read - Reads a register from msp
> + * @reg: register address
> + *
> + * Returns result of operation - value, or negative errno
> + */
> +int davinci_msp_read(u8 reg)
> +{
> +	return i2c_smbus_read_byte_data(msp430, reg);
> +}
> +EXPORT_SYMBOL(davinci_msp_read);
> +
> +#if defined(CONFIG_MACH_DAVINCI_DM355_EVM) /* exclusively for dm355evm 	*/
> +/*
> + * The DM355 is a DaVinci chip with video support but no C64+ DSP.  Its
> + * EVM board has an MSP430 programmed with firmware for various board
> + * support functions.  This driver exposes some of them directly, and
> + * supports other drivers (e.g. RTC, input) for more complex access.
> + *
> + * Because this firmware is entirely board-specific, this file embeds
> + * knowledge that would be passed as platform_data in a generic driver.
> + *
> + * This driver was tested with firmware revision A4.
> + */
> +#include <linux/i2c/dm355evm_msp.h>
> +
> +#if defined(CONFIG_INPUT_DM355EVM) || defined(CONFIG_INPUT_DM355EVM_MODULE)
> +#define msp_has_keyboard()	true
> +#else
> +#define msp_has_keyboard()	false
> +#endif
> +
> +#if defined(CONFIG_LEDS_GPIO) || defined(CONFIG_LEDS_GPIO_MODULE)
> +#define msp_has_leds()		true
> +#else
> +#define msp_has_leds()		false
> +#endif
> +
> +#if defined(CONFIG_RTC_DRV_DM355EVM) || defined(CONFIG_RTC_DRV_DM355EVM_MODULE)
> +#define msp_has_rtc()		true
> +#else
> +#define msp_has_rtc()		false
> +#endif
> +
> +#if defined(CONFIG_VIDEO_TVP514X) || defined(CONFIG_VIDEO_TVP514X_MODULE)
> +#define msp_has_tvp()		true
> +#else
> +#define msp_has_tvp()		false
> +#endif
> +
> +/*----------------------------------------------------------------------*/
> +
> +/*
> + * Many of the msp430 pins are just used as fixed-direction GPIOs.
> + * We could export a few more of them this way, if we wanted.
> + */
> +#define MSP_GPIO(bit,reg)	((DM355EVM_MSP_ ## reg) << 3 | (bit))
> +
> +static const u8 msp_gpios[] = {
> +	/* eight leds */
> +	MSP_GPIO(0, LED), MSP_GPIO(1, LED),
> +	MSP_GPIO(2, LED), MSP_GPIO(3, LED),
> +	MSP_GPIO(4, LED), MSP_GPIO(5, LED),
> +	MSP_GPIO(6, LED), MSP_GPIO(7, LED),
> +	/* SW6 and the NTSC/nPAL jumper */
> +	MSP_GPIO(0, SWITCH1), MSP_GPIO(1, SWITCH1),
> +	MSP_GPIO(2, SWITCH1), MSP_GPIO(3, SWITCH1),
> +	MSP_GPIO(4, SWITCH1),
> +	/* switches on MMC/SD sockets */
> +	/*
> +	 * Note: EVMDM355_ECP_VA4.pdf suggests that Bit 2 and 4 should be
> +	 * checked for card detection. However on the EVM bit 1 and 3 gives
> +	 * this status, for 0 and 1 instance respectively. The pdf also
> +	 * suggests that Bit 1 and 3 should be checked for write protection.
> +	 * However on the EVM bit 2 and 4 gives this status,for 0 and 1
> +	 * instance respectively.
> +	 */
> +	MSP_GPIO(2, SDMMC), MSP_GPIO(1, SDMMC),	/* mmc0 WP, nCD */
> +	MSP_GPIO(4, SDMMC), MSP_GPIO(3, SDMMC),	/* mmc1 WP, nCD */
> +};
> +
> +#define MSP_GPIO_REG(offset)	(msp_gpios[(offset)] >> 3)
> +#define MSP_GPIO_MASK(offset)	BIT(msp_gpios[(offset)] & 0x07)
> +
> +static int msp_gpio_in(struct gpio_chip *chip, unsigned offset)
> +{
> +	switch (MSP_GPIO_REG(offset)) {
> +	case DM355EVM_MSP_SWITCH1:
> +	case DM355EVM_MSP_SWITCH2:
> +	case DM355EVM_MSP_SDMMC:
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static u8 msp_led_cache;
> +
> +static int msp_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	int reg, status;
> +
> +	reg = MSP_GPIO_REG(offset);
> +	status = davinci_msp_read(reg);
> +	if (status < 0)
> +		return status;
> +	if (reg == DM355EVM_MSP_LED)
> +		msp_led_cache = status;
> +	return status & MSP_GPIO_MASK(offset);
> +}
> +
> +static int msp_gpio_out(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	int mask, bits;
> +
> +	/* NOTE:  there are some other signals that could be
> +	 * packaged as output GPIOs, but they aren't as useful
> +	 * as the LEDs ... so for now we don't.
> +	 */
> +	if (MSP_GPIO_REG(offset) != DM355EVM_MSP_LED)
> +		return -EINVAL;
> +
> +	mask = MSP_GPIO_MASK(offset);
> +	bits = msp_led_cache;
> +
> +	bits &= ~mask;
> +	if (value)
> +		bits |= mask;
> +	msp_led_cache = bits;
> +
> +	return davinci_msp_write(bits, DM355EVM_MSP_LED);
> +}
> +
> +static void msp_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	msp_gpio_out(chip, offset, value);
> +}
> +
> +static struct gpio_chip dm355evm_msp_gpio = {
> +	.label			= "dm355evm_msp",
> +	.owner			= THIS_MODULE,
> +	.direction_input	= msp_gpio_in,
> +	.get			= msp_gpio_get,
> +	.direction_output	= msp_gpio_out,
> +	.set			= msp_gpio_set,
> +	.base			= -EINVAL,	/* dynamic assignment 	*/
> +	.ngpio			= ARRAY_SIZE(msp_gpios),
> +	.can_sleep		= true,
> +};
> +
> +/*----------------------------------------------------------------------*/
> +
> +static int add_children(struct i2c_client *client)
> +{
> +	static const struct {
> +		int offset;
> +		char *label;
> +	} config_inputs[] = {
> +		/* 8 == right after the LEDs */
> +		{ 8 + 0, "sw6_1", },
> +		{ 8 + 1, "sw6_2", },
> +		{ 8 + 2, "sw6_3", },
> +		{ 8 + 3, "sw6_4", },
> +		{ 8 + 4, "NTSC/nPAL", },
> +	};
> +
> +	struct device	*child;
> +	int		status;
> +	int		i;
> +
> +	/* GPIO-ish stuff */
> +	dm355evm_msp_gpio.dev = &client->dev;
> +	status = gpiochip_add(&dm355evm_msp_gpio);
> +	if (status < 0)
> +		return status;
> +
> +	/* LED output */
> +	if (msp_has_leds()) {
> +#define GPIO_LED(l)	.name = l, .active_low = true
> +		static struct gpio_led evm_leds[] = {
> +			{ GPIO_LED("dm355evm::ds14"),
> +				.default_trigger = "heartbeat", },
> +			{ GPIO_LED("dm355evm::ds15"),
> +				.default_trigger = "mmc0", },
> +			{ GPIO_LED("dm355evm::ds16"),
> +				/* could also be a CE-ATA drive */
> +				.default_trigger = "mmc1", },
> +			{ GPIO_LED("dm355evm::ds17"),
> +				.default_trigger = "nand-disk", },
> +			{ GPIO_LED("dm355evm::ds18"), },
> +			{ GPIO_LED("dm355evm::ds19"), },
> +			{ GPIO_LED("dm355evm::ds20"), },
> +			{ GPIO_LED("dm355evm::ds21"), },
> +		};
> +#undef GPIO_LED
> +
> +		struct gpio_led_platform_data evm_led_data = {
> +			.num_leds	= ARRAY_SIZE(evm_leds),
> +			.leds		= evm_leds,
> +		};
> +
> +		for (i = 0; i < ARRAY_SIZE(evm_leds); i++)
> +			evm_leds[i].gpio = i + dm355evm_msp_gpio.base;
> +
> +		/* NOTE:  these are the only fully programmable LEDs
> +		 * on the board, since GPIO-61/ds22 (and many signals
> +		 * going to DC7) must be used for AEMIF address lines
> +		 * unless the top 1 GB of NAND is unused...
> +		 */
> +		child = add_child(client, "leds-gpio",
> +				&evm_led_data, sizeof(evm_led_data),
> +				false, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +
> +	/* configuration inputs */
> +	for (i = 0; i < ARRAY_SIZE(config_inputs); i++) {
> +		int gpio = dm355evm_msp_gpio.base + config_inputs[i].offset;
> +
> +		gpio_request(gpio, config_inputs[i].label);
> +		gpio_direction_input(gpio);
> +
> +		/* make it easy for userspace to see these */
> +		gpio_export(gpio, false);
> +	}
> +
> +	/* MMC/SD inputs -- right after the last config input */
> +	if (client->dev.platform_data) {
> +		void (*mmcsd_setup)(unsigned) = client->dev.platform_data;
> +
> +		mmcsd_setup(dm355evm_msp_gpio.base + 8 + 5);
> +	}
> +
> +	/* RTC is a 32 bit counter, no alarm */
> +	if (msp_has_rtc()) {
> +		child = add_child(client, "rtc-dm355evm",
> +				NULL, 0, false, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +
> +	/* input from buttons and IR remote (uses the IRQ) */
> +	if (msp_has_keyboard()) {
> +		child = add_child(client, "dm355evm_keys",
> +				NULL, 0, true, client->irq);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +
> +	return 0;
> +}
> +
> +static void dm355evm_command(unsigned command)
> +{
> +	int status;
> +
> +	status = davinci_msp_write(command, DM355EVM_MSP_COMMAND);
> +	if (status < 0)
> +		dev_err(&msp430->dev, "command %d failure %d\n",
> +				command, status);
> +}
> +
> +static void dm355evm_power_off(void)
> +{
> +	dm355evm_command(MSP_COMMAND_POWEROFF);
> +}
> +#elif defined(CONFIG_MACH_NEUROS_OSD2)	/* exclusively for Neuros OSD2	*/
> +/*
> + * Neuros OSD2 also has an MSP430 programmed with firmware for various board
> + * support functions.
> + */
> +#include <linux/i2c/neuros_osd2_msp.h>
> +
> +#if defined(CONFIG_INPUT_NEUROS_OSD2) || \
> +				defined(CONFIG_INPUT_NEUROS_OSD2_MODULE)
> +#define msp_has_keys()	true
> +#else
> +#define msp_has_keys()	false
> +#endif
> +
> +#if defined(CONFIG_RTC_DRV_NEUROS_OSD2) || \
> +				defined(CONFIG_RTC_DRV_NEUROS_OSD2_MODULE)
> +#define msp_has_rtc()		true
> +#else
> +#define msp_has_rtc()		false
> +#endif
> +
> +#if defined(CONFIG_NEUROS_OSD2_IRBLASTER) || \
> +				defined(CONFIG_NEUROS_OSD2_IRBLASTER_MODULE)
> +#define msp_has_irblaster()	true
> +#else
> +#define msp_has_irblaster()	false
> +#endif
> +
> +/*
> + * Inialize particular board specific resources
> + */
> +static int add_children(struct i2c_client *client)
> +{
> +	struct device	*child;
> +
> +	/* RTC */
> +	if (msp_has_rtc()) {
> +		child = add_child(client, "rtc_neuros_osd2",
> +				NULL, 0, false, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +
> +	/* input from IR remote (uses the IRQ) */
> +	if (msp_has_keys()) {
> +		child = add_child(client, "neuros_osd2_ir",
> +				NULL, 0, true, client->irq);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +
> +	/* output to IR blaster  */
> +	if (msp_has_irblaster()) {
> +		child = add_child(client, "neuros_osd2_irblaster",
> +				NULL, 0, true, client->irq);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +	return 0;
> +}
> +#endif
> +
> +/*
> + * Add single resource into the chain of platfrom specific MFD resources.
> + */
> +static struct device *add_child(struct i2c_client *client, const char *name,
> +			void *pdata, unsigned pdata_len,
> +			bool can_wakeup, int irq)
> +{
> +	struct platform_device	*pdev;
> +	int			status;
> +
> +	pdev = platform_device_alloc(name, -1);
> +	if (!pdev) {
> +		dev_dbg(&client->dev, "can't alloc dev\n");
> +		status = -ENOMEM;
> +		goto err;
> +	}
> +
> +	device_init_wakeup(&pdev->dev, can_wakeup);
> +	pdev->dev.parent = &client->dev;
> +
> +	if (pdata) {
> +		status = platform_device_add_data(pdev, pdata, pdata_len);
> +		if (status < 0) {
> +			dev_dbg(&pdev->dev, "can't add platform_data\n");
> +			goto err;
> +		}
> +	}
> +
> +	if (irq) {
> +		struct resource r = {
> +			.start = irq,
> +			.flags = IORESOURCE_IRQ,
> +		};
> +
> +		status = platform_device_add_resources(pdev, &r, 1);
> +		if (status < 0) {
> +			dev_dbg(&pdev->dev, "can't add irq\n");
> +			goto err;
> +		}
> +	}
> +
> +	status = platform_device_add(pdev);
> +
> +err:
> +	if (status < 0) {
> +		platform_device_put(pdev);
> +		dev_err(&client->dev, "can't add %s dev\n", name);
> +		return ERR_PTR(status);
> +	}
> +	return &pdev->dev;
> +}
> +
> +/*----------------------------------------------------------------------*/
> +/*
> + * Driver initialization code
> +*/
> +static int davinci_msp_remove(struct i2c_client *client)
> +{
> +	pm_power_off = NULL;
> +	msp430 = NULL;
> +	return 0;
> +}
> +
> +static int davinci_msp_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	int		status;
> +
> +	if (msp430)
> +		return -EBUSY;
> +	msp430 = client;
> +
> +	/* export capabilities we support */
> +	status = add_children(client);
> +	if (status < 0)
> +		goto fail;
> +
> +#if defined(CONFIG_MACH_DAVINCI_DM355_EVM) /* exclusively for dm355evm 	*/
> +	{
> +		const char	*video = msp_has_tvp() ? "TVP5146" : "imager";
> +
> +	/* display revision status; doubles as sanity check */
> +	status = davinci_msp_read(DM355EVM_MSP_FIRMREV);
> +	if (status < 0)
> +		goto fail;
> +	dev_info(&client->dev, "firmware v.%02X, %s as video-in\n",
> +			status, video);
> +
> +	/* mux video input:  either tvp5146 or some external imager */
> +	status = davinci_msp_write(msp_has_tvp() ? 0 : MSP_VIDEO_IMAGER,
> +			DM355EVM_MSP_VIDEO_IN);
> +	if (status < 0)
> +		dev_warn(&client->dev, "error %d muxing %s as video-in\n",
> +			status, video);
> +
> +	/* init LED cache, and turn off the LEDs */
> +	msp_led_cache = 0xff;
> +	davinci_msp_write(msp_led_cache, DM355EVM_MSP_LED);
> +
> +	/* PM hookup */
> +	pm_power_off = dm355evm_power_off;
> +	}
> +#endif
> +	return 0;
> +
> +fail:
> +	/* FIXME remove children ... */
> +	davinci_msp_remove(client);
> +	return status;
> +}
> +
> +
> +static const struct i2c_device_id davinci_msp_ids[] = {
> +	{ "davinci_msp", 0 },
> +	{ /* end of list */ },
> +};
> +MODULE_DEVICE_TABLE(i2c, davincim_msp_ids);
> +
> +static struct i2c_driver davinci_msp_driver = {
> +	.driver.name	= "davinci_msp",
> +	.id_table	= davinci_msp_ids,
> +	.probe		= davinci_msp_probe,
> +	.remove		= davinci_msp_remove,
> +};
> +
> +static int __init davinci_msp_init(void)
> +{
> +	return i2c_add_driver(&davinci_msp_driver);
> +}
> +subsys_initcall(davinci_msp_init);
> +
> +static void __exit davinci_msp_exit(void)
> +{
> +	i2c_del_driver(&davinci_msp_driver);
> +}
> +module_exit(davinci_msp_exit);
> +
> +MODULE_DESCRIPTION("Interface to MSP430 firmware on Davinci");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/i2c/dm355evm_msp.h b/include/linux/i2c/dm355evm_msp.h
> index 3724703..63cd992 100644
> --- a/include/linux/i2c/dm355evm_msp.h
> +++ b/include/linux/i2c/dm355evm_msp.h
> @@ -14,9 +14,10 @@
>   */
>  
>  /* utilities to access "registers" emulated by msp430 firmware */
> -extern int dm355evm_msp_write(u8 value, u8 reg);
> -extern int dm355evm_msp_read(u8 reg);
> -
> +extern int davinci_msp_write(u8 value, u8 reg);
> +extern int davinci_msp_read(u8 reg);
> +#define	dm355evm_msp_write	davinci_msp_write
> +#define	dm355evm_msp_read	davinci_msp_read
>  
>  /* command/control registers */
>  #define DM355EVM_MSP_COMMAND		0x00
> diff --git a/include/linux/i2c/neuros_osd2_msp.h b/include/linux/i2c/neuros_osd2_msp.h
> new file mode 100644
> index 0000000..4295aef
> --- /dev/null
> +++ b/include/linux/i2c/neuros_osd2_msp.h
> @@ -0,0 +1,45 @@
> +/*
> + * neuros_osd2_msp.h - support MSP430 microcontroller on Neuros OSD2 board
> + * 2009 (c) Andrey A. Porodko <Andrey.Porodko@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +#ifndef __LINUX_I2C_NEUROS_OSD2_MSP
> +#define __LINUX_I2C_NEUROS_OSD2_MSP
> +
> +/* utilities to access "registers" emulated by msp430 firmware */
> +extern int davinci_msp_write(u8 value, u8 reg);
> +extern int davinci_msp_read(u8 reg);
> +#define	ntosd2_msp_write	davinci_msp_write
> +#define	ntosd2_msp_read		davinci_msp_read
> +
> +/* MSP commands (registers) */
> +#define	NTOSD2_MSP430_GETIRCODE	  0xB0
> +#define	NTOSD2_MSP430_GETVER	  0x36
> +#define NTOSD2_MSP430_RTC_MDAY	  0x19
> +#define	NTOSD2_MSP430_RTC_MONTH	  0x1A
> +#define	NTOSD2_MSP430_RTC_YEAR	  0x1B /* year since 2006, 0 = 2006	*/
> +#define	NTOSD2_MSP430_RTC_HOURS	  0x18
> +#define	NTOSD2_MSP430_RTC_MINUTES 0x17
> +#define	NTOSD2_MSP430_RTC_SECONDS 0x16
> +
> +#define	NTOSD2_MSP430_READ_RETRIES 3
> +
> +#define	NTOSD2_MSP430_RESET	  6    /* reset to MSP430 high - active	*/
> +#define	NTOSD2_MSP430_IRR_IRQ	  7    /* Raw data from IR sensor	*/
> +#define	NTOSD2_MSP430_PWM0	  45   /* out, generates 38 kHz for IR Blaster*/
> +#define	NTOSD2_MSP430_ARM_BLSTR	  47   /* Raw data to IR Blaster	*/
> +
> +#define	NTOSD2_MSP430_MAX_PULSES  128  /* max pulses in buffer		*/
> +#define	NTOSD2_MSP430_IO_TIMEOUT  75   /* default I/O timeout in ms	*/
> +#define	NTOSD2_MSP430_POOLING_TIMEOUT 10000/* default sensor polling in us */
> +
> +#define	NTOSD2_IR_BLASTER_IOC_MAGIC 'i'/* code for IR blaster ioctl	*/
> +#define RRB_SET_IO_TIMEOUT 	  _IOW(NTOSD2_IR_BLASTER_IOC_MAGIC, \
> +					1, unsigned long)
> +#define RRB_SET_POOLING_TIMEOUT   _IOW(NTOSD2_IR_BLASTER_IOC_MAGIC, \
> +					2, unsigned long)
> +
> +#endif /* __LINUX_I2C_NEUROS_OSD2_MSP */
> -- 
> 1.5.6.5
> 
> 
> 
> -- 
> Best regards
> Andrey A. Porodko
>  
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
