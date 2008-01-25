Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbYAYHun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbYAYHun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761913AbYAYHfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:55187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760628AbYAYHfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 088/196] Driver Core: kill subsys_attribute and default sysfs ops
Date: Thu, 24 Jan 2008 23:31:57 -0800
Message-Id: <1201246425-5058-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Remove the no longer needed subsys_attributes, they are all converted to
the more sensical kobj_attributes.

There is no longer a magic fallback in sysfs attribute operations, all
kobjects which create simple attributes need explicitely a ktype
assigned, which tells the core what was intended here.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c         |   63 +++++++---------------------------------------
 include/linux/kobject.h |    9 ------
 lib/kobject.c           |   21 ---------------
 3 files changed, 10 insertions(+), 83 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 387a636..8acf82b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -20,43 +20,6 @@
 
 #include "sysfs.h"
 
-#define to_sattr(a) container_of(a,struct subsys_attribute, attr)
-
-/*
- * Subsystem file operations.
- * These operations allow subsystems to have files that can be 
- * read/written. 
- */
-static ssize_t 
-subsys_attr_show(struct kobject * kobj, struct attribute * attr, char * page)
-{
-	struct kset *kset = to_kset(kobj);
-	struct subsys_attribute * sattr = to_sattr(attr);
-	ssize_t ret = -EIO;
-
-	if (sattr->show)
-		ret = sattr->show(kset, page);
-	return ret;
-}
-
-static ssize_t 
-subsys_attr_store(struct kobject * kobj, struct attribute * attr, 
-		  const char * page, size_t count)
-{
-	struct kset *kset = to_kset(kobj);
-	struct subsys_attribute * sattr = to_sattr(attr);
-	ssize_t ret = -EIO;
-
-	if (sattr->store)
-		ret = sattr->store(kset, page, count);
-	return ret;
-}
-
-static struct sysfs_ops subsys_sysfs_ops = {
-	.show	= subsys_attr_show,
-	.store	= subsys_attr_store,
-};
-
 /*
  * There's one sysfs_buffer for each open file and one
  * sysfs_open_dirent for each sysfs_dirent with one or more open
@@ -354,29 +317,23 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_buffer * buffer;
-	struct sysfs_ops * ops = NULL;
-	int error;
+	struct sysfs_buffer *buffer;
+	struct sysfs_ops *ops;
+	int error = -EACCES;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	/* if the kobject has no ktype, then we assume that it is a subsystem
-	 * itself, and use ops for it.
-	 */
-	if (kobj->ktype)
+	/* every kobject with an attribute needs a ktype assigned */
+	if (kobj->ktype && kobj->ktype->sysfs_ops)
 		ops = kobj->ktype->sysfs_ops;
-	else
-		ops = &subsys_sysfs_ops;
-
-	error = -EACCES;
-
-	/* No sysfs operations, either from having no subsystem,
-	 * or the subsystem have no operations.
-	 */
-	if (!ops)
+	else {
+		printk(KERN_ERR "missing sysfs attribute operations for "
+		       "kobject: %s\n", kobject_name(kobj));
+		WARN_ON(1);
 		goto err_out;
+	}
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 29dc444..29841bb 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -216,15 +216,6 @@ extern struct kset *firmware_kset;
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
 
-struct subsys_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct kset *, char *);
-	ssize_t (*store)(struct kset *, const char *, size_t);
-};
-
-extern int __must_check subsys_create_file(struct kset *,
-					struct subsys_attribute *);
-
 #if defined(CONFIG_HOTPLUG)
 int kobject_uevent(struct kobject *kobj, enum kobject_action action);
 int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
diff --git a/lib/kobject.c b/lib/kobject.c
index 99f6354..c742ac2 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -810,26 +810,6 @@ void subsystem_unregister(struct kset *s)
 	kset_unregister(s);
 }
 
-/**
- *	subsystem_create_file - export sysfs attribute file.
- *	@s:	subsystem.
- *	@a:	subsystem attribute descriptor.
- */
-
-int subsys_create_file(struct kset *s, struct subsys_attribute *a)
-{
-	int error = 0;
-
-	if (!s || !a)
-		return -EINVAL;
-
-	if (kset_get(s)) {
-		error = sysfs_create_file(&s->kobj, &a->attr);
-		kset_put(s);
-	}
-	return error;
-}
-
 static void kset_release(struct kobject *kobj)
 {
 	struct kset *kset = container_of(kobj, struct kset, kobj);
@@ -927,4 +907,3 @@ EXPORT_SYMBOL(kset_unregister);
 
 EXPORT_SYMBOL(subsystem_register);
 EXPORT_SYMBOL(subsystem_unregister);
-EXPORT_SYMBOL(subsys_create_file);
-- 
1.5.3.8

