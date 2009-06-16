Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZFPEQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZFPEQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZFPEQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:16:10 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:46428
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750824AbZFPEQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:16:08 -0400
Message-ID: <4A371CDF.3070407@bluewatersys.com>
Date: Tue, 16 Jun 2009 16:17:35 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH] ds2782 battery gas gauge driver
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the the ds2782 standalone I2C gas-gauge.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>

---

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 33da112..b9c818f 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -43,6 +43,13 @@ config BATTERY_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
 
+config BATTERY_DS2782
+	tristate "DS2782 standalone gas-gauge"
+	depends on I2C
+	help
+	  Say Y here to enable support for the DS2782 standalone battery
+	  gas-gauge.
+
 config BATTERY_PMU
 	tristate "Apple PMU battery"
 	depends on PPC32 && ADB_PMU
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 2fcf41d..ad1ac61 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_APM_POWER)		+= apm_power.o
 obj-$(CONFIG_WM8350_POWER)	+= wm8350_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
+obj-$(CONFIG_BATTERY_DS2782)	+= ds2782_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
new file mode 100644
index 0000000..8697891
--- /dev/null
+++ b/drivers/power/ds2782_battery.c
@@ -0,0 +1,269 @@
+/*
+ * drivers/power/ds2782_battery.c
+ *
+ * I2C client/driver for the Maxim/Dallas DS2782 Stand-Alone Fuel Gauge IC
+ *
+ * Copyright (C) 2009 Bluewater Systems Ltd
+ * Author: Ryan Mallon <ryan@bluewatersys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/idr.h>
+#include <linux/power_supply.h>
+
+#define DS2782_REG_RARC		0x06	/* Remaining active relative capacity */
+
+#define DS2782_REG_VOLT_MSB	0x0c
+#define DS2782_REG_TEMP_MSB	0x0a
+#define DS2782_REG_CURRENT_MSB	0x0e
+
+/* EEPROM Block */
+#define DS2782_REG_RSNSP	0x69	/* Sense resistor value */
+
+/* Current unit measurement in uA for a 1 milli-ohm sense resistor */
+#define DS2782_CURRENT_UNITS	1563
+
+#define to_ds2782_info(x) container_of(x, struct ds2782_info, battery)
+
+struct ds2782_info {
+	struct i2c_client	*client;
+	struct power_supply	battery;
+	int			id;
+};
+
+static DEFINE_IDR(battery_id);
+static DEFINE_MUTEX(battery_lock);
+
+static inline u8 ds2782_read_reg(struct ds2782_info *info, int reg)
+{
+	return i2c_smbus_read_byte_data(info->client, reg);
+}
+
+static inline u16 ds2782_read_reg16(struct ds2782_info *info, int reg_msb)
+{
+	u8 msb, lsb;
+
+	msb = ds2782_read_reg(info, reg_msb);
+	lsb = ds2782_read_reg(info, reg_msb + 1);
+
+	return (msb << 8) | lsb;
+}
+
+static int ds2782_get_temp(struct ds2782_info *info)
+{
+	u16 raw;
+	s16 temp;
+
+	/* Temperature is measured in units of 0.125 degrees celcius */
+	raw = ds2782_read_reg16(info, DS2782_REG_TEMP_MSB);
+	temp = (raw >> 5) & 0x7ff;
+	if (raw & (1 << 15))
+		temp |= 0xf800;
+	return (temp * 125) / 100;
+}
+
+static int ds2782_get_current(struct ds2782_info *info)
+{
+	s16 current_uA;
+	int sense_res;
+
+	/*
+	 * The units of measurement for current are dependent on the value of
+	 * the sense resistor.
+	 */
+	sense_res = 1000 / ds2782_read_reg(info, DS2782_REG_RSNSP);
+	dev_dbg(&info->client->dev, "sense resistor = %d milli-ohms\n",
+		sense_res);
+	current_uA = ds2782_read_reg16(info, DS2782_REG_CURRENT_MSB);
+	return current_uA * (DS2782_CURRENT_UNITS / sense_res);
+}
+
+static int ds2782_get_voltage(struct ds2782_info *info)
+{
+	u16 raw;
+	s16 voltage_uA;
+
+	/* Voltage is measured in units of 4.88mV */
+	raw = ds2782_read_reg16(info, DS2782_REG_VOLT_MSB);
+	voltage_uA = (raw >> 5) & 0x7ff;
+	if (raw & (1 << 15))
+		voltage_uA |= 0xf800;
+	return voltage_uA * 4880;
+}
+
+static int ds2782_get_status(struct ds2782_info *info)
+{
+	int current_uA, capacity;
+
+	current_uA = ds2782_get_current(info);
+	capacity = ds2782_read_reg(info, DS2782_REG_RARC);
+
+	if (capacity == 100)
+		return POWER_SUPPLY_STATUS_FULL;
+	else if (current_uA == 0)
+		return POWER_SUPPLY_STATUS_NOT_CHARGING;
+	else if (current_uA < 0)
+		return POWER_SUPPLY_STATUS_DISCHARGING;
+	else
+		return POWER_SUPPLY_STATUS_CHARGING;
+}
+
+static int ds2782_battery_get_property(struct power_supply *psy,
+				       enum power_supply_property prop,
+				       union power_supply_propval *val)
+{
+	struct ds2782_info *info = to_ds2782_info(psy);
+
+	switch (prop) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = ds2782_get_status(info);
+		break;
+
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = ds2782_read_reg(info, DS2782_REG_RARC);
+		break;
+
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = ds2782_get_voltage(info);
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = ds2782_get_current(info);
+		break;
+
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = ds2782_get_temp(info);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static enum power_supply_property ds2782_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+static void ds2782_power_supply_init(struct power_supply *battery)
+{
+	battery->type			= POWER_SUPPLY_TYPE_BATTERY;
+	battery->properties		= ds2782_battery_props;
+	battery->num_properties		= ARRAY_SIZE(ds2782_battery_props);
+	battery->get_property		= ds2782_battery_get_property;
+	battery->external_power_changed	= NULL;
+}
+
+static int ds2782_battery_remove(struct i2c_client *client)
+{
+	struct ds2782_info *info = i2c_get_clientdata(client);
+
+	power_supply_unregister(&info->battery);
+	kfree(info->battery.name);
+
+	mutex_lock(&battery_lock);
+	idr_remove(&battery_id, info->id);
+	mutex_unlock(&battery_lock);
+
+	kfree(info);
+	return 0;
+}
+
+static int ds2782_battery_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct ds2782_info *info;
+	int ret, num;
+
+	/* Get an ID for this battery */
+	ret = idr_pre_get(&battery_id, GFP_KERNEL);
+	if (ret == 0) {
+		ret = -ENOMEM;
+		goto fail_id;
+	}
+
+	mutex_lock(&battery_lock);
+	ret = idr_get_new(&battery_id, client, &num);
+	mutex_unlock(&battery_lock);
+	if (ret < 0)
+		return ret;
+
+	info = kzalloc(sizeof(struct ds2782_info), GFP_KERNEL);
+	if (!info) {
+		ret = -ENOMEM;
+		goto fail_info;
+	}
+
+	info->battery.name = kasprintf(GFP_KERNEL, "ds2782-%d", num);
+	if (!info->battery.name) {
+		ret = -ENOMEM;
+		goto fail_name;
+	}
+
+	i2c_set_clientdata(client, info);
+	info->client = client;
+	ds2782_power_supply_init(&info->battery);
+
+	ret = power_supply_register(&client->dev, &info->battery);
+	if (ret) {
+		dev_err(&client->dev, "failed to register battery\n");
+		goto fail_register;
+	}
+
+	return 0;
+
+fail_register:
+	kfree(info->battery.name);
+fail_name:
+	kfree(info);
+fail_info:
+	mutex_lock(&battery_lock);
+	idr_remove(&battery_id, num);
+	mutex_unlock(&battery_lock);
+fail_id:
+	return ret;
+}
+
+static const struct i2c_device_id ds2782_id[] = {
+	{"ds2782", 0},
+	{},
+};
+
+static struct i2c_driver ds2782_battery_driver = {
+	.driver 	= {
+		.name	= "ds2782-battery",
+	},
+	.probe		= ds2782_battery_probe,
+	.remove		= ds2782_battery_remove,
+	.id_table	= ds2782_id,
+};
+
+static int __init ds2782_init(void)
+{
+	return i2c_add_driver(&ds2782_battery_driver);
+}
+
+static void __exit ds2782_exit(void)
+{
+	i2c_del_driver(&ds2782_battery_driver);
+}
+
+module_init(ds2782_init);
+module_exit(ds2782_exit);
+
+MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
+MODULE_DESCRIPTION("Maxim/Dallas DS2782 Stand-Alone Fuel Gauage IC driver");
+MODULE_LICENSE("GPL");
+

