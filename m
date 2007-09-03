Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbXICCk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbXICCk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbXICC2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:28:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57977 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489AbXICC2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:28:51 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 17/32] Unionfs: interpose updates
Date: Sun,  2 Sep 2007 22:20:40 -0400
Message-Id: <1188786057225-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Update unionfs_interpose to handle spliced dentries, which is important for
NFS exporting.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/inode.c  |   40 +++++++++++----
 fs/unionfs/lookup.c |   22 +++++++-
 fs/unionfs/main.c   |  138 +++++++++++++++++++++++++++++++++------------------
 fs/unionfs/union.h  |    4 +-
 4 files changed, 141 insertions(+), 63 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 6cec564..a219a40 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -152,7 +152,12 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 						     wh_dentry);
 			wh_dentry = NULL;
 
-			err = unionfs_interpose(dentry, parent->i_sb, 0);
+			/*
+			 * Only INTERPOSE_LOOKUP can return a value other
+			 * than 0 on err.
+			 */
+			err = PTR_ERR(unionfs_interpose(dentry,
+							parent->i_sb, 0));
 			goto out;
 		}
 	}
@@ -194,11 +199,14 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			if (!IS_COPYUP_ERR(err))
 				break;
 		} else {
-			err = unionfs_interpose(dentry, parent->i_sb, 0);
+			/*
+			 * Only INTERPOSE_LOOKUP can return a value other
+			 * than 0 on err.
+			 */
+			err = PTR_ERR(unionfs_interpose(dentry,
+							parent->i_sb, 0));
 			if (!err) {
-				fsstack_copy_attr_times(parent,
-							lower_parent_dentry->
-							d_inode);
+				unionfs_copy_attr_times(parent);
 				fsstack_copy_inode_size(parent,
 							lower_parent_dentry->
 							d_inode);
@@ -527,7 +535,12 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 			if (!IS_COPYUP_ERR(err))
 				break;
 		} else {
-			err = unionfs_interpose(dentry, dir->i_sb, 0);
+			/*
+			 * Only INTERPOSE_LOOKUP can return a value other
+			 * than 0 on err.
+			 */
+			err = PTR_ERR(unionfs_interpose(dentry,
+							dir->i_sb, 0));
 			if (!err) {
 				fsstack_copy_attr_times(dir,
 							lower_dir_dentry->
@@ -664,10 +677,13 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 		}
 		set_dbend(dentry, bindex);
 
-		err = unionfs_interpose(dentry, parent->i_sb, 0);
+		/*
+		 * Only INTERPOSE_LOOKUP can return a value other than 0 on
+		 * err.
+		 */
+		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
-			fsstack_copy_attr_times(parent,
-						lower_parent_dentry->d_inode);
+			unionfs_copy_attr_times(parent);
 			fsstack_copy_inode_size(parent,
 						lower_parent_dentry->d_inode);
 
@@ -795,7 +811,11 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 			break;
 		}
 
-		err = unionfs_interpose(dentry, dir->i_sb, 0);
+		/*
+		 * Only INTERPOSE_LOOKUP can return a value other than 0 on
+		 * err.
+		 */
+		err = PTR_ERR(unionfs_interpose(dentry, dir->i_sb, 0));
 		if (!err) {
 			fsstack_copy_attr_times(dir,
 						lower_parent_dentry->d_inode);
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 61ee50d..e4e8470 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -72,7 +72,12 @@ out:
 	return err;
 }
 
-/* main (and complex) driver function for Unionfs's lookup */
+/*
+ * Main (and complex) driver function for Unionfs's lookup
+ *
+ * Returns: NULL (ok), ERR_PTR if an error occurred, or a non-null non-error
+ * PTR if d_splice returned a different dentry.
+ */
 struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 				      struct nameidata *nd, int lookupmode)
 {
@@ -81,6 +86,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	struct dentry *wh_lower_dentry = NULL;
 	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *parent_dentry = NULL;
+	struct dentry *d_interposed = NULL;
 	int bindex, bstart, bend, bopaque;
 	int dentry_count = 0;	/* Number of positive dentries. */
 	int first_dentry_offset = -1; /* -1 is uninitialized */
@@ -90,7 +96,6 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	int locked_parent = 0;
 	int locked_child = 0;
 	int allocated_new_info = 0;
-
 	int opaque;
 	char *whname = NULL;
 	const char *name;
@@ -370,7 +375,16 @@ out_positive:
 		bend = dbend(dentry);
 	}
 
-	err = unionfs_interpose(dentry, dentry->d_sb, lookupmode);
+	/*
+	 * Interpose can return a dentry if d_splice returned a different
+	 * dentry.
+	 */
+	d_interposed = unionfs_interpose(dentry, dentry->d_sb, lookupmode);
+	if (IS_ERR(d_interposed))
+		err = PTR_ERR(d_interposed);
+	else if (d_interposed)
+		dentry = d_interposed;
+
 	if (err)
 		goto out_drop;
 
@@ -406,6 +420,8 @@ out:
 	dput(parent_dentry);
 	if (locked_child || (err && allocated_new_info))
 		unionfs_unlock_dentry(dentry);
+	if (!err && d_interposed)
+		return d_interposed;
 	return ERR_PTR(err);
 }
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 689a8fa..bc5c105 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -20,20 +20,73 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
+static void unionfs_fill_inode(struct dentry *dentry,
+			       struct inode *inode)
+{
+	struct inode *lower_inode;
+	struct dentry *lower_dentry;
+	int bindex, bstart, bend;
+
+	bstart = dbstart(dentry);
+	bend = dbend(dentry);
+
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry) {
+			unionfs_set_lower_inode_idx(inode, bindex, NULL);
+			continue;
+		}
+
+		/* Initialize the lower inode to the new lower inode. */
+		if (!lower_dentry->d_inode)
+			continue;
+
+		unionfs_set_lower_inode_idx(inode, bindex,
+					    igrab(lower_dentry->d_inode));
+	}
+
+	ibstart(inode) = dbstart(dentry);
+	ibend(inode) = dbend(dentry);
+
+	/* Use attributes from the first branch. */
+	lower_inode = unionfs_lower_inode(inode);
+
+	/* Use different set of inode ops for symlinks & directories */
+	if (S_ISLNK(lower_inode->i_mode))
+		inode->i_op = &unionfs_symlink_iops;
+	else if (S_ISDIR(lower_inode->i_mode))
+		inode->i_op = &unionfs_dir_iops;
+
+	/* Use different set of file ops for directories */
+	if (S_ISDIR(lower_inode->i_mode))
+		inode->i_fop = &unionfs_dir_fops;
+
+	/* properly initialize special inodes */
+	if (S_ISBLK(lower_inode->i_mode) || S_ISCHR(lower_inode->i_mode) ||
+	    S_ISFIFO(lower_inode->i_mode) || S_ISSOCK(lower_inode->i_mode))
+		init_special_inode(inode, lower_inode->i_mode,
+				   lower_inode->i_rdev);
+
+	/* all well, copy inode attributes */
+	unionfs_copy_attr_all(inode, lower_inode);
+	fsstack_copy_inode_size(inode, lower_inode);
+}
+
 /*
  * Connect a unionfs inode dentry/inode with several lower ones.  This is
  * the classic stackable file system "vnode interposition" action.
  *
  * @sb: unionfs's super_block
  */
