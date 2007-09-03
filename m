Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbXICCg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbXICCg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932233AbXICC0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:20 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57719 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXICCZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:35 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 05/32] Unionfs: do not use fsstack_copy_attr_all
Date: Sun,  2 Sep 2007 22:20:28 -0400
Message-Id: <11887860561137-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Unionfs needs a special fan-out version of fsstack_copy_attr_all, which is
called unionfs_copy_attr_all.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   12 +++++++++---
 fs/unionfs/fanout.h |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/unionfs/inode.c  |   13 ++++++++-----
 fs/unionfs/main.c   |    2 +-
 fs/unionfs/subr.c   |    2 +-
 fs/unionfs/union.h  |    5 +++--
 6 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index f88a285..4a3c479 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -166,9 +166,15 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 		valid = 0;
 
 	if (valid) {
-		fsstack_copy_attr_all(dentry->d_inode,
-				      unionfs_lower_inode(dentry->d_inode),
-				      unionfs_get_nlinks);
+		/*
+		 * If we get here, and we copy the meta-data from the lower
+		 * inode to our inode, then it is vital that we have already
+		 * purged all unionfs-level file data.  We do that in the
+		 * caller (__unionfs_d_revalidate_chain) by calling
+		 * purge_inode_data.
+		 */
+		unionfs_copy_attr_all(dentry->d_inode,
+				      unionfs_lower_inode(dentry->d_inode));
 		fsstack_copy_inode_size(dentry->d_inode,
 					unionfs_lower_inode(dentry->d_inode));
 	}
diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 4da34c6..5908bc7 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -305,4 +305,52 @@ static inline void verify_locked(struct dentry *d)
 	BUG_ON(!mutex_is_locked(&UNIONFS_D(d)->lock));
 }
 
-#endif	/* _FANOUT_H */
+/* copy a/m/ctime from the lower branch with the newest times */
+static inline void unionfs_copy_attr_times(struct inode *upper)
+{
+	int bindex;
+	struct inode *lower;
+
+	if (!upper)
+		return;
+	for (bindex=ibstart(upper); bindex <= ibend(upper); bindex++) {
+		lower = unionfs_lower_inode_idx(upper, bindex);
+		if (!lower)
+			continue; /* not all lower dir objects may exist */
+		if (timespec_compare(&upper->i_mtime, &lower->i_mtime) < 0)
+			upper->i_mtime = lower->i_mtime;
+		if (timespec_compare(&upper->i_ctime, &lower->i_ctime) < 0)
+			upper->i_ctime = lower->i_ctime;
+		if (timespec_compare(&upper->i_atime, &lower->i_atime) < 0)
+			upper->i_atime = lower->i_atime;
+		/* XXX: should we notify_change on our upper inode? */
+	}
+}
+
+/*
+ * A unionfs/fanout version of fsstack_copy_attr_all.  Uses a
+ * unionfs_get_nlinks to properly calcluate the number of links to a file.
+ * Also, copies the max() of all a/m/ctimes for all lower inodes (which is
+ * important if the lower inode is a directory type)
+ */
+static inline void unionfs_copy_attr_all(struct inode *dest,
+					 const struct inode *src)
+{
+	dest->i_mode = src->i_mode;
+	dest->i_uid = src->i_uid;
+	dest->i_gid = src->i_gid;
+	dest->i_rdev = src->i_rdev;
+
+	unionfs_copy_attr_times(dest);
+
+	dest->i_blkbits = src->i_blkbits;
+	dest->i_flags = src->i_flags;
+
+	/*
+	 * Update the nlinks AFTER updating the above fields, because the
+	 * get_links callback may depend on them.
+	 */
+	dest->i_nlink = unionfs_get_nlinks(dest);
+}
+
+#endif	/* not _FANOUT_H */
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 59bb418..cbbde6f 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -369,12 +369,13 @@ check_link:
 	/* Its a hard link, so use the same inode */
 	new_dentry->d_inode = igrab(old_dentry->d_inode);
 	d_instantiate(new_dentry, new_dentry->d_inode);
-	fsstack_copy_attr_all(dir, lower_new_dentry->d_parent->d_inode,
-			      unionfs_get_nlinks);
+	unionfs_copy_attr_all(dir, lower_new_dentry->d_parent->d_inode);
 	fsstack_copy_inode_size(dir, lower_new_dentry->d_parent->d_inode);
 
 	/* propagate number of hard-links */
 	old_dentry->d_inode->i_nlink = unionfs_get_nlinks(old_dentry->d_inode);
+	/* new dentry's ctime may have changed due to hard-link counts */
+	unionfs_copy_attr_times(new_dentry->d_inode);
 
 out:
 	if (!new_dentry->d_inode)
@@ -1084,13 +1085,15 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	}
 
 	/* get the size from the first lower inode */
-	lower_inode = unionfs_lower_inode(dentry->d_inode);
-	fsstack_copy_attr_all(inode, lower_inode, unionfs_get_nlinks);
+	lower_inode = unionfs_lower_inode(inode);
+	unionfs_copy_attr_all(inode, lower_inode);
 	fsstack_copy_inode_size(inode, lower_inode);
-
+	/* if setattr succeeded, then parent dir may have changed */
+	unionfs_copy_attr_times(dentry->d_parent->d_inode);
 out:
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
+
 	return err;
 }
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 1ea7894..689a8fa 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -123,7 +123,7 @@ int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 				   lower_inode->i_rdev);
 
 	/* all well, copy inode attributes */
-	fsstack_copy_attr_all(inode, lower_inode, unionfs_get_nlinks);
+	unionfs_copy_attr_all(inode, lower_inode);
 	fsstack_copy_inode_size(inode, lower_inode);
 
 skip:
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 0c8b0aa..3cebc17 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -179,7 +179,7 @@ out:
  * returns the sum of the n_link values of all the underlying inodes of the
  * passed inode
  */
-int unionfs_get_nlinks(struct inode *inode)
+int unionfs_get_nlinks(const struct inode *inode)
 {
 	int sum_nlinks = 0;
 	int dirs = 0;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index e4ee3c1..2a8f763 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -186,6 +186,9 @@ struct unionfs_dir_state {
 	struct list_head list[0];
 };
 
+/* externs needed for fanout.h or sioq.h */
+extern int unionfs_get_nlinks(const struct inode *inode);
+
 /* include miscellaneous macros */
 #include "fanout.h"
 #include "sioq.h"
@@ -282,8 +285,6 @@ extern int remove_whiteouts(struct dentry *dentry,
 extern int do_delete_whiteouts(struct dentry *dentry, int bindex,
 			       struct unionfs_dir_state *namelist);
 
-extern int unionfs_get_nlinks(struct inode *inode);
-
 /* Is this directory empty: 0 if it is empty, -ENOTEMPTY if not. */
 extern int check_empty(struct dentry *dentry,
 		       struct unionfs_dir_state **namelist);
-- 
1.5.2.2.238.g7cbf2f2

