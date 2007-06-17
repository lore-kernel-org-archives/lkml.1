Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbXFQTLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbXFQTLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759711AbXFQTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:09:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36840 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760805AbXFQTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:09:46 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 11/16] Unionfs: Revalidate dentries passed to all inode/super operations
Date: Sun, 17 Jun 2007 15:09:18 -0400
Message-Id: <11821073641448-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Be sure to properly revalidate all dentry chains passed to all inode and
super_block operations.  Remove the older BUG_ON test is_valid_dentry().
This should help improve cache-coherency.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c  |   71 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/unionfs/rename.c |   13 +++++++--
 fs/unionfs/super.c  |    9 ++++++-
 fs/unionfs/union.h  |   13 ---------
 fs/unionfs/unlink.c |   15 ++++++++---
 fs/unionfs/xattr.c  |   34 ++++++++++++++++++------
 6 files changed, 111 insertions(+), 44 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 9f1acc4..aaabfcf 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -47,7 +47,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	valid = __unionfs_d_revalidate_chain(dentry->d_parent, nd);
 	unionfs_unlock_dentry(dentry->d_parent);
 	if (!valid) {
-		err = -ENOENT;	/* same as what real_lookup does */
+		err = -ESTALE;	/* same as what real_lookup does */
 		goto out;
 	}
 	valid = __unionfs_d_revalidate_chain(dentry, nd);
@@ -234,6 +234,12 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 	struct path path_save;
 	struct dentry *ret;
 
