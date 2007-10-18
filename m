Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbXJRUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbXJRUXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXJRUXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:23:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41018 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXJRUXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:23:05 -0400
Date: Thu, 18 Oct 2007 13:22:43 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: lm-sensors@lm-sensors.org, Jeff Garrett <jgarrett@teamhpc.com>,
       Vadim Zeitlin <vadim@zeitlins.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] i5k_amb: New memory temperature sensor driver
Message-ID: <20071018202243.GF31309@tree.beaverton.ibm.com>
References: <200707141454.l6EEs2rL027471@e34.co.us.ibm.com> <20070716202807.GD2619@tree.beaverton.ibm.com> <20070716221429.GF2619@tree.beaverton.ibm.com> <20070730033840.GG31314@jupiter.solarsys.private> <20070730192606.GD2795@tree.beaverton.ibm.com> <200707302141.l6ULfAnT021069@e1.ny.us.ibm.com> <20070731183706.GG2795@tree.beaverton.ibm.com> <20071016125429.GG3731@jupiter.solarsys.private> <20071016230657.GA6408@tree.beaverton.ibm.com> <20071018131550.GA3526@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018131550.GA3526@jupiter.solarsys.private>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

New driver to read FB-DIMM temperature sensors on systems with the
Intel 5000 series chipsets.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/Kconfig   |   10 +
 drivers/hwmon/Makefile  |    1 
 drivers/hwmon/i5k_amb.c |  531 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    3 
 4 files changed, 545 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b8854b9..c2acb37 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -215,6 +215,16 @@ config SENSORS_DS1621
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds1621.
 
+config SENSORS_I5K_AMB
+	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
+	depends on PCI && EXPERIMENTAL
+	help
+	  If you say yes here you get support for FB-DIMM AMB temperature
+	  monitoring chips on systems with the Intel 5000 series chipset.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called i5k_amb.
+
 config SENSORS_F71805F
 	tristate "Fintek F71805F/FG, F71806F/FG and F71872F/FG"
 	depends on EXPERIMENTAL
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 2f592e2..914c48c 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_SENSORS_FSCPOS)	+= fscpos.o
 obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
 obj-$(CONFIG_SENSORS_GL520SM)	+= gl520sm.o
 obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
+obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
new file mode 100644
index 0000000..7fdbe81
--- /dev/null
+++ b/drivers/hwmon/i5k_amb.c
@@ -0,0 +1,531 @@
+/*
+ * A hwmon driver for the Intel 5000 series chipset FB-DIMM AMB
+ * temperature sensors
+ * Copyright (C) 2007 IBM
+ *
+ * Author: Darrick J. Wong <djwong@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/log2.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+
+#define DRVNAME "i5k_amb"
+
+#define I5K_REG_AMB_BASE_ADDR		0x48
+#define I5K_REG_AMB_LEN_ADDR		0x50
+#define I5K_REG_CHAN0_PRESENCE_ADDR	0x64
+#define I5K_REG_CHAN1_PRESENCE_ADDR	0x66
+
+#define AMB_REG_TEMP_MIN_ADDR		0x80
+#define AMB_REG_TEMP_MID_ADDR		0x81
+#define AMB_REG_TEMP_MAX_ADDR		0x82
+#define AMB_REG_TEMP_STATUS_ADDR	0x84
+#define AMB_REG_TEMP_ADDR		0x85
+
+#define AMB_CONFIG_SIZE			2048
+#define AMB_FUNC_3_OFFSET		768
+
+#define AMB_REG_TEMP_STATUS(amb)	((amb) * AMB_CONFIG_SIZE + \
+			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_STATUS_ADDR)
+#define AMB_REG_TEMP_MIN(amb)		((amb) * AMB_CONFIG_SIZE + \
+			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MIN_ADDR)
+#define AMB_REG_TEMP_MID(amb)		((amb) * AMB_CONFIG_SIZE + \
+			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MID_ADDR)
+#define AMB_REG_TEMP_MAX(amb)		((amb) * AMB_CONFIG_SIZE + \
+			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MAX_ADDR)
+#define AMB_REG_TEMP(amb)		((amb) * AMB_CONFIG_SIZE + \
+			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_ADDR)
+
+#define MAX_MEM_CHANNELS		4
+#define MAX_AMBS_PER_CHANNEL		16
+#define MAX_AMBS			(MAX_MEM_CHANNELS * \
+					 MAX_AMBS_PER_CHANNEL)
+/*
+ * Ugly hack: For some reason the highest bit is set if there
+ * are _any_ DIMMs in the channel.  Attempting to read from
+ * this "high-order" AMB results in a memory bus error, so
+ * for now we'll just ignore that top bit, even though that
+ * might prevent us from seeing the 16th DIMM in the channel.
+ */
+#define REAL_MAX_AMBS_PER_CHANNEL	15
+#define KNOBS_PER_AMB			5
+
+#define AMB_NUM_FROM_REG(byte_num, bit_num)	((byte_num) * \
+			MAX_AMBS_PER_CHANNEL) + (bit_num)
+
+#define AMB_SYSFS_NAME_LEN		16
+struct i5k_device_attribute {
+	struct sensor_device_attribute s_attr;
+	char name[AMB_SYSFS_NAME_LEN];
+};
+
+struct i5k_amb_data {
+	struct device *hwmon_dev;
+
+	unsigned long amb_base;
+	unsigned long amb_len;
+	u16 amb_present[MAX_MEM_CHANNELS];
+	void __iomem *amb_mmio;
+	struct i5k_device_attribute *attrs;
+	unsigned int num_attrs;
+};
+
+static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
+			 char *buf)
+{
+	return sprintf(buf, "%s\n", DRVNAME);
+}
+
+
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+static struct platform_device *amb_pdev;
+
+static u8 amb_read_byte(struct i5k_amb_data *data, unsigned long offset)
+{
+	return ioread8(data->amb_mmio + offset);
+}
+
+static void amb_write_byte(struct i5k_amb_data *data, unsigned long offset,
+			   u8 val)
+{
+	iowrite8(val, data->amb_mmio + offset);
+}
+
+static ssize_t show_amb_alarm(struct device *dev,
+			     struct device_attribute *devattr,
+			     char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+
+	if (!(amb_read_byte(data, AMB_REG_TEMP_STATUS(attr->index)) & 0x20) &&
+	     (amb_read_byte(data, AMB_REG_TEMP_STATUS(attr->index)) & 0x8))
+		return sprintf(buf, "1\n");
+	else
+		return sprintf(buf, "0\n");
+}
+
+static ssize_t store_amb_min(struct device *dev,
+			     struct device_attribute *devattr,
+			     const char *buf,
+			     size_t count)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+	unsigned long temp = simple_strtoul(buf, NULL, 10) / 500;
+
+	if (temp > 255)
+		temp = 255;
+
+	amb_write_byte(data, AMB_REG_TEMP_MIN(attr->index), temp);
+	return count;
+}
+
+static ssize_t store_amb_mid(struct device *dev,
+			     struct device_attribute *devattr,
+			     const char *buf,
+			     size_t count)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+	unsigned long temp = simple_strtoul(buf, NULL, 10) / 500;
+
+	if (temp > 255)
+		temp = 255;
+
+	amb_write_byte(data, AMB_REG_TEMP_MID(attr->index), temp);
+	return count;
+}
+
+static ssize_t store_amb_max(struct device *dev,
+			     struct device_attribute *devattr,
+			     const char *buf,
+			     size_t count)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+	unsigned long temp = simple_strtoul(buf, NULL, 10) / 500;
+
+	if (temp > 255)
+		temp = 255;
+
+	amb_write_byte(data, AMB_REG_TEMP_MAX(attr->index), temp);
+	return count;
+}
+
+static ssize_t show_amb_min(struct device *dev,
+			     struct device_attribute *devattr,
+			     char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n",
+		500 * amb_read_byte(data, AMB_REG_TEMP_MIN(attr->index)));
+}
+
+static ssize_t show_amb_mid(struct device *dev,
+			     struct device_attribute *devattr,
+			     char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n",
+		500 * amb_read_byte(data, AMB_REG_TEMP_MID(attr->index)));
+}
+
+static ssize_t show_amb_max(struct device *dev,
+			     struct device_attribute *devattr,
+			     char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n",
+		500 * amb_read_byte(data, AMB_REG_TEMP_MAX(attr->index)));
+}
+
+static ssize_t show_amb_temp(struct device *dev,
+			     struct device_attribute *devattr,
+			     char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct i5k_amb_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n",
+		500 * amb_read_byte(data, AMB_REG_TEMP(attr->index)));
+}
+
+static int __devinit i5k_amb_hwmon_init(struct platform_device *pdev)
+{
+	int i, j, k, d = 0;
+	u16 c;
+	int res = 0;
+	int num_ambs = 0;
+	struct i5k_amb_data *data = platform_get_drvdata(pdev);
+
+	/* Count the number of AMBs found */
+	/* ignore the high-order bit, see "Ugly hack" comment above */
+	for (i = 0; i < MAX_MEM_CHANNELS; i++)
+		num_ambs += hweight16(data->amb_present[i] & 0x7fff);
+
+	/* Set up sysfs stuff */
+	data->attrs = kzalloc(sizeof(*data->attrs) * num_ambs * KNOBS_PER_AMB,
+				GFP_KERNEL);
+	if (!data->attrs)
+		return -ENOMEM;
+	data->num_attrs = 0;
+
+	for (i = 0; i < MAX_MEM_CHANNELS; i++) {
+		c = data->amb_present[i];
+		for (j = 0; j < REAL_MAX_AMBS_PER_CHANNEL; j++, c >>= 1) {
+			struct i5k_device_attribute *iattr;
+
+			k = AMB_NUM_FROM_REG(i, j);
+			if (!(c & 0x1))
+				continue;
+			d++;
+
+			/* Temperature sysfs knob */
+			iattr = data->attrs + data->num_attrs;
+			snprintf(iattr->name, AMB_SYSFS_NAME_LEN,
+				 "temp%d_input", d);
+			iattr->s_attr.dev_attr.attr.name = iattr->name;
+			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
+			iattr->s_attr.dev_attr.show = show_amb_temp;
+			iattr->s_attr.index = k;
+			res = device_create_file(&pdev->dev,
+						 &iattr->s_attr.dev_attr);
+			if (res)
+				goto exit_remove;
+			data->num_attrs++;
+
+			/* Temperature min sysfs knob */
+			iattr = data->attrs + data->num_attrs;
+			snprintf(iattr->name, AMB_SYSFS_NAME_LEN,
+				 "temp%d_min", d);
+			iattr->s_attr.dev_attr.attr.name = iattr->name;
+			iattr->s_attr.dev_attr.attr.mode = S_IWUSR | S_IRUGO;
+			iattr->s_attr.dev_attr.show = show_amb_min;
+			iattr->s_attr.dev_attr.store = store_amb_min;
+			iattr->s_attr.index = k;
+			res = device_create_file(&pdev->dev,
+						 &iattr->s_attr.dev_attr);
+			if (res)
+				goto exit_remove;
+			data->num_attrs++;
+
+			/* Temperature mid sysfs knob */
+			iattr = data->attrs + data->num_attrs;
+			snprintf(iattr->name, AMB_SYSFS_NAME_LEN,
+				 "temp%d_mid", d);
+			iattr->s_attr.dev_attr.attr.name = iattr->name;
+			iattr->s_attr.dev_attr.attr.mode = S_IWUSR | S_IRUGO;
+			iattr->s_attr.dev_attr.show = show_amb_mid;
+			iattr->s_attr.dev_attr.store = store_amb_mid;
+			iattr->s_attr.index = k;
+			res = device_create_file(&pdev->dev,
+						 &iattr->s_attr.dev_attr);
+			if (res)
+				goto exit_remove;
+			data->num_attrs++;
+
+			/* Temperature max sysfs knob */
+			iattr = data->attrs + data->num_attrs;
+			snprintf(iattr->name, AMB_SYSFS_NAME_LEN,
+				 "temp%d_max", d);
+			iattr->s_attr.dev_attr.attr.name = iattr->name;
+			iattr->s_attr.dev_attr.attr.mode = S_IWUSR | S_IRUGO;
+			iattr->s_attr.dev_attr.show = show_amb_max;
+			iattr->s_attr.dev_attr.store = store_amb_max;
+			iattr->s_attr.index = k;
+			res = device_create_file(&pdev->dev,
+						 &iattr->s_attr.dev_attr);
+			if (res)
+				goto exit_remove;
+			data->num_attrs++;
+
+			/* Temperature alarm sysfs knob */
+			iattr = data->attrs + data->num_attrs;
+			snprintf(iattr->name, AMB_SYSFS_NAME_LEN,
+				 "temp%d_alarm", d);
+			iattr->s_attr.dev_attr.attr.name = iattr->name;
+			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
+			iattr->s_attr.dev_attr.show = show_amb_alarm;
+			iattr->s_attr.index = k;
+			res = device_create_file(&pdev->dev,
+						 &iattr->s_attr.dev_attr);
+			if (res)
+				goto exit_remove;
+			data->num_attrs++;
+		}
+	}
+
+	res = device_create_file(&pdev->dev, &dev_attr_name);
+	if (res)
+		goto exit_remove;
+
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		res = PTR_ERR(data->hwmon_dev);
+		goto exit_remove;
+	}
+
+	return res;
+
+exit_remove:
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	for (i = 0; i < data->num_attrs; i++)
+		device_remove_file(&pdev->dev, &data->attrs[i].s_attr.dev_attr);
+	kfree(data->attrs);
+
+	return res;
+}
+
+static int __devinit i5k_amb_add(void)
+{
+	int res = -ENODEV;
+
+	/* only ever going to be one of these */
+	amb_pdev = platform_device_alloc(DRVNAME, 0);
+	if (!amb_pdev)
+		return -ENOMEM;
+
+	res = platform_device_add(amb_pdev);
+	if (res)
+		goto err;
+	return 0;
+
+err:
+	platform_device_put(amb_pdev);
+	return res;
+}
+
+static int __devinit i5k_find_amb_registers(struct i5k_amb_data *data)
+{
+	struct pci_dev *pcidev;
+	u32 val32;
+	int res = -ENODEV;
+
+	/* Find AMB register memory space */
+	pcidev = pci_get_device(PCI_VENDOR_ID_INTEL,
+				PCI_DEVICE_ID_INTEL_5000_ERR,
+				NULL);
+	if (!pcidev)
+		return -ENODEV;
+
+	if (pci_read_config_dword(pcidev, I5K_REG_AMB_BASE_ADDR, &val32))
+		goto out;
+	data->amb_base = val32;
+
+	if (pci_read_config_dword(pcidev, I5K_REG_AMB_LEN_ADDR, &val32))
+		goto out;
+	data->amb_len = val32;
+
+	/* Is it big enough? */
+	if (data->amb_len < AMB_CONFIG_SIZE * MAX_AMBS) {
+		dev_err(&pcidev->dev, "AMB region too small!\n");
+		goto out;
+	}
+
+	res = 0;
+out:
+	pci_dev_put(pcidev);
+	return res;
+}
+
+static int __devinit i5k_channel_probe(u16 *amb_present, unsigned long dev_id)
+{
+	struct pci_dev *pcidev;
+	u16 val16;
+	int res = -ENODEV;
+
+	/* Copy the DIMM presence map for these two channels */
+	pcidev = pci_get_device(PCI_VENDOR_ID_INTEL, dev_id, NULL);
+	if (!pcidev)
+		return -ENODEV;
+
+	if (pci_read_config_word(pcidev, I5K_REG_CHAN0_PRESENCE_ADDR, &val16))
+		goto out;
+	amb_present[0] = val16;
+
+	if (pci_read_config_word(pcidev, I5K_REG_CHAN1_PRESENCE_ADDR, &val16))
+		goto out;
+	amb_present[1] = val16;
+
+	res = 0;
+
+out:
+	pci_dev_put(pcidev);
+	return res;
+}
+
+static int __devinit i5k_amb_probe(struct platform_device *pdev)
+{
+	struct i5k_amb_data *data;
+	struct resource *reso;
+	int res = -ENODEV;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* Figure out where the AMB registers live */
+	res = i5k_find_amb_registers(data);
+	if (res)
+		goto err;
+
+	/* Copy the DIMM presence map for the first two channels */
+	res = i5k_channel_probe(&data->amb_present[0],
+				PCI_DEVICE_ID_INTEL_5000_FBD0);
+	if (res)
+		goto err;
+
+	/* Copy the DIMM presence map for the optional second two channels */
+	i5k_channel_probe(&data->amb_present[2],
+			  PCI_DEVICE_ID_INTEL_5000_FBD1);
+
+	/* Set up resource regions */
+	reso = request_mem_region(data->amb_base, data->amb_len, DRVNAME);
+	if (!reso) {
+		res = -EBUSY;
+		goto err;
+	}
+
+	data->amb_mmio = ioremap_nocache(data->amb_base, data->amb_len);
+	if (!data->amb_mmio) {
+		res = -EBUSY;
+		goto err_map_failed;
+	}
+
+	platform_set_drvdata(pdev, data);
+
+	res = i5k_amb_hwmon_init(pdev);
+	if (res)
+		goto err_init_failed;
+
+	return res;
+
+err_init_failed:
+	iounmap(data->amb_mmio);
+	platform_set_drvdata(pdev, NULL);
+err_map_failed:
+	release_mem_region(data->amb_base, data->amb_len);
+err:
+	kfree(data);
+	return res;
+}
+
+static int __devexit i5k_amb_remove(struct platform_device *pdev)
+{
+	int i;
+	struct i5k_amb_data *data = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	for (i = 0; i < data->num_attrs; i++)
+		device_remove_file(&pdev->dev, &data->attrs[i].s_attr.dev_attr);
+	kfree(data->attrs);
+	iounmap(data->amb_mmio);
+	release_mem_region(data->amb_base, data->amb_len);
+	platform_set_drvdata(pdev, NULL);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver i5k_amb_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRVNAME,
+	},
+	.probe = i5k_amb_probe,
+	.remove = __devexit_p(i5k_amb_remove),
+};
+
+static int __init i5k_amb_init(void)
+{
+	int res;
+
+	res = platform_driver_register(&i5k_amb_driver);
+	if (res)
+		return res;
+
+	res = i5k_amb_add();
+	if (res)
+		platform_driver_unregister(&i5k_amb_driver);
+
+	return res;
+}
+
+static void __exit i5k_amb_exit(void)
+{
+	platform_device_unregister(amb_pdev);
+	platform_driver_unregister(&i5k_amb_driver);
+}
+
+MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
+MODULE_DESCRIPTION("Intel 5000 chipset FB-DIMM AMB temperature sensor");
+MODULE_LICENSE("GPL");
+
+module_init(i5k_amb_init);
+module_exit(i5k_amb_exit);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 55f307f..d641b2f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2241,6 +2241,9 @@
 #define PCI_DEVICE_ID_INTEL_82915G_IG	0x2582
 #define PCI_DEVICE_ID_INTEL_82915GM_HB	0x2590
 #define PCI_DEVICE_ID_INTEL_82915GM_IG	0x2592
+#define PCI_DEVICE_ID_INTEL_5000_ERR	0x25F0
+#define PCI_DEVICE_ID_INTEL_5000_FBD0	0x25F5
+#define PCI_DEVICE_ID_INTEL_5000_FBD1	0x25F6
 #define PCI_DEVICE_ID_INTEL_82945G_HB	0x2770
 #define PCI_DEVICE_ID_INTEL_82945G_IG	0x2772
 #define PCI_DEVICE_ID_INTEL_3000_HB	0x2778
