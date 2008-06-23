Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYFWGil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYFWGil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 02:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYFWGid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 02:38:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:65399 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYFWGib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 02:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g4on9axGQ2qnFHyMWQf74LI3qTITyotiUG/nw3orWTXzIdcFGqQUf0WJLKFEfy9Ixx
         WDqMNWzsaMQqwQlhLk3MKlN7S/2MO6Lq7PKWYbPm4tsLHq0Lks0w2P2IgVjx9Silqfr3
         l7dbTGR5Urec3wpZxW/B22BQ2Tn82nNzm0nBo=
Date: Mon, 23 Jun 2008 10:38:17 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: support for Texas Instruments BQ27x00 battery
	managers.
Message-ID: <20080623063817.GA24051@zarina>
Reply-To: cbouatmailru@gmail.com
References: <1213794512-8245-1-git-send-email-giometti@linux.it> <20080619233411.GA27198@zarina> <20080620061345.GA9339@gundam.enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080620061345.GA9339@gundam.enneenne.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 08:13:45AM +0200, Rodolfo Giometti wrote:
[..]
> > To avoid these ifdefs, I would suggest you to reconsider the model
> > of this driver. How about:
> > 
> > - drivers/power/bq27x00_battery.c:
> > 
> >   Registers two platform_drivers, first is "bq27200-bat" (I2C) and
> >   second is "bq27000-bat" (W1). Both are using the same probe and
> >   remove methods. This driver will simply register power_supply
> >   and will do all battery logic, separated from the underlaying
> >   bus.
> > 
> >   (Two platform drivers are used simply because underlaying
> >   I2C/W1 drivers will not know each other, thus will not able to
> >   pass uniqe platform_device.id in case of single driver).
> > 
> > - include/linux/bq27x00-battery.h:
> > 
> >   Declares
> >   struct bq27x00_access_methods {
> >   	/*
> > 	 * dev argument is I2C or W1 device, battery driver will use
> > 	 * platform_device->dev.parent to pass the dev argument.
> > 	 */
> > 	int (*read)(struct device *dev, u8 reg, int *rt_value, int b_single);
> >   };
> 
> Where this function should be defined? Can you explain better what you
> mean?

Here is the patch to show the idea. I only tested it to build, so no
guaranties that it will work on the actual hardware. :-)

