Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYJ3Ag5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYJ3Ag5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYJ3Ags
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:36:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1410 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbYJ3Agr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:36:47 -0400
Subject: driver core: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 01:36:48 +0100
Message-Id: <1225327008.5970.27.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: driver core: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Greg KH <greg@kroah.com>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index f57652d..b9cda05 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -167,7 +167,7 @@ attribute_container_add_device(struct device *dev,
 		ic->classdev.parent = get_device(dev);
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
-		strcpy(ic->classdev.bus_id, dev->bus_id);
+		dev_set_name(&ic->classdev, dev_name(dev));
 		if (fn)
 			fn(cont, dev, &ic->classdev);
 		else
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 5aee1c0..83f32b8 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -333,7 +333,7 @@ static int match_name(struct device *dev, void *data)
 {
 	const char *name = data;
 
-	return sysfs_streq(name, dev->bus_id);
+	return sysfs_streq(name, dev_name(dev));
 }
 
 /**
@@ -461,12 +461,12 @@ int bus_add_device(struct device *dev)
 	int error = 0;
 
 	if (bus) {
-		pr_debug("bus: '%s': add device %s\n", bus->name, dev->bus_id);
+		pr_debug("bus: '%s': add device %s\n", bus->name, dev_name(dev));
 		error = device_add_attrs(bus, dev);
 		if (error)
 			goto out_put;
 		error = sysfs_create_link(&bus->p->devices_kset->kobj,
-						&dev->kobj, dev->bus_id);
+						&dev->kobj, dev_name(dev));
 		if (error)
 			goto out_id;
 		error = sysfs_create_link(&dev->kobj,
@@ -482,7 +482,7 @@ int bus_add_device(struct device *dev)
 out_deprecated:
 	sysfs_remove_link(&dev->kobj, "subsystem");
 out_subsys:
-	sysfs_remove_link(&bus->p->devices_kset->kobj, dev->bus_id);
+	sysfs_remove_link(&bus->p->devices_kset->kobj, dev_name(dev));
 out_id:
 	device_remove_attrs(bus, dev);
 out_put:
@@ -526,13 +526,13 @@ void bus_remove_device(struct device *dev)
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		remove_deprecated_bus_links(dev);
 		sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
-				  dev->bus_id);
+				  dev_name(dev));
 		device_remove_attrs(dev->bus, dev);
 		if (klist_node_attached(&dev->knode_bus))
 			klist_del(&dev->knode_bus);
 
 		pr_debug("bus: '%s': remove device %s\n",
-			 dev->bus->name, dev->bus_id);
+			 dev->bus->name, dev_name(dev));
 		device_release_driver(dev);
 		bus_put(dev->bus);
 	}
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8c2cc26..14aa2b6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -119,7 +119,7 @@ static void device_release(struct kobject *kobj)
 	else
 		WARN(1, KERN_ERR "Device '%s' does not have a release() "
 			"function, it is broken and must be fixed.\n",
-			dev->bus_id);
+			dev_name(dev));
 }
 
 static struct kobj_type device_ktype = {
@@ -209,7 +209,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		retval = dev->bus->uevent(dev, env);
 		if (retval)
 			pr_debug("device: '%s': %s: bus uevent() returned %d\n",
-				 dev->bus_id, __func__, retval);
+				 dev_name(dev), __func__, retval);
 	}
 
 	/* have the class specific function add its stuff */
@@ -217,7 +217,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		retval = dev->class->dev_uevent(dev, env);
 		if (retval)
 			pr_debug("device: '%s': %s: class uevent() "
-				 "returned %d\n", dev->bus_id,
+				 "returned %d\n", dev_name(dev),
 				 __func__, retval);
 	}
 
@@ -226,7 +226,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		retval = dev->type->uevent(dev, env);
 		if (retval)
 			pr_debug("device: '%s': %s: dev_type uevent() "
-				 "returned %d\n", dev->bus_id,
+				 "returned %d\n", dev_name(dev),
 				 __func__, retval);
 	}
 
@@ -672,7 +672,7 @@ static int device_add_class_symlinks(struct device *dev)
 	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev)) {
 		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
-					  &dev->kobj, dev->bus_id);
+					  &dev->kobj, dev_name(dev));
 		if (error)
 			goto out_subsys;
 	}
@@ -712,11 +712,11 @@ out_busid:
 	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev))
 		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
-				  dev->bus_id);
+				  dev_name(dev));
 #else
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
-				  &dev->kobj, dev->bus_id);
+				  &dev->kobj, dev_name(dev));
 	if (error)
 		goto out_subsys;
 
@@ -729,7 +729,7 @@ out_busid:
 	return 0;
 
 out_busid:
-	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev->bus_id);
+	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev_name(dev));
 #endif
 
 out_subsys:
