Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbXBWXRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbXBWXRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXBWXRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:17:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:35237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259AbXBWXRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/9] Driver core: remove class_device_rename
Date: Fri, 23 Feb 2007 15:15:48 -0800
Message-Id: <11722725561867-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <20070223231426.GA20498@kroah.com>
References: <20070223231426.GA20498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No one uses it, and it wasn't exported to modules, so remove it.  The
only other user of it was the network code, which is now converted to
use struct device instead.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c   |   42 ------------------------------------------
 include/linux/device.h |    2 --
 2 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 1417e5c..d596812 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -840,48 +840,6 @@ void class_device_destroy(struct class *cls, dev_t devt)
 		class_device_unregister(class_dev);
 }
 
-int class_device_rename(struct class_device *class_dev, char *new_name)
-{
-	int error = 0;
-	char *old_class_name = NULL, *new_class_name = NULL;
-
-	class_dev = class_device_get(class_dev);
-	if (!class_dev)
-		return -EINVAL;
-
-	pr_debug("CLASS: renaming '%s' to '%s'\n", class_dev->class_id,
-		 new_name);
-
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if (class_dev->dev)
-		old_class_name = make_class_name(class_dev->class->name,
-						 &class_dev->kobj);
-#endif
-
-	strlcpy(class_dev->class_id, new_name, KOBJ_NAME_LEN);
-
-	error = kobject_rename(&class_dev->kobj, new_name);
-
-#ifdef CONFIG_SYSFS_DEPRECATED
-	if (class_dev->dev) {
-		new_class_name = make_class_name(class_dev->class->name,
-						 &class_dev->kobj);
-		if (new_class_name)
-			sysfs_create_link(&class_dev->dev->kobj,
-					  &class_dev->kobj, new_class_name);
-		if (old_class_name)
-			sysfs_remove_link(&class_dev->dev->kobj,
-						old_class_name);
-	}
-#endif
-	class_device_put(class_dev);
-
-	kfree(old_class_name);
-	kfree(new_class_name);
-
-	return error;
-}
-
 struct class_device * class_device_get(struct class_device *class_dev)
 {
 	if (class_dev)
diff --git a/include/linux/device.h b/include/linux/device.h
index d1a3a27..39a3199 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -294,8 +294,6 @@ extern void class_device_initialize(struct class_device *);
 extern int __must_check class_device_add(struct class_device *);
 extern void class_device_del(struct class_device *);
 
-extern int class_device_rename(struct class_device *, char *);
-
 extern struct class_device * class_device_get(struct class_device *);
 extern void class_device_put(struct class_device *);
 
-- 
1.5.0.1

