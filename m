Return-Path: <linux-kernel-owner+w=401wt.eu-S965705AbXBHAh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbXBHAh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422928AbXBHAc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:56383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422874AbXBHAcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:13 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/28] driver core fixes: make_class_name() retval checks
Date: Wed,  7 Feb 2007 16:30:01 -0800
Message-Id: <1170894664547-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946601643-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Make make_class_name() return NULL on error and fixup callers in the
driver core.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |   21 ++++++++++++++-------
 drivers/base/core.c  |   17 +++++++++++------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8bf2ca2..96def1d 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -364,7 +364,7 @@ char *make_class_name(const char *name, struct kobject *kobj)
 
 	class_name = kmalloc(size, GFP_KERNEL);
 	if (!class_name)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	strcpy(class_name, name);
 	strcat(class_name, ":");
@@ -411,8 +411,11 @@ static int make_deprecated_class_device_links(struct class_device *class_dev)
 		return 0;
 
 	class_name = make_class_name(class_dev->class->name, &class_dev->kobj);
-	error = sysfs_create_link(&class_dev->dev->kobj, &class_dev->kobj,
-				  class_name);
+	if (class_name)
+		error = sysfs_create_link(&class_dev->dev->kobj,
+					  &class_dev->kobj, class_name);
+	else
+		error = -ENOMEM;
 	kfree(class_name);
 	return error;
 }
@@ -425,7 +428,8 @@ static void remove_deprecated_class_device_links(struct class_device *class_dev)
 		return;
 
 	class_name = make_class_name(class_dev->class->name, &class_dev->kobj);
-	sysfs_remove_link(&class_dev->dev->kobj, class_name);
+	if (class_name)
+		sysfs_remove_link(&class_dev->dev->kobj, class_name);
 	kfree(class_name);
 }
 #else
@@ -863,9 +867,12 @@ int class_device_rename(struct class_device *class_dev, char *new_name)
 	if (class_dev->dev) {
 		new_class_name = make_class_name(class_dev->class->name,
 						 &class_dev->kobj);
-		sysfs_create_link(&class_dev->dev->kobj, &class_dev->kobj,
-				  new_class_name);
-		sysfs_remove_link(&class_dev->dev->kobj, old_class_name);
+		if (new_class_name)
+			sysfs_create_link(&class_dev->dev->kobj,
+					  &class_dev->kobj, new_class_name);
+		if (old_class_name)
+			sysfs_remove_link(&class_dev->dev->kobj,
+						old_class_name);
 	}
 #endif
 	class_device_put(class_dev);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index c60114d..6fee3e6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -527,9 +527,13 @@ int device_add(struct device *dev)
 					  &dev->kobj, dev->bus_id);
 #ifdef CONFIG_SYSFS_DEPRECATED
 		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj, "device");
-			class_name = make_class_name(dev->class->name, &dev->kobj);
-			sysfs_create_link(&dev->parent->kobj, &dev->kobj, class_name);
+			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+							"device");
+			class_name = make_class_name(dev->class->name,
+							&dev->kobj);
+			if (class_name)
+				sysfs_create_link(&dev->parent->kobj,
+						  &dev->kobj, class_name);
 		}
 #endif
 	}
@@ -672,7 +676,9 @@ void device_del(struct device * dev)
 		if (parent) {
 			char *class_name = make_class_name(dev->class->name,
 							   &dev->kobj);
-			sysfs_remove_link(&dev->parent->kobj, class_name);
+			if (class_name)
+				sysfs_remove_link(&dev->parent->kobj,
+						  class_name);
 			kfree(class_name);
 			sysfs_remove_link(&dev->kobj, "device");
 		}
@@ -975,8 +981,7 @@ static int device_move_class_links(struct device *dev,
 
 	class_name = make_class_name(dev->class->name, &dev->kobj);
 	if (!class_name) {
-		error = PTR_ERR(class_name);
-		class_name = NULL;
+		error = -ENOMEM;
 		goto out;
 	}
 	if (old_parent) {
-- 
1.4.4.4

