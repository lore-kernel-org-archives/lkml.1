Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZHLPHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZHLPHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZHLPHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:07:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55251 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZHLPHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:07:18 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Sascha Hauer <s.hauer@pengutronix.de>, Luotao Fu <l.fu@pengutronix.de>,
       Hans de Goede <hdegoede@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Piel <eric.piel@tremplin-utc.net>, lm-sensors@lm-sensors.org
Subject: [PATCH 3/5] [hwmon] add Freescale MC13783 adc driver
Date: Wed, 12 Aug 2009 17:05:29 +0200
Message-Id: <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de>
 <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luotao Fu <l.fu@pengutronix.de>

This driver provides support for the ADC integrated into the
Freescale MC13783 PMIC.

Changes since v1:

- add MODULE_ALIAS
- __init -> __devinit in probe function
- use platform_driver_probe instead of platform_driver_register

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: lm-sensors@lm-sensors.org
---
 drivers/hwmon/Kconfig       |    6 ++
 drivers/hwmon/Makefile      |    1 +
 drivers/hwmon/mc13783-adc.c |  181 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/mc13783-adc.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 2d50166..a7e34fd 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1017,6 +1017,12 @@ config SENSORS_APPLESMC
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of applesmc.
 
+config SENSORS_MC13783_ADC
+        tristate "Freescale MC13783 ADC"
+        depends on MFD_MC13783
+        help
+          Support for the ad converter on mc13783 pmic.
+
 config HWMON_DEBUG_CHIP
 	bool "Hardware Monitoring Chip debugging messages"
 	default n
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index b793dce..9b4e131 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_SENSORS_VT8231)	+= vt8231.o
 obj-$(CONFIG_SENSORS_W83627EHF)	+= w83627ehf.o
 obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
 obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
+obj-$(CONFIG_SENSORS_MC13783_ADC)       += mc13783-adc.o
 
 ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
