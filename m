Return-Path: <linux-kernel-owner+w=401wt.eu-S1759869AbZCYAri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869AbZCYAri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZCYAaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:35 -0400
Received: from kroah.org ([198.145.64.141]:54183 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756873AbZCYAaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/61] sysfs: don't block indefinitely for unmapped files.
Date: Tue, 24 Mar 2009 17:26:52 -0700
Message-Id: <1237940825-22904-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

Modify sysfs bin files so that we can remove the bin file while they are
still mapped.  When the kobject is removed we unmap the bin file and
arrange for future accesses to the mapping to receive SIGBUS.

Implementing this prevents a nasty DOS when pci devices are hot plugged
and unplugged.  Where if any of their resources were mmaped the kernel
could not free up their pci resources or release their pci data
structures.

[akpm@linux-foundation.org: remove unused var]
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c   |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/sysfs/dir.c   |    1 +
 fs/sysfs/sysfs.h |    2 +
 3 files changed, 174 insertions(+), 13 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index f2c478c..96cc2bf 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -21,15 +21,28 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 
 #include "sysfs.h"
 
+/*
+ * There's one bin_buffer for each open file.
+ *
+ * filp->private_data points to bin_buffer and
+ * sysfs_dirent->s_bin_attr.buffers points to a the bin_buffer s
+ * sysfs_dirent->s_bin_attr.buffers is protected by sysfs_bin_lock
+ */
+static DEFINE_MUTEX(sysfs_bin_lock);
+
 struct bin_buffer {
-	struct mutex	mutex;
-	void		*buffer;
-	int		mmapped;
+	struct mutex			mutex;
+	void				*buffer;
+	int				mmapped;
+	struct vm_operations_struct 	*vm_ops;
+	struct file			*file;
+	struct hlist_node		list;
 };
 
 static int
@@ -168,29 +181,148 @@ out_free:
 	return count;
 }
 
+static void bin_vma_open(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+
+	if (!bb->vm_ops || !bb->vm_ops->open)
+		return;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return;
+
+	bb->vm_ops->open(vma);
+
+	sysfs_put_active_two(attr_sd);
+}
+
+static void bin_vma_close(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+
+	if (!bb->vm_ops || !bb->vm_ops->close)
+		return;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return;
+
+	bb->vm_ops->close(vma);
+
+	sysfs_put_active_two(attr_sd);
+}
+
+static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	int ret;
+
+	if (!bb->vm_ops || !bb->vm_ops->fault)
+		return VM_FAULT_SIGBUS;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return VM_FAULT_SIGBUS;
+
+	ret = bb->vm_ops->fault(vma, vmf);
+
+	sysfs_put_active_two(attr_sd);
+	return ret;
+}
+
+static int bin_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	int ret;
+
+	if (!bb->vm_ops || !bb->vm_ops->page_mkwrite)
+		return -EINVAL;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return -EINVAL;
+
+	ret = bb->vm_ops->page_mkwrite(vma, page);
+
+	sysfs_put_active_two(attr_sd);
+	return ret;
+}
+
+static int bin_access(struct vm_area_struct *vma, unsigned long addr,
+		  void *buf, int len, int write)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	int ret;
+
+	if (!bb->vm_ops || !bb->vm_ops->access)
+		return -EINVAL;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return -EINVAL;
+
+	ret = bb->vm_ops->access(vma, addr, buf, len, write);
+
+	sysfs_put_active_two(attr_sd);
+	return ret;
+}
+
+static struct vm_operations_struct bin_vm_ops = {
+	.open		= bin_vma_open,
+	.close		= bin_vma_close,
+	.fault		= bin_fault,
+	.page_mkwrite	= bin_page_mkwrite,
+	.access		= bin_access,
+};
+
 static int mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct vm_operations_struct *vm_ops;
 	int rc;
 
 	mutex_lock(&bb->mutex);
 
 	/* need attr_sd for attr, its parent for kobj */
