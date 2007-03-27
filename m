Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbXC0HPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbXC0HPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbXC0HPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:15:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46574 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297AbXC0HO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:14:59 -0400
Date: Tue, 27 Mar 2007 10:14:58 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] revoke: break cow for private mappings
Message-ID: <Pine.LNX.4.64.0703271014100.793@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

We need to break COW for private mappings to make sure a process cannot
read new data after an inode has been revoked.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 73 insertions(+), 12 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-26 18:10:24.000000000 +0300
+++ uml-2.6/fs/revoke.c	2007-03-26 18:27:25.000000000 +0300
@@ -174,12 +174,58 @@ static inline bool need_revoke(struct vm
 	if (file->f_path.dentry->d_inode != inode)
 		return false;
 
-	if (!(vma->vm_flags & VM_SHARED))
-		return false;
-
 	return file != to_exclude;
 }
 
+static int __revoke_break_cow(struct task_struct *tsk, struct inode *inode,
+			      struct file *to_exclude)
+{
+	struct mm_struct *mm = tsk->mm;
+	struct vm_area_struct *vma;
+	int err = 0;
+
+	down_write(&mm->mmap_sem);
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		int ret;
+
+		if (vma->vm_flags & VM_SHARED)
+			continue;
+
+		if (!need_revoke(vma, inode, to_exclude))
+			continue;
+
+		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
+				     vma->vm_end-vma->vm_start, 1, 1, NULL,
+				     NULL);
+		if (ret < 0) {
+			err = ret;
+			break;
+		}
+	}
+	up_write(&mm->mmap_sem);
+	return err;
+}
+
+static int revoke_break_cow(struct revoke_table *table, struct inode *inode,
+			    struct file *to_exclude)
+{
+	unsigned long i;
+	int err = 0;
+
+	for (i = 0; i < table->end; i++) {
+		struct revokefs_inode_info *info;
+		struct file *this;
+
+		this = table->files[i];
+		info = revokefs_i(this->f_dentry->d_inode);
+
+		err = __revoke_break_cow(info->owner, inode, to_exclude);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 /*
  *	 LOCKING: down_write(&mm->mmap_sem)
  *	 	    -> spin_lock(&mapping->i_mmap_lock)
@@ -235,6 +281,9 @@ 	int err = 0;
 		goto out;
 	}
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
 		if (!need_revoke(vma, mapping->host, to_exclude))
 			continue;
 
@@ -261,6 +310,9 @@ 	int try_again = 0;
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
 		int err;
 
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
 		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
 			continue;
 
@@ -380,12 +432,9 @@ 	for (i = 0; i < table->end; i++) {
 		put_task_struct(info->owner);
 		info->owner = NULL;	/* To avoid restoring closed file. */
 		if (err)
-			goto failed;
+			goto out;
 	}
-	return 0;
-
-  failed:
-	restore_files(table);
+  out:
 	return err;
 }
 
@@ -527,10 +576,8 @@ 	int err = 0;
   exit_loop:
 	read_unlock(&tasklist_lock);
 
-	if (err) {
-		restore_files(table);
-		goto out_free_table;
-	}
+	if (err)
+		goto out_restore;
 
 	/*
 	 * Take down shared memory mappings.
@@ -538,13 +585,27 @@ 	int err = 0;
 	revoke_mapping(inode->i_mapping, to_exclude);
 
 	/*
+ 	 * Break COW for private mappings.
+ 	 */
+	err = revoke_break_cow(table, inode, to_exclude);
+	if (err)
+		goto out_restore;
+
+	/*
 	 * Now, revoke the files for good.
 	 */
 	err = revoke_files(table);
+	if (err)
+		goto out_restore;
+
   out_free_table:
 	free_revoke_table(table);
   out:
 	return err;
+
+  out_restore:
+	restore_files(table);
+	goto out_free_table;
 }
 
 asmlinkage long sys_revokeat(int dfd, const char __user * filename)
