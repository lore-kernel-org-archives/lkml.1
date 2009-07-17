Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZGQUd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZGQUd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZGQUd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:33:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47792 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbZGQUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:33:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 17 Jul 2009 21:33:15 +0100
Message-Id: <1247862795-22547-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] hwmon: Add WM835x PMIC hardware monitoring driver
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides reporting of the status supply voltage rails
of the WM835x series of PMICs via the hwmon API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/hwmon/Kconfig           |   10 +++
 drivers/hwmon/Makefile          |    1 +
 drivers/hwmon/wm8350-hwmon.c    |  149 +++++++++++++++++++++++++++++++++++++++
 drivers/mfd/wm8350-core.c       |    3 +
 include/linux/mfd/wm8350/core.h |    6 ++
 5 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/wm8350-hwmon.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 2d50166..c94d708 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -920,6 +920,16 @@ config SENSORS_W83627EHF
 	  This driver can also be built as a module.  If so, the module
 	  will be called w83627ehf.
 
+config SENSORS_WM8350
+	tristate "Wolfson Microelectronics WM835x"
+	depends on MFD_WM8350
+	help
+	  If you say yes here you get support for the hardware
+	  monitoring features of the WM835x series of PMICs.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called wm8350-hwmon.
+
 config SENSORS_ULTRA45
 	tristate "Sun Ultra45 PIC16F747"
 	depends on SPARC64
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index b793dce..c02e90e 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_SENSORS_VT8231)	+= vt8231.o
 obj-$(CONFIG_SENSORS_W83627EHF)	+= w83627ehf.o
 obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
 obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
+obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
 
 ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/hwmon/wm8350-hwmon.c b/drivers/hwmon/wm8350-hwmon.c
new file mode 100644
index 0000000..7387620
--- /dev/null
+++ b/drivers/hwmon/wm8350-hwmon.c
@@ -0,0 +1,149 @@
+/*
+ * drivers/hwmon/wm8350-hwmon.c - Wolfson Microelectroncis WM8350 PMIC
+ *                                  hardware monitoring features.
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
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+
+#include <linux/mfd/wm8350/core.h>
+#include <linux/mfd/wm8350/comparator.h>
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "wm8350\n");
+}
+
+static const char *input_names[] = {
+	[WM8350_AUXADC_USB]  = "USB" ,
+	[WM8350_AUXADC_LINE] = "Line" ,
+	[WM8350_AUXADC_BATT] = "Battery",
+};
+
+
+static ssize_t show_voltage(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(attr)->index;
+	int val;
+
+	val = wm8350_read_auxadc(wm8350, channel, 0, 0)
+		* WM8350_AUX_COEFF / 1000;
+
+	return sprintf(buf, "%d\n", val);
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
+#define WM8350_NAMED_VOLTAGE(id, name) \
+	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, show_voltage,\
+				  NULL, WM8350_AUXADC_##name);		\
+	static SENSOR_DEVICE_ATTR(in##id##_label, S_IRUGO, show_label,	\
+				  NULL, WM8350_AUXADC_##name)
+
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+WM8350_NAMED_VOLTAGE(0, USB);
+WM8350_NAMED_VOLTAGE(1, BATT);
+WM8350_NAMED_VOLTAGE(2, LINE);
+
+static struct attribute *wm8350_attributes[] = {
+	&dev_attr_name.attr,
+
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+
+	NULL,
+};
+
+static const struct attribute_group wm8350_attr_group = {
+	.attrs	= wm8350_attributes,
+};
+
+static int __devinit wm8350_hwmon_probe(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &wm8350_attr_group);
+	if (ret)
+		goto err;
+
+	wm8350->hwmon.classdev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(wm8350->hwmon.classdev)) {
+		ret = PTR_ERR(wm8350->hwmon.classdev);
+		goto err_group;
+	}
+
+	return 0;
+
+err_group:
+	sysfs_remove_group(&pdev->dev.kobj, &wm8350_attr_group);
+err:
+	return ret;
+}
+
+static int __devexit wm8350_hwmon_remove(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(wm8350->hwmon.classdev);
+	sysfs_remove_group(&pdev->dev.kobj, &wm8350_attr_group);
+
+	return 0;
+}
+
+static struct platform_driver wm8350_hwmon_driver = {
+	.probe = wm8350_hwmon_probe,
+	.remove = __devexit_p(wm8350_hwmon_remove),
+	.driver = {
+		.name = "wm8350-hwmon",
+	},
+};
+
+static int __init wm8350_hwmon_init(void)
+{
+	return platform_driver_register(&wm8350_hwmon_driver);
+}
+module_init(wm8350_hwmon_init);
+
+static void __exit wm8350_hwmon_exit(void)
+{
+	platform_driver_unregister(&wm8350_hwmon_driver);
+}
+module_exit(wm8350_hwmon_exit);
+
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM8350 Hardware Monitoring");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8350-hwmon");
diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index fe24079..9d662a5 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1472,6 +1472,8 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 				   &(wm8350->codec.pdev));
 	wm8350_client_dev_register(wm8350, "wm8350-gpio",
 				   &(wm8350->gpio.pdev));
+	wm8350_client_dev_register(wm8350, "wm8350-hwmon",
+				   &(wm8350->hwmon.pdev));
 	wm8350_client_dev_register(wm8350, "wm8350-power",
 				   &(wm8350->power.pdev));
 	wm8350_client_dev_register(wm8350, "wm8350-rtc", &(wm8350->rtc.pdev));
@@ -1498,6 +1500,7 @@ void wm8350_device_exit(struct wm8350 *wm8350)
 	platform_device_unregister(wm8350->wdt.pdev);
 	platform_device_unregister(wm8350->rtc.pdev);
 	platform_device_unregister(wm8350->power.pdev);
+	platform_device_unregister(wm8350->hwmon.pdev);
 	platform_device_unregister(wm8350->gpio.pdev);
 	platform_device_unregister(wm8350->codec.pdev);
 
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 42cca67..969b0b5 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -605,6 +605,11 @@ struct wm8350_irq {
 	void *data;
 };
 
+struct wm8350_hwmon {
+	struct platform_device *pdev;
+	struct device *classdev;
+};
+
 struct wm8350 {
 	struct device *dev;
 
@@ -629,6 +634,7 @@ struct wm8350 {
 	/* Client devices */
 	struct wm8350_codec codec;
 	struct wm8350_gpio gpio;
+	struct wm8350_hwmon hwmon;
 	struct wm8350_pmic pmic;
 	struct wm8350_power power;
 	struct wm8350_rtc rtc;
-- 
1.6.3.3

