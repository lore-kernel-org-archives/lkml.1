Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZFEGeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZFEGeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZFEGd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:33:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15101 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZFEGd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:33:56 -0400
Date: Fri, 05 Jun 2009 15:33:04 +0900
From: Minkyu Kang <mk7.kang@samsung.com>
Subject: [PATCH v3] add MAX17040 Fuel Gauge driver
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-i2c@vger.kernel.org
Cc: Trilok Soni <soni.trilok@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com
Message-id: <4A28BC20.3010307@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
X-OriginalArrivalTime: 05 Jun 2009 06:33:05.0282 (UTC)
 FILETIME=[7B9AEE20:01C9E5A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
This patch adds support the MAX17040 Fuel Gauge

Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>

---
 drivers/power/Kconfig            |    8 +
 drivers/power/Makefile           |    3 +-
 drivers/power/max17040_battery.c |  306 ++++++++++++++++++++++++++++++++++++++
 include/linux/max17040_battery.h |   19 +++
 4 files changed, 335 insertions(+), 1 deletions(-)
 create mode 100644 drivers/power/max17040_battery.c
 create mode 100644 include/linux/max17040_battery.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 33da112..6af5798 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -88,4 +88,12 @@ config CHARGER_PCF50633
 	help
 	 Say Y to include support for NXP PCF50633 Main Battery Charger.
 
+config BATTERY_MAX17040
+	tristate "Maxim MAX17040 Fuel Gauge"
+	depends on I2C
+	help
+	  MAX17040 is fuel-gauge systems for lithium-ion (Li+) batteries
+	  in handheld and portable equipment. The MAX17040 is configured
+	  to operate with a single lithium cell
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 2fcf41d..9c48995 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -25,4 +25,5 @@ obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
 obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
-obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
\ No newline at end of file
+obj-$(CONFIG_BATTERY_MAX17040))	+= max17040_battery.o
+obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
new file mode 100644
index 0000000..af3016c
--- /dev/null
+++ b/drivers/power/max17040_battery.c
@@ -0,0 +1,306 @@
+/*
+ *  max17040_battery.c
+ *  fuel-gauge systems for lithium-ion (Li+) batteries
+ *
+ *  Copyright (C) 2009 Samsung Electronics
+ *  Minkyu Kang <mk7.kang@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/power_supply.h>
+#include <linux/max17040_battery.h>
+
+#define MAX17040_VCELL_MSB	0x02
+#define MAX17040_VCELL_LSB	0x03
+#define MAX17040_SOC_MSB	0x04
+#define MAX17040_SOC_LSB	0x05
+#define MAX17040_MODE_MSB	0x06
+#define MAX17040_MODE_LSB	0x07
+#define MAX17040_VER_MSB	0x08
+#define MAX17040_VER_LSB	0x09
+#define MAX17040_RCOMP_MSB	0x0C
+#define MAX17040_RCOMP_LSB	0x0D
+#define MAX17040_CMD_MSB	0xFE
+#define MAX17040_CMD_LSB	0xFF
+
+#define MAX17040_DELAY		1000
+#define MAX17040_BATTERY_FULL	95
+
+struct max17040_chip {
+	struct i2c_client		*client;
+	struct delayed_work		work;
+	struct power_supply		battery;
+	struct max17040_platform_data	*pdata;
+
+	/* State Of Connect */
+	int online;
+	/* battery voltage */
+	int vcell;
+	/* battery capacity */
+	int soc;
+	/* State Of Charge */
+	int status;
+};
+
+static int max17040_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	struct max17040_chip *chip = container_of(psy,
+				struct max17040_chip, battery);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = chip->status;
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = chip->online;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = chip->vcell;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = chip->soc;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int max17040_write_reg(struct i2c_client *client, int reg, u8 value)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, value);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int max17040_read_reg(struct i2c_client *client, int reg)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static void max17040_reset(struct i2c_client *client)
+{
+	max17040_write_reg(client, MAX17040_CMD_MSB, 0x54);
+	max17040_write_reg(client, MAX17040_CMD_LSB, 0x00);
+}
+
+static void max17040_set_rcomp(struct i2c_client *client, u16 val)
+{
+	max17040_write_reg(client, MAX17040_RCOMP_MSB, val >> 8);
+	max17040_write_reg(client, MAX17040_RCOMP_LSB, (val << 8) >> 8);
+}
+
+static void max17040_get_vcell(struct i2c_client *client)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+	u8 msb;
+	u8 lsb;
+
+	msb = max17040_read_reg(client, MAX17040_VCELL_MSB);
+	lsb = max17040_read_reg(client, MAX17040_VCELL_LSB);
+
+	chip->vcell = (msb << 4) + (lsb >> 4);
+}
+
+static void max17040_get_soc(struct i2c_client *client)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+	u8 msb;
+	u8 lsb;
+
+	msb = max17040_read_reg(client, MAX17040_SOC_MSB);
+	lsb = max17040_read_reg(client, MAX17040_SOC_LSB);
+
+	chip->soc = msb;
+}
+
+static void max17040_get_version(struct i2c_client *client)
+{
+	u8 msb;
+	u8 lsb;
+
+	msb = max17040_read_reg(client, MAX17040_VER_MSB);
+	lsb = max17040_read_reg(client, MAX17040_VER_LSB);
+
+	dev_info(&client->dev, "MAX17040 Fuel-Gauge Ver %d%d\n", msb, lsb);
+}
+
+static void max17040_get_online(struct i2c_client *client)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+
+	if (chip->pdata->battery_online)
+		chip->online = chip->pdata->battery_online();
+	else
+		chip->online = 1;
+}
+
+static void max17040_get_status(struct i2c_client *client)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+
+	if (!chip->pdata->charger_online || !chip->pdata->charger_enable) {
+		chip->status = POWER_SUPPLY_STATUS_UNKNOWN;
+		return;
+	}
+
+	if (chip->pdata->charger_online()) {
+		if (chip->pdata->charger_enable())
+			chip->status = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			chip->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	} else {
+		chip->status = POWER_SUPPLY_STATUS_DISCHARGING;
+	}
+
+	if (chip->soc > MAX17040_BATTERY_FULL)
+		chip->status = POWER_SUPPLY_STATUS_FULL;
+}
+
+static void max17040_work(struct work_struct *work)
+{
+	struct max17040_chip *chip;
+
+	chip = container_of(work, struct max17040_chip, work.work);
+
+	max17040_get_vcell(chip->client);
+	max17040_get_soc(chip->client);
+	max17040_get_online(chip->client);
+	max17040_get_status(chip->client);
+
+	schedule_delayed_work(&chip->work, MAX17040_DELAY);
+}
+
+static enum power_supply_property max17040_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+};
+
+static int __devinit max17040_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct max17040_chip *chip;
+	int ret;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
+		return -EIO;
+
+	chip = kzalloc(sizeof(struct max17040_chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->client = client;
+	chip->pdata = client->dev.platform_data;
+
+	i2c_set_clientdata(client, chip);
+
+	chip->battery.name		= "battery";
+	chip->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
+	chip->battery.get_property	= max17040_get_property;
+	chip->battery.properties	= max17040_battery_props;
+	chip->battery.num_properties	= ARRAY_SIZE(max17040_battery_props);
+
+	ret = power_supply_register(&client->dev, &chip->battery);
+	if (ret) {
+		dev_err(&client->dev, "failed: power supply register\n");
+		i2c_set_clientdata(client, NULL);
+		kfree(chip);
+		return ret;
+	}
+
+	max17040_reset(client);
+	max17040_get_version(client);
+
+	INIT_DELAYED_WORK_DEFERRABLE(&chip->work, max17040_work);
+	schedule_delayed_work(&chip->work, MAX17040_DELAY);
+
+	return 0;
+}
+
+static int __devexit max17040_remove(struct i2c_client *client)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+
+	power_supply_unregister(&chip->battery);
+	cancel_delayed_work(&chip->work);
+	i2c_set_clientdata(client, NULL);
+	kfree(chip);
+	return 0;
+}
+
+static int max17040_suspend(struct i2c_client *client,
+		pm_message_t state)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+
+	cancel_delayed_work(&chip->work);
+	return 0;
+}
+
+static int max17040_resume(struct i2c_client *client)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+
+	schedule_delayed_work(&chip->work, MAX17040_DELAY);
+	return 0;
+}
+
+static const struct i2c_device_id max17040_id[] = {
+	{ "max17040", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max17040_id);
+
+static struct i2c_driver max17040_i2c_driver = {
+	.driver	= {
+		.name	= "max17040",
+	},
+	.probe		= max17040_probe,
+	.remove		= __devexit_p(max17040_remove),
+	.suspend	= max17040_suspend,
+	.resume		= max17040_resume,
+	.id_table	= max17040_id,
+};
+
+static int __init max17040_init(void)
+{
+	return i2c_add_driver(&max17040_i2c_driver);
+}
+module_init(max17040_init);
+
+static void __exit max17040_exit(void)
+{
+	i2c_del_driver(&max17040_i2c_driver);
+}
+module_exit(max17040_exit);
+
+MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
+MODULE_DESCRIPTION("MAX17040 Fuel Gauge");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/max17040_battery.h b/include/linux/max17040_battery.h
new file mode 100644
index 0000000..ad97b06
--- /dev/null
+++ b/include/linux/max17040_battery.h
@@ -0,0 +1,19 @@
+/*
+ *  Copyright (C) 2009 Samsung Electronics
+ *  Minkyu Kang <mk7.kang@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MAX17040_BATTERY_H_
+#define __MAX17040_BATTERY_H_
+
+struct max17040_platform_data {
+	int (*battery_online)(void);
+	int (*charger_online)(void);
+	int (*charger_enable)(void);
+};
+
+#endif
-- 
1.5.4.3
