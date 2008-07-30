Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbYG3Kju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbYG3Kju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYG3Kjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:39:42 -0400
Received: from mail.hevs.ch ([153.109.23.10]:37857 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbYG3Kjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:39:41 -0400
To: lm-sensors@lm-sensors.org
Subject: [RFC,PATCH v3] hwmon: ADC124S501 generic driver
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Tobias Himmer <tobias@himmer-online.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Content-Disposition: inline
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
Date: Wed, 30 Jul 2008 12:39:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200807301239.34999.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPI driver for analog to digital converters national semiconductor ADC081S101,
ADC124S501, ...

Code for 8 channels by : Tobias Himmer <tobias@himmer-online.de>

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

Hi all!

the message named '[RFC,PATCH v2] hwmon: ADC124S501 generic driver' contains the
v1 patch!

Andrew, you're working too fast and I'm too dumb to verify what is inside my
clipboard..., sorry for that.

patch against 2.6.27-rc1, tested on a custom arm board and only compile-tested
on x86.

This driver add support for National Semiconductor ADC<bb><c>S<sss> chip family,
where:
 * bb  is the resolution in number of bits (8, 10, 12)
 * c   is the number of channels (1, 2, 4, 8)
 * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
   kSPS and 101 for 1 MSPS)

Changes from v2:
 * the attatched patch is the right version

Changes from v1:
 * error recovery fixed
 * support for 8 channels, thanks to Tobias
 * better CodingStyle

Thanks for your comments and testing ;)

Best regards

Marc

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 00ff533..9aedccc 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -67,6 +67,22 @@ config SENSORS_AD7418
 	  This driver can also be built as a module. If so, the module
 	  will be called ad7418.
 
+config SENSORS_ADCXX
+	tristate "National Semiconductor ADCxxxSxxx"
+	depends on SPI_MASTER && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  ADC<bb><c>S<sss> chip family, where
+	  * bb  is the resolution in number of bits (8, 10, 12)
+	  * c   is the number of channels (1, 2, 4, 8)
+	  * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
+	    kSPS and 101 for 1 MSPS)
+
+	  Examples : ADC081S101, ADC124S501, ...
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called adcxx.
+
 config SENSORS_ADM1021
 	tristate "Analog Devices ADM1021 and compatibles"
 	depends on I2C
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index d098677..026ba1e 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_SENSORS_W83791D)	+= w83791d.o
 obj-$(CONFIG_SENSORS_ABITUGURU)	+= abituguru.o
 obj-$(CONFIG_SENSORS_ABITUGURU3)+= abituguru3.o
 obj-$(CONFIG_SENSORS_AD7418)	+= ad7418.o
+obj-$(CONFIG_SENSORS_ADCXX)	+= adcxx.o
 obj-$(CONFIG_SENSORS_ADM1021)	+= adm1021.o
 obj-$(CONFIG_SENSORS_ADM1025)	+= adm1025.o
 obj-$(CONFIG_SENSORS_ADM1026)	+= adm1026.o
diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
new file mode 100644
index 0000000..242294d
--- /dev/null
+++ b/drivers/hwmon/adcxx.c
@@ -0,0 +1,329 @@
+/*
+ * adcxx.c
+ *
+ * The adcxx4s is an AD converter family from National Semiconductor (NS).
+ *
+ * Copyright (c) 2008 Marc Pignat <marc.pignat@hevs.ch>
+ *
+ * The adcxx4s communicates with a host processor via an SPI/Microwire Bus
+ * interface. This driver supports the whole family of devices with name
+ * ADC<bb><c>S<sss>, where
+ * * bb is the resolution in number of bits (8, 10, 12)
+ * * c is the number of channels (1, 2, 4, 8)
+ * * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500 kSPS
+ *   and 101 for 1 MSPS)
+ *
+ * Complete datasheets are available at National's website here:
+ * http://www.national.com/ds/DC/ADC<bb><c>S<sss>.pdf
+ *
+ * Handling of 8, 10 and 12 bits converters are the same, the
+ * unavailable bits are 0 :)
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/sysfs.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mutex.h>
+#include <linux/spi/spi.h>
+
+#define DRVNAME		"adcxx"
+
+struct adcxx {
+	struct device *hwmon_dev;
+	struct mutex lock;
+	u32 channels;
+	u32 reference; /* in millivolts */
+};
+
+/* sysfs hook function */
+static ssize_t adcxx_read(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct adcxx *adc = dev_get_drvdata(&spi->dev);
+	u8 tx_buf[2] = { attr->index << 3 }; /* other bits are don't care */
+	u8 rx_buf[2];
+	int status;
+	int value;
+
+	if (mutex_lock_interruptible(&adc->lock))
+		return -ERESTARTSYS;
+
+	status = spi_write_then_read(spi, tx_buf, sizeof(tx_buf),
+					rx_buf, sizeof(rx_buf));
+	if (status < 0) {
+		dev_warn(dev, "spi_write_then_read failed with status %d\n",
+				status);
+		goto out;
+	}
+
+	value = (rx_buf[0] << 8) + rx_buf[1];
+	dev_dbg(dev, "raw value = 0x%x\n", value);
+
+	value = value * adc->reference >> 12;
+	status = sprintf(buf, "%d\n", value);
+out:
+	mutex_unlock(&adc->lock);
+	return status;
+}
+
+static ssize_t adcxx_show_min(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	/* The minimum reference is 0 for this chip family */
+	return sprintf(buf, "0\n");
+}
+
+static ssize_t adcxx_show_max(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct adcxx *adc = dev_get_drvdata(&spi->dev);
+	u32 reference;
+
+	if (mutex_lock_interruptible(&adc->lock))
+		return -ERESTARTSYS;
+
+	reference = adc->reference;
+
+	mutex_unlock(&adc->lock);
+
+	return sprintf(buf, "%d\n", reference);
+}
+
+static ssize_t adcxx_set_max(struct device *dev,
+	struct device_attribute *devattr, const char *buf, size_t count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct adcxx *adc = dev_get_drvdata(&spi->dev);
+	unsigned long value;
+
+	if (strict_strtoul(buf, 10, &value))
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&adc->lock))
+		return -ERESTARTSYS;
+
+	adc->reference = value;
+
+	mutex_unlock(&adc->lock);
+
+	return count;
+}
+
+static ssize_t adcxx_show_name(struct device *dev, struct device_attribute
+			      *devattr, char *buf)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct adcxx *adc = dev_get_drvdata(&spi->dev);
+
+	return sprintf(buf, "adcxx%ds\n", adc->channels);
+}
+
+static struct sensor_device_attribute ad_input[] = {
+	SENSOR_ATTR(name, S_IRUGO, adcxx_show_name, NULL, 0),
+	SENSOR_ATTR(in_min, S_IRUGO, adcxx_show_min, NULL, 0),
+	SENSOR_ATTR(in_max, S_IWUSR | S_IRUGO, adcxx_show_max,
+					adcxx_set_max, 0),
+	SENSOR_ATTR(in0_input, S_IRUGO, adcxx_read, NULL, 0),
+	SENSOR_ATTR(in1_input, S_IRUGO, adcxx_read, NULL, 1),
+	SENSOR_ATTR(in2_input, S_IRUGO, adcxx_read, NULL, 2),
+	SENSOR_ATTR(in3_input, S_IRUGO, adcxx_read, NULL, 3),
+	SENSOR_ATTR(in4_input, S_IRUGO, adcxx_read, NULL, 4),
+	SENSOR_ATTR(in5_input, S_IRUGO, adcxx_read, NULL, 5),
+	SENSOR_ATTR(in6_input, S_IRUGO, adcxx_read, NULL, 6),
+	SENSOR_ATTR(in7_input, S_IRUGO, adcxx_read, NULL, 7),
+};
+
+/*----------------------------------------------------------------------*/
+
+static int __devinit adcxx_probe(struct spi_device *spi, int channels)
+{
+	struct adcxx *adc;
+	int status;
+	int i;
+
+	adc = kzalloc(sizeof *adc, GFP_KERNEL);
+	if (!adc)
+		return -ENOMEM;
+
+	/* set a default value for the reference */
+	adc->reference = 3300;
+	adc->channels = channels;
+	mutex_init(&adc->lock);
+
+	mutex_lock(&adc->lock);
+
+	dev_set_drvdata(&spi->dev, adc);
+
+	for (i = 0; i < 3 + adc->channels; i++) {
+		status = device_create_file(&spi->dev, &ad_input[i].dev_attr);
+		if (status) {
+			dev_err(&spi->dev, "device_create_file failed.\n");
+			goto out_err;
+		}
+	}
+
+	adc->hwmon_dev = hwmon_device_register(&spi->dev);
+	if (IS_ERR(adc->hwmon_dev)) {
+		dev_err(&spi->dev, "hwmon_device_register failed.\n");
+		status = PTR_ERR(adc->hwmon_dev);
+		goto out_err;
+	}
+
+	mutex_unlock(&adc->lock);
+	return 0;
+
+out_err:
+	for (i--; i >= 0; i--)
+		device_remove_file(&spi->dev, &ad_input[i].dev_attr);
+
+	dev_set_drvdata(&spi->dev, NULL);
+	mutex_unlock(&adc->lock);
+	kfree(adc);
+	return status;
+}
+
+static int __devinit adcxx1s_probe(struct spi_device *spi)
+{
+	return adcxx_probe(spi, 1);
+}
+
+static int __devinit adcxx2s_probe(struct spi_device *spi)
+{
+	return adcxx_probe(spi, 2);
+}
+
+static int __devinit adcxx4s_probe(struct spi_device *spi)
+{
+	return adcxx_probe(spi, 4);
+}
+
+static int __devinit adcxx8s_probe(struct spi_device *spi)
+{
+	return adcxx_probe(spi, 8);
+}
+
+static int __devexit adcxx_remove(struct spi_device *spi)
+{
+	struct adcxx *adc = dev_get_drvdata(&spi->dev);
+	int i;
+
+	mutex_lock(&adc->lock);
+	hwmon_device_unregister(adc->hwmon_dev);
+	for (i = 0; i < 3 + adc->channels; i++)
+		device_remove_file(&spi->dev, &ad_input[i].dev_attr);
+
+	dev_set_drvdata(&spi->dev, NULL);
+	mutex_unlock(&adc->lock);
+	kfree(adc);
+
+	return 0;
+}
+
+static struct spi_driver adcxx1s_driver = {
+	.driver = {
+		.name	= "adcxx1s",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= adcxx1s_probe,
+	.remove	= __devexit_p(adcxx_remove),
+};
+
+static struct spi_driver adcxx2s_driver = {
+	.driver = {
+		.name	= "adcxx2s",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= adcxx2s_probe,
+	.remove	= __devexit_p(adcxx_remove),
+};
+
+static struct spi_driver adcxx4s_driver = {
+	.driver = {
+		.name	= "adcxx4s",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= adcxx4s_probe,
+	.remove	= __devexit_p(adcxx_remove),
+};
+
+static struct spi_driver adcxx8s_driver = {
+	.driver = {
+		.name	= "adcxx8s",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= adcxx8s_probe,
+	.remove	= __devexit_p(adcxx_remove),
+};
+
+static int __init init_adcxx(void)
+{
+	int status;
+	status = spi_register_driver(&adcxx1s_driver);
+	if (status)
+		goto reg_1_failed;
+
+	status = spi_register_driver(&adcxx2s_driver);
+	if (status)
+		goto reg_2_failed;
+
+	status = spi_register_driver(&adcxx4s_driver);
+	if (status)
+		goto reg_4_failed;
+
+	status = spi_register_driver(&adcxx8s_driver);
+	if (status)
+		goto reg_8_failed;
+
+	return status;
+
+reg_8_failed:
+	spi_unregister_driver(&adcxx4s_driver);
+reg_4_failed:
+	spi_unregister_driver(&adcxx2s_driver);
+reg_2_failed:
+	spi_unregister_driver(&adcxx1s_driver);
+reg_1_failed:
+	return status;
+}
+
+static void __exit exit_adcxx(void)
+{
+	spi_unregister_driver(&adcxx1s_driver);
+	spi_unregister_driver(&adcxx2s_driver);
+	spi_unregister_driver(&adcxx4s_driver);
+	spi_unregister_driver(&adcxx8s_driver);
+}
+
+module_init(init_adcxx);
+module_exit(exit_adcxx);
+
+MODULE_AUTHOR("Marc Pignat");
+MODULE_DESCRIPTION("National Semiconductor adcxx8sxxx Linux driver");
+MODULE_LICENSE("GPL");
+
+MODULE_ALIAS("adcxx1s");
+MODULE_ALIAS("adcxx2s");
+MODULE_ALIAS("adcxx4s");
+MODULE_ALIAS("adcxx8s");
