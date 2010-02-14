Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab0BNOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 09:09:27 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:54190 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574Ab0BNOJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 09:09:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ufJHlT+rR6N+JTSoG/9uExSxVaBYATirUzWslUDBGKLX2SdkcKYxgw+ka2HiDAqidL
         ECITnZHSvpfMQbAT16t0cVgIZ5FPgstEINtHK/ev/oYLWlt7DTb+knhjMSaOPc1F053/
         lY7pQTtTvIe3WGwvEssc/DAVB5SpK8ccgJvio=
From: NISHIMOTO Hiroki <tlayboy@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, akpm@linux-foundation.org,
       NISHIMOTO Hiroki <tlayboy@gmail.com>
Subject: [PATCH] driver/misc: Add new driver for Avago ADJD-S371-QR999
Date: Sun, 14 Feb 2010 23:08:16 +0900
Message-Id: <1266156496-15269-1-git-send-email-tlayboy@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new driver for Avago ADJD-S371-QR999 digital color sensor.

This driver has two functions.
1. raw_color
       Gets color values of object.
2. trim_color
       Gets color values of object except the influence of natural light.

Reset, sleep, external clock functions are not mandatory, so not implemented.

Signed-off-by: NISHIMOTO Hiroki <tlayboy@gmail.com>
---
 drivers/misc/Kconfig      |   11 +
 drivers/misc/Makefile     |    1 +
 drivers/misc/s371_qr999.c |  569 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 581 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/s371_qr999.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e3551d2..af970d6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -292,6 +292,17 @@ config TI_DAC7512
 	  This driver can also be built as a module. If so, the module
 	  will be calles ti_dac7512.
 
