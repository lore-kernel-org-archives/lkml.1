Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbZCYAqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbZCYAqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZCYAaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:30 -0400
Received: from kroah.org ([198.145.64.141]:54170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756791AbZCYAaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 44/61] driver core: create a private portion of struct device
Date: Tue, 24 Mar 2009 17:26:48 -0700
Message-Id: <1237940825-22904-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to be used to move things out of struct device that no code
outside of the driver core should ever touch.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |   12 ++++++++++++
 drivers/base/core.c    |    9 +++++++++
 include/linux/device.h |    3 +++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index ca2b037..62a2cb5 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -63,6 +63,18 @@ struct class_private {
 #define to_class(obj)	\
 	container_of(obj, struct class_private, class_subsys.kobj)
 
+/**
+ * struct device_private - structure to hold the private to the driver core portions of the device structure.
+ *
+ * @device - pointer back to the struct class that this structure is
+ * associated with.
+ *
+ * Nothing outside of the driver core should ever touch these fields.
+ */
+struct device_private {
+	struct device *device;
+};
+
 /* initialisation functions */
 extern int devices_init(void);
 extern int buses_init(void);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 059966b..16d8599 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -109,6 +109,7 @@ static struct sysfs_ops dev_sysfs_ops = {
 static void device_release(struct kobject *kobj)
 {
 	struct device *dev = to_dev(kobj);
+	struct device_private *p = dev->p;
 
 	if (dev->release)
 		dev->release(dev);
@@ -120,6 +121,7 @@ static void device_release(struct kobject *kobj)
 		WARN(1, KERN_ERR "Device '%s' does not have a release() "
 			"function, it is broken and must be fixed.\n",
 			dev_name(dev));
+	kfree(p);
 }
 
 static struct kobj_type device_ktype = {
@@ -859,6 +861,13 @@ int device_add(struct device *dev)
 	if (!dev)
 		goto done;
 
+	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
+	if (!dev->p) {
+		error = -ENOMEM;
+		goto done;
+	}
+	dev->p->device = dev;
+
 	/*
 	 * for statically allocated devices, which should all be converted
 	 * some day, we need to initialize the name. We prevent reading back
diff --git a/include/linux/device.h b/include/linux/device.h
index c56b154..4cf063f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -28,6 +28,7 @@
 #define BUS_ID_SIZE		20
 
 struct device;
+struct device_private;
 struct device_driver;
 struct driver_private;
 struct class;
@@ -373,6 +374,8 @@ struct device {
 	struct klist_node	knode_bus;
 	struct device		*parent;
 
+	struct device_private	*p;
+
 	struct kobject kobj;
 	unsigned		uevent_suppress:1;
 	const char		*init_name; /* initial name of the device */
-- 
1.6.2