-int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
+struct dentry *unionfs_interpose(struct dentry *dentry, struct super_block *sb,
+				 int flag)
 {
-	struct inode *lower_inode;
-	struct dentry *lower_dentry;
 	int err = 0;
 	struct inode *inode;
 	int is_negative_dentry = 1;
 	int bindex, bstart, bend;
+	int need_fill_inode = 1;
+	struct dentry *spliced = NULL;
 
 	verify_locked(dentry);
 
@@ -80,51 +133,12 @@ int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 			err = -EACCES;
 			goto out;
 		}
-
 		if (atomic_read(&inode->i_count) > 1)
 			goto skip;
 	}
 
-	for (bindex = bstart; bindex <= bend; bindex++) {
-		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!lower_dentry) {
-			unionfs_set_lower_inode_idx(inode, bindex, NULL);
-			continue;
-		}
-
-		/* Initialize the lower inode to the new lower inode. */
-		if (!lower_dentry->d_inode)
-			continue;
-
-		unionfs_set_lower_inode_idx(inode, bindex,
-					    igrab(lower_dentry->d_inode));
-	}
-
-	ibstart(inode) = dbstart(dentry);
-	ibend(inode) = dbend(dentry);
-
-	/* Use attributes from the first branch. */
-	lower_inode = unionfs_lower_inode(inode);
-
-	/* Use different set of inode ops for symlinks & directories */
-	if (S_ISLNK(lower_inode->i_mode))
-		inode->i_op = &unionfs_symlink_iops;
-	else if (S_ISDIR(lower_inode->i_mode))
-		inode->i_op = &unionfs_dir_iops;
-
-	/* Use different set of file ops for directories */
-	if (S_ISDIR(lower_inode->i_mode))
-		inode->i_fop = &unionfs_dir_fops;
-
-	/* properly initialize special inodes */
-	if (S_ISBLK(lower_inode->i_mode) || S_ISCHR(lower_inode->i_mode) ||
-	    S_ISFIFO(lower_inode->i_mode) || S_ISSOCK(lower_inode->i_mode))
-		init_special_inode(inode, lower_inode->i_mode,
-				   lower_inode->i_rdev);
-
-	/* all well, copy inode attributes */
-	unionfs_copy_attr_all(inode, lower_inode);
-	fsstack_copy_inode_size(inode, lower_inode);
+	need_fill_inode = 0;
+	unionfs_fill_inode(dentry, inode);
 
 skip:
 	/* only (our) lookup wants to do a d_add */
