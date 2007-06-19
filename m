Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbXFSMJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbXFSMJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbXFSMI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:08:59 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:45551 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319AbXFSMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:08:57 -0400
Date: Tue, 19 Jun 2007 14:10:20 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070619121020.GA8902@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650706190428q341a50a1obae68b2565d0ed7@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] I2C: TSL2550 support.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Taos TSL2550 ambient light sensors.
(http://www.taosinc.com/product_detail.asp?cateid=4&proid=18).

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/i2c/chips/Kconfig   |   10 +
 drivers/i2c/chips/Makefile  |    1 +
 drivers/i2c/chips/tsl2550.c |  449 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 460 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/chips/tsl2550.c

diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index ea085a0..b59c013 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -124,4 +124,14 @@ config SENSORS_MAX6875
 	  This driver can also be built as a module.  If so, the module
 	  will be called max6875.
 
+config SENSORS_TSL2550
+	tristate "Taos TSL2550 ambient light sensor"
+	depends on I2C && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the Taos TSL2550
+	  ambient light sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called tsl2550.
+
 endmenu
diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
index 779868e..1ef6a04 100644
--- a/drivers/i2c/chips/Makefile
+++ b/drivers/i2c/chips/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
 obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
+obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
 
 ifeq ($(CONFIG_I2C_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/i2c/chips/tsl2550.c b/drivers/i2c/chips/tsl2550.c
new file mode 100644
index 0000000..352538e
--- /dev/null
+++ b/drivers/i2c/chips/tsl2550.c
@@ -0,0 +1,449 @@
+/*
+ *  tsl2550.c - Linux kernel modules for ambient light sensor
+ *
+ *  Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>
+ *  Copyright (C) 2007 Eurotech S.p.A. <info@eurotech.it>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+
+#define TSL2550_DRV_NAME	"tsl2550"
+#define DRIVER_VERSION		"1.1.0"
+
+/*
+ * Defines
+ */
+
+#define TSL2550_POWER_DOWN		0x00
+#define TSL2550_POWER_UP		0x03
+#define TSL2550_STANDARD_RANGE		0x18
+#define TSL2550_EXTENDED_RANGE		0x1d
+#define TSL2550_READ_ADC0		0x43
+#define TSL2550_READ_ADC1		0x83
+
+/*
+ * Structs
+ */
+
+struct tsl2550_data {
+	struct i2c_client *client;
+	struct mutex update_lock;
+
+	unsigned int power_state : 1;
+	unsigned int operating_mode : 1;
+};
+
+/*
+ * Management functions
+ */
+
+static int tsl2550_set_operating_mode(struct i2c_client *client, int mode)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	int ret;
+
+	mode = !!mode;
+	if (mode == data->operating_mode)
+		return 0;
+
+	if (mode == 0)
+		ret = i2c_smbus_write_byte(client, TSL2550_STANDARD_RANGE);
+	else 
+		ret = i2c_smbus_write_byte(client, TSL2550_EXTENDED_RANGE);
+
+	data->operating_mode = mode;
+
+	return ret;
+}
+
+static int tsl2550_set_power_state(struct i2c_client *client, int state)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	int ret;
+
+	state = !!state;
+	if (state == data->power_state)
+		return 0;
+
+	if (state == 0)
+		ret = i2c_smbus_write_byte(client, TSL2550_POWER_DOWN);
+	else {
+		ret = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
+
+		/* On power up we should reset operating mode also... */
+		tsl2550_set_operating_mode(client, data->operating_mode);
+	}
+
+	data->power_state = state;
+
+	return ret;
+}
+
+static int tsl2550_get_adc_value(struct i2c_client *client, int channel)
+{
+	u8 cmd = channel == 0 ? TSL2550_READ_ADC0 : TSL2550_READ_ADC1;
+	unsigned long end;
+	int loop = 0, ret = 0;
+
+	/*
+	 * Read ADC channel waiting at most 400ms (see data sheet for further
+         * info).
+	 * To avoid long busy wait we spin for few milliseconds then
+	 * start sleeping.
+	 */
+	end = jiffies + msecs_to_jiffies(400);
+	while (time_before(jiffies, end)) {
+		i2c_smbus_write_byte(client, cmd);
+
+		if (loop++ < 5)
+			mdelay(1);
+		else
+			msleep(1);
+
+		ret = i2c_smbus_read_byte(client);
+		if (ret < 0)
+			return ret;
+		else if (ret & 0x0080)
+			break;
+	}
+	if (!(ret & 0x0080))
+		return -EIO;
+	return ((u8) ret) & 0x7f;	/* remove the "valid" bit */
+}
+
+/*
+ * LUX calculation
+ */
+
+#define	TSL2550_MAX_LUX		1846
+
+static const u8 ratio_lut[] = {
+	100, 100, 100, 100, 100, 100, 100, 100, 
+	100, 100, 100, 100, 100, 100, 99, 99, 
+	99, 99, 99, 99, 99, 99, 99, 99, 
+	99, 99, 99, 98, 98, 98, 98, 98, 
+	98, 98, 97, 97, 97, 97, 97, 96, 
+	96, 96, 96, 95, 95, 95, 94, 94, 
+	93, 93, 93, 92, 92, 91, 91, 90, 
+	89, 89, 88, 87, 87, 86, 85, 84, 
+	83, 82, 81, 80, 79, 78, 77, 75, 
+	74, 73, 71, 69, 68, 66, 64, 62, 
+	60, 58, 56, 54, 52, 49, 47, 44, 
+	42, 41, 40, 40, 39, 39, 38, 38, 
+	37, 37, 37, 36, 36, 36, 35, 35, 
+	35, 35, 34, 34, 34, 34, 33, 33, 
+	33, 33, 32, 32, 32, 32, 32, 31, 
+	31, 31, 31, 31, 30, 30, 30, 30, 
+	30, 
+};
+
+static const u16 count_lut[] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 
+	8, 9, 10, 11, 12, 13, 14, 15, 
+	16, 18, 20, 22, 24, 26, 28, 30, 
+	32, 34, 36, 38, 40, 42, 44, 46, 
+	49, 53, 57, 61, 65, 69, 73, 77, 
+	81, 85, 89, 93, 97, 101, 105, 109, 
+	115, 123, 131, 139, 147, 155, 163, 171, 
+	179, 187, 195, 203, 211, 219, 227, 235, 
+	247, 263, 279, 295, 311, 327, 343, 359, 
+	375,  391, 407, 423, 439, 455, 471, 487, 
+	511, 543, 575, 607, 639, 671, 703, 735, 
+	767, 799, 831, 863, 895, 927, 959, 991, 
+	1039, 1103, 1167, 1231, 1295, 1359, 1423, 1487, 
+	1551, 1615, 1679, 1743, 1807, 1871, 1935, 1999, 
+	2095, 2223, 2351, 2479, 2607, 2735, 2863, 2991, 
+	3119, 3247, 3375, 3503, 3631, 3759, 3887, 4015
+};
+
+/*
+ * This function is described into Taos TSL2550 Designer's Notebook
+ * pages 2, 3.
+ */
+static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
+{
+	unsigned int lux;
+
+	/* Look up count from channel values */
+	u16 c0 = count_lut[ch0];
+	u16 c1 = count_lut[ch1];
+
+	/*
+	 * Calculate ratio.
+	 * Note: the "128" is a scaling factor
+	 */
+	u8 r = 128;
+
+	/* Avoid division by 0 and count 1 cannot be greater than count 0 */
+	if (c0 && (c1 <= c0))
+		r = c1 * 128 / c0;
+	else
+		return -1;
+
+	/* Calculare LUX */
+	lux = ((c0 - c1) * ratio_lut[r]) / 256;
+
+	/* LUX range check */
+	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
+}
+
+/*
+ * SysFS support
+ */
+
+static ssize_t tsl2550_show_power_state(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
+
+	return sprintf(buf, "%u\n", data->power_state);
+}
+
+static ssize_t tsl2550_store_power_state(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	unsigned long val = simple_strtoul(buf, NULL, 10);
+	int ret;
+
+	mutex_lock(&data->update_lock);
+	ret = tsl2550_set_power_state(client, val);
+	mutex_unlock(&data->update_lock);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR(power_state, S_IWUSR | S_IRUGO, 
+		   tsl2550_show_power_state, tsl2550_store_power_state);
+
+static ssize_t tsl2550_show_operating_mode(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
+
+	return sprintf(buf, "%u\n", data->operating_mode);
+}
+
+static ssize_t tsl2550_store_operating_mode(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	unsigned long val = simple_strtoul(buf, NULL, 10);
+	int ret;
+
+	mutex_lock(&data->update_lock);
+	ret = tsl2550_set_operating_mode(client, val);
+	mutex_unlock(&data->update_lock);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR(operating_mode, S_IWUSR | S_IRUGO, 
+		   tsl2550_show_operating_mode, tsl2550_store_operating_mode);
+
+static ssize_t __tsl2550_show_lux(struct i2c_client *client, struct device_attribute *attr, char *buf)
+{
+	u8 ch0, ch1;
+	int ret;
+
+	ret = tsl2550_get_adc_value(client, 0);
+	if (ret < 0)
+		return ret;
+	ch0 = (u8) ret;
+
+	mdelay(1);
+
+	ret = tsl2550_get_adc_value(client, 1);
+	if (ret < 0)
+		return ret;
+	ch1 = (u8) ret;
+	
+	/* Do the job */
+	ret = tsl2550_calculate_lux(ch0, ch1);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", ret);
+}
+
+static ssize_t tsl2550_show_lux(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	int ret;
+
+	/* No LUX data if not operational */
+	if (!data->power_state)
+		return -EBUSY;
+
+	mutex_lock(&data->update_lock);
+	ret = __tsl2550_show_lux(client, attr, buf);
+	mutex_unlock(&data->update_lock);
+
+	return ret;
+}
+
+static DEVICE_ATTR(lux, S_IRUGO, 
+		   tsl2550_show_lux, NULL);
+
+static struct attribute *tsl2550_attributes[] = {
+	&dev_attr_power_state.attr,
+	&dev_attr_operating_mode.attr,
+	&dev_attr_lux.attr,
+	NULL
+};
+
+static const struct attribute_group tsl2550_attr_group = {
+	.attrs = tsl2550_attributes,
+};
+
+/*
+ * Initialization function
+ */
+
+static void tsl2550_init_client(struct i2c_client *client)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+
+	/* Power up the device and set the default operating mode */
+	tsl2550_set_power_state(client, 1);
+	tsl2550_set_operating_mode(client, data->operating_mode);
+}
+
+/*
+ * I2C init/probing/exit functions
+ */
+
+static struct i2c_driver tsl2550_driver;
+static int __devinit tsl2550_probe(struct i2c_client *client)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct tsl2550_data *data;
+	int *opmode, err = 0;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE
+				     | I2C_FUNC_SMBUS_WRITE_BYTE_DATA)) {
+		err = -EIO;
+		goto exit;
+	}
+
+	data = kzalloc(sizeof(struct tsl2550_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+	data->client = client;
+	i2c_set_clientdata(client, data);
+	
+	/* Check platform data */
+	opmode = client->dev.platform_data;
+	if (opmode) {
+		if (*opmode < 0 || *opmode > 1) {
+			dev_err(&client->dev, "invalid operating_mode (%d)\n",
+					*opmode);
+			err = -EINVAL;
+			goto exit_kfree;
+		}
+		data->operating_mode = *opmode;
+	} else
+		data->operating_mode = 0;	/* default mode is standard */
+	dev_info(&client->dev, "%s operating mode\n",
+			data->operating_mode ? "extended" : "standard");
+
+	/*
+	 * Probe the chip. To do so we try to power up the device and then to
+	 * read back the 0x03 code
+	 */
+	err = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
+	if (err < 0)
+		goto exit_kfree;
+	mdelay(1);
+	err = i2c_smbus_read_byte(client);
+	if (err != TSL2550_POWER_UP) {
+		err = -ENODEV;
+		goto exit_kfree;
+	}
+
+	mutex_init(&data->update_lock);
+
+	/* Initialize the TSL2550 chip */
+	tsl2550_init_client(client);
+
+	/* Register sysfs hooks */
+	err = sysfs_create_group(&client->dev.kobj, &tsl2550_attr_group);
+	if (err)
+		goto exit_kfree;
+
+	dev_info(&client->dev,
+		"TSL2550 I2C support enabled - ver. %s\n", DRIVER_VERSION);
+	dev_info(&client->dev,
+		"Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>\n");
+
+	return 0;
+
+exit_kfree:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int __devexit tsl2550_remove(struct i2c_client *client)
+{
+	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
+
+	/* Power doen the device */
+	tsl2550_set_power_state(client, 0);
+
+	kfree(i2c_get_clientdata(client));
+
+	return 0;
+}
+
+static struct i2c_driver tsl2550_driver = {
+	.driver = {
+		.name	= TSL2550_DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= tsl2550_probe,
+	.remove	= __devexit_p(tsl2550_remove),
+};
+
+static int __init tsl2550_init(void)
+{
+	return i2c_add_driver(&tsl2550_driver);
+}
+
+static void __exit tsl2550_exit(void)
+{
+	i2c_del_driver(&tsl2550_driver);
+}
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("TSL2550 ambient light sensor driver");
+MODULE_LICENSE("GPL");
+
+module_init(tsl2550_init);
+module_exit(tsl2550_exit);
-- 
1.5.1.1


-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
