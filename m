Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbXLLEaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbXLLEaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXLLE3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:29:53 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40321 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751081AbXLLE3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:29:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VboywiDdb8M9O1gjeJaFDdgW6FC9arMoMSlFHs2bfeJmA8XIE0KyPMRes5j3a75Q2b1Wr33hWSBIfHdf4JqtTQW3QW/6ntjtM+UPiAGm+9kA/z2J0erfleoKIIAbVLVvImNV/AcAIM6//rMUR3nLgXRupvk5M7HjoyGjoL8Sa9E=  ;
X-YMail-OSG: zBP8X_IVM1naP5nwfjOLmximl58TLgUJ_lE833w.pUSZDnEqK5A6AlFUTA_NgZgh5Yw0Lq._jQ--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [PATCH 2.6.24-rc4-mm 1/2] gpiolib: basic support for 16-bit PCA9539 GPIO expander[
Date: Tue, 11 Dec 2007 20:29:49 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       i2c@lm-sensors.org
References: <f17812d70712100139q31c95d6er12105ebbe94b3909@mail.gmail.com>
In-Reply-To: <f17812d70712100139q31c95d6er12105ebbe94b3909@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200712112029.49692.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ do we need so much crossposting on these patches? ]

On Monday 10 December 2007, eric miao wrote:

> +    Copyright (C) 2007 Marvell Internation Ltd.

"International"?


> +static int __devinit pca9539_probe(struct i2c_client *client)
> +{
> +	...
> +	/* initialize registers */
> +	chip->reg_output = 0xffff;
> +	chip->reg_direction = 0xffff;
> +
> +	pca9539_write_reg(chip, PCA9539_OUTPUT, chip->reg_output);
> +	pca9539_write_reg(chip, PCA9539_DIRECTION, chip->reg_direction);

I thought you were going to change that code to use whatever values
were previously found in those registers?  What this does is change
those values to act as if the chip just came from reset.  Which isn't
the best approach when a bootloader initialized it, or if the values
were otherwise set up by something ... the previous kernel before a
kexec, this one before "rmmod pca9539", or something similar.


> +MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");

But not you?


Here's a slightly cleaned up version ... address the issues above
and I'd say this one is ready to join the queue (after the other
gpiolib patches).

- Dave

============	SNIP
From: eric miao <eric.miao@marvell.com>

Basic support for 16-bit PCA9539 GPIO expander

 1. use 16-bit register access to simplify the logic, cache OUTPUT
    and DIRECTION registers for fast access

 2. platform code is required to setup
   (a) the numbering of GPIO for PCA9539 (base and number)
   (b) pass "pca9539_platform_data" within "i2c_board_info"

Derived from drivers/i2c/chips/pca9539.c (which has no current known users).

Signed-off-by: eric miao <eric.miao@marvell.com>
Acked-by: Ben Gardner <bgardner@wabtec.com>

 - Alphabetized Kconfig and Makefile
 - Corrected description:  not "Philips", but NXP or TI
 - Use dev_err() not printk
 - Move module_{init,exit} next to those routines
 - Did NOT change clobber of output and direction registers

---
 drivers/gpio/Kconfig        |   10 +
 drivers/gpio/Makefile       |    1 
 drivers/gpio/pca9539.c      |  249 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca9539.h |   18 +++
 4 files changed, 278 insertions(+)

--- a/drivers/gpio/Kconfig	2007-12-11 09:30:43.000000000 -0800
+++ b/drivers/gpio/Kconfig	2007-12-11 17:16:16.000000000 -0800
@@ -9,6 +9,16 @@ menu "GPIO Expanders"
 
 comment "I2C GPIO expanders:"
 
+config GPIO_PCA9539
+	tristate "PCA9539 16-bit I/O port"
+	depends on I2C
+	help
+	  Say yes here to support the PCA9539 16-bit I/O port.  These
+	  parts are made by NXP and TI.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called pca9539.
+
 config GPIO_PCF857X
 	tristate "PCF857x, PCA857x, and PCA967x I2C GPIO expanders"
 	depends on I2C