+	rc = -ENODEV;
 	if (!sysfs_get_active_two(attr_sd))
-		return -ENODEV;
+		goto out_unlock;
 
 	rc = -EINVAL;
-	if (attr->mmap)
-		rc = attr->mmap(kobj, attr, vma);
+	if (!attr->mmap)
+		goto out_put;
 
-	if (rc == 0 && !bb->mmapped)
-		bb->mmapped = 1;
-	else
-		sysfs_put_active_two(attr_sd);
+	rc = attr->mmap(kobj, attr, vma);
+	vm_ops = vma->vm_ops;
+	vma->vm_ops = &bin_vm_ops;
+	if (rc)
+		goto out_put;
 
+	rc = -EINVAL;
+	if (bb->mmapped && bb->vm_ops != vma->vm_ops)
+		goto out_put;
+
+#ifdef CONFIG_NUMA
+	rc = -EINVAL;
+	if (vm_ops && ((vm_ops->set_policy || vm_ops->get_policy || vm_ops->migrate)))
+		goto out_put;
+#endif
+
+	rc = 0;
+	bb->mmapped = 1;
+	bb->vm_ops = vm_ops;
+out_put:
+	sysfs_put_active_two(attr_sd);
+out_unlock:
 	mutex_unlock(&bb->mutex);
 
 	return rc;
@@ -223,8 +355,13 @@ static int open(struct inode * inode, struct file * file)
 		goto err_out;
 
 	mutex_init(&bb->mutex);
+	bb->file = file;
 	file->private_data = bb;
 
+	mutex_lock(&sysfs_bin_lock);
+	hlist_add_head(&bb->list, &attr_sd->s_bin_attr.buffers);
+	mutex_unlock(&sysfs_bin_lock);
+
 	/* open succeeded, put active references */
 	sysfs_put_active_two(attr_sd);
 	return 0;
@@ -237,11 +374,12 @@ static int open(struct inode * inode, struct file * file)
 
 static int release(struct inode * inode, struct file * file)
 {
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_buffer *bb = file->private_data;
 
-	if (bb->mmapped)
-		sysfs_put_active_two(attr_sd);
+	mutex_lock(&sysfs_bin_lock);
+	hlist_del(&bb->list);
+	mutex_unlock(&sysfs_bin_lock);
+
 	kfree(bb->buffer);
 	kfree(bb);
 	return 0;
@@ -256,6 +394,26 @@ const struct file_operations bin_fops = {
 	.release	= release,
 };
 
+
+void unmap_bin_file(struct sysfs_dirent *attr_sd)
+{
+	struct bin_buffer *bb;
+	struct hlist_node *tmp;
+
+	if (sysfs_type(attr_sd) != SYSFS_KOBJ_BIN_ATTR)
+		return;
+
+	mutex_lock(&sysfs_bin_lock);
+
+	hlist_for_each_entry(bb, tmp, &attr_sd->s_bin_attr.buffers, list) {
+		struct inode *inode = bb->file->f_path.dentry->d_inode;
+
+		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+	}
+
+	mutex_unlock(&sysfs_bin_lock);
+}
+
 /**
  *	sysfs_create_bin_file - create binary file for object.
  *	@kobj:	object.
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f13d852..66aeb4f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -609,6 +609,7 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 
 		sysfs_drop_dentry(sd);
 		sysfs_deactivate(sd);
+		unmap_bin_file(sd);
 		sysfs_put(sd);
 	}
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 9055d04..3fa0d98 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -28,6 +28,7 @@ struct sysfs_elem_attr {
 
 struct sysfs_elem_bin_attr {
 	struct bin_attribute	*bin_attr;
+	struct hlist_head	buffers;
 };
 
 /*
@@ -164,6 +165,7 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
  * bin.c
  */
 extern const struct file_operations bin_fops;
+void unmap_bin_file(struct sysfs_dirent *attr_sd);
 
 /*
  * symlink.c
-- 
1.6.2

