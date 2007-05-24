Return-Path: <linux-kernel-owner+w=401wt.eu-S1764468AbXEXAoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764468AbXEXAoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759995AbXEXAg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40218 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbXEXAgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:21 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 03/21] Unionfs: Every printk should prefix with "unionfs: " consistently
Date: Wed, 23 May 2007 20:35:53 -0400
Message-Id: <11799669723086-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    7 ++++---
 fs/unionfs/copyup.c     |    2 +-
 fs/unionfs/dentry.c     |    8 +++++---
 fs/unionfs/inode.c      |   15 ++++++++-------
 fs/unionfs/lookup.c     |    5 +++--
 fs/unionfs/main.c       |    8 ++++----
 fs/unionfs/rdstate.c    |    4 ++--
 fs/unionfs/rename.c     |   30 +++++++++++++++---------------
 fs/unionfs/sioq.c       |    2 +-
 fs/unionfs/subr.c       |    4 ++--
 fs/unionfs/super.c      |    8 ++++----
 11 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 9cf6b81..778901f 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -355,8 +355,8 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	if (willwrite && IS_WRITE_FLAG(file->f_flags) &&
 	    !IS_WRITE_FLAG(unionfs_lower_file(file)->f_flags) &&
 	    is_robranch(dentry)) {
-		printk(KERN_DEBUG "Doing delayed copyup of a read-write "
-		       "file on a read-only branch.\n");
+		printk(KERN_DEBUG "unionfs: Doing delayed copyup of a "
+		       "read-write file on a read-only branch.\n");
 		err = do_delayed_copyup(file, dentry);
 	}
 