@@ -758,12 +758,12 @@ static void device_remove_class_symlinks(struct device *dev)
 	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev))
 		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
-				  dev->bus_id);
+				  dev_name(dev));
 #else
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 
-	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev->bus_id);
+	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev_name(dev));
 #endif
 
 	sysfs_remove_link(&dev->kobj, "subsystem");
@@ -866,7 +866,7 @@ int device_add(struct device *dev)
 	if (!strlen(dev->bus_id))
 		goto done;
 
-	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
+	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 
 	parent = get_device(dev->parent);
 	setup_parent(dev, parent);
@@ -876,7 +876,7 @@ int device_add(struct device *dev)
 		set_dev_node(dev, dev_to_node(parent));
 
 	/* first, register with generic layer. */
-	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
+	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev_name(dev));
 	if (error)
 		goto Error;
 
@@ -1086,7 +1086,7 @@ void device_del(struct device *dev)
  */
 void device_unregister(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
+	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 	device_del(dev);
 	put_device(dev);
 }
@@ -1199,7 +1199,7 @@ EXPORT_SYMBOL_GPL(device_remove_file);
 
 static void device_create_release(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
+	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 	kfree(dev);
 }
 
@@ -1344,7 +1344,7 @@ int device_rename(struct device *dev, char *new_name)
 	if (!dev)
 		return -EINVAL;
 
-	pr_debug("device: '%s': %s: renaming to '%s'\n", dev->bus_id,
+	pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
 		 __func__, new_name);
 
 #ifdef CONFIG_SYSFS_DEPRECATED
@@ -1381,7 +1381,7 @@ int device_rename(struct device *dev, char *new_name)
 #else
 	if (dev->class) {
 		error = sysfs_create_link_nowarn(&dev->class->p->class_subsys.kobj,
-						 &dev->kobj, dev->bus_id);
+						 &dev->kobj, dev_name(dev));
 		if (error)
 			goto out;
 		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
@@ -1459,8 +1459,8 @@ int device_move(struct device *dev, struct device *new_parent)
 	new_parent = get_device(new_parent);
 	new_parent_kobj = get_device_parent(dev, new_parent);
 
-	pr_debug("device: '%s': %s: moving to '%s'\n", dev->bus_id,
-		 __func__, new_parent ? new_parent->bus_id : "<NULL>");
+	pr_debug("device: '%s': %s: moving to '%s'\n", dev_name(dev),
+		 __func__, new_parent ? dev_name(new_parent) : "<NULL>");
 	error = kobject_move(&dev->kobj, new_parent_kobj);
 	if (error) {
 		cleanup_glue_dir(dev, new_parent_kobj);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 20febc0..17a8e45 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -34,7 +34,7 @@ static void driver_bound(struct device *dev)
 		return;
 	}
 
-	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev->bus_id,
+	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev_name(dev),
 		 __func__, dev->driver->name);
 
 	if (dev->bus)
@@ -104,13 +104,13 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
-		 drv->bus->name, __func__, drv->name, dev->bus_id);
+		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	WARN_ON(!list_empty(&dev->devres_head));
 
 	dev->driver = drv;
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
-			__func__, dev->bus_id);
+			__func__, dev_name(dev));
 		goto probe_failed;
 	}
 
@@ -127,7 +127,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	driver_bound(dev);
 	ret = 1;
 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
-		 drv->bus->name, __func__, dev->bus_id, drv->name);
+		 drv->bus->name, __func__, dev_name(dev), drv->name);
 	goto done;
 
 probe_failed:
@@ -139,7 +139,7 @@ probe_failed:
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
-		       drv->name, dev->bus_id, ret);
+		       drv->name, dev_name(dev), ret);
 	}
 	/*
 	 * Ignore errors returned by ->probe so that the next driver can try
@@ -194,7 +194,7 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 		goto done;
 
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
-		 drv->bus->name, __func__, dev->bus_id, drv->name);
+		 drv->bus->name, __func__, dev_name(dev), drv->name);
 
 	ret = really_probe(dev, drv);
 
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b7e5710..44699d9 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -291,12 +291,6 @@ firmware_class_timeout(u_long data)
 	fw_load_abort(fw_priv);
 }
 
-static inline void fw_setup_device_id(struct device *f_dev, struct device *dev)
-{
-	/* XXX warning we should watch out for name collisions */
-	strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
-}
-
 static int fw_register_device(struct device **dev_p, const char *fw_name,
 			      struct device *device)
 {
@@ -321,7 +315,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);
 
