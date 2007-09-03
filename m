Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbXICCdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbXICCdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932340AbXICCZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57681 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbXICCY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:58 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 13/32] Unionfs: copyup updates
Date: Sun,  2 Sep 2007 22:20:36 -0400
Message-Id: <1188786057299-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Fixes, updates, and better documentation for the file-copyup functionality.
Include two additional utility functions useful for copyup code callers.
Parent directory copyup updates: create_parents now takes a string name
instead of the whole dentry.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |  135 +++++++++++--------
 fs/unionfs/copyup.c     |  348 +++++++++++++++++++++++++++-------------------
 fs/unionfs/inode.c      |   33 ++++--
 fs/unionfs/rename.c     |   26 +++--
 fs/unionfs/subr.c       |    4 +-
 fs/unionfs/union.h      |   11 +-
 fs/unionfs/unlink.c     |    2 +
 7 files changed, 338 insertions(+), 221 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index edb52c0..64bd0bd 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -31,7 +31,6 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 	const int countersize = sizeof(counter) * 2;
 	const int nlen = sizeof(".unionfs") + i_inosize + countersize - 1;
 	char name[nlen + 1];
-
 	int err;
 	struct dentry *tmp_dentry = NULL;
 	struct dentry *lower_dentry;
@@ -42,7 +41,6 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 	sprintf(name, ".unionfs%*.*lx",
 		i_inosize, i_inosize, lower_dentry->d_inode->i_ino);
 
-retry:
 	/*
 	 * Loop, looking for an unused temp name to copyup to.
 	 *
@@ -52,6 +50,7 @@ retry:
 	 * the name exists in the dest branch, but it'd be nice to catch it
 	 * sooner than later.
 	 */
+retry:
 	tmp_dentry = NULL;
 	do {
 		char *suffix = name + nlen - countersize;
@@ -73,14 +72,20 @@ retry:
 	dput(tmp_dentry);
 
 	err = copyup_named_file(dentry->d_parent->d_inode, file, name, bstart,
-				bindex, file->f_dentry->d_inode->i_size);
-	if (err == -EEXIST)
-		goto retry;
-	else if (err)
+				bindex, file->f_path.dentry->d_inode->i_size);
+	if (err) {
+		if (err == -EEXIST)
+			goto retry;
 		goto out;
+	}
 
 	/* bring it to the same state as an unlinked file */
 	lower_dentry = unionfs_lower_dentry_idx(dentry, dbstart(dentry));
+	if (!unionfs_lower_inode_idx(dentry->d_inode, bindex)) {
+		atomic_inc(&lower_dentry->d_inode->i_count);
+		unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
+					    lower_dentry->d_inode);
+	}
 	lower_dir_dentry = lock_parent(lower_dentry);
 	err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
 	unlock_dir(lower_dir_dentry);
