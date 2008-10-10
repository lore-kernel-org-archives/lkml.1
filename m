Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbYJJO7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbYJJO7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760849AbYJJO6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:58:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42837 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760772AbYJJO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:58:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 09/14] mfd: Add I2C control support for WM8350
Date: Fri, 10 Oct 2008 15:58:11 +0100
Message-Id: <1223650696-15552-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223650696-15552-8-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1223649928.6814.333.camel@dell-desktop.example.com>
 <1223650696-15552-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-6-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-7-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-8-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the I2C control interface for the WM8350. This code was
originally written by Liam Girdwood and has been updated for submission
by Mark Brown.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig      |   11 ++++
 drivers/mfd/Makefile     |    1 +
 drivers/mfd/wm8350-i2c.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wm8350-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c903aa3..911439a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -105,6 +105,17 @@ config MFD_WM8350_CONFIG_MODE_3
 	bool
 	depends on MFD_WM8350
 
+config MFD_WM8350_I2C
+	tristate "Support Wolfson Microelectronics WM8350 with I2C"
+	select MFD_WM8350
+	depends on I2C
+	help
+	  The WM8350 is an integrated audio and power management
+	  subsystem with watchdog and RTC functionality for embedded
+	  systems.  This option enables core support for the WM8350 with
+	  I2C as the control interface.  Additional options must be
+	  selected to enable support for the functionality of the chip.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b0adca0..746d37b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o
 obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
 wm8350-objs			:= wm8350-core.o wm8350-regmap.o
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
+obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
new file mode 100644
index 0000000..2b0569c
--- /dev/null
+++ b/drivers/mfd/wm8350-i2c.c
@@ -0,0 +1,120 @@
+/*
+ * wm8350-i2c.c  --  Generic I2C driver for Wolfson WM8350 PMIC
+ *
+ * This driver defines and configures the WM8350 for the Freescale i.MX32ADS.
+ *
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood
+ *         linux@wolfsonmicro.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/wm8350/core.h>
+
+static int wm8350_i2c_read_device(struct wm8350 *wm8350, char reg,
+				  int bytes, void *dest)
+{
+	int ret;
+
+	ret = i2c_master_send(wm8350->i2c_client, &reg, 1);
+	if (ret < 0)
+		return ret;
+	return i2c_master_recv(wm8350->i2c_client, dest, bytes);
+}
+
+static int wm8350_i2c_write_device(struct wm8350 *wm8350, char reg,
+				   int bytes, void *src)
+{
+	/* we add 1 byte for device register */
+	u8 msg[(WM8350_MAX_REGISTER << 1) + 1];
+
+	if (bytes > ((WM8350_MAX_REGISTER << 1) + 1))
+		return -EINVAL;
+
+	msg[0] = reg;
+	memcpy(&msg[1], src, bytes);
+	return i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
+}
+
+static int wm8350_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct wm8350 *wm8350;
+	int ret = 0;
+
+	wm8350 = kzalloc(sizeof(struct wm8350), GFP_KERNEL);
+	if (wm8350 == NULL) {
+		kfree(i2c);
+		return -ENOMEM;
+	}
+
+	i2c_set_clientdata(i2c, wm8350);
+	wm8350->dev = &i2c->dev;
+	wm8350->i2c_client = i2c;
+	wm8350->read_dev = wm8350_i2c_read_device;
+	wm8350->write_dev = wm8350_i2c_write_device;
+
+	ret = wm8350_device_init(wm8350);
+	if (ret < 0)
+		goto err;
+
+	return ret;
+
+err:
+	kfree(wm8350);
+	return ret;
+}
+
+static int wm8350_i2c_remove(struct i2c_client *i2c)
+{
+	struct wm8350 *wm8350 = i2c_get_clientdata(i2c);
+
+	wm8350_device_exit(wm8350);
+	kfree(wm8350);
+
+	return 0;
+}
+
+static const struct i2c_device_id wm8350_i2c_id[] = {
+       { "wm8350", 0 },
+       { }
+};
+MODULE_DEVICE_TABLE(i2c, wm8350_i2c_id);
+
+
+static struct i2c_driver wm8350_i2c_driver = {
+	.driver = {
+		   .name = "wm8350",
+		   .owner = THIS_MODULE,
+	},
+	.probe = wm8350_i2c_probe,
+	.remove = wm8350_i2c_remove,
+	.id_table = wm8350_i2c_id,
+};
+
+static int __init wm8350_i2c_init(void)
+{
+	return i2c_add_driver(&wm8350_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(wm8350_i2c_init);
+
+static void __exit wm8350_i2c_exit(void)
+{
+	i2c_del_driver(&wm8350_i2c_driver);
+}
+module_exit(wm8350_i2c_exit);
+
+MODULE_DESCRIPTION("I2C support for the WM8350 AudioPlus PMIC");
+MODULE_LICENSE("GPL");
-- 
1.5.6.5

