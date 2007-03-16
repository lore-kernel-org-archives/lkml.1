Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXCPI5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXCPI5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXCPI4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:56:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58091 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbXCPI4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:56:07 -0400
Date: Fri, 16 Mar 2007 10:56:02 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH] revoke: need ->mmap_sem to modify vma->vm_flags
Message-ID: <Pine.LNX.4.64.0703161055370.15253@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Nick Piggin, modifying vma->vm_flags without
->mmap_sem can corrupt the flags. This changes revoke_mapping() to
drop ->i_mmap_lock and rescanning vmas of the parent mm under
->mmap_sem.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |   86 +++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 26 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-16 09:31:22.000000000 +0200
+++ uml-2.6/fs/revoke.c	2007-03-16 10:54:18.000000000 +0200
@@ -159,6 +159,22 @@ 	for (fd = 0; fd < fdt->max_fds; fd++) {
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
@@ -167,13 +183,8 @@ static int revoke_vma(struct vm_area_str
 	start_addr = vma->vm_start;
 	end_addr = vma->vm_end;
 
-	/*
- 	 * Not holding ->mmap_sem here but we must watch out for page
- 	 * faults and after the shared mappings have been taken down
- 	 * and sys_mmap() trying to remap the revoked range.
-	 */
 	vma->vm_flags |= VM_REVOKED;
-	smp_mb();
+
   again:
 	restart_addr = zap_page_range(vma, start_addr, end_addr - start_addr,
 				      details);
@@ -195,48 +206,71 @@ 	return 0;
 	return -EINTR;
 }
 
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
+static void revoke_mm(struct mm_struct *mm, struct address_space *mapping,
+		      struct file *to_exclude)
+{
+	struct vm_area_struct *vma;
+	struct zap_details details;
+
+	details.i_mmap_lock = &mapping->i_mmap_lock;
+
+	spin_unlock(&mapping->i_mmap_lock);
+	down_write(&mm->mmap_sem);
+	spin_lock(&mapping->i_mmap_lock);
+  restart:
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		if (!(vma->vm_flags & VM_SHARED) || vma->vm_file == to_exclude)
+			continue;
+
+		if (revoke_vma(vma, &details))
+			goto restart;
+	}
+	up_write(&mm->mmap_sem);
+}
+
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
 static void revoke_mapping_tree(struct address_space *mapping,
-				struct file *to_exclude,
-				struct zap_details *details)
+				struct file *to_exclude)
 {
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 
-  restart:
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			if (revoke_vma(vma, details))
-				goto restart;
-		}
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		revoke_mm(vma->vm_mm, mapping, to_exclude);
 	}
 }
 
+/*
+ *	LOCKING: spin_lock(&mapping->i_mmap_lock)
+ */
 static void revoke_mapping_list(struct address_space *mapping,
-				struct file *to_exclude,
-				struct zap_details *details)
+				struct file *to_exclude)
 {
 	struct vm_area_struct *vma;
 
-  restart:
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
-		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			if (revoke_vma(vma, details))
-				goto restart;
-		}
+		if (likely(!need_revoke(vma, to_exclude)))
+			continue;
+
+		revoke_mm(vma->vm_mm, mapping, to_exclude);
 	}
 }
 
 static void revoke_mapping(struct address_space *mapping, struct file *to_exclude)
 {
-	struct zap_details details;
-
-	details.i_mmap_lock = &mapping->i_mmap_lock;
-
 	spin_lock(&mapping->i_mmap_lock);
 	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
-		revoke_mapping_tree(mapping, to_exclude, &details);
+		revoke_mapping_tree(mapping, to_exclude);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
-		revoke_mapping_list(mapping, to_exclude, &details);
+		revoke_mapping_list(mapping, to_exclude);
 	spin_unlock(&mapping->i_mmap_lock);
 }
 
