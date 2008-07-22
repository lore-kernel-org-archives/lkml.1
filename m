Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYGVFcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYGVFcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbYGVFXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbYGVFXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 31/79] Driver Core: add ability for class_for_each_device to start in middle of list
Date: Mon, 21 Jul 2008 22:18:55 -0700
Message-Id: <1216703983-21448-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mirrors the functionality that driver_for_each_device has as well.

We add a start variable, and all callers of the function are fixed up at
the same time.

The block layer will be using this new functionality in a follow-on
patch.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c              |   21 +++++++++++++--------
 drivers/i2c/i2c-core.c            |    6 ++++--
 drivers/ieee1394/nodemgr.c        |   14 +++++++++-----
 drivers/power/apm_power.c         |    2 +-
 drivers/power/power_supply_core.c |    4 ++--
 include/linux/device.h            |    3 ++-
 6 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 71ce3ff..2eb7048 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -256,11 +256,14 @@ char *make_class_name(const char *name, struct kobject *kobj)
 /**
  * class_for_each_device - device iterator
  * @class: the class we're iterating
+ * @start: the device to start with in the list, if any.
  * @data: data for the callback
  * @fn: function to be called for each device
  *
  * Iterate over @class's list of devices, and call @fn for each,
- * passing it @data.
+ * passing it @data.  If @start is set, the list iteration will start
+ * there, otherwise if it is NULL, the iteration starts at the
+ * beginning of the list.
  *
  * We check the return of @fn each time. If it returns anything
  * other than 0, we break out and return that value.
@@ -269,8 +272,8 @@ char *make_class_name(const char *name, struct kobject *kobj)
  * re-acquired in @fn, otherwise it will self-deadlocking. For
  * example, calls to add or remove class members would be verboten.
  */