This patch should be separated: one patch is for I2C subsystem
maintainer (drivers/i2c/* changes) and another (drivers/power/* +
include/linux/bq27x00.h) is for me.

 drivers/i2c/chips/Kconfig       |    9 +
 drivers/i2c/chips/Makefile      |    1
 drivers/i2c/chips/bq27200.c     |  167 +++++++++++++++++++++++++
 drivers/power/Kconfig           |   10 +
 drivers/power/Makefile          |    1
 drivers/power/bq27x00_battery.c |  259 ++++++++++++++++++++++++++++++++++++++++
 include/linux/bq27x00.h         |   28 ++++
 7 files changed, 475 insertions(+)

diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index 2da2edf..d4ad4a0 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -129,6 +129,15 @@ config SENSORS_TSL2550
 	  This driver can also be built as a module.  If so, the module
 	  will be called tsl2550.
 
+config BATTERY_BQ27200
+	tristate "BQ27200 I2C battery driver"
+	default y if BATTERY_BQ27x00
+	help
+	  Say Y here to enable support for batteries with BQ27200 I2C chip.
+
+	  Note: you'll also need to select BATTERY_BQ27x00 driver to get
+	  userspace interface for this chip.
+
 config MENELAUS
 	bool "TWL92330/Menelaus PM chip"
 	depends on I2C=y && ARCH_OMAP24XX
diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
index e47aca0..2f39f73 100644
--- a/drivers/i2c/chips/Makefile
+++ b/drivers/i2c/chips/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
 obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
+obj-$(CONFIG_BATTERY_BQ27200)	+= bq27200.o
 obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
 
 ifeq ($(CONFIG_I2C_DEBUG_CHIP),y)
diff --git a/drivers/i2c/chips/bq27200.c b/drivers/i2c/chips/bq27200.c
new file mode 100644
index 0000000..fc485be
--- /dev/null
+++ b/drivers/i2c/chips/bq27200.c
@@ -0,0 +1,167 @@
+/*
+ * BQ27200 I2C battery monitor driver
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
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/idr.h>
+#include <linux/i2c.h>
+#include <linux/bq27x00.h>
+
+#define HIGH_BYTE(A) ((A) << 8)
+
+/*
+ * If the system has several batteries we need a different id for each
+ * of them... Sadly, there is no support for dynamic ids for platform
+ * devices.
+ */
+static DEFINE_IDR(battery_id);
+static DEFINE_MUTEX(battery_mutex);
+
+static int bq27200_read(struct device *dev, u8 reg, int *rt_value, int b_single)
+{
+	struct i2c_client *client = to_i2c_client(dev);
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
+	data[0] = reg;
+
+	err = i2c_transfer(client->adapter, msg, 1);
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
+			return 0;
+		} else
+			return err;
+	} else {
+		return err;
+	}
+}
+
+static int __init bq27200_battery_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct platform_device *pdev;
+	struct bq27x00_access_methods am = {
+		.read = bq27200_read,
+	};
+	int bat_id;
+	int ret = 0;
+
+idr_try_again:
+	/* Get new ID for the new battery device */
+	ret = idr_pre_get(&battery_id, GFP_KERNEL);
+	if (ret == 0)
+		return -ENOMEM;
+	mutex_lock(&battery_mutex);
+	ret = idr_get_new(&battery_id, client, &bat_id);
+	mutex_unlock(&battery_mutex);
+
+	if (ret == -EAGAIN)
+		goto idr_try_again;
+	else if (ret != 0)
+		return ret;
+
+	bat_id &= MAX_ID_MASK;
+
+	pdev = platform_device_alloc("bq27000-battery", bat_id);
+	if (!pdev) {
+		ret = -ENOMEM;
+		goto err_pdev_alloc;
+	}
+
+	ret = platform_device_add_data(pdev, &am, sizeof(am));
+	if (ret)
+		goto err_pdev;
+
+	pdev->dev.parent = &client->dev;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto err_pdev;
+
+	i2c_set_clientdata(client, pdev);
+
+	dev_info(&client->dev, "probed fine\n");
+
+	return 0;
+err_pdev:
+	platform_device_del(pdev);
+err_pdev_alloc:
+	mutex_lock(&battery_mutex);
+	idr_remove(&battery_id, bat_id);
+	mutex_unlock(&battery_mutex);
+	return ret;
+}
+
+static int __devexit bq27200_battery_remove(struct i2c_client *client)
+{
+	struct platform_device *pdev = i2c_get_clientdata(client);
+
+	platform_device_unregister(pdev);
+	mutex_lock(&battery_mutex);
+	idr_remove(&battery_id, pdev->id);
+	mutex_unlock(&battery_mutex);
+	return 0;
+}
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
+static int __init bq27200_battery_init(void)
+{
+	return i2c_add_driver(&bq27200_battery_driver);
+}
+module_init(bq27200_battery_init);
+
+static void __exit bq27200_battery_exit(void)
+{
+	i2c_del_driver(&bq27200_battery_driver);
+}
+module_exit(bq27200_battery_exit);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("BQ27000 I2C driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 58c806e..4fe3f88 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -49,4 +49,14 @@ config BATTERY_OLPC
 	help
 	  Say Y to enable support for the battery on the OLPC laptop.
 
+config BATTERY_BQ27x00
+	tristate "BQ27x00 battery monitor driver"
+	help
+	  Say Y here to enable support for common userspace interface for
+	  batteries with BQ27000 or BQ27200 chips inside.
+
+	  NOTE: this driver only provides userspace interface for these
+	  chips, you need to select BQ27x00 chip variant, I2C or W1,
+	  as found in the appropriate menus.
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
index 0000000..ae5bff7
--- /dev/null
+++ b/drivers/power/bq27x00_battery.c
@@ -0,0 +1,259 @@
+/*
+ * BQ27000/BQ27200 battery monitor driver
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
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/bq27x00.h>
+
+#define DRIVER_VERSION			"1.0.0"
+
+#define BQ27x00_REG_TEMP		0x06
+#define BQ27x00_REG_VOLT		0x08
+#define BQ27x00_REG_RSOC		0x0B /* Relative State-of-Charge */
+#define BQ27x00_REG_AI			0x14
+#define BQ27x00_REG_FLAGS		0x0A
+
+struct bq27x00_device_info {
+	struct device 		*dev;
+	int			voltage_uV;
+	int			current_uA;
+	int			temp_C;
+	int			charge_rsoc;
+	struct bq27x00_access_methods	*bus;
+	struct power_supply	bat;
+};
+
+#define to_bq27x00_device_info(x) container_of((x), \
+				struct bq27x00_device_info, bat);
+
+static enum power_supply_property bq27x00_battery_props[] = {
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+static int bq27x00_read(struct bq27x00_device_info *di, u8 reg, int *rt_value,
+			int b_single)
+{
+	int ret;
+
+	ret = di->bus->read(di->dev->parent, reg, rt_value, b_single);
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
+	int ret;
+	int temp = 0;
+
+	ret = bq27x00_read(di, BQ27x00_REG_TEMP, &temp, 0);
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
+	int ret;
+	int volt = 0;
+
+	ret = bq27x00_read(di, BQ27x00_REG_VOLT, &volt, 0);
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
+	int ret;
+	int curr = 0;
+	int flags = 0;
+
+	ret = bq27x00_read(di, BQ27x00_REG_AI, &curr, 0);
+	if (ret) {
+		dev_err(di->dev, "error reading current\n");
+		return 0;
+	}
+	ret = bq27x00_read(di, BQ27x00_REG_FLAGS, &flags, 0);
+	if (ret < 0) {
+		dev_err(di->dev, "error reading flags\n");
+		return 0;
+	}
+	if ((flags & (1 << 7)) != 0) {
+		dev_dbg(di->dev, "negative current!\n");
+		return -curr;
+	}
+	return curr;
+}
+
+/*
+ * Return the battery Relative State-of-Charge
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
+{
+	int ret;
+	int rsoc = 0;
+
+	ret = bq27x00_read(di, BQ27x00_REG_RSOC, &rsoc, 1);
+	if (ret) {
+		dev_err(di->dev, "error reading relative State-of-Charge\n");
+		return ret;
+	}
+
+	return rsoc >> 8;
+}
+
+static int bq27x00_battery_get_property(struct power_supply *psy,
+					enum power_supply_property psp,
+					union power_supply_propval *val)
+{
+	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = bq27x00_battery_voltage(di);
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = bq27x00_battery_current(di);
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = bq27x00_battery_rsoc(di);
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = bq27x00_battery_temperature(di);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init bq27x00_battery_probe(struct platform_device *pdev)
+{
+	struct bq27x00_device_info *di;
+	int ret;
+
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "failed to allocate device info data\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, di);
+
+	di->dev = &pdev->dev;
+	di->bus = platform_get_drvdata(pdev);
+	di->bat.name = pdev->dev.bus_id;
+	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
+	di->bat.properties = bq27x00_battery_props;
+	di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
+	di->bat.get_property = bq27x00_battery_get_property;
+
+	ret = power_supply_register(&pdev->dev, &di->bat);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register battery\n");
+		goto batt_failed;
+	}
+
+	dev_info(&pdev->dev, "support ver. %s enabled\n", DRIVER_VERSION);
+
+	return 0;
+
+batt_failed:
+	kfree(di);
+	return ret;
+}
+
+static int __devexit bq27x00_battery_remove(struct  platform_device *pdev)
+{
+	struct bq27x00_device_info *di = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&di->bat);
+	kfree(di);
+	return 0;
+}
+
+static struct platform_driver bq27000_battery_driver = {
+	.probe = bq27x00_battery_probe,
+	.remove = bq27x00_battery_remove,
+	.driver = {
+		.name = "bq27000-battery",
+	},
+};
+MODULE_ALIAS("platform:bq27000-battery");
+
+static struct platform_driver bq27200_battery_driver = {
+	.probe = bq27x00_battery_probe,
+	.remove = __devexit_p(bq27x00_battery_remove),
+	.driver = {
+		.name = "bq27200-battery",
+	},
+};
+MODULE_ALIAS("platform:bq27200-battery");
+
+static int __init bq27x00_battery_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&bq27000_battery_driver);
+	if (ret)
+		return -ENOMEM;
+
+	ret = platform_driver_register(&bq27200_battery_driver);
+	if (ret) {
+		platform_driver_unregister(&bq27000_battery_driver);
+		return -ENOMEM;
+	}
+	return 0;
+}
+module_init(bq27x00_battery_init);
+
+static void __exit bq27x00_battery_exit(void)
+{
+	platform_driver_unregister(&bq27000_battery_driver);
+	platform_driver_unregister(&bq27200_battery_driver);
+}
+module_exit(bq27x00_battery_exit);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_DESCRIPTION("BQ27x00 battery monitor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/bq27x00.h b/include/linux/bq27x00.h
new file mode 100644
index 0000000..a3484eb
--- /dev/null
+++ b/include/linux/bq27x00.h
@@ -0,0 +1,28 @@
+/*
+ * BQ27x00 battery monitors
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
+ */
+
+#ifndef __LINUX_BQ27x00_H
+#define __LINUX_BQ27x00_H
+
+#include <linux/types.h>
+#include <linux/device.h>
+
+struct bq27x00_access_methods {
+	int (*read)(struct device *dev, u8 reg, int *rt_value, int b_single);
+};
+
+#endif /* __LINUX_BQ27x00_H */
