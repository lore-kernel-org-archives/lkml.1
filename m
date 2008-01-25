Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbYAYIXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbYAYIXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbYAYIBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764085AbYAYH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 152/196] Driver core: clean up debugging messages
Date: Thu, 24 Jan 2008 23:33:01 -0800
Message-Id: <1201246425-5058-73-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core debugging messages are a mess.  This provides a unified
message that makes them actually useful.

The format for new kobject debug messages should be:
	driver/bus/class: 'OBJECT_NAME': FUNCTION_NAME: message.\n

Note, the class code is not changed in this patch due to pending patches
in my queue that this would conflict with.  A later patch will clean
them up.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c  |   14 +++++++-------
 drivers/base/core.c |   23 +++++++++++++----------
 drivers/base/dd.c   |   16 ++++++++--------
 3 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index aa0c986..937fc10 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -80,7 +80,7 @@ static void driver_release(struct kobject *kobj)
 {
 	struct driver_private *drv_priv = to_driver(kobj);
 
-	pr_debug("%s: freeing %s\n", __FUNCTION__, kobject_name(kobj));
+	pr_debug("driver: '%s': %s\n", kobject_name(kobj), __FUNCTION__);
 	kfree(drv_priv);
 }
 
@@ -446,7 +446,7 @@ int bus_add_device(struct device * dev)
 	int error = 0;
 
 	if (bus) {
-		pr_debug("bus %s: add device %s\n", bus->name, dev->bus_id);
+		pr_debug("bus: '%s': add device %s\n", bus->name, dev->bus_id);
 		error = device_add_attrs(bus, dev);
 		if (error)
 			goto out_put;
@@ -519,7 +519,7 @@ void bus_remove_device(struct device * dev)
 			dev->is_registered = 0;
 			klist_del(&dev->knode_bus);
 		}
-		pr_debug("bus %s: remove device %s\n", dev->bus->name, dev->bus_id);
+		pr_debug("bus: '%s': remove device %s\n", dev->bus->name, dev->bus_id);
 		device_release_driver(dev);
 		bus_put(dev->bus);
 	}
@@ -637,7 +637,7 @@ int bus_add_driver(struct device_driver *drv)
 	if (!bus)
 		return -EINVAL;
 
-	pr_debug("bus %s: add driver %s\n", bus->name, drv->name);
+	pr_debug("bus: '%s': add driver %s\n", bus->name, drv->name);
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -707,7 +707,7 @@ void bus_remove_driver(struct device_driver * drv)
 	driver_remove_attrs(drv->bus, drv);
 	driver_remove_file(drv, &driver_attr_uevent);
 	klist_remove(&drv->p->knode_bus);
-	pr_debug("bus %s: remove driver %s\n", drv->bus->name, drv->name);
+	pr_debug("bus: '%s': remove driver %s\n", drv->bus->name, drv->name);
 	driver_detach(drv);
 	module_remove_driver(drv);
 	kobject_unregister(&drv->p->kobj);
@@ -907,7 +907,7 @@ int bus_register(struct bus_type * bus)
 	if (retval)
 		goto bus_attrs_fail;
 
-	pr_debug("bus type '%s' registered\n", bus->name);
+	pr_debug("bus: '%s': registered\n", bus->name);
 	return 0;
 
 bus_attrs_fail:
