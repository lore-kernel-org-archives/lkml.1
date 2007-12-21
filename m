Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbXLUMp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbXLUMp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbXLUMpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:45:49 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53859 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759244AbXLUMps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:45:48 -0500
From: Ville Syrjala <syrjala@sci.fi>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, Ville Syrjala <syrjala@sci.fi>
Subject: [PATCH] w1-gpio: Add GPIO w1 bus master driver (v2)
Date: Fri, 21 Dec 2007 14:45:46 +0200
Message-Id: <11982411462688-git-send-email-syrjala@sci.fi>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a GPIO 1-wire bus master driver. The driver used the GPIO API to
control the wire and the GPIO pin can be specified using platform data
similar to i2c-gpio. The driver was tested with AT91SAM9260 + DS2401.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
---
Version 2 of the patch changes the sizeof to use the type as requested.
I also had a better look at i2c-gpio and noticed that I should probably
call gpio_request()/gpio_free(). Those functions are no-ops on mach-at91 but
perhaps some other platforms require them. Also I removed the open-drain
requirement like i2c-gpio does by toggling the pin direction.

 Documentation/w1/masters/00-INDEX |    2 +
 Documentation/w1/masters/w1-gpio  |   33 ++++++++++
 drivers/w1/masters/Kconfig        |   10 +++
 drivers/w1/masters/Makefile       |    1 +
 drivers/w1/masters/w1-gpio.c      |  125 +++++++++++++++++++++++++++++++++++++
 include/linux/w1-gpio.h           |   23 +++++++
 6 files changed, 194 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/w1/masters/w1-gpio
 create mode 100644 drivers/w1/masters/w1-gpio.c
 create mode 100644 include/linux/w1-gpio.h

diff --git a/Documentation/w1/masters/00-INDEX b/Documentation/w1/masters/00-INDEX
index 752613c..7b0ceaa 100644
--- a/Documentation/w1/masters/00-INDEX
+++ b/Documentation/w1/masters/00-INDEX
@@ -4,3 +4,5 @@ ds2482
 	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
 ds2490
 	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
+w1-gpio
+	- GPIO 1-wire bus master driver.
diff --git a/Documentation/w1/masters/w1-gpio b/Documentation/w1/masters/w1-gpio
new file mode 100644
index 0000000..af5d3b4
--- /dev/null
+++ b/Documentation/w1/masters/w1-gpio
@@ -0,0 +1,33 @@
+Kernel driver w1-gpio
+=====================
+
+Author: Ville Syrjala <syrjala@sci.fi>
+
+
+Description
+-----------
+
+GPIO 1-wire bus master driver. The driver uses the GPIO API to control the
+wire and the GPIO pin can be specified using platform data.
+
+
+Example (mach-at91)
+-------------------
+
+#include <linux/w1-gpio.h>
+
+static struct w1_gpio_platform_data foo_w1_gpio_pdata = {
+	.pin		= AT91_PIN_PB20,
+	.is_open_drain	= 1,
+};
+
+static struct platform_device foo_w1_device = {
+	.name			= "w1-gpio",
+	.id			= -1,
+	.dev.platform_data	= &foo_w1_gpio_pdata,
+};
+
+...
+	at91_set_GPIO_periph(foo_w1_gpio_pdata.pin, 1);
+	at91_set_multi_drive(foo_w1_gpio_pdata.pin, 1);
+	platform_device_register(&foo_w1_device);
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 8236d44..c449309 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -42,5 +42,15 @@ config W1_MASTER_DS1WM
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
 	  hx4700.
 
+config W1_MASTER_GPIO
+	tristate "GPIO 1-wire busmaster"
+	depends on GENERIC_GPIO
+	help
+	  Say Y here if you want to communicate with your 1-wire devices using
+	  GPIO pins. This driver uses the GPIO API to control the wire.
+
+	  This support is also available as a module.  If so, the module
+	  will be called w1-gpio.ko.
+
 endmenu
 
diff --git a/drivers/w1/masters/Makefile b/drivers/w1/masters/Makefile
index 11551b3..1420b5b 100644
--- a/drivers/w1/masters/Makefile
+++ b/drivers/w1/masters/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_W1_MASTER_MATROX)		+= matrox_w1.o
 obj-$(CONFIG_W1_MASTER_DS2490)		+= ds2490.o
 obj-$(CONFIG_W1_MASTER_DS2482)		+= ds2482.o
 obj-$(CONFIG_W1_MASTER_DS1WM)		+= ds1wm.o