@@ -576,7 +576,8 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 
 	if (fileinfo->rdstate) {
 		fileinfo->rdstate->access = jiffies;
-		printk(KERN_DEBUG "Saving rdstate with cookie %u [%d.%lld]\n",
+		printk(KERN_DEBUG "unionfs: saving rdstate with cookie "
+		       "%u [%d.%lld]\n",
 		       fileinfo->rdstate->cookie,
 		       fileinfo->rdstate->bindex,
 		       (long long)fileinfo->rdstate->dirpos);
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 502a40f..8fae308 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -183,7 +183,7 @@ static int __copyup_ndentry(struct dentry *old_hidden_dentry,
 		run_sioq(__unionfs_create, &args);
 		err = args.err;
 	} else {
-		printk(KERN_ERR "Unknown inode type %d\n",
+		printk(KERN_ERR "unionfs: unknown inode type %d\n",
 		       old_mode);
 		BUG();
 	}
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 067732c..463cf4c 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -48,7 +48,8 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 
 	/* if the dentry is unhashed, do NOT revalidate */
 	if (d_deleted(dentry)) {
-		printk(KERN_DEBUG "unhashed dentry being revalidated: %*s\n",
+		printk(KERN_DEBUG "unionfs: unhashed dentry being "
+		       "revalidated: %*s\n",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out;
 	}
@@ -297,12 +298,13 @@ static void unionfs_d_release(struct dentry *dentry)
 
 	/* this could be a negative dentry, so check first */
 	if (!UNIONFS_D(dentry)) {
-		printk(KERN_DEBUG "dentry without private data: %.*s",
+		printk(KERN_DEBUG "unionfs: dentry without private data: %.*s",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out;
 	} else if (dbstart(dentry) < 0) {
 		/* this is due to a failed lookup */
-		printk(KERN_DEBUG "dentry without hidden dentries : %.*s",
+		printk(KERN_DEBUG "unionfs: dentry without hidden "
+		       "dentries: %.*s",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out_free;
 	}
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 0b9cb29..f0616ed 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -463,8 +463,9 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 				if (IS_ERR(hidden_dentry))
 					err = PTR_ERR(hidden_dentry);
 
-				printk(KERN_DEBUG "hidden dentry NULL (or error)"
-				       "for bindex = %d\n", bindex);
+				printk(KERN_DEBUG "unionfs: hidden dentry "
+				       "NULL (or error) for bindex = %d\n",
+				       bindex);
 				continue;
 			}
 		}
@@ -585,8 +586,8 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 		if (!hidden_dentry) {
 			hidden_dentry = create_parents(parent, dentry, bindex);
 			if (!hidden_dentry || IS_ERR(hidden_dentry)) {
-				printk(KERN_DEBUG "hidden dentry NULL for "
-				       "bindex = %d\n", bindex);
+				printk(KERN_DEBUG "unionfs: hidden dentry "
+				       " NULL for bindex = %d\n", bindex);
 				continue;
 			}
 		}
@@ -628,7 +629,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 
 		err = make_dir_opaque(dentry, dbstart(dentry));
 		if (err) {
-			printk(KERN_ERR "mkdir: error creating "
+			printk(KERN_ERR "unionfs: mkdir: error creating "
 			       ".wh.__dir_opaque: %d\n", err);
 			goto out;
 		}
@@ -713,8 +714,8 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		if (!hidden_dentry) {
 			hidden_dentry = create_parents(dir, dentry, bindex);
 			if (IS_ERR(hidden_dentry)) {
-				printk(KERN_DEBUG
-				       "failed to create parents on %d, err = %ld\n",
+				printk(KERN_DEBUG "unionfs: failed to create "
+				       "parents on %d, err = %ld\n",
 				       bindex, PTR_ERR(hidden_dentry));
 				continue;
 			}
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 4be590f..8e5f419 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -193,8 +193,9 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 				break;
 			}
 			err = -EIO;
-			printk(KERN_NOTICE "EIO: Invalid whiteout entry type"
-			       " %d.\n", wh_hidden_dentry->d_inode->i_mode);
+			printk(KERN_NOTICE "unionfs: EIO: invalid whiteout "
+			       "entry type %d.\n",
+			       wh_hidden_dentry->d_inode->i_mode);
 			dput(wh_hidden_dentry);
 			dput(first_hidden_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index ffedbcd..cdfe96a 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -138,7 +138,7 @@ skip:
 		/* Do nothing. */
 		break;
 	default:
-		printk(KERN_ERR "Invalid interpose flag passed!");
+		printk(KERN_ERR "unionfs: invalid interpose flag passed!");
 		BUG();
 	}
 
@@ -518,7 +518,7 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 
 	if (!raw_data) {
 		printk(KERN_WARNING
-		       "unionfs_read_super: missing data argument\n");
+		       "unionfs: read_super: missing data argument\n");
 		err = -EINVAL;
 		goto out;
 	}
@@ -526,7 +526,7 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	/* Allocate superblock private data */
 	sb->s_fs_info = kzalloc(sizeof(struct unionfs_sb_info), GFP_KERNEL);
 	if (!UNIONFS_SB(sb)) {
-		printk(KERN_WARNING "%s: out of memory\n", __FUNCTION__);
+		printk(KERN_WARNING "unionfs: read_super: out of memory\n");
 		err = -ENOMEM;
 		goto out;
 	}
@@ -539,7 +539,7 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	hidden_root_info = unionfs_parse_options(sb, raw_data);
 	if (IS_ERR(hidden_root_info)) {
 		printk(KERN_WARNING
-		       "unionfs_read_super: error while parsing options "
+		       "unionfs: read_super: error while parsing options "
 		       "(err = %ld)\n", PTR_ERR(hidden_root_info));
 		err = PTR_ERR(hidden_root_info);
 		hidden_root_info = NULL;
diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index 4e875b1..e84161d 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -213,8 +213,8 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 			 * system is corrupted.
 			 */
 			if (cursor->bindex == rdstate->bindex) {
-				printk(KERN_DEBUG "Possible I/O error "
-				       "unionfs_filldir: a file is duplicated "
+				printk(KERN_DEBUG "unionfs: filldir: possible "
+				       "I/O error: a file is duplicated "
 				       "in the same branch %d: %s\n",
 				       rdstate->bindex, cursor->name);
 			}
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 5c6a33f..224ce5c 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -39,8 +39,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 			create_parents(new_dentry->d_parent->d_inode,
 				       new_dentry, bindex);
 		if (IS_ERR(hidden_new_dentry)) {
-			printk(KERN_DEBUG "error creating directory tree for"
-			       " rename, bindex = %d, err = %ld\n",
+			printk(KERN_DEBUG "unionfs: error creating directory "
+			       "tree for rename, bindex = %d, err = %ld\n",
 			       bindex, PTR_ERR(hidden_new_dentry));
 			err = PTR_ERR(hidden_new_dentry);
 			goto out;
@@ -65,8 +65,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (hidden_wh_dentry->d_inode) {
 		/* get rid of the whiteout that is existing */
 		if (hidden_new_dentry->d_inode) {
-			printk(KERN_WARNING "Both a whiteout and a dentry"
-			       " exist when doing a rename!\n");
+			printk(KERN_WARNING "unionfs: both a whiteout and a "
+			       "dentry exist when doing a rename!\n");
 			err = -EIO;
 
 			dput(hidden_wh_dentry);
@@ -254,8 +254,8 @@ static int do_unionfs_rename(struct inode *old_dir,
 			 * we can't fix anything now, so we cop-out and use
 			 * -EIO.
 			 */
-			printk(KERN_ERR "We can't create a whiteout for the "
-			       "source in rename!\n");
+			printk(KERN_ERR "unionfs: can't create a whiteout for "
+			       "the source in rename!\n");
 			err = -EIO;
 		}
 	}
@@ -268,31 +268,31 @@ revert:
 	/* Do revert here. */
 	local_err = unionfs_refresh_hidden_dentry(new_dentry, old_bstart);
 	if (local_err) {
-		printk(KERN_WARNING "Revert failed in rename: the new refresh "
-		       "failed.\n");
+		printk(KERN_WARNING "unionfs: revert failed in rename: "
+		       "the new refresh failed.\n");
 		eio = -EIO;
 	}
 
 	local_err = unionfs_refresh_hidden_dentry(old_dentry, old_bstart);
 	if (local_err) {
-		printk(KERN_WARNING "Revert failed in rename: the old refresh "
-		       "failed.\n");
+		printk(KERN_WARNING "unionfs: revert failed in rename: "
+		       "the old refresh failed.\n");
 		eio = -EIO;
 		goto revert_out;
 	}
 
 	if (!unionfs_lower_dentry_idx(new_dentry, bindex) ||
 	    !unionfs_lower_dentry_idx(new_dentry, bindex)->d_inode) {
-		printk(KERN_WARNING "Revert failed in rename: the object "
-		       "disappeared from under us!\n");
+		printk(KERN_WARNING "unionfs: revert failed in rename: "
+		       "the object disappeared from under us!\n");
 		eio = -EIO;
 		goto revert_out;
 	}
 
 	if (unionfs_lower_dentry_idx(old_dentry, bindex) &&
 	    unionfs_lower_dentry_idx(old_dentry, bindex)->d_inode) {
-		printk(KERN_WARNING "Revert failed in rename: the object was "
-		       "created underneath us!\n");
+		printk(KERN_WARNING "unionfs: revert failed in rename: "
+		       "the object was created underneath us!\n");
 		eio = -EIO;
 		goto revert_out;
 	}
@@ -302,7 +302,7 @@ revert:
 
 	/* If we can't fix it, then we cop-out with -EIO. */
 	if (local_err) {
-		printk(KERN_WARNING "Revert failed in rename!\n");
+		printk(KERN_WARNING "unionfs: revert failed in rename!\n");
 		eio = -EIO;
 	}
 
diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index bef970b..a1e8ffa 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -35,7 +35,7 @@ int __init init_sioq(void)
 		return 0;
 
 	err = PTR_ERR(superio_workqueue);
-	printk(KERN_ERR "create_workqueue failed %d\n", err);
+	printk(KERN_ERR "unionfs: create_workqueue failed %d\n", err);
 	superio_workqueue = NULL;
 	return err;
 }
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 0257cca..f77101b 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -55,8 +55,8 @@ int create_whiteout(struct dentry *dentry, int start)
 			hidden_dentry = create_parents(dentry->d_inode,
 						       dentry, bindex);
 			if (!hidden_dentry || IS_ERR(hidden_dentry)) {
-				printk(KERN_DEBUG "create_parents failed for "
-				       "bindex = %d\n", bindex);
+				printk(KERN_DEBUG "unionfs: create_parents "
+				       "failed for bindex = %d\n", bindex);
 				continue;
 			}
 		}
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index f8116a5..eab844e 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -30,8 +30,8 @@ static void unionfs_read_inode(struct inode *inode)
 	struct unionfs_inode_info *info = UNIONFS_I(inode);
 
 	if (!info) {
-		printk(KERN_ERR "No kernel memory when allocating inode "
-		       "private data!\n");
+		printk(KERN_ERR "unionfs: no kernel memory when allocating "
+		       "inode private data!\n");
 		BUG();
 	}
 
@@ -48,8 +48,8 @@ static void unionfs_read_inode(struct inode *inode)
 	size = sbmax(inode->i_sb) * sizeof(struct inode *);
 	info->lower_inodes = kzalloc(size, GFP_KERNEL);
 	if (!info->lower_inodes) {
-		printk(KERN_ERR "No kernel memory when allocating lower-"
-		       "pointer array!\n");
+		printk(KERN_ERR "unionfs: no kernel memory when allocating "
+		       "lower-pointer array!\n");
 		BUG();
 	}
 
-- 
1.5.2.rc1.165.gaf9b

