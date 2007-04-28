Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbXD1Nk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbXD1Nk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbXD1Nk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45359 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030490AbXD1NkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=evQRNyUfquKO3PPLMjSV5A2KfVoOKS1bzYMi2X/OwNnAqDmnVUqbKioVz9P0r6QwDCPc3OVh7pUf1dT6HmTaf1IljEalUbEsfhDPZ3pgaGfmkiaKTvE28jRwUbWp3CPsk6KueCLIFKyzrpd5SiLA3ZxRQSgmd4cfym2lURY8goQ=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 16/21] sysfs: implement bin_buffer
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:42 +0900
Message-Id: <1177767582628-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement bin_buffer which contains a mutex and pointer to PAGE_SIZE
buffer to properly synchronize accesses to per-openfile buffer and
prepare for immediate-kobj-disconnect.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c |   64 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 67a0d50..5dc47fe 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -20,6 +20,11 @@
 
 #include "sysfs.h"
 
+struct bin_buffer {
+	struct mutex	mutex;
+	void		*buffer;
+};
+
 static int
 fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
@@ -36,7 +41,7 @@ fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 static ssize_t
 read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 {
-	char *buffer = file->private_data;
+	struct bin_buffer *bb = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
@@ -49,17 +54,23 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 			count = size - offs;
 	}
 
-	count = fill_read(dentry, buffer, offs, count);
+	mutex_lock(&bb->mutex);
+
+	count = fill_read(dentry, bb->buffer, offs, count);
 	if (count < 0)
-		return count;
+		goto out_unlock;
 
-	if (copy_to_user(userbuf, buffer, count))
-		return -EFAULT;
+	if (copy_to_user(userbuf, bb->buffer, count)) {
+		count = -EFAULT;
+		goto out_unlock;
+	}
 
 	pr_debug("offs = %lld, *off = %lld, count = %d\n", offs, *off, count);
 
 	*off = offs + count;
 
+ out_unlock:
+	mutex_unlock(&bb->mutex);
 	return count;
 }
 
@@ -79,7 +90,7 @@ flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 static ssize_t write(struct file *file, const char __user *userbuf,
 		     size_t bytes, loff_t *off)
 {
-	char *buffer = file->private_data;
+	struct bin_buffer *bb = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
@@ -92,25 +103,38 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 			count = size - offs;
 	}
 
-	if (copy_from_user(buffer, userbuf, count))
-		return -EFAULT;
+	mutex_lock(&bb->mutex);
+
+	if (copy_from_user(bb->buffer, userbuf, count)) {
+		count = -EFAULT;
+		goto out_unlock;
+	}
 
-	count = flush_write(dentry, buffer, offs, count);
+	count = flush_write(dentry, bb->buffer, offs, count);
 	if (count > 0)
 		*off = offs + count;
+
+ out_unlock:
+	mutex_unlock(&bb->mutex);
 	return count;
 }
 
 static int mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
 	struct kobject *kobj = to_kobj(file->f_path.dentry->d_parent);
+	int rc;
 
 	if (!attr->mmap)
 		return -EINVAL;
 
-	return attr->mmap(kobj, attr, vma);
+	mutex_lock(&bb->mutex);
+	rc = attr->mmap(kobj, attr, vma);
+	mutex_unlock(&bb->mutex);
+
+	return rc;
 }
 
 static int open(struct inode * inode, struct file * file)
@@ -118,6 +142,7 @@ static int open(struct inode * inode, struct file * file)
 	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
+	struct bin_buffer *bb = NULL;
 	int error = -EINVAL;
 
 	if (!kobj || !attr)
@@ -135,14 +160,22 @@ static int open(struct inode * inode, struct file * file)
 		goto Error;
 
 	error = -ENOMEM;
-	file->private_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!file->private_data)
+	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
+	if (!bb)
 		goto Error;
 
+	bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!bb->buffer)
+		goto Error;
+
+	mutex_init(&bb->mutex);
+	file->private_data = bb;
+
 	error = 0;
-    goto Done;
+	goto Done;
 
  Error:
+	kfree(bb);
 	module_put(attr->attr.owner);
  Done:
 	if (error)
@@ -155,11 +188,12 @@ static int release(struct inode * inode, struct file * file)
 	struct kobject * kobj = to_kobj(file->f_path.dentry->d_parent);
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	u8 * buffer = file->private_data;
+	struct bin_buffer *bb = file->private_data;
 
 	kobject_put(kobj);
 	module_put(attr->attr.owner);
-	kfree(buffer);
+	kfree(bb->buffer);
+	kfree(bb);
 	return 0;
 }
 
-- 
1.5.0.3


