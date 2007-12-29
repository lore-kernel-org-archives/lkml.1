Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbXL2EHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbXL2EHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXL2EEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:04:47 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21951 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755117AbXL2EEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:04:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=kx1xIW6hxaMGdZKeSSrnImf5EkX772mAgoNmoDlk95Au+yKcTh9h6Cn7KrWnjxpbY8QDB0cSkRh4baGcJu/rQZoLtrc0OBd+ExSPk2V8RZStTNwkNjOJkcK6l4dKfPjzpHmaDyNCaZR2iEmXwX8m9xaqQTfFmLYAH8WOT06/L0s=  ;
X-YMail-OSG: ywtUF_kVM1krlbjThF0j8IdXsdBtLz3vUOe5h53qletCvw6cX_JvObdUvVW6Bt9aqcanDBwJNg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc6-mm 8/9] gpiolib: pca9539 i2c gpio expander support
Date: Fri, 28 Dec 2007 19:58:53 -0800
User-Agent: KMail/1.9.6
Cc: Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>
References: <200712281927.32575.david-b@pacbell.net>
In-Reply-To: <200712281927.32575.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712281958.53694.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: eric miao <eric.miao@marvell.com>

This adds a new-style I2C driver with basic support for the sixteen
bit PCA9539 GPIO expanders.  These chips have multiple registers,
push-pull output drivers, and (not supported by this patch) pin
change interrupts.

Board-specific code must provide "pca9539_platform_data" with each
chip's "i2c_board_info".  That provides the GPIO numbers to be used
by that chip, and callbacks for board-specific setup/teardown logic.

Derived from drivers/i2c/chips/pca9539.c (which has no current known
users).  This is faster and simpler; it uses 16-bit register access,
and caches the OUTPUT and DIRECTION registers for fast access.

Signed-off-by: eric miao <eric.miao@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/Kconfig        |   10 +
 drivers/gpio/Makefile       |    1 
 drivers/gpio/pca9539.c      |  264 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca9539.h |   18 +++
 4 files changed, 293 insertions(+)

--- at91.orig/drivers/gpio/Kconfig
+++ at91/drivers/gpio/Kconfig
@@ -27,6 +27,16 @@ config DEBUG_GPIO
 
 comment "I2C GPIO expanders:"
 
+config GPIO_PCA9539
+	tristate "PCA9539 16-bit I/O port"
+	depends on I2C
+	help
+	  Say yes here to support the PCA9539 16-bit I/O port. These
+	  parts are made by NXP and TI.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called pca9539.
+
 config GPIO_PCF857X
 	tristate "PCF857x, PCA857x, and PCA967x I2C GPIO expanders"
 	depends on I2C
--- at91.orig/drivers/gpio/Makefile
+++ at91/drivers/gpio/Makefile
@@ -1,6 +1,7 @@
 # gpio support: dedicated expander chips, etc
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_PCA9539)	+= pca9539.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 
 ifeq ($(CONFIG_DEBUG_GPIO),y)
--- /dev/null
+++ at91/drivers/gpio/pca9539.c
@@ -0,0 +1,264 @@
+/*
+ *  pca9539.c - 16-bit I/O port with interrupt and reset
+ *
+ *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+ *  Copyright (C) 2007 Marvell International Ltd.
+ *
+ *  Derived from drivers/i2c/chips/pca9539.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ */
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
+/* NOTE:  we can't currently rely on fault codes to come from SMBus
+ * calls, so we map all errors to EIO here and return zero otherwise.
+ */
+static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
+{
+	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
+		return -EIO;
+	else
+		return 0;
+}
+
+static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_word_data(chip->client, reg);
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed reading register\n");
+		return -EIO;
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
+	if (ret < 0) {
+		/* NOTE:  diagnostic already omitted; that's the
+		 * best we can do here.
+		 */
+		return 0;
+	}
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
+	/* initialize cached registers from their original values */
+	ret = pca9539_read_reg(chip, PCA9539_OUTPUT, &chip->reg_output);
+	if (ret)
+		goto out_failed;
+
+	ret = pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
+	if (ret)
+		goto out_failed;
+
+	/* set platform specific polarity inversion */
+	ret = pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
+	if (ret)
+		goto out_failed;
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
+MODULE_AUTHOR("eric miao <eric.miao@marvell.com>");
+MODULE_DESCRIPTION("GPIO expander driver for PCA9539");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ at91/include/linux/i2c/pca9539.h
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
