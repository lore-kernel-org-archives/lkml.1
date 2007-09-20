Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbXITIIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbXITIIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbXITIGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:34681 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbXITIFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=Q8YrsiOXtQm4iHMC8E9Cq9ouZYGYo1n+VZD7I++PIXQMhBwDhwzOGylTz9QUtHqxCPeP0BrztQuwkT965vUI8Ubnl0koHp+NztenMXNEJog3hJY/45UMebX02LZpnU8b6JPlQDFf2+CyPzt7UjNDbgDjnIKMOkZVqNJcXx+tvbI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 08/22] sysfs: implement sysfs_dirent based directory interface
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <11902755402788-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert sd->s_dir.kobj to sd->s_dir.data and make it void *, and
implement sd based directory creation function sysfs_add_dir().  Using
this function the caller can create directory node with arbitrary user
data.  Also, name copying is not implicit.  Name is copied iff
SYSFS_COPY_NAME should be specified in @mode.

* sysfs_root is exported.  To be used as @parent when creating a node
  below the sysfs root.

* Kobject-based sysfs_create_dir() is reimplemented in terms of
  sysfs_add_dir() and moved to fs/sysfs/kobject.c.

* Users of sysfs_create_dir() in sysfs are converted to use
  sysfs_add_dir().

* attr and bin_attr still can cope only with kobject sd->s_dir.data,
  so sysfs_add_dir() can't be used with arbitrary pointer yet.  This
  will be changed by following patches.

This patch doesn't introduce any behavior change to the original API.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c        |    6 +-
 fs/sysfs/dir.c        |  108 +++++++++++++++++++++++++++----------------------
 fs/sysfs/file.c       |    6 +-
 fs/sysfs/group.c      |    8 ++--
 fs/sysfs/kobject.c    |   26 ++++++++++++
 fs/sysfs/mount.c      |    2 +
 fs/sysfs/sysfs.h      |    8 +--
 include/linux/sysfs.h |   16 +++++++
 8 files changed, 117 insertions(+), 63 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 1c12cf0..91e573f 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -31,7 +31,7 @@ fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
 	int rc;
 
 	/* need attr_sd for attr, its parent for kobj */
@@ -88,7 +88,7 @@ flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
 	int rc;
 
 	/* need attr_sd for attr, its parent for kobj */
@@ -141,7 +141,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
 	int rc;
 
 	mutex_lock(&bb->mutex);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7cb3f1e..b15ade7 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -7,7 +7,6 @@
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/module.h>
-#include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <linux/completion.h>
@@ -639,6 +638,40 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 }
 
 /**
+ *	sysfs_insert_one - shortcut function to add single sysfs_dirent
+ *	@parent: parent to add sysfs_dirent under
+ *	@sd: sysfs_dirent to add
+ *
+ *	A shortcut function to perform sysfs_addrm_start, add_one,
+ *	addrm_finish sequence and error handling for a single
+ *	sysfs_dirent.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to the new sysfs_dirent on success, ERR_PTR() value on
+ *	failure.
+ */
+struct sysfs_dirent *sysfs_insert_one(struct sysfs_dirent *parent,
+				      struct sysfs_dirent *sd)
+{
+	struct sysfs_addrm_cxt acxt;
+	int rc;
+
+	sysfs_addrm_start(&acxt);
+	rc = sysfs_add_one(&acxt, parent, sd);
+	sysfs_addrm_finish(&acxt);
+
+	if (rc) {
+		sysfs_put(sd);
+		return ERR_PTR(rc);
+	}
+
+	return sd;
+}
+
+/**
  *	sysfs_find_dirent - find sysfs_dirent with the given name
  *	@parent_sd: sysfs_dirent to search under
  *	@name: name to look for
@@ -722,60 +755,39 @@ struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 }
 EXPORT_SYMBOL_GPL(sysfs_find_child);
 
-static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
-		      const char *name, struct sysfs_dirent **p_sd)
-{
-	umode_t mode = S_IRWXU | S_IRUGO | S_IXUGO;
-	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent *sd;
-	int rc;
-
-	/* allocate */
-	sd = sysfs_new_dirent(name, mode | SYSFS_COPY_NAME, SYSFS_DIR);
-	if (!sd)
-		return -ENOMEM;
-	sd->s_dir.kobj = kobj;
-
-	/* link in */
-	sysfs_addrm_start(&acxt);
-	rc = sysfs_add_one(&acxt, parent_sd, sd);
-	sysfs_addrm_finish(&acxt);
-
-	if (rc == 0)
-		*p_sd = sd;
-	else
-		sysfs_put(sd);
-
-	return rc;
-}
-
-int sysfs_create_subdir(struct kobject *kobj, const char *name,
-			struct sysfs_dirent **p_sd)
-{
-	return create_dir(kobj, kobj->sd, name, p_sd);
-}
-
 /**
- *	sysfs_create_dir - create a directory for an object.
- *	@kobj:		object we're creating directory for. 
+ *	sysfs_add_dir - add a new sysfs directory
+ *	@parent: sysfs_dirent to add the directory under
+ *	@name: name of the new directory
+ *	@mode: mode and SYSFS_* flags for the new directory
+ *	@data: s_dir.data for the new directory
+ *
+ *	Add a new directory under @parent with the specified
+ *	parameters.  If SYSFS_COPY_NAME is set in @mode, @name is
+ *	copied before being used.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to the new sysfs_dirent on success, ERR_PTR() value on
+ *	error.
  */