@@ -134,7 +148,28 @@ skip:
 		d_instantiate(dentry, inode);
 		break;
 	case INTERPOSE_LOOKUP:
-		err = PTR_ERR(d_splice_alias(inode, dentry));
+		spliced = d_splice_alias(inode, dentry);
+		if (IS_ERR(spliced))
+			err = PTR_ERR(spliced);
+		else if (spliced && spliced != dentry) {
+			/*
+			 * d_splice can return a dentry if it was
+			 * disconnected and had to be moved.  We must ensure
+			 * that the private data of the new dentry is
+			 * correct and that the inode info was filled
+			 * properly.  Finally we must return this new
+			 * dentry.
+			 */
+			spliced->d_op = &unionfs_dops;
+			spliced->d_fsdata = dentry->d_fsdata;
+			dentry->d_fsdata = NULL;
+			dentry = spliced;
+			if (need_fill_inode) {
+				need_fill_inode = 0;
+				unionfs_fill_inode(dentry, inode);
+			}
+			goto out_spliced;
+		}
 		break;
 	case INTERPOSE_REVAL:
 		/* Do nothing. */
@@ -143,9 +178,13 @@ skip:
 		printk(KERN_ERR "unionfs: invalid interpose flag passed!");
 		BUG();
 	}
+	goto out;
 
+out_spliced:
+	if (!err)
+		return spliced;
 out:
-	return err;
+	return ERR_PTR(err);
 }
 
 /* like interpose above, but for an already existing dentry */
@@ -623,8 +662,11 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	/* Set the generation number to one, since this is for the mount. */
 	atomic_set(&UNIONFS_D(sb->s_root)->generation, 1);
 
-	/* call interpose to create the upper level inode */
-	err = unionfs_interpose(sb->s_root, sb, 0);
+	/*
+	 * Call interpose to create the upper level inode.  Only
+	 * INTERPOSE_LOOKUP can return a value other than 0 on err.
+	 */
+	err = PTR_ERR(unionfs_interpose(sb->s_root, sb, 0));
 	unionfs_unlock_dentry(sb->s_root);
 	if (!err)
 		goto out;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index ec33155..0fa8ae0 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -333,8 +333,8 @@ extern int is_newer_lower(const struct dentry *dentry);
 #define INTERPOSE_REVAL_NEG	3
 #define INTERPOSE_PARTIAL	4
 
-extern int unionfs_interpose(struct dentry *this_dentry,
-			     struct super_block *sb, int flag);
+extern struct dentry *unionfs_interpose(struct dentry *this_dentry,
+					struct super_block *sb, int flag);
 
 #ifdef CONFIG_UNION_FS_XATTR
 /* Extended attribute functions. */
-- 
1.5.2.2.238.g7cbf2f2

