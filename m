Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbXBWXSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbXBWXSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbXBWXSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:18:22 -0500
Received: from ns2.suse.de ([195.135.220.15]:35280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbXBWXR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: James Simmons <jsimmons@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 8/9] Driver core: fix error by cleanup up symlinks properly
Date: Fri, 23 Feb 2007 15:15:55 -0800
Message-Id: <1172272579116-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <11722725761560-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de> <11722725592291-git-send-email-gregkh@suse.de> <11722725623183-git-send-email-gregkh@suse.de> <1172272565581-git-send-email-gregkh@suse.de> <1172272569255-git-send-email-gregkh@suse.de> <11722725722238-git-send-email-gregkh@suse.de> <11722725761560-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <jsimmons@infradead.org>

When a device fails to register the class symlinks where not cleaned up.
This left a symlink in the /sys/class/"device"/ directory that pointed
to no where. This caused the sysfs_follow_link Oops I reported earlier.
This patch cleanups up the symlink. Please apply. Thank you.

Signed-Off: James Simmons <jsimmons@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

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
-- 
1.5.0.1

