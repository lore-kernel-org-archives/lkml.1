Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbYAYHa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbYAYHa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbYAYHRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759090AbYAYHRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 047/196] kobject: get rid of kobject_kset_add_dir
Date: Thu, 24 Jan 2008 23:09:45 -0800
Message-Id: <1201245134-4876-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_kset_add_dir is only called in one place so remove it and use
kobject_create() instead.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c     |   16 ++++++++++++++--
 include/linux/kobject.h |    4 +---
 lib/kobject.c           |   37 +++++--------------------------------
 3 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 992eba3..7762ee8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -571,6 +571,8 @@ static struct kobject *virtual_device_parent(struct device *dev)
 static struct kobject * get_device_parent(struct device *dev,
 					  struct device *parent)
 {
+	int retval;
+
 	if (dev->class) {
 		struct kobject *kobj = NULL;
 		struct kobject *parent_kobj;
@@ -600,8 +602,18 @@ static struct kobject * get_device_parent(struct device *dev,
 			return kobj;
 
 		/* or create a new class-directory at the parent device */
-		return kobject_kset_add_dir(&dev->class->class_dirs,
-					    parent_kobj, dev->class->name);
+		k = kobject_create();
+		if (!k)
+			return NULL;
+		k->kset = &dev->class->class_dirs;
+		retval = kobject_add_ng(k, parent_kobj, "%s", dev->class->name);
+		if (retval < 0) {
+			kobject_put(k);
+			return NULL;
+		}
+		/* Do not emit a uevent, as it's not needed for this
+		 * "class glue" directory. */
+		return k;
 	}
 
 	if (parent)
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 7b09136..718b488 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -91,6 +91,7 @@ extern int __must_check kobject_init_and_add(struct kobject *kobj,
 
 extern void kobject_del(struct kobject *);
 
+extern struct kobject * __must_check kobject_create(void);
 extern struct kobject * __must_check kobject_create_and_add(const char *name,
 						struct kobject *parent);
 
@@ -103,9 +104,6 @@ extern void kobject_unregister(struct kobject *);
 extern struct kobject * kobject_get(struct kobject *);
 extern void kobject_put(struct kobject *);
 
-extern struct kobject *kobject_kset_add_dir(struct kset *kset,
-					    struct kobject *, const char *);
-
 extern char * kobject_get_path(struct kobject *, gfp_t);
 
 struct kobj_type {
diff --git a/lib/kobject.c b/lib/kobject.c
index 96b61d9..67c3d38 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -629,15 +629,18 @@ static struct kobj_type dynamic_kobj_ktype = {
 	.release = dynamic_kobj_release,
 };
 
-/*
+/**
  * kobject_create - create a struct kobject dynamically
  *
  * This function creates a kobject structure dynamically and sets it up
  * to be a "dynamic" kobject with a default release function set up.
  *
  * If the kobject was not able to be created, NULL will be returned.
+ * The kobject structure returned from here must be cleaned up with a
+ * call to kobject_put() and not kfree(), as kobject_init_ng() has
+ * already been called on this structure.
  */
-static struct kobject *kobject_create(void)
+struct kobject *kobject_create(void)
 {
 	struct kobject *kobj;
 
@@ -683,36 +686,6 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 EXPORT_SYMBOL_GPL(kobject_create_and_add);
 
 /**
- *	kobject_kset_add_dir - add sub directory of object.
- *	@kset:		kset the directory is belongs to.
- *	@parent:	object in which a directory is created.
- *	@name:	directory name.
- *
- *	Add a plain directory object as child of given object.
- */
-struct kobject *kobject_kset_add_dir(struct kset *kset,
-				     struct kobject *parent, const char *name)
-{
-	struct kobject *k;
-	int ret;
-
-	k = kobject_create();
-	if (!k)
-		return NULL;
-
-	k->kset = kset;
-	ret = kobject_add_ng(k, parent, "%s", name);
-	if (ret < 0) {
-		printk(KERN_WARNING "%s: kobject_add error: %d\n",
-			__func__, ret);
-		kobject_put(k);
-		k = NULL;
-	}
-
-	return k;
-}
-
-/**
  *	kset_init - initialize a kset for use
  *	@k:	kset 
  */
-- 
1.5.3.8

