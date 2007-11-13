Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbXKMKLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbXKMKLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXKMKKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:10:53 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50686 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbXKMKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:10:51 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 1/9] Unionfs: flush and release updates
Date: Tue, 13 Nov 2007 05:10:20 -0500
Message-Id: <11949486282427-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
References: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the totalopens counter which was intended to reduce unnecessary
processing of d_deleted dentries.  Move that processing from file_release to
flush.

Cc: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   30 +++++++++++-------------------
 fs/unionfs/union.h      |    2 --
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 50e5775..ba84529 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -551,9 +551,6 @@ int unionfs_open(struct inode *inode, struct file *file)
 	bstart = fbstart(file) = dbstart(dentry);
 	bend = fbend(file) = dbend(dentry);
 
-	/* increment, so that we can flush appropriately */
-	atomic_inc(&UNIONFS_I(dentry->d_inode)->totalopens);
-
 	/*
 	 * open all directories and make the unionfs file struct point to
 	 * these lower file structs
@@ -565,7 +562,6 @@ int unionfs_open(struct inode *inode, struct file *file)
 
 	/* freeing the allocated resources, and fput the opened files */
 	if (err) {
-		atomic_dec(&UNIONFS_I(dentry->d_inode)->totalopens);
 		for (bindex = bstart; bindex <= bend; bindex++) {
 			lower_file = unionfs_lower_file_idx(file, bindex);
 			if (!lower_file)
@@ -606,6 +602,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	struct unionfs_file_info *fileinfo;
 	struct unionfs_inode_info *inodeinfo;
 	struct super_block *sb = inode->i_sb;
+	struct dentry *dentry = file->f_path.dentry;
 	int bindex, bstart, bend;
 	int fgen, err = 0;
 
@@ -628,6 +625,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	bstart = fbstart(file);
 	bend = fbend(file);
 
+	unionfs_lock_dentry(dentry);
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		lower_file = unionfs_lower_file_idx(file, bindex);
 
@@ -635,7 +633,15 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 			fput(lower_file);
 			branchput(sb, bindex);
 		}
+
+		/* if there are no more refs to the dentry, dput it */
+		if (d_deleted(dentry)) {
+			dput(unionfs_lower_dentry_idx(dentry, bindex));
+			unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
+		}
 	}
+	unionfs_unlock_dentry(dentry);
+
 	kfree(fileinfo->lower_files);
 	kfree(fileinfo->saved_branch_ids);
 
@@ -799,11 +805,6 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 		goto out;
 	unionfs_check_file(file);
 
-	if (!atomic_dec_and_test(&UNIONFS_I(dentry->d_inode)->totalopens))
-		goto out;
-
-	unionfs_lock_dentry(dentry);
-
 	bstart = fbstart(file);
 	bend = fbend(file);
 	for (bindex = bstart; bindex <= bend; bindex++) {
@@ -813,14 +814,7 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 		    lower_file->f_op->flush) {
 			err = lower_file->f_op->flush(lower_file, id);
 			if (err)
-				goto out_lock;
-
-			/* if there are no more refs to the dentry, dput it */
-			if (d_deleted(dentry)) {
-				dput(unionfs_lower_dentry_idx(dentry, bindex));
-				unionfs_set_lower_dentry_idx(dentry, bindex,
-							     NULL);
-			}
+				goto out;
 		}
 
 	}
@@ -830,8 +824,6 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 	/* parent time could have changed too (async) */
 	unionfs_copy_attr_times(dentry->d_parent->d_inode);
 
-out_lock:
-	unionfs_unlock_dentry(dentry);
 out:
 	unionfs_read_unlock(dentry->d_sb);
 	unionfs_check_file(file);
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 0476f97..09b9ac9 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -102,8 +102,6 @@ struct unionfs_inode_info {
 
 	/* The lower inodes */
 	struct inode **lower_inodes;
-	/* to keep track of reads/writes for unlinks before closes */
-	atomic_t totalopens;
 
 	struct inode vfs_inode;
 };
-- 
1.5.2.2

