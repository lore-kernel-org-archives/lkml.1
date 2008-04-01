Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYDAVIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYDAVIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760948AbYDAVHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:41 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45578 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760455AbYDAVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:37 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Himanshu Kanda <hkanda@cs.sunysb.edu>
Subject: [PATCH 06/14] Unionfs: reduce number of whiteouts by deleting all instances of files
Date: Tue,  1 Apr 2008 17:06:48 -0400
Message-Id: <12070840193574-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize the unlinking of non-dir objects in unionfs by deleting all
possible lower inode objects from all writable lower branches.  This may
consume a bit more processing, but on average reduces overall inode
consumption and further saves a lot by reducing the total number of
whiteouts needed.  We create a whiteout now only if we could not delete all
lower objects, or if one of the lower branches was explicitly marked
read-only.

Signed-off-by: Himanshu Kanda <hkanda@cs.sunysb.edu>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/concepts.txt |   25 ++++++
 fs/unionfs/lookup.c                            |    8 +-
 fs/unionfs/unlink.c                            |  107 +++++++++++++++---------
 3 files changed, 97 insertions(+), 43 deletions(-)

diff --git a/Documentation/filesystems/unionfs/concepts.txt b/Documentation/filesystems/unionfs/concepts.txt
index 8d9a1c5..0bc1a19 100644
--- a/Documentation/filesystems/unionfs/concepts.txt
+++ b/Documentation/filesystems/unionfs/concepts.txt
@@ -62,6 +62,31 @@ simplest solution is to take the instance from the highest priority
 (numerically lowest value) and "hide" the others.
 
 
+Unlinking:
+=========
+
+Unlink operation on non-directory instances is optimized to remove the
+maximum possible objects in case multiple underlying branches have the same
+file name.  The unlink operation will first try to delete file instances
+from highest priority branch and then move further to delete from remaining
+branches in order of their decreasing priority.  Consider a case (F..D..F),
+where F is a file and D is a directory of the same name; here, some
+intermediate branch could have an empty directory instance with the same
+name, so this operation also tries to delete this directory instance and
+proceed further to delete from next possible lower priority branch.  The
+unionfs unlink operation will smoothly delete the files with same name from
+all possible underlying branches.  In case if some error occurs, it creates
+whiteout in highest priority branch that will hide file instance in rest of
+the branches.  An error could occur either if an unlink operations in any of
+the underlying branch failed or if a branch has no write permission.
+
+This unlinking policy is known as "delete all" and it has the benefit of
+overall reducing the number of inodes used by duplicate files, and further
+reducing the total number of inodes consumed by whiteouts.  The cost is of
+extra processing, but testing shows this extra processing is well worth the
+savings.
+
+
 Copyup:
 =======
 
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 755158e..7618716 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -264,7 +264,9 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		 * branches, but we have to skip non-dirs (to avoid, say,
 		 * calling readdir on a regular file).
 		 */
-		if (!S_ISDIR(lower_dentry->d_inode->i_mode) && dentry_count) {
+		if ((lookupmode != INTERPOSE_PARTIAL) &&
+		    !S_ISDIR(lower_dentry->d_inode->i_mode) &&
+		    dentry_count) {
 			dput(lower_dentry);
 			continue;
 		}
@@ -295,10 +297,6 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 				continue;
 			if (dentry_count == 1)
 				goto out_positive;
-			/* This can only happen with mixed D-*-F-* */
-			BUG_ON(!S_ISDIR(unionfs_lower_dentry(dentry)->
-					d_inode->i_mode));
-			continue;
 		}
 
 		opaque = is_opaque_dir(dentry, bindex);
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 6e93da3..c66bb3e 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -18,7 +18,32 @@
 
 #include "union.h"
 
