Return-Path: <linux-kernel-owner+w=401wt.eu-S934293AbXICCiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293AbXICCiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXICC01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57786 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbXICC0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:26:21 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 32/32] Unionfs: unionfs_create rewrite
Date: Sun,  2 Sep 2007 22:20:55 -0400
Message-Id: <1188786059299-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The code was hard to follow and violated some invariants (e.g., never modify
a read only branch, and always create on branch 0).

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c |  207 +++++++++++++++-------------------------------------
 1 files changed, 58 insertions(+), 149 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 9adf272..08c1ae0 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -24,9 +24,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	int err = 0;
 	struct dentry *lower_dentry = NULL;
 	struct dentry *wh_dentry = NULL;
-	struct dentry *new_lower_dentry;
 	struct dentry *lower_parent_dentry = NULL;
-	int bindex = 0, bstart;
 	char *name = NULL;
 	int valid = 0;
 
@@ -47,177 +45,88 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	 */
 	BUG_ON(!valid && dentry->d_inode);
 
-	/* We start out in the leftmost branch. */
-	bstart = dbstart(dentry);
-	lower_dentry = unionfs_lower_dentry(dentry);
-
 	/*
-	 * check if whiteout exists in this branch, i.e. lookup .wh.foo
-	 * first.
+	 * We shouldn't create things in a read-only branch; this check is a
+	 * bit redundant as we don't allow branch 0 to be read-only at the
+	 * moment
 	 */
