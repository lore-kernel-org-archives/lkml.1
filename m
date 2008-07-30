Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYG3CsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYG3CsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYG3Cop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46300 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbYG3Coj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:39 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/19] Unionfs: simplify stale-inode detection code
Date: Tue, 29 Jul 2008 22:43:36 -0400
Message-Id: <12173858351552-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   16 +++++++++++++++-
 fs/unionfs/lookup.c |   10 ++--------
 fs/unionfs/main.c   |   14 +-------------
 fs/unionfs/union.h  |    2 +-
 4 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 51c0baf..cd4611b 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -18,6 +18,20 @@
 
 #include "union.h"
 
+bool is_negative_lower(const struct dentry *dentry)
+{
+	int bindex;
+	struct dentry *lower_dentry;
+
+	BUG_ON(!dentry || dbstart(dentry) < 0);
+	for (bindex = dbstart(dentry); bindex <= dbend(dentry); bindex++) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		/* XXX: what if lower_dentry is NULL? */
+		if (lower_dentry && lower_dentry->d_inode)
+			return false;
+	}
+	return true;
+}
 
 static inline void __dput_lowers(struct dentry *dentry, int start, int end)
 {
@@ -113,7 +127,7 @@ static bool __unionfs_d_revalidate_one(struct dentry *dentry,
 			dentry = result;
 		}
 
-		if (unlikely(positive && UNIONFS_I(dentry->d_inode)->stale)) {
+		if (unlikely(positive && is_negative_lower(dentry))) {
 			make_bad_inode(dentry->d_inode);
 			d_drop(dentry);
 			valid = false;
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index f6bb748..1ba7103 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -320,11 +320,9 @@ out_negative:
 		goto out;
 
 	/* If we've only got negative dentries, then use the leftmost one. */
-	if (lookupmode == INTERPOSE_REVAL) {
-		if (dentry->d_inode)
-			UNIONFS_I(dentry->d_inode)->stale = 1;
+	if (lookupmode == INTERPOSE_REVAL)
 		goto out;
-	}
+
 	if (!lower_dir_dentry) {
 		err = -ENOENT;
 		goto out;
@@ -424,7 +422,6 @@ out:
 		     !UNIONFS_I(dentry->d_inode)->lower_inodes)) {
 			unionfs_mntput(dentry->d_sb->s_root, bstart);
 			dput(first_lower_dentry);
-			UNIONFS_I(dentry->d_inode)->stale = 1;
 		}
 	}
 	kfree(whname);
@@ -433,9 +430,6 @@ out:
 		unionfs_unlock_dentry(dentry);
 	if (!err && d_interposed)
 		return d_interposed;
-	if (dentry->d_inode && UNIONFS_I(dentry->d_inode)->stale &&
-	    first_dentry_offset >= 0)
-		unionfs_mntput(dentry->d_sb->s_root, first_dentry_offset);
 	return ERR_PTR(err);
 }
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index b8f84bb..a9d2cb6 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -83,25 +83,13 @@ struct dentry *unionfs_interpose(struct dentry *dentry, struct super_block *sb,
 {
 	int err = 0;
 	struct inode *inode;
-	int is_negative_dentry = 1;
-	int bindex, bstart, bend;
 	int need_fill_inode = 1;
 	struct dentry *spliced = NULL;
 
 	verify_locked(dentry);
 
-	bstart = dbstart(dentry);
-	bend = dbend(dentry);
-
 	/* Make sure that we didn't get a negative dentry. */
-	for (bindex = bstart; bindex <= bend; bindex++) {
-		if (unionfs_lower_dentry_idx(dentry, bindex) &&
-		    unionfs_lower_dentry_idx(dentry, bindex)->d_inode) {
-			is_negative_dentry = 0;
-			break;
-		}
-	}
-	BUG_ON(is_negative_dentry);
+	BUG_ON(is_negative_lower(dentry));
 
 	/*
 	 * We allocate our new inode below by calling unionfs_iget,
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 7ddbad1..f5cf09b 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -99,7 +99,6 @@ struct unionfs_inode_info {
 	int bstart;
 	int bend;
 	atomic_t generation;
-	int stale;
 	/* Stuff for readdir over NFS. */
 	spinlock_t rdlock;
 	struct list_head readdircache;
@@ -377,6 +376,7 @@ extern bool __unionfs_d_revalidate_one_locked(struct dentry *dentry,
 					      bool willwrite);
 extern bool __unionfs_d_revalidate_chain(struct dentry *dentry,
 					 struct nameidata *nd, bool willwrite);
+extern bool is_negative_lower(const struct dentry *dentry);
 extern bool is_newer_lower(const struct dentry *dentry);
 extern void purge_sb_data(struct super_block *sb);
 
-- 
1.5.2.2