+	/*
+	 * lookup is the only special function which takes a dentry, yet we
+	 * do NOT want to call __unionfs_d_revalidate_chain because by
+	 * definition, we don't have a valid dentry here yet.
+	 */
+
 	/* save the dentry & vfsmnt from namei */
 	if (nd) {
 		path_save.dentry = nd->dentry;
@@ -262,11 +268,18 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct dentry *whiteout_dentry;
 	char *name = NULL;
 
-	BUG_ON(!is_valid_dentry(new_dentry));
-	BUG_ON(!is_valid_dentry(old_dentry));
-
 	unionfs_double_lock_dentry(new_dentry, old_dentry);
 
+	if (!__unionfs_d_revalidate_chain(old_dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+	if (new_dentry->d_inode &&
+	    !__unionfs_d_revalidate_chain(new_dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	hidden_new_dentry = unionfs_lower_dentry(new_dentry);
 
 	/*
@@ -392,10 +405,14 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	int bindex = 0, bstart;
 	char *name = NULL;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
 
+	if (dentry->d_inode &&
+	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	/* We start out in the leftmost branch. */
 	bstart = dbstart(dentry);
 
@@ -534,9 +551,14 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 	int whiteout_unlinked = 0;
 	struct sioq_args args;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
+
+	if (dentry->d_inode &&
+	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	bstart = dbstart(dentry);
 
 	hidden_dentry = unionfs_lower_dentry(dentry);
@@ -667,9 +689,14 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	char *name = NULL;
 	int whiteout_unlinked = 0;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
+
+	if (dentry->d_inode &&
+	    !__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	bstart = dbstart(dentry);
 
 	hidden_dentry = unionfs_lower_dentry(dentry);
@@ -774,9 +801,13 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 	int err;
 	struct dentry *hidden_dentry;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
+
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	hidden_dentry = unionfs_lower_dentry(dentry);
 
 	if (!hidden_dentry->d_inode->i_op ||
@@ -803,7 +834,13 @@ static void *unionfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 	int len = PAGE_SIZE, err;
 	mm_segment_t old_fs;
 
-	BUG_ON(!is_valid_dentry(dentry));
+	unionfs_lock_dentry(dentry);
+
+	if (dentry->d_inode &&
+	    !__unionfs_d_revalidate_chain(dentry, nd)) {
+		err = -ESTALE;
+		goto out;
+	}
 
 	/* This is freed by the put_link method assuming a successful call. */
 	buf = kmalloc(len, GFP_KERNEL);
@@ -969,9 +1006,13 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	int i;
 	int copyup = 0;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
+
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	bstart = dbstart(dentry);
 	bend = dbend(dentry);
 	inode = dentry->d_inode;
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index edc5a5c..4ceb815 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -398,11 +398,18 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int err = 0;
 	struct dentry *wh_dentry;
 
-	BUG_ON(!is_valid_dentry(old_dentry));
-	BUG_ON(!is_valid_dentry(new_dentry));
-
 	unionfs_double_lock_dentry(old_dentry, new_dentry);
 
+	if (!__unionfs_d_revalidate_chain(old_dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+	if (!d_deleted(new_dentry) && new_dentry->d_inode &&
+	    !__unionfs_d_revalidate_chain(new_dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	if (!S_ISDIR(old_dentry->d_inode->i_mode))
 		err = unionfs_partial_lookup(old_dentry);
 	else
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 196ff12..3f334f3 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -117,7 +117,12 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct super_block *sb;
 	struct dentry *lower_dentry;
 
-	BUG_ON(!is_valid_dentry(dentry));
+	unionfs_lock_dentry(dentry);
+
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
 
 	sb = dentry->d_sb;
 
@@ -136,6 +141,8 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	memset(&buf->f_fsid, 0, sizeof(__kernel_fsid_t));
 	memset(&buf->f_spare, 0, sizeof(buf->f_spare));
 
+out:
+	unionfs_unlock_dentry(dentry);
 	return err;
 }
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 480b8ee..28eb622 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -401,19 +401,6 @@ static inline int is_robranch(const struct dentry *dentry)
 	return is_robranch_idx(dentry, index);
 }
 
-/*
- * Check if dentry is valid or not, as per our generation numbers.
- * @dentry: dentry to check.
- * Returns 1 (valid) or 0 (invalid/stale).
- */
-static inline int is_valid_dentry(struct dentry *dentry)
-{
-	BUG_ON(!UNIONFS_D(dentry));
-	BUG_ON(!UNIONFS_SB(dentry->d_sb));
-	return (atomic_read(&UNIONFS_D(dentry)->generation) ==
-		atomic_read(&UNIONFS_SB(dentry->d_sb)->generation));
-}
-
 /* What do we use for whiteouts. */
 #define UNIONFS_WHPFX ".wh."
 #define UNIONFS_WHLEN 4
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 27b4542..c785ff0 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -74,15 +74,19 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int err = 0;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
 
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	err = unionfs_unlink_whiteout(dir, dentry);
 	/* call d_drop so the system "forgets" about us */
 	if (!err)
 		d_drop(dentry);
 
+out:
 	unionfs_unlock_dentry(dentry);
 	return err;
 }
@@ -124,10 +128,13 @@ int unionfs_rmdir(struct inode *dir, struct dentry *dentry)
 	int err = 0;
 	struct unionfs_dir_state *namelist = NULL;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
 
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	/* check if this unionfs directory is empty or not */
 	err = check_empty(dentry, &namelist);
 	if (err)
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 12d618b..1beb373 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -57,14 +57,18 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 	struct dentry *hidden_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
 
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	hidden_dentry = unionfs_lower_dentry(dentry);
 
 	err = vfs_getxattr(hidden_dentry, (char*) name, value, size);
 
+out:
 	unionfs_unlock_dentry(dentry);
 	return err;
 }
@@ -79,14 +83,19 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 	struct dentry *hidden_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
+
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	hidden_dentry = unionfs_lower_dentry(dentry);
 
 	err = vfs_setxattr(hidden_dentry, (char*) name, (void*) value,
 			   size, flags);
 
+out:
 	unionfs_unlock_dentry(dentry);
 	return err;
 }
@@ -100,13 +109,18 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 	struct dentry *hidden_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
+
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	hidden_dentry = unionfs_lower_dentry(dentry);
 
 	err = vfs_removexattr(hidden_dentry, (char*) name);
 
+out:
 	unionfs_unlock_dentry(dentry);
 	return err;
 }
@@ -121,15 +135,19 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 	int err = -EOPNOTSUPP;
 	char *encoded_list = NULL;
 
-	BUG_ON(!is_valid_dentry(dentry));
-
 	unionfs_lock_dentry(dentry);
 
+	if (!__unionfs_d_revalidate_chain(dentry, NULL)) {
+		err = -ESTALE;
+		goto out;
+	}
+
 	hidden_dentry = unionfs_lower_dentry(dentry);
 
 	encoded_list = list;
 	err = vfs_listxattr(hidden_dentry, encoded_list, size);
 
+out:
 	unionfs_unlock_dentry(dentry);
 	return err;
 }
-- 
1.5.2.rc1.165.gaf9b

