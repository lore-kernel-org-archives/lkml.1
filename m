Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbYFBNsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbYFBNsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761779AbYFBNra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:47:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49815 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761761AbYFBNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:47:28 -0400
Message-Id: <20080602134439.618813133@theryb.frec.bull.fr>
References: <20080602134438.224352910@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 15:45:58 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 08/10] driver core: Implement tagged directory support for
 device classes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver core: Implement tagged directory support for device classes.

This patch enables tagging on every class directory if struct class
has tag_ops.

In addition device_del and device_rename were modified to use
sysfs_delete_link and sysfs_rename_link respectively to ensure
when these operations happen on devices whose classes have
tag_ops that they work properly.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
---
 drivers/base/class.c   |   30 ++++++++++++++++++++++++++----
 drivers/base/core.c    |   41 ++++++++++++++++++++++-------------------
 include/linux/device.h |    2 ++
 3 files changed, 50 insertions(+), 23 deletions(-)

Index: linux-mm/drivers/base/class.c
===================================================================
--- linux-mm.orig/drivers/base/class.c
+++ linux-mm/drivers/base/class.c
@@ -134,6 +134,17 @@ static void remove_class_attrs(struct cl
 	}
 }
 
+static int class_setup_tagging(struct class *cls)
+{
+	const struct sysfs_tagged_dir_operations *tag_ops;
+
+	tag_ops = cls->tag_ops;
+	if (!tag_ops)
+		return 0;
+
+	return sysfs_enable_tagging(&cls->subsys.kobj, tag_ops);
+}
+
 int class_register(struct class *cls)
 {
 	int error;
@@ -162,11 +173,22 @@ int class_register(struct class *cls)
 	cls->subsys.kobj.ktype = &class_ktype;
 
 	error = kset_register(&cls->subsys);
-	if (!error) {
-		error = add_class_attrs(class_get(cls));
-		class_put(cls);
-	}
+	if (error)
+		goto out;
+
+	error = class_setup_tagging(cls);
+	if (error)
+		goto out_unregister;
+
+	error = add_class_attrs(cls);
+	if (error)
+		goto out_unregister;
+
+out:
 	return error;
+out_unregister:
+	kset_unregister(&cls->subsys);
+	goto out;
 }
 
 void class_unregister(struct class *cls)
Index: linux-mm/drivers/base/core.c
===================================================================
--- linux-mm.orig/drivers/base/core.c
+++ linux-mm/drivers/base/core.c
@@ -617,6 +617,10 @@ static struct kobject *get_device_parent
 			kobject_put(k);
 			return NULL;
 		}
+		/* If we created a new class-directory setup tagging */
+		if (dev->class->tag_ops)
+			sysfs_enable_tagging(k, dev->class->tag_ops);
+
 		/* do not emit an uevent for this simple "glue" directory */
 		return k;
 	}
@@ -751,12 +755,13 @@ static void device_remove_class_symlinks
 
 	if (dev->kobj.parent != &dev->class->subsys.kobj &&
 	    device_is_not_partition(dev))
-		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+		sysfs_delete_link(&dev->class->subsys.kobj, &dev->kobj,
+				  dev->bus_id);
 #else
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 
-	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	sysfs_delete_link(&dev->class->subsys.kobj, &dev->kobj, dev->bus_id);
 #endif
 
 	sysfs_remove_link(&dev->kobj, "subsystem");
@@ -1282,6 +1287,15 @@ int device_rename(struct device *dev, ch
 	strlcpy(old_device_name, dev->bus_id, BUS_ID_SIZE);
 	strlcpy(dev->bus_id, new_name, BUS_ID_SIZE);
 
+#ifndef CONFIG_SYSFS_DEPRECATED
+	if (dev->class && (dev->kobj.parent != &dev->class->subsys.kobj)) {
+		error = sysfs_rename_link(&dev->class->subsys.kobj,
+			&dev->kobj, old_device_name, new_name);
+		if (error)
+			goto out;
+	}
+#endif
+
 	error = kobject_rename(&dev->kobj, new_name);
 	if (error) {
 		strlcpy(dev->bus_id, old_device_name, BUS_ID_SIZE);
@@ -1290,24 +1304,13 @@ int device_rename(struct device *dev, ch
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if (old_class_name) {
+		error = -ENOMEM;
 		new_class_name = make_class_name(dev->class->name, &dev->kobj);
-		if (new_class_name) {
-			error = sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, new_class_name);
-			if (error)
-				goto out;
-			sysfs_remove_link(&dev->parent->kobj, old_class_name);
-		}
-	}
-#else
-	if (dev->class) {
-		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
-		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
-					  dev->bus_id);
-		if (error) {
-			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
-				__func__, error);
-		}
+		if (new_class_name)
+			error = sysfs_rename_link(&dev->parent->kobj,
+						  &dev->kobj,
+						  old_class_name,
+						  new_class_name);
 	}
 #endif
 
Index: linux-mm/include/linux/device.h
===================================================================
--- linux-mm.orig/include/linux/device.h
+++ linux-mm/include/linux/device.h
@@ -199,6 +199,8 @@ struct class {
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
 
+	const struct sysfs_tagged_dir_operations *tag_ops;
+
 	struct pm_ops *pm;
 };
 

-- 
