Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbZCZOq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbZCZOq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZCZOpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:45:55 -0400
Received: from mx1.emlix.com ([193.175.82.87]:41417 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763AbZCZOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:45:54 -0400
From: Oskar Schirmer <os@emlix.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Chris Zankel <chris@zankel.net>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>
Subject: [patch] add pca9543 driver
Date: Thu, 26 Mar 2009 15:46:58 +0100
Message-Id: <1238078818-25977-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

support pca9543 i2c bus switch chip

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/i2c/chips/Kconfig   |    3 +
 drivers/i2c/chips/Makefile  |    1 +
 drivers/i2c/chips/pca9543.c |  188 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/chips/pca9543.c

diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index c80312c..acfc46f 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -64,6 +64,9 @@ config SENSORS_PCA9539
 	  This driver is deprecated and will be dropped soon. Use
 	  drivers/gpio/pca953x.c instead.
 
+config PCA9543
+	tristate "Philips PCA9543 i2c bus switch"
+
 config SENSORS_PCF8591
 	tristate "Philips PCF8591"
 	depends on EXPERIMENTAL
diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
index d142f23..c7a7fe2 100644
--- a/drivers/i2c/chips/Makefile
+++ b/drivers/i2c/chips/Makefile
@@ -13,6 +13,7 @@
 obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_SENSORS_MAX6875)	+= max6875.o
 obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
+obj-$(CONFIG_PCA9543)		+= pca9543.o
 obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
 obj-$(CONFIG_PCF8575)		+= pcf8575.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
diff --git a/drivers/i2c/chips/pca9543.c b/drivers/i2c/chips/pca9543.c
new file mode 100644
index 0000000..ee59497
--- /dev/null
+++ b/drivers/i2c/chips/pca9543.c
@@ -0,0 +1,188 @@
+/*
+ *  pca9543.c - i2c channel switch
+ *
+ *  Copyright (C) 2008 Emlix GmbH <info@emlix.com>
+ *  Authors:	Fabian Godehardt <fg@emlix.com>
+ *		Oskar Schirmer <os@emlix.com>
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/sysfs.h>
+
+struct pca9543_data {
+	struct mutex lock;
+	struct i2c_client *client;
+};
+
+static ssize_t pca9543_read(struct pca9543_data *data, char *buf, size_t count)
+{
+	int stat;
+	struct i2c_msg msg;
+	mutex_lock(&data->lock);
+	msg.addr = data->client->addr;
+	msg.flags = I2C_M_RD;
+	msg.buf = buf;
+	msg.len = 1;
+	stat = i2c_transfer(data->client->adapter, &msg, 1);
+	mutex_unlock(&data->lock);
+	if ((stat >= 0) && (stat != 1))
+		stat = -EIO;
+	return stat;
+}
+
+static ssize_t pca9543_bin_read(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
+{
+	struct pca9543_data *data;
+	data = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	if (unlikely(!count))
+		return count;
+	if (off)
+		return -EINVAL;
+	return pca9543_read(data, buf, count);
+}
+
+static ssize_t pca9543_write(struct pca9543_data *data, char *buf, size_t count)
+{
+	int stat;
+	struct i2c_msg msg;
+	mutex_lock(&data->lock);
+	msg.addr = data->client->addr;
+	msg.flags = 0;
+	msg.buf = buf;
+	msg.len = 1;
+	stat = i2c_transfer(data->client->adapter, &msg, 1);
+	mutex_unlock(&data->lock);
+	if ((stat >= 0) && (stat != 1))
+		stat = -EIO;
+	return stat;
+}
+
+static ssize_t pca9543_bin_write(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
+{
+	struct pca9543_data *data;
+	data = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	if (unlikely(!count))
+		return count;
+	if (off)
+		return -EINVAL;
+	return pca9543_write(data, buf, count);
+}
+
+static struct bin_attribute pca9543_attr = {
+	.attr = {
+		.name = "switch",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = 1,
+	.read = pca9543_bin_read,
+	.write = pca9543_bin_write,
+};
+
+int pca9543_set_switch(struct i2c_client *client, unsigned value)
+{
+	struct pca9543_data *data;
+	u8 buf;
+	int ret;
+	data = i2c_get_clientdata(client);
+	buf = value;
+	ret = pca9543_write(data, &buf, 1);
+	if (ret > 0)
+		ret = 0;
+	return ret;
+}
+EXPORT_SYMBOL(pca9543_set_switch);
+
+static int pca9543_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	int err;
+	struct pca9543_data *data;
+	void (*cbf)(struct i2c_client *, int(*)(struct i2c_client *, unsigned));
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		printk(KERN_ERR "pca9543 probe failure\n");
+		err = -EPFNOSUPPORT;
+		goto err;
+	}
+	data = kzalloc(sizeof(struct pca9543_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto err;
+	}
+	mutex_init(&data->lock);
+	data->client = client;
+	err = sysfs_create_bin_file(&client->dev.kobj, &pca9543_attr);
+	if (err)
+		goto errmem;
+	i2c_set_clientdata(client, data);
+	dev_info(&client->dev,
+		"pca9543 i2c switch @ x%02x\n", client->addr);
+	cbf = client->dev.platform_data;
+	if (cbf)
+		cbf(client, &pca9543_set_switch);
+	return 0;
+errmem:
+	kfree(data);
+err:
+	return err;
+}
+
+static int pca9543_remove(struct i2c_client *client)
+{
+	struct pca9543_data *data;
+	data = i2c_get_clientdata(client);
+	sysfs_remove_bin_file(&client->dev.kobj, &pca9543_attr);
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
+	return 0;
+}
+
+static const struct i2c_device_id pca9543_id[] = {
+	{ "pca9543", 0 },
+	{ }
+};
+
+static struct i2c_driver pca9543_driver = {
+	.driver = {
+		.name = "pca9543",
+		.owner = THIS_MODULE,
+	},
+	.probe = pca9543_probe,
+	.remove = pca9543_remove,
+	.id_table = pca9543_id,
+};
+
+static int __init pca9543_init(void)
+{
+	return i2c_add_driver(&pca9543_driver);
+}
+
+static void __exit pca9543_exit(void)
+{
+	i2c_del_driver(&pca9543_driver);
+}
+
+MODULE_AUTHOR("emlix GmbH <info@emlix.com>");
+MODULE_DESCRIPTION("pca9543 switch driver");
+MODULE_LICENSE("GPL");
+
+module_init(pca9543_init);
+module_exit(pca9543_exit);
-- 
1.6.2.107.ge47ee

