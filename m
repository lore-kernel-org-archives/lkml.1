Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXCPKHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXCPKHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933579AbXCPKHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:07:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60544 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575AbXCPKHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:07:12 -0400
Date: Fri, 16 Mar 2007 12:07:09 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] revoke: fix shared mapping revoke
Message-ID: <Pine.LNX.4.64.0703161205050.18621@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Nick Piggin, modifying vma->vm_flags without
->mmap_sem can corrupt the flags. This changes revoke_mapping() to use 
down_write_trylock() to acquire ->mmap_sem and then rescan vmas of the 
parent mm.

Also make sure we restart scanning in revoke_mm() if zap_page_range()
did not finish within our process timeslice.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |  128 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 105 insertions(+), 23 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-16 11:37:52.000000000 +0200
+++ uml-2.6/fs/revoke.c	2007-03-16 12:02:10.000000000 +0200
@@ -158,6 +158,22 @@ 	for (fd = 0; fd < fdt->max_fds; fd++) {
 	return err;
 }
 
+static inline bool need_revoke(struct vm_area_struct *vma,
+			       struct file *to_exclude)
+{
+	if (vma->vm_flags & VM_REVOKED)
+		return false;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return false;
+
+	return vma->vm_file != to_exclude;
+}
+
+/*
+ *	 LOCKING: down_write(&mm->mmap_sem)
+ *	 	    -> spin_lock(&mapping->i_mmap_lock)
+ */
 static int revoke_vma(struct vm_area_struct *vma, struct zap_details *details)
 {
 	unsigned long restart_addr, start_addr, end_addr;
@@ -166,11 +182,6 @@ static int revoke_vma(struct vm_area_str
 	start_addr = vma->vm_start;
 	end_addr = vma->vm_end;
 
-	/*
- 	 * Not holding ->mmap_sem here.
-	 */
-	vma->vm_flags |= VM_REVOKED;
-	smp_mb();
   again:
 	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
 				      details);
@@ -183,6 +194,7 @@ static int revoke_vma(struct vm_area_str
 		start_addr = restart_addr;
 		goto again;
 	}
+	vma->vm_flags |= VM_REVOKED;
 	return 0;
 
   out_need_break:
@@ -192,34 +204,108 @@ 	return 0;
 	return -EINTR;
 }
 
-static int revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static int revoke_mm(struct mm_struct *mm, struct address_space *mapping,
+		     struct file *to_exclude)
 {
 	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
 	struct zap_details details;
 	int err = 0;
 
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
-	spin_lock(&mapping->i_mmap_lock);
+	/*
+ 	 * If ->mmap_sem is under contention, we continue scanning other
+ 	 * mms and try again later.
+ 	 */
+	if (!down_write_trylock(&mm->mmap_sem)) {
+		err = -EAGAIN;
+		goto out;
+	}
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		if (!need_revoke(vma, to_exclude))
+			continue;
+
+		err = revoke_vma(vma, &details);
+		if (err)
+			break;
+	}
+	up_write(&mm->mmap_sem);
+  out:
+	return err;
+}
+
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mapping_tree(struct address_space *mapping,
+				struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	struct prio_tree_iter iter;
+	int try_again = 0;
+
+  restart:
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+		int err;
+
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		if (err == -EAGAIN) {
+			try_again = 1;
+			continue;
 		}
+		if (err == -EINTR)
+			goto restart;
+	}
+	if (try_again) {
+		cond_resched();
+		goto restart;
 	}
+}
 
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mapping_list(struct address_space *mapping,
+				struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	int try_again = 0;
+
+  restart:
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+		int err;
+
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		if (err == -EAGAIN) {
+			try_again = 1;
+			continue;
 		}
+		if (err == -EINTR)
+			goto restart;
 	}
-  out:
+	if (try_again) {
+		cond_resched();
+		goto restart;
+	}
+}
+
+static void revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+{
+	spin_lock(&mapping->i_mmap_lock);
+	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
+		revoke_mapping_tree(mapping, to_exclude);
+	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
+		revoke_mapping_list(mapping, to_exclude);
 	spin_unlock(&mapping->i_mmap_lock);
-	return err;
 }
 
 static void restore_file(struct revokefs_inode_info *info)
@@ -439,11 +525,7 @@ 	int err = 0;
 	/*
 	 * Take down shared memory mappings.
 	 */
-	err = revoke_mapping(inode->i_mapping, to_exclude);
-	if (err) {
-		restore_files(table);
-		goto out_free_table;
-	}
+	revoke_mapping(inode->i_mapping, to_exclude);
 
 	/*
 	 * Now, revoke the files for good.
