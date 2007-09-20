Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbXITIQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbXITIQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXITIGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:41897 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbXITIGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=KidLXSYLsFEYGNp7e+z3xg1V+0IcsNVx7pOXVsItSaPrW8/uXyub+n6KbmmWgbBgV189L/luVtLzgRNksvqdE8hGWG0ZFen4hwDODUsu7ibgCQN/7USj/6ep6j9ejF8PLGIWQN77P+Wkk8BhmF6vs7skM2srRcViwC5ShgqOoFI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 13/22] sysfs: implement sysfs_dirent based bin interface
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <11902755403327-git-send-email-htejun@gmail.com>
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

sysfs_add_bin() creates a binary sysfs file which is equivalent to
binary attribute file of the original API.  As with file, bin ops take
private data of both itself and parent to support kobject based API
and kobject based interface works by setting parent_data to kobj and
data to battr.

Other than interface change, internal implementation is mostly
identical.

This patch doesn't introduce any behavior change to the original API.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c        |   77 +++++++++++++++++++++++--------------------
 fs/sysfs/inode.c      |    5 +--
 fs/sysfs/kobject.c    |   87 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h      |    4 ++-
 include/linux/sysfs.h |   18 ++++++++++
 5 files changed, 150 insertions(+), 41 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index dad891c..d6cc7b3 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -11,7 +11,6 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
-#include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
@@ -26,21 +25,21 @@ struct bin_buffer {
 	int		mmapped;
 };
 
-static int
-fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
+static int fill_read(struct dentry *dentry, char *buffer, loff_t off,
+		     size_t count)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
-	struct bin_attribute *attr = sd->s_bin.bin_attr;
-	struct kobject *kobj = sd->s_parent->s_dir.data;
+	const struct sysfs_bin_ops *bops = sd->s_bin.ops;
 	int rc;
 
-	/* need sd for attr, its parent for kobj */
+	/* need sd for bops and data, its parent for parent_data */
 	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
-	rc = -EIO;
-	if (attr->read)
-		rc = attr->read(kobj, attr, buffer, off, count);
+	rc = -EACCES;
+	if (bops->read)
+		rc = bops->read(buffer, off, count, sd->s_bin.data,
+				sd->s_parent->s_dir.data);
 
 	sysfs_put_active_two(sd);
 
@@ -83,21 +82,21 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 	return count;
 }
 
-static int
-flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
+static int flush_write(struct dentry *dentry, char *buffer, loff_t offset,
+		       size_t count)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
-	struct bin_attribute *attr = sd->s_bin.bin_attr;
-	struct kobject *kobj = sd->s_parent->s_dir.data;
+	const struct sysfs_bin_ops *bops = sd->s_bin.ops;
 	int rc;
 
-	/* need sd for attr, its parent for kobj */
+	/* need sd for bops and data, its parent for parent_data */
 	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
-	rc = -EIO;
-	if (attr->write)
-		rc = attr->write(kobj, attr, buffer, offset, count);
+	rc = -EACCES;
+	if (bops->write)
+		rc = bops->write(buffer, offset, count, sd->s_bin.data,
+				 sd->s_parent->s_dir.data);
 
 	sysfs_put_active_two(sd);
 
@@ -140,19 +139,19 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = sd->s_bin.bin_attr;
-	struct kobject *kobj = sd->s_parent->s_dir.data;
+	const struct sysfs_bin_ops *bops = sd->s_bin.ops;
 	int rc;
 
 	mutex_lock(&bb->mutex);
 
-	/* need sd for attr, its parent for kobj */
+	/* need sd for bops and data, its parent for parent_data */
 	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	rc = -EINVAL;
-	if (attr->mmap)
-		rc = attr->mmap(kobj, attr, vma);
+	if (bops->mmap)
+		rc = bops->mmap(vma, sd->s_bin.data,
+				sd->s_parent->s_dir.data);
 
 	if (rc == 0 && !bb->mmapped)
 		bb->mmapped = 1;
@@ -167,7 +166,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 static int open(struct inode * inode, struct file * file)
 {
 	struct sysfs_dirent *sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = sd->s_bin.bin_attr;
+	const struct sysfs_bin_ops *bops = sd->s_bin.ops;
 	struct bin_buffer *bb = NULL;
 	int error;
 
@@ -176,9 +175,11 @@ static int open(struct inode * inode, struct file * file)
 		return -ENODEV;
 
 	error = -EACCES;
-	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
+	if (!bops)
 		goto err_out;
-	if ((file->f_mode & FMODE_READ) && !(attr->read || attr->mmap))
+	if ((file->f_mode & FMODE_WRITE) && !(bops->write || bops->mmap))
+		goto err_out;
+	if ((file->f_mode & FMODE_READ) && !(bops->read || bops->mmap))
 		goto err_out;
 
 	error = -ENOMEM;
@@ -224,17 +225,21 @@ const struct file_operations sysfs_bin_file_operations = {
 	.release	= release,
 };
 
-/**
- *	sysfs_create_bin_file - create binary file for object.
- *	@kobj:	object.
- *	@attr:	attribute descriptor.
- */
-
-int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
+struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
+				   const char *name, mode_t mode, size_t size,
+				   const struct sysfs_bin_ops *bops, void *data)
 {
-	BUG_ON(!kobj || !kobj->sd || !attr);
+	struct sysfs_dirent *sd;
 
-	return __sysfs_add_file(kobj->sd, &attr->attr, SYSFS_BIN);
-}
+	/* allocate and initialize */
+	sd = sysfs_new_dirent(name, mode, SYSFS_BIN);
+	if (!sd)
+		return ERR_PTR(-ENOMEM);
+
+	sd->s_bin.ops = bops;
+	sd->s_bin.size = size;
+	sd->s_bin.data = data;
 
-EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
+	return sysfs_insert_one(parent, sd);
+}
+EXPORT_SYMBOL(sysfs_add_bin);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 593b1da..d303e62 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -136,8 +136,6 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
-	struct bin_attribute *bin_attr;
-
 	inode->i_blocks = 0;
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
@@ -167,8 +165,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_file_operations;
 		break;
 	case SYSFS_BIN:
-		bin_attr = sd->s_bin.bin_attr;
-		inode->i_size = bin_attr->size;
+		inode->i_size = sd->s_bin.size;
 		inode->i_fop = &sysfs_bin_file_operations;
 		break;
 	case SYSFS_KOBJ_LINK:
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 56ec704..a34c54e 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -252,6 +252,93 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
 
+/*
+ * kobject bin_attribute interface
+ */
+static ssize_t sysfs_battr_read(char *buf, loff_t off, size_t size,
+				void *data, void *parent_data)
+{
+	struct kobject *kobj = parent_data;
+	struct bin_attribute *battr = data;
+
+	if (!battr->read)
+		return -EACCES;
+
+	return battr->read(kobj, battr, buf, off, size);
+}
+
+static ssize_t sysfs_battr_write(char *buf, loff_t off, size_t size,
+				 void *data, void *parent_data)
+{
+	struct kobject *kobj = parent_data;
+	struct bin_attribute *battr = data;
+
+	if (!battr->write)
+		return -EACCES;
+
+	return battr->write(kobj, battr, buf, off, size);
+}
+
+static int sysfs_battr_mmap(struct vm_area_struct *vma, void *data,
+			    void *parent_data)
+{
+	struct kobject *kobj = parent_data;
+	struct bin_attribute *battr = data;
+
+	if (!battr->mmap)
+		return -EINVAL;
+
+	return battr->mmap(kobj, battr, vma);
+}
+
+static const struct sysfs_bin_ops sysfs_battr_rwm_bops = {
+	.read	= sysfs_battr_read,
+	.write	= sysfs_battr_write,
+	.mmap	= sysfs_battr_mmap,
+};
+
+static const struct sysfs_bin_ops sysfs_battr_rw_bops = {
+	.read	= sysfs_battr_read,
+	.write	= sysfs_battr_write,
+};
+
+static const struct sysfs_bin_ops sysfs_battr_ro_bops = {
+	.read	= sysfs_battr_read,
+};
+
+static const struct sysfs_bin_ops sysfs_battr_wo_bops = {
+	.write	= sysfs_battr_write,
+};
+
+/**
+ *	sysfs_create_bin_file - create binary file for object.
+ *	@kobj:	object.
+ *	@attr:	attribute descriptor.
+ */
+int sysfs_create_bin_file(struct kobject *kobj, struct bin_attribute *battr)
+{
+	struct sysfs_dirent *sd;
+	const struct sysfs_bin_ops *bops = NULL;
+
+	BUG_ON(!kobj || !kobj->sd || !battr);
+
+	if (battr->mmap)
+		bops = &sysfs_battr_rwm_bops;
+	else if (battr->read && battr->write)
+		bops = &sysfs_battr_rw_bops;
+	else if (battr->read)
+		bops = &sysfs_battr_ro_bops;
+	else if (battr->write)
+		bops = &sysfs_battr_wo_bops;
+
+	sd = sysfs_add_bin(kobj->sd, battr->attr.name, battr->attr.mode,
+			   battr->size, bops, battr);
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
+
 /**
  *	sysfs_remove_bin_file - remove binary file for object.
  *	@kobj:	object.
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3f505d7..d8c61c5 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -18,7 +18,9 @@ struct sysfs_elem_file {
 };
 
 struct sysfs_elem_bin {
-	struct bin_attribute	*bin_attr;
+	const struct sysfs_bin_ops *ops;
+	void			*data;
+	size_t			size;
 };
 
 /*
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 9304db7..dfb6bd7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -40,6 +40,14 @@ struct sysfs_file_ops {
 			 void *parent_data);
 };
 
+struct sysfs_bin_ops {
+	ssize_t (*read)(char *buf, loff_t off, size_t size, void *data,
+			void *parent_data);
+	ssize_t (*write)(char *buf, loff_t off, size_t size, void *data,
+			 void *parent_data);
+	int (*mmap)(struct vm_area_struct *vma, void *data, void *parent_data);
+};
+
 #ifdef CONFIG_SYSFS
 
 extern struct sysfs_dirent * const sysfs_root;
@@ -49,6 +57,9 @@ struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
 struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
 			const char *name, mode_t mode,
 			const struct sysfs_file_ops *fops, void *data);
+struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
+			const char *name, mode_t mode, size_t size,
+			const struct sysfs_bin_ops *bops, void *data);
 
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 				      const char *name);
@@ -76,6 +87,13 @@ static inline struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
 	return NULL;
 }
 
+static inline struct sysfs_dirent *sysfs_add_bin(struct sysfs_dirent *parent,
+			const char *name, mode_t mode, size_t size,
+			const struct sysfs_bin_ops *bops, void *data)
+{
+	return NULL;
+}
+
 static inline struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 						    const char *name)
 {
-- 
1.5.0.3


