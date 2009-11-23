Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZKWHp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZKWHp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbZKWHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:45:59 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:36860 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZKWHp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:45:58 -0500
Message-ID: <4B0A3DB6.9090703@ladisch.de>
Date: Mon, 23 Nov 2009 08:45:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h CPUs
References: <4AF91F70.10106@ladisch.de>	<4B06501B.8080509@ladisch.de>	<87ws1l5wcl.fsf@depni.sinp.msu.ru>	<4B0673D7.5010006@ladisch.de>	<20091120123016.19d98ab4@hyperion.delvare>	<4B068402.7020606@ladisch.de> <20091120131855.7f8f8722@hyperion.delvare>
In-Reply-To: <20091120131855.7f8f8722@hyperion.delvare>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the internal temperature sensor of AMD Family 10h
and 11h CPUs.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
v3: added 'force' parameter for CPUs with buggy sensor; more documentation

 Documentation/hwmon/k10temp |   57 ++++++++++++
 drivers/hwmon/Kconfig       |   12 ++
 drivers/hwmon/Makefile      |    1
 drivers/hwmon/k10temp.c     |  142 ++++++++++++++++++++++++++++++++
 4 files changed, 212 insertions(+)

--- /dev/null
+++ linux-2.6/Documentation/hwmon/k10temp
@@ -0,0 +1,57 @@
+Kernel driver k10temp
+=====================
+
+Supported chips:
+* AMD Family 10h processors:
+  Socket F: Quad-Core/Six-Core/Embedded Opteron
+  Socket AM2+: Opteron, Phenom (II) X3/X4
+  Socket AM3: Quad-Core Opteron, Athlon/Phenom II X2/X3/X4, Sempron II
+  Socket S1G3: Athlon II, Sempron, Turion II
+* AMD Family 11h processors:
+  Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
+
+  Prefix: 'k10temp'
+  Addresses scanned: PCI space
+  Datasheets:
+  BIOS and Kernel Developer's Guide (BKDG) For AMD Family 10h Processors:
+    http://support.amd.com/us/Processor_TechDocs/31116.pdf
+  BIOS and Kernel Developer's Guide (BKDG) for AMD Family 11h Processors:
+    http://support.amd.com/us/Processor_TechDocs/41256.pdf
+  Revision Guide for AMD Family 10h Processors:
+    http://support.amd.com/us/Processor_TechDocs/41322.pdf
+  Revision Guide for AMD Family 11h Processors:
+    http://support.amd.com/us/Processor_TechDocs/41788.pdf
+  AMD Family 11h Processor Power and Thermal Data Sheet for Notebooks:
+    http://support.amd.com/us/Processor_TechDocs/43373.pdf
+  AMD Family 10h Server and Workstation Processor Power and Thermal Data Sheet:
+    http://support.amd.com/us/Processor_TechDocs/43374.pdf
+  AMD Family 10h Desktop Processor Power and Thermal Data Sheet:
+    http://support.amd.com/us/Processor_TechDocs/43375.pdf
+
+Author: Clemens Ladisch <clemens@ladisch.de>
+
+Description
+-----------
+
+This driver permits reading of the internal temperature sensor of AMD
+Family 10h and 11h processors.
+
+All these processors have a sensor, but on older revisions of Family 10h
+processors, the sensor may return inconsistent values (erratum 319). The
+driver will refuse to load on these revisions unless you specify the
+"force=1" module parameter.
+
+There is one temperature value, available as temp1_input in sysfs. It is
+measured in degrees Celsius with a resolution of 1/8th degree. Please note
+that it is defined as a relative value; to quote the AMD manual:
+
+  Tctl is the processor temperatur control value, used by the platform to
+  control cooling systems. Tctl is a non-physical temperature on an
+  arbitrary scale measured in degrees. It does _not_ represent an actual
+  physical temperature like die or case temperature. Instead, it specifies
+  the processor temperature relative to the point at which the system must
+  supply the maximum cooling for the processor's specified maximum case
+  temperature and maximum thermal power dissipation.
+
+The maximum value for Tctl is defined as 70 degrees, so, as a rule of thumb,
+this value should not exceed 60 degrees.
--- linux-2.6/drivers/hwmon/Kconfig
+++ linux-2.6/drivers/hwmon/Kconfig
@@ -222,6 +222,18 @@ config SENSORS_K8TEMP
 	  This driver can also be built as a module.  If so, the module
 	  will be called k8temp.
 
