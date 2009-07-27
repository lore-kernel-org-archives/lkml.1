Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZG0NtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZG0NtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZG0Nq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59111 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754407AbZG0Nq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       lm-sensors@lm-sensors.org
Subject: [PATCH 12/22] hwmon: WM831x PMIC hardware monitoring driver
Date: Mon, 27 Jul 2009 14:46:02 +0100
Message-Id: <1248702372-29534-12-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the hardware monitoring features of
the WM831x PMICs to the hwmon API. Monitoring is provided for
the system voltages supported natively by the WM831x, the chip
temperature, the battery temperature and the auxiliary inputs
of the WM831x.

Currently no alarms are supported, though digital comparators on
the WM831x devices would allow these to be provided.

Since the auxiliary and battery temperature input scaling depends
on the system configuration raw ADC values are reported with scaling
left to userspace.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lm-sensors@lm-sensors.org
---
 Documentation/hwmon/wm831x   |   37 +++++++
 drivers/hwmon/Kconfig        |   11 ++
 drivers/hwmon/Makefile       |    1 +
 drivers/hwmon/wm831x-hwmon.c |  236 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 285 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/wm831x
 create mode 100644 drivers/hwmon/wm831x-hwmon.c

diff --git a/Documentation/hwmon/wm831x b/Documentation/hwmon/wm831x
new file mode 100644
index 0000000..999e525
--- /dev/null
+++ b/Documentation/hwmon/wm831x
@@ -0,0 +1,37 @@
+Kernel driver wm831x-hwmon
+==========================
+
+Supported chips:
+  * Wolfson Microelectronics WM831x PMICs
+    Prefix: 'wm831x'
+    Datasheet:
+	http://www.wolfsonmicro.com/products/WM8310
+	http://www.wolfsonmicro.com/products/WM8311
+	http://www.wolfsonmicro.com/products/WM8312
+
+Authors: Mark Brown <broonie@opensource.wolfsonmicro.com>
+
+Description
+-----------
+
+The WM831x series of PMICs include an AUXADC which can be used to
+monitor a range of system operating parameters, including the voltages
+of the major supplies within the system.  Currently the driver provides
+reporting of all the input values but does not provide any alarms.
+
+Voltage Monitoring
+------------------
+
+Voltages are sampled by a 12 bit ADC.  Voltages in milivolts are 1.465
+times the ADC value.
+
+Temperature Monitoring
+----------------------
+
+Temperatures are sampled by a 12 bit ADC.  Chip and battery temperatures
+are available.  The chip temperature is calculated as:
+
+	Degrees celsius = (512.8 - data) / 1.0983
+
+while the battery temperature calculation will depend on the NTC
+termistor component.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 8d17135..6a680e2 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -930,6 +930,17 @@ config SENSORS_W83627EHF
 	  This driver can also be built as a module.  If so, the module
 	  will be called w83627ehf.
 
+config SENSORS_WM831X
+	tristate "WM831x PMICs"
+	depends on MFD_WM831X
+	help
+	  If you say yes here you get support for the hardware
+   	  monitoring functionality of the Wolfson Microelectronics
+	  WM831x series of PMICs.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called wm831x-hwmon.
+
 config SENSORS_WM8350
 	tristate "Wolfson Microelectronics WM835x"
 	depends on MFD_WM8350
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 6126257..a7e7eb7 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_SENSORS_VT8231)	+= vt8231.o
 obj-$(CONFIG_SENSORS_W83627EHF)	+= w83627ehf.o
 obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
 obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
+obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
 obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
 
 ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