-int sysfs_create_dir(struct kobject * kobj)
+struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
+				   const char *name, mode_t mode, void *data)
 {
-	struct sysfs_dirent *parent_sd, *sd;
-	int error = 0;
+	struct sysfs_dirent *sd;
 
-	BUG_ON(!kobj);
+	/* allocate and initialize */
+	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
+	if (!sd)
+		return ERR_PTR(-ENOMEM);
 
-	if (kobj->parent)
-		parent_sd = kobj->parent->sd;
-	else
-		parent_sd = sysfs_root;
+	sd->s_dir.data = data;
 
-	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd);
-	if (!error)
-		kobj->sd = sd;
-	return error;
+	return sysfs_insert_one(parent, sd);
 }
+EXPORT_SYMBOL_GPL(sysfs_add_dir);
 
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1faba5f..8154fbb 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -145,7 +145,7 @@ void sysfs_file_check_suicide(struct sysfs_dirent *sd)
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
 	struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
@@ -265,7 +265,7 @@ static int
 flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
 	struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
@@ -404,7 +404,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index cef0376..e4993fd 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -39,7 +39,7 @@ static int create_files(struct sysfs_dirent *dir_sd,
 }
 
 
-int sysfs_create_group(struct kobject * kobj, 
+int sysfs_create_group(struct kobject * kobj,
 		       const struct attribute_group * grp)
 {
 	struct sysfs_dirent *sd;
@@ -48,9 +48,9 @@ int sysfs_create_group(struct kobject * kobj,
 	BUG_ON(!kobj || !kobj->sd);
 
 	if (grp->name) {
-		error = sysfs_create_subdir(kobj, grp->name, &sd);
-		if (error)
-			return error;
+		sd = sysfs_add_dir(kobj->sd, grp->name, SYSFS_DIR_MODE, kobj);
+		if (IS_ERR(sd))
+			return PTR_ERR(sd);
 	} else
 		sd = kobj->sd;
 	sysfs_get(sd);
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 9415f18..8e4677c 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -30,6 +30,32 @@ static int sysfs_remove_child(struct sysfs_dirent *parent, const char *name)
 }
 
 /**
+ *	sysfs_create_dir - create a directory for an object.
+ *	@kobj:	object we're creating directory for.
+ */
+int sysfs_create_dir(struct kobject *kobj)
+{
+	struct sysfs_dirent *parent, *sd;
+
+	BUG_ON(!kobj);
+
+	if (kobj->parent) {
+		parent = kobj->parent->sd;
+		if (!parent)
+			return -EFAULT;
+	} else
+		parent = sysfs_root;
+
+	sd = sysfs_add_dir(parent, kobject_name(kobj),
+			   SYSFS_DIR_MODE | SYSFS_COPY_NAME, kobj);
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+
+	kobj->sd = sd;
+	return 0;
+}
+
+/**
  *	sysfs_remove_dir - remove an object's directory.
  *	@kobj:	object.
  *
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index d00d4b9..d61eb08 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -8,6 +8,7 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
+#include <linux/module.h>
 
 #include "sysfs.h"
 
@@ -32,6 +33,7 @@ static struct sysfs_dirent sysfs_root_storage = {
 };
 
 struct sysfs_dirent * const sysfs_root = &sysfs_root_storage;
+EXPORT_SYMBOL_GPL(sysfs_root);
 
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 9494f3d..82ade38 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -2,7 +2,7 @@ struct sysfs_open_dirent;
 
 /* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
-	struct kobject		*kobj;
+	void			*data;
 	/* children list starts here and goes through sd->s_sibling */
 	struct sysfs_dirent	*children;
 };
@@ -78,7 +78,6 @@ struct sysfs_addrm_cxt {
 /*
  * mount.c
  */
-extern struct sysfs_dirent * const sysfs_root;
 extern struct super_block *sysfs_sb;
 extern struct kmem_cache *sysfs_dir_cachep;
 
@@ -102,6 +101,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *parent,
 		  struct sysfs_dirent *sd);
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
+struct sysfs_dirent *sysfs_insert_one(struct sysfs_dirent *parent,
+				      struct sysfs_dirent *sd);
 
 struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 				       const unsigned char *name);
@@ -113,9 +114,6 @@ void __sysfs_remove(struct sysfs_dirent *sd, int recurse);
 
 void release_sysfs_dirent(struct sysfs_dirent *sd);
 
-int sysfs_create_subdir(struct kobject *kobj, const char *name,
-			struct sysfs_dirent **p_sd);
-
 static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 4ad2874..3c64b4a 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -17,6 +17,8 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/stat.h>
+#include <linux/err.h>
 
 struct sysfs_dirent;
 struct vm_area_struct;
@@ -26,6 +28,7 @@ struct vm_area_struct;
  * valid as real mode bits.  Bits in S_IFMT are used to set sysfs
  * specific flags.
  */
+#define SYSFS_DIR_MODE		(S_IRWXU | S_IRUGO | S_IXUGO)
 #define SYSFS_COPY_NAME		010000	/* copy passed @name */
 
 /* collection of all flags for verification */
@@ -33,6 +36,11 @@ struct vm_area_struct;
 
 #ifdef CONFIG_SYSFS
 
+extern struct sysfs_dirent * const sysfs_root;
+
+struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
+			const char *name, mode_t mode, void *data);
+
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 				      const char *name);
 void sysfs_remove(struct sysfs_dirent *sd);
@@ -41,6 +49,14 @@ int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
 
+#define sysfs_root		((struct sysfs_dirent *)NULL)
+
+static inline struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
+			const char *name, mode_t mode, void *data)
+{
+	return NULL;
+}
+
 static inline struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 						    const char *name)
 {
-- 
1.5.0.3


