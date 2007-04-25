Return-Path: <linux-kernel-owner+w=401wt.eu-S1031104AbXDYPzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031104AbXDYPzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031156AbXDYPy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:54:57 -0400
Received: from mail.z-net.ru ([89.113.80.10]:4357 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031104AbXDYPyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:54:47 -0400
Date: Wed, 25 Apr 2007 19:51:34 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 5/7] 1-Wire ds2760 chip battery driver
Message-ID: <20070425155110.GE4117@zarina>
References: <20070425154820.GA27300@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070425154820.GA27300@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is driver for batteries with ds2760 chip inside, found inside
almost every HP iPaq and HTC PDAs/phones.

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/battery/Kconfig          |    7 +
 drivers/battery/Makefile         |    2 +
 drivers/battery/ds2760_battery.c |  503 ++++++++++++++++++++++++++++++++++++++
 include/linux/ds2760_battery.h   |   32 +++
 4 files changed, 544 insertions(+), 0 deletions(-)
 create mode 100644 drivers/battery/ds2760_battery.c
 create mode 100644 include/linux/ds2760_battery.h

diff --git a/drivers/battery/Kconfig b/drivers/battery/Kconfig
index 7e7f9cd..7de72df 100644
--- a/drivers/battery/Kconfig
+++ b/drivers/battery/Kconfig
@@ -16,4 +16,11 @@ config APM_POWER
 	  Say Y here to enable support APM status emulation using
 	  battery class devices.
 
+config BATTERY_DS2760
+	tristate "DS2760 battery driver (HP iPAQ & others)"
+	depends on BATTERY && W1
+	select W1_SLAVE_DS2760
+	help
+	  Say Y here to enable support for batteries with ds2760 chip.
+
 endmenu
diff --git a/drivers/battery/Makefile b/drivers/battery/Makefile
index 8c0d648..1b0c624 100644
--- a/drivers/battery/Makefile
+++ b/drivers/battery/Makefile
@@ -9,3 +9,5 @@ obj-$(CONFIG_BATTERY)              += battery_leds.o
 endif
 
 obj-$(CONFIG_APM_POWER)            += apm_power.o