-int class_for_each_device(struct class *class, void *data,
-			   int (*fn)(struct device *, void *))
+int class_for_each_device(struct class *class, struct device *start,
+			  void *data, int (*fn)(struct device *, void *))
 {
 	struct device *dev;
 	int error = 0;
@@ -279,12 +282,14 @@ int class_for_each_device(struct class *class, void *data,
 		return -EINVAL;
 	down(&class->sem);
 	list_for_each_entry(dev, &class->devices, node) {
+		if (start) {
+			if (start == dev)
+				start = NULL;
+			continue;
+		}
 		dev = get_device(dev);
-		if (dev) {
-			error = fn(dev, data);
-			put_device(dev);
-		} else
-			error = -ENODEV;
+		error = fn(dev, data);
+		put_device(dev);
 		if (error)
 			break;
 	}
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7608df8..7bf38c4 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -722,7 +722,8 @@ int i2c_register_driver(struct module *owner, struct i2c_driver *driver)
 
 	INIT_LIST_HEAD(&driver->clients);
 	/* Walk the adapters that are already present */
-	class_for_each_device(&i2c_adapter_class, driver, __attach_adapter);
+	class_for_each_device(&i2c_adapter_class, NULL, driver,
+			      __attach_adapter);
 
 	mutex_unlock(&core_lock);
 	return 0;
@@ -782,7 +783,8 @@ void i2c_del_driver(struct i2c_driver *driver)
 {
 	mutex_lock(&core_lock);
 
-	class_for_each_device(&i2c_adapter_class, driver, __detach_adapter);
+	class_for_each_device(&i2c_adapter_class, NULL, driver,
+			      __detach_adapter);
 
 	driver_unregister(&driver->driver);
 	pr_debug("i2c-core: driver [%s] unregistered\n", driver->driver.name);
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 05710c7..47c0d85 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1453,7 +1453,8 @@ static void nodemgr_suspend_ne(struct node_entry *ne)
 	ne->in_limbo = 1;
 	WARN_ON(device_create_file(&ne->device, &dev_attr_ne_in_limbo));
 
-	class_for_each_device(&nodemgr_ud_class, ne, __nodemgr_driver_suspend);
+	class_for_each_device(&nodemgr_ud_class, NULL, ne,
+			      __nodemgr_driver_suspend);
 }
 
 
@@ -1462,7 +1463,8 @@ static void nodemgr_resume_ne(struct node_entry *ne)
 	ne->in_limbo = 0;
 	device_remove_file(&ne->device, &dev_attr_ne_in_limbo);
 
-	class_for_each_device(&nodemgr_ud_class, ne, __nodemgr_driver_resume);
+	class_for_each_device(&nodemgr_ud_class, NULL, ne,
+			      __nodemgr_driver_resume);
 	HPSB_DEBUG("Node resumed: ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
 		   NODE_BUS_ARGS(ne->host, ne->nodeid), (unsigned long long)ne->guid);
 }
@@ -1498,7 +1500,8 @@ static int __nodemgr_update_pdrv(struct device *dev, void *data)
 
 static void nodemgr_update_pdrv(struct node_entry *ne)
 {
-	class_for_each_device(&nodemgr_ud_class, ne, __nodemgr_update_pdrv);
+	class_for_each_device(&nodemgr_ud_class, NULL, ne,
+			      __nodemgr_update_pdrv);
 }
 
 
@@ -1591,7 +1594,8 @@ static void nodemgr_node_probe(struct host_info *hi, int generation)
 	 * while probes are time-consuming. (Well, those probes need some
 	 * improvement...) */
 
-	class_for_each_device(&nodemgr_ne_class, &param, __nodemgr_node_probe);
+	class_for_each_device(&nodemgr_ne_class, NULL, &param,
+			      __nodemgr_node_probe);
 
 	/* If we had a bus reset while we were scanning the bus, it is
 	 * possible that we did not probe all nodes.  In that case, we
@@ -1826,7 +1830,7 @@ int nodemgr_for_each_host(void *data, int (*cb)(struct hpsb_host *, void *))
 
 	hip.cb = cb;
 	hip.data = data;
-	error = class_for_each_device(&hpsb_host_class, &hip,
+	error = class_for_each_device(&hpsb_host_class, NULL, &hip,
 				      __nodemgr_for_each_host);
 
 	return error;
diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index a489227..936bae5 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -78,7 +78,7 @@ static void find_main_battery(void)
 	main_battery = NULL;
 	bp.main = main_battery;
 
-	error = class_for_each_device(power_supply_class, &bp,
+	error = class_for_each_device(power_supply_class, NULL, &bp,
 				      __find_main_battery);
 	if (error) {
 		main_battery = bp.main;
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index af1633e..cb1ccb4 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -41,7 +41,7 @@ static void power_supply_changed_work(struct work_struct *work)
 
 	dev_dbg(psy->dev, "%s\n", __func__);
 
-	class_for_each_device(power_supply_class, psy,
+	class_for_each_device(power_supply_class, NULL, psy,
 			      __power_supply_changed_work);
 
 	power_supply_update_leds(psy);
@@ -79,7 +79,7 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 {
 	int error;
 
-	error = class_for_each_device(power_supply_class, psy,
+	error = class_for_each_device(power_supply_class, NULL, psy,
 				      __power_supply_am_i_supplied);
 
 	dev_dbg(psy->dev, "%s %d\n", __func__, error);
diff --git a/include/linux/device.h b/include/linux/device.h
index de17871..6d5b351 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -210,7 +210,8 @@ extern struct kobject *sysfs_dev_block_kobj;
 extern struct kobject *sysfs_dev_char_kobj;
 extern int __must_check class_register(struct class *class);
 extern void class_unregister(struct class *class);
-extern int class_for_each_device(struct class *class, void *data,
+extern int class_for_each_device(struct class *class, struct device *start,
+				 void *data,
 				 int (*fn)(struct device *dev, void *data));
 extern struct device *class_find_device(struct class *class, void *data,
 					int (*match)(struct device *, void *));
-- 
1.5.6.3

