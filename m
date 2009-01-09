Return-Path: <linux-kernel-owner+w=401wt.eu-S932834AbZAIXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbZAIXXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760393AbZAIXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:22:05 -0500
Received: from kroah.org ([198.145.64.141]:54595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760372AbZAIXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:22:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 4/4] Revert "driver core: create a private portion of struct device"
Date: Fri,  9 Jan 2009 15:20:57 -0800
Message-Id: <1231543257-10047-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090109232021.GA10007@kroah.com>
References: <20090109232021.GA10007@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3.

Turns out that device_initialize shouldn't fail silently.
This series needs to be reworked in order to get into proper
shape.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h    |   12 ------------
 drivers/base/core.c    |    8 --------
 include/linux/device.h |    3 ---
 3 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 6b20809..0a5f055 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -63,18 +63,6 @@ struct class_private {
 #define to_class(obj)	\
 	container_of(obj, struct class_private, class_subsys.kobj)
 
-/**
- * struct device_private - structure to hold the private to the driver core portions of the device structure.
- *
- * @device - pointer back to the struct class that this structure is
- * associated with.
- *
- * Nothing outside of the driver core should ever touch these fields.
- */
-struct device_private {
-	struct device *device;
-};
-
 /* initialisation functions */
 extern int devices_init(void);
 extern int buses_init(void);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5c2acf7..8079afc 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -109,7 +109,6 @@ static struct sysfs_ops dev_sysfs_ops = {
 static void device_release(struct kobject *kobj)
 {
 	struct device *dev = to_dev(kobj);
-	struct device_private *p = dev->p;
 
 	if (dev->release)
 		dev->release(dev);
@@ -121,7 +120,6 @@ static void device_release(struct kobject *kobj)
 		WARN(1, KERN_ERR "Device '%s' does not have a release() "
 			"function, it is broken and must be fixed.\n",
 			dev_name(dev));
-	kfree(p);
 }
 
 static struct kobj_type device_ktype = {
@@ -538,12 +536,6 @@ static void klist_children_put(struct klist_node *n)
  */
 void device_initialize(struct device *dev)
 {
-	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
-	if (!dev->p) {
-		WARN_ON(1);
-		return;
-	}
-	dev->p->device = dev;
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
 	klist_init(&dev->klist_children, klist_children_get,
diff --git a/include/linux/device.h b/include/linux/device.h
index 2975351..45e5b19 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -28,7 +28,6 @@
 #define BUS_ID_SIZE		20
 
 struct device;
-struct device_private;
 struct device_driver;
 struct driver_private;
 struct class;
@@ -372,8 +371,6 @@ struct device {
 	struct klist_node	knode_bus;
 	struct device		*parent;
 
-	struct device_private	*p;
-
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	unsigned		uevent_suppress:1;
-- 
1.6.0.4

