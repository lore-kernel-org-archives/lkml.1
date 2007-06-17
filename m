Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbXFQTNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbXFQTNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761200AbXFQTKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:10 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36875 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761133AbXFQTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:00 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 04/16] Unionfs: Set lower inodes correctly after branch management succeeds
Date: Sun, 17 Jun 2007 15:09:11 -0400
Message-Id: <11821073631286-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |   50 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index fe02941..b3a5e64 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -335,7 +335,13 @@ found_insertion_point:
 		       new_branch, err);
 		goto out;
 	}
-	/* it's probably safe to check_mode the new branch to insert */
+	/*
+	 * It's probably safe to check_mode the new branch to insert.  Note:
+	 * we don't allow inserting branches which are unionfs's by
+	 * themselves (check_branch returns EINVAL in that case).  This is
+	 * because this code base doesn't support stacking unionfs: the ODF
+	 * code base supports that correctly.
+	 */
 	if ((err = check_branch(&nd))) {
 		printk(KERN_WARNING "unionfs: hidden directory "
 		       "\"%s\" is not a valid branch\n", optarg);
@@ -400,15 +406,17 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	int i;
 	char *optionstmp, *tmp_to_free;	/* kstrdup'ed of "options" */
 	char *optname;
-	int cur_branches;	/* no. of current branches */
-	int new_branches;	/* no. of branches actually left in the end */
+	int cur_branches = 0;	/* no. of current branches */
+	int new_branches = 0;	/* no. of branches actually left in the end */
 	int add_branches;	/* est. no. of branches to add */
 	int del_branches;	/* est. no. of branches to del */
 	int max_branches;	/* max possible no. of branches */
 	struct unionfs_data *new_data = NULL, *tmp_data = NULL;
 	struct path *new_lower_paths = NULL, *tmp_lower_paths = NULL;
+	struct inode **new_lower_inodes = NULL;
 	int new_high_branch_id;	/* new high branch ID */
 	int size;		/* memory allocation size, temp var */
+	int old_ibstart, old_ibend;
 
 	unionfs_write_lock(sb);
 
@@ -640,6 +648,14 @@ out_no_change:
 		goto out_release;
 	}
 
+	/* allocate space for new pointers to lower inodes */
+	new_lower_inodes = kcalloc(new_branches,
+				   sizeof(struct inode *), GFP_KERNEL);
+	if (!new_lower_inodes) {
+		err = -ENOMEM;
+		goto out_release;
+	}
+
 	/*
 	 * OK, just before we actually put the new set of branches in place,
 	 * we need to ensure that our own f/s has no dirty objects left.
@@ -660,7 +676,7 @@ out_no_change:
 	 * fsync_super() which would not have returned until all dirty pages
 	 * were flushed.
 	 *
-	 * But do w have to worry about locked pages?  Is there any chance
+	 * But do we have to worry about locked pages?  Is there any chance
 	 * that in here we'll get locked pages?
 	 *
 	 * XXX: what about pages mapped into pagetables?  Are these pages
@@ -687,8 +703,31 @@ out_no_change:
 	i = sbmax(sb);		/* save no. of branches to release at end */
 	sbend(sb) = new_branches - 1;
 	set_dbend(sb->s_root, new_branches - 1);
+	old_ibstart = ibstart(sb->s_root->d_inode);
+	old_ibend = ibend(sb->s_root->d_inode);
+	ibend(sb->s_root->d_inode) = new_branches - 1;
 	UNIONFS_D(sb->s_root)->bcount = new_branches;
-	new_branches = i;	/* no. of branches to release below */
+	new_branches = i; /* no. of branches to release below */
+
+	/*
+	 * Update lower inodes: 3 steps
+	 * 1. grab ref on all new lower inodes
+	 */
+	for (i=dbstart(sb->s_root); i<=dbend(sb->s_root); i++) {
+		struct dentry *lower_dentry =
+			unionfs_lower_dentry_idx(sb->s_root, i);
+		atomic_inc(&lower_dentry->d_inode->i_count);
+		new_lower_inodes[i] = lower_dentry->d_inode;
+	}
+	/* 2. release reference on all older lower inodes */
+	for (i=old_ibstart; i<=old_ibend; i++) {
+		iput(unionfs_lower_inode_idx(sb->s_root->d_inode, i));
+		unionfs_set_lower_inode_idx(sb->s_root->d_inode, i, NULL);
+	}
+	kfree(UNIONFS_I(sb->s_root->d_inode)->lower_inodes);
+	/* 3. update root dentry's inode to new lower_inodes array */
+	UNIONFS_I(sb->s_root->d_inode)->lower_inodes = new_lower_inodes;
+	new_lower_inodes = NULL;
 
 	/* maxbytes may have changed */
 	sb->s_maxbytes = unionfs_lower_super_idx(sb, 0)->s_maxbytes;
@@ -723,6 +762,7 @@ out_free:
 	kfree(tmp_data);
 	kfree(new_lower_paths);
 	kfree(new_data);
+	kfree(new_lower_inodes);
 out_error:
 	unionfs_write_unlock(sb);
 	return err;
-- 
1.5.2.rc1.165.gaf9b

