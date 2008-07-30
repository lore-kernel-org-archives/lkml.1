Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYG3Crv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYG3Crv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbYG3Col
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:41 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46295 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbYG3Coh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:37 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/19] Unionfs: move a rename helper closer to rename code
Date: Tue, 29 Jul 2008 22:43:33 -0400
Message-Id: <12173858334145-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/rename.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/unionfs/subr.c   |   42 ------------------------------------------
 fs/unionfs/union.h  |    3 ---
 3 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index fe8d877..5b3f1a3 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -18,6 +18,48 @@
 
 #include "union.h"
 
+/*
+ * This is a helper function for rename, used when rename ends up with hosed
+ * over dentries and we need to revert.
+ */
+static int unionfs_refresh_lower_dentry(struct dentry *dentry, int bindex)
+{
+	struct dentry *lower_dentry;
+	struct dentry *lower_parent;
+	int err = 0;
+
+	verify_locked(dentry);
+
+	unionfs_lock_dentry(dentry->d_parent, UNIONFS_DMUTEX_CHILD);
+	lower_parent = unionfs_lower_dentry_idx(dentry->d_parent, bindex);
+	unionfs_unlock_dentry(dentry->d_parent);
+
+	BUG_ON(!S_ISDIR(lower_parent->d_inode->i_mode));
+
+	lower_dentry = lookup_one_len(dentry->d_name.name, lower_parent,
+				      dentry->d_name.len);
+	if (IS_ERR(lower_dentry)) {
+		err = PTR_ERR(lower_dentry);
+		goto out;
+	}
+
+	dput(unionfs_lower_dentry_idx(dentry, bindex));
+	iput(unionfs_lower_inode_idx(dentry->d_inode, bindex));
+	unionfs_set_lower_inode_idx(dentry->d_inode, bindex, NULL);
+
+	if (!lower_dentry->d_inode) {
+		dput(lower_dentry);
+		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
+	} else {
+		unionfs_set_lower_dentry_idx(dentry, bindex, lower_dentry);
+		unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
+					    igrab(lower_dentry->d_inode));
+	}
+
+out:
+	return err;
+}
+
 static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			    struct inode *new_dir, struct dentry *new_dentry,
 			    int bindex, struct dentry **wh_old)
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index b76fa7a..1f1db3d 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -114,48 +114,6 @@ out:
 	return err;
 }
 
-/*
- * This is a helper function for rename, which ends up with hosed over
- * dentries when it needs to revert.
- */
-int unionfs_refresh_lower_dentry(struct dentry *dentry, int bindex)
-{
-	struct dentry *lower_dentry;
-	struct dentry *lower_parent;
-	int err = 0;
-
-	verify_locked(dentry);
-
-	unionfs_lock_dentry(dentry->d_parent, UNIONFS_DMUTEX_CHILD);
-	lower_parent = unionfs_lower_dentry_idx(dentry->d_parent, bindex);
-	unionfs_unlock_dentry(dentry->d_parent);
-
-	BUG_ON(!S_ISDIR(lower_parent->d_inode->i_mode));
-
-	lower_dentry = lookup_one_len(dentry->d_name.name, lower_parent,
-				      dentry->d_name.len);
-	if (IS_ERR(lower_dentry)) {
-		err = PTR_ERR(lower_dentry);
-		goto out;
-	}
-
-	dput(unionfs_lower_dentry_idx(dentry, bindex));
-	iput(unionfs_lower_inode_idx(dentry->d_inode, bindex));
-	unionfs_set_lower_inode_idx(dentry->d_inode, bindex, NULL);
-
-	if (!lower_dentry->d_inode) {
-		dput(lower_dentry);
-		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
-	} else {
-		unionfs_set_lower_dentry_idx(dentry, bindex, lower_dentry);
-		unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
-					    igrab(lower_dentry->d_inode));
-	}
-
-out:
-	return err;
-}
-
 int make_dir_opaque(struct dentry *dentry, int bindex)
 {
 	int err = 0;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index edd5685..7ddbad1 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -346,9 +346,6 @@ extern int check_empty(struct dentry *dentry,
 extern int delete_whiteouts(struct dentry *dentry, int bindex,
 			    struct unionfs_dir_state *namelist);
 
-/* Re-lookup a lower dentry. */
-extern int unionfs_refresh_lower_dentry(struct dentry *dentry, int bindex);
-
 extern void unionfs_reinterpose(struct dentry *this_dentry);
 extern struct super_block *unionfs_duplicate_super(struct super_block *sb);
 
-- 
1.5.2.2

