Return-Path: <linux-kernel-owner+w=401wt.eu-S1761704AbXEOQnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761704AbXEOQnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbXEOQnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:43:42 -0400
Received: from mx27.mail.ru ([194.67.23.64]:16297 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbXEOQnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:43:41 -0400
Date: Tue, 15 May 2007 20:41:29 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: + git-battery-fix.patch added to -mm tree
Message-ID: <20070515164129.GA8077@zarina>
Reply-To: cbou@mail.ru
References: <200705081001.l48A1KUK020833@shell0.pdx.osdl.net> <20070508111924.GA16785@zarina> <20070508121341.GA21072@2ka.mipt.ru> <20070513092752.GE11249@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070513092752.GE11249@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 02:27:52AM -0700, Greg KH wrote:
> On Tue, May 08, 2007 at 04:13:42PM +0400, Evgeniy Polyakov wrote:
> > So, my vote is for exporting generic find_bus in mainline with related
> > to w1 and battery status changes.
> 
> Ok, I'm convinced, can someone resend that patch to me again?  I seem to
> have lost it in the ether somewhere :(

Heh.. while you're convinced, I'm not any longer. It seems I've found way
to not use find_bus.

I would thank you for being so exacting, and pushing on me to find this
way. ;-)

Here how it's done:

>From now not platform code (arch/) registering ds2760 battery devices, but
w1 slave driver, it passing w1 slave device as .parent field for
platfrom sub-device. So, we getting w1 slave device from the start, thus
don't need bus type to iterate through it finding proper device.

The only "bad" effect of that change is that platform code can not give
exact names to the ds2760 batteries (like "main-battery"), now it's named
as "ds2760-battery.N". Though, there is really good effect also...
ds2760_battery driver can handle multiple batteries found on w1 bus.

 2 files changed, 51 insertions(+), 53 deletions(-)

-2 lines total <- another prove of correctness. ;-)

Looks good, isn't it?

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 86c562c..29032ec 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -25,13 +25,12 @@
 #include <linux/workqueue.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
-#include <linux/ds2760_battery.h>
+#include <linux/power_supply.h>
 
 #include "../w1/w1.h"
 #include "../w1/slaves/w1_ds2760.h"
 
 struct ds2760_device_info {
-	struct power_supply_info *bi;
 	struct device *dev;
 
 	/* DS2760 data, valid after calling ds2760_battery_read_status() */
@@ -106,9 +105,6 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
 	                                   msecs_to_jiffies(cache_time)))
 		return 0;
 
-	if (!di->w1_dev)
-		return 0;
-
 	/* The first time we read the entire contents of SRAM/EEPROM,
 	 * but after that we just read the interesting bits that change. */
 	if (di->update_time == 0) {
@@ -266,51 +262,17 @@ static void ds2760_battery_update_status(struct ds2760_device_info *di)
 	return;
 }
 
-static int ds2760_battery_match_callback(struct device *dev, void *data)
-{
-	struct w1_slave *sl;
-
-	if (!(dev->driver && dev->driver->name &&
-	     (strcmp(dev->driver->name, "w1_slave_driver") == 0)))
-		return 0;
-
-	sl = container_of(dev, struct w1_slave, dev);
-
-	/* DS2760 w1 slave device names begin with the family number 0x30. */
-	if (strncmp(sl->name, "30-", 3) != 0)
-		return 0;
-
-	return 1;
-}
-
 static void ds2760_battery_work(struct work_struct *work)
 {
 	struct ds2760_device_info *di = container_of(work,
 		struct ds2760_device_info, monitor_work.work);
-	struct bus_type *bus;
-	int interval = HZ * 60;
+	const int interval = HZ * 60;
 
 	dev_dbg(di->dev, "%s\n", __FUNCTION__);
 
-	if (!di->w1_dev) {
-		/* Get the battery w1 slave device. */
-		bus = find_bus("w1");
-		if (bus)
-			di->w1_dev = bus_find_device(bus, NULL, NULL,
-			                   ds2760_battery_match_callback);
-
-		if (!di->w1_dev) {
-			dev_dbg(di->dev, "no w1 dev found\n");
-			interval = HZ * 10;
-			goto again_please;
-		}
-		dev_dbg(di->dev, "w1 dev found\n");
-	}
-
 	ds2760_battery_update_status(di);
-
-again_please:
 	queue_delayed_work(di->monitor_wqueue, &di->monitor_work, interval);
+
 	return;
 }
 
