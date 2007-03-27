Return-Path: <linux-kernel-owner+w=401wt.eu-S965289AbXC0HOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbXC0HOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXC0HOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:14:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46574 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289AbXC0HOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:14:10 -0400
Date: Tue, 27 Mar 2007 10:14:09 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] revoke: only revoke mappings for the given inode
Message-ID: <Pine.LNX.4.64.0703271013330.793@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This fixes a bug that was introduced when we switched to rescanning all the
vmas of a mm.  We need to check that the vma host file points to the same
inode we are revoking; otherwise we end up revoking all shared mappings.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-26 17:43:57.000000000 +0300
+++ uml-2.6/fs/revoke.c	2007-03-26 17:48:40.000000000 +0300
@@ -160,15 +160,24 @@ 	for (fd = 0; fd < fdt->max_fds; fd++) {
 }
 
 static inline bool need_revoke(struct vm_area_struct *vma,
+			       struct inode *inode,
 			       struct file *to_exclude)
 {
+	struct file *file = vma->vm_file;
+
 	if (vma->vm_flags & VM_REVOKED)
 		return false;
 
+	if (!file)
+		return false;
+
+	if (file->f_path.dentry->d_inode != inode)
+		return false;
+
 	if (!(vma->vm_flags & VM_SHARED))
 		return false;
 
-	return vma->vm_file != to_exclude;
+	return file != to_exclude;
 }
 
 /*
@@ -226,7 +235,7 @@ 	int err = 0;
 		goto out;
 	}
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
-		if (!need_revoke(vma, to_exclude))
+		if (!need_revoke(vma, mapping->host, to_exclude))
 			continue;
 
 		err = revoke_vma(vma, &details);
@@ -252,7 +261,7 @@ 	int try_again = 0;
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
 		int err;
 
-		if (likely(!need_revoke(vma, to_exclude)))
+		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
@@ -282,7 +291,7 @@ 	int try_again = 0;
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
 		int err;
 
-		if (likely(!need_revoke(vma, to_exclude)))
+		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
 			continue;
 
 		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
