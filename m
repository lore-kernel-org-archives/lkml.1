Return-Path: <linux-kernel-owner+w=401wt.eu-S1767772AbXCJEJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767772AbXCJEJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767779AbXCJEJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:09:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:36903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767772AbXCJEJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:09:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] Driver core: add device symlink back to sysfs
Date: Fri,  9 Mar 2007 20:07:29 -0800
Message-Id: <11734996551193-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11734996523796-git-send-email-gregkh@suse.de>
References: <20070310040405.GC30638@kroah.com> <11734996523796-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the device symlink back to sysfs even if
CONFIG_SYSFS_DEPRECATED is enabled as too many userspace programs (well,
HAL), still rely on this link to be present.

I will rework the ability for sysfs to change layouts like this in the
future, but for now, this patch should fix people's network connections.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 89ebe36..fb16f29 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -584,17 +584,17 @@ int device_add(struct device *dev)
 		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
 			sysfs_create_link(&dev->class->subsys.kset.kobj,
 					  &dev->kobj, dev->bus_id);
-#ifdef CONFIG_SYSFS_DEPRECATED
 		if (parent) {
 			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 							"device");
+#ifdef CONFIG_SYSFS_DEPRECATED
 			class_name = make_class_name(dev->class->name,
 							&dev->kobj);
 			if (class_name)
 				sysfs_create_link(&dev->parent->kobj,
 						  &dev->kobj, class_name);
-		}
 #endif
+		}
 	}
 
 	if ((error = device_add_attrs(dev)))
@@ -651,17 +651,17 @@ int device_add(struct device *dev)
 		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
 			sysfs_remove_link(&dev->class->subsys.kset.kobj,
 					  dev->bus_id);
-#ifdef CONFIG_SYSFS_DEPRECATED
 		if (parent) {
+#ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
 							   &dev->kobj);
 			if (class_name)
 				sysfs_remove_link(&dev->parent->kobj,
 						  class_name);
 			kfree(class_name);
+#endif
 			sysfs_remove_link(&dev->kobj, "device");
 		}
-#endif
 
 		down(&dev->class->sem);
 		/* notify any interfaces that the device is now gone */
@@ -761,17 +761,17 @@ void device_del(struct device * dev)
 		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
 			sysfs_remove_link(&dev->class->subsys.kset.kobj,
 					  dev->bus_id);
-#ifdef CONFIG_SYSFS_DEPRECATED
 		if (parent) {
+#ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
 							   &dev->kobj);
 			if (class_name)
 				sysfs_remove_link(&dev->parent->kobj,
 						  class_name);
 			kfree(class_name);
+#endif
 			sysfs_remove_link(&dev->kobj, "device");
 		}
-#endif
 
 		down(&dev->class->sem);
 		/* notify any interfaces that the device is now gone */
@@ -1071,8 +1071,8 @@ static int device_move_class_links(struct device *dev,
 				   struct device *old_parent,
 				   struct device *new_parent)
 {
+	int error = 0;
 #ifdef CONFIG_SYSFS_DEPRECATED
-	int error;
 	char *class_name;
 
 	class_name = make_class_name(dev->class->name, &dev->kobj);
@@ -1100,7 +1100,12 @@ out:
 	kfree(class_name);
 	return error;
 #else
-	return 0;
+	if (old_parent)
+		sysfs_remove_link(&dev->kobj, "device");
+	if (new_parent)
+		error = sysfs_create_link(&dev->kobj, &new_parent->kobj,
+					  "device");
+	return error;
 #endif
 }
 
-- 
1.5.0.2