diff --git a/drivers/hwmon/wm831x-hwmon.c b/drivers/hwmon/wm831x-hwmon.c
new file mode 100644
index 0000000..0dd9973
--- /dev/null
+++ b/drivers/hwmon/wm831x-hwmon.c
@@ -0,0 +1,236 @@
+/*
+ * drivers/hwmon/wm831x-hwmon.c - Wolfson Microelectronics WM831x PMIC
+ *                                hardware monitoring features.
+ *
+ * Copyright (C) 2009 Wolfson Microelectronics plc
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License v2 as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/auxadc.h>
+
+struct wm831x_hwmon {
+	struct wm831x *wm831x;
+	struct device *classdev;
+};
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "wm831x\n");
+}
+
+static const char *input_names[] = {
+	[WM831X_AUX_SYSVDD]    = "SYSVDD" ,
+	[WM831X_AUX_USB]       = "USB" ,
+	[WM831X_AUX_BKUP_BATT] = "Backup battery",
+	[WM831X_AUX_BATT]      = "Battery",
+	[WM831X_AUX_WALL]      = "WALL",
+	[WM831X_AUX_CHIP_TEMP] = "PMIC",
+	[WM831X_AUX_BATT_TEMP] = "Battery",
+};
+
+
+static ssize_t show_voltage(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct wm831x_hwmon *hwmon = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(attr)->index;
+	int ret;
+
+	ret = wm831x_auxadc_read_uv(hwmon->wm831x, channel);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", DIV_ROUND_CLOSEST(ret, 1000));
+}
+
+static ssize_t show_chip_temp(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct wm831x_hwmon *hwmon = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(attr)->index;
+	int ret;
+
+	ret = wm831x_auxadc_read(hwmon->wm831x, channel);
+	if (ret < 0)
+		return ret;
+
+	/* Degrees celsius = (512.18-ret) / 1.0983 */
+	ret = 512180 - (ret * 1000);
+	ret = (ret * 10000) / 10983;
+
+	return sprintf(buf, "%d\n", ret);
+}
+
+static ssize_t show_batt_temp(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct wm831x_hwmon *hwmon = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(attr)->index;
+	int ret;
+
+	ret = wm831x_auxadc_read(hwmon->wm831x, channel);
+	if (ret < 0)
+		return ret;
+
+	/* The conversion depends on the battery, leave to userspace */
+	return sprintf(buf, "%d\n", ret);
+}
+
+static ssize_t show_label(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	int channel = to_sensor_dev_attr(attr)->index;
+
+	return sprintf(buf, "%s\n", input_names[channel]);
+}
+
+#define WM831X_VOLTAGE(id, name) \
+	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, show_voltage, \
+				  NULL, name);
+
+#define WM831X_NAMED_VOLTAGE(id, name) \
+	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, show_voltage,\
+				  NULL, name);		\
+	static SENSOR_DEVICE_ATTR(in##id##_label, S_IRUGO, show_label,	\
+				  NULL, name)
+
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+WM831X_VOLTAGE(0, WM831X_AUX_AUX1);
+WM831X_VOLTAGE(1, WM831X_AUX_AUX2);
+WM831X_VOLTAGE(2, WM831X_AUX_AUX3);
+WM831X_VOLTAGE(3, WM831X_AUX_AUX4);
+
+WM831X_NAMED_VOLTAGE(4, WM831X_AUX_SYSVDD);
+WM831X_NAMED_VOLTAGE(5, WM831X_AUX_USB);
+WM831X_NAMED_VOLTAGE(6, WM831X_AUX_BATT);
+WM831X_NAMED_VOLTAGE(7, WM831X_AUX_WALL);
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_chip_temp, NULL,
+			  WM831X_AUX_CHIP_TEMP);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_label, NULL,
+			  WM831X_AUX_CHIP_TEMP);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_batt_temp, NULL,
+			  WM831X_AUX_BATT_TEMP);
+static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_label, NULL,
+			  WM831X_AUX_BATT_TEMP);
+
+static struct attribute *wm831x_attributes[] = {
+	&dev_attr_name.attr,
+
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+	&sensor_dev_attr_in4_label.dev_attr.attr,
+	&sensor_dev_attr_in5_input.dev_attr.attr,
+	&sensor_dev_attr_in5_label.dev_attr.attr,
+	&sensor_dev_attr_in6_input.dev_attr.attr,
+	&sensor_dev_attr_in6_label.dev_attr.attr,
+	&sensor_dev_attr_in7_input.dev_attr.attr,
+	&sensor_dev_attr_in7_label.dev_attr.attr,
+
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_label.dev_attr.attr,
+
+	NULL,
+};
+
+static const struct attribute_group wm831x_attr_group = {
+	.attrs	= wm831x_attributes,
+};
+
+static int __devinit wm831x_hwmon_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_hwmon *hwmon;
+	int ret;
+
+	hwmon = kzalloc(sizeof(struct wm831x_hwmon), GFP_KERNEL);
+	if (!hwmon)
+		return -ENOMEM;
+
+	hwmon->wm831x = wm831x;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &wm831x_attr_group);
+	if (ret)
+		goto err;
+
+	hwmon->classdev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon->classdev)) {
+		ret = PTR_ERR(hwmon->classdev);
+		goto err_sysfs;
+	}
+
+	platform_set_drvdata(pdev, hwmon);
+
+	return 0;
+
+err_sysfs:
+	sysfs_remove_group(&pdev->dev.kobj, &wm831x_attr_group);
+err:
+	kfree(hwmon);
+	return ret;
+}
+
+static int __devexit wm831x_hwmon_remove(struct platform_device *pdev)
+{
+	struct wm831x_hwmon *hwmon = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(hwmon->classdev);
+	sysfs_remove_group(&pdev->dev.kobj, &wm831x_attr_group);
+	kfree(hwmon);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_hwmon_driver = {
+	.probe = wm831x_hwmon_probe,
+	.remove = __devexit_p(wm831x_hwmon_remove),
+	.driver = {
+		.name = "wm831x-hwmon",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init wm831x_hwmon_init(void)
+{
+	return platform_driver_register(&wm831x_hwmon_driver);
+}
+module_init(wm831x_hwmon_init);
+
+static void __exit wm831x_hwmon_exit(void)
+{
+	platform_driver_unregister(&wm831x_hwmon_driver);
+}
+module_exit(wm831x_hwmon_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("WM831x Hardware Monitoring");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-hwmon");
-- 
1.6.3.3

