Return-Path: <linux-kernel-owner+w=401wt.eu-S1030879AbXDNOfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030879AbXDNOfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 10:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030887AbXDNOfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 10:35:19 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:52199 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030879AbXDNOfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 10:35:18 -0400
Date: Sat, 14 Apr 2007 16:34:18 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Jean Delvare <khali@linux-fr.org>, David Brownell <david-b@pacbell.net>,
       Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
In-Reply-To: <11765554074106-git-send-email-hskinnemoen@atmel.com>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007 14:56:47 +0200
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

>   o Default to a very low SCL frequency (6.6 kHz) if clock stretching
>     isn't supported

This would have been true if I had remembered to save before generating
the patch...

Updated patch below. Sorry about the mess.

Haavard

===================[cut here]======================
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] Bitbanging i2c bus driver using the GPIO API

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
required and you're ready to go. This will use default values for
udelay and timeout, and will work with GPIO hardware that does not
support open drain mode, but allows sensing of the SDA and SCL lines
even when they are being driven.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 MAINTAINERS                   |    5 +
 drivers/i2c/busses/Kconfig    |    8 ++
 drivers/i2c/busses/Makefile   |    1 +
 drivers/i2c/busses/i2c-gpio.c |  215 +++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c-gpio.h      |   38 +++++++
 5 files changed, 267 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ef84419..fdecda4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1429,6 +1429,11 @@ L:	linux-scsi@vger.kernel.org
 W:	http://www.icp-vortex.com/
 S:	Supported
 
+GENERIC GPIO I2C DRIVER
+P:	Haavard Skinnemoen
+M:	hskinnemoen@atmel.com
+S:	Supported
+
 GENERIC HDLC DRIVER, N2, C101, PCI200SYN and WANXL DRIVERS
 P:	Krzysztof Halasa
 M:	khc@pm.waw.pl
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
index 0000000..e427bfb
--- /dev/null
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -0,0 +1,215 @@
+/*
+ * Bitbanging i2c bus driver using the GPIO API
+ *
+ * Copyright (C) 2007 Atmel Corporation
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
+/* Toggle SDA by changing the direction of the pin */
+static void i2c_gpio_setsda_dir(void *data, int state)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	if (state)
+		gpio_direction_input(pdata->sda_pin);
+	else
+		gpio_direction_output(pdata->sda_pin, 0);
+}
+
+/*
+ * Toggle SDA by changing the output value of the pin. This is only
+ * valid for pins configured as open drain (i.e. setting the value
+ * high effectively turns off the output driver.)
+ */
+static void i2c_gpio_setsda_val(void *data, int state)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	gpio_set_value(pdata->sda_pin, state);
+}
+
+/* Toggle SCL by changing the direction of the pin. */
+static void i2c_gpio_setscl_dir(void *data, int state)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	if (state)
+		gpio_direction_input(pdata->scl_pin);
+	else
+		gpio_direction_output(pdata->scl_pin, 0);
+}
+
+/*
+ * Toggle SCL by changing the output value of the pin. This is used
+ * for pins that are configured as open drain and for output-only
+ * pins. The latter case will break the i2c protocol, but it will
+ * often work in practice.
+ */
+static void i2c_gpio_setscl_val(void *data, int state)
+{
+	struct i2c_gpio_platform_data *pdata = data;
+
+	gpio_set_value(pdata->scl_pin, state);
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
+	if (pdata->sda_is_open_drain) {
+		gpio_direction_output(pdata->sda_pin, 1);
+		bit_data->setsda = i2c_gpio_setsda_val;
+	} else {
+		gpio_direction_input(pdata->sda_pin);
+		bit_data->setsda = i2c_gpio_setsda_dir;
+	}
+
+	if (pdata->scl_is_open_drain || pdata->scl_is_output_only) {
+		gpio_direction_output(pdata->scl_pin, 1);
+		bit_data->setscl = i2c_gpio_setscl_val;
+	} else {
+		gpio_direction_input(pdata->scl_pin);
+		bit_data->setscl = i2c_gpio_setscl_dir;
+	}
+
+	if (!pdata->scl_is_output_only)
+		bit_data->getscl = i2c_gpio_getscl;
+	bit_data->getsda = i2c_gpio_getsda;
+
+	if (pdata->udelay)
+		bit_data->udelay = pdata->udelay;
+	else if (pdata->scl_is_output_only)
+		bit_data->udelay = 50;			/* 6.6 kHz */
+	else
+		bit_data->udelay = 5;			/* 66 kHz */
+
+	if (pdata->timeout)
+		bit_data->timeout = pdata->timeout;
+	else
+		bit_data->timeout = HZ / 10;		/* 100 ms */
+
+	bit_data->data = pdata;
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
+	dev_info(&pdev->dev, "using pins %u (sda) and %u (scl%s)\n",
+		 pdata->sda_pin, pdata->scl_pin,
+		 pdata->scl_is_output_only
+		 ? ", no clock stretching" : "");
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
+	kfree(adap->algo_data);
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
+		printk(KERN_ERR "i2c-gpio: probe failed: %d\n", ret);
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
index 0000000..7812407
--- /dev/null
+++ b/include/linux/i2c-gpio.h
@@ -0,0 +1,38 @@
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
+/**
+ * struct i2c_gpio_platform_data - Platform-dependent data for i2c-gpio
+ * @sda_pin: GPIO pin ID to use for SDA
+ * @scl_pin: GPIO pin ID to use for SCL
+ * @udelay: signal toggle delay. SCL frequency is (333 / udelay) kHz
+ * @timeout: clock stretching timeout in jiffies. If the slave keeps
+ *	SCL low for longer than this, the transfer will time out.
+ * @sda_is_open_drain: SDA is configured as open drain, i.e. the pin
+ *	isn't actively driven high when setting the output value high.
+ *	gpio_get_value() must return the actual pin state even if the
+ *	pin is configured as an output.
+ * @scl_is_open_drain: SCL is set up as open drain. Same requirements
+ *	as for sda_is_open_drain apply.
+ * @scl_is_output_only: SCL output drivers cannot be turned off.
+ */
+struct i2c_gpio_platform_data {
+	unsigned int	sda_pin;
+	unsigned int	scl_pin;
+	int		udelay;
+	int		timeout;
+	unsigned int	sda_is_open_drain:1;
+	unsigned int	scl_is_open_drain:1;
+	unsigned int	scl_is_output_only:1;
+};
+
+#endif /* _LINUX_I2C_GPIO_H */
-- 
1.4.4.4

