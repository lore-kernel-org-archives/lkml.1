Return-Path: <linux-kernel-owner+w=401wt.eu-S1422726AbXBURoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbXBURoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422730AbXBURox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:44:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36438 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422726AbXBURox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:44:53 -0500
Date: Wed, 21 Feb 2007 17:44:51 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cleanup up symlinks
Message-ID: <Pine.LNX.4.64.0702211740300.24543@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a device fails to register the class symlinks where not cleaned up. 
This left a symlink in the /sys/class/"device"/ directory that pointed to 
no where. This caused the sysfs_follow_link Oops I reported earlier. This 
patch cleanups up the symlink. Please apply. Thank you.

Signed-Off: James Simmons <jsimmons@infradead.org>

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d04fd33..cf2a398 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -637,12 +637,41 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_groups(dev);
  GroupError:
- 	device_remove_attrs(dev);
+	device_remove_attrs(dev);
  AttrsError:
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
 	}
+
+	if (dev->class) {
+		sysfs_remove_link(&dev->kobj, "subsystem");
+		/* If this is not a "fake" compatible device, remove the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
+					  dev->bus_id);
+#ifdef CONFIG_SYSFS_DEPRECATED
+		if (parent) {
+			char *class_name = make_class_name(dev->class->name,
+							   &dev->kobj);
+			if (class_name)
+				sysfs_remove_link(&dev->parent->kobj,
+						  class_name);
+			kfree(class_name);
+			sysfs_remove_link(&dev->kobj, "device");
+		}
+#endif
+
+		down(&dev->class->sem);
+		/* notify any interfaces that the device is now gone */
+		list_for_each_entry(class_intf, &dev->class->interfaces, node)
+			if (class_intf->remove_dev)
+				class_intf->remove_dev(dev, class_intf);
+		/* remove the device from the class list */
+		list_del_init(&dev->node);
+		up(&dev->class->sem);
+	}
  ueventattrError:
 	device_remove_file(dev, &dev->uevent_attr);
  attrError:
