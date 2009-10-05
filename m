Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbZJEH01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbZJEH01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbZJEH00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:26:26 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33815 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbZJEH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:26:25 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 2/2] LIS3LV02D: I2C support
Date: Mon,  5 Oct 2009 10:24:38 +0300
Message-Id: <1254727478-19802-3-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1254727478-19802-2-git-send-email-samu.p.onkalo@nokia.com>
References: <1254727478-19802-1-git-send-email-samu.p.onkalo@nokia.com>
 <1254727478-19802-2-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 05 Oct 2009 07:24:46.0406 (UTC) FILETIME=[EA6A6660:01CA458C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C bus support for lis3lv02d and variant accelerometer chips

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/Kconfig         |   17 ++++
 drivers/hwmon/Makefile        |    1 +
 drivers/hwmon/lis3lv02d_i2c.c |  184 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 202 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/lis3lv02d_i2c.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 69222bc..f059dc1 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -992,6 +992,23 @@ config SENSORS_LIS3_SPI
 	  will be called lis3lv02d and a specific module for the SPI transport
 	  is called lis3lv02d_spi.
 
+config SENSORS_LIS3_I2C
+	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (I2C)"
+	depends on I2C && INPUT
+	select INPUT_POLLDEV
+	default n
+	help
+	  This driver provides support for the LIS3LV02Dx accelerometer connected
+	  via I2C. The accelerometer data is readable via
+	  /sys/devices/platform/lis3lv02d.
+
+	  This driver also provides an absolute input class device, allowing
+	  the device to act as a pinball machine-esque joystick.
+
+	  This driver can also be built as modules.  If so, the core module
+	  will be called lis3lv02d and a specific module for the I2C transport
+	  is called lis3lv02d_i2c.
+
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
 	depends on INPUT && X86
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 4a34375..699e372 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
 obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
 obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
+obj-$(CONFIG_SENSORS_LIS3_I2C)	+= lis3lv02d.o lis3lv02d_i2c.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+= lm75.o
diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
new file mode 100644
index 0000000..51f858d
--- /dev/null
+++ b/drivers/hwmon/lis3lv02d_i2c.c
@@ -0,0 +1,184 @@
+/*
+ * drivers/hwmon/lis3lv02d_i2c.c
+ *
+ * Implements I2C interface for lis3lv02d (STMicroelectronics) accelerometer.
+ * Driver is based on corresponding SPI driver written by Daniel Mack
+ * (lis3lv02d_spi.c (C) 2009 Daniel Mack <daniel@caiaq.de> ).
+ *
+ * Copyright (C) 2009 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include "lis3lv02d.h"
+
+#define DRV_NAME 	"lis3lv02d_i2c"
+
+static inline s32 lis3_i2c_write(struct lis3lv02d *lis3, int reg, u8 value)
+{
+	struct i2c_client *c = lis3->bus_priv;
+	return i2c_smbus_write_byte_data(c, reg, value);
+}
+
+static inline s32 lis3_i2c_read(struct lis3lv02d *lis3, int reg, u8 *v)
+{
+	struct i2c_client *c = lis3->bus_priv;
+	*v = i2c_smbus_read_byte_data(c, reg);
+	return 0;
+}
+
+static int lis3_i2c_init(struct lis3lv02d *lis3)
+{
+	u8 reg;
+	int ret;
+
+	/* power up the device */
+	ret = lis3->read(lis3, CTRL_REG1, &reg);
+	if (ret < 0)
+		return ret;
+
+	reg |= CTRL1_PD0;
+	return lis3->write(lis3, CTRL_REG1, reg);
+}
+
+/* Default axis mapping but it can be overwritten by platform data */
+static struct axis_conversion lis3lv02d_axis_map = { LIS3_DEV_X,
+						     LIS3_DEV_Y,
+						     LIS3_DEV_Z };
+
+static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int ret = 0;
+	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
+
+	if (pdata) {
+		if (pdata->axis_x)
+			lis3lv02d_axis_map.x = pdata->axis_x;
+
+		if (pdata->axis_y)
+			lis3lv02d_axis_map.y = pdata->axis_y;
+
+		if (pdata->axis_z)
+			lis3lv02d_axis_map.z = pdata->axis_z;
+
+		if (pdata->setup_resources)
+			ret = pdata->setup_resources();
+
+		if (ret)
+			goto fail;
+	}
+
+	lis3_dev.pdata	  = pdata;
+	lis3_dev.bus_priv = client;
+	lis3_dev.init	  = lis3_i2c_init;
+	lis3_dev.read	  = lis3_i2c_read;
+	lis3_dev.write	  = lis3_i2c_write;
+	lis3_dev.irq	  = client->irq;
+	lis3_dev.ac	  = lis3lv02d_axis_map;
+
+	i2c_set_clientdata(client, &lis3_dev);
+	ret = lis3lv02d_init_device(&lis3_dev);
+fail:
+	return ret;
+}
+
+static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
+{
+	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
+	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
+
+	if (pdata && pdata->release_resources)
+		pdata->release_resources();
+
+	lis3lv02d_joystick_disable();
+	lis3lv02d_poweroff(lis3);
+
+	return lis3lv02d_remove_fs(&lis3_dev);
+}
+
+#ifdef CONFIG_PM
+static int lis3lv02d_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweroff(lis3);
+	return 0;
+}
+
+static int lis3lv02d_i2c_resume(struct i2c_client *client)
+{
+	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweron(lis3);
+	return 0;
+}
+
+static void lis3lv02d_i2c_shutdown(struct i2c_client *client)
+{
+	lis3lv02d_i2c_suspend(client, PMSG_SUSPEND);
+}
+#else
+#define lis3lv02d_i2c_suspend	NULL
+#define lis3lv02d_i2c_resume	NULL
+#define lis3lv02d_i2c_shutdown	NULL
+#endif
+
+static const struct i2c_device_id lis3lv02d_id[] = {
+	{"lis3lv02d", 0 },
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lis3lv02d_id);
+
+static struct i2c_driver lis3lv02d_i2c_driver = {
+	.driver	 = {
+		.name   = DRV_NAME,
+		.owner  = THIS_MODULE,
+	},
+	.suspend = lis3lv02d_i2c_suspend,
+	.shutdown = lis3lv02d_i2c_shutdown,
+	.resume = lis3lv02d_i2c_resume,
+	.probe	= lis3lv02d_i2c_probe,
+	.remove	= __devexit_p(lis3lv02d_i2c_remove),
+	.id_table = lis3lv02d_id,
+};
+
+static int __init lis3lv02d_init(void)
+{
+	return i2c_add_driver(&lis3lv02d_i2c_driver);
+}
+
+static void __exit lis3lv02d_exit(void)
+{
+	i2c_del_driver(&lis3lv02d_i2c_driver);
+}
+
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_DESCRIPTION("lis3lv02d I2C interface");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("i2c:" DRV_NAME);
+
+module_init(lis3lv02d_init);
+module_exit(lis3lv02d_exit);
-- 
1.5.6.3