--- a/drivers/gpio/Makefile	2007-12-11 09:30:43.000000000 -0800
+++ b/drivers/gpio/Makefile	2007-12-11 17:15:18.000000000 -0800
@@ -1,4 +1,5 @@
 # gpio support: dedicated expander chips, etc
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_PCA9539)	+= pca9539.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/gpio/pca9539.c	2007-12-11 19:54:57.000000000 -0800
@@ -0,0 +1,249 @@
+/*
+    pca9539.c - 16-bit I/O port with interrupt and reset
+
+    Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+    Copyright (C) 2007 Marvell Internation Ltd.
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; version 2 of the License.
+*/
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca9539.h>
+
+#include <asm/gpio.h>
+
+
+#define NR_PCA9539_GPIOS	16
+
+#define PCA9539_INPUT		0
+#define PCA9539_OUTPUT		2
+#define PCA9539_INVERT		4
+#define PCA9539_DIRECTION	6
+
+struct pca9539_chip {
+	unsigned gpio_start;
+	uint16_t reg_output;
+	uint16_t reg_direction;
+
+	struct i2c_client *client;
+	struct gpio_chip gpio_chip;
+};
+
+static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
+{
+	return i2c_smbus_write_word_data(chip->client, reg, val);
+}
+
+static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_word_data(chip->client, reg);
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "read error %d\n", ret);
+		return ret;
+	}
+
+	*val = (uint16_t)ret;
+	return 0;
+}
+
+static int pca9539_gpio_direction_input(struct gpio_chip *gc, unsigned off)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	reg_val = chip->reg_direction | (1u << off);
+	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca9539_gpio_direction_output(struct gpio_chip *gc,
+		unsigned off, int val)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	/* set output level */
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_output = reg_val;
+
+	/* then direction */
+	reg_val = chip->reg_direction & ~(1u << off);
+	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
+	if (ret < 0)
+		return ret;
+
+	return (reg_val & (1u << off)) ? 1 : 0;
+}
+
+static void pca9539_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	if (ret)
+		return;
+
+	chip->reg_output = reg_val;
+}
+
+static int pca9539_init_gpio(struct pca9539_chip *chip)
+{
+	struct gpio_chip *gc;
+
+	gc = &chip->gpio_chip;
+
+	gc->direction_input  = pca9539_gpio_direction_input;
+	gc->direction_output = pca9539_gpio_direction_output;
+	gc->get = pca9539_gpio_get_value;
+	gc->set = pca9539_gpio_set_value;
+
+	gc->base = chip->gpio_start;
+	gc->ngpio = NR_PCA9539_GPIOS;
+	gc->label = "pca9539";
+
+	return gpiochip_add(gc);
+}
+
+static int __devinit pca9539_probe(struct i2c_client *client)
+{
+	struct pca9539_platform_data *pdata;
+	struct pca9539_chip *chip;
+	int ret;
+
+	pdata = client->dev.platform_data;
+	if (pdata == NULL)
+		return -ENODEV;
+
+	chip = kzalloc(sizeof(struct pca9539_chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	chip->client = client;
+
+	chip->gpio_start = pdata->gpio_base;
+
+	/* initialize registers */
+	chip->reg_output = 0xffff;
+	chip->reg_direction = 0xffff;
+
+	pca9539_write_reg(chip, PCA9539_OUTPUT, chip->reg_output);
+	pca9539_write_reg(chip, PCA9539_DIRECTION, chip->reg_direction);
+
+	/* set platform specific polarity inversion */
+	pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
+
+	ret = pca9539_init_gpio(chip);
+	if (ret)
+		goto out_failed;
+
+	if (pdata->setup) {
+		ret = pdata->setup(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_dbg(&client->dev, "setup failed, %d\n", ret);
+	}
+
+	i2c_set_clientdata(client, chip);
+	return 0;
+
+out_failed:
+	kfree(chip);
+	return ret;
+}
+
+static int pca9539_remove(struct i2c_client *client)
+{
+	struct pca9539_platform_data *pdata = client->dev.platform_data;
+	struct pca9539_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	if (pdata->teardown) {
+		ret = pdata->teardown(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_dbg(&client->dev, "teardown failed, %d\n", ret);
+	}
+
+	ret = gpiochip_remove(&chip->gpio_chip);
+	if (ret) {
+		dev_err(&client->dev, "failed remove gpio_chip\n");
+		return ret;
+	}
+
+	kfree(chip);
+	return 0;
+}
+
+static struct i2c_driver pca9539_driver = {
+	.driver = {
+		.name	= "pca9539",
+	},
+	.probe		= pca9539_probe,
+	.remove		= pca9539_remove,
+};
+
+static int __init pca9539_init(void)
+{
+	return i2c_add_driver(&pca9539_driver);
+}
+module_init(pca9539_init);
+
+static void __exit pca9539_exit(void)
+{
+	i2c_del_driver(&pca9539_driver);
+}
+module_exit(pca9539_exit);
+
+MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
+MODULE_DESCRIPTION("PCA9539 driver");
+MODULE_LICENSE("GPL");
+
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/linux/i2c/pca9539.h	2007-12-11 09:30:44.000000000 -0800
@@ -0,0 +1,18 @@
+/* platform data for the PCA9539 16-bit I/O expander driver */
+
+struct pca9539_platform_data {
+	/* number of the first GPIO */
+	unsigned	gpio_base;
+
+	/* initial polarity inversion setting */
+	uint16_t	invert;
+
+	void		*context;	/* param to setup/teardown */
+
+	int		(*setup)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+	int		(*teardown)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+};
