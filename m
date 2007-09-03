Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbXICC0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbXICC0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbXICCZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:06 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57585 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbXICCYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:21 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 22/32] Unionfs: handling lower vfsmount fixes
Date: Sun,  2 Sep 2007 22:20:45 -0400
Message-Id: <11887860583755-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Properly increase/release lower vfsmounts.
Validate proper use of unionfs mntget/put.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    6 ++++--
 fs/unionfs/inode.c  |   11 +++++++++++
 fs/unionfs/lookup.c |   11 ++++++-----
 fs/unionfs/union.h  |   47 +++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index c7bbeca..0be958f 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -450,9 +450,11 @@ static void unionfs_d_release(struct dentry *dentry)
 	bend = dbend(dentry);
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		dput(unionfs_lower_dentry_idx(dentry, bindex));
-		unionfs_mntput(dentry, bindex);
-
 		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
+		/* NULL lower mnt is ok if this is a negative dentry */
+		if (!dentry->d_inode && !unionfs_lower_mnt_idx(dentry,bindex))
+			continue;
+		unionfs_mntput(dentry, bindex);
 		unionfs_set_lower_mnt_idx(dentry, bindex, NULL);
 	}
 	/* free private data (unionfs_dentry_info) here */
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index a219a40..d6a79d5 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -222,8 +222,11 @@ out:
 	dput(wh_dentry);
 	kfree(name);
 
+	if (!err)
+		unionfs_postcopyup_setmnt(dentry);
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
+
 	return err;
 }
 
@@ -563,8 +566,12 @@ out:
 		d_drop(dentry);
 
 	kfree(name);
+	if (!err)
+		unionfs_postcopyup_setmnt(dentry);
 	unionfs_unlock_dentry(dentry);
+
 	unionfs_read_unlock(dentry->d_sb);
+
 	return err;
 }
 
@@ -835,8 +842,12 @@ out:
 
 	kfree(name);
 
+	if (!err)
+		unionfs_postcopyup_setmnt(dentry);
 	unionfs_unlock_dentry(dentry);
+
 	unionfs_read_unlock(dentry->d_sb);
+
 	return err;
 }
 
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 152d421..38ee21f 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -314,24 +314,25 @@ out_negative:
 	if (lookupmode == INTERPOSE_REVAL) {
 		if (dentry->d_inode)
 			UNIONFS_I(dentry->d_inode)->stale = 1;
-
 		goto out;
 	}
 	/* This should only happen if we found a whiteout. */
 	if (first_dentry_offset == -1) {
 		first_lower_dentry = lookup_one_len(name, lower_dir_dentry,
-						     namelen);
+						    namelen);
 		first_dentry_offset = bindex;
 		if (IS_ERR(first_lower_dentry)) {
 			err = PTR_ERR(first_lower_dentry);
 			goto out;
 		}
-		
-		/* FIXME: the following line needs to be changed to allow
+
+		/*
+		 * FIXME: the following line needs to be changed to allow
 		 * mount-point crossing
 		 */
 		first_dentry = dentry;
-		first_lower_mnt = unionfs_mntget(dentry, bindex);
+		first_lower_mnt = unionfs_mntget(dentry->d_sb->s_root,
+						 bindex);
 	}
 	unionfs_set_lower_dentry_idx(dentry, first_dentry_offset,
 				     first_lower_dentry);
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 9f3e68a..33c2137 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -459,18 +459,49 @@ static inline void unlock_dir(struct dentry *dir)
 static inline struct vfsmount *unionfs_mntget(struct dentry *dentry,
 					      int bindex)
 {
-	BUG_ON(!dentry || bindex < 0);
-
-	return mntget(unionfs_lower_mnt_idx(dentry, bindex));
+	struct vfsmount *mnt;
+
+	if (!dentry) {
+		if (bindex < 0)
+			return NULL;
+		if (!dentry && bindex >= 0) {
+			return NULL;
+		}
+	}
+	mnt = unionfs_lower_mnt_idx(dentry, bindex);
+	if (!mnt) {
+		if (bindex < 0)
+			return NULL;
+		if (!mnt && bindex >= 0) {
+			return NULL;
+		}
+	}
+	mnt = mntget(mnt);
+	return mnt;
 }
 
 static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 {
-	if (!dentry)
-		return;
+	struct vfsmount *mnt;
+
+	if (!dentry) {
+		if (bindex < 0)
+			return;
+		if (!dentry && bindex >= 0) {
+			return;
+		}
+	}
+	mnt = unionfs_lower_mnt_idx(dentry, bindex);
+	if (!mnt) {
+		if (bindex < 0)
+			return;
+		if (!mnt && bindex >= 0) {
+			return;
+		}
+	}
+	mntput(mnt);
+}
+
 
-	BUG_ON(bindex < 0);
 
-	mntput(unionfs_lower_mnt_idx(dentry, bindex));
-}
 #endif	/* not _UNION_H_ */
-- 
1.5.2.2.238.g7cbf2f2

