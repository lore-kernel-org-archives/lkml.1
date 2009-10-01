Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbZJAOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbZJAOIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbZJAOIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:08:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:21498 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932461AbZJAOIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:08:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,487,1249282800"; 
   d="scan'208";a="498835155"
Date: Thu, 1 Oct 2009 16:09:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad
 Input Device Driver
Message-ID: <20091001140948.GD10199@sortiz.org>
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org>
 <1253682664-27040-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253682664-27040-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Some comments on this patch:

On Wed, Sep 23, 2009 at 01:11:04AM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
> 
> Subdevs:
> LCD Backlight   : drivers/video/backlight/adp5520_bl
> LEDs            : drivers/led/leds-adp5520
> GPIO            : drivers/gpio/adp5520-gpio (ADP5520 only)
> Keys            : drivers/input/keyboard/adp5520-keys (ADP5520 only)
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> v2
> 	- fix return type of irq handler
> 	- fix unbalanced paren in BL_CTRL_VAL() macro
> 
>  drivers/mfd/Kconfig         |   10 ++
>  drivers/mfd/Makefile        |    1 +
>  drivers/mfd/adp5520.c       |  371 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/adp5520.h |  303 +++++++++++++++++++++++++++++++++++
>  4 files changed, 685 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/adp5520.c
>  create mode 100644 include/linux/mfd/adp5520.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 570be13..34e8595 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -160,6 +160,16 @@ config PMIC_DA903X
>  	  individual components like LCD backlight, voltage regulators,
>  	  LEDs and battery-charger under the corresponding menus.
>  
> +config PMIC_ADP5520
> +	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
> +	depends on I2C=y
> +	help
> +	  Say yes here to add support for Analog Devices AD5520 and ADP5501,
> +	  Multifunction Power Management IC. This includes
> +	  the I2C driver and the core APIs _only_, you have to select
> +	  individual components like LCD backlight, LEDs, GPIOs and Kepad
> +	  under the corresponding menus.
> +
>  config MFD_WM8400
>  	tristate "Support Wolfson Microelectronics WM8400"
>  	select MFD_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f3b277b..a42248e 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -50,3 +50,4 @@ obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
>  obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
>  obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
>  obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
> +obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> new file mode 100644
> index 0000000..1083626
> --- /dev/null
> +++ b/drivers/mfd/adp5520.c
> @@ -0,0 +1,371 @@
> +/*
> + * Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
> + * LCD Backlight: drivers/video/backlight/adp5520_bl
> + * LEDs		: drivers/led/leds-adp5520
> + * GPIO		: drivers/gpio/adp5520-gpio (ADP5520 only)
> + * Keys		: drivers/input/keyboard/adp5520-keys (ADP5520 only)
> + *
> + * Copyright 2009 Analog Devices Inc.
> + *
> + * Derived from da903x:
> + * Copyright (C) 2008 Compulab, Ltd.
> + * 	Mike Rapoport <mike@compulab.co.il>
> + *
> + * Copyright (C) 2006-2008 Marvell International Ltd.
> + * 	Eric Miao <eric.miao@marvell.com>
> + *
> + * Licensed under the GPL-2 or later.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/workqueue.h>
> +#include <linux/i2c.h>
> +
> +#include <linux/mfd/adp5520.h>
> +
> +struct adp5520_chip {
> +	struct i2c_client *client;
> +	struct device *dev;
> +	struct mutex lock;
> +	struct work_struct irq_work;
> +	struct blocking_notifier_head notifier_list;
> +	int irq;
> +};
> +
> +static int __adp5520_read(struct i2c_client *client,
> +				int reg, uint8_t *val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(client, reg);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
> +		return ret;
> +	}
> +
> +	*val = (uint8_t)ret;
> +	return 0;
> +}
> +
> +static int __adp5520_write(struct i2c_client *client,
> +				 int reg, uint8_t val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(client, reg, val);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed writing 0x%02x to 0x%02x\n",
> +				val, reg);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +int __adp5520_ack_bits(struct i2c_client *client, int reg, uint8_t bit_mask)
> +{
> +	struct adp5520_chip *chip = i2c_get_clientdata(client);
> +	uint8_t reg_val;
> +	int ret;
> +
> +	mutex_lock(&chip->lock);
> +
> +	ret = __adp5520_read(client, reg, &reg_val);
> +
> +	if (!ret) {
> +		reg_val |= bit_mask;
> +		ret = __adp5520_write(client, reg, reg_val);
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +
> +int adp5520_write(struct device *dev, int reg, uint8_t val)
> +{
> +	return __adp5520_write(to_i2c_client(dev), reg, val);
> +}
> +EXPORT_SYMBOL_GPL(adp5520_write);
> +
> +int adp5520_read(struct device *dev, int reg, uint8_t *val)
> +{
> +	return __adp5520_read(to_i2c_client(dev), reg, val);
> +}
> +EXPORT_SYMBOL_GPL(adp5520_read);
> +
> +int adp5520_set_bits(struct device *dev, int reg, uint8_t bit_mask)
> +{
> +	struct adp5520_chip *chip = dev_get_drvdata(dev);
> +	uint8_t reg_val;
> +	int ret;
> +
> +	mutex_lock(&chip->lock);
> +
> +	ret = __adp5520_read(chip->client, reg, &reg_val);
> +
> +	if (!ret && ((reg_val & bit_mask) == 0)) {
> +		reg_val |= bit_mask;
> +		ret = __adp5520_write(chip->client, reg, reg_val);
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(adp5520_set_bits);
> +
> +int adp5520_clr_bits(struct device *dev, int reg, uint8_t bit_mask)
> +{
> +	struct adp5520_chip *chip = dev_get_drvdata(dev);
> +	uint8_t reg_val;
> +	int ret;
> +
> +	mutex_lock(&chip->lock);
> +
> +	ret = __adp5520_read(chip->client, reg, &reg_val);
> +
> +	if (!ret && (reg_val & bit_mask)) {
> +		reg_val &= ~bit_mask;
> +		ret = __adp5520_write(chip->client, reg, reg_val);
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(adp5520_clr_bits);
> +
> +int adp5520_register_notifier(struct device *dev, struct notifier_block *nb,
> +				unsigned int events)
> +{
> +	struct adp5520_chip *chip = dev_get_drvdata(dev);
> +
> +	if (chip->irq) {
> +		adp5520_set_bits(chip->dev, INTERRUPT_ENABLE,
> +			events & (KP_IEN | KR_IEN | OVP_IEN | CMPR_IEN));
> +
> +		return blocking_notifier_chain_register(&chip->notifier_list,
> +			 nb);
> +	}
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(adp5520_register_notifier);
> +
> +int adp5520_unregister_notifier(struct device *dev, struct notifier_block *nb,
> +				unsigned int events)
> +{
> +	struct adp5520_chip *chip = dev_get_drvdata(dev);
> +
> +	adp5520_clr_bits(chip->dev, INTERRUPT_ENABLE,
> +		events & (KP_IEN | KR_IEN | OVP_IEN | CMPR_IEN));
> +
> +	return blocking_notifier_chain_unregister(&chip->notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(adp5520_unregister_notifier);
> +
> +static void adp5520_irq_work(struct work_struct *work)
> +{
> +	struct adp5520_chip *chip =
> +		container_of(work, struct adp5520_chip, irq_work);
> +	unsigned int events;
> +	uint8_t reg_val;
> +	int ret;
> +
> +	ret = __adp5520_read(chip->client, MODE_STATUS, &reg_val);
> +	if (ret)
> +		goto out;
> +
> +	events =  reg_val & (OVP_INT | CMPR_INT | GPI_INT | KR_INT | KP_INT);
> +
> +	blocking_notifier_call_chain(&chip->notifier_list, events, NULL);
> +	/* ACK, Sticky bits are W1C */
> +	__adp5520_ack_bits(chip->client, MODE_STATUS, events);
> +
> +out:
> +	enable_irq(chip->client->irq);
> +}
> +
> +static irqreturn_t adp5520_irq_handler(int irq, void *data)
> +{
> +	struct adp5520_chip *chip = data;
> +
> +	disable_irq_nosync(irq);
> +	schedule_work(&chip->irq_work);
Have you considered using a threaded irq handler here ?


> +	return IRQ_HANDLED;
> +}
> +
> +static int __remove_subdev(struct device *dev, void *unused)
> +{
> +	platform_device_unregister(to_platform_device(dev));
> +	return 0;
> +}
> +
> +static int adp5520_remove_subdevs(struct adp5520_chip *chip)
> +{
> +	return device_for_each_child(chip->dev, NULL, __remove_subdev);
> +}
> +
> +static int __devinit adp5520_add_subdevs(struct adp5520_chip *chip,
> +					struct adp5520_platform_data *pdata)
> +{
> +	struct adp5520_subdev_info *subdev;
> +	struct platform_device *pdev;
> +	int i, ret = 0;
> +
> +	for (i = 0; i < pdata->num_subdevs; i++) {
> +		subdev = &pdata->subdevs[i];
> +
> +		pdev = platform_device_alloc(subdev->name, subdev->id);
> +
> +		pdev->dev.parent = chip->dev;
> +		pdev->dev.platform_data = subdev->platform_data;
> +
> +		ret = platform_device_add(pdev);
> +		if (ret)
> +			goto failed;
> +	}
> +	return 0;
Here I would expect the MFD core driver to know about all the potential
subdevices and add them in that routine, and not take the subdevices list from
the platform definition.
I realize da903x has the same issue btw.

Also, please note that you could use the mfd-core API for adding devices, but
that's just optional.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