+config S371_QR999
+       tristate "Avago ADJD-S371-QR999"
+       depends on I2C && SYSFS
+       default n
+       help
+	 If you say yes here, you get support for the Avago
+	 ADJD-S371-QR999 digital color sensor.
+
+	 This driver can also be built as a module. If so, the module
+	 will be called s371_qr999.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 049ff24..52b6c13 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
+obj-$(CONFIG_S371_QR999)	+= s371_qr999.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
diff --git a/drivers/misc/s371_qr999.c b/drivers/misc/s371_qr999.c
new file mode 100644
index 0000000..c9eed9f
--- /dev/null
+++ b/drivers/misc/s371_qr999.c
@@ -0,0 +1,569 @@
+/*
+ *  s371_qr999.c - ADJD-S371-QR999 digital color sensor driver
+ *
+ *  Copyright (C) 2010 NISHIMOTO Hiroki <tlayboy@gmail.com>
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
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * The main function of the ADJD-S371-QR999 is to detect color of object.
+ * If you need other functions led, reset, sleep, external clock,
+ * implement it youself by using gpio.
+ *
+ * ++ USAGE EXAMPLE ++
+ * + optimize the color value
+ *	# echo 3 > /sys/devices/platform/s371_qr999/capacitor/xxx_cap
+ *	# echo 1500 > /sys/devices/platform/s371_qr999/integration/xxx_int
+ *
+ * + get color values
+ *	# cat /sys/devices/platform/s371_qr999/raw_color
+ *
+ * + get color values except the influence of natural light
+ * 	# cat /sys/devices/platform/s371_qr999/trim_get
+ *	# cat /sys/devices/platform/s371_qr999/trim_color
+ *
+ * Data Sheet
+ *	http://www.avagotech.com/docs/AV02-0314EN
+ * Application Note:
+ *	http://www.avagotech.com/docs/AV02-0359EN
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
+#define DRIVER_NAME     "s371_qr999"
+
+enum s371_qr999_color {
+	RED		= 0,
+	GREEN		= 1,
+	BLUE		= 2,
+	CLEAR		= 3,
+	COLOR_NUM	= 4,
+};
+
+enum s371_qr999_val {
+	INT_MIN_VAL	= 0x0000,
+	INT_MAX_VAL	= 0x0FFF,
+	CAP_MIN_VAL	= 0x00,
+	CAP_MAX_VAL	= 0x0F,
+};
+
+enum s371_qr999_regs {
+	CTRL            = 0x00,
+	CONFIG          = 0x01,
+	CAP_RED         = 0x06,
+	CAP_GREEN       = 0x07,
+	CAP_BLUE        = 0x08,
+	CAP_CLEAR       = 0x09,
+	INT_RED		= 0x0A,
+	INT_GREEN	= 0x0C,
+	INT_BLUE	= 0x0E,
+	INT_CLEAR	= 0x10,
+	DATA_RED	= 0x40,
+	DATA_GREEN	= 0x42,
+	DATA_BLUE	= 0x44,
+	DATA_CLEAR	= 0x46,
+	OFFSET_RED      = 0x48,
+	OFFSET_GREEN    = 0x49,
+	OFFSET_BLUE     = 0x4A,
+	OFFSET_CLEAR    = 0x4B,
+};
+
+enum s371_qr999_ctrl {
+	GOFS_MASK       = 0x02,
+	GSSR_MASK       = 0x01,
+};
+
+enum s371_qr999_config {
+	EXTCLK_MASK     = 0x04,
+	SLEEP_MASK      = 0x02,
+	TOFS_MASK       = 0x01,
+};
+
+enum s371_qr999_int {
+	INT_MASK	= 0x0FFF,
+};
+
+enum s371_qr999_offset {
+	SIGN_MASK	= 0x80,
+	OFFSET_MASK	= 0x7F,
+};
+
+struct s371_qr999 {
+	void *client;
+	struct platform_device *pdev;
+	struct s371_qr999_platform_data *pdata;
+	struct mutex mutex;
+	int (*write_byte) (struct s371_qr999 *s371, int reg, u8 val);
+	int (*read_byte) (struct s371_qr999 *s371, int reg, u8 *val);
+	int (*write_word) (struct s371_qr999 *s371, int reg, u16 val);
+	int (*read_word) (struct s371_qr999 *s371, int reg, u16 *val);
+};
+
+struct s371_qr999 s371_qr999_dev;
+
+static const struct i2c_device_id s371_qr999_id[] = {
+	{"s371_qr999", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, s371_qr999_id);
+
+/* ===================================================================== */
+
+static inline s32 s371_qr999_i2c_write_byte(struct s371_qr999 *s371,
+					    int reg, u8 val)
+{
+	struct i2c_client *c = s371->client;
+	return i2c_smbus_write_byte_data(c, reg, val);
+}
+
+static inline s32 s371_qr999_i2c_read_byte(struct s371_qr999 *s371,
+					   int reg, u8 *val)
+{
+	struct i2c_client *c = s371->client;
+	*val = i2c_smbus_read_byte_data(c, reg);
+	return 0;
+}
+
+/* --------------- */
+
+static inline s32 s371_qr999_i2c_write_word(struct s371_qr999 *s371,
+					    int reg, u16 val)
+{
+	struct i2c_client *c = s371->client;
+	return i2c_smbus_write_word_data(c, reg, val);
+}
+
+static inline s32 s371_qr999_i2c_read_word(struct s371_qr999 *s371,
+					   int reg, u16 *val)
+{
+	struct i2c_client *c = s371->client;
+	*val = i2c_smbus_read_word_data(c, reg);
+	return 0;
+}
+
+/* ===================================================================== */
+
+static void s371_qr999_trim_on(struct s371_qr999 *s371)
+{
+	u8 val;
+
+	s371_qr999_i2c_read_byte(s371, CONFIG, &val);
+	s371_qr999_i2c_write_byte(s371, CONFIG, val | TOFS_MASK);
+}
+
+static void s371_qr999_trim_off(struct s371_qr999 *s371)
+{
+	u8 val;
+
+	s371_qr999_i2c_read_byte(s371, CONFIG, &val);
+	s371_qr999_i2c_write_byte(s371, CONFIG, val & ~TOFS_MASK);
+}
+
+/* --------------- */
+
+static int s371_qr999_int_reg_select(const char *name)
+{
+	int reg;
+
+	if (strcmp(name, "red_int") == 0)
+		reg = INT_RED;
+	else if (strcmp(name, "green_int") == 0)
+		reg = INT_GREEN;
+	else if (strcmp(name, "blue_int") == 0)
+		reg = INT_BLUE;
+	else if (strcmp(name, "clear_int") == 0)
+		reg = INT_CLEAR;
+	else
+		reg = -EINVAL;
+
+	return reg;
+}
+
+static int s371_qr999_cap_reg_select(const char *name)
+{
+	int reg;
+
+	if (strcmp(name, "red_cap") == 0)
+		reg = CAP_RED;
+	else if (strcmp(name, "green_cap") == 0)
+		reg = CAP_GREEN;
+	else if (strcmp(name, "blue_cap") == 0)
+		reg = CAP_BLUE;
+	else if (strcmp(name, "clear_cap") == 0)
+		reg = CAP_CLEAR;
+	else
+		reg = -EINVAL;
+
+	return reg;
+}
+
+/* --------------- */
+
+static void s371_qr999_color_get(struct s371_qr999 *s371,
+				 int *r, int *g, int *b, int *c)
+{
+	u16 color[COLOR_NUM];
+	u8 flag;
+
+	s371_qr999_i2c_write_byte(s371, CTRL, GSSR_MASK);
+
+	do {
+		s371_qr999_i2c_read_byte(s371, CTRL, &flag);
+	} while (flag != 0x00);
+
+	mutex_lock(&s371->mutex);
+	s371->read_word(s371, DATA_RED, &color[RED]);
+	s371->read_word(s371, DATA_GREEN, &color[GREEN]);
+	s371->read_word(s371, DATA_BLUE, &color[BLUE]);
+	s371->read_word(s371, DATA_CLEAR, &color[CLEAR]);
+	mutex_unlock(&s371->mutex);
+
+	*r = color[RED] & INT_MASK;
+	*g = color[GREEN] & INT_MASK;
+	*b = color[BLUE] & INT_MASK;
+	*c = color[CLEAR] & INT_MASK;
+}
+
+static void s371_qr999_trim_get(struct s371_qr999 *s371,
+				 int *r, int *g, int *b, int *c)
+{
+	u8 color[COLOR_NUM];
+
+	s371_qr999_i2c_write_byte(s371, CTRL, GOFS_MASK);
+
+	mutex_lock(&s371->mutex);
+	s371->read_byte(s371, OFFSET_RED, &color[RED]);
+	s371->read_byte(s371, OFFSET_GREEN, &color[GREEN]);
+	s371->read_byte(s371, OFFSET_BLUE, &color[BLUE]);
+	s371->read_byte(s371, OFFSET_CLEAR, &color[CLEAR]);
+	mutex_unlock(&s371->mutex);
+
+	*r = (color[RED] & SIGN_MASK) ?
+		-(color[RED] & ~SIGN_MASK) : color[RED];
+	*g = (color[GREEN] & SIGN_MASK) ?
+		-(color[GREEN] & ~SIGN_MASK) : color[GREEN];
+	*b = (color[BLUE] & SIGN_MASK) ?
+		-(color[BLUE] & ~SIGN_MASK) : color[BLUE];
+	*c = (color[CLEAR] & SIGN_MASK) ?
+		-(color[CLEAR] & ~SIGN_MASK) : color[CLEAR];
+}
+
+/* ===================================================================== */
+
+/* show color values with no offset */
+static ssize_t s371_qr999_raw_color_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	int r, g, b, c;
+
+	s371_qr999_trim_off(&s371_qr999_dev);
+	s371_qr999_color_get(&s371_qr999_dev, &r, &g, &b, &c);
+
+	return sprintf(buf, "(%d,%d,%d,%d)\n", r, g, b, c);
+}
+
+/* show color values whit offset */
+static ssize_t s371_qr999_trim_color_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	int r, g, b, c;
+
+	s371_qr999_trim_on(&s371_qr999_dev);
+	s371_qr999_color_get(&s371_qr999_dev, &r, &g, &b, &c);
+
+	return sprintf(buf, "(%d,%d,%d,%d)\n", r, g, b, c);
+}
+
+/* show and set offset used by trim_color */
+static ssize_t s371_qr999_trim_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	int r, g, b, c;
+
+	s371_qr999_trim_get(&s371_qr999_dev, &r, &g, &b, &c);
+
+	return sprintf(buf, "(%d,%d,%d,%d)\n", r, g, b, c);
+}
+
+static DEVICE_ATTR(raw_color, S_IRUGO,
+		   s371_qr999_raw_color_show, NULL);
+static DEVICE_ATTR(trim_color, S_IRUGO,
+		   s371_qr999_trim_color_show, NULL);
+static DEVICE_ATTR(trim_get, S_IRUGO,
+		   s371_qr999_trim_show, NULL);
+
+static struct attribute *s371_qr999_operation_attributes[] = {
+	&dev_attr_raw_color.attr,
+	&dev_attr_trim_color.attr,
+	&dev_attr_trim_get.attr,
+	NULL
+};
+
+static struct attribute_group s371_qr999_operation_attribute_group = {
+	.attrs	= s371_qr999_operation_attributes
+};
+
+/* --------------- */
+
+static ssize_t s371_qr999_int_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	u8 reg;
+	u16 val;
+	int ret;
+
+	/* get a cap register address */
+	ret = s371_qr999_int_reg_select(attr->attr.name);
+	if (ret < 0)
+		return ret;
+	reg = (u8)ret;
+
+	s371_qr999_i2c_read_word(&s371_qr999_dev, reg, &val);
+	val &= INT_MASK;
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t s371_qr999_int_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	u8 reg;
+	u16 val;
+	int ret;
+	unsigned long res;
+
+	/* get a cap register address */
+	ret = s371_qr999_int_reg_select(attr->attr.name);
+	if (ret < 0)
+		return ret;
+	reg = (u8)ret;
+
+	/* get a value given by a user */
+	if (strict_strtoul(buf, 0, &res))
+		return -EINVAL;
+	val = (u16)(res & INT_MASK);
+
+	if (val < INT_MIN_VAL || val > INT_MAX_VAL)
+		return -EINVAL;
+
+	s371_qr999_i2c_write_word(&s371_qr999_dev, reg, val);
+
+	return count;
+}
+
+static DEVICE_ATTR(red_int, S_IRUGO | S_IWUSR,
+		   s371_qr999_int_show, s371_qr999_int_store);
+static DEVICE_ATTR(green_int, S_IRUGO | S_IWUSR,
+		   s371_qr999_int_show, s371_qr999_int_store);
+static DEVICE_ATTR(blue_int, S_IRUGO | S_IWUSR,
+		   s371_qr999_int_show, s371_qr999_int_store);
+static DEVICE_ATTR(clear_int, S_IRUGO | S_IWUSR,
+		   s371_qr999_int_show, s371_qr999_int_store);
+
+static struct attribute *s371_qr999_int_attributes[] = {
+	&dev_attr_red_int.attr,
+	&dev_attr_green_int.attr,
+	&dev_attr_blue_int.attr,
+	&dev_attr_clear_int.attr,
+	NULL
+};
+
+static struct attribute_group s371_qr999_int_attribute_group = {
+	.name	= "integration",
+	.attrs	= s371_qr999_int_attributes
+};
+
+/* --------------- */
+
+static ssize_t s371_qr999_cap_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	u8 reg, val;
+	int ret;
+
+	/* get the cap register address */
+	ret = s371_qr999_cap_reg_select(attr->attr.name);
+	if (ret < 0)
+		return ret;
+	reg = (u8)ret;
+
+	s371_qr999_i2c_read_byte(&s371_qr999_dev, reg, &val);
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t s371_qr999_cap_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	u8 reg, val;
+	int ret;
+	unsigned long res;
+
+	/* get a cap register address */
+	ret = s371_qr999_cap_reg_select(attr->attr.name);
+	if (ret < 0)
+		return ret;
+	reg = (u8)ret;
+
+	/* get a value given by a user */
+	if (strict_strtoul(buf, 0, &res))
+		return -EINVAL;
+	val = (u8)res;
+
+	if (val < CAP_MIN_VAL || val > CAP_MAX_VAL)
+		return -EINVAL;
+
+	s371_qr999_i2c_write_byte(&s371_qr999_dev, reg, val);
+
+	return count;
+}
+
+static DEVICE_ATTR(red_cap, S_IRUGO | S_IWUSR,
+		   s371_qr999_cap_show, s371_qr999_cap_store);
+static DEVICE_ATTR(green_cap, S_IRUGO | S_IWUSR,
+		   s371_qr999_cap_show, s371_qr999_cap_store);
+static DEVICE_ATTR(blue_cap, S_IRUGO | S_IWUSR,
+		   s371_qr999_cap_show, s371_qr999_cap_store);
+static DEVICE_ATTR(clear_cap, S_IRUGO | S_IWUSR,
+		   s371_qr999_cap_show, s371_qr999_cap_store);
+
+static struct attribute *s371_qr999_cap_attributes[] = {
+	&dev_attr_red_cap.attr,
+	&dev_attr_green_cap.attr,
+	&dev_attr_blue_cap.attr,
+	&dev_attr_clear_cap.attr,
+	NULL
+};
+
+static struct attribute_group s371_qr999_cap_attribute_group = {
+	.name	= "capacitor",
+	.attrs	= s371_qr999_cap_attributes
+};
+
+/* ===================================================================== */
+
+static int s371_qr999_add_fs(struct s371_qr999 *s371)
+{
+	int err = 0;
+
+	s371->pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
+
+	if (IS_ERR(s371->pdev))
+		return PTR_ERR(s371->pdev);
+
+	err = sysfs_create_group(&s371->pdev->dev.kobj,
+				 &s371_qr999_operation_attribute_group);
+	err |= sysfs_create_group(&s371->pdev->dev.kobj,
+				  &s371_qr999_int_attribute_group);
+	err |= sysfs_create_group(&s371->pdev->dev.kobj,
+				  &s371_qr999_cap_attribute_group);
+
+	if (err)
+		dev_err(&s371->pdev->dev, "Failed to register sysfs hooks\n");
+
+	return 0;
+}
+
+static int s371_qr999_remove_fs(struct s371_qr999 *s371)
+{
+	sysfs_remove_group(&s371->pdev->dev.kobj,
+			   &s371_qr999_operation_attribute_group);
+	sysfs_remove_group(&s371->pdev->dev.kobj,
+			   &s371_qr999_int_attribute_group);
+	sysfs_remove_group(&s371->pdev->dev.kobj,
+			   &s371_qr999_cap_attribute_group);
+
+	platform_device_unregister(s371->pdev);
+
+	return 0;
+}
+
+/* ===================================================================== */
+
+static int __devinit s371_qr999_i2c_probe(struct i2c_client *client,
+					  const struct i2c_device_id *id)
+{
+	struct s371_qr999_platform_data *pdata = client->dev.platform_data;
+
+	s371_qr999_dev.pdata		= pdata;
+	s371_qr999_dev.client		= client;
+	s371_qr999_dev.write_byte	= s371_qr999_i2c_write_byte;
+	s371_qr999_dev.read_byte	= s371_qr999_i2c_read_byte;
+	s371_qr999_dev.write_word	= s371_qr999_i2c_write_word;
+	s371_qr999_dev.read_word	= s371_qr999_i2c_read_word;
+
+	mutex_init(&s371_qr999_dev.mutex);
+
+	i2c_set_clientdata(client, &s371_qr999_dev);
+	s371_qr999_add_fs(&s371_qr999_dev);
+
+	printk(KERN_INFO DRIVER_NAME
+	       ": ADJD-S371-QR999 digital color sensor found\n");
+
+	return 0;
+}
+
+static int __devexit s371_qr999_i2c_remove(struct i2c_client *client)
+{
+	struct s371_qr999 *s371 = i2c_get_clientdata(client);
+
+	return s371_qr999_remove_fs(s371);
+}
+
+#define s371_qr999_i2c_suspend	NULL
+#define s371_qr999_i2c_shutdown	NULL
+#define s371_qr999_i2c_resume	NULL
+
+static struct i2c_driver s371_qr999_i2c_driver = {
+	.driver         = {
+		.name   = DRIVER_NAME,
+		.owner  = THIS_MODULE,
+	},
+	.suspend	= s371_qr999_i2c_suspend,
+	.shutdown	= s371_qr999_i2c_shutdown,
+	.resume		= s371_qr999_i2c_resume,
+	.probe          = s371_qr999_i2c_probe,
+	.remove		= __devexit_p(s371_qr999_i2c_remove),
+	.id_table       = s371_qr999_id,
+};
+
+/* ===================================================================== */
+
+static int __init s371_qr999_init(void)
+{
+	return i2c_add_driver(&s371_qr999_i2c_driver);
+}
+
+static void __exit s371_qr999_exit(void)
+{
+	i2c_del_driver(&s371_qr999_i2c_driver);
+}
+
+MODULE_AUTHOR("NISHIMOTO Hiroki <tlayboy@gmail.com>");
+MODULE_DESCRIPTION("ADJD-S371-QR999 digital color sensor driver");
+MODULE_LICENSE("GPL");
+
+module_init(s371_qr999_init);
+module_exit(s371_qr999_exit);
-- 
1.6.3.3

