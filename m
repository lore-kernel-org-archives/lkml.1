Return-Path: <linux-kernel-owner+w=401wt.eu-S1162074AbXECOwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162074AbXECOwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162075AbXECOwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:52:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51777 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162074AbXECOwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:52:45 -0400
Date: Thu, 3 May 2007 17:52:43 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] revoke: rename to can_revoke_{file|vma}
Message-ID: <Pine.LNX.4.64.0705031752150.6505@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The inode_matches and need_revoke functions have confusing names so
rename them to can_revoke_file and can_revoke_vma respectively.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

Index: 26-mm/fs/revoke.c
===================================================================
--- 26-mm.orig/fs/revoke.c	2007-05-03 16:46:00.000000000 +0300
+++ 26-mm/fs/revoke.c	2007-05-03 17:09:52.000000000 +0300
@@ -75,10 +75,13 @@ 	filp->f_pos = 0;
 	return NULL;
 }
 
-static inline int inode_matches(struct file *file, struct inode *inode,
-				struct file *to_exclude)
+static inline bool can_revoke_file(struct file *file, struct inode *inode,
+				   struct file *to_exclude)
 {
-	return file && file != to_exclude && file->f_dentry->d_inode == inode;
+	if (!file || file == to_exclude)
+		return false;
+
+	return file->f_dentry->d_inode == inode;
 }
 
 static inline bool revoke_table_is_full(struct revoke_table *table)
@@ -116,7 +119,7 @@ 	for (fd = 0; fd < fdt->max_fds; fd++) {
 		struct inode *new_inode;
 
 		filp = fcheck_files(files, fd);
-		if (!inode_matches(filp, inode, to_exclude))
+		if (!can_revoke_file(filp, inode, to_exclude))
 			continue;
 
 		if (!filp->f_op->revoke) {
@@ -159,22 +162,18 @@ 	for (fd = 0; fd < fdt->max_fds; fd++) {
 	return err;
 }
 
-static inline bool need_revoke(struct vm_area_struct *vma,
-			       struct inode *inode,
-			       struct file *to_exclude)
+static inline bool can_revoke_vma(struct vm_area_struct *vma,
+				  struct inode *inode, struct file *to_exclude)
 {
 	struct file *file = vma->vm_file;
 
 	if (vma->vm_flags & VM_REVOKED)
 		return false;
 
-	if (!file)
-		return false;
-
-	if (file->f_path.dentry->d_inode != inode)
+	if (!file || file == to_exclude)
 		return false;
 
-	return file != to_exclude;
+	return file->f_path.dentry->d_inode == inode;
 }
 
 static int __revoke_break_cow(struct task_struct *tsk, struct inode *inode,
@@ -191,7 +190,7 @@ 	int err = 0;
 		if (vma->vm_flags & VM_SHARED)
 			continue;
 
-		if (!need_revoke(vma, inode, to_exclude))
+		if (!can_revoke_vma(vma, inode, to_exclude))
 			continue;
 
 		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
@@ -287,7 +286,7 @@ 	int err = 0;
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
-		if (!need_revoke(vma, mapping->host, to_exclude))
+		if (!can_revoke_vma(vma, mapping->host, to_exclude))
 			continue;
 
 		err = revoke_vma(vma, &details);
@@ -320,7 +319,7 @@ 	vma_prio_tree_foreach(vma, &iter, &mapp
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
-		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
+		if (likely(!can_revoke_vma(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
@@ -348,7 +347,7 @@ 	int try_again = 0;
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
 		int err;
 
-		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
+		if (likely(!can_revoke_vma(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
@@ -470,7 +469,7 @@ 		for (fd = 0; fd < fdt->max_fds; fd++) 
 			struct file *file;
 
 			file = fcheck_files(files, fd);
-			if (inode_matches(file, inode, to_exclude)) {
+			if (can_revoke_file(file, inode, to_exclude)) {
 				nr_fds += fdt->max_fds;
 				break;
 			}