-	fw_setup_device_id(f_dev, device);
+	dev_set_name(f_dev, dev_name(device));
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
diff --git a/drivers/base/isa.c b/drivers/base/isa.c
index efd5775..5751d9d 100644
--- a/drivers/base/isa.c
+++ b/drivers/base/isa.c
@@ -11,7 +11,7 @@
 #include <linux/isa.h>
 
 static struct device isa_bus = {
-	.bus_id		= "isa"
+	.init_name	= "isa"
 };
 
 struct isa_dev {
@@ -135,9 +135,8 @@ int isa_register_driver(struct isa_driver *isa_driver, unsigned int ndev)
 		isa_dev->dev.parent	= &isa_bus;
 		isa_dev->dev.bus	= &isa_bus_type;
 
-		snprintf(isa_dev->dev.bus_id, BUS_ID_SIZE, "%s.%u",
-				isa_driver->driver.name, id);
-
+		dev_set_name(&isa_dev->dev, "%s.%u",
+			     isa_driver->driver.name, id)
 		isa_dev->dev.platform_data	= isa_driver;
 		isa_dev->dev.release		= isa_dev_release;
 		isa_dev->id			= id;
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dfcbfe5..39bfeae 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -24,7 +24,7 @@
 				 driver))
 
 struct device platform_bus = {
-	.bus_id		= "platform",
+	.init_name	= "platform",
 };
 EXPORT_SYMBOL_GPL(platform_bus);
 
@@ -242,16 +242,15 @@ int platform_device_add(struct platform_device *pdev)
 	pdev->dev.bus = &platform_bus_type;
 
 	if (pdev->id != -1)
-		snprintf(pdev->dev.bus_id, BUS_ID_SIZE, "%s.%d", pdev->name,
-			 pdev->id);
+		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
 	else
-		strlcpy(pdev->dev.bus_id, pdev->name, BUS_ID_SIZE);
+		dev_set_name(&pdev->dev, pdev->name);
 
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
 
 		if (r->name == NULL)
-			r->name = pdev->dev.bus_id;
+			r->name = dev_name(&pdev->dev);
 
 		p = r->parent;
 		if (!p) {
@@ -264,14 +263,14 @@ int platform_device_add(struct platform_device *pdev)
 		if (p && insert_resource(p, r)) {
 			printk(KERN_ERR
 			       "%s: failed to claim resource %d\n",
-			       pdev->dev.bus_id, i);
+			       dev_name(&pdev->dev), i);
 			ret = -EBUSY;
 			goto failed;
 		}
 	}
 
 	pr_debug("Registering platform device '%s'. Parent at %s\n",
-		 pdev->dev.bus_id, pdev->dev.parent->bus_id);
+		 dev_name(&pdev->dev), dev_name(pdev->dev.parent));
 
 	ret = device_add(&pdev->dev);
 	if (ret == 0)
@@ -609,7 +608,7 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 	struct platform_device *pdev;
 
 	pdev = container_of(dev, struct platform_device, dev);
-	return (strncmp(pdev->name, drv->name, BUS_ID_SIZE) == 0);
+	return (strcmp(pdev->name, drv->name) == 0);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 692c20b..6a6ed82 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -76,7 +76,7 @@ void device_pm_add(struct device *dev)
 	if (dev->parent) {
 		if (dev->parent->power.status >= DPM_SUSPENDING)
 			dev_warn(dev, "parent %s should not be sleeping\n",
-				dev->parent->bus_id);
+				 dev_name(dev->parent));
 	} else if (transition_started) {
 		/*
 		 * We refuse to register parentless devices while a PM
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 2aa6e8f..0a1a2c4 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -140,7 +140,7 @@ static unsigned int hash_string(unsigned int seed, const char *data, unsigned in
 
 void set_trace_device(struct device *dev)
 {
-	dev_hash_value = hash_string(DEVSEED, dev->bus_id, DEVHASH);
+	dev_hash_value = hash_string(DEVSEED, dev_name(dev), DEVHASH);
 }
 EXPORT_SYMBOL(set_trace_device);
 
@@ -192,7 +192,7 @@ static int show_dev_hash(unsigned int value)
 
 	while (entry != &dpm_list) {
 		struct device * dev = to_device(entry);
-		unsigned int hash = hash_string(DEVSEED, dev->bus_id, DEVHASH);
+		unsigned int hash = hash_string(DEVSEED, dev_name(dev), DEVHASH);
 		if (hash == value) {
 			dev_info(dev, "hash matches\n");
 			match++;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 5437ac0..c9c214d 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -72,6 +72,8 @@ struct kobject {
 
 extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
 			    __attribute__((format(printf, 2, 3)));
+extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
+				  va_list vargs);
 
 static inline const char *kobject_name(const struct kobject *kobj)
 {
diff --git a/lib/kobject.c b/lib/kobject.c
index 0487d1f..a6dec32 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -212,7 +212,7 @@ static int kobject_add_internal(struct kobject *kobj)
  * @fmt: format string used to build the name
  * @vargs: vargs to format the string.
  */
-static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
+int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
 	const char *old_name = kobj->name;


