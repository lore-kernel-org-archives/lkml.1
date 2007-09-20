Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbXITIK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbXITIK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbXITIGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:12 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:41176 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbXITIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=jwMF80AX4qVdusa89PIBqm+O7XvNK0gFK1Dj265IZ9J8zDYI/GtTZJ0SnbT+1llgHe+e0yyuwcenSlHkEHjgHuX4mw5Njp0NVmn7xCpQe12VIP/MFJKRY5RVg5FPgUnAIMMk91KhxwmCk7M6yoJ7XbVDn/0OdLD+R31BHdQ/Yjg=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 12/22] sysfs: drop kobj and attr from bin related symbols
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <1190275540705-git-send-email-htejun@gmail.com>
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

Currently, binary sysfs files are called (kobj) bin attrs.  sd-based
interface won't be bound to bin_attribute.  Use 'bin' as name and drop
all kobj and attr from symbol names.

This patch doesn't introduce any logic change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c   |   54 +++++++++++++++++++++++++++---------------------------
 fs/sysfs/dir.c   |    2 +-
 fs/sysfs/inode.c |    6 +++---
 fs/sysfs/sysfs.h |    8 ++++----
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 20c2e78..dad891c 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -29,20 +29,20 @@ struct bin_buffer {
 static int
 fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct bin_attribute *attr = sd->s_bin.bin_attr;
+	struct kobject *kobj = sd->s_parent->s_dir.data;
 	int rc;
 
-	/* need attr_sd for attr, its parent for kobj */
-	if (!sysfs_get_active_two(attr_sd))
+	/* need sd for attr, its parent for kobj */
+	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	rc = -EIO;
 	if (attr->read)
 		rc = attr->read(kobj, attr, buffer, off, count);
 
-	sysfs_put_active_two(attr_sd);
+	sysfs_put_active_two(sd);
 
 	return rc;
 }
@@ -86,20 +86,20 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 static int
 flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct bin_attribute *attr = sd->s_bin.bin_attr;
+	struct kobject *kobj = sd->s_parent->s_dir.data;
 	int rc;
 
-	/* need attr_sd for attr, its parent for kobj */
-	if (!sysfs_get_active_two(attr_sd))
+	/* need sd for attr, its parent for kobj */
+	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	rc = -EIO;
 	if (attr->write)
 		rc = attr->write(kobj, attr, buffer, offset, count);
 
-	sysfs_put_active_two(attr_sd);
+	sysfs_put_active_two(sd);
 
 	return rc;
 }
@@ -139,15 +139,15 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 static int mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
+	struct sysfs_dirent *sd = file->f_path.dentry->d_fsdata;
+	struct bin_attribute *attr = sd->s_bin.bin_attr;
+	struct kobject *kobj = sd->s_parent->s_dir.data;
 	int rc;
 
 	mutex_lock(&bb->mutex);
 
-	/* need attr_sd for attr, its parent for kobj */
-	if (!sysfs_get_active_two(attr_sd))
+	/* need sd for attr, its parent for kobj */
+	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	rc = -EINVAL;
@@ -157,7 +157,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	if (rc == 0 && !bb->mmapped)
 		bb->mmapped = 1;
 	else
-		sysfs_put_active_two(attr_sd);
+		sysfs_put_active_two(sd);
 
 	mutex_unlock(&bb->mutex);
 
@@ -166,13 +166,13 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 
 static int open(struct inode * inode, struct file * file)
 {
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
+	struct sysfs_dirent *sd = file->f_path.dentry->d_fsdata;
+	struct bin_attribute *attr = sd->s_bin.bin_attr;
 	struct bin_buffer *bb = NULL;
 	int error;
 
 	/* binary file operations requires both @sd and its parent */
-	if (!sysfs_get_active_two(attr_sd))
+	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	error = -EACCES;
@@ -194,28 +194,28 @@ static int open(struct inode * inode, struct file * file)
 	file->private_data = bb;
 
 	/* open succeeded, put active references */
-	sysfs_put_active_two(attr_sd);
+	sysfs_put_active_two(sd);
 	return 0;
 
  err_out:
-	sysfs_put_active_two(attr_sd);
+	sysfs_put_active_two(sd);
 	kfree(bb);
 	return error;
 }
 
 static int release(struct inode * inode, struct file * file)
 {
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	struct sysfs_dirent *sd = file->f_path.dentry->d_fsdata;
 	struct bin_buffer *bb = file->private_data;
 
 	if (bb->mmapped)
-		sysfs_put_active_two(attr_sd);
+		sysfs_put_active_two(sd);
 	kfree(bb->buffer);
 	kfree(bb);
 	return 0;
 }
 
-const struct file_operations bin_fops = {
+const struct file_operations sysfs_bin_file_operations = {
 	.read		= read,
 	.write		= write,
 	.mmap		= mmap,
@@ -234,7 +234,7 @@ int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 {
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return __sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
+	return __sysfs_add_file(kobj->sd, &attr->attr, SYSFS_BIN);
 }
 
 EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f4a6f2f..263d346 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -342,7 +342,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 		mode |= S_IFDIR;
 		break;
 	case SYSFS_FILE:
-	case SYSFS_KOBJ_BIN_ATTR:
+	case SYSFS_BIN:
 		mode |= S_IFREG;
 		break;
 	case SYSFS_KOBJ_LINK:
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 318e5d5..593b1da 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -166,10 +166,10 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_size = PAGE_SIZE;
 		inode->i_fop = &sysfs_file_operations;
 		break;
-	case SYSFS_KOBJ_BIN_ATTR:
-		bin_attr = sd->s_bin_attr.bin_attr;
+	case SYSFS_BIN:
+		bin_attr = sd->s_bin.bin_attr;
 		inode->i_size = bin_attr->size;
-		inode->i_fop = &bin_fops;
+		inode->i_fop = &sysfs_bin_file_operations;
 		break;
 	case SYSFS_KOBJ_LINK:
 		inode->i_op = &sysfs_symlink_inode_operations;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ca02276..3f505d7 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -17,7 +17,7 @@ struct sysfs_elem_file {
 	struct sysfs_open_dirent *open;
 };
 
-struct sysfs_elem_bin_attr {
+struct sysfs_elem_bin {
 	struct bin_attribute	*bin_attr;
 };
 
@@ -40,7 +40,7 @@ struct sysfs_dirent {
 		struct sysfs_elem_dir		s_dir;
 		struct sysfs_elem_symlink	s_symlink;
 		struct sysfs_elem_file		s_file;
-		struct sysfs_elem_bin_attr	s_bin_attr;
+		struct sysfs_elem_bin		s_bin;
 	};
 
 	unsigned int		s_flags;
@@ -54,7 +54,7 @@ struct sysfs_dirent {
 #define SYSFS_TYPE_MASK			0x00ff
 #define SYSFS_DIR			0x0001
 #define SYSFS_FILE			0x0002
-#define SYSFS_KOBJ_BIN_ATTR		0x0004
+#define SYSFS_BIN			0x0004
 #define SYSFS_KOBJ_LINK			0x0008
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
@@ -149,7 +149,7 @@ int __sysfs_add_file(struct sysfs_dirent *dir_sd,
 /*
  * bin.c
  */
-extern const struct file_operations bin_fops;
+extern const struct file_operations sysfs_bin_file_operations;
 
 /*
  * symlink.c
-- 
1.5.0.3


