Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbXJLWXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbXJLWXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbXJLWSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:53125 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761007AbXJLWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/75] Driver core: remove put_bus()
Date: Fri, 12 Oct 2007 15:16:14 -0700
Message-Id: <11922274853108-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227481691-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

put_bus() should not be globally visable as it is not used by anything
other than drivers/base/bus.c.  This patch removes the visability of it,
and renames it to match all of the other *_put() functions in the
kernel.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h |    1 -
 drivers/base/bus.c  |   29 ++++++++++++++---------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 47eb02d..cebc7e7 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -19,7 +19,6 @@ extern int bus_add_device(struct device * dev);
 extern void bus_attach_device(struct device * dev);
 extern void bus_remove_device(struct device * dev);
 extern struct bus_type *get_bus(struct bus_type * bus);
-extern void put_bus(struct bus_type * bus);
 
 extern int bus_add_driver(struct device_driver *);
 extern void bus_remove_driver(struct device_driver *);
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index bc38085..4f53b75 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -30,6 +30,11 @@
 static int __must_check bus_rescan_devices_helper(struct device *dev,
 						void *data);
 
+static void bus_put(struct bus_type *bus)
+{
+	kset_put(&bus->subsys);
+}
+
 static ssize_t
 drv_attr_show(struct kobject * kobj, struct attribute * attr, char * buf)
 {
@@ -124,7 +129,7 @@ int bus_create_file(struct bus_type * bus, struct bus_attribute * attr)
 	int error;
 	if (get_bus(bus)) {
 		error = sysfs_create_file(&bus->subsys.kobj, &attr->attr);
-		put_bus(bus);
+		bus_put(bus);
 	} else
 		error = -EINVAL;
 	return error;
@@ -134,7 +139,7 @@ void bus_remove_file(struct bus_type * bus, struct bus_attribute * attr)
 {
 	if (get_bus(bus)) {
 		sysfs_remove_file(&bus->subsys.kobj, &attr->attr);
-		put_bus(bus);
+		bus_put(bus);
 	}
 }
 
@@ -186,7 +191,7 @@ static ssize_t driver_unbind(struct device_driver *drv,
 		err = count;
 	}
 	put_device(dev);
-	put_bus(bus);
+	bus_put(bus);
 	return err;
 }
 static DRIVER_ATTR(unbind, S_IWUSR, NULL, driver_unbind);
@@ -219,7 +224,7 @@ static ssize_t driver_bind(struct device_driver *drv,
 			err = -ENODEV;
 	}
 	put_device(dev);
-	put_bus(bus);
+	bus_put(bus);
 	return err;
 }
 static DRIVER_ATTR(bind, S_IWUSR, NULL, driver_bind);
@@ -459,7 +464,7 @@ out_subsys:
 out_id:
 	device_remove_attrs(bus, dev);
 out_put:
-	put_bus(dev->bus);
+	bus_put(dev->bus);
 	return error;
 }
 
@@ -509,7 +514,7 @@ void bus_remove_device(struct device * dev)
 		}
 		pr_debug("bus %s: remove device %s\n", dev->bus->name, dev->bus_id);
 		device_release_driver(dev);
-		put_bus(dev->bus);
+		bus_put(dev->bus);
 	}
 }
 
@@ -646,7 +651,7 @@ int bus_add_driver(struct device_driver *drv)
 out_unregister:
 	kobject_unregister(&drv->kobj);
 out_put_bus:
-	put_bus(bus);
+	bus_put(bus);
 	return error;
 }
 
@@ -671,7 +676,7 @@ void bus_remove_driver(struct device_driver * drv)
 	driver_detach(drv);
 	module_remove_driver(drv);
 	kobject_unregister(&drv->kobj);
-	put_bus(drv->bus);
+	bus_put(drv->bus);
 }
 
 
@@ -732,12 +737,6 @@ struct bus_type *get_bus(struct bus_type *bus)
 				struct bus_type, subsys) : NULL;
 }
 
-void put_bus(struct bus_type * bus)
-{
-	kset_put(&bus->subsys);
-}
-
-
 /**
  *	find_bus - locate bus by name.
  *	@name:	name of bus.
@@ -874,7 +873,7 @@ out:
  *	@bus:	bus.
  *
  *	Unregister the child subsystems and the bus itself.
- *	Finally, we call put_bus() to release the refcount
+ *	Finally, we call bus_put() to release the refcount
  */
 void bus_unregister(struct bus_type * bus)
 {
-- 
1.5.3.4