+config SENSORS_K10TEMP
+	tristate "AMD Phenom/Sempron/Turion/Opteron temperature sensor"
+	depends on X86 && PCI
+	help
+	  If you say yes here you get support for the temperature
+	  sensor(s) inside your CPU. Supported are later revisions of
+	  the AMD Family 10h and all revisions of the AMD Family 11h
+	  microarchitectures.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called k10temp.
+
 config SENSORS_AMS
 	tristate "Apple Motion Sensor driver"
 	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
--- linux-2.6/drivers/hwmon/Makefile
+++ linux-2.6/drivers/hwmon/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
+obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
 obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
 obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
--- /dev/null
+++ linux-2.6/drivers/hwmon/k10temp.c
@@ -0,0 +1,142 @@
+/*
+ * k10temp.c - AMD Family 10h/11h processor hardware monitoring
+ *
+ * Copyright (c) 2009 Clemens Ladisch <clemens@ladisch.de>
+ *
+ *
+ * This driver is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <asm/processor.h>
+
+MODULE_DESCRIPTION("AMD Family 10h/11h CPU core temperature monitor");
+MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
+MODULE_LICENSE("GPL");
+
+static bool force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
+
+#define REG_REPORTED_TEMPERATURE	0xa4
+#define CURTMP_TO_MILLIDEGREES(regval)	(((regval) >> 21) * 125)
+
+static ssize_t show_temp(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	u32 regval;
+
+	pci_read_config_dword(to_pci_dev(dev),
+			      REG_REPORTED_TEMPERATURE, &regval);
+	return sprintf(buf, "%u\n", CURTMP_TO_MILLIDEGREES(regval));
+}
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "k10temp\n");
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+static bool __devinit has_erratum_319(void)
+{
+	/*
+	 * Erratum 319: The thermal sensor of older Family 10h processors
+	 *              (B steppings) may be unreliable.
+	 */
+	return boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model <= 2;
+}
+
+static int __devinit k10temp_probe(struct pci_dev *pdev,
+				   const struct pci_device_id *id)
+{
+	struct device *hwmon_dev;
+	int err;
+
+	if (has_erratum_319() && !force) {
+		dev_err(&pdev->dev,
+			"unreliable CPU thermal sensor; monitoring disabled\n");
+		err = -ENODEV;
+		goto exit;
+	}
+
+	err = device_create_file(&pdev->dev,
+				 &sensor_dev_attr_temp1_input.dev_attr);
+	if (err)
+		goto exit;
+
+	err = device_create_file(&pdev->dev, &dev_attr_name);
+	if (err)
+		goto exit_remove1;
+
+	hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon_dev)) {
+		err = PTR_ERR(hwmon_dev);
+		goto exit_remove2;
+	}
+	dev_set_drvdata(&pdev->dev, hwmon_dev);
+
+	if (has_erratum_319() && force)
+		dev_warn(&pdev->dev,
+			 "unreliable CPU thermal sensor; check erratum 319\n");
+	return 0;
+
+exit_remove2:
+	device_remove_file(&pdev->dev, &dev_attr_name);
+exit_remove1:
+	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_input.dev_attr);
+exit:
+	return err;
+}
+
+static void __devexit k10temp_remove(struct pci_dev *pdev)
+{
+	hwmon_device_unregister(dev_get_drvdata(&pdev->dev));
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_input.dev_attr);
+	dev_set_drvdata(&pdev->dev, NULL);
+}
+
+static struct pci_device_id k10temp_id_table[] = {
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, k10temp_id_table);
+
+static struct pci_driver k10temp_driver = {
+	.name = "k10temp",
+	.id_table = k10temp_id_table,
+	.probe = k10temp_probe,
+	.remove = __devexit_p(k10temp_remove),
+};
+
+static int __init k10temp_init(void)
+{
+	return pci_register_driver(&k10temp_driver);
+}
+
+static void __exit k10temp_exit(void)
+{
+	pci_unregister_driver(&k10temp_driver);
+}
+
+module_init(k10temp_init)
+module_exit(k10temp_exit)
