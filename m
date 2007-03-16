Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbXCPHRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbXCPHRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXCPHRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:17:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41118 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXCPHRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:17:38 -0400
Date: Fri, 16 Mar 2007 09:17:35 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] revoke: fix shared mapping revoke
Message-ID: <Pine.LNX.4.64.0703160917070.14651@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> This all looks very strange.  If the calling process expires its timeslice,
> the entire system call fails?

This changes revoke_mapping() to restart after cond_resched() to fix an
obvious goof made by me.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-16 09:02:16.000000000 +0200
+++ uml-2.6/fs/revoke.c	2007-03-16 09:11:46.000000000 +0200
@@ -194,34 +194,49 @@ 	return 0;
 	return -EINTR;
 }
 
-static int revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+static void revoke_mapping_tree(struct address_space *mapping,
+				struct file *to_exclude,
+				struct zap_details *details)
 {
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
-	struct zap_details details;
-	int err = 0;
-
-	details.i_mmap_lock = &mapping->i_mmap_lock;
 
-	spin_lock(&mapping->i_mmap_lock);
+  restart:
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
 		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+			if (revoke_vma(vma, details))
+				goto restart;
 		}
 	}
+}
 
+static void revoke_mapping_list(struct address_space *mapping,
+				struct file *to_exclude,
+				struct zap_details *details)
+{
+	struct vm_area_struct *vma;
+
+  restart:
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
 		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+			if (revoke_vma(vma, details))
+				goto restart;
 		}
 	}
-  out:
+}
+
+static void revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+{
+	struct zap_details details;
+
+	details.i_mmap_lock = &mapping->i_mmap_lock;
+
+	spin_lock(&mapping->i_mmap_lock);
+	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
+		revoke_mapping_tree(mapping, to_exclude, &details);
+	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
+		revoke_mapping_list(mapping, to_exclude, &details);
 	spin_unlock(&mapping->i_mmap_lock);
-	return err;
 }
 
 static void restore_file(struct revokefs_inode_info *info)
@@ -441,11 +456,7 @@ 	int err = 0;
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
