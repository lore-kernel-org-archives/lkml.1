Return-Path: <linux-kernel-owner+w=401wt.eu-S637776AbXDSONr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637776AbXDSONr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637777AbXDSONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:13:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54560 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637776AbXDSONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:13:46 -0400
Date: Thu, 19 Apr 2007 17:13:45 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] revoke: mapping revocation
Message-ID: <Pine.LNX.4.64.0704191712400.25085@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Andrew Morton, if some process is partway through a
big page_cache_readahead() operation, a concurrent
invalidate_inode_pages2() is not enough to revoke inode pages. This
patch changes the revoke code to modify ->f_mapping to point to a
revoked mapping that will cause any future operations on the mapping
to fail with EIO.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c        |   29 ++++++++++++++++++++---------
 fs/revoked_inode.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    4 ++--
 include/linux/mm.h |    1 +
 mm/mmap.c          |   11 +++++++++++
 5 files changed, 73 insertions(+), 11 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-04-12 18:17:55.000000000 +0300
+++ uml-2.6/fs/revoke.c	2007-04-19 16:55:14.000000000 +0300
@@ -201,6 +201,10 @@ 		if (ret < 0) {
 			err = ret;
 			break;
 		}
+
+		unlink_file_vma(vma);
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
 	}
 	up_read(&mm->mmap_sem);
 	return err;
@@ -290,6 +294,10 @@ 	int err = 0;
 		err = revoke_vma(vma, &details);
 		if (err)
 			break;
+
+		__unlink_file_vma(vma);
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
 	}
 	up_write(&mm->mmap_sem);
   out:
@@ -317,12 +325,10 @@ 	vma_prio_tree_foreach(vma, &iter, &mapp
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
-		if (err == -EAGAIN) {
+		if (err == -EAGAIN)
 			try_again = 1;
-			continue;
-		}
-		if (err == -EINTR)
-			goto restart;
+
+		goto restart;
 	}
 	if (try_again) {
 		cond_resched();
@@ -418,9 +424,11 @@ 	int err = 0;
 	for (i = 0; i < table->end; i++) {
 		struct revokefs_inode_info *info;
 		struct file *this, *filp;
+		struct inode *inode;
 
 		this = table->files[i];
-		info = revokefs_i(this->f_dentry->d_inode);
+		inode = this->f_dentry->d_inode;
+		info = revokefs_i(inode);
 
 		/*
 		 * Increase count before attempting to close file as
@@ -428,7 +436,7 @@ 	for (i = 0; i < table->end; i++) {
 		 */
 		table->restore_start++;
 		filp = info->file;
-		err = filp->f_op->revoke(filp);
+		err = filp->f_op->revoke(filp, inode->i_mapping);
 		put_task_struct(info->owner);
 		info->owner = NULL;	/* To avoid restoring closed file. */
 		if (err)
@@ -633,8 +641,9 @@ asmlinkage long sys_frevoke(unsigned int
 	return err;
 }
 
-int generic_file_revoke(struct file *file)
+int generic_file_revoke(struct file *file, struct address_space *new_mapping)
 {
+	struct address_space *mapping = file->f_mapping;
 	int err;
 
 	/*
@@ -644,10 +653,12 @@ int generic_file_revoke(struct file *fil
 	if (err)
 		goto out;
 
+	file->f_mapping = new_mapping;
+
 	/*
 	 * Make pending reads fail.
 	 */
-	err = invalidate_inode_pages2(file->f_mapping);
+	err = invalidate_inode_pages2(mapping);
 
   out:
 	return err;
Index: uml-2.6/fs/revoked_inode.c
===================================================================
--- uml-2.6.orig/fs/revoked_inode.c	2007-04-12 18:17:55.000000000 +0300
+++ uml-2.6/fs/revoked_inode.c	2007-04-12 18:29:30.000000000 +0300
@@ -362,6 +362,43 @@ static struct inode_operations revoked_i
 	/* truncate_range returns void */
 };
 
+static int revoked_readpage(struct file *file, struct page *page)
+{
+	return -EIO;
+}
+
+static int revoked_writepage(struct page *page, struct writeback_control *wbc)
+{
+	return -EIO;
+}
+
+static int revoked_prepare_write(struct file *file, struct page *page,
+				 unsigned from, unsigned to)
+{
+	return -EIO;
+}
+
+static int revoked_commit_write(struct file *file, struct page *page,
+				unsigned from, unsigned to)
+{
+	return -EIO;
+}
+
+static ssize_t revoked_direct_IO(int rw, struct kiocb *iocb,
+				 const struct iovec *iov, loff_t offset,
+				 unsigned long nr_segs)
+{
+	return -EIO;
+}
+
+static const struct address_space_operations revoked_aops = {
+        .readpage       = revoked_readpage,
+        .writepage      = revoked_writepage,
+        .prepare_write  = revoked_prepare_write,
+        .commit_write   = revoked_commit_write,
+        .direct_IO      = revoked_direct_IO,
+};
+
 void make_revoked_inode(struct inode *inode, int mode)
 {
 	remove_inode_hash(inode);
@@ -375,4 +412,6 @@ void make_revoked_inode(struct inode *in
 		inode->i_fop = &revoked_special_file_ops;
 	else
 		inode->i_fop = &revoked_file_ops;
+
+	inode->i_mapping->a_ops = &revoked_aops;
 }
Index: uml-2.6/include/linux/fs.h
===================================================================
--- uml-2.6.orig/include/linux/fs.h	2007-04-12 18:17:55.000000000 +0300
+++ uml-2.6/include/linux/fs.h	2007-04-12 18:29:30.000000000 +0300
@@ -1100,7 +1100,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
-	int (*revoke)(struct file *);
+	int (*revoke)(struct file *, struct address_space *);
 };
 
 struct inode_operations {
@@ -1742,7 +1742,7 @@ extern long do_splice_direct(struct file
 
 /* fs/revoke.c */
 #ifdef CONFIG_MMU
-extern int generic_file_revoke(struct file *);
+extern int generic_file_revoke(struct file *, struct address_space *);
 #else
 #define generic_file_revoke NULL
 #endif
Index: uml-2.6/include/linux/mm.h
===================================================================
--- uml-2.6.orig/include/linux/mm.h	2007-04-12 16:57:33.000000000 +0300
+++ uml-2.6/include/linux/mm.h	2007-04-12 19:07:34.000000000 +0300
@@ -1022,6 +1022,7 @@ extern int split_vma(struct mm_struct *,
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void __vma_link_rb(struct mm_struct *, struct vm_area_struct *,
 	struct rb_node **, struct rb_node *);
+extern void __unlink_file_vma(struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
 	unsigned long addr, unsigned long len, pgoff_t pgoff);
Index: uml-2.6/mm/mmap.c
===================================================================
--- uml-2.6.orig/mm/mmap.c	2007-04-12 16:57:33.000000000 +0300
+++ uml-2.6/mm/mmap.c	2007-04-19 16:55:47.000000000 +0300
@@ -201,6 +201,17 @@ static void __remove_shared_vm_struct(st
 }
 
 /*
+ * Requires inode->i_mapping->i_mmap_lock
+ */
+void __unlink_file_vma(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+
+	__remove_shared_vm_struct(vma, file, mapping);
+}
+
+/*
  * Unlink a file-based vm structure from its prio_tree, to hide
  * vma from rmap and vmtruncate before freeing its page tables.
  */