new file mode 100644
index 0000000..87168f9
--- /dev/null
+++ b/drivers/hwmon/mc13783-adc.c
@@ -0,0 +1,181 @@
+/*
+ * Driver for the Freescale Semiconductor MC13783 adc.
+ *
+ * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright (C) 2009 Sascha Hauer, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/mfd/mc13783-private.h>
+#include <linux/platform_device.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/completion.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/hwmon.h>
+#include <linux/input.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+
+#define MC13783_ADC_NAME	"mc13783-adc"
+
+struct mc13783_adc_priv {
+	struct mc13783 *mc13783;
+	struct device *hwmon_dev;
+};
+
+static ssize_t mc13783_adc_show_name(struct device *dev, struct device_attribute
+			      *devattr, char *buf)
+{
+	return sprintf(buf, "mc13783_adc\n");
+}
+
+static ssize_t mc13783_adc_read(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mc13783_adc_priv *priv = platform_get_drvdata(pdev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	unsigned int channel = attr->index;
+	unsigned int res;
+	unsigned int sample[4];
+
+	mc13783_adc_do_conversion(priv->mc13783, MC13783_ADC_MODE_MULT_CHAN,
+			channel, sample);
+
+	channel &= 0x7;
+
+	res = (sample[channel % 4] >> (channel > 3 ? 14 : 2)) & 0x3ff;
+
+	return sprintf(buf, "%u\n", res);
+}
+
+static struct sensor_device_attribute mc13783_adc_ctl[] = {
+	SENSOR_ATTR(name, S_IRUGO, mc13783_adc_show_name, NULL, 0),
+	SENSOR_ATTR(in0_input, S_IRUGO, mc13783_adc_read, NULL, 0),
+	SENSOR_ATTR(in1_input, S_IRUGO, mc13783_adc_read, NULL, 1),
+	SENSOR_ATTR(in2_input, S_IRUGO, mc13783_adc_read, NULL, 2),
+	SENSOR_ATTR(in3_input, S_IRUGO, mc13783_adc_read, NULL, 3),
+	SENSOR_ATTR(in4_input, S_IRUGO, mc13783_adc_read, NULL, 4),
+	SENSOR_ATTR(in5_input, S_IRUGO, mc13783_adc_read, NULL, 5),
+	SENSOR_ATTR(in6_input, S_IRUGO, mc13783_adc_read, NULL, 6),
+	SENSOR_ATTR(in7_input, S_IRUGO, mc13783_adc_read, NULL, 7),
+	SENSOR_ATTR(in8_input, S_IRUGO, mc13783_adc_read, NULL, 8),
+	SENSOR_ATTR(in9_input, S_IRUGO, mc13783_adc_read, NULL, 9),
+	SENSOR_ATTR(in10_input, S_IRUGO, mc13783_adc_read, NULL, 10),
+	SENSOR_ATTR(in11_input, S_IRUGO, mc13783_adc_read, NULL, 11),
+	SENSOR_ATTR(in12_input, S_IRUGO, mc13783_adc_read, NULL, 12),
+	SENSOR_ATTR(in13_input, S_IRUGO, mc13783_adc_read, NULL, 13),
+	SENSOR_ATTR(in14_input, S_IRUGO, mc13783_adc_read, NULL, 14),
+	SENSOR_ATTR(in15_input, S_IRUGO, mc13783_adc_read, NULL, 15),
+};
+
+static int __devinit mc13783_adc_probe(struct platform_device *pdev)
+{
+	struct mc13783_adc_priv *priv;
+	int ret, i;
+	int entries;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+
+	entries = ARRAY_SIZE(mc13783_adc_ctl);
+
+	/* last four channels may be occupied by the touchscreen */
+	if (priv->mc13783->flags & MC13783_USE_TOUCHSCREEN)
+		entries -= 4;
+
+	for (i = 0; i < entries; i++) {
+		ret = device_create_file(&pdev->dev,
+				&mc13783_adc_ctl[i].dev_attr);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"device_create_file failed with %d.\n", ret);
+			goto out_err;
+		}
+	}
+
+	priv->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(priv->hwmon_dev)) {
+		ret = PTR_ERR(priv->hwmon_dev);
+		dev_err(&pdev->dev,
+				"hwmon_device_register failed with %d.\n", ret);
+		goto out_err;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+
+out_err:
+	for (i--; i >= 0; i--)
+		device_remove_file(&pdev->dev, &mc13783_adc_ctl[i].dev_attr);
+
+	kfree(priv);
+
+	return ret;
+}
+
+static int __devexit mc13783_adc_remove(struct platform_device *pdev)
+{
+	struct mc13783_adc_priv *priv = platform_get_drvdata(pdev);
+	int entries;
+	int i;
+
+	hwmon_device_unregister(&pdev->dev);
+
+	entries = ARRAY_SIZE(mc13783_adc_ctl);
+
+	if (priv->mc13783->flags & MC13783_USE_TOUCHSCREEN)
+		entries -= 4;
+
+	for (i = 0; i < entries; i++)
+		device_remove_file(&pdev->dev, &mc13783_adc_ctl[i].dev_attr);
+
+	kfree(priv);
+
+	return 0;
+}
+
+static struct platform_driver mc13783_adc_driver = {
+	.remove 	= __devexit_p(mc13783_adc_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= MC13783_ADC_NAME,
+	},
+};
+
+static int __init mc13783_adc_init(void)
+{
+	return platform_driver_probe(&mc13783_adc_driver, &mc13783_adc_probe);
+}
+
+static void __exit mc13783_adc_exit(void)
+{
+	platform_driver_unregister(&mc13783_adc_driver);
+}
+
+module_init(mc13783_adc_init);
+module_exit(mc13783_adc_exit);
+
+MODULE_DESCRIPTION("MC13783 input touchscreen driver");
+MODULE_AUTHOR("Luotao Fu, <l.fu@pengutronix.de>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mc13783-adc");
-- 
1.6.3.3

