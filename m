Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbXLQG1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbXLQG1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXLQG1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:27:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:13751 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbXLQG1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:27:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rrTnvSmKUulctu3n7rFq8ySP9penxR742yXLH7olcaE7j6WYQn0hkOqqiOFBwDbHR88bGmR+1PG73Ais15ohH0V7bpjKkz1N7a8UfmHoZ78gfd4YaSenVHw0x65OLNSoN/fRH043noKmonHl9JIUXURvQGEwjr7sms6rZqN8CWk=
Message-ID: <f17812d70712162227g5aaadf68u68d311bff02db7b1@mail.gmail.com>
Date: Mon, 17 Dec 2007 14:27:35 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 2.6.24-rc5-mm 1/3] gpiolib: basic support for 16-bit PCA9539 GPIO expander
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org,
       bgardner@wabtec.com
In-Reply-To: <f17812d70712162216t2f6125b8ve37b9eb8d44aa872@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70712142014s3e2bf56es9c9e2b24ed164c3e@mail.gmail.com>
	 <20071215234024.2B4DA10C75D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <f17812d70712162216t2f6125b8ve37b9eb8d44aa872@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ forget about the previous patch, sorry for my carelessness not to
free the chip structure, below is the correct one ]

>From c4be69e8dad28dc75e80b393f9c60f740cca7047 Mon Sep 17 00:00:00 2001
From: eric miao <eric.miao@marvell.com>
Date: Mon, 10 Dec 2007 17:19:12 +0800
Subject: [PATCH] gpiolib: basic support for 16-bit PCA9539 GPIO expander

1. use 16-bit register access to simplify the logic, cache OUTPUT
   and DIRECTION registers for fast access

2. platform code is required to setup
   a) the numbering of GPIO for PCA9539 (base and number)
   c) pass "pca9539_platform_data" within "i2c_board_info"

Derived from drivers/i2c/chips/pca9539.c (which has no current known
users).

Signed-off-by: eric miao <eric.miao@marvell.com>
---
 drivers/gpio/Kconfig        |   10 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/pca9539.c      |  260 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca9539.h |   18 +++
 4 files changed, 289 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/pca9539.c
 create mode 100644 include/linux/i2c/pca9539.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index dd9e697..4b54f60 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -9,6 +9,16 @@ menu "GPIO Expanders"

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
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 575bb57..d14fc1e 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -1,4 +1,5 @@
 # gpio support: dedicated expander chips, etc

 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
+obj-$(CONFIG_GPIO_PCA9539)	+= pca9539.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
diff --git a/drivers/gpio/pca9539.c b/drivers/gpio/pca9539.c
new file mode 100644
index 0000000..fc8bee4
--- /dev/null
+++ b/drivers/gpio/pca9539.c
@@ -0,0 +1,260 @@
+/*
+ *  pca9539.c - 16-bit I/O port with interrupt and reset
+ *
+ *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+ *  Copyright (C) 2007 Marvell International Ltd.
+ *
+ *  Derived from drivers/i2c/chips/pca9539.c (which has no current known
+ *  users).
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
+		dev_err(&chip->client->dev, "failed reading register\n");
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
+		return -EIO;
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
+		return -EIO;
+
+	chip->reg_output = reg_val;
+
+	/* then direction */
+	reg_val = chip->reg_direction & ~(1u << off);
+	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	if (ret)
+		return -EIO;
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
+		return -EIO;
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
+	if (ret) {
+		ret = -EIO;
+		goto out_failed;
+	}
+
+	ret = pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
+	if (ret) {
+		ret = -EIO;
+		goto out_failed;
+	}
+
+	/* set platform specific polarity inversion */
+	ret = pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
+	if (ret) {
+		ret = -EIO;
+		goto out_failed;
+	}
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
diff --git a/include/linux/i2c/pca9539.h b/include/linux/i2c/pca9539.h
new file mode 100644
index 0000000..611d84a
--- /dev/null
+++ b/include/linux/i2c/pca9539.h
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
-- 
1.5.2.5.GIT

---
Cheers
- eric
