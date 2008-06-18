Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYFRNJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYFRNJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbYFRNIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:08:48 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42995 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYFRNIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:08:45 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Wed, 18 Jun 2008 15:08:32 +0200
Message-Id: <1213794512-8245-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] power: support for Texas Instruments BQ27x00 battery managers.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver supports both HDQ (BQ27000) and I2C (BQ27200) chip version.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/power/Kconfig           |   21 ++
 drivers/power/Makefile          |    1 +
 drivers/power/bq27x00_battery.c |  511 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 533 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/bq27x00_battery.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 58c806e..35e45aa 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -49,4 +49,25 @@ config BATTERY_OLPC
 	help
 	  Say Y to enable support for the battery on the OLPC laptop.
 
+config BATTERY_BQ27x00
+	tristate "BQ27x00 battery driver"
+	help
+	  Say Y here to enable support for batteries with BQ27000 or
+	  BQ27200 chip.
+
+config BATTERY_BQ27000
+	bool "BQ27000 battery driver"
+	depends on BATTERY_BQ27x00
+	select W1
+	select W1_SLAVE_BQ27000
+	help
+	  Say Y here to enable support for batteries with BQ27000(HDQ) chip.
+
+config BATTERY_BQ27200
+	bool "BQ27200 battery driver"
+	depends on BATTERY_BQ27x00
+	select I2C
+	help
+	  Say Y here to enable support for batteries with BQ27200(I2C) chip.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 6413ded..15aa8cb 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_APM_POWER)		+= apm_power.o
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
+obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
new file mode 100644
index 0000000..755a64c
--- /dev/null
+++ b/drivers/power/bq27x00_battery.c
@@ -0,0 +1,511 @@
+/*
+ * linux/drivers/power/bq27x00_battery.c
+ *
+ * BQ27000/BQ27200 battery driver
+ *
+ * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
+ * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
+ *
+ * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/jiffies.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/idr.h>
+
+#define DRIVER_VERSION			"1.0.0"
+
+#ifdef CONFIG_BATTERY_BQ27000
+#include "../w1/w1.h"
+#endif
+#ifdef CONFIG_BATTERY_BQ27200
+#include <linux/i2c.h>
+#endif
+
+#define BQ27x00_REG_TEMP		0x06
+#define BQ27x00_REG_VOLT		0x08
+#define BQ27x00_REG_RSOC		0x0B /* Relative State-of-Charge */
+#define BQ27x00_REG_AI			0x14
+#define BQ27x00_REG_FLAGS		0x0A
+#define HIGH_BYTE(A)			((A) << 8)
+
+/* If the system has several batteries we need a different name for each
+ * of them...
+ */
+DEFINE_IDR(battery_id);
+DEFINE_MUTEX(battery_mutex);
+
+struct bq27x00_device_info;
+struct bq27x00_access_methods {
+	int (*read)(u8 reg, int *rt_value, int b_single,
+		struct bq27x00_device_info *di);
+};
+
+struct bq27x00_device_info {
+	struct device 		*dev;
+#ifdef CONFIG_BATTERY_BQ27200
+	struct i2c_client *client;
+	int id;
+#endif
+	int			voltage_uV;
+	int			current_uA;
+	int			temp_C;
+	int			charge_rsoc;
+	struct bq27x00_access_methods	*bus;
+	struct power_supply	bat;
+};
+
+static enum power_supply_property bq27x00_battery_props[] = {
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+/*
+ * Common code for BQ27x00 devices
+ */
+
+static int bq27x00_read(u8 reg, int *rt_value, int b_single,
+	struct bq27x00_device_info *di)
+{
+	int ret;
+
+	ret = di->bus->read(reg, rt_value, b_single, di);
+	*rt_value = be16_to_cpu(*rt_value);
+
+	return ret;
+}
+
+/*
+ * Return the battery temperature in Celcius degrees
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
+{
+	int ret, temp = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_TEMP, &temp, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading temperature\n");
+		return ret;
+	}
+
+	return (temp >> 2) - 273;
+}
+
+/*
+ * Return the battery Voltage in milivolts
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
+{
+	int ret, volt = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_VOLT, &volt, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading voltage\n");
+		return ret;
+	}
+
+	return volt;
+}
+
+/*
+ * Return the battery average current
+ * Note that current can be negative signed as well
+ * Or 0 if something fails.
+ */
+static int bq27x00_battery_current(struct bq27x00_device_info *di)
+{
+	int ret, curr = 0, flags = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_AI, &curr, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading current\n");
+		return 0;
+	}
+	ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
+	if (ret < 0) {
+		dev_err(di->dev, "error reading flags\n");
+		return 0;
+	}
+	if ((flags & (1 << 7)) != 0) {
+		dev_dbg(di->dev, "negative current!\n");
+		return -curr;
+	} else
+		return curr;
+}
+
+/*
+ * Return the battery Relative State-of-Charge
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
+{
+	int ret, rsoc = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_RSOC, &rsoc, 1, di);
+	if (ret) {
+		dev_err(di->dev, "error reading relative State-of-Charge\n");
+		return ret;
+	}
+
+	return rsoc >> 8;
+}
+
+#define to_bq27x00_device_info(x) container_of((x), \
+				struct bq27x00_device_info, bat);
+
+static int bq27x00_battery_get_property(struct power_supply *psy,
+					enum power_supply_property psp,
+					union power_supply_propval *val)
+{
+	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW :
+	case POWER_SUPPLY_PROP_PRESENT :
+		val->intval = bq27x00_battery_voltage(di);
+		if (psp == POWER_SUPPLY_PROP_PRESENT)
+			val->intval = val->intval <= 0 ? 0 : 1;
+
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_NOW :
+		val->intval = bq27x00_battery_current(di);
+
+		break;
+
+	case POWER_SUPPLY_PROP_CAPACITY :
+		val->intval = bq27x00_battery_rsoc(di);
+
+		break;
+
+	case POWER_SUPPLY_PROP_TEMP :
+		val->intval = bq27x00_battery_temperature(di);
+
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void bq27x00_powersupply_init(struct bq27x00_device_info *di)
+{
+	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
+	di->bat.properties = bq27x00_battery_props;
+	di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
+	di->bat.get_property = bq27x00_battery_get_property;
+	di->bat.external_power_changed = NULL;
+
+	return;
+}
+
+/*
+ * BQ27000 specific code
+ */
+
+#ifdef CONFIG_BATTERY_BQ27000
+
+extern int w1_bq27000_read(struct device *dev, u8 reg);
+
+static int bq27000_read(u8 reg, int *rt_value, int b_single,
+	struct bq27x00_device_info *di)
+{
+	u8 val;
+
+	val = w1_bq27000_read(di->dev, reg);
+	*rt_value = val;
+
+	if (!b_single) {
+		val = w1_bq27000_read(di->dev, reg + 1);
+		*rt_value +=  HIGH_BYTE((int) val);
+	}
+
+	return 0;
+}
+
+static int bq27000_battery_probe(struct platform_device *pdev)
+{
+	struct bq27x00_device_info *di;
+	struct bq27x00_access_methods *bus;
+	int retval = 0;
+
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "failed to allocate device info data\n");
+		return -ENOMEM;
+	}
+
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus) {
+		dev_err(&pdev->dev, "failed to allocate access method data\n");
+		kfree(di);
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, di);
+
+	di->dev = &pdev->dev;
+	di->dev = pdev->dev.parent;
+	di->bat.name = "bq27000";
+	bus->read = &bq27000_read;
+	di->bus = bus;
+
+	bq27x00_powersupply_init(di);
+
+	retval = power_supply_register(&pdev->dev, &di->bat);
+	if (retval) {
+		dev_err(&pdev->dev, "failed to register battery\n");
+		goto batt_failed;
+	}
+
+	dev_info(&pdev->dev, "support ver. %s enabled\n", DRIVER_VERSION);
+
+	return 0;
+
+batt_failed:
+	kfree(bus);
+	kfree(di);
+	return retval;
+}
+
+static int bq27000_battery_remove(struct  platform_device *pdev)
+{
+	struct bq27x00_device_info *di = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&di->bat);
+	platform_set_drvdata(pdev, NULL);
+	kfree(di);
+
+	return 0;
+}
+
+#endif /* CONFIG_BATTERY_BQ27000 */
+
+/*
+ * BQ27200 specific code
+ */
+
+#ifdef CONFIG_BATTERY_BQ27200
+
+static int bq27200_read(u8 reg, int *rt_value, int b_single,
+	struct bq27x00_device_info *di)
+{
+	struct i2c_client *client = di->client;
+	struct i2c_msg msg[1];
+	unsigned char data[2];
+	int err;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg->addr = client->addr;
+	msg->flags = 0;
+	msg->len = 1;
+	msg->buf = data;
+
+	data[0] = reg;
+	err = i2c_transfer(client->adapter, msg, 1);
+
+	if (err >= 0) {
+		if (!b_single)
+			msg->len = 2;
+		else
+			msg->len = 1;
+
+		msg->flags = I2C_M_RD;
+		err = i2c_transfer(client->adapter, msg, 1);
+		if (err >= 0) {
+			if (!b_single)
+				*rt_value = data[1] | HIGH_BYTE(data[0]);
+			else
+				*rt_value = data[0];
+
+			return 0;
+		} else
+			return err;
+	} else
+		return err;
+}
+
+static int bq27200_battery_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	char *name;
+	struct bq27x00_device_info *di;
+	struct bq27x00_access_methods *bus;
+	int num, retval = 0;
+
+	/* Get new ID for the new battery device */
+	retval = idr_pre_get(&battery_id, GFP_KERNEL);
+	if (retval == 0)
+		return -ENOMEM;
+	mutex_lock(&battery_mutex);
+	retval = idr_get_new(&battery_id, client, &num);
+	mutex_unlock(&battery_mutex);
+	if (retval < 0)
+		return retval;
+
+	name = kmalloc(16, GFP_KERNEL);
+	if (!name) {
+		dev_err(&client->dev, "failed to allocate device name\n");
+		retval = -ENOMEM;
+		goto batt_failed_1;
+	}
+	sprintf(name, "bq27200-%d", num);
+
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&client->dev, "failed to allocate device info data\n");
+		retval = -ENOMEM;
+		goto batt_failed_2;
+	}
+	di->id = num;
+
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus) {
+		dev_err(&client->dev, "failed to allocate access method "
+					"data\n");
+		retval = -ENOMEM;
+		goto batt_failed_3;
+	}
+
+	i2c_set_clientdata(client, di);
+	di->dev = &client->dev;
+	di->bat.name = name;
+	bus->read = &bq27200_read;
+	di->bus = bus;
+	di->client = client;
+
+	bq27x00_powersupply_init(di);
+
+	retval = power_supply_register(&client->dev, &di->bat);
+	if (retval) {
+		dev_err(&client->dev, "failed to register battery\n");
+		goto batt_failed_4;
+	}
+
+	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
+
+	return 0;
+
+batt_failed_4:
+	kfree(bus);
+batt_failed_3:
+	kfree(di);
+batt_failed_2:
+	kfree(name);
+batt_failed_1:
+	mutex_lock(&battery_mutex);
+	idr_remove(&battery_id, num);
+	mutex_unlock(&battery_mutex);
+
+	return retval;
+}
+
+static int bq27200_battery_remove(struct i2c_client *client)
+{
+	struct bq27x00_device_info *di  = i2c_get_clientdata(client);
+
+	power_supply_unregister(&di->bat);
+
+	kfree(di->bat.name);
+
+	mutex_lock(&battery_mutex);
+	idr_remove(&battery_id, di->id);
+	mutex_unlock(&battery_mutex);
+
+	kfree(di);
+
+	return 0;
+}
+
+#endif /* CONFIG_BATTERY_BQ27200 */
+
+/*
+ * Module stuff
+ */
+
+#ifdef CONFIG_BATTERY_BQ27000
+
+static struct platform_driver bq27000_battery_driver = {
+	.probe = bq27000_battery_probe,
+	.remove = bq27000_battery_remove,
+
+	.driver = {
+		.name = "bq27000-battery",
+	},
+};
+
+#endif /* CONFIG_BATTERY_BQ27000 */
+
+#ifdef CONFIG_BATTERY_BQ27200
+
+static const struct i2c_device_id bq27200_id[] = {
+	{ "bq27200", 0 },
+};
+
+static struct i2c_driver bq27200_battery_driver = {
+	.probe  = bq27200_battery_probe,
+	.remove = __devexit_p(bq27200_battery_remove),
+
+	.driver = {
+		.name   = "bq27200-battery",
+	},
+	.id_table = bq27200_id,
+};
+
+#endif /* CONFIG_BATTERY_BQ27200 */
+
+static int __init bq27x00_battery_init(void)
+{
+	int status = 0;
+
+#ifdef CONFIG_BATTERY_BQ27000
+	status = platform_driver_register(&bq27000_battery_driver);
+	if (status)
+		printk(KERN_ERR "Unable to register BQ27000 driver\n");
+#endif
+#ifdef CONFIG_BATTERY_BQ27200
+	status = i2c_add_driver(&bq27200_battery_driver);
+	if (status)
+		printk(KERN_ERR "Unable to register BQ27200 driver\n");
+#endif
+	return status;
+}
+
+static void __exit bq27x00_battery_exit(void)
+{
+#ifdef CONFIG_BATTERY_BQ27000
+	platform_driver_unregister(&bq27000_battery_driver);
+#endif
+#ifdef CONFIG_BATTERY_BQ27200
+	i2c_del_driver(&bq27200_battery_driver);
+#endif
+}
+
+module_init(bq27x00_battery_init);
+module_exit(bq27x00_battery_exit);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("BQ27x00 battery moniter driver");
+MODULE_LICENSE("GPL");
-- 
1.5.4.3

