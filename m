Return-Path: <linux-kernel-owner+w=401wt.eu-S1945996AbXBVMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945996AbXBVMlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945999AbXBVMlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:41:19 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52967 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945996AbXBVMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:41:18 -0500
Date: Thu, 22 Feb 2007 14:41:16 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, jsipek@fsl.cs.sunysb.edu
Subject: [PATCH 2/2] unionfs: fix slab abuses with krealloc
Message-ID: <Pine.LNX.4.64.0702221440230.14523@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This changes unionfs to use krealloc() for reallocating memory so that
we don't need to play tricks with slab internals.

Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/unionfs/copyup.c |   35 +++++++++++++----------------------
 fs/unionfs/lookup.c |   33 +++++++++++++--------------------
 2 files changed, 26 insertions(+), 42 deletions(-)

Index: 2.6/fs/unionfs/copyup.c
===================================================================
--- 2.6.orig/fs/unionfs/copyup.c	2007-02-22 11:33:52.000000000 +0200
+++ 2.6/fs/unionfs/copyup.c	2007-02-22 11:33:53.000000000 +0200
@@ -603,23 +603,16 @@
 	const char *childname;
 	unsigned int childnamelen;
 
-	int old_kmalloc_size;
-	int kmalloc_size;
-	int num_dentry;
+	int nr_dentry;
 	int count;
 
 	int old_bstart;
 	int old_bend;
 	struct dentry **path = NULL;
-	struct dentry **tmp_path;
 	struct super_block *sb;
 
 	verify_locked(dentry);
 
-	/* There is no sense allocating any less than the minimum. */
-	kmalloc_size = malloc_sizes[0].cs_size;
-	num_dentry = kmalloc_size / sizeof(struct dentry *);
-
 	if ((err = is_robranch_super(dir->i_sb, bindex))) {
 		hidden_dentry = ERR_PTR(err);
 		goto out;
@@ -629,7 +622,10 @@
 	old_bend = dbend(dentry);
 
 	hidden_dentry = ERR_PTR(-ENOMEM);
-	path = kzalloc(kmalloc_size, GFP_KERNEL);
+
+	/* There is no sense allocating any less than the minimum. */
+	nr_dentry = 1;
+	path = kmalloc(nr_dentry * sizeof(struct dentry *), GFP_KERNEL);
 	if (!path)
 		goto out;
 
@@ -655,26 +651,21 @@
 		/* find out the hidden_parent_dentry in the given branch */
 		hidden_parent_dentry = unionfs_lower_dentry_idx(parent_dentry, bindex);
 
-		/* store the child dentry */
-		path[count++] = child_dentry;
-
 		/* grow path table */
-		if (count == num_dentry) {
-			old_kmalloc_size = kmalloc_size;
-			kmalloc_size *= 2;
-			num_dentry = kmalloc_size / sizeof(struct dentry *);
+		if (count == nr_dentry) {
+			void *p;
 
-			tmp_path = kzalloc(kmalloc_size, GFP_KERNEL);
-			if (!tmp_path) {
+			nr_dentry *= 2;
+			p = krealloc(path, nr_dentry * sizeof(struct dentry *), GFP_KERNEL);
+			if (!p) {
 				hidden_dentry = ERR_PTR(-ENOMEM);
 				goto out;
 			}
-			memcpy(tmp_path, path, old_kmalloc_size);
-			kfree(path);
-			path = tmp_path;
-			tmp_path = NULL;
+			path = p;
 		}
 
+		/* store the child dentry */
+		path[count++] = child_dentry;
 	} while (!hidden_parent_dentry);
 	count--;
 
Index: 2.6/fs/unionfs/lookup.c
===================================================================
--- 2.6.orig/fs/unionfs/lookup.c	2007-02-22 11:33:52.000000000 +0200
+++ 2.6/fs/unionfs/lookup.c	2007-02-22 11:33:53.000000000 +0200
@@ -428,9 +428,8 @@
 /* allocate new dentry private data, free old one if necessary */
 int new_dentry_private_data(struct dentry *dentry)
 {
-	int newsize;
-	int oldsize = 0;
 	struct unionfs_dentry_info *info = UNIONFS_D(dentry);
+	int new_size, size;
 
 	spin_lock(&dentry->d_lock);
 	if (!info) {
@@ -445,8 +444,9 @@
 		mutex_lock(&info->lock);
 
 		info->lower_paths = NULL;
+		size = 0;
 	} else
-		oldsize = sizeof(struct path) * info->bcount;
+		size = sizeof(struct path) * info->bcount;
 
 	info->bstart = -1;
 	info->bend = -1;
@@ -454,28 +454,21 @@
 	info->bcount = sbmax(dentry->d_sb);
 	atomic_set(&info->generation,
 		   atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
-	newsize = sizeof(struct path) * sbmax(dentry->d_sb);
+
+	new_size = sizeof(struct path) * sbmax(dentry->d_sb);
 
 	/* Don't reallocate when we already have enough space. */
-	/* It would be ideal if we could actually use the slab macros to
-	 * determine what our object sizes is, but those are not exported.
-	 */
-	if (oldsize) {
-		int minsize = malloc_sizes[0].cs_size;
-
-		if (!newsize || ((oldsize < newsize) && (newsize > minsize))) {
-			kfree(info->lower_paths);
-			info->lower_paths = NULL;
-		}
-	}
+	if (new_size > size) {
+		void *p;
 
-	if (!info->lower_paths && newsize) {
-		info->lower_paths = kmalloc(newsize, GFP_ATOMIC);
-		if (!info->lower_paths)
+		p = krealloc(info->lower_paths, new_size, GFP_ATOMIC);
+		if (!p)
 			goto out_free;
-	}
 
-	memset(info->lower_paths, 0, (oldsize > newsize ? oldsize : newsize));
+		info->lower_paths = p;
+		size = new_size;
+	}
+	memset(info->lower_paths, 0, size);
 
 	spin_unlock(&dentry->d_lock);
 	return 0;
