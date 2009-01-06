Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZAFWR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZAFWR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZAFWNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:32 -0500
Received: from kroah.org ([198.145.64.141]:51203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755324AbZAFWNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:30 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 13/60] driver core: create a private portion of struct device
Date: Tue,  6 Jan 2009 14:11:32 -0800
Message-Id: <1231279939-32728-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to be used to move things out of struct device that no code
outside of the driver core should ever touch.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |   12 ++++++++++++
 drivers/base/core.c    |    8 ++++++++
 include/linux/device.h |    3 +++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 0a5f055..6b20809 100644
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
index 14aa2b6..6657787 100644
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
@@ -536,6 +538,12 @@ static void klist_children_put(struct klist_node *n)
  */
 void device_initialize(struct device *dev)
 {
+	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
+	if (!dev->p) {
+		WARN_ON(1);
+		return;
+	}
+	dev->p->device = dev;
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
 	klist_init(&dev->klist_children, klist_children_get,
diff --git a/include/linux/device.h b/include/linux/device.h
index 4e14fad..d6d3408 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -28,6 +28,7 @@
 #define BUS_ID_SIZE		20
 
 struct device;
+struct device_private;
 struct device_driver;
 struct driver_private;
 struct class;
@@ -371,6 +372,8 @@ struct device {
 	struct klist_node	knode_bus;
 	struct device		*parent;
 
+	struct device_private	*p;
+
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	unsigned		uevent_suppress:1;
-- 
1.6.0.4