@@ -336,9 +298,6 @@ static int ds2760_battery_get_property(struct power_supply *psy,
 	struct ds2760_device_info *di = to_ds2760_device_info(psy);
 
 	switch (psp) {
-	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
-		val->intval = di->bi->voltage_max_design;
-		return 0;
 	case POWER_SUPPLY_PROP_STATUS:
 		val->intval = di->charge_status;
 		return 0;
@@ -379,7 +338,6 @@ static int ds2760_battery_get_property(struct power_supply *psy,
 
 static enum power_supply_property ds2760_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
-	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
@@ -404,10 +362,9 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, di);
 
 	pdata = pdev->dev.platform_data;
-	di->bi = &pdata->battery_info;
-	di->dev = &pdev->dev;
-
-	di->bat.name           = di->bi->name;
+	di->dev                = &pdev->dev;
+	di->w1_dev             = pdev->dev.parent;
+	di->bat.name           = pdev->dev.bus_id;
 	di->bat.type           = POWER_SUPPLY_TYPE_BATTERY;
 	di->bat.properties     = ds2760_battery_props;
 	di->bat.num_properties = ARRAY_SIZE(ds2760_battery_props);
@@ -424,7 +381,7 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 	}
 
 	INIT_DELAYED_WORK(&di->monitor_work, ds2760_battery_work);
-	di->monitor_wqueue = create_singlethread_workqueue("ds2760_mon");
+	di->monitor_wqueue = create_singlethread_workqueue(pdev->dev.bus_id);
 	if (!di->monitor_wqueue) {
 		retval = -ESRCH;
 		goto workqueue_failed;
@@ -450,8 +407,6 @@ static int ds2760_battery_remove(struct platform_device *pdev)
 	                                  &di->monitor_work);
 	destroy_workqueue(di->monitor_wqueue);
 	power_supply_unregister(&di->bat);
-	if (di->w1_dev)
-		put_device(di->w1_dev);
 
 	return 0;
 }
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index 5a340d1..45d4e32 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -13,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -82,14 +84,55 @@ static struct bin_attribute w1_ds2760_bin_attr = {
 	.read = w1_ds2760_read_bin,
 };
 
+static int bat_id;
+static DEFINE_MUTEX(bat_id_lock);
+
 static int w1_ds2760_add_slave(struct w1_slave *sl)
 {
-	return sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
+	int ret;
+	struct platform_device *pdev;
+
+	mutex_lock(&bat_id_lock);
+	pdev = platform_device_alloc("ds2760-battery", bat_id++);
+	if (!pdev) {
+		ret = -ENOMEM;
+		goto pdev_alloc_failed;
+	}
+	pdev->dev.parent = &sl->dev;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto pdev_add_failed;
+
+	ret = sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
+	if (ret)
+		goto bin_attr_failed;
+
+	dev_set_drvdata(&sl->dev, pdev);
+
+	goto success;
+
+bin_attr_failed:
+pdev_add_failed:
+	platform_device_unregister(pdev);
+pdev_alloc_failed:
+	bat_id--;
+success:
+	mutex_unlock(&bat_id_lock);
+	return ret;
 }
 
 static void w1_ds2760_remove_slave(struct w1_slave *sl)
 {
+	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
+
+	mutex_lock(&bat_id_lock);
+	bat_id--;
+	platform_device_unregister(pdev);
+	mutex_unlock(&bat_id_lock);
 	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
+
+	return;
 }
 
 static struct w1_family_ops w1_ds2760_fops = {