@@ -96,48 +101,52 @@ out:
 static void cleanup_file(struct file *file)
 {
 	int bindex, bstart, bend;
-	struct file **lf;
-	struct super_block *sb = file->f_dentry->d_sb;
+	struct file **lower_files;
+	struct file *lower_file;
+	struct super_block *sb = file->f_path.dentry->d_sb;
 
-	lf = UNIONFS_F(file)->lower_files;
+	lower_files = UNIONFS_F(file)->lower_files;
 	bstart = fbstart(file);
 	bend = fbend(file);
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		if (unionfs_lower_file_idx(file, bindex)) {
-			/*
-			 * Find new index of matching branch with an open
-			 * file, since branches could have been added or
-			 * deleted causing the one with open files to shift.
-			 */
-			int i;	/* holds (possibly) updated branch index */
-			int old_bid;
-
-			old_bid = UNIONFS_F(file)->saved_branch_ids[bindex];
-			i = branch_id_to_idx(sb, old_bid);
-			if (i < 0)
-				printk(KERN_ERR "unionfs: no superblock for "
-				       "file %p\n", file);
-			else {
-				/* decrement count of open files */
-				branchput(sb, i);
-				/*
-				 * fput will perform an mntput for us on the
-				 * correct branch.  Although we're using the
-				 * file's old branch configuration, bindex,
-				 * which is the old index, correctly points
-				 * to the right branch in the file's branch
-				 * list.  In other words, we're going to
-				 * mntput the correct branch even if
-				 * branches have been added/removed.
-				 */
-				fput(unionfs_lower_file_idx(file, bindex));
-			}
+		int i;	/* holds (possibly) updated branch index */
+		int old_bid;
+
+		lower_file = unionfs_lower_file_idx(file, bindex);
+		if (!lower_file)
+			continue;
+
+		/*
+		 * Find new index of matching branch with an open
+		 * file, since branches could have been added or
+		 * deleted causing the one with open files to shift.
+		 */
+		old_bid = UNIONFS_F(file)->saved_branch_ids[bindex];
+		i = branch_id_to_idx(sb, old_bid);
+		if (i < 0) {
+			printk(KERN_ERR "unionfs: no superblock for "
+			       "file %p\n", file);
+			continue;
 		}
+
+		/* decrement count of open files */
+		branchput(sb, i);
+		/*
+		 * fput will perform an mntput for us on the correct branch.
+		 * Although we're using the file's old branch configuration,
+		 * bindex, which is the old index, correctly points to the
+		 * right branch in the file's branch list.  In other words,
+		 * we're going to mntput the correct branch even if branches
+		 * have been added/removed.
+		 */
+		fput(lower_file);
+		UNIONFS_F(file)->lower_files[bindex] = NULL;
+		UNIONFS_F(file)->saved_branch_ids[bindex] = -1;
 	}
 
 	UNIONFS_F(file)->lower_files = NULL;
-	kfree(lf);
+	kfree(lower_files);
 	kfree(UNIONFS_F(file)->saved_branch_ids);
 	/* set to NULL because caller needs to know if to kfree on error */
 	UNIONFS_F(file)->saved_branch_ids = NULL;
@@ -209,7 +218,6 @@ static int open_highest_file(struct file *file, int willwrite)
 
 	dget(lower_dentry);
 	unionfs_mntget(dentry, bstart);
-	branchget(sb, bstart);
 	lower_file = dentry_open(lower_dentry,
 				 unionfs_lower_mnt_idx(dentry, bstart),
 				 file->f_flags);
@@ -217,6 +225,7 @@ static int open_highest_file(struct file *file, int willwrite)
 		err = PTR_ERR(lower_file);
 		goto out;
 	}
+	branchget(sb, bstart);
 	unionfs_set_lower_file(file, lower_file);
 	/* Fix up the position. */
 	lower_file->f_pos = file->f_pos;
@@ -227,19 +236,20 @@ out:
 }
 
 /* perform a delayed copyup of a read-write file on a read-only branch */
-static int do_delayed_copyup(struct file *file, struct dentry *dentry)
+static int do_delayed_copyup(struct file *file)
 {
 	int bindex, bstart, bend, err = 0;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *parent_inode = dentry->d_parent->d_inode;
-	loff_t inode_size = file->f_dentry->d_inode->i_size;
+	loff_t inode_size = dentry->d_inode->i_size;
 
 	bstart = fbstart(file);
 	bend = fbend(file);
 
-	BUG_ON(!S_ISREG(file->f_dentry->d_inode->i_mode));
+	BUG_ON(!S_ISREG(dentry->d_inode->i_mode));
 
 	for (bindex = bstart - 1; bindex >= 0; bindex--) {
-		if (!d_deleted(file->f_dentry))
+		if (!d_deleted(dentry))
 			err = copyup_file(parent_inode, file, bstart,
 					  bindex, inode_size);
 		else
@@ -249,17 +259,34 @@ static int do_delayed_copyup(struct file *file, struct dentry *dentry)
 		if (!err)
 			break;
 	}
-	if (!err && (bstart > fbstart(file))) {
-		bend = fbend(file);
-		for (bindex = bstart; bindex <= bend; bindex++) {
-			if (unionfs_lower_file_idx(file, bindex)) {
-				branchput(dentry->d_sb, bindex);
-				fput(unionfs_lower_file_idx(file, bindex));
-				unionfs_set_lower_file_idx(file, bindex, NULL);
-			}
+	if (err || (bstart <= fbstart(file)))
+		goto out;
+	bend = fbend(file);
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		if (unionfs_lower_file_idx(file, bindex)) {
+			branchput(dentry->d_sb, bindex);
+			fput(unionfs_lower_file_idx(file, bindex));
+			unionfs_set_lower_file_idx(file, bindex, NULL);
+		}
+		if (unionfs_lower_mnt_idx(dentry, bindex)) {
+			unionfs_mntput(dentry, bindex);
+			unionfs_set_lower_mnt_idx(dentry, bindex, NULL);
+		}
+		if (unionfs_lower_dentry_idx(dentry, bindex)) {
+			BUG_ON(!dentry->d_inode);
+			iput(unionfs_lower_inode_idx(dentry->d_inode, bindex));
+			unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
+						    NULL);
+			dput(unionfs_lower_dentry_idx(dentry, bindex));
+			unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
 		}
-		fbend(file) = bend;
 	}
+	/* for reg file, we only open it "once" */
+	fbend(file) = fbstart(file);
+	set_dbend(dentry, dbstart(dentry));
+	ibend(dentry->d_inode) = ibstart(dentry->d_inode);
+
+out:
 	return err;
 }
 
