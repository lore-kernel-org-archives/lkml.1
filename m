Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbXIZDbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbXIZDbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbXIZDat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:30:49 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35284 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbXIZDar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:30:47 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 23/25] Unionfs: add un/likely conditionals on unlink ops
Date: Tue, 25 Sep 2007 23:10:02 -0400
Message-Id: <1190776214844-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/unlink.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 3924f7f..33d08d9 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -26,13 +26,13 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 	int bindex;
 	int err = 0;
 
-	if ((err = unionfs_partial_lookup(dentry)))
+	if (unlikely((err = unionfs_partial_lookup(dentry))))
 		goto out;
 
 	bindex = dbstart(dentry);
 
 	lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-	if (!lower_dentry)
+	if (unlikely(!lower_dentry))
 		goto out;
 
 	lower_dir_dentry = lock_parent(lower_dentry);
@@ -42,13 +42,13 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 	if (!(err = is_robranch_super(dentry->d_sb, bindex)))
 		err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
 	/* if vfs_unlink succeeded, update our inode's times */
-	if (!err)
+	if (likely(!err))
 		unionfs_copy_attr_times(dentry->d_inode);
 	dput(lower_dentry);
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	unlock_dir(lower_dir_dentry);
 
-	if (err && !IS_COPYUP_ERR(err))
+	if (unlikely(err && !IS_COPYUP_ERR(err)))
 		goto out;
 
 	if (err) {
@@ -62,11 +62,11 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 		err = create_whiteout(dentry, dbstart(dentry));
 
 out:
-	if (!err)
+	if (likely(!err))
 		dentry->d_inode->i_nlink--;
 
 	/* We don't want to leave negative leftover dentries for revalidate. */
-	if (!err && (dbopaque(dentry) != -1))
+	if (likely(!err && (dbopaque(dentry) != -1)))
 		update_bstart(dentry);
 
 	return err;
@@ -79,7 +79,7 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -87,7 +87,7 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	err = unionfs_unlink_whiteout(dir, dentry);
 	/* call d_drop so the system "forgets" about us */
-	if (!err) {
+	if (likely(!err)) {
 		if (!S_ISDIR(dentry->d_inode->i_mode))
 			unionfs_postcopyup_release(dentry);
 		d_drop(dentry);
@@ -99,7 +99,7 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 
 out:
-	if (!err) {
+	if (likely(!err)) {
 		unionfs_check_dentry(dentry);
 		unionfs_check_inode(dir);
 	}
@@ -117,7 +117,7 @@ static int unionfs_rmdir_first(struct inode *dir, struct dentry *dentry,
 
 	/* Here we need to remove whiteout entries. */
 	err = delete_whiteouts(dentry, dbstart(dentry), namelist);
-	if (err)
+	if (unlikely(err))
 		goto out;
 
 	lower_dentry = unionfs_lower_dentry(dentry);
@@ -135,7 +135,7 @@ static int unionfs_rmdir_first(struct inode *dir, struct dentry *dentry,
 	dentry->d_inode->i_nlink = unionfs_get_nlinks(dentry->d_inode);
 
 out:
-	if (lower_dir_dentry)
+	if (likely(lower_dir_dentry))
 		unlock_dir(lower_dir_dentry);
 	return err;
 }
@@ -148,7 +148,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
 
-	if (!__unionfs_d_revalidate_chain(dentry, NULL, false)) {
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
 		err = -ESTALE;
 		goto out;
 	}
@@ -156,7 +156,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	/* check if this unionfs directory is empty or not */
 	err = check_empty(dentry, &namelist);
-	if (err)
+	if (unlikely(err))
 		goto out;
 
 	err = unionfs_rmdir_first(dir, dentry, namelist);
@@ -170,7 +170,7 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 			goto out;
 
 		/* exit if the error returned was NOT -EROFS */
-		if (!IS_COPYUP_ERR(err))
+		if (unlikely(!IS_COPYUP_ERR(err)))
 			goto out;
 
 		new_err = create_whiteout(dentry, dbstart(dentry) - 1);
@@ -180,10 +180,10 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 out:
 	/* call d_drop so the system "forgets" about us */
-	if (!err)
+	if (likely(!err))
 		d_drop(dentry);
 
-	if (namelist)
+	if (likely(namelist))
 		free_rdstate(namelist);
 
 	unionfs_unlock_dentry(dentry);
-- 
1.5.2.2

