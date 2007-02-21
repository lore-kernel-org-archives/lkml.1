Return-Path: <linux-kernel-owner+w=401wt.eu-S1161115AbXBUIHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115AbXBUIHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXBUIHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:07:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33849 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161115AbXBUIHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:07:51 -0500
Date: Wed, 21 Feb 2007 10:07:50 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: jsipek@fsl.cs.sunysb.edu, linux-kernel@vger.kernel.org,
       unionfs@filesystems.org, bunk@stusta.de, hooanon05@yahoo.co.jp,
       clameter@sgi.com
Subject: [PATCH 3/3] unionfs: fix up slab abuses
Message-ID: <Pine.LNX.4.64.0702211006530.8172@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This changes unionfs to query the actual buffer size with ksize()
instead of playing tricks with malloc_sizes.  Also converts an
open-coded reallocation to use the new krealloc API.

Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/unionfs/copyup.c |   26 +++++++++-----------------
 fs/unionfs/lookup.c |   37 +++++++++++++------------------------
 2 files changed, 22 insertions(+), 41 deletions(-)

Index: 2.6/fs/unionfs/copyup.c
===================================================================
--- 2.6.orig/fs/unionfs/copyup.c	2007-02-21 09:47:02.000000000 +0200
+++ 2.6/fs/unionfs/copyup.c	2007-02-21 09:47:51.000000000 +0200
@@ -603,7 +603,6 @@
 	const char *childname;
 	unsigned int childnamelen;
 
-	int old_kmalloc_size;
 	int kmalloc_size;
 	int num_dentry;
 	int count;
@@ -611,15 +610,10 @@
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
@@ -629,10 +623,14 @@
 	old_bend = dbend(dentry);
 
 	hidden_dentry = ERR_PTR(-ENOMEM);
-	path = kzalloc(kmalloc_size, GFP_KERNEL);
+	/* There is no sense allocating any less than the minimum. */
+	path = kzalloc(sizeof(struct dentry *), GFP_KERNEL);
 	if (!path)
 		goto out;
 
+	kmalloc_size = ksize(path);
+	num_dentry = kmalloc_size / sizeof(struct dentry *);
+
 	/* assume the negative dentry of unionfs as the parent dentry */
 	parent_dentry = dentry;
 
@@ -660,19 +658,13 @@
 
 		/* grow path table */
 		if (count == num_dentry) {
-			old_kmalloc_size = kmalloc_size;
-			kmalloc_size *= 2;
-			num_dentry = kmalloc_size / sizeof(struct dentry *);
-
-			tmp_path = kzalloc(kmalloc_size, GFP_KERNEL);
-			if (!tmp_path) {
+			path = krealloc(path, kmalloc_size * 2, GFP_KERNEL);
+			if (!path) {
 				hidden_dentry = ERR_PTR(-ENOMEM);
 				goto out;
 			}
-			memcpy(tmp_path, path, old_kmalloc_size);
-			kfree(path);
-			path = tmp_path;
-			tmp_path = NULL;
+			kmalloc_size = ksize(path);
+			num_dentry = kmalloc_size / sizeof(struct dentry *);
 		}
 
 	} while (!hidden_parent_dentry);
Index: 2.6/fs/unionfs/lookup.c
===================================================================
--- 2.6.orig/fs/unionfs/lookup.c	2007-02-21 09:48:09.000000000 +0200
+++ 2.6/fs/unionfs/lookup.c	2007-02-21 09:51:11.000000000 +0200
@@ -428,9 +428,9 @@
 /* allocate new dentry private data, free old one if necessary */
 int new_dentry_private_data(struct dentry *dentry)
 {
-	int newsize;
-	int oldsize = 0;
 	struct unionfs_dentry_info *info = UNIONFS_D(dentry);
+	int new_size;
+	int size;
 
 	spin_lock(&dentry->d_lock);
 	if (!info) {
@@ -445,8 +445,7 @@
 		mutex_lock(&info->lock);
 
 		info->lower_paths = NULL;
-	} else
-		oldsize = sizeof(struct path) * info->bcount;
+	}
 
 	info->bstart = -1;
 	info->bend = -1;
@@ -454,35 +453,25 @@
 	info->bcount = sbmax(dentry->d_sb);
 	atomic_set(&info->generation,
 		   atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
-	newsize = sizeof(struct path) * sbmax(dentry->d_sb);
+
+	new_size = sizeof(struct path) * sbmax(dentry->d_sb);
+	size = ksize(info->lower_paths);
 
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
+		kfree(info->lower_paths);
 
-	if (!info->lower_paths && newsize) {
-		info->lower_paths = kmalloc(newsize, GFP_ATOMIC);
+		info->lower_paths = kmalloc(new_size, GFP_ATOMIC);
 		if (!info->lower_paths)
-			goto out_free;
-	}
+			goto out;
 
-	memset(info->lower_paths, 0, (oldsize > newsize ? oldsize : newsize));
+		size = new_size;
+	}
+	memset(info->lower_paths, 0, size);
 
 	spin_unlock(&dentry->d_lock);
 	return 0;
 
-out_free:
-	kfree(info->lower_paths);
-
 out:
 	free_dentry_private_data(info);
 	dentry->d_fsdata = NULL;
