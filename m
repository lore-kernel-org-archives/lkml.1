Return-Path: <linux-kernel-owner+w=401wt.eu-S1767504AbXCITPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767504AbXCITPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767506AbXCITPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:15:13 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:55265 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767504AbXCITPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:15:11 -0500
X-Greylist: delayed 1498 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 14:15:10 EST
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] Bitbanging i2c bus driver using the GPIO API
Date: Fri,  9 Mar 2007 19:48:48 +0100
Message-Id: <11734661281633-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <200703090945.38880.david-b@pacbell.net>
References: <200703090945.38880.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a very simple bitbanging i2c bus driver utilizing the new
arch-neutral GPIO API. Useful for chips that don't have a built-in
i2c controller, additional i2c busses, or testing purposes.

To use, include something similar to the following in the
board-specific setup code:

  #include <linux/i2c-gpio.h>

  static struct i2c_gpio_platform_data i2c_gpio_data = {
  	.sda_pin	= GPIO_PIN_FOO,
	.scl_pin	= GPIO_PIN_BAR,
  };
  static struct platform_device i2c_gpio_device = {
  	.name		= "i2c-gpio",
	.id		= 0,
	.dev		= {
		.platform_data	= &i2c_gpio_data,
	},
  };

Register this platform_device, set up the i2c pins as GPIO if
required and you're ready to go.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
I wrote this driver for testing purposes a couple of weeks ago.
Figured I might as well post it since it looks like something like
this is needed.

This driver hasn't yet been updated for the latest change to the GPIO
API. I'll update the patch when the GPIO change makes it into
mainline.

Haavard

 drivers/i2c/busses/Kconfig    |    8 ++
 drivers/i2c/busses/Makefile   |    1 +
 drivers/i2c/busses/i2c-gpio.c |  164 +++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c-gpio.h      |   18 +++++
 include/linux/i2c-id.h        |    1 +
 5 files changed, 192 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index fb19dbb..52f79d1 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -102,6 +102,14 @@ config I2C_ELEKTOR
 	  This support is also available as a module.  If so, the module 
 	  will be called i2c-elektor.
 
+config I2C_GPIO
+	tristate "GPIO-based bitbanging i2c driver"
+	depends on I2C && GENERIC_GPIO
+	select I2C_ALGOBIT
+	help
+	  This is a very simple bitbanging i2c driver utilizing the
+	  arch-neutral GPIO API to control the SCL and SDA lines.
+
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
 	depends on I2C && PCI && PPC_CHRP && EXPERIMENTAL
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 290b540..68f2b05 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
 obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
 obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
 obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
+obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
 obj-$(CONFIG_I2C_HYDRA)		+= i2c-hydra.o
 obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
 obj-$(CONFIG_I2C_I810)		+= i2c-i810.o
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
new file mode 100644
index 0000000..f5ed64e
--- /dev/null
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -0,0 +1,164 @@
+/*
+ * Bitbanging i2c bus driver using the GPIO API
+ *
+ * Copyright (C) 2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include <linux/i2c-gpio.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <asm/gpio.h>
+
+void i2c_gpio_setsda(void *data, int state)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	if (state)
+		gpio_direction_input(pdata->sda_pin);
+	else
+		gpio_direction_output(pdata->sda_pin);
+}
+
+void i2c_gpio_setscl(void *data, int state)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	if (state)
+		gpio_direction_input(pdata->scl_pin);
+	else
+		gpio_direction_output(pdata->scl_pin);
+}
+
+int i2c_gpio_getsda(void *data)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	return gpio_get_value(pdata->sda_pin);
+}
+
+int i2c_gpio_getscl(void *data)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	return gpio_get_value(pdata->scl_pin);
+}
+
+static int __init i2c_gpio_probe(struct platform_device *pdev)
+{
+	struct i2c_gpio_platform_data *pdata;
+	struct i2c_algo_bit_data *bit_data;
+	struct i2c_adapter *adap;
+	int ret;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -ENXIO;
+
+	ret = -ENOMEM;
+	adap = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
+	if (!adap)
+		goto err_alloc_adap;
+	bit_data = kzalloc(sizeof(struct i2c_algo_bit_data), GFP_KERNEL);
+	if (!bit_data)
+		goto err_alloc_bit_data;
+
+	ret = gpio_request(pdata->sda_pin, "sda");
+	if (ret)
+		goto err_request_sda;
+	ret = gpio_request(pdata->scl_pin, "scl");
+	if (ret)
+		goto err_request_scl;
+
+	gpio_direction_input(pdata->sda_pin);
+	gpio_direction_input(pdata->scl_pin);
+	gpio_set_value(pdata->sda_pin, 0);
+	gpio_set_value(pdata->scl_pin, 0);
+
+	bit_data->setsda	= i2c_gpio_setsda,
+	bit_data->setscl	= i2c_gpio_setscl,
+	bit_data->getsda	= i2c_gpio_getsda,
+	bit_data->getscl	= i2c_gpio_getscl,
+	bit_data->udelay	= 5,			/* 100 kHz */
+	bit_data->timeout	= HZ / 10,		/* 100 ms */
+	bit_data->data		= pdata;
+
+	adap->owner = THIS_MODULE;
+	snprintf(adap->name, I2C_NAME_SIZE, "i2c-gpio%d", pdev->id);
+	adap->algo_data = bit_data;
+	adap->dev.parent = &pdev->dev;
+
+	ret = i2c_bit_add_bus(adap);
+	if (ret)
+		goto err_add_bus;
+
+	platform_set_drvdata(pdev, adap);
+
+	printk(KERN_INFO "i2c-gpio: using pins 0x%x (sda) 0x%x (scl)\n",
+	       pdata->sda_pin, pdata->scl_pin);
+
+	return 0;
+
+err_add_bus:
+	gpio_free(pdata->scl_pin);
+err_request_scl:
+	gpio_free(pdata->sda_pin);
+err_request_sda:
+	kfree(bit_data);
+err_alloc_bit_data:
+	kfree(adap);
+err_alloc_adap:
+	return ret;
+}
+
+static int __exit i2c_gpio_remove(struct platform_device *pdev)
+{
+	struct i2c_gpio_platform_data *pdata;
+	struct i2c_adapter *adap;
+
+	adap = platform_get_drvdata(pdev);
+	pdata = pdev->dev.platform_data;
+
+	i2c_del_adapter(adap);
+	gpio_free(pdata->scl_pin);
+	gpio_free(pdata->sda_pin);
+	kfree(adap);
+
+	return 0;
+}
+
+static struct platform_driver i2c_gpio_driver = {
+	.driver		= {
+		.name	= "i2c-gpio",
+		.owner	= THIS_MODULE,
+	},
+	.remove		= __exit_p(i2c_gpio_remove),
+};
+
+static int __init i2c_gpio_init(void)
+{
+	int ret;
+
+	ret = platform_driver_probe(&i2c_gpio_driver, i2c_gpio_probe);
+	if (ret)
+		printk("i2c-gpio: probe failed: %d\n", ret);
+
+	return ret;
+}
+module_init(i2c_gpio_init);
+
+static void __exit i2c_gpio_exit(void)
+{
+	platform_driver_unregister(&i2c_gpio_driver);
+}
+module_exit(i2c_gpio_exit);
+
+MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_DESCRIPTION("Platform-independent bitbanging i2c driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c-gpio.h b/include/linux/i2c-gpio.h
new file mode 100644
index 0000000..57f0a0d
--- /dev/null
+++ b/include/linux/i2c-gpio.h
@@ -0,0 +1,18 @@
+/*
+ * i2c-gpio interface to platform code
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _LINUX_I2C_GPIO_H
+#define _LINUX_I2C_GPIO_H
+
+struct i2c_gpio_platform_data {
+	unsigned int sda_pin;
+	unsigned int scl_pin;
+};
+
+#endif /* _LINUX_I2C_GPIO_H */
diff --git a/include/linux/i2c-id.h b/include/linux/i2c-id.h
index 9c21dc7..34230a6 100644
--- a/include/linux/i2c-id.h
+++ b/include/linux/i2c-id.h
@@ -194,6 +194,7 @@
 #define I2C_HW_B_EM28XX		0x01001f /* em28xx video capture cards */
 #define I2C_HW_B_CX2341X	0x010020 /* Conexant CX2341X MPEG encoder cards */
 #define I2C_HW_B_INTELFB	0x010021 /* intel framebuffer driver */
+#define I2C_HW_B_GPIO		0x010022 /* Generic GPIO-based driver */
 
 /* --- PCF 8584 based algorithms					*/
 #define I2C_HW_P_LP		0x020000 /* Parallel port interface */
-- 
1.4.4.4

