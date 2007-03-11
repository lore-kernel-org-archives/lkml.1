Return-Path: <linux-kernel-owner+w=401wt.eu-S934011AbXCKTLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbXCKTLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934016AbXCKTLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:11:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40477 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011AbXCKTLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:11:23 -0400
To: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] driver core: handle sysfs_op failure while device_add
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Sun, 11 Mar 2007 22:11:51 +0300
Message-ID: <874porvbm0.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

depends on: "[PATCH] driver core: fix device_add error path"

 - rearrange error path sequence, in order to make it more correct.
   In fact if initial sequance was doA(); doB(); doC();
   we should undo it with folowing sequance undoC(); undoB(); undoA();
 - handle sysfs_ops failure

This patch kills "ignoring return value of 'sysfs_create_link'"
warning message.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/base/core.c |   47 +++++++++++++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 245d703..bcfcfad 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -602,22 +602,34 @@ int device_add(struct device *dev)
 	}
 
 	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
-				  "subsystem");
+		error = sysfs_create_link(&dev->kobj,
+				&dev->class->subsys.kset.kobj, "subsystem");
+		if (error)
+			goto ueventattrError;
 		/* If this is not a "fake" compatible device, then create the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_create_link(&dev->class->subsys.kset.kobj,
-					  &dev->kobj, dev->bus_id);
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj) {
+			error = sysfs_create_link(
+					&dev->class->subsys.kset.kobj,
+					&dev->kobj, dev->bus_id);
+			if (error)
+				goto busLinkErr;
+		}
 		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
+			error = sysfs_create_link(&dev->kobj,
+					&dev->parent->kobj, "device");
+			if (error)
+				goto deviceLinkErr;
 #ifdef CONFIG_SYSFS_DEPRECATED
 			class_name = make_class_name(dev->class->name,
 							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
+			if (class_name) {
+				error = sysfs_create_link(
+						&dev->parent->kobj,
+						&dev->kobj, class_name);
+				if (error)
+					goto classLinkErr;
+			}
 #endif
 		}
 	}
@@ -673,12 +685,6 @@ int device_add(struct device *dev)
 	}
 
 	if (dev->class) {
-		sysfs_remove_link(&dev->kobj, "subsystem");
-		/* If this is not a "fake" compatible device, remove the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_remove_link(&dev->class->subsys.kset.kobj,
-					  dev->bus_id);
 		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
@@ -688,8 +694,17 @@ int device_add(struct device *dev)
 						  class_name);
 			kfree(class_name);
 #endif
+classLinkErr:
 			sysfs_remove_link(&dev->kobj, "device");
 		}
+deviceLinkErr:
+		/* If this is not a "fake" compatible device, remove the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
+					  dev->bus_id);
+busLinkErr:
+		sysfs_remove_link(&dev->kobj, "subsystem");
 	}
  ueventattrError:
 	device_remove_file(dev, &dev->uevent_attr);
-- 
1.5.0.1