@@ -348,7 +375,7 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	    is_robranch(dentry)) {
 		printk(KERN_DEBUG "unionfs: Doing delayed copyup of a "
 		       "read-write file on a read-only branch.\n");
-		err = do_delayed_copyup(file, dentry);
+		err = do_delayed_copyup(file);
 	}
 
 out:
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 410ce07..9c476cd 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -23,15 +23,6 @@
  * Documentation/filesystems/unionfs/concepts.txt
  */
 
-/* forward definitions */
-static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
-			       int bstart, int new_bindex, const char *name,
-			       int namelen, struct file **copyup_file,
-			       loff_t len);
-static struct dentry *create_parents_named(struct inode *dir,
-					   struct dentry *dentry,
-					   const char *name, int bindex);
-
 #ifdef CONFIG_UNION_FS_XATTR
 /* copyup all extended attrs for a given dentry */
 static int copyup_xattrs(struct dentry *old_lower_dentry,
@@ -101,7 +92,14 @@ out:
 }
 #endif /* CONFIG_UNION_FS_XATTR */
 
-/* Determine the mode based on the copyup flags, and the existing dentry. */
+/*
+ * Determine the mode based on the copyup flags, and the existing dentry.
+ *
+ * Handle file systems which may not support certain options.  For example
+ * jffs2 doesn't allow one to chmod a symlink.  So we ignore such harmless
+ * errors, rather than propagating them up, which results in copyup errors
+ * and errors returned back to users.
+ */
 static int copyup_permissions(struct super_block *sb,
 			      struct dentry *old_lower_dentry,
 			      struct dentry *new_lower_dentry)
@@ -113,30 +111,31 @@ static int copyup_permissions(struct super_block *sb,
 	newattrs.ia_atime = i->i_atime;
 	newattrs.ia_mtime = i->i_mtime;
 	newattrs.ia_ctime = i->i_ctime;
-
 	newattrs.ia_gid = i->i_gid;
 	newattrs.ia_uid = i->i_uid;
-
-	newattrs.ia_mode = i->i_mode;
-
 	newattrs.ia_valid = ATTR_CTIME | ATTR_ATIME | ATTR_MTIME |
 		ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_FORCE |
-		ATTR_GID | ATTR_UID | ATTR_MODE;
+		ATTR_GID | ATTR_UID;
+	err = notify_change(new_lower_dentry, &newattrs);
+	if (err)
+		goto out;
 
+	/* now try to change the mode and ignore EOPNOTSUPP on symlinks */
+	newattrs.ia_mode = i->i_mode;
+	newattrs.ia_valid = ATTR_MODE | ATTR_FORCE;
 	err = notify_change(new_lower_dentry, &newattrs);
+	if (err == -EOPNOTSUPP &&
+	    S_ISLNK(new_lower_dentry->d_inode->i_mode)) {
+		printk(KERN_WARNING
+		       "unionfs: changing \"%s\" symlink mode unsupported\n",
+		       new_lower_dentry->d_name.name);
+		err = 0;
+	}
 
+out:
 	return err;
 }
 
-int copyup_dentry(struct inode *dir, struct dentry *dentry,
-		  int bstart, int new_bindex,
-		  struct file **copyup_file, loff_t len)
-{
-	return copyup_named_dentry(dir, dentry, bstart, new_bindex,
-				   dentry->d_name.name,
-				   dentry->d_name.len, copyup_file, len);
-}
-
 /*
  * create the new device/file/directory - use copyup_permission to copyup
  * times, and mode
@@ -202,6 +201,7 @@ static int __copyup_reg_data(struct dentry *dentry,
 	struct super_block *sb = dentry->d_sb;
 	struct file *input_file;
 	struct file *output_file;
+	struct vfsmount *output_mnt;
 	mm_segment_t old_fs;
 	char *buf = NULL;
 	ssize_t read_bytes, write_bytes;
@@ -211,6 +211,7 @@ static int __copyup_reg_data(struct dentry *dentry,
 	/* open old file */
 	unionfs_mntget(dentry, old_bindex);
 	branchget(sb, old_bindex);
+	/* dentry_open calls dput and mntput if it returns an error */
 	input_file = dentry_open(old_lower_dentry,
 				 unionfs_lower_mnt_idx(dentry, old_bindex),
 				 O_RDONLY | O_LARGEFILE);
