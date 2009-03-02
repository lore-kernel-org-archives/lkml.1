Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZCBOdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZCBOdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZCBOcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:32:13 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:44383 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZCBOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:32:11 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Pavel Machek <pavel@ucw.cz>,
       Eric Piel <eric.piel@tremplin-utc.net>
Subject: [PATCH 5/5] lis3: SPI transport layer
Date: Mon,  2 Mar 2009 15:31:50 +0100
Message-Id: <1236004310-29196-5-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236004310-29196-4-git-send-email-daniel@caiaq.de>
References: <49ABB22F.7040508@tremplin-utc.net>
 <1236004310-29196-1-git-send-email-daniel@caiaq.de>
 <1236004310-29196-2-git-send-email-daniel@caiaq.de>
 <1236004310-29196-3-git-send-email-daniel@caiaq.de>
 <1236004310-29196-4-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new abstraction layer and add a new transport layer for
spi. Works fine on a PXA based board.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/Kconfig         |   16 ++++++
 drivers/hwmon/Makefile        |    1 +
 drivers/hwmon/lis3lv02d_spi.c |  113 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/lis3lv02d_spi.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b84bf06..9d78ab4 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -895,6 +895,22 @@ config SENSORS_LIS3LV02D
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of lis3lv02d.
 
+config SENSORS_LIS3_SPI
+	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (SPI)"
+	depends on !ACPI && SPI_MASTER && INPUT
+	default n
+	help
+	  This driver provides support for the LIS3LV02Dx accelerometer connected
+	  via SPI. The accelerometer data is readable via
+	  /sys/devices/platform/lis3lv02d.
+
+	  This driver also provides an absolute input class device, allowing
+	  the laptop to act as a pinball machine-esque joystick.
+
+	  This driver can also be built as modules.  If so, the core module
+	  will be called lis3lv02d and a specific module for the SPI transport
+	  is called lis3lv02d_spi.
+
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
 	depends on INPUT && X86
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 2e80f37..6f0f4b3 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
 obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
+obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+= lm75.o
diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
new file mode 100644
index 0000000..14436e7
--- /dev/null
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -0,0 +1,113 @@
+/*
+ * lis3lv02d_spi - SPI glue layer for lis3lv02d
+ *
+ * Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/spi/spi.h>
+
+#include "lis3lv02d.h"
+
+#define DRV_NAME 	"lis3lv02d_spi"
+#define LIS3_SPI_READ	0x80
+
+static int lis3_spi_read(struct lis3lv02d *lis3, int reg, u8 *v)
+{
+	struct spi_device *spi = lis3->bus_priv;
+	int ret = spi_w8r8(spi, reg | LIS3_SPI_READ);
+	if (ret < 0)
+		return -EINVAL;
+
+	*v = (u8) ret;
+	return 0;
+}
+
+static int lis3_spi_write(struct lis3lv02d *lis3, int reg, u8 val)
+{
+	u8 tmp[2] = { reg, val };
+	struct spi_device *spi = lis3->bus_priv;
+	return spi_write(spi, tmp, sizeof(tmp));
+}
+
+static int lis3_spi_init(struct lis3lv02d *lis3)
+{
+	u8 reg;
+	int ret;
+
+	ret = lis3->read(lis3, CTRL_REG1, &reg);
+	if (ret < 0)
+		return ret;
+
+	reg |= 0x40;
+	return lis3->write(lis3, CTRL_REG1, reg);
+}
+
+static struct axis_conversion lis3lv02d_axis_normal = { 1, 2, 3 };
+
+static int __devinit lis302dl_spi_probe(struct spi_device *spi)
+{
+	int ret;
+
+	spi->bits_per_word = 8;
+	spi->mode = SPI_MODE_0;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	lis3_dev.bus_priv = spi;
+	lis3_dev.init = lis3_spi_init;
+	lis3_dev.read = lis3_spi_read;
+	lis3_dev.write = lis3_spi_write;
+	lis3_dev.irq = spi->irq;
+	lis3_dev.ac = lis3lv02d_axis_normal;
+	spi_set_drvdata(spi, &lis3_dev);
+
+	ret = lis3lv02d_init_device(&lis3_dev);
+	return ret;
+}
+
+static int __devexit lis302dl_spi_remove(struct spi_device *spi)
+{
+	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
+	lis3lv02d_joystick_disable();
+	lis3lv02d_poweroff(lis3);
+	return 0;
+}
+
+static struct spi_driver lis302dl_spi_driver = {
+	.driver	 = {
+		.name   = DRV_NAME,
+		.owner  = THIS_MODULE,
+	},
+	.probe	= lis302dl_spi_probe,
+	.remove	= __devexit_p(lis302dl_spi_remove),
+};
+
+static int __init lis302dl_init(void)
+{
+	return spi_register_driver(&lis302dl_spi_driver);
+}
+
+static void __exit lis302dl_exit(void)
+{
+	spi_unregister_driver(&lis302dl_spi_driver);
+}
+
+module_init(lis302dl_init);
+module_exit(lis302dl_exit);
+
+MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
+MODULE_DESCRIPTION("lis3lv02d SPI glue layer");
+MODULE_LICENSE("GPL");
+
-- 
1.6.1.3