-/* unlink a file by creating a whiteout */
+/*
+ * Helper function for Unionfs's unlink operation.
+ *
+ * The main goal of this function is to optimize the unlinking of non-dir
+ * objects in unionfs by deleting all possible lower inode objects from the
+ * underlying branches having same dentry name as the non-dir dentry on
+ * which this unlink operation is called.  This way we delete as many lower
+ * inodes as possible, and save space.  Whiteouts need to be created in
+ * branch0 only if unlinking fails on any of the lower branch other than
+ * branch0, or if a lower branch is marked read-only.
+ *
+ * Also, while unlinking a file, if we encounter any dir type entry in any
+ * intermediate branch, then we remove the directory by calling vfs_rmdir.
+ * The following special cases are also handled:
+
+ * (1) If an error occurs in branch0 during vfs_unlink, then we return
+ *     appropriate error.
+ *
+ * (2) If we get an error during unlink in any of other lower branch other
+ *     than branch0, then we create a whiteout in branch0.
+ *
+ * (3) If a whiteout already exists in any intermediate branch, we delete
+ *     all possible inodes only up to that branch (this is an "opaqueness"
+ *     as as per Documentation/filesystems/unionfs/concepts.txt).
+ *
+ */
 static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *lower_dentry;
@@ -30,51 +55,57 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 
-	bindex = dbstart(dentry);
-
-	lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-	if (!lower_dentry)
-		goto out;
+	/* trying to unlink all possible valid instances */
+	for (bindex = dbstart(dentry); bindex <= dbend(dentry); bindex++) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry || !lower_dentry->d_inode)
+			continue;
+
+		lower_dir_dentry = lock_parent(lower_dentry);
+
+		/* avoid destroying the lower inode if the object is in use */
+		dget(lower_dentry);
+		err = is_robranch_super(dentry->d_sb, bindex);
+		if (!err) {
+			/* see Documentation/filesystems/unionfs/issues.txt */
+			lockdep_off();
+			if (!S_ISDIR(lower_dentry->d_inode->i_mode))
+				err = vfs_unlink(lower_dir_dentry->d_inode,
+								lower_dentry);
+			else
+				err = vfs_rmdir(lower_dir_dentry->d_inode,
+								lower_dentry);
+			lockdep_on();
+		}
 
-	lower_dir_dentry = lock_parent(lower_dentry);
+		/* if lower object deletion succeeds, update inode's times */
+		if (!err)
+			unionfs_copy_attr_times(dentry->d_inode);
+		dput(lower_dentry);
+		fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
+		unlock_dir(lower_dir_dentry);
 
-	/* avoid destroying the lower inode if the file is in use */
-	dget(lower_dentry);
-	err = is_robranch_super(dentry->d_sb, bindex);
-	if (!err) {
-		/* see Documentation/filesystems/unionfs/issues.txt */
-		lockdep_off();
-		err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
-		lockdep_on();
+		if (err)
+			break;
 	}
-	/* if vfs_unlink succeeded, update our inode's times */
-	if (!err)
-		unionfs_copy_attr_times(dentry->d_inode);
-	dput(lower_dentry);
-	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
-	unlock_dir(lower_dir_dentry);
-
-	if (err && !IS_COPYUP_ERR(err))
-		goto out;
 
 	/*
-	 * We create whiteouts if (1) there was an error unlinking the main
-	 * file; (2) there is a lower priority file with the same name
-	 * (dbopaque); (3) the branch in which the file is not the last
-	 * (rightmost0 branch.  The last rule is an optimization to avoid
-	 * creating all those whiteouts if there's no chance they'd be
-	 * masking any lower-priority branch, as well as unionfs is used
-	 * with only one branch (using only one branch, while odd, is still
-	 * possible).
+	 * Create the whiteout in branch 0 (highest priority) only if (a)
+	 * there was an error in any intermediate branch other than branch 0
+	 * due to failure of vfs_unlink/vfs_rmdir or (b) a branch marked or
+	 * mounted read-only.
 	 */
 	if (err) {
-		if (dbstart(dentry) == 0)
+		if ((bindex == 0) ||
+		    ((bindex == dbstart(dentry)) &&
+		     (!IS_COPYUP_ERR(err))))
 			goto out;
-		err = create_whiteout(dentry, dbstart(dentry) - 1);
-	} else if (dbopaque(dentry) != -1) {
-		err = create_whiteout(dentry, dbopaque(dentry));
-	} else if (dbstart(dentry) < sbend(dentry->d_sb)) {
-		err = create_whiteout(dentry, dbstart(dentry));
+		else {
+			if (!IS_COPYUP_ERR(err))
+				pr_debug("unionfs: lower object deletion "
+					     "failed in branch:%d\n", bindex);
+			err = create_whiteout(dentry, sbstart(dentry->d_sb));
+		}
 	}
 
 out:
-- 
1.5.2.2

