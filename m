Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbZIOTSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbZIOTSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758535AbZIOTSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:18:12 -0400
Received: from kroah.org ([198.145.64.141]:33033 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505AbZIOTOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 02/20] Driver core: move dev_get/set_drvdata to drivers/base/dd.c
Date: Tue, 15 Sep 2009 12:12:38 -0700
Message-Id: <1253041976-1111-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one should directly access the driver_data field, so remove the field
and make it private.  We dynamically create the private field now if it
is needed, to handle drivers that call get/set before they are
registered with the driver core.

Also update the copyright notices on these files while we are there.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |    5 +++++
 drivers/base/core.c    |   20 ++++++++++++++------
 drivers/base/dd.c      |   31 +++++++++++++++++++++++++++++--
 include/linux/device.h |   16 ++++------------
 4 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 1e52c12..503d59c 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -70,6 +70,8 @@ struct class_private {
  * @knode_parent - node in sibling list
  * @knode_driver - node in driver list
  * @knode_bus - node in bus list
+ * @driver_data - private pointer for driver specific info.  Will turn into a
+ * list soon.
  * @device - pointer back to the struct class that this structure is
  * associated with.
  *
@@ -80,6 +82,7 @@ struct device_private {
 	struct klist_node knode_parent;
 	struct klist_node knode_driver;
 	struct klist_node knode_bus;
+	void *driver_data;
 	struct device *device;
 };
 #define to_device_private_parent(obj)	\
@@ -89,6 +92,8 @@ struct device_private {
 #define to_device_private_bus(obj)	\
 	container_of(obj, struct device_private, knode_bus)
 
+extern int device_private_init(struct device *dev);
+
 /* initialisation functions */
 extern int devices_init(void);
 extern int buses_init(void);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index c34774d..99dfe96 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -843,6 +843,17 @@ static void device_remove_sys_dev_entry(struct device *dev)
 	}
 }
 
+int device_private_init(struct device *dev)
+{
+	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
+	if (!dev->p)
+		return -ENOMEM;
+	dev->p->device = dev;
+	klist_init(&dev->p->klist_children, klist_children_get,
+		   klist_children_put);
+	return 0;
+}
+
 /**
  * device_add - add device to device hierarchy.
  * @dev: device.
@@ -868,14 +879,11 @@ int device_add(struct device *dev)
 	if (!dev)
 		goto done;
 
-	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
 	if (!dev->p) {
-		error = -ENOMEM;
-		goto done;
+		error = device_private_init(dev);
+		if (error)
+			goto done;
 	}
-	dev->p->device = dev;
-	klist_init(&dev->p->klist_children, klist_children_get,
-		   klist_children_put);
 
 	/*
 	 * for statically allocated devices, which should all be converted
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 7b34b3a..979d159 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -11,8 +11,8 @@
  *
  * Copyright (c) 2002-5 Patrick Mochel
  * Copyright (c) 2002-3 Open Source Development Labs
- * Copyright (c) 2007 Greg Kroah-Hartman <gregkh@suse.de>
- * Copyright (c) 2007 Novell Inc.
+ * Copyright (c) 2007-2009 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (c) 2007-2009 Novell Inc.
  *
  * This file is released under the GPLv2
  */
@@ -391,3 +391,30 @@ void driver_detach(struct device_driver *drv)
 		put_device(dev);
 	}
 }
+
+/*
+ * These exports can't be _GPL due to .h files using this within them, and it
+ * might break something that was previously working...
+ */
+void *dev_get_drvdata(const struct device *dev)
+{
+	if (dev && dev->p)
+		return dev->p->driver_data;
+	return NULL;
+}
+EXPORT_SYMBOL(dev_get_drvdata);
+
+void dev_set_drvdata(struct device *dev, void *data)
+{
+	int error;
+
+	if (!dev)
+		return;
+	if (!dev->p) {
+		error = device_private_init(dev);
+		if (error)
+			return;
+	}
+	dev->p->driver_data = data;
+}
+EXPORT_SYMBOL(dev_set_drvdata);
diff --git a/include/linux/device.h b/include/linux/device.h
index a286429..c0bd230 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -2,7 +2,8 @@
  * device.h - generic, centralized driver model
  *
  * Copyright (c) 2001-2003 Patrick Mochel <mochel@osdl.org>
- * Copyright (c) 2004-2007 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (c) 2004-2009 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (c) 2008-2009 Novell Inc.
  *
  * This file is released under the GPLv2
  *
@@ -381,7 +382,6 @@ struct device {
 	struct bus_type	*bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
-	void		*driver_data;	/* data private to the driver */
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
 	struct dev_pm_info	power;
@@ -447,16 +447,6 @@ static inline void set_dev_node(struct device *dev, int node)
 }
 #endif
 
-static inline void *dev_get_drvdata(const struct device *dev)
-{
-	return dev->driver_data;
-}
-
-static inline void dev_set_drvdata(struct device *dev, void *data)
-{
-	dev->driver_data = data;
-}
-
 static inline unsigned int dev_get_uevent_suppress(const struct device *dev)
 {
 	return dev->kobj.uevent_suppress;
@@ -490,6 +480,8 @@ extern int device_rename(struct device *dev, char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent,
 		       enum dpm_order dpm_order);
 extern const char *device_get_nodename(struct device *dev, const char **tmp);
+extern void *dev_get_drvdata(const struct device *dev);
+extern void dev_set_drvdata(struct device *dev, void *data);
 
 /*
  * Root device objects for grouping under /sys/devices
-- 
1.6.4.2