@@ -226,10 +227,9 @@ static int __copyup_reg_data(struct dentry *dentry,
 
 	/* open new file */
 	dget(new_lower_dentry);
-	unionfs_mntget(dentry, new_bindex);
+	output_mnt = unionfs_mntget(sb->s_root, new_bindex);
 	branchget(sb, new_bindex);
-	output_file = dentry_open(new_lower_dentry,
-				  unionfs_lower_mnt_idx(dentry, new_bindex),
+	output_file = dentry_open(new_lower_dentry, output_mnt,
 				  O_RDWR | O_LARGEFILE);
 	if (IS_ERR(output_file)) {
 		err = PTR_ERR(output_file);
@@ -331,11 +331,21 @@ static void __clear(struct dentry *dentry, struct dentry *old_lower_dentry,
 	dput(old_lower_dentry);
 }
 
-/* copy up a dentry to a file of specified name */
-static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
-			       int bstart, int new_bindex, const char *name,
-			       int namelen, struct file **copyup_file,
-			       loff_t len)
+/*
+ * Copy up a dentry to a file of specified name.
+ *
+ * @dir: used to pull the ->i_sb to access other branches
+ * @dentry: the non-negative dentry whose lower_inode we should copy
+ * @bstart: the branch of the lower_inode to copy from
+ * @new_bindex: the branch to create the new file in
+ * @name: the name of the file to create
+ * @namelen: length of @name
+ * @copyup_file: the "struct file" to return (optional)
+ * @len: how many bytes to copy-up?
+ */
+int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
+		  int new_bindex, const char *name, int namelen,
+		  struct file **copyup_file, loff_t len)
 {
 	struct dentry *new_lower_dentry;
 	struct dentry *old_lower_dentry = NULL;
@@ -363,8 +373,7 @@ static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	/* Create the directory structure above this dentry. */
-	new_lower_dentry =
-		create_parents_named(dir, dentry, name, new_bindex);
+	new_lower_dentry = create_parents(dir, dentry, name, new_bindex);
 	if (IS_ERR(new_lower_dentry)) {
 		err = PTR_ERR(new_lower_dentry);
 		goto out;
@@ -479,6 +488,25 @@ out_free:
 		dput(old_lower_dentry);
 	kfree(symbuf);
 
+	if (err)
+		goto out;
+	if (!S_ISDIR(dentry->d_inode->i_mode)) {
+		unionfs_postcopyup_release(dentry);
+		if (!unionfs_lower_inode(dentry->d_inode)) {
+			/*
+			 * If we got here, then we copied up to an
+			 * unlinked-open file, whose name is .unionfsXXXXX.
+			 */
+			struct inode *inode = new_lower_dentry->d_inode;
+			atomic_inc(&inode->i_count);
+			unionfs_set_lower_inode_idx(dentry->d_inode,
+						    ibstart(dentry->d_inode),
+						    inode);
+		}
+	}
+	unionfs_postcopyup_setmnt(dentry);
+	/* sync inode times from copied-up inode to our inode */
+	unionfs_copy_attr_times(dentry->d_inode);
 out:
 	return err;
 }
@@ -494,9 +522,8 @@ int copyup_named_file(struct inode *dir, struct file *file, char *name,
 	int err = 0;
 	struct file *output_file = NULL;
 
-	err = copyup_named_dentry(dir, file->f_dentry, bstart,
-				  new_bindex, name, strlen(name), &output_file,
-				  len);
+	err = copyup_dentry(dir, file->f_path.dentry, bstart, new_bindex,
+			    name, strlen(name), &output_file, len);
 	if (!err) {
 		fbstart(file) = new_bindex;
 		unionfs_set_lower_file_idx(file, new_bindex, output_file);
@@ -514,8 +541,10 @@ int copyup_file(struct inode *dir, struct file *file, int bstart,
 {
 	int err = 0;
 	struct file *output_file = NULL;
+	struct dentry *dentry = file->f_path.dentry;
 
-	err = copyup_dentry(dir, file->f_dentry, bstart, new_bindex,
+	err = copyup_dentry(dir, dentry, bstart, new_bindex,
+			    dentry->d_name.name, dentry->d_name.len,
 			    &output_file, len);
 	if (!err) {
 		fbstart(file) = new_bindex;
@@ -525,17 +554,6 @@ int copyup_file(struct inode *dir, struct file *file, int bstart,
 	return err;
 }
 
-/*
- * This function replicates the directory structure up-to given dentry in the
- * bindex branch. Can create directory structure recursively to the right
- * also.
- */
-struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
-			      int bindex)
-{
-	return create_parents_named(dir, dentry, dentry->d_name.name, bindex);
-}
-
 /* purge a dentry's lower-branch states (dput/mntput, etc.) */
 static void __cleanup_dentry(struct dentry *dentry, int bindex,
 			     int old_bstart, int old_bend)
@@ -615,9 +633,8 @@ static void __set_dentry(struct dentry *upper, struct dentry *lower,
  * This function replicates the directory structure up-to given dentry
  * in the bindex branch.
  */
-static struct dentry *create_parents_named(struct inode *dir,
-					   struct dentry *dentry,
-					   const char *name, int bindex)
+struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
+			      const char *name, int bindex)
 {
 	int err;
 	struct dentry *child_dentry;
@@ -626,10 +643,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 	struct dentry *lower_dentry = NULL;
 	const char *childname;
 	unsigned int childnamelen;
-
 	int nr_dentry;
 	int count = 0;
-
 	int old_bstart;
 	int old_bend;
 	struct dentry **path = NULL;
@@ -681,7 +696,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 			void *p;
 
 			nr_dentry *= 2;
-			p = krealloc(path, nr_dentry * sizeof(struct dentry *), GFP_KERNEL);
+			p = krealloc(path, nr_dentry * sizeof(struct dentry *),
+				     GFP_KERNEL);
 			if (!p) {
 				lower_dentry = ERR_PTR(-ENOMEM);
 				goto out;
@@ -697,106 +713,100 @@ static struct dentry *create_parents_named(struct inode *dir,
 	sb = dentry->d_sb;
 
 	/*
-	 * This is basically while(child_dentry != dentry).  This loop is
-	 * horrible to follow and should be replaced with cleaner code.
+	 * This code goes between the begin/end labels and basically
+	 * emulates a while(child_dentry != dentry), only cleaner and
+	 * shorter than what would be a much longer while loop.
 	 */
-	while (1) {
-		/* get lower parent dir in the current branch */
-		lower_parent_dentry =
-			unionfs_lower_dentry_idx(parent_dentry, bindex);
-		unionfs_unlock_dentry(parent_dentry);
-
-		/* init the values to lookup */
-		childname = child_dentry->d_name.name;
-		childnamelen = child_dentry->d_name.len;
-
-		if (child_dentry != dentry) {
-			/* lookup child in the underlying file system */
-			lower_dentry =
-				lookup_one_len(childname, lower_parent_dentry,
-					       childnamelen);
-			if (IS_ERR(lower_dentry))
-				goto out;
-		} else {
+begin:
+	/* get lower parent dir in the current branch */
+	lower_parent_dentry = unionfs_lower_dentry_idx(parent_dentry, bindex);
+	unionfs_unlock_dentry(parent_dentry);
+
+	/* init the values to lookup */
+	childname = child_dentry->d_name.name;
+	childnamelen = child_dentry->d_name.len;
+
+	if (child_dentry != dentry) {
+		/* lookup child in the underlying file system */
+		lower_dentry = lookup_one_len(childname, lower_parent_dentry,
+					      childnamelen);
+		if (IS_ERR(lower_dentry))
+			goto out;
+	} else {
+		/*
+		 * Is the name a whiteout of the child name ?  lookup the
+		 * whiteout child in the underlying file system
+		 */
+		lower_dentry = lookup_one_len(name, lower_parent_dentry,
+					      strlen(name));
+		if (IS_ERR(lower_dentry))
+			goto out;
 
-			/*
-			 * is the name a whiteout of the child name ?
-			 * lookup the whiteout child in the underlying file
-			 * system
-			 */
-			lower_dentry =
-				lookup_one_len(name, lower_parent_dentry,
-					       strlen(name));
-			if (IS_ERR(lower_dentry))
-				goto out;
+		/* Replace the current dentry (if any) with the new one */
+		dput(unionfs_lower_dentry_idx(dentry, bindex));
+		unionfs_set_lower_dentry_idx(dentry, bindex,
+					     lower_dentry);
 
-			/*
-			 * Replace the current dentry (if any) with the new
-			 * one.
-			 */
-			dput(unionfs_lower_dentry_idx(dentry, bindex));
-			unionfs_set_lower_dentry_idx(dentry, bindex,
-						     lower_dentry);
+		__cleanup_dentry(dentry, bindex, old_bstart, old_bend);
+		goto out;
+	}
 
-			__cleanup_dentry(dentry, bindex, old_bstart, old_bend);
-			break;
-		}
+	if (lower_dentry->d_inode) {
+		/*
+		 * since this already exists we dput to avoid
+		 * multiple references on the same dentry
+		 */
+		dput(lower_dentry);
+	} else {
+		struct sioq_args args;
+
+		/* it's a negative dentry, create a new dir */
+		lower_parent_dentry = lock_parent(lower_dentry);
+
+		args.mkdir.parent = lower_parent_dentry->d_inode;
+		args.mkdir.dentry = lower_dentry;
+		args.mkdir.mode = child_dentry->d_inode->i_mode;
+
+		run_sioq(__unionfs_mkdir, &args);
+		err = args.err;
 
-		if (lower_dentry->d_inode) {
+		if (!err)
+			err = copyup_permissions(dir->i_sb, child_dentry,
+						 lower_dentry);
+		unlock_dir(lower_parent_dentry);
+		if (err) {
+			struct inode *inode = lower_dentry->d_inode;
 			/*
-			 * since this already exists we dput to avoid
-			 * multiple references on the same dentry
+			 * If we get here, it means that we created a new
+			 * dentry+inode, but copying permissions failed.
+			 * Therefore, we should delete this inode and dput
+			 * the dentry so as not to leave cruft behind.
 			 */
+			if (lower_dentry->d_op && lower_dentry->d_op->d_iput)
+				lower_dentry->d_op->d_iput(lower_dentry,
+							   inode);
+			else
+				iput(inode);
+			lower_dentry->d_inode = NULL;
 			dput(lower_dentry);
-		} else {
-			struct sioq_args args;
-
-			/* its a negative dentry, create a new dir */
-			lower_parent_dentry = lock_parent(lower_dentry);
-
-			args.mkdir.parent = lower_parent_dentry->d_inode;
-			args.mkdir.dentry = lower_dentry;
-			args.mkdir.mode = child_dentry->d_inode->i_mode;
-
-			run_sioq(__unionfs_mkdir, &args);
-			err = args.err;
-
-			if (!err)
-				err = copyup_permissions(dir->i_sb,
-							 child_dentry,
-							 lower_dentry);
-			unlock_dir(lower_parent_dentry);
-			if (err) {
-				struct inode *inode = lower_dentry->d_inode;
-				/*
-				 * If we get here, it means that we created a new
-				 * dentry+inode, but copying permissions failed.
-				 * Therefore, we should delete this inode and dput
-				 * the dentry so as not to leave cruft behind.
-				 *
-				 * XXX: call dentry_iput() instead, but then we have
-				 * to export that symbol.
-				 */
-				if (lower_dentry->d_op && lower_dentry->d_op->d_iput)
-					lower_dentry->d_op->d_iput(lower_dentry,
-								   inode);
-				else
-					iput(inode);
-				lower_dentry->d_inode = NULL;
-
-				dput(lower_dentry);
-				lower_dentry = ERR_PTR(err);
-				goto out;
-			}
-
+			lower_dentry = ERR_PTR(err);
+			goto out;
 		}
 
-		__set_inode(child_dentry, lower_dentry, bindex);
-		__set_dentry(child_dentry, lower_dentry, bindex);
-
-		parent_dentry = child_dentry;
-		child_dentry = path[--count];
 	}
+
+	__set_inode(child_dentry, lower_dentry, bindex);
+	__set_dentry(child_dentry, lower_dentry, bindex);
+	/*
+	 * update times of this dentry, but also the parent, because if
+	 * we changed, the parent may have changed too.
+	 */
+	unionfs_copy_attr_times(parent_dentry->d_inode);
+	unionfs_copy_attr_times(child_dentry->d_inode);
+
+	parent_dentry = child_dentry;
+	child_dentry = path[--count];
+	goto begin;
 out:
 	/* cleanup any leftover locks from the do/while loop above */
 	if (IS_ERR(lower_dentry))
@@ -805,3 +815,53 @@ out:
 	kfree(path);
 	return lower_dentry;
 }
+
+/*
+ * Post-copyup helper to ensure we have valid mnts: set lower mnt of
+ * dentry+parents to the first parent node that has an mnt.
+ */
+void unionfs_postcopyup_setmnt(struct dentry *dentry)
+{
+	struct dentry *parent, *hasone;
+	int bindex = dbstart(dentry);
+
+	if (unionfs_lower_mnt_idx(dentry, bindex))
+		return;
+	hasone = dentry->d_parent;
+	/* this loop should stop at root dentry */
+	while (!unionfs_lower_mnt_idx(hasone, bindex))
+		hasone = hasone->d_parent;
+	parent = dentry;
+	while (!unionfs_lower_mnt_idx(parent, bindex)) {
+		unionfs_set_lower_mnt_idx(parent, bindex,
+					  unionfs_mntget(hasone, bindex));
+		parent = parent->d_parent;
+	}
+}
+
+/*
+ * Post-copyup helper to release all non-directory source objects of a
+ * copied-up file.  Regular files should have only one lower object.
+ */
+void unionfs_postcopyup_release(struct dentry *dentry)
+{
+	int bindex;
+
+	BUG_ON(S_ISDIR(dentry->d_inode->i_mode));
+	for (bindex=dbstart(dentry)+1; bindex<=dbend(dentry); bindex++) {
+		if (unionfs_lower_mnt_idx(dentry, bindex)) {
+			unionfs_mntput(dentry, bindex);
+			unionfs_set_lower_mnt_idx(dentry, bindex, NULL);
+		}
+		if (unionfs_lower_dentry_idx(dentry, bindex)) {
+			dput(unionfs_lower_dentry_idx(dentry, bindex));
+			unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
+			iput(unionfs_lower_inode_idx(dentry->d_inode, bindex));
+			unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
+						    NULL);
+		}
+	}
+	bindex = dbstart(dentry);
+	set_dbend(dentry, bindex);
+	ibend(dentry->d_inode) = ibstart(dentry->d_inode) = bindex;
+}
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 4789fd5..6cec564 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -167,7 +167,9 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			 * because lookup passed as a negative unionfs dentry
 			 * pointing to a lone negative underlying dentry.
 			 */
-			lower_dentry = create_parents(parent, dentry, bindex);
+			lower_dentry = create_parents(parent, dentry,
+						      dentry->d_name.name,
+						      bindex);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				if (IS_ERR(lower_dentry))
 					err = PTR_ERR(lower_dentry);
@@ -321,8 +323,9 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 	if (dbstart(old_dentry) != dbstart(new_dentry)) {
-		lower_new_dentry =
-			create_parents(dir, new_dentry, dbstart(old_dentry));
+		lower_new_dentry = create_parents(dir, new_dentry,
+						  new_dentry->d_name.name,
+						  dbstart(old_dentry));
 		err = PTR_ERR(lower_new_dentry);
 		if (IS_COPYUP_ERR(err))
 			goto docopyup;
@@ -347,11 +350,13 @@ docopyup:
 		for (bindex = old_bstart - 1; bindex >= 0; bindex--) {
 			err = copyup_dentry(old_dentry->d_parent->d_inode,
 					    old_dentry, old_bstart,
-					    bindex, NULL,
+					    bindex, old_dentry->d_name.name,
+					    old_dentry->d_name.len, NULL,
 					    old_dentry->d_inode->i_size);
 			if (!err) {
 				lower_new_dentry =
 					create_parents(dir, new_dentry,
+						       new_dentry->d_name.name,
 						       bindex);
 				lower_old_dentry =
 					unionfs_lower_dentry(old_dentry);
@@ -388,6 +393,8 @@ out:
 		d_drop(new_dentry);
 
 	kfree(name);
+	if (!err)
+		unionfs_postcopyup_setmnt(new_dentry);
 
 	unionfs_unlock_dentry(new_dentry);
 	unionfs_unlock_dentry(old_dentry);
@@ -488,7 +495,9 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 			 * unionfs dentry pointing to a lone negative
 			 * underlying dentry
 			 */
-			lower_dentry = create_parents(dir, dentry, bindex);
+			lower_dentry = create_parents(dir, dentry,
+						      dentry->d_name.name,
+						      bindex);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				if (IS_ERR(lower_dentry))
 					err = PTR_ERR(lower_dentry);
@@ -621,7 +630,9 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 		if (!lower_dentry) {
-			lower_dentry = create_parents(parent, dentry, bindex);
+			lower_dentry = create_parents(parent, dentry,
+						      dentry->d_name.name,
+						      bindex);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				printk(KERN_DEBUG "unionfs: lower dentry "
 				       " NULL for bindex = %d\n", bindex);
@@ -759,7 +770,9 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 		if (!lower_dentry) {
-			lower_dentry = create_parents(dir, dentry, bindex);
+			lower_dentry = create_parents(dir, dentry,
+						      dentry->d_name.name,
+						      bindex);
 			if (IS_ERR(lower_dentry)) {
 				printk(KERN_DEBUG "unionfs: failed to create "
 				       "parents on %d, err = %ld\n",
@@ -1068,8 +1081,10 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 				if (ia->ia_valid & ATTR_SIZE)
 					size = ia->ia_size;
 				err = copyup_dentry(dentry->d_parent->d_inode,
-						    dentry, bstart, i, NULL,
-						    size);
+						    dentry, bstart, i,
+						    dentry->d_name.name,
+						    dentry->d_name.len,
+						    NULL, size);
 
 				if (!err) {
 					copyup = 1;
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index f8ea37a..acf829a 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -37,7 +37,8 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!lower_new_dentry) {
 		lower_new_dentry =
 			create_parents(new_dentry->d_parent->d_inode,
-				       new_dentry, bindex);
+				       new_dentry, new_dentry->d_name.name,
+				       bindex);
 		if (IS_ERR(lower_new_dentry)) {
 			printk(KERN_DEBUG "unionfs: error creating directory "
 			       "tree for rename, bindex = %d, err = %ld\n",
@@ -226,15 +227,18 @@ static int do_unionfs_rename(struct inode *old_dir,
 			 */
 			err = copyup_dentry(old_dentry->d_parent->d_inode,
 					    old_dentry, old_bstart, bindex,
+					    old_dentry->d_name.name,
+					    old_dentry->d_name.len,
 					    NULL, old_dentry->d_inode->i_size);
-			if (!err) {
-				dput(wh_old);
-				bwh_old = bindex;
-				err = __unionfs_rename(old_dir, old_dentry,
-						       new_dir, new_dentry,
-						       bindex, &wh_old);
-				break;
-			}
+			/* if copyup failed, try next branch to the left */
+			if (err)
+				continue;
+			dput(wh_old);
+			bwh_old = bindex;
+			err = __unionfs_rename(old_dir, old_dentry,
+					       new_dir, new_dentry,
+					       bindex, &wh_old);
+			break;
 		}
 	}
 
@@ -468,8 +472,12 @@ out:
 		 */
 		if (S_ISDIR(old_dentry->d_inode->i_mode))
 			atomic_dec(&UNIONFS_D(old_dentry)->generation);
+		else
+			unionfs_postcopyup_release(old_dentry);
 		if (new_dentry->d_inode &&
 		    !S_ISDIR(new_dentry->d_inode->i_mode)) {
+			unionfs_postcopyup_release(new_dentry);
+			unionfs_postcopyup_setmnt(new_dentry);
 			if (!unionfs_lower_inode(new_dentry->d_inode)) {
 				/*
 				 * If we get here, it means that no copyup
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 3cebc17..5db9e62 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -56,7 +56,9 @@ int create_whiteout(struct dentry *dentry, int start)
 			 * this dentry.
 			 */
 			lower_dentry = create_parents(dentry->d_inode,
-						      dentry, bindex);
+						      dentry,
+						      dentry->d_name.name,
+						      bindex);
 			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				printk(KERN_DEBUG "unionfs: create_parents "
 				       "failed for bindex = %d\n", bindex);
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index a9f9b97..f8a9cd2 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -255,7 +255,7 @@ extern void update_bstart(struct dentry *dentry);
 
 /* replicates the directory structure up to given dentry in given branch */
 extern struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
-				     int bindex);
+				     const char *name, int bindex);
 extern int make_dir_opaque(struct dentry *dir, int bindex);
 
 /* partial lookup */
@@ -275,9 +275,12 @@ extern int copyup_named_file(struct inode *dir, struct file *file,
 			     char *name, int bstart, int new_bindex,
 			     loff_t len);
 /* copies a dentry from dbstart to newbindex branch */
-extern int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
-			 int new_bindex, struct file **copyup_file,
-			 loff_t len);
+extern int copyup_dentry(struct inode *dir, struct dentry *dentry,
+			 int bstart, int new_bindex, const char *name,
+			 int namelen, struct file **copyup_file, loff_t len);
+/* helper functions for post-copyup actions */
+extern void unionfs_postcopyup_setmnt(struct dentry *dentry);
+extern void unionfs_postcopyup_release(struct dentry *dentry);
 
 extern int remove_whiteouts(struct dentry *dentry,
 			    struct dentry *lower_dentry, int bindex);
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 4e1c8f3..1e5bfce 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -88,6 +88,8 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 	err = unionfs_unlink_whiteout(dir, dentry);
 	/* call d_drop so the system "forgets" about us */
 	if (!err) {
+		if (!S_ISDIR(dentry->d_inode->i_mode))
+			unionfs_postcopyup_release(dentry);
 		d_drop(dentry);
 		/*
 		 * if unlink/whiteout succeeded, parent dir mtime has
-- 
1.5.2.2.238.g7cbf2f2