+
+obj-$(CONFIG_BATTERY_DS2760)       += ds2760_battery.o
diff --git a/drivers/battery/ds2760_battery.c b/drivers/battery/ds2760_battery.c
new file mode 100644
index 0000000..1f2712b
--- /dev/null
+++ b/drivers/battery/ds2760_battery.c
@@ -0,0 +1,503 @@
+/*
+ * Driver for batteries with DS2760 chips inside.
+ *
+ * Copyright (c) 2007 Anton Vorontsov
+ *               2004-2007 Matt Reimer
+ *               2004 Szabolcs Gyurko
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ *
+ * Author:  Anton Vorontsov <cbou@mail.ru>
+ *          February 2007
+ *
+ *          Matt Reimer <mreimer@vpop.net>
+ *          April 2004, 2005, 2007
+ *
+ *          Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
+ *          September 2004
+ */
+
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/jiffies.h>
+#include <linux/workqueue.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/ds2760_battery.h>
+
+#include "../w1/w1.h"
+#include "../w1/slaves/w1_ds2760.h"
+
+struct ds2760_device_info {
+	struct battery_info *bi;
+	struct device *dev;
+
+	/* DS2760 data, valid after calling ds2760_battery_read_status() */
+	unsigned long update_time;      /* jiffies when data read */
+	char raw[DS2760_DATA_SIZE];     /* raw DS2760 data */
+	int voltage_raw;                /* units of 4.88 mV */
+	int voltage_uV;                 /* units of uV */
+	int current_raw;                /* units of 0.625 mA */
+	int current_uA;                 /* units of uA */
+	int accum_current_raw;          /* units of 0.25 mAh */
+	int accum_current_uAh;          /* units of uAh */
+	int temp_raw;                   /* units of 0.125 C */
+	int temp_C;                     /* units of 0.1 C */
+	int rated_capacity;             /* units of uAh */
+	int rem_capacity;               /* percentage */
+	int full_active_uAh;            /* units of uAh */
+	int empty_uAh;                  /* units of uAh */
+	int life_sec;                   /* units of seconds */
+	int charge_status;              /* BATTERY_STATUS_* */
+
+	int full_counter;
+	struct battery batt;
+	struct device *w1_dev;
+	struct workqueue_struct *monitor_wqueue;
+	struct delayed_work monitor_work;
+};
+
+static unsigned int cache_time = 1000;
+module_param(cache_time, uint, 0644);
+MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
+
+/* Some batteries have their rated capacity stored a N * 10 mAh, while
+ * others use an index into this table. */
+static int rated_capacities[] = {
+	0,
+	920,        /* Samsung */
+	920,        /* BYD */
+	920,        /* Lishen */
+	920,        /* NEC */
+	1440,       /* Samsung */
+	1440,       /* BYD */
+	1440,       /* Lishen */
+	1440,       /* NEC */
+	2880,       /* Samsung */
+	2880,       /* BYD */
+	2880,       /* Lishen */
+	2880        /* NEC */
+};
+
+/* array is level at temps 0C, 10C, 20C, 30C, 40C
+ * temp is in Celsius */
+static int battery_interpolate(int array[], int temp)
+{
+	int index, dt;
+
+	if (temp <= 0)
+		return array[0];
+	if (temp >= 40)
+		return array[4];
+
+	index = temp / 10;
+	dt    = temp % 10;
+
+	return array[index] + (((array[index + 1] - array[index]) * dt) / 10);
+}
+
+static int ds2760_battery_read_status(struct ds2760_device_info *di)
+{
+	int ret, i, start, count, scale[5];
+
+	if (di->update_time && time_before(jiffies, di->update_time +
+	                                   msecs_to_jiffies(cache_time)))
+		return 0;
+
+	if (!di->w1_dev)
+		return 0;
+
+	/* The first time we read the entire contents of SRAM/EEPROM,
+	 * but after that we just read the interesting bits that change. */
+	if (di->update_time == 0) {
+		start = 0;
+		count = DS2760_DATA_SIZE;
+	}
+	else {
+		start = DS2760_VOLTAGE_MSB;
+		count = DS2760_TEMP_LSB - start + 1;
+	}
+
+	ret = w1_ds2760_read(di->w1_dev, di->raw + start, start, count);
+	if (ret != count) {
+		dev_warn(di->dev, "call to w1_ds2760_read failed (0x%08x)\n",
+		         (unsigned int)di->w1_dev);
+		return 1;
+	}
+
+	di->update_time = jiffies;
+
+	/* DS2760 reports voltage in units of 4.88mV, but the battery class
+	 * reports in units of uV, so convert by multiplying by 4880. */
+	di->voltage_raw = (di->raw[DS2760_VOLTAGE_MSB] << 3) |
+	                  (di->raw[DS2760_VOLTAGE_LSB] >> 5);
+	di->voltage_uV = di->voltage_raw * 4880;
+
+	/* DS2760 reports current in signed units of 0.625mA, but the battery
+	 * class reports in units of uA, so convert by multiplying by 625. */
+	di->current_raw =
+	    (((signed char)di->raw[DS2760_CURRENT_MSB]) << 5) |
+	                  (di->raw[DS2760_CURRENT_LSB] >> 3);
+	di->current_uA = di->current_raw * 625;
+
+	/* DS2760 reports accumulated current in signed units of 0.25mAh. */
+	di->accum_current_raw =
+	    (((signed char)di->raw[DS2760_CURRENT_ACCUM_MSB]) << 8) |
+	                   di->raw[DS2760_CURRENT_ACCUM_LSB];
+	di->accum_current_uAh = di->accum_current_raw * 250;
+
+	/* DS2760 reports temperature in signed units of 0.125C, but the
+	 * battery class reports in units of 1/10 C, so we convert by
+	 * multiplying by .125 * 10 = 1.25. */
+	di->temp_raw = (((signed char)di->raw[DS2760_TEMP_MSB]) << 3) |
+	                             (di->raw[DS2760_TEMP_LSB] >> 5);
+	di->temp_C = di->temp_raw + (di->temp_raw / 4);
+
+	/* At least some battery monitors (e.g. HP iPAQ) store the battery's
+	 * maximum rated capacity. */
+	if (di->raw[DS2760_RATED_CAPACITY] < ARRAY_SIZE(rated_capacities))
+		di->rated_capacity = rated_capacities[
+		        (unsigned int)di->raw[DS2760_RATED_CAPACITY]];
+	else
+		di->rated_capacity = di->raw[DS2760_RATED_CAPACITY] * 10;
+
+	di->rated_capacity *= 1000; /* convert to uAh */
+
+	/* Calculate the full level at the present temperature. */
+	di->full_active_uAh = di->raw[DS2760_ACTIVE_FULL] << 8 |
+	                      di->raw[DS2760_ACTIVE_FULL + 1];
+
+	scale[0] = di->raw[DS2760_ACTIVE_FULL] << 8 |
+	           di->raw[DS2760_ACTIVE_FULL + 1];
+	for (i = 1; i < 5; i++)
+		scale[i] = scale[i - 1] + di->raw[DS2760_ACTIVE_FULL + 2 + i];
+
+	di->full_active_uAh = battery_interpolate(scale, di->temp_C / 10);
+	di->full_active_uAh *= 1000; /* convert to uAh */
+
+	/* Calculate the empty level at the present temperature. */
+	scale[4] = di->raw[DS2760_ACTIVE_EMPTY + 4];
+	for (i = 3; i >= 0; i--)
+		scale[i] = scale[i + 1] + di->raw[DS2760_ACTIVE_EMPTY + i];
+
+	di->empty_uAh = battery_interpolate(scale, di->temp_C / 10);
+	di->empty_uAh *= 1000; /* convert to uAh */
+
+	/* From Maxim Application Note 131: remaining capacity =
+	 * ((ICA - Empty Value) / (Full Value - Empty Value)) x 100% */
+	di->rem_capacity = ((di->accum_current_uAh - di->empty_uAh) * 100L) /
+	                    (di->full_active_uAh - di->empty_uAh);
+
+	if (di->rem_capacity < 0)
+		di->rem_capacity = 0;
+	if (di->rem_capacity > 100)
+		di->rem_capacity = 100;
+
+	if (di->current_uA)
+		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) *
+		                 3600L) / di->current_uA;
+	else
+		di->life_sec = 0;
+
+	return 0;
+}
+
+static void ds2760_battery_update_status(struct ds2760_device_info *di)
+{
+	int old_charge_status = di->charge_status;
+
+	ds2760_battery_read_status(di);
+
+	if (di->charge_status == BATTERY_STATUS_UNKNOWN)
+		di->full_counter = 0;
+
+	if (battery_is_external_power_supplied(&di->batt)) {
+		if (di->current_uA > 10000) {
+			di->charge_status = BATTERY_STATUS_CHARGING;
+			di->full_counter = 0;
+		}
+		else if (di->current_uA < -5000) {
+			if (di->charge_status != BATTERY_STATUS_NOT_CHARGING)
+				dev_notice(di->dev, "not enough power to "
+				           "charge\n");
+			di->charge_status = BATTERY_STATUS_NOT_CHARGING;
+			di->full_counter = 0;
+		}
+		else if (di->current_uA < 10000 &&
+		            di->charge_status != BATTERY_STATUS_FULL) {
+
+			/* Don't consider the battery to be full unless
+			 * we've seen the current < 10 mA at least two
+			 * consecutive times. */
+
+			di->full_counter++;
+
+			if (di->full_counter < 2)
+				di->charge_status = BATTERY_STATUS_CHARGING;
+			else {
+				unsigned char acr[2];
+				int acr_val;
+
+				/* acr is in units of 0.25 mAh */
+				acr_val = di->full_active_uAh * 4L / 1000;
+
+				acr[0] = acr_val >> 8;
+				acr[1] = acr_val & 0xff;
+
+				if (w1_ds2760_write(di->w1_dev, acr,
+				    DS2760_CURRENT_ACCUM_MSB, 2) < 2)
+					dev_warn(di->dev,
+					         "ACR reset failed\n");
+
+				di->charge_status = BATTERY_STATUS_FULL;
+			}
+		}
+	}
+	else {
+		di->charge_status = BATTERY_STATUS_DISCHARGING;
+		di->full_counter = 0;
+	}
+
+	if (di->charge_status != old_charge_status)
+		battery_status_changed(&di->batt);
+
+	return;
+}
+
+static int ds2760_battery_match_callback(struct device *dev, void *data)
+{
+	struct w1_slave *sl;
+
+	if (!(dev->driver && dev->driver->name &&
+	     (strcmp(dev->driver->name, "w1_slave_driver") == 0)))
+		return 0;
+
+	sl = container_of(dev, struct w1_slave, dev);
+
+	/* DS2760 w1 slave device names begin with the family number 0x30. */
+	if (strncmp(sl->name, "30-", 3) != 0)
+		return 0;
+
+	return 1;
+}
+
+static void ds2760_battery_work(struct work_struct *work)
+{
+	struct ds2760_device_info *di = container_of(work,
+		struct ds2760_device_info, monitor_work.work);
+	struct bus_type *bus;
+	int interval = HZ * 60;
+
+	dev_dbg(di->dev, "%s\n", __FUNCTION__);
+
+	if (!di->w1_dev) {
+		/* Get the battery w1 slave device. */
+		bus = find_bus("w1");
+		if (bus)
+			di->w1_dev = bus_find_device(bus, NULL, NULL,
+			                   ds2760_battery_match_callback);
+
+		if (!di->w1_dev) {
+			dev_dbg(di->dev, "no w1 dev found\n");
+			interval = HZ * 10;
+			goto again_please;
+		}
+		dev_dbg(di->dev, "w1 dev found\n");
+	}
+
+	ds2760_battery_update_status(di);
+
+again_please:
+	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, interval);
+	return;
+}
+
+#define to_ds2760_device_info(x) container_of((x), struct ds2760_device_info, \
+                                              batt);
+
+static void ds2760_battery_external_power_changed(struct battery *bat)
+{
+	struct ds2760_device_info *di = to_ds2760_device_info(bat);
+
+	dev_dbg(di->dev, "%s\n", __FUNCTION__);
+
+	cancel_delayed_work(&di->monitor_work);
+	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ/10);
+
+	return;
+}
+
+static void *ds2760_battery_get_property(struct battery *bat,
+                                         enum battery_property bp)
+{
+	struct ds2760_device_info *di = to_ds2760_device_info(bat);
+
+	switch (bp) {
+	case BATTERY_PROP_VOLTAGE_MAX_DESIGN:
+		return &di->bi->voltage_max_design;
+	case BATTERY_PROP_STATUS:
+		return &di->charge_status;
+	default:
+		break;
+	};
+
+	ds2760_battery_read_status(di);
+
+	switch (bp) {
+	case BATTERY_PROP_VOLTAGE_NOW:
+		return &di->voltage_uV;
+	case BATTERY_PROP_CURRENT_NOW:
+		return &di->current_uA;
+	case BATTERY_PROP_CHARGE_FULL_DESIGN:
+		return &di->rated_capacity;
+	case BATTERY_PROP_CHARGE_FULL:
+		return &di->full_active_uAh;
+	case BATTERY_PROP_CHARGE_EMPTY:
+		return &di->empty_uAh;
+	case BATTERY_PROP_CHARGE_NOW:
+		return &di->accum_current_uAh;
+	case BATTERY_PROP_TEMP:
+		return &di->temp_C;
+	default: break;
+	};
+
+	return NULL;
+}
+
+static enum battery_property ds2760_battery_properties[] = {
+	BATTERY_PROP_STATUS,
+	BATTERY_PROP_VOLTAGE_MAX_DESIGN,
+	BATTERY_PROP_VOLTAGE_NOW,
+	BATTERY_PROP_CURRENT_NOW,
+	BATTERY_PROP_CHARGE_FULL_DESIGN,
+	BATTERY_PROP_CHARGE_FULL,
+	BATTERY_PROP_CHARGE_EMPTY,
+	BATTERY_PROP_CHARGE_NOW,
+	BATTERY_PROP_TEMP,
+};
+
+static int ds2760_battery_probe(struct platform_device *pdev)
+{
+	int retval = 0;
+	struct ds2760_device_info *di;
+	struct ds2760_platform_data *pdata;
+
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		retval = -ENOMEM;
+		goto di_alloc_failed;
+	}
+
+	platform_set_drvdata(pdev, di);
+
+	pdata = pdev->dev.platform_data;
+	di->bi = &pdata->battery_info;
+	di->dev = &pdev->dev;
+
+	di->batt.name           = di->bi->name;
+	di->batt.properties     = ds2760_battery_properties;
+	di->batt.num_properties = ARRAY_SIZE(ds2760_battery_properties);
+	di->batt.get_property   = ds2760_battery_get_property;
+	di->batt.external_power_changed =
+	                          ds2760_battery_external_power_changed;
+
+	di->charge_status = BATTERY_STATUS_UNKNOWN;
+
+	retval = battery_register(&pdev->dev, &di->batt);
+	if (retval) {
+		dev_err(di->dev, "failed to register battery");
+		goto batt_failed;
+	}
+
+	INIT_DELAYED_WORK(&di->monitor_work, ds2760_battery_work);
+	di->monitor_wqueue = create_singlethread_workqueue("ds2760_mon");
+	if (!di->monitor_wqueue) {
+		retval = -ESRCH;
+		goto workqueue_failed;
+	}
+	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ * 1);
+
+	goto success;
+
+workqueue_failed:
+	battery_unregister(&di->batt);
+batt_failed:
+	kfree(di);
+di_alloc_failed:
+success:
+	return retval;
+}
+
+static int ds2760_battery_remove(struct platform_device *pdev)
+{
+	struct ds2760_device_info *di = platform_get_drvdata(pdev);
+
+	cancel_rearming_delayed_workqueue(di->monitor_wqueue,
+	                                  &di->monitor_work);
+	destroy_workqueue(di->monitor_wqueue);
+	battery_unregister(&di->batt);
+	if (di->w1_dev)
+		put_device(di->w1_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ds2760_battery_suspend(struct platform_device *pdev,
+                                  pm_message_t state)
+{
+	struct ds2760_device_info *di = platform_get_drvdata(pdev);
+
+	di->charge_status = BATTERY_STATUS_UNKNOWN;
+	battery_status_changed(&di->batt);
+
+	return 0;
+}
+
+static int ds2760_battery_resume(struct platform_device *pdev)
+{
+	struct ds2760_device_info *di = platform_get_drvdata(pdev);
+
+	di->charge_status = BATTERY_STATUS_UNKNOWN;
+	battery_status_changed(&di->batt);
+
+	cancel_delayed_work(&di->monitor_work);
+	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ);
+
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+static struct platform_driver ds2760_battery_driver = {
+	.driver = {
+		.name = "ds2760-battery",
+	},
+	.probe	  = ds2760_battery_probe,
+	.remove   = ds2760_battery_remove,
+#ifdef CONFIG_PM
+	.suspend  = ds2760_battery_suspend,
+	.resume	  = ds2760_battery_resume,
+#endif
+};
+
+static int __init ds2760_battery_init(void)
+{
+	return platform_driver_register(&ds2760_battery_driver);
+}
+
+static void __exit ds2760_battery_exit(void)
+{
+	platform_driver_unregister(&ds2760_battery_driver);
+	return;
+}
+
+module_init(ds2760_battery_init);
+module_exit(ds2760_battery_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>, "
+              "Matt Reimer <mreimer@vpop.net>, "
+              "Anton Vorontsov <cbou@mail.ru>");
+MODULE_DESCRIPTION("ds2760 battery driver");
diff --git a/include/linux/ds2760_battery.h b/include/linux/ds2760_battery.h
new file mode 100644
index 0000000..a614b6a
--- /dev/null
+++ b/include/linux/ds2760_battery.h
@@ -0,0 +1,32 @@
+/*
+ * Driver for batteries with DS2760 chips inside.
+ *
+ * Copyright (c) 2007 Anton Vorontsov
+ *               2004-2007 Matt Reimer
+ *               2004 Szabolcs Gyurko
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ *
+ * Author:  Anton Vorontsov <cbou@mail.ru>
+ *          February 2007
+ *
+ *          Matt Reimer <mreimer@vpop.net>
+ *          April 2004, 2005, 2007
+ *
+ *          Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
+ *          September 2004
+ */
+
+#ifndef __DS2760_BATTERY__
+#define __DS2760_BATTERY__
+
+#include <linux/battery.h>
+
+struct ds2760_platform_data {
+	/* Battery information and characteristics. */
+	struct battery_info battery_info;
+};
+
+#endif
-- 
1.5.1.1-dirty