@@ -934,7 +934,7 @@ out:
  */
 void bus_unregister(struct bus_type * bus)
 {
-	pr_debug("bus %s: unregistering\n", bus->name);
+	pr_debug("bus: '%s': unregistering\n", bus->name);
 	bus_remove_attrs(bus);
 	remove_probe_files(bus);
 	kset_unregister(bus->p->drivers_kset);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 414a480..22fdf32 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -193,15 +193,16 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	if (dev->bus && dev->bus->uevent) {
 		retval = dev->bus->uevent(dev, env);
 		if (retval)
-			pr_debug ("%s: bus uevent() returned %d\n",
-				  __FUNCTION__, retval);
+			pr_debug("device: '%s': %s: bus uevent() returned %d\n",
+				 dev->bus_id, __FUNCTION__, retval);
 	}
 
 	/* have the class specific function add its stuff */
 	if (dev->class && dev->class->dev_uevent) {
 		retval = dev->class->dev_uevent(dev, env);
 		if (retval)
-			pr_debug("%s: class uevent() returned %d\n",
+			pr_debug("device: '%s': %s: class uevent() "
+				 "returned %d\n", dev->bus_id,
 				 __FUNCTION__, retval);
 	}
 
@@ -209,7 +210,8 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	if (dev->type && dev->type->uevent) {
 		retval = dev->type->uevent(dev, env);
 		if (retval)
-			pr_debug("%s: dev_type uevent() returned %d\n",
+			pr_debug("device: '%s': %s: dev_type uevent() "
+				 "returned %d\n", dev->bus_id,
 				 __FUNCTION__, retval);
 	}
 
@@ -751,7 +753,7 @@ int device_add(struct device *dev)
 		goto Error;
 	}
 
-	pr_debug("DEV: registering device: ID = '%s'\n", dev->bus_id);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
 
 	parent = get_device(dev->parent);
 	error = setup_parent(dev, parent);
@@ -1020,7 +1022,7 @@ void device_del(struct device * dev)
  */
 void device_unregister(struct device * dev)
 {
-	pr_debug("DEV: Unregistering device. ID = '%s'\n", dev->bus_id);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
 	device_del(dev);
 	put_device(dev);
 }
@@ -1116,7 +1118,7 @@ EXPORT_SYMBOL_GPL(device_remove_file);
 
 static void device_create_release(struct device *dev)
 {
-	pr_debug("%s called for %s\n", __FUNCTION__, dev->bus_id);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
 	kfree(dev);
 }
 
@@ -1259,7 +1261,8 @@ int device_rename(struct device *dev, char *new_name)
 	if (!dev)
 		return -EINVAL;
 
-	pr_debug("DEVICE: renaming '%s' to '%s'\n", dev->bus_id, new_name);
+	pr_debug("device: '%s': %s: renaming to '%s'\n", dev->bus_id,
+		 __FUNCTION__, new_name);
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if ((dev->class) && (dev->parent))
@@ -1378,8 +1381,8 @@ int device_move(struct device *dev, struct device *new_parent)
 		put_device(new_parent);
 		goto out;
 	}
-	pr_debug("DEVICE: moving '%s' to '%s'\n", dev->bus_id,
-		 new_parent ? new_parent->bus_id : "<NULL>");
+	pr_debug("device: '%s': %s: moving to '%s'\n", dev->bus_id,
+		 __FUNCTION__, new_parent ? new_parent->bus_id : "<NULL>");
 	error = kobject_move(&dev->kobj, new_parent_kobj);
 	if (error) {
 		put_device(new_parent);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 87a348c..5492264 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -34,8 +34,8 @@ static void driver_bound(struct device *dev)
 		return;
 	}
 
-	pr_debug("bound device '%s' to driver '%s'\n",
-		 dev->bus_id, dev->driver->name);
+	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev->bus_id,
+		 __FUNCTION__, dev->driver->name);
 
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -102,8 +102,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	int ret = 0;
 
 	atomic_inc(&probe_count);
-	pr_debug("%s: Probing driver %s with device %s\n",
-		 drv->bus->name, drv->name, dev->bus_id);
+	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
+		 drv->bus->name, __FUNCTION__, drv->name, dev->bus_id);
 	WARN_ON(!list_empty(&dev->devres_head));
 
 	dev->driver = drv;
@@ -125,8 +125,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	driver_bound(dev);
 	ret = 1;
-	pr_debug("%s: Bound Device %s to Driver %s\n",
-		 drv->bus->name, dev->bus_id, drv->name);
+	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
+		 drv->bus->name, __FUNCTION__, dev->bus_id, drv->name);
 	goto done;
 
 probe_failed:
@@ -192,8 +192,8 @@ int driver_probe_device(struct device_driver * drv, struct device * dev)
 	if (drv->bus->match && !drv->bus->match(dev, drv))
 		goto done;
 
-	pr_debug("%s: Matched Device %s with Driver %s\n",
-		 drv->bus->name, dev->bus_id, drv->name);
+	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
+		 drv->bus->name, __FUNCTION__, dev->bus_id, drv->name);
 
 	ret = really_probe(dev, drv);
 
-- 
1.5.3.8