-	name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-	if (IS_ERR(name)) {
-		err = PTR_ERR(name);
-		goto out;
-	}
-
-	wh_dentry = lookup_one_len(name, lower_dentry->d_parent,
-				   dentry->d_name.len + UNIONFS_WHLEN);
-	if (IS_ERR(wh_dentry)) {
-		err = PTR_ERR(wh_dentry);
-		wh_dentry = NULL;
+	if ((err = is_robranch_super(dentry->d_sb, 0))) {
+		err = -EROFS;
 		goto out;
 	}
 
-	if (wh_dentry->d_inode) {
+	/*
+	 * We _always_ create on branch 0
+	 */
+	lower_dentry = unionfs_lower_dentry_idx(dentry, 0);
+	if (lower_dentry) {
 		/*
-		 * .wh.foo has been found.
-		 * First truncate it and then rename it to foo (hence having
-		 * the same overall effect as a normal create.
+		 * check if whiteout exists in this branch, i.e. lookup .wh.foo
+		 * first.
 		 */
-		struct dentry *lower_dir_dentry;
-		struct iattr newattrs;
-
-		mutex_lock(&wh_dentry->d_inode->i_mutex);
-		newattrs.ia_valid = ATTR_CTIME | ATTR_MODE | ATTR_ATIME
-			| ATTR_MTIME | ATTR_UID | ATTR_GID | ATTR_FORCE
-			| ATTR_KILL_SUID | ATTR_KILL_SGID;
-
-		newattrs.ia_mode = mode & ~current->fs->umask;
-		newattrs.ia_uid = current->fsuid;
-		newattrs.ia_gid = current->fsgid;
-
-		if (wh_dentry->d_inode->i_size != 0) {
-			newattrs.ia_valid |= ATTR_SIZE;
-			newattrs.ia_size = 0;
-		}
-
-		err = notify_change(wh_dentry, &newattrs);
-
-		mutex_unlock(&wh_dentry->d_inode->i_mutex);
-
-		if (err)
-			printk(KERN_WARNING "unionfs: %s:%d: notify_change "
-			       "failed: %d, ignoring..\n",
-			       __FILE__, __LINE__, err);
-
-		new_lower_dentry = unionfs_lower_dentry(dentry);
-		dget(new_lower_dentry);
-
-		lower_dir_dentry = dget_parent(wh_dentry);
-		lock_rename(lower_dir_dentry, lower_dir_dentry);
-
-		if (!(err = is_robranch_super(dentry->d_sb, bstart))) {
-			err = vfs_rename(lower_dir_dentry->d_inode,
-					 wh_dentry,
-					 lower_dir_dentry->d_inode,
-					 new_lower_dentry);
-		}
-		if (!err) {
-			fsstack_copy_attr_times(parent,
-						new_lower_dentry->d_parent->
-						d_inode);
-			fsstack_copy_inode_size(parent,
-						new_lower_dentry->d_parent->
-						d_inode);
-			parent->i_nlink = unionfs_get_nlinks(parent);
+		name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
+		if (IS_ERR(name)) {
+			err = PTR_ERR(name);
+			goto out;
 		}
 
-		unlock_rename(lower_dir_dentry, lower_dir_dentry);
-		dput(lower_dir_dentry);
-
-		dput(new_lower_dentry);
-
-		if (err) {
-			/* exit if the error returned was NOT -EROFS */
-			if (!IS_COPYUP_ERR(err))
-				goto out;
-			/*
-			 * We were not able to create the file in this
-			 * branch, so, we try to create it in one branch to
-			 * left
-			 */
-			bstart--;
-		} else {
-			/*
-			 * reset the unionfs dentry to point to the .wh.foo
-			 * entry.
-			 */
-
-			/* Discard any old reference. */
-			dput(unionfs_lower_dentry(dentry));
-
-			/* Trade one reference to another. */
-			unionfs_set_lower_dentry_idx(dentry, bstart,
-						     wh_dentry);
+		wh_dentry = lookup_one_len(name, lower_dentry->d_parent,
+					   dentry->d_name.len + UNIONFS_WHLEN);
+		if (IS_ERR(wh_dentry)) {
+			err = PTR_ERR(wh_dentry);
 			wh_dentry = NULL;
-
-			/*
-			 * Only INTERPOSE_LOOKUP can return a value other
-			 * than 0 on err.
-			 */
-			err = PTR_ERR(unionfs_interpose(dentry,
-							parent->i_sb, 0));
 			goto out;
 		}
-	}
 
-	for (bindex = bstart; bindex >= 0; bindex--) {
-		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!lower_dentry) {
+		if (wh_dentry->d_inode) {
 			/*
-			 * if lower_dentry is NULL, create the entire
-			 * dentry directory structure in branch 'bindex'.
-			 * lower_dentry will NOT be null when bindex == bstart
-			 * because lookup passed as a negative unionfs dentry
-			 * pointing to a lone negative underlying dentry.
+			 * .wh.foo has been found, so let's unlink it
 			 */
-			lower_dentry = create_parents(parent, dentry,
-						      dentry->d_name.name,
-						      bindex);
-			if (!lower_dentry || IS_ERR(lower_dentry)) {
-				if (IS_ERR(lower_dentry))
-					err = PTR_ERR(lower_dentry);
-				continue;
+			struct dentry *lower_dir_dentry;
+
+			lower_dir_dentry = lock_parent(wh_dentry);
+			err = vfs_unlink(lower_dir_dentry->d_inode, wh_dentry);
+			unlock_dir(lower_dir_dentry);
+
+			if (err) {
+				printk("unionfs_create: could not unlink "
+				       "whiteout, err = %d\n", err);
+				goto out;
 			}
 		}
-
-		lower_parent_dentry = lock_parent(lower_dentry);
-		if (IS_ERR(lower_parent_dentry)) {
-			err = PTR_ERR(lower_parent_dentry);
+	} else {
+		/*
+		 * if lower_dentry is NULL, create the entire
+		 * dentry directory structure in branch 0.
+		 */
+		lower_dentry = create_parents(parent, dentry, dentry->d_name.name, 0);
+		if (IS_ERR(lower_dentry)) {
+			err = PTR_ERR(lower_dentry);
 			goto out;
 		}
-		/* We shouldn't create things in a read-only branch. */
-		if (!(err = is_robranch_super(dentry->d_sb, bindex)))
-			err = vfs_create(lower_parent_dentry->d_inode,
-					 lower_dentry, mode, nd);
+	}
 
-		if (err || !lower_dentry->d_inode) {
-			unlock_dir(lower_parent_dentry);
+	lower_parent_dentry = lock_parent(lower_dentry);
+	if (IS_ERR(lower_parent_dentry)) {
+		err = PTR_ERR(lower_parent_dentry);
+		goto out;
+	}
 
-			/* break out of for loop if the error wasn't  -EROFS */
-			if (!IS_COPYUP_ERR(err))
-				break;
-		} else {
-			/*
-			 * Only INTERPOSE_LOOKUP can return a value other
-			 * than 0 on err.
-			 */
-			err = PTR_ERR(unionfs_interpose(dentry,
-							parent->i_sb, 0));
-			if (!err) {
-				unionfs_copy_attr_times(parent);
-				fsstack_copy_inode_size(parent,
-							lower_parent_dentry->
-							d_inode);
-				/* update no. of links on parent directory */
-				parent->i_nlink = unionfs_get_nlinks(parent);
-			}
-			unlock_dir(lower_parent_dentry);
-			break;
+	err = vfs_create(lower_parent_dentry->d_inode, lower_dentry, mode, nd);
+
+	if (!err) {
+		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
+		if (!err) {
+			unionfs_copy_attr_times(parent);
+			fsstack_copy_inode_size(parent,
+						lower_parent_dentry->d_inode);
+			/* update no. of links on parent directory */
+			parent->i_nlink = unionfs_get_nlinks(parent);
 		}
 	}
 
+	unlock_dir(lower_parent_dentry);
+
 out:
 	dput(wh_dentry);
 	kfree(name);
-- 
1.5.2.2.238.g7cbf2f2

