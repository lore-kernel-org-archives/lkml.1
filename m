Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZCVSf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZCVSf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZCVSfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 14:35:14 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55326 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZCVSfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 14:35:12 -0400
Date: Sun, 22 Mar 2009 18:33:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Eric W. Biederman" <ebiederm@aristanetworks.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH next] sysfs: fix some bin_vm_ops errors
Message-ID: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
on CONFIG_NUMA=y, just because that has a set_policy and get_policy.
They probably won't be called, and it's not a disaster if they don't
work on sysfs.  vm_ops->migrate?  I couldn't find any example.  Just
delete CONFIG_NUMA tests, easy enough to add stubs later if required.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I have only tested that X now starts up fine on the G5: I don't think
I've messed up the intent of your patch, but not tested it still works.

 fs/sysfs/bin.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- 2.6.29-rc8-next/fs/sysfs/bin.c	2009-03-20 12:41:45.000000000 +0000
+++ linux/fs/sysfs/bin.c	2009-03-21 18:01:26.000000000 +0000
@@ -241,9 +241,12 @@ static int bin_page_mkwrite(struct vm_ar
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
 
@@ -287,7 +290,6 @@ static int mmap(struct file *file, struc
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_bin_attr.bin_attr;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct vm_operations_struct *vm_ops;
 	int rc;
 
 	mutex_lock(&bb->mutex);
@@ -302,24 +304,20 @@ static int mmap(struct file *file, struc
 		goto out_put;
 
 	rc = attr->mmap(kobj, attr, vma);
-	vm_ops = vma->vm_ops;
-	vma->vm_ops = &bin_vm_ops;
 	if (rc)
 		goto out_put;
 
-	rc = -EINVAL;
-	if (bb->mmapped && bb->vm_ops != vma->vm_ops)
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