+obj-$(CONFIG_W1_MASTER_GPIO)		+= w1-gpio.o
diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
new file mode 100644
index 0000000..354ee6f
--- /dev/null
+++ b/drivers/w1/masters/w1-gpio.c
@@ -0,0 +1,125 @@
+/*
+ * w1-gpio - GPIO w1 bus master driver
+ *
+ * Copyright (C) 2007 Ville Syrjala <syrjala@sci.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/w1-gpio.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+
+#include <asm/gpio.h>
+
+static void w1_gpio_write_bit_dir(void *data, u8 bit)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	if (bit)
+		gpio_direction_input(pdata->pin);
+	else
+		gpio_direction_output(pdata->pin, 0);
+}
+
+static void w1_gpio_write_bit_val(void *data, u8 bit)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	gpio_set_value(pdata->pin, bit);
+}
+
+static u8 w1_gpio_read_bit(void *data)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	return gpio_get_value(pdata->pin);
+}
+
+static int __init w1_gpio_probe(struct platform_device *pdev)
+{
+	struct w1_bus_master *master;
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	int err;
+
+	if (!pdata)
+		return -ENXIO;
+
+	master = kzalloc(sizeof(struct w1_bus_master), GFP_KERNEL);
+	if (!master)
+		return -ENOMEM;
+
+	err = gpio_request(pdata->pin, "w1");
+	if (err)
+		goto free_master;
+
+	master->data = pdata;
+	master->read_bit = &w1_gpio_read_bit;
+
+	if (pdata->is_open_drain) {
+		gpio_direction_output(pdata->pin, 1);
+		master->write_bit = &w1_gpio_write_bit_val;
+	} else {
+		gpio_direction_input(pdata->pin);
+		master->write_bit = &w1_gpio_write_bit_dir;
+	}
+
+	err = w1_add_master_device(master);
+	if (err)
+		goto free_gpio;
+
+	platform_set_drvdata(pdev, master);
+
+	return 0;
+
+ free_gpio:
+	gpio_free(pdata->pin);
+ free_master:
+	kfree(master);
+
+	return err;
+}
+
+static int __exit w1_gpio_remove(struct platform_device *pdev)
+{
+	struct w1_bus_master *master = platform_get_drvdata(pdev);
+	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+
+	w1_remove_master_device(master);
+	gpio_free(pdata->pin);
+	kfree(master);
+
+	return 0;
+}
+
+static struct platform_driver w1_gpio_driver = {
+	.driver = {
+		.name	= "w1-gpio",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= w1_gpio_probe,
+	.remove	= __exit_p(w1_gpio_remove),
+};
+
+static int __init w1_gpio_init(void)
+{
+	return platform_driver_register(&w1_gpio_driver);
+}
+
+static void __exit w1_gpio_exit(void)
+{
+	platform_driver_unregister(&w1_gpio_driver);
+}
+
+module_init(w1_gpio_init);
+module_exit(w1_gpio_exit);
+
+MODULE_DESCRIPTION("GPIO w1 bus master driver");
+MODULE_AUTHOR("Ville Syrjala <syrjala@sci.fi>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/w1-gpio.h b/include/linux/w1-gpio.h
new file mode 100644
index 0000000..9797fec
--- /dev/null
+++ b/include/linux/w1-gpio.h
@@ -0,0 +1,23 @@
+/*
+ * w1-gpio interface to platform code
+ *
+ * Copyright (C) 2007 Ville Syrjala <syrjala@sci.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+#ifndef _LINUX_W1_GPIO_H
+#define _LINUX_W1_GPIO_H
+
+/**
+ * struct w1_gpio_platform_data - Platform-dependent data for w1-gpio
+ * @pin: GPIO pin to use
+ * @is_open_drain: GPIO pin is configured as open drain
+ */
+struct w1_gpio_platform_data {
+	unsigned int pin;
+	unsigned int is_open_drain:1;
+};
+
+#endif /* _LINUX_W1_GPIO_H */
-- 
1.5.2.5

