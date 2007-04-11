Return-Path: <linux-kernel-owner+w=401wt.eu-S1161346AbXDKX4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161346AbXDKX4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXDKX4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:56:30 -0400
Received: from mail.z-net.ru ([89.113.80.10]:1646 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbXDKX43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:56:29 -0400
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 19:56:28 EDT
Date: Thu, 12 Apr 2007 03:25:45 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: [PATCH 6/7] [RFC] ds2760 battery driver
Message-ID: <20070411232522.GF20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is driver for batteries with ds2760 chip inside. Such batteries
used in almost every HP iPaq and HTC PDAs/phones.

---
 drivers/battery/Kconfig          |    7 +
 drivers/battery/Makefile         |    1 +
 drivers/battery/ds2760_battery.c |  466 ++++++++++++++++++++++++++++++++++++++
 include/linux/ds2760_battery.h   |   32 +++
 4 files changed, 506 insertions(+), 0 deletions(-)
 create mode 100644 drivers/battery/ds2760_battery.c
 create mode 100644 include/linux/ds2760_battery.h

diff --git a/drivers/battery/Kconfig b/drivers/battery/Kconfig
index c386593..0c14ae0 100644
--- a/drivers/battery/Kconfig
+++ b/drivers/battery/Kconfig
@@ -8,4 +8,11 @@ config BATTERY
 	  Say Y here to enable generic battery status reporting in
 	  the /sys filesystem.
 
+config BATTERY_DS2760
+	tristate "DS2760 battery driver (HP iPAQ & others)"
+	depends on BATTERY && W1
+	select W1_SLAVE_DS2760
+	help
+	  Say Y here to enable support for batteries with ds2760 chip.
+
 endmenu
diff --git a/drivers/battery/Makefile b/drivers/battery/Makefile
index a2239cb..9902513 100644
--- a/drivers/battery/Makefile
+++ b/drivers/battery/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_BATTERY)              += battery.o
+obj-$(CONFIG_BATTERY_DS2760)       += ds2760_battery.o
diff --git a/drivers/battery/ds2760_battery.c b/drivers/battery/ds2760_battery.c
new file mode 100644
index 0000000..a686304
--- /dev/null
+++ b/drivers/battery/ds2760_battery.c
@@ -0,0 +1,466 @@
+/*
+ * Driver for batteries with DS2760 chips inside.
+ *
+ * Copyright (c) 2007 Anton Vorontsov
+ *               2004 Matt Reimer
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
+ *          April 2004, 2005
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
+
+	/* DS2760 data, valid after calling ds2760_battery_read_status() */
+	unsigned long update_time;      /* jiffies when data read */
+	char raw[DS2760_DATA_SIZE];     /* raw DS2760 data */
+	int voltage_raw;                /* units of 4.88 mV */
+	int voltage_mV;                 /* units of mV */
+	int current_raw;                /* units of 0.625 mA */
+	int current_mA;                 /* units of mA */
+	int accum_current_raw;          /* units of 0.25 mAh */
+	int accum_current_mAh;          /* units of mAh */
+	int temp_raw;                   /* units of 0.125 C */
+	int temp_C;                     /* units of 0.1 C */
+	int rated_capacity;             /* units of mAh */
+	int rem_capacity;               /* percentage */
+	int full_active_mAh;            /* units of mAh */
+	int empty_mAh;                  /* units of mAh */
+	int life_min;                   /* units of minutes */
+	int charge_status;              /* BATTERY_STATUS_* */
+
+	int full_counter;
+	struct battery batt_cdev;
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
+		printk("call to w1_ds2760_read failed (0x%08x)\n",
+		       (unsigned int)di->w1_dev);
+		return 1;
+	}
+
+	di->update_time = jiffies;
+
+	/* DS2760 reports voltage in units of 4.88mV, but the battery class
+	 * reports in units of mV, so convert by multiplying by 4.875.
+	 * We approximate because integer math is cheap, and close enough. */
+	di->voltage_raw = (di->raw[DS2760_VOLTAGE_MSB] << 3) |
+	                  (di->raw[DS2760_VOLTAGE_LSB] >> 5);
+	di->voltage_mV = (di->voltage_raw * 5) - (di->voltage_raw / 8);
+
+	/* DS2760 reports current in signed units of 0.625mA, but the battery
+	 * class reports in units of mA, so convert by multiplying by 0.625. */
+	di->current_raw =
+	    (((signed char)di->raw[DS2760_CURRENT_MSB]) << 5) |
+	                  (di->raw[DS2760_CURRENT_LSB] >> 3);
+	di->current_mA = (di->current_raw / 2) + (di->current_raw / 8);
+
+	/* DS2760 reports accumulated current in signed units of 0.25mAh. */
+	di->accum_current_raw =
+	    (((signed char)di->raw[DS2760_CURRENT_ACCUM_MSB]) << 8) |
+	                   di->raw[DS2760_CURRENT_ACCUM_LSB];
+	di->accum_current_mAh = di->accum_current_raw / 4;
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
+	/* Calculate the full level at the present temperature. */
+	di->full_active_mAh = di->raw[DS2760_ACTIVE_FULL] << 8 |
+	                      di->raw[DS2760_ACTIVE_FULL + 1];
+
+	scale[0] = di->raw[DS2760_ACTIVE_FULL] << 8 |
+	           di->raw[DS2760_ACTIVE_FULL + 1];
+	for (i = 1; i < 5; i++)
+		scale[i] = scale[i - 1] + di->raw[DS2760_ACTIVE_FULL + 2 + i];
+
+	di->full_active_mAh = battery_interpolate(scale, di->temp_C / 10);
+
+	/* Calculate the empty level at the present temperature. */
+	scale[4] = di->raw[DS2760_ACTIVE_EMPTY + 4];
+	for (i = 3; i >= 0; i--)
+		scale[i] = scale[i + 1] + di->raw[DS2760_ACTIVE_EMPTY + i];
+
+	di->empty_mAh = battery_interpolate(scale, di->temp_C / 10);
+
+	/* From Maxim Application Note 131: remaining capacity =
+	 * ((ICA - Empty Value) / (Full Value - Empty Value)) x 100% */
+	di->rem_capacity = ((di->accum_current_mAh - di->empty_mAh) * 100) /
+	                    (di->full_active_mAh - di->empty_mAh);
+
+	if (di->rem_capacity < 0)
+		di->rem_capacity = 0;
+	if (di->rem_capacity > 100)
+		di->rem_capacity = 100;
+
+	if (di->current_mA)
+		di->life_min = -((di->accum_current_mAh - di->empty_mAh) *
+		                 60) / di->current_mA;
+	else
+		di->life_min = 0;
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
+	if (battery_is_external_power_supplied(&di->batt_cdev)) {
+		if (di->current_mA > 10) {
+			di->charge_status = BATTERY_STATUS_CHARGING;
+			di->full_counter = 0;
+		}
+		else if (di->current_mA < -5) {
+			if (di->charge_status != BATTERY_STATUS_DISCHARGING)
+				printk(KERN_WARNING "%s: not enough power to "
+				       "charge\n", di->bi->name);
+			di->charge_status = BATTERY_STATUS_DISCHARGING;
+			di->full_counter = 0;
+		}
+		else if (di->current_mA < 10 &&
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
+
+				acr[0] = (di->full_active_mAh * 4) >> 8;
+				acr[1] = (di->full_active_mAh * 4) & 0xff;
+
+				if (w1_ds2760_write(di->w1_dev, acr,
+				    DS2760_CURRENT_ACCUM_MSB, 2) < 2)
+					printk(KERN_ERR "ACR reset failed\n");
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
+		battery_status_changed(&di->batt_cdev);
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
+	if (!di->w1_dev) {
+		/* Get the battery w1 slave device. */
+		bus = find_bus("w1");
+		if (bus)
+			di->w1_dev = bus_find_device(bus, NULL, NULL,
+			                   ds2760_battery_match_callback);
+
+		if (!di->w1_dev) {
+			pr_debug("%s: no dev found\n", __FUNCTION__);
+			interval = HZ * 10;
+			goto again_please;
+		}
+		pr_debug("%s: dev found\n", __FUNCTION__);
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
+                                              batt_cdev);
+
+static void ds2760_battery_external_power_changed(struct battery *bat)
+{
+	struct ds2760_device_info *di = to_ds2760_device_info(bat);
+	cancel_delayed_work(&di->monitor_work);
+	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, HZ/10);
+	return;
+}
+
+#define ds2760_cdev_prop(x,y,z)                                             \
+        static int ds2760_battery_get_##y(struct battery *bat)              \
+        {                                                                   \
+                struct ds2760_device_info *di = to_ds2760_device_info(bat); \
+                if (x)                                                      \
+                        ds2760_battery_read_status(di);                     \
+                return di->z;                                               \
+        }
+
+ds2760_cdev_prop(0, max_voltage, bi->max_voltage);
+ds2760_cdev_prop(0, min_voltage, bi->min_voltage);
+ds2760_cdev_prop(1, voltage, voltage_mV);
+ds2760_cdev_prop(0, max_current, bi->max_current);
+ds2760_cdev_prop(0, min_current, bi->min_current);
+ds2760_cdev_prop(1, current, current_mA);
+ds2760_cdev_prop(1, max_capacity, full_active_mAh);
+ds2760_cdev_prop(1, min_capacity, empty_mAh);
+ds2760_cdev_prop(1, capacity, accum_current_mAh);
+ds2760_cdev_prop(1, temp, temp_C);
+ds2760_cdev_prop(0, status, charge_status);
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
+
+	di->batt_cdev.name             = di->bi->name;
+	di->batt_cdev.get_voltage      = ds2760_battery_get_voltage;
+	di->batt_cdev.get_min_voltage  = ds2760_battery_get_min_voltage;
+	di->batt_cdev.get_max_voltage  = ds2760_battery_get_max_voltage;
+	di->batt_cdev.get_current      = ds2760_battery_get_current;
+	di->batt_cdev.get_min_current  = ds2760_battery_get_min_current;
+	di->batt_cdev.get_max_current  = ds2760_battery_get_max_current;
+	di->batt_cdev.get_capacity     = ds2760_battery_get_capacity;
+	di->batt_cdev.get_min_capacity = ds2760_battery_get_min_capacity;
+	di->batt_cdev.get_max_capacity = ds2760_battery_get_max_capacity;
+	di->batt_cdev.get_temp         = ds2760_battery_get_temp;
+	di->batt_cdev.get_status       = ds2760_battery_get_status;
+	di->batt_cdev.external_power_changed =
+	                          ds2760_battery_external_power_changed;
+
+	di->charge_status = BATTERY_STATUS_UNKNOWN;
+
+	retval = battery_register(&pdev->dev, &di->batt_cdev);
+	if (retval) {
+		printk(KERN_ERR "Failed to register class dev for %s",
+		       pdev->name);
+		goto batt_cdev_failed;
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
+	battery_unregister(&di->batt_cdev);
+batt_cdev_failed:
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
+	battery_unregister(&di->batt_cdev);
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
+	battery_status_changed(&di->batt_cdev);
+
+	return 0;
+}
+
+static int ds2760_battery_resume(struct platform_device *pdev)
+{
+	struct ds2760_device_info *di = platform_get_drvdata(pdev);
+
+	di->charge_status = BATTERY_STATUS_UNKNOWN;
+	battery_status_changed(&di->batt_cdev);
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
+	#ifdef CONFIG_PM
+	.suspend  = ds2760_battery_suspend,
+	.resume	  = ds2760_battery_resume,
+	#endif
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
index 0000000..2937a54
--- /dev/null
+++ b/include/linux/ds2760_battery.h
@@ -0,0 +1,32 @@
+/*
+ * Driver for batteries with DS2760 chips inside.
+ *
+ * Copyright (c) 2007 Anton Vorontsov
+ *               2004 Matt Reimer
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
+ *          April 2004, 2005
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
1.5.0.5-dirty
