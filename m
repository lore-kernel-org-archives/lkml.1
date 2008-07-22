Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYGVFpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYGVFpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYGVF0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:43416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032AbYGVF0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 71/79] driver core: Suppress sysfs warnings for device_rename().
Date: Mon, 21 Jul 2008 22:19:35 -0700
Message-Id: <1216703983-21448-71-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

driver core: Suppress sysfs warnings for device_rename().

Renaming network devices to an already existing name is not
something we want sysfs to print a scary warning for, since the
callers can deal with this correctly. So let's introduce
sysfs_create_link_nowarn() which gets rid of the common warning.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c   |    9 +++++----
 fs/sysfs/dir.c        |   37 +++++++++++++++++++++++++++++++++++--
 fs/sysfs/symlink.c    |   41 +++++++++++++++++++++++++++++++++--------
 fs/sysfs/sysfs.h      |    1 +
 include/linux/sysfs.h |   10 ++++++++++
 5 files changed, 84 insertions(+), 14 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c05b115..7d5c63c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1345,8 +1345,9 @@ int device_rename(struct device *dev, char *new_name)
 	if (old_class_name) {
 		new_class_name = make_class_name(dev->class->name, &dev->kobj);
 		if (new_class_name) {
-			error = sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, new_class_name);
+			error = sysfs_create_link_nowarn(&dev->parent->kobj,
+							 &dev->kobj,
+							 new_class_name);
 			if (error)
 				goto out;
 			sysfs_remove_link(&dev->parent->kobj, old_class_name);
@@ -1354,8 +1355,8 @@ int device_rename(struct device *dev, char *new_name)
 	}
 #else
 	if (dev->class) {
-		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
-					  &dev->kobj, dev->bus_id);
+		error = sysfs_create_link_nowarn(&dev->class->p->class_subsys.kobj,
+						 &dev->kobj, dev->bus_id);
 		if (error)
 			goto out;
 		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8c0e4b9..c1a7efb 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -398,7 +398,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 }
 
 /**
- *	sysfs_add_one - add sysfs_dirent to parent
+ *	__sysfs_add_one - add sysfs_dirent to parent without warning
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be added
  *
@@ -417,7 +417,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
 	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
 		return -EEXIST;
@@ -435,6 +435,39 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 }
 
 /**
+ *	sysfs_add_one - add sysfs_dirent to parent
+ *	@acxt: addrm context to use
+ *	@sd: sysfs_dirent to be added
+ *
+ *	Get @acxt->parent_sd and set sd->s_parent to it and increment
+ *	nlink of parent inode if @sd is a directory and link into the
+ *	children list of the parent.
+ *
+ *	This function should be called between calls to
+ *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
+ *	passed the same @acxt as passed to sysfs_addrm_start().
+ *
+ *	LOCKING:
+ *	Determined by sysfs_addrm_start().
+ *
+ *	RETURNS:
+ *	0 on success, -EEXIST if entry with the given name already
+ *	exists.
+ */
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
+{
+	int ret;
+
+	ret = __sysfs_add_one(acxt, sd);
+	if (ret == -EEXIST) {
+		printk(KERN_WARNING "sysfs: duplicate filename '%s' "
+		       "can not be created\n", sd->s_name);
+		WARN_ON(1);
+	}
+	return ret;
+}
+
+/**
  *	sysfs_remove_one - remove sysfs_dirent from parent
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be removed
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 817f596..a3ba217 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -19,13 +19,8 @@
 
 #include "sysfs.h"
 
-/**
- *	sysfs_create_link - create symlink between two objects.
- *	@kobj:	object whose directory we're creating the link in.
- *	@target:	object we're pointing to.
- *	@name:		name of the symlink.
- */
-int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * name)
+static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
+				const char *name, int warn)
 {
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
@@ -65,7 +60,10 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
-	error = sysfs_add_one(&acxt, sd);
+	if (warn)
+		error = sysfs_add_one(&acxt, sd);
+	else
+		error = __sysfs_add_one(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
@@ -80,6 +78,33 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 }
 
 /**
+ *	sysfs_create_link - create symlink between two objects.
+ *	@kobj:	object whose directory we're creating the link in.
+ *	@target:	object we're pointing to.
+ *	@name:		name of the symlink.
+ */
+int sysfs_create_link(struct kobject *kobj, struct kobject *target,
+		      const char *name)
+{
+	return sysfs_do_create_link(kobj, target, name, 1);
+}
+
+/**
+ *	sysfs_create_link_nowarn - create symlink between two objects.
+ *	@kobj:	object whose directory we're creating the link in.
+ *	@target:	object we're pointing to.
+ *	@name:		name of the symlink.
+ *
+ *	This function does the same as sysf_create_link(), but it
+ *	doesn't warn if the link already exists.
+ */
+int sysfs_create_link_nowarn(struct kobject *kobj, struct kobject *target,
+			     const char *name)
+{
+	return sysfs_do_create_link(kobj, target, name, 0);
+}
+
+/**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
  *	@name:	name of the symlink to remove.
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ce4e15f..a5db496 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -107,6 +107,7 @@ struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
 void sysfs_put_active_two(struct sysfs_dirent *sd);
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 		       struct sysfs_dirent *parent_sd);
+int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 7858eac..37fa241 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -101,6 +101,9 @@ void sysfs_remove_bin_file(struct kobject *kobj, struct bin_attribute *attr);
 
 int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
 				   const char *name);
+int __must_check sysfs_create_link_nowarn(struct kobject *kobj,
+					  struct kobject *target,
+					  const char *name);
 void sysfs_remove_link(struct kobject *kobj, const char *name);
 
 int __must_check sysfs_create_group(struct kobject *kobj,
@@ -180,6 +183,13 @@ static inline int sysfs_create_link(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_create_link_nowarn(struct kobject *kobj,
+					   struct kobject *target,
+					   const char *name)
+{
+	return 0;
+}
+
 static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
 }
-- 
1.5.6.3

