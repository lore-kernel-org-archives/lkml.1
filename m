Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879Ab0AHQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0AHQYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822Ab0AHQYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:24:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:38076 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0AHQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:24:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o8uXYUAU1INmPUunxPeh7ep9pnN/5wcgNsnbnOuupmaBOg0EFtdKLyJs6GI2/mL5d2
         GReRxsRgyq9Uau2T8EgUVGzRXtGdpOvuA9qDQfRF5/o+OraK5fgcZ8gStModn1s+7zBN
         r702qNCHowtHu2w29hkV31bxYbHTTb5ERcBZo=
Subject: Re: [PATCH] backlight: lcd: Add Epson L4F00242T03 LCD driver.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Eric Miao <eric.y.miao@gmail.com>
In-Reply-To: <1261150931.3356.54.camel@climbing-alby>
References: <1261150931.3356.54.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:24:37 +0100
Message-ID: <1262967877.2050.32.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping for that patch.
Any comments on this?

Alberto.

Il giorno ven, 18/12/2009 alle 16.42 +0100, Alberto Panizzo ha scritto:
> The Epson LCD L4F00242T03 is mounted on the Freescale i.MX31 PDK
> board.
> Based upon Marek Vasut work in l4f00242t03.c, this driver provide
> basilar init and power on/off functionality for this device.
> Those functionality are accessible also through the /sys/class/lcd
> interface.
> Unfortunately Datasheet for this device are not available. 
> All the control sequences sent to the display were copied from the
> peer freescale driver that leave in the i.MX31 Linux BSP.
> 
> The driver is tested to work as a module and build-in too.
> As in the i.MX31PDK board the core and io suppliers are voltage
> regulators, that functionality is embedded here, but not strict.
> 
> This patch apply to a 2.6.32-rc6 linus kernel.
> 
> Alberto!
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
>  drivers/video/backlight/Kconfig       |    7 +
>  drivers/video/backlight/Makefile      |    1 +
>  drivers/video/backlight/l4f00242t03.c |  244 +++++++++++++++++++++++++++++++++
>  include/linux/spi/l4f00242t03.h       |   31 ++++
>  4 files changed, 283 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/backlight/l4f00242t03.c
>  create mode 100644 include/linux/spi/l4f00242t03.h
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 09bfa96..57ae4c0 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -31,6 +31,13 @@ config LCD_CORGI
>  	  Say y here to support the LCD panels usually found on SHARP
>  	  corgi (C7x0) and spitz (Cxx00) models.
>  
> +config LCD_L4F00242T03
> +	tristate "Epson L4F00242T03 LCD"
> +	depends on LCD_CLASS_DEVICE && SPI_MASTER && GENERIC_GPIO
> +	help
> +	  SPI driver for Epson L4F00242T03. This provides basic support
> +	  for init and powering the LCD up/down through a sysfs interface.
> +
>  config LCD_LMS283GF05
>  	tristate "Samsung LMS283GF05 LCD"
>  	depends on LCD_CLASS_DEVICE && SPI_MASTER && GENERIC_GPIO
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index 9a40554..e3e9e5f 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -3,6 +3,7 @@
>  obj-$(CONFIG_LCD_CLASS_DEVICE)     += lcd.o
>  obj-$(CONFIG_LCD_CORGI)		   += corgi_lcd.o
>  obj-$(CONFIG_LCD_HP700)		   += jornada720_lcd.o
> +obj-$(CONFIG_LCD_L4F00242T03)	   += l4f00242t03.o
>  obj-$(CONFIG_LCD_LMS283GF05)	   += lms283gf05.o
>  obj-$(CONFIG_LCD_LTV350QV)	   += ltv350qv.o
>  obj-$(CONFIG_LCD_ILI9320)	   += ili9320.o
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> new file mode 100644
> index 0000000..a0a020f
> --- /dev/null
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -0,0 +1,256 @@
> +/*
> + * l4f00242t03.c -- support for Epson L4F00242T03 LCD
> + *
> + * Copyright 2007-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * Copyright (c) 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
> + * 	Inspired by Marek Vasut work in l4f00242t03.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/gpio.h>
> +#include <linux/lcd.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include <linux/spi/spi.h>
> +#include <linux/spi/l4f00242t03.h>
> +
> +struct l4f00242t03_priv {
> +	struct spi_device	*spi;
> +	struct lcd_device	*ld;
> +	int lcd_on:1;
> +	struct regulator *io_reg;
> +	struct regulator *core_reg;
> +};
> +
> +
> +static void l4f00242t03_reset(unsigned int gpio)
> +{
> +	pr_debug("l4f00242t03_reset.\n");
> +	gpio_set_value(gpio, 1);
> +	mdelay(100);
> +	gpio_set_value(gpio, 0);
> +	mdelay(10);	/* tRES >= 100us */
> +	gpio_set_value(gpio, 1);
> +	mdelay(20);
> +}
> +
> +#define param(x) ((x) | 0x100)
> +
> +static void l4f00242t03_lcd_init(struct spi_device *spi)
> +{
> +	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
> +	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
> +	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
> +
> +	dev_dbg(&spi->dev, "initializing LCD\n");
> +
> +	if (priv->io_reg) {
> +		regulator_set_voltage(priv->io_reg, 1800000, 1800000);
> +		regulator_enable(priv->io_reg);
> +	}
> +
> +	if (priv->core_reg) {
> +		regulator_set_voltage(priv->core_reg, 2800000, 2800000);
> +		regulator_enable(priv->core_reg);
> +	}
> +
> +	gpio_set_value(pdata->data_enable_gpio, 1);
> +	msleep(60);
> +	spi_write(spi, (const u8 *)cmd, ARRAY_SIZE(cmd) * sizeof(u16));
> +}
> +
> +static int l4f00242t03_lcd_power_set(struct lcd_device *ld, int power)
> +{
> +	struct l4f00242t03_priv *priv = lcd_get_data(ld);
> +	struct spi_device *spi = priv->spi;
> +
> +	const u16 slpout = 0x11;
> +	const u16 dison = 0x29;
> +
> +	const u16 slpin = 0x10;
> +	const u16 disoff = 0x28;
> +
> +	if (power) {
> +		if (priv->lcd_on)
> +			return 0;
> +
> +		dev_dbg(&spi->dev, "turning on LCD\n");
> +
> +		spi_write(spi, (const u8 *)&slpout, sizeof(u16));
> +		msleep(60);
> +		spi_write(spi, (const u8 *)&dison, sizeof(u16));
> +
> +		priv->lcd_on = 1;
> +	} else {
> +		if (!priv->lcd_on)
> +			return 0;
> +
> +		dev_dbg(&spi->dev, "turning off LCD\n");
> +
> +		spi_write(spi, (const u8 *)&disoff, sizeof(u16));
> +		msleep(60);
> +		spi_write(spi, (const u8 *)&slpin, sizeof(u16));
> +
> +		priv->lcd_on = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct lcd_ops l4f_ops = {
> +	.set_power	= l4f00242t03_lcd_power_set,
> +	.get_power	= NULL,
> +};
> +
> +static int __devinit l4f00242t03_probe(struct spi_device *spi)
> +{
> +	struct l4f00242t03_priv *priv;
> +	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
> +	int ret;
> +
> +	if (pdata == NULL) {
> +		dev_err(&spi->dev, "Uninitialized platform data.\n");
> +		return -EINVAL;
> +	}
> +
> +	priv = kzalloc(sizeof(struct l4f00242t03_priv), GFP_KERNEL);
> +
> +	if (priv == NULL) {
> +		dev_err(&spi->dev, "No memory for this device.\n");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	dev_set_drvdata(&spi->dev, priv);
> +	spi->bits_per_word = 9;
> +	spi_setup(spi);
> +
> +	priv->spi = spi;
> +
> +	ret = gpio_request(pdata->reset_gpio, "lcd l4f00242t03 reset");
> +	if (ret) {
> +		dev_err(&spi->dev,
> +			"Unable to get the lcd l4f00242t03 reset gpio.\n");
> +		return ret;
> +	}
> +
> +	ret = gpio_direction_output(pdata->reset_gpio, 1);
> +	if (ret)
> +		goto err2;
> +
> +	ret = gpio_request(pdata->data_enable_gpio,
> +				"lcd l4f00242t03 data enable");
> +	if (ret) {
> +		dev_err(&spi->dev,
> +			"Unable to get the lcd l4f00242t03 data en gpio.\n");
> +		return ret;
> +	}
> +
> +	ret = gpio_direction_output(pdata->data_enable_gpio, 0);
> +	if (ret)
> +		goto err3;
> +
> +	if (pdata->io_supply) {
> +		priv->io_reg = regulator_get(NULL, pdata->io_supply);
> +
> +		if (IS_ERR(priv->io_reg)) {
> +			pr_err("%s: Unable to get the IO regulator\n",
> +								__func__);
> +			goto err3;
> +		}
> +	}
> +
> +	if (pdata->core_supply) {
> +		priv->core_reg = regulator_get(NULL, pdata->core_supply);
> +
> +		if (IS_ERR(priv->core_reg)) {
> +			pr_err("%s: Unable to get the core regulator\n",
> +								__func__);
> +			goto err4;
> +		}
> +	}
> +
> +	priv->ld = lcd_device_register("l4f00242t03",
> +					&spi->dev, priv, &l4f_ops);
> +	if (IS_ERR(priv->ld)) {
> +		ret = PTR_ERR(priv->ld);
> +		goto err5;
> +	}
> +
> +	/* Init the LCD */
> +	l4f00242t03_reset(pdata->reset_gpio);
> +	l4f00242t03_lcd_init(spi);
> +	l4f00242t03_lcd_power_set(priv->ld, 1);
> +
> +	dev_info(&spi->dev, "Epson l4f00242t03 lcd probed.\n");
> +
> +	return 0;
> +
> +err5:
> +	if (priv->core_reg)
> +		regulator_put(priv->core_reg);
> +err4:
> +	if (priv->io_reg)
> +		regulator_put(priv->io_reg);
> +err3:
> +	gpio_free(pdata->data_enable_gpio);
> +err2:
> +	gpio_free(pdata->reset_gpio);
> +err:
> +	kfree(priv);
> +
> +	return ret;
> +}
> +
> +static int __devexit l4f00242t03_remove(struct spi_device *spi)
> +{
> +	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
> +	struct l4f00242t03_pdata *pdata = priv->spi->dev.platform_data;
> +
> +	l4f00242t03_lcd_power_set(priv->ld, 0);
> +	lcd_device_unregister(priv->ld);
> +
> +	gpio_free(pdata->data_enable_gpio);
> +	gpio_free(pdata->reset_gpio);
> +
> +	if (priv->io_reg)
> +		regulator_put(priv->core_reg);
> +	if (priv->core_reg)
> +		regulator_put(priv->io_reg);
> +
> +	kfree(priv);
> +
> +	return 0;
> +}
> +
> +static struct spi_driver l4f00242t03_driver = {
> +	.driver = {
> +		.name	= "l4f00242t03",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= l4f00242t03_probe,
> +	.remove		= __devexit_p(l4f00242t03_remove),
> +};
> +
> +static __init int l4f00242t03_init(void)
> +{
> +	return spi_register_driver(&l4f00242t03_driver);
> +}
> +
> +static __exit void l4f00242t03_exit(void)
> +{
> +	spi_unregister_driver(&l4f00242t03_driver);
> +}
> +
> +module_init(l4f00242t03_init);
> +module_exit(l4f00242t03_exit);
> +
> +MODULE_AUTHOR("Alberto Panizzo <maramaopercheseimorto@gmail.com>");
> +MODULE_DESCRIPTION("EPSON L4F00242T03 LCD");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/spi/l4f00242t03.h b/include/linux/spi/l4f00242t03.h
> new file mode 100644
> index 0000000..3efb8e1
> --- /dev/null
> +++ b/include/linux/spi/l4f00242t03.h
> @@ -0,0 +1,31 @@
> +/*
> + * l4f00242t03.h -- Platform glue for Epson L4F00242T03 LCD
> + *
> + * Copyright (c) 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
> + * Based on Marek Vasut work in lms283gf05.h
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> +*/
> +
> +#ifndef _INCLUDE_LINUX_SPI_L4F00242T03_H_
> +#define _INCLUDE_LINUX_SPI_L4F00242T03_H_
> +
> +struct l4f00242t03_pdata {
> +	unsigned int	reset_gpio;
> +	unsigned int	data_enable_gpio;
> +	const char 	*io_supply;	/* will be set to 1.8 V */
> +	const char 	*core_supply;	/* will be set to 2.8 V */
> +};
> +
> +#endif /* _INCLUDE_LINUX_SPI_L4F00242T03_H_ */


