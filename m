Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbZCYAu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbZCYAu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbZCYAaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:46 -0400
Received: from kroah.org ([198.145.64.141]:54212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756910AbZCYAab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hugh@veritas.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/61] sysfs: fix some bin_vm_ops errors
Date: Tue, 24 Mar 2009 17:27:01 -0700
Message-Id: <1237940825-22904-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

Commit 86c9508eb1c0ce5aa07b5cf1d36b60c54efc3d7a
"sysfs: don't block indefinitely for unmapped files" in linux-next
crashes the PowerMac G5 when X starts up.  It's caught out by the way
powerpc's pci_mmap of legacy_mem uses shmem_zero_setup(), substituting
a new vma->vm_file whose private_data no longer points to the bin_buffer
(substitution done because some versions of X crash if that mmap fails).

The fix to this is straightforward: the original vm_file is fput() in
that case, so this mmap won't block sysfs at all, so just don't switch
over to bin_vm_ops if vm_file has changed.

But more fixes made before realizing that was the problem:-

It should not be an error if bin_page_mkwrite() finds no underlying
page_mkwrite().

Check that a file already mmap'ed has the same underlying vm_ops
_before_ pointing vma->vm_ops at bin_vm_ops.

If the file being mmap'ed is a shmem/tmpfs file, don't fail the mmap
on CONFIG_NUMA=y, just because that has a set_policy and get_policy:
provide bin_set_policy, bin_get_policy and bin_migrate.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Eric Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 96cc2bf..07703d3 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -241,9 +241,12 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->page_mkwrite)
+	if (!bb->vm_ops)
 		return -EINVAL;
 
+	if (!bb->vm_ops->page_mkwrite)
+		return 0;
+
 	if (!sysfs_get_active_two(attr_sd))
 		return -EINVAL;
 
@@ -273,12 +276,78 @@ static int bin_access(struct vm_area_struct *vma, unsigned long addr,
 	return ret;
 }
 
+#ifdef CONFIG_NUMA
+static int bin_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	int ret;
+
+	if (!bb->vm_ops || !bb->vm_ops->set_policy)
+		return 0;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return -EINVAL;
+
+	ret = bb->vm_ops->set_policy(vma, new);
+
+	sysfs_put_active_two(attr_sd);
+	return ret;
+}
+
+static struct mempolicy *bin_get_policy(struct vm_area_struct *vma,
+					unsigned long addr)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	struct mempolicy *pol;
+
+	if (!bb->vm_ops || !bb->vm_ops->get_policy)
+		return vma->vm_policy;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return vma->vm_policy;
+
+	pol = bb->vm_ops->get_policy(vma, addr);
+
+	sysfs_put_active_two(attr_sd);
+	return pol;
+}
+
+static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
+			const nodemask_t *to, unsigned long flags)
+{
+	struct file *file = vma->vm_file;
+	struct bin_buffer *bb = file->private_data;
+	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
+	int ret;
+
+	if (!bb->vm_ops || !bb->vm_ops->migrate)
+		return 0;
+
+	if (!sysfs_get_active_two(attr_sd))
+		return 0;
+
+	ret = bb->vm_ops->migrate(vma, from, to, flags);
+
+	sysfs_put_active_two(attr_sd);
+	return ret;
+}
+#endif
+
 static struct vm_operations_struct bin_vm_ops = {
 	.open		= bin_vma_open,
 	.close		= bin_vma_close,
 	.fault		= bin_fault,
 	.page_mkwrite	= bin_page_mkwrite,
 	.access		= bin_access,
+#ifdef CONFIG_NUMA
+	.set_policy	= bin_set_policy,
+	.get_policy	= bin_get_policy,
+	.migrate	= bin_migrate,
+#endif
 };
 
 static int mmap(struct file *file, struct vm_area_struct *vma)
@@ -287,7 +356,6 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct vm_operations_struct *vm_ops;
 	int rc;
 
 	mutex_lock(&bb->mutex);
@@ -302,24 +370,25 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 		goto out_put;
 
 	rc = attr->mmap(kobj, attr, vma);
-	vm_ops = vma->vm_ops;
-	vma->vm_ops = &bin_vm_ops;
 	if (rc)
 		goto out_put;
 
-	rc = -EINVAL;
-	if (bb->mmapped && bb->vm_ops != vma->vm_ops)
+	/*
+	 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()
+	 * to satisfy versions of X which crash if the mmap fails: that
+	 * substitutes a new vm_file, and we don't then want bin_vm_ops.
+	 */
+	if (vma->vm_file != file)
 		goto out_put;
 
-#ifdef CONFIG_NUMA
 	rc = -EINVAL;
-	if (vm_ops && ((vm_ops->set_policy || vm_ops->get_policy || vm_ops->migrate)))
+	if (bb->mmapped && bb->vm_ops != vma->vm_ops)
 		goto out_put;
-#endif
 
 	rc = 0;
 	bb->mmapped = 1;
-	bb->vm_ops = vm_ops;
+	bb->vm_ops = vma->vm_ops;
+	vma->vm_ops = &bin_vm_ops;
 out_put:
 	sysfs_put_active_two(attr_sd);
 out_unlock:
-- 
1.6.2

