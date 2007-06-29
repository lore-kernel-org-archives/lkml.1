Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXF2H25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXF2H25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764790AbXF2H06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:26:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46315 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbXF2H0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:26:38 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/5] Unionfs: Convert all instances of "hidden" to "lower"
Date: Fri, 29 Jun 2007 03:26:17 -0400
Message-Id: <11831019812813-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
References: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

The Unionfs code contained many references to symbols whose name had the
string "hidden" in it, referring to, for example, a "hidden inode" below the
Unionfs inode.  The term "hidden" was there for historical reasons and was a
misnomer, implying that the objects at Unionfs's lower branches were somehow
hidden or unavailable.  This was not just incorrect, but confusing.  The
lower objects are just that: lower.  They are not hidden from users.  In
fact, users can 'cd' to lower branches and manipulate files directly there.
This long patch renames all such mis-named symbols, and re-indents the code
as needed to comply with coding standards.

[jsipek: fixed up few rejects]
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |  174 +++++++++++++-------------
 fs/unionfs/copyup.c     |  210 ++++++++++++++++----------------
 fs/unionfs/dentry.c     |   26 ++--
 fs/unionfs/dirfops.c    |   14 +-
 fs/unionfs/dirhelper.c  |   84 +++++++-------
 fs/unionfs/inode.c      |  312 +++++++++++++++++++++++-----------------------
 fs/unionfs/lookup.c     |  140 +++++++++++-----------
 fs/unionfs/main.c       |  170 +++++++++++++-------------
 fs/unionfs/rdstate.c    |    8 +-
 fs/unionfs/rename.c     |  100 ++++++++--------
 fs/unionfs/subr.c       |   98 ++++++++--------
 fs/unionfs/super.c      |   38 +++---
 fs/unionfs/union.h      |    8 +-
 fs/unionfs/unlink.c     |   46 ++++----
 fs/unionfs/xattr.c      |   24 ++--
 15 files changed, 726 insertions(+), 726 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index a6917fe..6d87426 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -34,13 +34,13 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 
 	int err;
 	struct dentry *tmp_dentry = NULL;
-	struct dentry *hidden_dentry;
-	struct dentry *hidden_dir_dentry = NULL;
+	struct dentry *lower_dentry;
+	struct dentry *lower_dir_dentry = NULL;
 
-	hidden_dentry = unionfs_lower_dentry_idx(dentry, bstart);
+	lower_dentry = unionfs_lower_dentry_idx(dentry, bstart);
 
 	sprintf(name, ".unionfs%*.*lx",
-		i_inosize, i_inosize, hidden_dentry->d_inode->i_ino);
+		i_inosize, i_inosize, lower_dentry->d_inode->i_ino);
 
 retry:
 	/*
@@ -63,7 +63,7 @@ retry:
 		printk(KERN_DEBUG "unionfs: trying to rename %s to %s\n",
 		       dentry->d_name.name, name);
 
-		tmp_dentry = lookup_one_len(name, hidden_dentry->d_parent,
+		tmp_dentry = lookup_one_len(name, lower_dentry->d_parent,
 					    nlen);
 		if (IS_ERR(tmp_dentry)) {
 			err = PTR_ERR(tmp_dentry);
@@ -80,10 +80,10 @@ retry:
 		goto out;
 
 	/* bring it to the same state as an unlinked file */
-	hidden_dentry = unionfs_lower_dentry_idx(dentry, dbstart(dentry));
-	hidden_dir_dentry = lock_parent(hidden_dentry);
-	err = vfs_unlink(hidden_dir_dentry->d_inode, hidden_dentry);
-	unlock_dir(hidden_dir_dentry);
+	lower_dentry = unionfs_lower_dentry_idx(dentry, dbstart(dentry));
+	lower_dir_dentry = lock_parent(lower_dentry);
+	err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
+	unlock_dir(lower_dir_dentry);
 
 out:
 	return err;
@@ -147,8 +147,8 @@ static void cleanup_file(struct file *file)
 static int open_all_files(struct file *file)
 {
 	int bindex, bstart, bend, err = 0;
-	struct file *hidden_file;
-	struct dentry *hidden_dentry;
+	struct file *lower_file;
+	struct dentry *lower_dentry;
 	struct dentry *dentry = file->f_dentry;
 	struct super_block *sb = dentry->d_sb;
 
@@ -156,23 +156,23 @@ static int open_all_files(struct file *file)
 	bend = dbend(dentry);
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry)
 			continue;
 
-		dget(hidden_dentry);
+		dget(lower_dentry);
 		unionfs_mntget(dentry, bindex);
 		branchget(sb, bindex);
 
-		hidden_file =
-			dentry_open(hidden_dentry,
+		lower_file =
+			dentry_open(lower_dentry,
 				    unionfs_lower_mnt_idx(dentry, bindex),
 				    file->f_flags);
-		if (IS_ERR(hidden_file)) {
-			err = PTR_ERR(hidden_file);
+		if (IS_ERR(lower_file)) {
+			err = PTR_ERR(lower_file);
 			goto out;
 		} else
-			unionfs_set_lower_file_idx(file, bindex, hidden_file);
+			unionfs_set_lower_file_idx(file, bindex, lower_file);
 	}
 out:
 	return err;
@@ -182,8 +182,8 @@ out:
 static int open_highest_file(struct file *file, int willwrite)
 {
 	int bindex, bstart, bend, err = 0;
-	struct file *hidden_file;
-	struct dentry *hidden_dentry;
+	struct file *lower_file;
+	struct dentry *lower_dentry;
 
 	struct dentry *dentry = file->f_dentry;
 	struct inode *parent_inode = dentry->d_parent->d_inode;
@@ -193,7 +193,7 @@ static int open_highest_file(struct file *file, int willwrite)
 	bstart = dbstart(dentry);
 	bend = dbend(dentry);
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 	if (willwrite && IS_WRITE_FLAG(file->f_flags) && is_robranch(dentry)) {
 		for (bindex = bstart - 1; bindex >= 0; bindex--) {
 			err = copyup_file(parent_inode, file, bstart, bindex,
@@ -207,21 +207,21 @@ static int open_highest_file(struct file *file, int willwrite)
 		goto out;
 	}
 
-	dget(hidden_dentry);
+	dget(lower_dentry);
 	unionfs_mntget(dentry, bstart);
 	branchget(sb, bstart);
-	hidden_file = dentry_open(hidden_dentry,
-				  unionfs_lower_mnt_idx(dentry, bstart),
-				  file->f_flags);
-	if (IS_ERR(hidden_file)) {
-		err = PTR_ERR(hidden_file);
+	lower_file = dentry_open(lower_dentry,
+				 unionfs_lower_mnt_idx(dentry, bstart),
+				 file->f_flags);
+	if (IS_ERR(lower_file)) {
+		err = PTR_ERR(lower_file);
 		goto out;
 	}
-	unionfs_set_lower_file(file, hidden_file);
+	unionfs_set_lower_file(file, lower_file);
 	/* Fix up the position. */
-	hidden_file->f_pos = file->f_pos;
+	lower_file->f_pos = file->f_pos;
 
-	memcpy(&hidden_file->f_ra, &file->f_ra, sizeof(struct file_ra_state));
+	memcpy(&lower_file->f_ra, &file->f_ra, sizeof(struct file_ra_state));
 out:
 	return err;
 }
@@ -364,29 +364,29 @@ out_nofree:
 /* unionfs_open helper function: open a directory */
 static int __open_dir(struct inode *inode, struct file *file)
 {
-	struct dentry *hidden_dentry;
-	struct file *hidden_file;
+	struct dentry *lower_dentry;
+	struct file *lower_file;
 	int bindex, bstart, bend;
 
 	bstart = fbstart(file) = dbstart(file->f_dentry);
 	bend = fbend(file) = dbend(file->f_dentry);
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry =
+		lower_dentry =
 			unionfs_lower_dentry_idx(file->f_dentry, bindex);
-		if (!hidden_dentry)
+		if (!lower_dentry)
 			continue;
 
-		dget(hidden_dentry);
+		dget(lower_dentry);
 		unionfs_mntget(file->f_dentry, bindex);
-		hidden_file = dentry_open(hidden_dentry,
-					  unionfs_lower_mnt_idx(file->f_dentry,
+		lower_file = dentry_open(lower_dentry,
+					 unionfs_lower_mnt_idx(file->f_dentry,
 								bindex),
-					  file->f_flags);
-		if (IS_ERR(hidden_file))
-			return PTR_ERR(hidden_file);
+					 file->f_flags);
+		if (IS_ERR(lower_file))
+			return PTR_ERR(lower_file);
 
-		unionfs_set_lower_file_idx(file, bindex, hidden_file);
+		unionfs_set_lower_file_idx(file, bindex, lower_file);
 
 		/*
 		 * The branchget goes after the open, because otherwise
@@ -401,27 +401,27 @@ static int __open_dir(struct inode *inode, struct file *file)
 /* unionfs_open helper function: open a file */
 static int __open_file(struct inode *inode, struct file *file)
 {
-	struct dentry *hidden_dentry;
-	struct file *hidden_file;
-	int hidden_flags;
+	struct dentry *lower_dentry;
+	struct file *lower_file;
+	int lower_flags;
 	int bindex, bstart, bend;
 
-	hidden_dentry = unionfs_lower_dentry(file->f_dentry);
-	hidden_flags = file->f_flags;
+	lower_dentry = unionfs_lower_dentry(file->f_dentry);
+	lower_flags = file->f_flags;
 
 	bstart = fbstart(file) = dbstart(file->f_dentry);
 	bend = fbend(file) = dbend(file->f_dentry);
 
 	/*
-	 * check for the permission for hidden file.  If the error is
+	 * check for the permission for lower file.  If the error is
 	 * COPYUP_ERR, copyup the file.
 	 */
-	if (hidden_dentry->d_inode && is_robranch(file->f_dentry)) {
+	if (lower_dentry->d_inode && is_robranch(file->f_dentry)) {
 		/*
 		 * if the open will change the file, copy it up otherwise
 		 * defer it.
 		 */
-		if (hidden_flags & O_TRUNC) {
+		if (lower_flags & O_TRUNC) {
 			int size = 0;
 			int err = -EROFS;
 
@@ -435,24 +435,24 @@ static int __open_file(struct inode *inode, struct file *file)
 			}
 			return err;
 		} else
-			hidden_flags &= ~(OPEN_WRITE_FLAGS);
+			lower_flags &= ~(OPEN_WRITE_FLAGS);
 	}
 
-	dget(hidden_dentry);
+	dget(lower_dentry);
 
 	/*
 	 * dentry_open will decrement mnt refcnt if err.
 	 * otherwise fput() will do an mntput() for us upon file close.
 	 */
 	unionfs_mntget(file->f_dentry, bstart);
-	hidden_file =
-		dentry_open(hidden_dentry,
+	lower_file =
+		dentry_open(lower_dentry,
 			    unionfs_lower_mnt_idx(file->f_dentry, bstart),
-			    hidden_flags);
-	if (IS_ERR(hidden_file))
-		return PTR_ERR(hidden_file);
+			    lower_flags);
+	if (IS_ERR(lower_file))
+		return PTR_ERR(lower_file);
 
-	unionfs_set_lower_file(file, hidden_file);
+	unionfs_set_lower_file(file, lower_file);
 	branchget(inode->i_sb, bstart);
 
 	return 0;
@@ -461,7 +461,7 @@ static int __open_file(struct inode *inode, struct file *file)
 int unionfs_open(struct inode *inode, struct file *file)
 {
 	int err = 0;
-	struct file *hidden_file = NULL;
+	struct file *lower_file = NULL;
 	struct dentry *dentry = NULL;
 	int bindex = 0, bstart = 0, bend = 0;
 	int size;
@@ -503,7 +503,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 
 	/*
 	 * open all directories and make the unionfs file struct point to
-	 * these hidden file structs
+	 * these lower file structs
 	 */
 	if (S_ISDIR(inode->i_mode))
 		err = __open_dir(inode, file);	/* open a dir */
@@ -514,13 +514,13 @@ int unionfs_open(struct inode *inode, struct file *file)
 	if (err) {
 		atomic_dec(&UNIONFS_I(dentry->d_inode)->totalopens);
 		for (bindex = bstart; bindex <= bend; bindex++) {
-			hidden_file = unionfs_lower_file_idx(file, bindex);
-			if (!hidden_file)
+			lower_file = unionfs_lower_file_idx(file, bindex);
+			if (!lower_file)
 				continue;
 
 			branchput(file->f_dentry->d_sb, bindex);
-			/* fput calls dput for hidden_dentry */
-			fput(hidden_file);
+			/* fput calls dput for lower_dentry */
+			fput(lower_file);
 		}
 	}
 
@@ -544,7 +544,7 @@ out_nofree:
  */
 int unionfs_file_release(struct inode *inode, struct file *file)
 {
-	struct file *hidden_file = NULL;
+	struct file *lower_file = NULL;
 	struct unionfs_file_info *fileinfo;
 	struct unionfs_inode_info *inodeinfo;
 	struct super_block *sb = inode->i_sb;
@@ -564,16 +564,16 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	BUG_ON(file->f_dentry->d_inode != inode);
 	inodeinfo = UNIONFS_I(inode);
 
-	/* fput all the hidden files */
+	/* fput all the lower files */
 	fgen = atomic_read(&fileinfo->generation);
 	bstart = fbstart(file);
 	bend = fbend(file);
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_file = unionfs_lower_file_idx(file, bindex);
+		lower_file = unionfs_lower_file_idx(file, bindex);
 
-		if (hidden_file) {
-			fput(hidden_file);
+		if (lower_file) {
+			fput(lower_file);
 			branchput(inode->i_sb, bindex);
 		}
 	}
@@ -602,24 +602,24 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 /* pass the ioctl to the lower fs */
 static long do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct file *hidden_file;
+	struct file *lower_file;
 	int err;
 
-	hidden_file = unionfs_lower_file(file);
+	lower_file = unionfs_lower_file(file);
 
-	err = security_file_ioctl(hidden_file, cmd, arg);
+	err = security_file_ioctl(lower_file, cmd, arg);
 	if (err)
 		goto out;
 
 	err = -ENOTTY;
-	if (!hidden_file || !hidden_file->f_op)
+	if (!lower_file || !lower_file->f_op)
 		goto out;
-	if (hidden_file->f_op->unlocked_ioctl) {
-		err = hidden_file->f_op->unlocked_ioctl(hidden_file, cmd, arg);
-	} else if (hidden_file->f_op->ioctl) {
+	if (lower_file->f_op->unlocked_ioctl) {
+		err = lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
+	} else if (lower_file->f_op->ioctl) {
 		lock_kernel();
-		err = hidden_file->f_op->ioctl(hidden_file->f_dentry->d_inode,
-					       hidden_file, cmd, arg);
+		err = lower_file->f_op->ioctl(lower_file->f_dentry->d_inode,
+					      lower_file, cmd, arg);
 		unlock_kernel();
 	}
 
@@ -640,7 +640,7 @@ static int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
 	fd_set branchlist;
 
 	int bstart = 0, bend = 0, bindex = 0;
-	struct dentry *dentry, *hidden_dentry;
+	struct dentry *dentry, *lower_dentry;
 
 	dentry = file->f_dentry;
 	unionfs_lock_dentry(dentry);
@@ -652,10 +652,10 @@ static int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
 	FD_ZERO(&branchlist);
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry)
 			continue;
-		if (hidden_dentry->d_inode)
+		if (lower_dentry->d_inode)
 			FD_SET(bindex, &branchlist);
 	}
 
@@ -705,7 +705,7 @@ out:
 int unionfs_flush(struct file *file, fl_owner_t id)
 {
 	int err = 0;
-	struct file *hidden_file = NULL;
+	struct file *lower_file = NULL;
 	struct dentry *dentry = file->f_dentry;
 	int bindex, bstart, bend;
 
@@ -722,11 +722,11 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 	bstart = fbstart(file);
 	bend = fbend(file);
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_file = unionfs_lower_file_idx(file, bindex);
+		lower_file = unionfs_lower_file_idx(file, bindex);
 
-		if (hidden_file && hidden_file->f_op &&
-		    hidden_file->f_op->flush) {
-			err = hidden_file->f_op->flush(hidden_file, id);
+		if (lower_file && lower_file->f_op &&
+		    lower_file->f_op->flush) {
+			err = lower_file->f_op->flush(lower_file, id);
 			if (err)
 				goto out_lock;
 
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 8f13670..2762d3e 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -34,8 +34,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 
 #ifdef CONFIG_UNION_FS_XATTR
 /* copyup all extended attrs for a given dentry */
-static int copyup_xattrs(struct dentry *old_hidden_dentry,
-			 struct dentry *new_hidden_dentry)
+static int copyup_xattrs(struct dentry *old_lower_dentry,
+			 struct dentry *new_lower_dentry)
 {
 	int err = 0;
 	ssize_t list_size = -1;
@@ -43,7 +43,7 @@ static int copyup_xattrs(struct dentry *old_hidden_dentry,
 	char *attr_value = NULL;
 	char *name_list_orig = NULL;
 
-	list_size = vfs_listxattr(old_hidden_dentry, NULL, 0);
+	list_size = vfs_listxattr(old_lower_dentry, NULL, 0);
 
 	if (list_size <= 0) {
 		err = list_size;
@@ -55,7 +55,7 @@ static int copyup_xattrs(struct dentry *old_hidden_dentry,
 		err = PTR_ERR(name_list);
 		goto out;
 	}
-	list_size = vfs_listxattr(old_hidden_dentry, name_list, list_size);
+	list_size = vfs_listxattr(old_lower_dentry, name_list, list_size);
 	attr_value = unionfs_xattr_alloc(XATTR_SIZE_MAX, XATTR_SIZE_MAX);
 	if (!attr_value || IS_ERR(attr_value)) {
 		err = PTR_ERR(name_list);
@@ -66,10 +66,10 @@ static int copyup_xattrs(struct dentry *old_hidden_dentry,
 		ssize_t size;
 
 		/* Lock here since vfs_getxattr doesn't lock for us */
-		mutex_lock(&old_hidden_dentry->d_inode->i_mutex);
-		size = vfs_getxattr(old_hidden_dentry, name_list,
+		mutex_lock(&old_lower_dentry->d_inode->i_mutex);
+		size = vfs_getxattr(old_lower_dentry, name_list,
 				    attr_value, XATTR_SIZE_MAX);
-		mutex_unlock(&old_hidden_dentry->d_inode->i_mutex);
+		mutex_unlock(&old_lower_dentry->d_inode->i_mutex);
 		if (size < 0) {
 			err = size;
 			goto out;
@@ -80,7 +80,7 @@ static int copyup_xattrs(struct dentry *old_hidden_dentry,
 			goto out;
 		}
 		/* Don't lock here since vfs_setxattr does it for us. */
-		err = vfs_setxattr(new_hidden_dentry, name_list, attr_value,
+		err = vfs_setxattr(new_lower_dentry, name_list, attr_value,
 				   size, 0);
 
 		if (err < 0)
@@ -103,10 +103,10 @@ out:
 
 /* Determine the mode based on the copyup flags, and the existing dentry. */
 static int copyup_permissions(struct super_block *sb,
-			      struct dentry *old_hidden_dentry,
-			      struct dentry *new_hidden_dentry)
+			      struct dentry *old_lower_dentry,
+			      struct dentry *new_lower_dentry)
 {
-	struct inode *i = old_hidden_dentry->d_inode;
+	struct inode *i = old_lower_dentry->d_inode;
 	struct iattr newattrs;
 	int err;
 
@@ -123,7 +123,7 @@ static int copyup_permissions(struct super_block *sb,
 		ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_FORCE |
 		ATTR_GID | ATTR_UID | ATTR_MODE;
 
-	err = notify_change(new_hidden_dentry, &newattrs);
+	err = notify_change(new_lower_dentry, &newattrs);
 
 	return err;
 }
@@ -144,25 +144,25 @@ int copyup_dentry(struct inode *dir, struct dentry *dentry,
  * if the object being copied up is a regular file, the file is only created,
  * the contents have to be copied up separately
  */
-static int __copyup_ndentry(struct dentry *old_hidden_dentry,
-			    struct dentry *new_hidden_dentry,
-			    struct dentry *new_hidden_parent_dentry,
+static int __copyup_ndentry(struct dentry *old_lower_dentry,
+			    struct dentry *new_lower_dentry,
+			    struct dentry *new_lower_parent_dentry,
 			    char *symbuf)
 {
 	int err = 0;
-	umode_t old_mode = old_hidden_dentry->d_inode->i_mode;
+	umode_t old_mode = old_lower_dentry->d_inode->i_mode;
 	struct sioq_args args;
 
 	if (S_ISDIR(old_mode)) {
-		args.mkdir.parent = new_hidden_parent_dentry->d_inode;
-		args.mkdir.dentry = new_hidden_dentry;
+		args.mkdir.parent = new_lower_parent_dentry->d_inode;
+		args.mkdir.dentry = new_lower_dentry;
 		args.mkdir.mode = old_mode;
 
 		run_sioq(__unionfs_mkdir, &args);
 		err = args.err;
 	} else if (S_ISLNK(old_mode)) {
-		args.symlink.parent = new_hidden_parent_dentry->d_inode;
-		args.symlink.dentry = new_hidden_dentry;
+		args.symlink.parent = new_lower_parent_dentry->d_inode;
+		args.symlink.dentry = new_lower_dentry;
 		args.symlink.symbuf = symbuf;
 		args.symlink.mode = old_mode;
 
@@ -170,16 +170,16 @@ static int __copyup_ndentry(struct dentry *old_hidden_dentry,
 		err = args.err;
 	} else if (S_ISBLK(old_mode) || S_ISCHR(old_mode) ||
 		   S_ISFIFO(old_mode) || S_ISSOCK(old_mode)) {
-		args.mknod.parent = new_hidden_parent_dentry->d_inode;
-		args.mknod.dentry = new_hidden_dentry;
+		args.mknod.parent = new_lower_parent_dentry->d_inode;
+		args.mknod.dentry = new_lower_dentry;
 		args.mknod.mode = old_mode;
-		args.mknod.dev = old_hidden_dentry->d_inode->i_rdev;
+		args.mknod.dev = old_lower_dentry->d_inode->i_rdev;
 
 		run_sioq(__unionfs_mknod, &args);
 		err = args.err;
 	} else if (S_ISREG(old_mode)) {
-		args.create.parent = new_hidden_parent_dentry->d_inode;
-		args.create.dentry = new_hidden_dentry;
+		args.create.parent = new_lower_parent_dentry->d_inode;
+		args.create.dentry = new_lower_dentry;
 		args.create.mode = old_mode;
 		args.create.nd = NULL;
 
@@ -195,8 +195,8 @@ static int __copyup_ndentry(struct dentry *old_hidden_dentry,
 }
 
 static int __copyup_reg_data(struct dentry *dentry,
-			     struct dentry *new_hidden_dentry, int new_bindex,
-			     struct dentry *old_hidden_dentry, int old_bindex,
+			     struct dentry *new_lower_dentry, int new_bindex,
+			     struct dentry *old_lower_dentry, int old_bindex,
 			     struct file **copyup_file, loff_t len)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -211,11 +211,11 @@ static int __copyup_reg_data(struct dentry *dentry,
 	/* open old file */
 	unionfs_mntget(dentry, old_bindex);
 	branchget(sb, old_bindex);
-	input_file = dentry_open(old_hidden_dentry,
+	input_file = dentry_open(old_lower_dentry,
 				 unionfs_lower_mnt_idx(dentry, old_bindex),
 				 O_RDONLY | O_LARGEFILE);
 	if (IS_ERR(input_file)) {
-		dput(old_hidden_dentry);
+		dput(old_lower_dentry);
 		err = PTR_ERR(input_file);
 		goto out;
 	}
@@ -225,10 +225,10 @@ static int __copyup_reg_data(struct dentry *dentry,
 	}
 
 	/* open new file */
-	dget(new_hidden_dentry);
+	dget(new_lower_dentry);
 	unionfs_mntget(dentry, new_bindex);
 	branchget(sb, new_bindex);
-	output_file = dentry_open(new_hidden_dentry,
+	output_file = dentry_open(new_lower_dentry,
 				  unionfs_lower_mnt_idx(dentry, new_bindex),
 				  O_WRONLY | O_LARGEFILE);
 	if (IS_ERR(output_file)) {
@@ -289,7 +289,7 @@ static int __copyup_reg_data(struct dentry *dentry,
 
 	if (!err)
 		err = output_file->f_op->fsync(output_file,
-					       new_hidden_dentry, 0);
+					       new_lower_dentry, 0);
 
 	if (err)
 		goto out_close_out;
@@ -318,17 +318,17 @@ out:
  * dput the lower references for old and new dentry & clear a lower dentry
  * pointer
  */
-static void __clear(struct dentry *dentry, struct dentry *old_hidden_dentry,
+static void __clear(struct dentry *dentry, struct dentry *old_lower_dentry,
 		    int old_bstart, int old_bend,
-		    struct dentry *new_hidden_dentry, int new_bindex)
+		    struct dentry *new_lower_dentry, int new_bindex)
 {
-	/* get rid of the hidden dentry and all its traces */
+	/* get rid of the lower dentry and all its traces */
 	unionfs_set_lower_dentry_idx(dentry, new_bindex, NULL);
 	set_dbstart(dentry, old_bstart);
 	set_dbend(dentry, old_bend);
 
-	dput(new_hidden_dentry);
-	dput(old_hidden_dentry);
+	dput(new_lower_dentry);
+	dput(old_lower_dentry);
 }
 
 /* copy up a dentry to a file of specified name */
@@ -337,14 +337,14 @@ static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
 			       int namelen, struct file **copyup_file,
 			       loff_t len)
 {
-	struct dentry *new_hidden_dentry;
-	struct dentry *old_hidden_dentry = NULL;
+	struct dentry *new_lower_dentry;
+	struct dentry *old_lower_dentry = NULL;
 	struct super_block *sb;
 	int err = 0;
 	int old_bindex;
 	int old_bstart;
 	int old_bend;
-	struct dentry *new_hidden_parent_dentry = NULL;
+	struct dentry *new_lower_parent_dentry = NULL;
 	mm_segment_t oldfs;
 	char *symbuf = NULL;
 
@@ -363,75 +363,75 @@ static int copyup_named_dentry(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	/* Create the directory structure above this dentry. */
-	new_hidden_dentry =
+	new_lower_dentry =
 		create_parents_named(dir, dentry, name, new_bindex);
-	if (IS_ERR(new_hidden_dentry)) {
-		err = PTR_ERR(new_hidden_dentry);
+	if (IS_ERR(new_lower_dentry)) {
+		err = PTR_ERR(new_lower_dentry);
 		goto out;
 	}
 
-	old_hidden_dentry = unionfs_lower_dentry_idx(dentry, old_bindex);
-	/* we conditionally dput this old_hidden_dentry at end of function */
-	dget(old_hidden_dentry);
+	old_lower_dentry = unionfs_lower_dentry_idx(dentry, old_bindex);
+	/* we conditionally dput this old_lower_dentry at end of function */
+	dget(old_lower_dentry);
 
 	/* For symlinks, we must read the link before we lock the directory. */
-	if (S_ISLNK(old_hidden_dentry->d_inode->i_mode)) {
+	if (S_ISLNK(old_lower_dentry->d_inode->i_mode)) {
 
 		symbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!symbuf) {
-			__clear(dentry, old_hidden_dentry,
+			__clear(dentry, old_lower_dentry,
 				old_bstart, old_bend,
-				new_hidden_dentry, new_bindex);
+				new_lower_dentry, new_bindex);
 			err = -ENOMEM;
 			goto out_free;
 		}
 
 		oldfs = get_fs();
 		set_fs(KERNEL_DS);
-		err = old_hidden_dentry->d_inode->i_op->readlink(
-			old_hidden_dentry,
+		err = old_lower_dentry->d_inode->i_op->readlink(
+			old_lower_dentry,
 			(char __user *)symbuf,
 			PATH_MAX);
 		set_fs(oldfs);
 		if (err) {
-			__clear(dentry, old_hidden_dentry,
+			__clear(dentry, old_lower_dentry,
 				old_bstart, old_bend,
-				new_hidden_dentry, new_bindex);
+				new_lower_dentry, new_bindex);
 			goto out_free;
 		}
 		symbuf[err] = '\0';
 	}
 
 	/* Now we lock the parent, and create the object in the new branch. */
-	new_hidden_parent_dentry = lock_parent(new_hidden_dentry);
+	new_lower_parent_dentry = lock_parent(new_lower_dentry);
 
 	/* create the new inode */
-	err = __copyup_ndentry(old_hidden_dentry, new_hidden_dentry,
-			       new_hidden_parent_dentry, symbuf);
+	err = __copyup_ndentry(old_lower_dentry, new_lower_dentry,
+			       new_lower_parent_dentry, symbuf);
 
 	if (err) {
-		__clear(dentry, old_hidden_dentry,
+		__clear(dentry, old_lower_dentry,
 			old_bstart, old_bend,
-			new_hidden_dentry, new_bindex);
+			new_lower_dentry, new_bindex);
 		goto out_unlock;
 	}
 
 	/* We actually copyup the file here. */
-	if (S_ISREG(old_hidden_dentry->d_inode->i_mode))
-		err = __copyup_reg_data(dentry, new_hidden_dentry, new_bindex,
-					old_hidden_dentry, old_bindex,
+	if (S_ISREG(old_lower_dentry->d_inode->i_mode))
+		err = __copyup_reg_data(dentry, new_lower_dentry, new_bindex,
+					old_lower_dentry, old_bindex,
 					copyup_file, len);
 	if (err)
 		goto out_unlink;
 
 	/* Set permissions. */
-	if ((err = copyup_permissions(sb, old_hidden_dentry,
-				      new_hidden_dentry)))
+	if ((err = copyup_permissions(sb, old_lower_dentry,
+				      new_lower_dentry)))
 		goto out_unlink;
 
 #ifdef CONFIG_UNION_FS_XATTR
 	/* Selinux uses extended attributes for permissions. */
-	if ((err = copyup_xattrs(old_hidden_dentry, new_hidden_dentry)))
+	if ((err = copyup_xattrs(old_lower_dentry, new_lower_dentry)))
 		goto out_unlink;
 #endif
 
@@ -447,7 +447,7 @@ out_unlink:
 	 * quota, or something else happened so let's unlink; we don't
 	 * really care about the return value of vfs_unlink
 	 */
-	vfs_unlink(new_hidden_parent_dentry->d_inode, new_hidden_dentry);
+	vfs_unlink(new_lower_parent_dentry->d_inode, new_lower_dentry);
 
 	if (copyup_file) {
 		/* need to close the file */
@@ -465,17 +465,17 @@ out_unlink:
 	 */
 
 out_unlock:
-	unlock_dir(new_hidden_parent_dentry);
+	unlock_dir(new_lower_parent_dentry);
 
 out_free:
 	/*
-	 * If old_hidden_dentry was a directory, we need to dput it.  If it
+	 * If old_lower_dentry was a directory, we need to dput it.  If it
 	 * was a file, then it was already dput indirectly by other
 	 * functions we call above which operate on regular files.
 	 */
-	if (old_hidden_dentry && old_hidden_dentry->d_inode &&
-	    S_ISDIR(old_hidden_dentry->d_inode->i_mode))
-		dput(old_hidden_dentry);
+	if (old_lower_dentry && old_lower_dentry->d_inode &&
+	    S_ISDIR(old_lower_dentry->d_inode->i_mode))
+		dput(old_lower_dentry);
 	kfree(symbuf);
 
 out:
@@ -621,8 +621,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 	int err;
 	struct dentry *child_dentry;
 	struct dentry *parent_dentry;
-	struct dentry *hidden_parent_dentry = NULL;
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_parent_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	const char *childname;
 	unsigned int childnamelen;
 
@@ -637,14 +637,14 @@ static struct dentry *create_parents_named(struct inode *dir,
 	verify_locked(dentry);
 
 	if ((err = is_robranch_super(dir->i_sb, bindex))) {
-		hidden_dentry = ERR_PTR(err);
+		lower_dentry = ERR_PTR(err);
 		goto out;
 	}
 
 	old_bstart = dbstart(dentry);
 	old_bend = dbend(dentry);
 
-	hidden_dentry = ERR_PTR(-ENOMEM);
+	lower_dentry = ERR_PTR(-ENOMEM);
 
 	/* There is no sense allocating any less than the minimum. */
 	nr_dentry = 1;
@@ -671,8 +671,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 		parent_dentry = child_dentry->d_parent;
 		unionfs_lock_dentry(parent_dentry);
 
-		/* find out the hidden_parent_dentry in the given branch */
-		hidden_parent_dentry =
+		/* find out the lower_parent_dentry in the given branch */
+		lower_parent_dentry =
 			unionfs_lower_dentry_idx(parent_dentry, bindex);
 
 		/* grow path table */
@@ -682,7 +682,7 @@ static struct dentry *create_parents_named(struct inode *dir,
 			nr_dentry *= 2;
 			p = krealloc(path, nr_dentry * sizeof(struct dentry *), GFP_KERNEL);
 			if (!p) {
-				hidden_dentry = ERR_PTR(-ENOMEM);
+				lower_dentry = ERR_PTR(-ENOMEM);
 				goto out;
 			}
 			path = p;
@@ -690,7 +690,7 @@ static struct dentry *create_parents_named(struct inode *dir,
 
 		/* store the child dentry */
 		path[count++] = child_dentry;
-	} while (!hidden_parent_dentry);
+	} while (!lower_parent_dentry);
 	count--;
 
 	sb = dentry->d_sb;
@@ -700,8 +700,8 @@ static struct dentry *create_parents_named(struct inode *dir,
 	 * horrible to follow and should be replaced with cleaner code.
 	 */
 	while (1) {
-		/* get hidden parent dir in the current branch */
-		hidden_parent_dentry =
+		/* get lower parent dir in the current branch */
+		lower_parent_dentry =
 			unionfs_lower_dentry_idx(parent_dentry, bindex);
 		unionfs_unlock_dentry(parent_dentry);
 
@@ -711,10 +711,10 @@ static struct dentry *create_parents_named(struct inode *dir,
 
 		if (child_dentry != dentry) {
 			/* lookup child in the underlying file system */
-			hidden_dentry =
-				lookup_one_len(childname, hidden_parent_dentry,
+			lower_dentry =
+				lookup_one_len(childname, lower_parent_dentry,
 					       childnamelen);
-			if (IS_ERR(hidden_dentry))
+			if (IS_ERR(lower_dentry))
 				goto out;
 		} else {
 
@@ -723,10 +723,10 @@ static struct dentry *create_parents_named(struct inode *dir,
 			 * lookup the whiteout child in the underlying file
 			 * system
 			 */
-			hidden_dentry =
-				lookup_one_len(name, hidden_parent_dentry,
+			lower_dentry =
+				lookup_one_len(name, lower_parent_dentry,
 					       strlen(name));
-			if (IS_ERR(hidden_dentry))
+			if (IS_ERR(lower_dentry))
 				goto out;
 
 			/*
@@ -735,26 +735,26 @@ static struct dentry *create_parents_named(struct inode *dir,
 			 */
 			dput(unionfs_lower_dentry_idx(dentry, bindex));
 			unionfs_set_lower_dentry_idx(dentry, bindex,
-						     hidden_dentry);
+						     lower_dentry);
 
 			__cleanup_dentry(dentry, bindex, old_bstart, old_bend);
 			break;
 		}
 
-		if (hidden_dentry->d_inode) {
+		if (lower_dentry->d_inode) {
 			/*
 			 * since this already exists we dput to avoid
 			 * multiple references on the same dentry
 			 */
-			dput(hidden_dentry);
+			dput(lower_dentry);
 		} else {
 			struct sioq_args args;
 
 			/* its a negative dentry, create a new dir */
-			hidden_parent_dentry = lock_parent(hidden_dentry);
+			lower_parent_dentry = lock_parent(lower_dentry);
 
-			args.mkdir.parent = hidden_parent_dentry->d_inode;
-			args.mkdir.dentry = hidden_dentry;
+			args.mkdir.parent = lower_parent_dentry->d_inode;
+			args.mkdir.dentry = lower_dentry;
 			args.mkdir.mode = child_dentry->d_inode->i_mode;
 
 			run_sioq(__unionfs_mkdir, &args);
@@ -763,10 +763,10 @@ static struct dentry *create_parents_named(struct inode *dir,
 			if (!err)
 				err = copyup_permissions(dir->i_sb,
 							 child_dentry,
-							 hidden_dentry);
-			unlock_dir(hidden_parent_dentry);
+							 lower_dentry);
+			unlock_dir(lower_parent_dentry);
 			if (err) {
-				struct inode *inode = hidden_dentry->d_inode;
+				struct inode *inode = lower_dentry->d_inode;
 				/*
 				 * If we get here, it means that we created a new
 				 * dentry+inode, but copying permissions failed.
@@ -776,31 +776,31 @@ static struct dentry *create_parents_named(struct inode *dir,
 				 * XXX: call dentry_iput() instead, but then we have
 				 * to export that symbol.
 				 */
-				if (hidden_dentry->d_op && hidden_dentry->d_op->d_iput)
-					hidden_dentry->d_op->d_iput(hidden_dentry,
-								    inode);
+				if (lower_dentry->d_op && lower_dentry->d_op->d_iput)
+					lower_dentry->d_op->d_iput(lower_dentry,
+								   inode);
 				else
 					iput(inode);
-				hidden_dentry->d_inode = NULL;
+				lower_dentry->d_inode = NULL;
 
-				dput(hidden_dentry);
-				hidden_dentry = ERR_PTR(err);
+				dput(lower_dentry);
+				lower_dentry = ERR_PTR(err);
 				goto out;
 			}
 
 		}
 
-		__set_inode(child_dentry, hidden_dentry, bindex);
-		__set_dentry(child_dentry, hidden_dentry, bindex);
+		__set_inode(child_dentry, lower_dentry, bindex);
+		__set_dentry(child_dentry, lower_dentry, bindex);
 
 		parent_dentry = child_dentry;
 		child_dentry = path[--count];
 	}
 out:
 	/* cleanup any leftover locks from the do/while loop above */
-	if (IS_ERR(hidden_dentry))
+	if (IS_ERR(lower_dentry))
 		while (count)
 			unionfs_unlock_dentry(path[count--]);
 	kfree(path);
-	return hidden_dentry;
+	return lower_dentry;
 }
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 306e171..f88a285 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -29,7 +29,7 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 				      struct nameidata *nd)
 {
 	int valid = 1;		/* default is valid (1); invalid is 0. */
-	struct dentry *hidden_dentry;
+	struct dentry *lower_dentry;
 	int bindex, bstart, bend;
 	int sbgen, dgen;
 	int positive = 0;
@@ -78,12 +78,12 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 		bstart = dbstart(dentry);
 		bend = dbend(dentry);
 		if (bstart >= 0) {
-			struct dentry *hidden_dentry;
+			struct dentry *lower_dentry;
 			for (bindex = bstart; bindex <= bend; bindex++) {
-				hidden_dentry =
+				lower_dentry =
 					unionfs_lower_dentry_idx(dentry,
 								 bindex);
-				dput(hidden_dentry);
+				dput(lower_dentry);
 			}
 		}
 		set_dbstart(dentry, -1);
@@ -106,14 +106,14 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 			bstart = ibstart(dentry->d_inode);
 			bend = ibend(dentry->d_inode);
 			if (bstart >= 0) {
-				struct inode *hidden_inode;
+				struct inode *lower_inode;
 				for (bindex = bstart; bindex <= bend;
 				     bindex++) {
-					hidden_inode =
+					lower_inode =
 						unionfs_lower_inode_idx(
 							dentry->d_inode,
 							bindex);
-					iput(hidden_inode);
+					iput(lower_inode);
 				}
 			}
 			kfree(UNIONFS_I(dentry->d_inode)->lower_inodes);
@@ -153,11 +153,11 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry,
 	bend = dbend(dentry);
 	BUG_ON(bstart == -1);
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry || !hidden_dentry->d_op
-		    || !hidden_dentry->d_op->d_revalidate)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry || !lower_dentry->d_op
+		    || !lower_dentry->d_op->d_revalidate)
 			continue;
-		if (!hidden_dentry->d_op->d_revalidate(hidden_dentry,
+		if (!lower_dentry->d_op->d_revalidate(lower_dentry,
 						       &lowernd))
 			valid = 0;
 	}
@@ -318,13 +318,13 @@ static void unionfs_d_release(struct dentry *dentry)
 		goto out;
 	} else if (dbstart(dentry) < 0) {
 		/* this is due to a failed lookup */
-		printk(KERN_DEBUG "unionfs: dentry without hidden "
+		printk(KERN_DEBUG "unionfs: dentry without lower "
 		       "dentries: %.*s",
 		       dentry->d_name.len, dentry->d_name.name);
 		goto out_free;
 	}
 
-	/* Release all the hidden dentries */
+	/* Release all the lower dentries */
 	bstart = dbstart(dentry);
 	bend = dbend(dentry);
 	for (bindex = bstart; bindex <= bend; bindex++) {
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 95b0946..8503411 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -90,7 +90,7 @@ out:
 static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 {
 	int err = 0;
-	struct file *hidden_file = NULL;
+	struct file *lower_file = NULL;
 	struct inode *inode = NULL;
 	struct unionfs_getdents_callback buf;
 	struct unionfs_dir_state *uds;
@@ -123,8 +123,8 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 	bend = fbend(file);
 
 	while (uds->bindex <= bend) {
-		hidden_file = unionfs_lower_file_idx(file, uds->bindex);
-		if (!hidden_file) {
+		lower_file = unionfs_lower_file_idx(file, uds->bindex);
+		if (!lower_file) {
 			uds->bindex++;
 			uds->dirpos = 0;
 			continue;
@@ -140,15 +140,15 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		buf.sb = inode->i_sb;
 
 		/* Read starting from where we last left off. */
-		offset = vfs_llseek(hidden_file, uds->dirpos, SEEK_SET);
+		offset = vfs_llseek(lower_file, uds->dirpos, SEEK_SET);
 		if (offset < 0) {
 			err = offset;
 			goto out;
 		}
-		err = vfs_readdir(hidden_file, unionfs_filldir, &buf);
+		err = vfs_readdir(lower_file, unionfs_filldir, &buf);
 
 		/* Save the position for when we continue. */
-		offset = vfs_llseek(hidden_file, 0, SEEK_CUR);
+		offset = vfs_llseek(lower_file, 0, SEEK_CUR);
 		if (offset < 0) {
 			err = offset;
 			goto out;
@@ -156,7 +156,7 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		uds->dirpos = offset;
 
 		/* Copy the atime. */
-		fsstack_copy_attr_atime(inode, hidden_file->f_dentry->d_inode);
+		fsstack_copy_attr_atime(inode, lower_file->f_dentry->d_inode);
 
 		if (err < 0)
 			goto out;
diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index 82e7896..24bd327 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -21,26 +21,26 @@
 /*
  * Delete all of the whiteouts in a given directory for rmdir.
  *
- * hidden directory inode should be locked
+ * lower directory inode should be locked
  */
 int do_delete_whiteouts(struct dentry *dentry, int bindex,
 			struct unionfs_dir_state *namelist)
 {
 	int err = 0;
-	struct dentry *hidden_dir_dentry = NULL;
-	struct dentry *hidden_dentry;
+	struct dentry *lower_dir_dentry = NULL;
+	struct dentry *lower_dentry;
 	char *name = NULL, *p;
-	struct inode *hidden_dir;
+	struct inode *lower_dir;
 
 	int i;
 	struct list_head *pos;
 	struct filldir_node *cursor;
 
-	/* Find out hidden parent dentry */
-	hidden_dir_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-	BUG_ON(!S_ISDIR(hidden_dir_dentry->d_inode->i_mode));
-	hidden_dir = hidden_dir_dentry->d_inode;
-	BUG_ON(!S_ISDIR(hidden_dir->i_mode));
+	/* Find out lower parent dentry */
+	lower_dir_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+	BUG_ON(!S_ISDIR(lower_dir_dentry->d_inode->i_mode));
+	lower_dir = lower_dir_dentry->d_inode;
+	BUG_ON(!S_ISDIR(lower_dir->i_mode));
 
 	err = -ENOMEM;
 	name = __getname();
@@ -62,17 +62,17 @@ int do_delete_whiteouts(struct dentry *dentry, int bindex,
 				continue;
 
 			strcpy(p, cursor->name);
-			hidden_dentry =
-				lookup_one_len(name, hidden_dir_dentry,
+			lower_dentry =
+				lookup_one_len(name, lower_dir_dentry,
 					       cursor->namelen +
 					       UNIONFS_WHLEN);
-			if (IS_ERR(hidden_dentry)) {
-				err = PTR_ERR(hidden_dentry);
+			if (IS_ERR(lower_dentry)) {
+				err = PTR_ERR(lower_dentry);
 				break;
 			}
-			if (hidden_dentry->d_inode)
-				err = vfs_unlink(hidden_dir, hidden_dentry);
-			dput(hidden_dentry);
+			if (lower_dentry->d_inode)
+				err = vfs_unlink(lower_dir, lower_dentry);
+			dput(lower_dentry);
 			if (err)
 				break;
 		}
@@ -81,7 +81,7 @@ int do_delete_whiteouts(struct dentry *dentry, int bindex,
 	__putname(name);
 
 	/* After all of the removals, we should copy the attributes once. */
-	fsstack_copy_attr_times(dentry->d_inode, hidden_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dentry->d_inode, lower_dir_dentry->d_inode);
 
 out:
 	return err;
@@ -93,8 +93,8 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 {
 	int err;
 	struct super_block *sb;
-	struct dentry *hidden_dir_dentry;
-	struct inode *hidden_dir;
+	struct dentry *lower_dir_dentry;
+	struct inode *lower_dir;
 
 	struct sioq_args args;
 
@@ -107,13 +107,13 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 	if (err)
 		goto out;
 
-	hidden_dir_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-	BUG_ON(!S_ISDIR(hidden_dir_dentry->d_inode->i_mode));
-	hidden_dir = hidden_dir_dentry->d_inode;
-	BUG_ON(!S_ISDIR(hidden_dir->i_mode));
+	lower_dir_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+	BUG_ON(!S_ISDIR(lower_dir_dentry->d_inode->i_mode));
+	lower_dir = lower_dir_dentry->d_inode;
+	BUG_ON(!S_ISDIR(lower_dir->i_mode));
 
-	mutex_lock(&hidden_dir->i_mutex);
-	if (!permission(hidden_dir, MAY_WRITE | MAY_EXEC, NULL))
+	mutex_lock(&lower_dir->i_mutex);
+	if (!permission(lower_dir, MAY_WRITE | MAY_EXEC, NULL))
 		err = do_delete_whiteouts(dentry, bindex, namelist);
 	else {
 		args.deletewh.namelist = namelist;
@@ -122,7 +122,7 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 		run_sioq(__delete_whiteouts, &args);
 		err = args.err;
 	}
-	mutex_unlock(&hidden_dir->i_mutex);
+	mutex_unlock(&lower_dir->i_mutex);
 
 out:
 	return err;
@@ -185,9 +185,9 @@ out:
 int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 {
 	int err = 0;
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	struct super_block *sb;
-	struct file *hidden_file;
+	struct file *lower_file;
 	struct unionfs_rdutil_callback *buf = NULL;
 	int bindex, bstart, bend, bopaque;
 
@@ -218,26 +218,26 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 		goto out;
 	}
 
-	/* Process the hidden directories with rdutil_callback as a filldir. */
+	/* Process the lower directories with rdutil_callback as a filldir. */
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry)
 			continue;
-		if (!hidden_dentry->d_inode)
+		if (!lower_dentry->d_inode)
 			continue;
-		if (!S_ISDIR(hidden_dentry->d_inode->i_mode))
+		if (!S_ISDIR(lower_dentry->d_inode->i_mode))
 			continue;
 
-		dget(hidden_dentry);
+		dget(lower_dentry);
 		unionfs_mntget(dentry, bindex);
 		branchget(sb, bindex);
-		hidden_file =
-			dentry_open(hidden_dentry,
+		lower_file =
+			dentry_open(lower_dentry,
 				    unionfs_lower_mnt_idx(dentry, bindex),
 				    O_RDONLY);
-		if (IS_ERR(hidden_file)) {
-			err = PTR_ERR(hidden_file);
-			dput(hidden_dentry);
+		if (IS_ERR(lower_file)) {
+			err = PTR_ERR(lower_file);
+			dput(lower_dentry);
 			branchput(sb, bindex);
 			goto out;
 		}
@@ -245,14 +245,14 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
 		do {
 			buf->filldir_called = 0;
 			buf->rdstate->bindex = bindex;
-			err = vfs_readdir(hidden_file,
+			err = vfs_readdir(lower_file,
 					  readdir_util_callback, buf);
 			if (buf->err)
 				err = buf->err;
 		} while ((err >= 0) && buf->filldir_called);
 
-		/* fput calls dput for hidden_dentry */
-		fput(hidden_file);
+		/* fput calls dput for lower_dentry */
+		fput(lower_file);
 		branchput(sb, bindex);
 
 		if (err < 0)
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index cdd1a7c..f946b33 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -22,10 +22,10 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			  int mode, struct nameidata *nd)
 {
 	int err = 0;
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	struct dentry *wh_dentry = NULL;
-	struct dentry *new_hidden_dentry;
-	struct dentry *hidden_parent_dentry = NULL;
+	struct dentry *new_lower_dentry;
+	struct dentry *lower_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
 	int valid = 0;
@@ -49,7 +49,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 
 	/* We start out in the leftmost branch. */
 	bstart = dbstart(dentry);
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
 	/*
 	 * check if whiteout exists in this branch, i.e. lookup .wh.foo
@@ -61,7 +61,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 		goto out;
 	}
 
-	wh_dentry = lookup_one_len(name, hidden_dentry->d_parent,
+	wh_dentry = lookup_one_len(name, lower_dentry->d_parent,
 				   dentry->d_name.len + UNIONFS_WHLEN);
 	if (IS_ERR(wh_dentry)) {
 		err = PTR_ERR(wh_dentry);
@@ -75,7 +75,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 		 * First truncate it and then rename it to foo (hence having
 		 * the same overall effect as a normal create.
 		 */
-		struct dentry *hidden_dir_dentry;
+		struct dentry *lower_dir_dentry;
 		struct iattr newattrs;
 
 		mutex_lock(&wh_dentry->d_inode->i_mutex);
@@ -101,32 +101,32 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			       "failed: %d, ignoring..\n",
 			       __FILE__, __LINE__, err);
 
-		new_hidden_dentry = unionfs_lower_dentry(dentry);
-		dget(new_hidden_dentry);
+		new_lower_dentry = unionfs_lower_dentry(dentry);
+		dget(new_lower_dentry);
 
-		hidden_dir_dentry = dget_parent(wh_dentry);
-		lock_rename(hidden_dir_dentry, hidden_dir_dentry);
+		lower_dir_dentry = dget_parent(wh_dentry);
+		lock_rename(lower_dir_dentry, lower_dir_dentry);
 
 		if (!(err = is_robranch_super(dentry->d_sb, bstart))) {
-			err = vfs_rename(hidden_dir_dentry->d_inode,
+			err = vfs_rename(lower_dir_dentry->d_inode,
 					 wh_dentry,
-					 hidden_dir_dentry->d_inode,
-					 new_hidden_dentry);
+					 lower_dir_dentry->d_inode,
+					 new_lower_dentry);
 		}
 		if (!err) {
 			fsstack_copy_attr_times(parent,
-						new_hidden_dentry->d_parent->
+						new_lower_dentry->d_parent->
 						d_inode);
 			fsstack_copy_inode_size(parent,
-						new_hidden_dentry->d_parent->
+						new_lower_dentry->d_parent->
 						d_inode);
 			parent->i_nlink = unionfs_get_nlinks(parent);
 		}
 
-		unlock_rename(hidden_dir_dentry, hidden_dir_dentry);
-		dput(hidden_dir_dentry);
+		unlock_rename(lower_dir_dentry, lower_dir_dentry);
+		dput(lower_dir_dentry);
 
-		dput(new_hidden_dentry);
+		dput(new_lower_dentry);
 
 		if (err) {
 			/* exit if the error returned was NOT -EROFS */
@@ -158,35 +158,35 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	}
 
 	for (bindex = bstart; bindex >= 0; bindex--) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry) {
 			/*
-			 * if hidden_dentry is NULL, create the entire
+			 * if lower_dentry is NULL, create the entire
 			 * dentry directory structure in branch 'bindex'.
-			 * hidden_dentry will NOT be null when bindex == bstart
+			 * lower_dentry will NOT be null when bindex == bstart
 			 * because lookup passed as a negative unionfs dentry
 			 * pointing to a lone negative underlying dentry.
 			 */
-			hidden_dentry = create_parents(parent, dentry, bindex);
-			if (!hidden_dentry || IS_ERR(hidden_dentry)) {
-				if (IS_ERR(hidden_dentry))
-					err = PTR_ERR(hidden_dentry);
+			lower_dentry = create_parents(parent, dentry, bindex);
+			if (!lower_dentry || IS_ERR(lower_dentry)) {
+				if (IS_ERR(lower_dentry))
+					err = PTR_ERR(lower_dentry);
 				continue;
 			}
 		}
 
-		hidden_parent_dentry = lock_parent(hidden_dentry);
-		if (IS_ERR(hidden_parent_dentry)) {
-			err = PTR_ERR(hidden_parent_dentry);
+		lower_parent_dentry = lock_parent(lower_dentry);
+		if (IS_ERR(lower_parent_dentry)) {
+			err = PTR_ERR(lower_parent_dentry);
 			goto out;
 		}
 		/* We shouldn't create things in a read-only branch. */
 		if (!(err = is_robranch_super(dentry->d_sb, bindex)))
-			err = vfs_create(hidden_parent_dentry->d_inode,
-					 hidden_dentry, mode, nd);
+			err = vfs_create(lower_parent_dentry->d_inode,
+					 lower_dentry, mode, nd);
 
-		if (err || !hidden_dentry->d_inode) {
-			unlock_dir(hidden_parent_dentry);
+		if (err || !lower_dentry->d_inode) {
+			unlock_dir(lower_parent_dentry);
 
 			/* break out of for loop if the error wasn't  -EROFS */
 			if (!IS_COPYUP_ERR(err))
@@ -195,15 +195,15 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			err = unionfs_interpose(dentry, parent->i_sb, 0);
 			if (!err) {
 				fsstack_copy_attr_times(parent,
-							hidden_parent_dentry->
+							lower_parent_dentry->
 							d_inode);
 				fsstack_copy_inode_size(parent,
-							hidden_parent_dentry->
+							lower_parent_dentry->
 							d_inode);
 				/* update no. of links on parent directory */
 				parent->i_nlink = unionfs_get_nlinks(parent);
 			}
-			unlock_dir(hidden_parent_dentry);
+			unlock_dir(lower_parent_dentry);
 			break;
 		}
 	}
@@ -250,9 +250,9 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 			struct dentry *new_dentry)
 {
 	int err = 0;
-	struct dentry *hidden_old_dentry = NULL;
-	struct dentry *hidden_new_dentry = NULL;
-	struct dentry *hidden_dir_dentry = NULL;
+	struct dentry *lower_old_dentry = NULL;
+	struct dentry *lower_new_dentry = NULL;
+	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *whiteout_dentry;
 	char *name = NULL;
 
@@ -269,7 +269,7 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto out;
 	}
 
-	hidden_new_dentry = unionfs_lower_dentry(new_dentry);
+	lower_new_dentry = unionfs_lower_dentry(new_dentry);
 
 	/*
 	 * check if whiteout exists in the branch of new dentry, i.e. lookup
@@ -281,7 +281,7 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto out;
 	}
 
-	whiteout_dentry = lookup_one_len(name, hidden_new_dentry->d_parent,
+	whiteout_dentry = lookup_one_len(name, lower_new_dentry->d_parent,
 					 new_dentry->d_name.len +
 					 UNIONFS_WHLEN);
 	if (IS_ERR(whiteout_dentry)) {
@@ -294,39 +294,39 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 		whiteout_dentry = NULL;
 	} else {
 		/* found a .wh.foo entry, unlink it and then call vfs_link() */
-		hidden_dir_dentry = lock_parent(whiteout_dentry);
+		lower_dir_dentry = lock_parent(whiteout_dentry);
 		err = is_robranch_super(new_dentry->d_sb, dbstart(new_dentry));
 		if (!err)
-			err = vfs_unlink(hidden_dir_dentry->d_inode,
+			err = vfs_unlink(lower_dir_dentry->d_inode,
 					 whiteout_dentry);
 
-		fsstack_copy_attr_times(dir, hidden_dir_dentry->d_inode);
+		fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 		dir->i_nlink = unionfs_get_nlinks(dir);
-		unlock_dir(hidden_dir_dentry);
-		hidden_dir_dentry = NULL;
+		unlock_dir(lower_dir_dentry);
+		lower_dir_dentry = NULL;
 		dput(whiteout_dentry);
 		if (err)
 			goto out;
 	}
 
 	if (dbstart(old_dentry) != dbstart(new_dentry)) {
-		hidden_new_dentry =
+		lower_new_dentry =
 			create_parents(dir, new_dentry, dbstart(old_dentry));
-		err = PTR_ERR(hidden_new_dentry);
+		err = PTR_ERR(lower_new_dentry);
 		if (IS_COPYUP_ERR(err))
 			goto docopyup;
-		if (!hidden_new_dentry || IS_ERR(hidden_new_dentry))
+		if (!lower_new_dentry || IS_ERR(lower_new_dentry))
 			goto out;
 	}
-	hidden_new_dentry = unionfs_lower_dentry(new_dentry);
-	hidden_old_dentry = unionfs_lower_dentry(old_dentry);
+	lower_new_dentry = unionfs_lower_dentry(new_dentry);
+	lower_old_dentry = unionfs_lower_dentry(old_dentry);
 
 	BUG_ON(dbstart(old_dentry) != dbstart(new_dentry));
-	hidden_dir_dentry = lock_parent(hidden_new_dentry);
+	lower_dir_dentry = lock_parent(lower_new_dentry);
 	if (!(err = is_robranch(old_dentry)))
-		err = vfs_link(hidden_old_dentry, hidden_dir_dentry->d_inode,
-			       hidden_new_dentry);
-	unlock_dir(hidden_dir_dentry);
+		err = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
+			       lower_new_dentry);
+	unlock_dir(lower_dir_dentry);
 
 docopyup:
 	if (IS_COPYUP_ERR(err)) {
@@ -339,18 +339,18 @@ docopyup:
 					    bindex, NULL,
 					    old_dentry->d_inode->i_size);
 			if (!err) {
-				hidden_new_dentry =
+				lower_new_dentry =
 					create_parents(dir, new_dentry,
 						       bindex);
-				hidden_old_dentry =
+				lower_old_dentry =
 					unionfs_lower_dentry(old_dentry);
-				hidden_dir_dentry =
-					lock_parent(hidden_new_dentry);
+				lower_dir_dentry =
+					lock_parent(lower_new_dentry);
 				/* do vfs_link */
-				err = vfs_link(hidden_old_dentry,
-					       hidden_dir_dentry->d_inode,
-					       hidden_new_dentry);
-				unlock_dir(hidden_dir_dentry);
+				err = vfs_link(lower_old_dentry,
+					       lower_dir_dentry->d_inode,
+					       lower_new_dentry);
+				unlock_dir(lower_dir_dentry);
 				goto check_link;
 			}
 		}
@@ -358,15 +358,15 @@ docopyup:
 	}
 
 check_link:
-	if (err || !hidden_new_dentry->d_inode)
+	if (err || !lower_new_dentry->d_inode)
 		goto out;
 
 	/* Its a hard link, so use the same inode */
 	new_dentry->d_inode = igrab(old_dentry->d_inode);
 	d_instantiate(new_dentry, new_dentry->d_inode);
-	fsstack_copy_attr_all(dir, hidden_new_dentry->d_parent->d_inode,
+	fsstack_copy_attr_all(dir, lower_new_dentry->d_parent->d_inode,
 			      unionfs_get_nlinks);
-	fsstack_copy_inode_size(dir, hidden_new_dentry->d_parent->d_inode);
+	fsstack_copy_inode_size(dir, lower_new_dentry->d_parent->d_inode);
 
 	/* propagate number of hard-links */
 	old_dentry->d_inode->i_nlink = unionfs_get_nlinks(old_dentry->d_inode);
@@ -389,9 +389,9 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 			   const char *symname)
 {
 	int err = 0;
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	struct dentry *whiteout_dentry = NULL;
-	struct dentry *hidden_dir_dentry = NULL;
+	struct dentry *lower_dir_dentry = NULL;
 	umode_t mode;
 	int bindex = 0, bstart;
 	char *name = NULL;
@@ -408,7 +408,7 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	/* We start out in the leftmost branch. */
 	bstart = dbstart(dentry);
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
 	/*
 	 * check if whiteout exists in this branch, i.e. lookup .wh.foo
@@ -421,7 +421,7 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	}
 
 	whiteout_dentry =
-		lookup_one_len(name, hidden_dentry->d_parent,
+		lookup_one_len(name, lower_dentry->d_parent,
 			       dentry->d_name.len + UNIONFS_WHLEN);
 	if (IS_ERR(whiteout_dentry)) {
 		err = PTR_ERR(whiteout_dentry);
@@ -436,18 +436,18 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 		 * found a .wh.foo entry, unlink it and then call
 		 * vfs_symlink().
 		 */
-		hidden_dir_dentry = lock_parent(whiteout_dentry);
+		lower_dir_dentry = lock_parent(whiteout_dentry);
 
 		if (!(err = is_robranch_super(dentry->d_sb, bstart)))
-			err = vfs_unlink(hidden_dir_dentry->d_inode,
+			err = vfs_unlink(lower_dir_dentry->d_inode,
 					 whiteout_dentry);
 		dput(whiteout_dentry);
 
-		fsstack_copy_attr_times(dir, hidden_dir_dentry->d_inode);
+		fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 		/* propagate number of hard-links */
 		dir->i_nlink = unionfs_get_nlinks(dir);
 
-		unlock_dir(hidden_dir_dentry);
+		unlock_dir(lower_dir_dentry);
 
 		if (err) {
 			/* exit if the error returned was NOT -EROFS */
@@ -466,39 +466,39 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 	 * with possible recursive directory creation
 	 */
 	for (bindex = bstart; bindex >= 0; bindex--) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry) {
 			/*
-			 * if hidden_dentry is NULL, create the entire
+			 * if lower_dentry is NULL, create the entire
 			 * dentry directory structure in branch 'bindex'.
-			 * hidden_dentry will NOT be null when bindex ==
+			 * lower_dentry will NOT be null when bindex ==
 			 * bstart because lookup passed as a negative
 			 * unionfs dentry pointing to a lone negative
 			 * underlying dentry
 			 */
-			hidden_dentry = create_parents(dir, dentry, bindex);
-			if (!hidden_dentry || IS_ERR(hidden_dentry)) {
-				if (IS_ERR(hidden_dentry))
-					err = PTR_ERR(hidden_dentry);
+			lower_dentry = create_parents(dir, dentry, bindex);
+			if (!lower_dentry || IS_ERR(lower_dentry)) {
+				if (IS_ERR(lower_dentry))
+					err = PTR_ERR(lower_dentry);
 
-				printk(KERN_DEBUG "unionfs: hidden dentry "
+				printk(KERN_DEBUG "unionfs: lower dentry "
 				       "NULL (or error) for bindex = %d\n",
 				       bindex);
 				continue;
 			}
 		}
 
-		hidden_dir_dentry = lock_parent(hidden_dentry);
+		lower_dir_dentry = lock_parent(lower_dentry);
 
 		if (!(err = is_robranch_super(dentry->d_sb, bindex))) {
 			mode = S_IALLUGO;
 			err =
-				vfs_symlink(hidden_dir_dentry->d_inode,
-					    hidden_dentry, symname, mode);
+				vfs_symlink(lower_dir_dentry->d_inode,
+					    lower_dentry, symname, mode);
 		}
-		unlock_dir(hidden_dir_dentry);
+		unlock_dir(lower_dir_dentry);
 
-		if (err || !hidden_dentry->d_inode) {
+		if (err || !lower_dentry->d_inode) {
 			/*
 			 * break out of for loop if error returned was NOT
 			 * -EROFS.
@@ -509,10 +509,10 @@ static int unionfs_symlink(struct inode *dir, struct dentry *dentry,
 			err = unionfs_interpose(dentry, dir->i_sb, 0);
 			if (!err) {
 				fsstack_copy_attr_times(dir,
-							hidden_dir_dentry->
+							lower_dir_dentry->
 							d_inode);
 				fsstack_copy_inode_size(dir,
-							hidden_dir_dentry->
+							lower_dir_dentry->
 							d_inode);
 				/*
 				 * update number of links on parent
@@ -537,8 +537,8 @@ out:
 static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 {
 	int err = 0;
-	struct dentry *hidden_dentry = NULL, *whiteout_dentry = NULL;
-	struct dentry *hidden_parent_dentry = NULL;
+	struct dentry *lower_dentry = NULL, *whiteout_dentry = NULL;
+	struct dentry *lower_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
 	int whiteout_unlinked = 0;
@@ -555,7 +555,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 
 	bstart = dbstart(dentry);
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
 	/*
 	 * check if whiteout exists in this branch, i.e. lookup .wh.foo
@@ -567,7 +567,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 		goto out;
 	}
 
-	whiteout_dentry = lookup_one_len(name, hidden_dentry->d_parent,
+	whiteout_dentry = lookup_one_len(name, lower_dentry->d_parent,
 					 dentry->d_name.len + UNIONFS_WHLEN);
 	if (IS_ERR(whiteout_dentry)) {
 		err = PTR_ERR(whiteout_dentry);
@@ -578,18 +578,18 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 		dput(whiteout_dentry);
 		whiteout_dentry = NULL;
 	} else {
-		hidden_parent_dentry = lock_parent(whiteout_dentry);
+		lower_parent_dentry = lock_parent(whiteout_dentry);
 
 		/* found a.wh.foo entry, remove it then do vfs_mkdir */
 		if (!(err = is_robranch_super(dentry->d_sb, bstart))) {
-			args.unlink.parent = hidden_parent_dentry->d_inode;
+			args.unlink.parent = lower_parent_dentry->d_inode;
 			args.unlink.dentry = whiteout_dentry;
 			run_sioq(__unionfs_unlink, &args);
 			err = args.err;
 		}
 		dput(whiteout_dentry);
 
-		unlock_dir(hidden_parent_dentry);
+		unlock_dir(lower_parent_dentry);
 
 		if (err) {
 			/* exit if the error returned was NOT -EROFS */
@@ -607,27 +607,27 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 		if (is_robranch_super(dentry->d_sb, bindex))
 			continue;
 
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry) {
-			hidden_dentry = create_parents(parent, dentry, bindex);
-			if (!hidden_dentry || IS_ERR(hidden_dentry)) {
-				printk(KERN_DEBUG "unionfs: hidden dentry "
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry) {
+			lower_dentry = create_parents(parent, dentry, bindex);
+			if (!lower_dentry || IS_ERR(lower_dentry)) {
+				printk(KERN_DEBUG "unionfs: lower dentry "
 				       " NULL for bindex = %d\n", bindex);
 				continue;
 			}
 		}
 
-		hidden_parent_dentry = lock_parent(hidden_dentry);
+		lower_parent_dentry = lock_parent(lower_dentry);
 
-		if (IS_ERR(hidden_parent_dentry)) {
-			err = PTR_ERR(hidden_parent_dentry);
+		if (IS_ERR(lower_parent_dentry)) {
+			err = PTR_ERR(lower_parent_dentry);
 			goto out;
 		}
 
-		err = vfs_mkdir(hidden_parent_dentry->d_inode, hidden_dentry,
+		err = vfs_mkdir(lower_parent_dentry->d_inode, lower_dentry,
 				mode);
 
-		unlock_dir(hidden_parent_dentry);
+		unlock_dir(lower_parent_dentry);
 
 		/* did the mkdir succeed? */
 		if (err)
@@ -644,9 +644,9 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 		err = unionfs_interpose(dentry, parent->i_sb, 0);
 		if (!err) {
 			fsstack_copy_attr_times(parent,
-						hidden_parent_dentry->d_inode);
+						lower_parent_dentry->d_inode);
 			fsstack_copy_inode_size(parent,
-						hidden_parent_dentry->d_inode);
+						lower_parent_dentry->d_inode);
 
 			/* update number of links on parent directory */
 			parent->i_nlink = unionfs_get_nlinks(parent);
@@ -678,8 +678,8 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 			 dev_t dev)
 {
 	int err = 0;
-	struct dentry *hidden_dentry = NULL, *whiteout_dentry = NULL;
-	struct dentry *hidden_parent_dentry = NULL;
+	struct dentry *lower_dentry = NULL, *whiteout_dentry = NULL;
+	struct dentry *lower_parent_dentry = NULL;
 	int bindex = 0, bstart;
 	char *name = NULL;
 	int whiteout_unlinked = 0;
@@ -695,7 +695,7 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 
 	bstart = dbstart(dentry);
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
 	/*
 	 * check if whiteout exists in this branch, i.e. lookup .wh.foo
@@ -707,7 +707,7 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		goto out;
 	}
 
-	whiteout_dentry = lookup_one_len(name, hidden_dentry->d_parent,
+	whiteout_dentry = lookup_one_len(name, lower_dentry->d_parent,
 					 dentry->d_name.len + UNIONFS_WHLEN);
 	if (IS_ERR(whiteout_dentry)) {
 		err = PTR_ERR(whiteout_dentry);
@@ -719,15 +719,15 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		whiteout_dentry = NULL;
 	} else {
 		/* found .wh.foo, unlink it */
-		hidden_parent_dentry = lock_parent(whiteout_dentry);
+		lower_parent_dentry = lock_parent(whiteout_dentry);
 
 		/* found a.wh.foo entry, remove it then do vfs_mkdir */
 		if (!(err = is_robranch_super(dentry->d_sb, bstart)))
-			err = vfs_unlink(hidden_parent_dentry->d_inode,
+			err = vfs_unlink(lower_parent_dentry->d_inode,
 					 whiteout_dentry);
 		dput(whiteout_dentry);
 
-		unlock_dir(hidden_parent_dentry);
+		unlock_dir(lower_parent_dentry);
 
 		if (err) {
 			if (!IS_COPYUP_ERR(err))
@@ -742,41 +742,41 @@ static int unionfs_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		if (is_robranch_super(dentry->d_sb, bindex))
 			continue;
 
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry) {
-			hidden_dentry = create_parents(dir, dentry, bindex);
-			if (IS_ERR(hidden_dentry)) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry) {
+			lower_dentry = create_parents(dir, dentry, bindex);
+			if (IS_ERR(lower_dentry)) {
 				printk(KERN_DEBUG "unionfs: failed to create "
 				       "parents on %d, err = %ld\n",
-				       bindex, PTR_ERR(hidden_dentry));
+				       bindex, PTR_ERR(lower_dentry));
 				continue;
 			}
 		}
 
-		hidden_parent_dentry = lock_parent(hidden_dentry);
-		if (IS_ERR(hidden_parent_dentry)) {
-			err = PTR_ERR(hidden_parent_dentry);
+		lower_parent_dentry = lock_parent(lower_dentry);
+		if (IS_ERR(lower_parent_dentry)) {
+			err = PTR_ERR(lower_parent_dentry);
 			goto out;
 		}
 
-		err = vfs_mknod(hidden_parent_dentry->d_inode,
-				hidden_dentry, mode, dev);
+		err = vfs_mknod(lower_parent_dentry->d_inode,
+				lower_dentry, mode, dev);
 
 		if (err) {
-			unlock_dir(hidden_parent_dentry);
+			unlock_dir(lower_parent_dentry);
 			break;
 		}
 
 		err = unionfs_interpose(dentry, dir->i_sb, 0);
 		if (!err) {
 			fsstack_copy_attr_times(dir,
-						hidden_parent_dentry->d_inode);
+						lower_parent_dentry->d_inode);
 			fsstack_copy_inode_size(dir,
-						hidden_parent_dentry->d_inode);
+						lower_parent_dentry->d_inode);
 			/* update number of links on parent directory */
 			dir->i_nlink = unionfs_get_nlinks(dir);
 		}
-		unlock_dir(hidden_parent_dentry);
+		unlock_dir(lower_parent_dentry);
 
 		break;
 	}
@@ -796,7 +796,7 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 			    int bufsiz)
 {
 	int err;
-	struct dentry *hidden_dentry;
+	struct dentry *lower_dentry;
 
 	unionfs_read_lock(dentry->d_sb);
 	unionfs_lock_dentry(dentry);
@@ -806,19 +806,19 @@ static int unionfs_readlink(struct dentry *dentry, char __user *buf,
 		goto out;
 	}
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
-	if (!hidden_dentry->d_inode->i_op ||
-	    !hidden_dentry->d_inode->i_op->readlink) {
+	if (!lower_dentry->d_inode->i_op ||
+	    !lower_dentry->d_inode->i_op->readlink) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	err = hidden_dentry->d_inode->i_op->readlink(hidden_dentry,
-						     buf, bufsiz);
+	err = lower_dentry->d_inode->i_op->readlink(lower_dentry,
+						    buf, bufsiz);
 	if (err > 0)
 		fsstack_copy_attr_atime(dentry->d_inode,
-					hidden_dentry->d_inode);
+					lower_dentry->d_inode);
 
 out:
 	unionfs_unlock_dentry(dentry);
@@ -950,7 +950,7 @@ static int inode_permission(struct inode *inode, int mask,
 static int unionfs_permission(struct inode *inode, int mask,
 			      struct nameidata *nd)
 {
-	struct inode *hidden_inode = NULL;
+	struct inode *lower_inode = NULL;
 	int err = 0;
 	int bindex, bstart, bend;
 	const int is_file = !S_ISDIR(inode->i_mode);
@@ -973,8 +973,8 @@ static int unionfs_permission(struct inode *inode, int mask,
 	}
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_inode = unionfs_lower_inode_idx(inode, bindex);
-		if (!hidden_inode)
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode)
 			continue;
 
 		/*
@@ -982,14 +982,14 @@ static int unionfs_permission(struct inode *inode, int mask,
 		 * we don't have to check for files, if we are checking for
 		 * directories.
 		 */
-		if (!is_file && !S_ISDIR(hidden_inode->i_mode))
+		if (!is_file && !S_ISDIR(lower_inode->i_mode))
 			continue;
 
 		/*
 		 * We use our own special version of permission, such that
 		 * only the first branch returns -EROFS.
 		 */
-		err = inode_permission(hidden_inode, mask, nd, bindex);
+		err = inode_permission(lower_inode, mask, nd, bindex);
 
 		/*
 		 * The permissions are an intersection of the overall directory
@@ -1001,9 +1001,9 @@ static int unionfs_permission(struct inode *inode, int mask,
 		/* only the leftmost file matters. */
 		if (is_file || write_mask) {
 			if (is_file && write_mask) {
-				err = get_write_access(hidden_inode);
+				err = get_write_access(lower_inode);
 				if (!err)
-					put_write_access(hidden_inode);
+					put_write_access(lower_inode);
 			}
 			break;
 		}
@@ -1017,9 +1017,9 @@ out:
 static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 {
 	int err = 0;
-	struct dentry *hidden_dentry;
+	struct dentry *lower_dentry;
 	struct inode *inode = NULL;
-	struct inode *hidden_inode = NULL;
+	struct inode *lower_inode = NULL;
 	int bstart, bend, bindex;
 	int i;
 	int copyup = 0;
@@ -1038,14 +1038,14 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 
 	for (bindex = bstart; (bindex <= bend) || (bindex == bstart);
 	     bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry)
 			continue;
-		BUG_ON(hidden_dentry->d_inode == NULL);
+		BUG_ON(lower_dentry->d_inode == NULL);
 
 		/* If the file is on a read only branch */
 		if (is_robranch_super(dentry->d_sb, bindex)
-		    || IS_RDONLY(hidden_dentry->d_inode)) {
+		    || IS_RDONLY(lower_dentry->d_inode)) {
 			if (copyup || (bindex != bstart))
 				continue;
 			/* Only if its the leftmost file, copyup the file */
@@ -1059,7 +1059,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 
 				if (!err) {
 					copyup = 1;
-					hidden_dentry =
+					lower_dentry =
 						unionfs_lower_dentry(dentry);
 					break;
 				}
@@ -1072,7 +1072,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 			}
 
 		}
-		err = notify_change(hidden_dentry, ia);
+		err = notify_change(lower_dentry, ia);
 		if (err)
 			goto out;
 		break;
@@ -1087,10 +1087,10 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 		}
 	}
 
-	/* get the size from the first hidden inode */
-	hidden_inode = unionfs_lower_inode(dentry->d_inode);
-	fsstack_copy_attr_all(inode, hidden_inode, unionfs_get_nlinks);
-	fsstack_copy_inode_size(inode, hidden_inode);
+	/* get the size from the first lower inode */
+	lower_inode = unionfs_lower_inode(dentry->d_inode);
+	fsstack_copy_attr_all(inode, lower_inode, unionfs_get_nlinks);
+	fsstack_copy_inode_size(inode, lower_inode);
 
 out:
 	unionfs_unlock_dentry(dentry);
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 8a09540..9d72a2c 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -33,39 +33,39 @@ static int is_validname(const char *name)
 static noinline int is_opaque_dir(struct dentry *dentry, int bindex)
 {
 	int err = 0;
-	struct dentry *hidden_dentry;
-	struct dentry *wh_hidden_dentry;
-	struct inode *hidden_inode;
+	struct dentry *lower_dentry;
+	struct dentry *wh_lower_dentry;
+	struct inode *lower_inode;
 	struct sioq_args args;
 
-	hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-	hidden_inode = hidden_dentry->d_inode;
+	lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+	lower_inode = lower_dentry->d_inode;
 
-	BUG_ON(!S_ISDIR(hidden_inode->i_mode));
+	BUG_ON(!S_ISDIR(lower_inode->i_mode));
 
-	mutex_lock(&hidden_inode->i_mutex);
+	mutex_lock(&lower_inode->i_mutex);
 
-	if (!permission(hidden_inode, MAY_EXEC, NULL))
-		wh_hidden_dentry =
-			lookup_one_len(UNIONFS_DIR_OPAQUE, hidden_dentry,
+	if (!permission(lower_inode, MAY_EXEC, NULL))
+		wh_lower_dentry =
+			lookup_one_len(UNIONFS_DIR_OPAQUE, lower_dentry,
 				       sizeof(UNIONFS_DIR_OPAQUE) - 1);
 	else {
-		args.is_opaque.dentry = hidden_dentry;
+		args.is_opaque.dentry = lower_dentry;
 		run_sioq(__is_opaque_dir, &args);
-		wh_hidden_dentry = args.ret;
+		wh_lower_dentry = args.ret;
 	}
 
-	mutex_unlock(&hidden_inode->i_mutex);
+	mutex_unlock(&lower_inode->i_mutex);
 
-	if (IS_ERR(wh_hidden_dentry)) {
-		err = PTR_ERR(wh_hidden_dentry);
+	if (IS_ERR(wh_lower_dentry)) {
+		err = PTR_ERR(wh_lower_dentry);
 		goto out;
 	}
 
-	/* This is an opaque dir iff wh_hidden_dentry is positive */
-	err = !!wh_hidden_dentry->d_inode;
+	/* This is an opaque dir iff wh_lower_dentry is positive */
+	err = !!wh_lower_dentry->d_inode;
 
-	dput(wh_hidden_dentry);
+	dput(wh_lower_dentry);
 out:
 	return err;
 }
@@ -75,16 +75,16 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 				      struct nameidata *nd, int lookupmode)
 {
 	int err = 0;
-	struct dentry *hidden_dentry = NULL;
-	struct dentry *wh_hidden_dentry = NULL;
-	struct dentry *hidden_dir_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
+	struct dentry *wh_lower_dentry = NULL;
+	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *parent_dentry = NULL;
 	int bindex, bstart, bend, bopaque;
 	int dentry_count = 0;	/* Number of positive dentries. */
 	int first_dentry_offset = -1; /* -1 is uninitialized */
 	struct dentry *first_dentry = NULL;
-	struct dentry *first_hidden_dentry = NULL;
-	struct vfsmount *first_hidden_mnt = NULL;
+	struct dentry *first_lower_dentry = NULL;
+	struct vfsmount *first_lower_mnt = NULL;
 	int locked_parent = 0;
 	int locked_child = 0;
 	int allocated_new_info = 0;
@@ -163,20 +163,20 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	}
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (lookupmode == INTERPOSE_PARTIAL && hidden_dentry)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (lookupmode == INTERPOSE_PARTIAL && lower_dentry)
 			continue;
-		BUG_ON(hidden_dentry != NULL);
+		BUG_ON(lower_dentry != NULL);
 
-		hidden_dir_dentry =
+		lower_dir_dentry =
 			unionfs_lower_dentry_idx(parent_dentry, bindex);
 
-		/* if the parent hidden dentry does not exist skip this */
-		if (!(hidden_dir_dentry && hidden_dir_dentry->d_inode))
+		/* if the parent lower dentry does not exist skip this */
+		if (!(lower_dir_dentry && lower_dir_dentry->d_inode))
 			continue;
 
 		/* also skip it if the parent isn't a directory. */
-		if (!S_ISDIR(hidden_dir_dentry->d_inode->i_mode))
+		if (!S_ISDIR(lower_dir_dentry->d_inode->i_mode))
 			continue;
 
 		/* Reuse the whiteout name because its value doesn't change. */
@@ -189,47 +189,47 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		}
 
 		/* check if whiteout exists in this branch: lookup .wh.foo */
-		wh_hidden_dentry = lookup_one_len(whname, hidden_dir_dentry,
-						  namelen + UNIONFS_WHLEN);
-		if (IS_ERR(wh_hidden_dentry)) {
-			dput(first_hidden_dentry);
+		wh_lower_dentry = lookup_one_len(whname, lower_dir_dentry,
+						 namelen + UNIONFS_WHLEN);
+		if (IS_ERR(wh_lower_dentry)) {
+			dput(first_lower_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
-			err = PTR_ERR(wh_hidden_dentry);
+			err = PTR_ERR(wh_lower_dentry);
 			goto out_free;
 		}
 
-		if (wh_hidden_dentry->d_inode) {
+		if (wh_lower_dentry->d_inode) {
 			/* We found a whiteout so lets give up. */
-			if (S_ISREG(wh_hidden_dentry->d_inode->i_mode)) {
+			if (S_ISREG(wh_lower_dentry->d_inode->i_mode)) {
 				set_dbend(dentry, bindex);
 				set_dbopaque(dentry, bindex);
-				dput(wh_hidden_dentry);
+				dput(wh_lower_dentry);
 				break;
 			}
 			err = -EIO;
 			printk(KERN_NOTICE "unionfs: EIO: invalid whiteout "
 			       "entry type %d.\n",
-			       wh_hidden_dentry->d_inode->i_mode);
-			dput(wh_hidden_dentry);
-			dput(first_hidden_dentry);
+			       wh_lower_dentry->d_inode->i_mode);
+			dput(wh_lower_dentry);
+			dput(first_lower_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
 			goto out_free;
 		}
 
-		dput(wh_hidden_dentry);
-		wh_hidden_dentry = NULL;
+		dput(wh_lower_dentry);
+		wh_lower_dentry = NULL;
 
 		/* Now do regular lookup; lookup foo */
 		nd->dentry = unionfs_lower_dentry_idx(dentry, bindex);
 		/* FIXME: fix following line for mount point crossing */
 		nd->mnt = unionfs_lower_mnt_idx(parent_dentry, bindex);
 
-		hidden_dentry = lookup_one_len_nd(name, hidden_dir_dentry,
-						  namelen, nd);
-		if (IS_ERR(hidden_dentry)) {
-			dput(first_hidden_dentry);
+		lower_dentry = lookup_one_len_nd(name, lower_dir_dentry,
+						 namelen, nd);
+		if (IS_ERR(lower_dentry)) {
+			dput(first_lower_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
-			err = PTR_ERR(hidden_dentry);
+			err = PTR_ERR(lower_dentry);
 			goto out_free;
 		}
 
@@ -237,19 +237,19 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		 * Store the first negative dentry specially, because if they
 		 * are all negative we need this for future creates.
 		 */
-		if (!hidden_dentry->d_inode) {
-			if (!first_hidden_dentry && (dbstart(dentry) == -1)) {
-				first_hidden_dentry = hidden_dentry;
+		if (!lower_dentry->d_inode) {
+			if (!first_lower_dentry && (dbstart(dentry) == -1)) {
+				first_lower_dentry = lower_dentry;
 				/*
 				 * FIXME: following line needs to be changed
 				 * to allow mount-point crossing
 				 */
 				first_dentry = parent_dentry;
-				first_hidden_mnt =
+				first_lower_mnt =
 					unionfs_mntget(parent_dentry, bindex);
 				first_dentry_offset = bindex;
 			} else
-				dput(hidden_dentry);
+				dput(lower_dentry);
 
 			continue;
 		}
@@ -260,7 +260,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		/* store underlying dentry */
 		if (dbstart(dentry) == -1)
 			set_dbstart(dentry, bindex);
-		unionfs_set_lower_dentry_idx(dentry, bindex, hidden_dentry);
+		unionfs_set_lower_dentry_idx(dentry, bindex, lower_dentry);
 		/*
 		 * FIXME: the following line needs to get fixed to allow
 		 * mount-point crossing
@@ -272,10 +272,10 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 
 		/* update parent directory's atime with the bindex */
 		fsstack_copy_attr_atime(parent_dentry->d_inode,
-					hidden_dir_dentry->d_inode);
+					lower_dir_dentry->d_inode);
 
 		/* We terminate file lookups here. */
-		if (!S_ISDIR(hidden_dentry->d_inode->i_mode)) {
+		if (!S_ISDIR(lower_dentry->d_inode->i_mode)) {
 			if (lookupmode == INTERPOSE_PARTIAL)
 				continue;
 			if (dentry_count == 1)
@@ -288,7 +288,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 
 		opaque = is_opaque_dir(dentry, bindex);
 		if (opaque < 0) {
-			dput(first_hidden_dentry);
+			dput(first_lower_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
 			err = opaque;
 			goto out_free;
@@ -321,12 +321,12 @@ out_negative:
 		/* FIXME: fix following line for mount point crossing */
 		nd->mnt = unionfs_lower_mnt_idx(parent_dentry, bindex);
 
-		first_hidden_dentry =
-			lookup_one_len_nd(name, hidden_dir_dentry,
+		first_lower_dentry =
+			lookup_one_len_nd(name, lower_dir_dentry,
 					  namelen, nd);
 		first_dentry_offset = bindex;
-		if (IS_ERR(first_hidden_dentry)) {
-			err = PTR_ERR(first_hidden_dentry);
+		if (IS_ERR(first_lower_dentry)) {
+			err = PTR_ERR(first_lower_dentry);
 			goto out;
 		}
 
@@ -335,12 +335,12 @@ out_negative:
 		 * mount-point crossing
 		 */
 		first_dentry = dentry;
-		first_hidden_mnt = unionfs_mntget(dentry, bindex);
+		first_lower_mnt = unionfs_mntget(dentry, bindex);
 	}
 	unionfs_set_lower_dentry_idx(dentry, first_dentry_offset,
-				     first_hidden_dentry);
+				     first_lower_dentry);
 	unionfs_set_lower_mnt_idx(dentry, first_dentry_offset,
-				  first_hidden_mnt);
+				  first_lower_mnt);
 	set_dbstart(dentry, first_dentry_offset);
 	set_dbend(dentry, first_dentry_offset);
 
@@ -358,7 +358,7 @@ out_positive:
 	 * If we're holding onto the first negative dentry & corresponding
 	 * vfsmount - throw it out.
 	 */
-	dput(first_hidden_dentry);
+	dput(first_lower_dentry);
 	unionfs_mntput(first_dentry, first_dentry_offset);
 
 	/* Partial lookups need to re-interpose, or throw away older negs. */
@@ -533,17 +533,17 @@ void update_bstart(struct dentry *dentry)
 	int bindex;
 	int bstart = dbstart(dentry);
 	int bend = dbend(dentry);
-	struct dentry *hidden_dentry;
+	struct dentry *lower_dentry;
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry)
 			continue;
-		if (hidden_dentry->d_inode) {
+		if (lower_dentry->d_inode) {
 			set_dbstart(dentry, bindex);
 			break;
 		}
-		dput(hidden_dentry);
+		dput(lower_dentry);
 		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
 	}
 }
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index c6bf729..1ea7894 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -28,8 +28,8 @@
  */
 int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 {
-	struct inode *hidden_inode;
-	struct dentry *hidden_dentry;
+	struct inode *lower_inode;
+	struct dentry *lower_dentry;
 	int err = 0;
 	struct inode *inode;
 	int is_negative_dentry = 1;
@@ -86,45 +86,45 @@ int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 	}
 
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry) {
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry) {
 			unionfs_set_lower_inode_idx(inode, bindex, NULL);
 			continue;
 		}
 
-		/* Initialize the hidden inode to the new hidden inode. */
-		if (!hidden_dentry->d_inode)
+		/* Initialize the lower inode to the new lower inode. */
+		if (!lower_dentry->d_inode)
 			continue;
 
 		unionfs_set_lower_inode_idx(inode, bindex,
-					    igrab(hidden_dentry->d_inode));
+					    igrab(lower_dentry->d_inode));
 	}
 
 	ibstart(inode) = dbstart(dentry);
 	ibend(inode) = dbend(dentry);
 
 	/* Use attributes from the first branch. */
-	hidden_inode = unionfs_lower_inode(inode);
+	lower_inode = unionfs_lower_inode(inode);
 
 	/* Use different set of inode ops for symlinks & directories */
-	if (S_ISLNK(hidden_inode->i_mode))
+	if (S_ISLNK(lower_inode->i_mode))
 		inode->i_op = &unionfs_symlink_iops;
-	else if (S_ISDIR(hidden_inode->i_mode))
+	else if (S_ISDIR(lower_inode->i_mode))
 		inode->i_op = &unionfs_dir_iops;
 
 	/* Use different set of file ops for directories */
-	if (S_ISDIR(hidden_inode->i_mode))
+	if (S_ISDIR(lower_inode->i_mode))
 		inode->i_fop = &unionfs_dir_fops;
 
 	/* properly initialize special inodes */
-	if (S_ISBLK(hidden_inode->i_mode) || S_ISCHR(hidden_inode->i_mode) ||
-	    S_ISFIFO(hidden_inode->i_mode) || S_ISSOCK(hidden_inode->i_mode))
-		init_special_inode(inode, hidden_inode->i_mode,
-				   hidden_inode->i_rdev);
+	if (S_ISBLK(lower_inode->i_mode) || S_ISCHR(lower_inode->i_mode) ||
+	    S_ISFIFO(lower_inode->i_mode) || S_ISSOCK(lower_inode->i_mode))
+		init_special_inode(inode, lower_inode->i_mode,
+				   lower_inode->i_rdev);
 
 	/* all well, copy inode attributes */
-	fsstack_copy_attr_all(inode, hidden_inode, unionfs_get_nlinks);
-	fsstack_copy_inode_size(inode, hidden_inode);
+	fsstack_copy_attr_all(inode, lower_inode, unionfs_get_nlinks);
+	fsstack_copy_inode_size(inode, lower_inode);
 
 skip:
 	/* only (our) lookup wants to do a d_add */
@@ -151,7 +151,7 @@ out:
 /* like interpose above, but for an already existing dentry */
 void unionfs_reinterpose(struct dentry *dentry)
 {
-	struct dentry *hidden_dentry;
+	struct dentry *lower_dentry;
 	struct inode *inode;
 	int bindex, bstart, bend;
 
@@ -163,16 +163,16 @@ void unionfs_reinterpose(struct dentry *dentry)
 	bstart = dbstart(dentry);
 	bend = dbend(dentry);
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry)
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!lower_dentry)
 			continue;
 
-		if (!hidden_dentry->d_inode)
+		if (!lower_dentry->d_inode)
 			continue;
 		if (unionfs_lower_inode_idx(inode, bindex))
 			continue;
 		unionfs_set_lower_inode_idx(inode, bindex,
-					    igrab(hidden_dentry->d_inode));
+					    igrab(lower_dentry->d_inode));
 	}
 	ibstart(inode) = dbstart(dentry);
 	ibend(inode) = dbend(dentry);
@@ -196,7 +196,7 @@ int check_branch(struct nameidata *nd)
 	return 0;
 }
 
-/* checks if two hidden_dentries have overlapping branches */
+/* checks if two lower_dentries have overlapping branches */
 static int is_branch_overlap(struct dentry *dent1, struct dentry *dent2)
 {
 	struct dentry *dent = NULL;
@@ -250,7 +250,7 @@ int parse_branch_mode(const char *name)
  * can even get a reference to us.
  */
 static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
-			     *hidden_root_info, char *options)
+			     *lower_root_info, char *options)
 {
 	struct nameidata nd;
 	char *name;
@@ -277,7 +277,7 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		if (options[i] == ':')
 			branches++;
 
-	/* allocate space for underlying pointers to hidden dentry */
+	/* allocate space for underlying pointers to lower dentry */
 	UNIONFS_SB(sb)->data =
 		kcalloc(branches, sizeof(struct unionfs_data), GFP_KERNEL);
 	if (!UNIONFS_SB(sb)->data) {
@@ -285,9 +285,9 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		goto out;
 	}
 
-	hidden_root_info->lower_paths =
+	lower_root_info->lower_paths =
 		kcalloc(branches, sizeof(struct path), GFP_KERNEL);
-	if (!hidden_root_info->lower_paths) {
+	if (!lower_root_info->lower_paths) {
 		err = -ENOMEM;
 		goto out;
 	}
@@ -316,28 +316,28 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		err = path_lookup(name, LOOKUP_FOLLOW, &nd);
 		if (err) {
 			printk(KERN_WARNING "unionfs: error accessing "
-			       "hidden directory '%s' (error %d)\n",
+			       "lower directory '%s' (error %d)\n",
 			       name, err);
 			goto out;
 		}
 
 		if ((err = check_branch(&nd))) {
-			printk(KERN_WARNING "unionfs: hidden directory "
+			printk(KERN_WARNING "unionfs: lower directory "
 			       "'%s' is not a valid branch\n", name);
 			path_release(&nd);
 			goto out;
 		}
 
-		hidden_root_info->lower_paths[bindex].dentry = nd.dentry;
-		hidden_root_info->lower_paths[bindex].mnt = nd.mnt;
+		lower_root_info->lower_paths[bindex].dentry = nd.dentry;
+		lower_root_info->lower_paths[bindex].mnt = nd.mnt;
 
 		set_branchperms(sb, bindex, perms);
 		set_branch_count(sb, bindex, 0);
 		new_branch_id(sb, bindex);
 
-		if (hidden_root_info->bstart < 0)
-			hidden_root_info->bstart = bindex;
-		hidden_root_info->bend = bindex;
+		if (lower_root_info->bstart < 0)
+			lower_root_info->bstart = bindex;
+		lower_root_info->bend = bindex;
 		bindex++;
 	}
 
@@ -347,7 +347,7 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 		goto out;
 	}
 
-	BUG_ON(branches != (hidden_root_info->bend + 1));
+	BUG_ON(branches != (lower_root_info->bend + 1));
 
 	/*
 	 * Ensure that no overlaps exist in the branches.
@@ -366,8 +366,8 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 	 */
 	for (i = 0; i < branches; i++) {
 		for (j = i + 1; j < branches; j++) {
-			dent1 = hidden_root_info->lower_paths[i].dentry;
-			dent2 = hidden_root_info->lower_paths[j].dentry;
+			dent1 = lower_root_info->lower_paths[i].dentry;
+			dent2 = lower_root_info->lower_paths[j].dentry;
 
 			if (is_branch_overlap(dent1, dent2)) {
 				printk(KERN_WARNING "unionfs: branches %d and "
@@ -381,20 +381,20 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 out:
 	if (err) {
 		for (i = 0; i < branches; i++)
-			if (hidden_root_info->lower_paths[i].dentry) {
-				dput(hidden_root_info->lower_paths[i].dentry);
+			if (lower_root_info->lower_paths[i].dentry) {
+				dput(lower_root_info->lower_paths[i].dentry);
 				/* initialize: can't use unionfs_mntput here */
-				mntput(hidden_root_info->lower_paths[i].mnt);
+				mntput(lower_root_info->lower_paths[i].mnt);
 			}
 
-		kfree(hidden_root_info->lower_paths);
+		kfree(lower_root_info->lower_paths);
 		kfree(UNIONFS_SB(sb)->data);
 
 		/*
 		 * MUST clear the pointers to prevent potential double free if
 		 * the caller dies later on
 		 */
-		hidden_root_info->lower_paths = NULL;
+		lower_root_info->lower_paths = NULL;
 		UNIONFS_SB(sb)->data = NULL;
 	}
 	return err;
@@ -403,14 +403,14 @@ out:
 /*
  * Parse mount options.  See the manual page for usage instructions.
  *
- * Returns the dentry object of the lower-level (hidden) directory;
- * We want to mount our stackable file system on top of that hidden directory.
+ * Returns the dentry object of the lower-level (lower) directory;
+ * We want to mount our stackable file system on top of that lower directory.
  */
 static struct unionfs_dentry_info *unionfs_parse_options(
 					struct super_block *sb,
 					char *options)
 {
-	struct unionfs_dentry_info *hidden_root_info;
+	struct unionfs_dentry_info *lower_root_info;
 	char *optname;
 	int err = 0;
 	int bindex;
@@ -418,13 +418,13 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 
 	/* allocate private data area */
 	err = -ENOMEM;
-	hidden_root_info =
+	lower_root_info =
 		kzalloc(sizeof(struct unionfs_dentry_info), GFP_KERNEL);
-	if (!hidden_root_info)
+	if (!lower_root_info)
 		goto out_error;
-	hidden_root_info->bstart = -1;
-	hidden_root_info->bend = -1;
-	hidden_root_info->bopaque = -1;
+	lower_root_info->bstart = -1;
+	lower_root_info->bend = -1;
+	lower_root_info->bopaque = -1;
 
 	while ((optname = strsep(&options, ",")) != NULL) {
 		char *optarg;
@@ -455,7 +455,7 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 				err = -EINVAL;
 				goto out_error;
 			}
-			err = parse_dirs_option(sb, hidden_root_info, optarg);
+			err = parse_dirs_option(sb, lower_root_info, optarg);
 			if (err)
 				goto out_error;
 			continue;
@@ -484,15 +484,15 @@ static struct unionfs_dentry_info *unionfs_parse_options(
 	goto out;
 
 out_error:
-	if (hidden_root_info && hidden_root_info->lower_paths) {
-		for (bindex = hidden_root_info->bstart;
-		     bindex >= 0 && bindex <= hidden_root_info->bend;
+	if (lower_root_info && lower_root_info->lower_paths) {
+		for (bindex = lower_root_info->bstart;
+		     bindex >= 0 && bindex <= lower_root_info->bend;
 		     bindex++) {
 			struct dentry *d;
 			struct vfsmount *m;
 
-			d = hidden_root_info->lower_paths[bindex].dentry;
-			m = hidden_root_info->lower_paths[bindex].mnt;
+			d = lower_root_info->lower_paths[bindex].dentry;
+			m = lower_root_info->lower_paths[bindex].mnt;
 
 			dput(d);
 			/* initializing: can't use unionfs_mntput here */
@@ -500,15 +500,15 @@ out_error:
 		}
 	}
 
-	kfree(hidden_root_info->lower_paths);
-	kfree(hidden_root_info);
+	kfree(lower_root_info->lower_paths);
+	kfree(lower_root_info);
 
 	kfree(UNIONFS_SB(sb)->data);
 	UNIONFS_SB(sb)->data = NULL;
 
-	hidden_root_info = ERR_PTR(err);
+	lower_root_info = ERR_PTR(err);
 out:
-	return hidden_root_info;
+	return lower_root_info;
 }
 
 /*
@@ -543,7 +543,7 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 {
 	int err = 0;
 
-	struct unionfs_dentry_info *hidden_root_info = NULL;
+	struct unionfs_dentry_info *lower_root_info = NULL;
 	int bindex, bstart, bend;
 
 	if (!raw_data) {
@@ -566,26 +566,26 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	init_rwsem(&UNIONFS_SB(sb)->rwsem);
 	UNIONFS_SB(sb)->high_branch_id = -1; /* -1 == invalid branch ID */
 
-	hidden_root_info = unionfs_parse_options(sb, raw_data);
-	if (IS_ERR(hidden_root_info)) {
+	lower_root_info = unionfs_parse_options(sb, raw_data);
+	if (IS_ERR(lower_root_info)) {
 		printk(KERN_WARNING
 		       "unionfs: read_super: error while parsing options "
-		       "(err = %ld)\n", PTR_ERR(hidden_root_info));
-		err = PTR_ERR(hidden_root_info);
-		hidden_root_info = NULL;
+		       "(err = %ld)\n", PTR_ERR(lower_root_info));
+		err = PTR_ERR(lower_root_info);
+		lower_root_info = NULL;
 		goto out_free;
 	}
-	if (hidden_root_info->bstart == -1) {
+	if (lower_root_info->bstart == -1) {
 		err = -ENOENT;
 		goto out_free;
 	}
 
-	/* set the hidden superblock field of upper superblock */
-	bstart = hidden_root_info->bstart;
+	/* set the lower superblock field of upper superblock */
+	bstart = lower_root_info->bstart;
 	BUG_ON(bstart != 0);
-	sbend(sb) = bend = hidden_root_info->bend;
+	sbend(sb) = bend = lower_root_info->bend;
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		struct dentry *d = hidden_root_info->lower_paths[bindex].dentry;
+		struct dentry *d = lower_root_info->lower_paths[bindex].dentry;
 		unionfs_set_lower_super_idx(sb, bindex, d->d_sb);
 	}
 
@@ -606,13 +606,13 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	if ((err = new_dentry_private_data(sb->s_root)))
 		goto out_freedpd;
 
-	/* Set the hidden dentries for s_root */
+	/* Set the lower dentries for s_root */
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		struct dentry *d;
 		struct vfsmount *m;
 
-		d = hidden_root_info->lower_paths[bindex].dentry;
-		m = hidden_root_info->lower_paths[bindex].mnt;
+		d = lower_root_info->lower_paths[bindex].dentry;
+		m = lower_root_info->lower_paths[bindex].mnt;
 
 		unionfs_set_lower_dentry_idx(sb->s_root, bindex, d);
 		unionfs_set_lower_mnt_idx(sb->s_root, bindex, m);
@@ -638,22 +638,22 @@ out_freedpd:
 	dput(sb->s_root);
 
 out_dput:
-	if (hidden_root_info && !IS_ERR(hidden_root_info)) {
-		for (bindex = hidden_root_info->bstart;
-		     bindex <= hidden_root_info->bend; bindex++) {
+	if (lower_root_info && !IS_ERR(lower_root_info)) {
+		for (bindex = lower_root_info->bstart;
+		     bindex <= lower_root_info->bend; bindex++) {
 			struct dentry *d;
 			struct vfsmount *m;
 
-			d = hidden_root_info->lower_paths[bindex].dentry;
-			m = hidden_root_info->lower_paths[bindex].mnt;
+			d = lower_root_info->lower_paths[bindex].dentry;
+			m = lower_root_info->lower_paths[bindex].mnt;
 
 			dput(d);
 			/* initializing: can't use unionfs_mntput here */
 			mntput(m);
 		}
-		kfree(hidden_root_info->lower_paths);
-		kfree(hidden_root_info);
-		hidden_root_info = NULL;
+		kfree(lower_root_info->lower_paths);
+		kfree(lower_root_info);
+		lower_root_info = NULL;
 	}
 
 out_free:
@@ -662,9 +662,9 @@ out_free:
 	sb->s_fs_info = NULL;
 
 out:
-	if (hidden_root_info && !IS_ERR(hidden_root_info)) {
-		kfree(hidden_root_info->lower_paths);
-		kfree(hidden_root_info);
+	if (lower_root_info && !IS_ERR(lower_root_info)) {
+		kfree(lower_root_info->lower_paths);
+		kfree(lower_root_info);
 	}
 	return err;
 }
diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index f0525ff..06ad5a8 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -64,7 +64,7 @@ void unionfs_destroy_filldir_cache(void)
 #define MINHASHSIZE 1
 static int guesstimate_hash_size(struct inode *inode)
 {
-	struct inode *hidden_inode;
+	struct inode *lower_inode;
 	int bindex;
 	int hashsize = MINHASHSIZE;
 
@@ -72,13 +72,13 @@ static int guesstimate_hash_size(struct inode *inode)
 		return UNIONFS_I(inode)->hashsize;
 
 	for (bindex = ibstart(inode); bindex <= ibend(inode); bindex++) {
-		if (!(hidden_inode = unionfs_lower_inode_idx(inode, bindex)))
+		if (!(lower_inode = unionfs_lower_inode_idx(inode, bindex)))
 			continue;
 
-		if (hidden_inode->i_size == DENTPAGE)
+		if (lower_inode->i_size == DENTPAGE)
 			hashsize += DENTPERONEPAGE;
 		else
-			hashsize += (hidden_inode->i_size / DENTPAGE) *
+			hashsize += (lower_inode->i_size / DENTPAGE) *
 				DENTPERPAGE;
 	}
 
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index 861c8db..8a159d1 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -23,26 +23,26 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			    int bindex, struct dentry **wh_old)
 {
 	int err = 0;
-	struct dentry *hidden_old_dentry;
-	struct dentry *hidden_new_dentry;
-	struct dentry *hidden_old_dir_dentry;
-	struct dentry *hidden_new_dir_dentry;
-	struct dentry *hidden_wh_dentry;
-	struct dentry *hidden_wh_dir_dentry;
+	struct dentry *lower_old_dentry;
+	struct dentry *lower_new_dentry;
+	struct dentry *lower_old_dir_dentry;
+	struct dentry *lower_new_dir_dentry;
+	struct dentry *lower_wh_dentry;
+	struct dentry *lower_wh_dir_dentry;
 	char *wh_name = NULL;
 
-	hidden_new_dentry = unionfs_lower_dentry_idx(new_dentry, bindex);
-	hidden_old_dentry = unionfs_lower_dentry_idx(old_dentry, bindex);
+	lower_new_dentry = unionfs_lower_dentry_idx(new_dentry, bindex);
+	lower_old_dentry = unionfs_lower_dentry_idx(old_dentry, bindex);
 
-	if (!hidden_new_dentry) {
-		hidden_new_dentry =
+	if (!lower_new_dentry) {
+		lower_new_dentry =
 			create_parents(new_dentry->d_parent->d_inode,
 				       new_dentry, bindex);
-		if (IS_ERR(hidden_new_dentry)) {
+		if (IS_ERR(lower_new_dentry)) {
 			printk(KERN_DEBUG "unionfs: error creating directory "
 			       "tree for rename, bindex = %d, err = %ld\n",
-			       bindex, PTR_ERR(hidden_new_dentry));
-			err = PTR_ERR(hidden_new_dentry);
+			       bindex, PTR_ERR(lower_new_dentry));
+			err = PTR_ERR(lower_new_dentry);
 			goto out;
 		}
 	}
@@ -54,42 +54,42 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto out;
 	}
 
-	hidden_wh_dentry = lookup_one_len(wh_name, hidden_new_dentry->d_parent,
+	lower_wh_dentry = lookup_one_len(wh_name, lower_new_dentry->d_parent,
 					  new_dentry->d_name.len +
 					  UNIONFS_WHLEN);
-	if (IS_ERR(hidden_wh_dentry)) {
-		err = PTR_ERR(hidden_wh_dentry);
+	if (IS_ERR(lower_wh_dentry)) {
+		err = PTR_ERR(lower_wh_dentry);
 		goto out;
 	}
 
-	if (hidden_wh_dentry->d_inode) {
+	if (lower_wh_dentry->d_inode) {
 		/* get rid of the whiteout that is existing */
-		if (hidden_new_dentry->d_inode) {
+		if (lower_new_dentry->d_inode) {
 			printk(KERN_WARNING "unionfs: both a whiteout and a "
 			       "dentry exist when doing a rename!\n");
 			err = -EIO;
 
-			dput(hidden_wh_dentry);
+			dput(lower_wh_dentry);
 			goto out;
 		}
 
-		hidden_wh_dir_dentry = lock_parent(hidden_wh_dentry);
+		lower_wh_dir_dentry = lock_parent(lower_wh_dentry);
 		if (!(err = is_robranch_super(old_dentry->d_sb, bindex)))
-			err = vfs_unlink(hidden_wh_dir_dentry->d_inode,
-					 hidden_wh_dentry);
+			err = vfs_unlink(lower_wh_dir_dentry->d_inode,
+					 lower_wh_dentry);
 
-		dput(hidden_wh_dentry);
-		unlock_dir(hidden_wh_dir_dentry);
+		dput(lower_wh_dentry);
+		unlock_dir(lower_wh_dir_dentry);
 		if (err)
 			goto out;
 	} else
-		dput(hidden_wh_dentry);
+		dput(lower_wh_dentry);
 
-	dget(hidden_old_dentry);
-	hidden_old_dir_dentry = dget_parent(hidden_old_dentry);
-	hidden_new_dir_dentry = dget_parent(hidden_new_dentry);
+	dget(lower_old_dentry);
+	lower_old_dir_dentry = dget_parent(lower_old_dentry);
+	lower_new_dir_dentry = dget_parent(lower_new_dentry);
 
-	lock_rename(hidden_old_dir_dentry, hidden_new_dir_dentry);
+	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 
 	err = is_robranch_super(old_dentry->d_sb, bindex);
 	if (err)
@@ -106,7 +106,7 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		err = PTR_ERR(whname);
 		if (IS_ERR(whname))
 			goto out_unlock;
-		*wh_old = lookup_one_len(whname, hidden_old_dir_dentry,
+		*wh_old = lookup_one_len(whname, lower_old_dir_dentry,
 					 old_dentry->d_name.len +
 					 UNIONFS_WHLEN);
 		kfree(whname);
@@ -117,15 +117,15 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
-	err = vfs_rename(hidden_old_dir_dentry->d_inode, hidden_old_dentry,
-			 hidden_new_dir_dentry->d_inode, hidden_new_dentry);
+	err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
+			 lower_new_dir_dentry->d_inode, lower_new_dentry);
 
 out_unlock:
-	unlock_rename(hidden_old_dir_dentry, hidden_new_dir_dentry);
+	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 
-	dput(hidden_old_dir_dentry);
-	dput(hidden_new_dir_dentry);
-	dput(hidden_old_dentry);
+	dput(lower_old_dir_dentry);
+	dput(lower_new_dir_dentry);
+	dput(lower_old_dentry);
 
 out:
 	if (!err) {
@@ -251,12 +251,12 @@ static int do_unionfs_rename(struct inode *old_dir,
 	 * (2) We did a copy_up
 	 */
 	if ((old_bstart != old_bend) || (do_copyup != -1)) {
-		struct dentry *hidden_parent;
+		struct dentry *lower_parent;
 		BUG_ON(!wh_old || wh_old->d_inode || bwh_old < 0);
-		hidden_parent = lock_parent(wh_old);
-		local_err = vfs_create(hidden_parent->d_inode, wh_old, S_IRUGO,
+		lower_parent = lock_parent(wh_old);
+		local_err = vfs_create(lower_parent->d_inode, wh_old, S_IRUGO,
 				       NULL);
-		unlock_dir(hidden_parent);
+		unlock_dir(lower_parent);
 		if (!local_err)
 			set_dbopaque(old_dentry, bwh_old);
 		else {
@@ -276,14 +276,14 @@ out:
 
 revert:
 	/* Do revert here. */
-	local_err = unionfs_refresh_hidden_dentry(new_dentry, old_bstart);
+	local_err = unionfs_refresh_lower_dentry(new_dentry, old_bstart);
 	if (local_err) {
 		printk(KERN_WARNING "unionfs: revert failed in rename: "
 		       "the new refresh failed.\n");
 		eio = -EIO;
 	}
 
-	local_err = unionfs_refresh_hidden_dentry(old_dentry, old_bstart);
+	local_err = unionfs_refresh_lower_dentry(old_dentry, old_bstart);
 	if (local_err) {
 		printk(KERN_WARNING "unionfs: revert failed in rename: "
 		       "the old refresh failed.\n");
@@ -316,10 +316,10 @@ revert:
 		eio = -EIO;
 	}
 
-	local_err = unionfs_refresh_hidden_dentry(new_dentry, bindex);
+	local_err = unionfs_refresh_lower_dentry(new_dentry, bindex);
 	if (local_err)
 		eio = -EIO;
-	local_err = unionfs_refresh_hidden_dentry(old_dentry, bindex);
+	local_err = unionfs_refresh_lower_dentry(old_dentry, bindex);
 	if (local_err)
 		eio = -EIO;
 
@@ -333,7 +333,7 @@ static struct dentry *lookup_whiteout(struct dentry *dentry)
 {
 	char *whname;
 	int bindex = -1, bstart = -1, bend = -1;
-	struct dentry *parent, *hidden_parent, *wh_dentry;
+	struct dentry *parent, *lower_parent, *wh_dentry;
 
 	whname = alloc_whname(dentry->d_name.name, dentry->d_name.len);
 	if (IS_ERR(whname))
@@ -345,10 +345,10 @@ static struct dentry *lookup_whiteout(struct dentry *dentry)
 	bend = dbend(parent);
 	wh_dentry = ERR_PTR(-ENOENT);
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_parent = unionfs_lower_dentry_idx(parent, bindex);
-		if (!hidden_parent)
+		lower_parent = unionfs_lower_dentry_idx(parent, bindex);
+		if (!lower_parent)
 			continue;
-		wh_dentry = lookup_one_len(whname, hidden_parent,
+		wh_dentry = lookup_one_len(whname, lower_parent,
 					   dentry->d_name.len + UNIONFS_WHLEN);
 		if (IS_ERR(wh_dentry))
 			continue;
@@ -424,7 +424,7 @@ int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto out;
 
 	/*
-	 * if new_dentry is already hidden because of whiteout,
+	 * if new_dentry is already lower because of whiteout,
 	 * simply override it even if the whited-out dir is not empty.
 	 */
 	wh_dentry = lookup_whiteout(new_dentry);
@@ -465,7 +465,7 @@ out:
 	else
 		/*
 		 * force re-lookup since the dir on ro branch is not renamed,
-		 * and hidden dentries still indicate the un-renamed ones.
+		 * and lower dentries still indicate the un-renamed ones.
 		 */
 		if (S_ISDIR(old_dentry->d_inode->i_mode))
 			atomic_dec(&UNIONFS_D(old_dentry)->generation);
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index d5689f5..0c8b0aa 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -26,9 +26,9 @@
 int create_whiteout(struct dentry *dentry, int start)
 {
 	int bstart, bend, bindex;
-	struct dentry *hidden_dir_dentry;
-	struct dentry *hidden_dentry;
-	struct dentry *hidden_wh_dentry;
+	struct dentry *lower_dir_dentry;
+	struct dentry *lower_dentry;
+	struct dentry *lower_wh_dentry;
 	char *name = NULL;
 	int err = -EINVAL;
 
@@ -45,49 +45,49 @@ int create_whiteout(struct dentry *dentry, int start)
 	}
 
 	for (bindex = start; bindex >= 0; bindex--) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
 
-		if (!hidden_dentry) {
+		if (!lower_dentry) {
 			/*
-			 * if hidden dentry is not present, create the
-			 * entire hidden dentry directory structure and go
+			 * if lower dentry is not present, create the
+			 * entire lower dentry directory structure and go
 			 * ahead.  Since we want to just create whiteout, we
 			 * only want the parent dentry, and hence get rid of
 			 * this dentry.
 			 */
-			hidden_dentry = create_parents(dentry->d_inode,
-						       dentry, bindex);
-			if (!hidden_dentry || IS_ERR(hidden_dentry)) {
+			lower_dentry = create_parents(dentry->d_inode,
+						      dentry, bindex);
+			if (!lower_dentry || IS_ERR(lower_dentry)) {
 				printk(KERN_DEBUG "unionfs: create_parents "
 				       "failed for bindex = %d\n", bindex);
 				continue;
 			}
 		}
 
-		hidden_wh_dentry =
-			lookup_one_len(name, hidden_dentry->d_parent,
+		lower_wh_dentry =
+			lookup_one_len(name, lower_dentry->d_parent,
 				       dentry->d_name.len + UNIONFS_WHLEN);
-		if (IS_ERR(hidden_wh_dentry))
+		if (IS_ERR(lower_wh_dentry))
 			continue;
 
 		/*
 		 * The whiteout already exists. This used to be impossible,
 		 * but now is possible because of opaqueness.
 		 */
-		if (hidden_wh_dentry->d_inode) {
-			dput(hidden_wh_dentry);
+		if (lower_wh_dentry->d_inode) {
+			dput(lower_wh_dentry);
 			err = 0;
 			goto out;
 		}
 
-		hidden_dir_dentry = lock_parent(hidden_wh_dentry);
+		lower_dir_dentry = lock_parent(lower_wh_dentry);
 		if (!(err = is_robranch_super(dentry->d_sb, bindex)))
-			err = vfs_create(hidden_dir_dentry->d_inode,
-					 hidden_wh_dentry,
+			err = vfs_create(lower_dir_dentry->d_inode,
+					 lower_wh_dentry,
 					 ~current->fs->umask & S_IRWXUGO,
 					 NULL);
-		unlock_dir(hidden_dir_dentry);
-		dput(hidden_wh_dentry);
+		unlock_dir(lower_dir_dentry);
+		dput(lower_wh_dentry);
 
 		if (!err || !IS_COPYUP_ERR(err))
 			break;
@@ -106,24 +106,24 @@ out:
  * This is a helper function for rename, which ends up with hosed over
  * dentries when it needs to revert.
  */
-int unionfs_refresh_hidden_dentry(struct dentry *dentry, int bindex)
+int unionfs_refresh_lower_dentry(struct dentry *dentry, int bindex)
 {
-	struct dentry *hidden_dentry;
-	struct dentry *hidden_parent;
+	struct dentry *lower_dentry;
+	struct dentry *lower_parent;
 	int err = 0;
 
 	verify_locked(dentry);
 
 	unionfs_lock_dentry(dentry->d_parent);
-	hidden_parent = unionfs_lower_dentry_idx(dentry->d_parent, bindex);
+	lower_parent = unionfs_lower_dentry_idx(dentry->d_parent, bindex);
 	unionfs_unlock_dentry(dentry->d_parent);
 
-	BUG_ON(!S_ISDIR(hidden_parent->d_inode->i_mode));
+	BUG_ON(!S_ISDIR(lower_parent->d_inode->i_mode));
 
-	hidden_dentry = lookup_one_len(dentry->d_name.name, hidden_parent,
-				       dentry->d_name.len);
-	if (IS_ERR(hidden_dentry)) {
-		err = PTR_ERR(hidden_dentry);
+	lower_dentry = lookup_one_len(dentry->d_name.name, lower_parent,
+				      dentry->d_name.len);
+	if (IS_ERR(lower_dentry)) {
+		err = PTR_ERR(lower_dentry);
 		goto out;
 	}
 
@@ -131,13 +131,13 @@ int unionfs_refresh_hidden_dentry(struct dentry *dentry, int bindex)
 	iput(unionfs_lower_inode_idx(dentry->d_inode, bindex));
 	unionfs_set_lower_inode_idx(dentry->d_inode, bindex, NULL);
 
-	if (!hidden_dentry->d_inode) {
-		dput(hidden_dentry);
+	if (!lower_dentry->d_inode) {
+		dput(lower_dentry);
 		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
 	} else {
-		unionfs_set_lower_dentry_idx(dentry, bindex, hidden_dentry);
+		unionfs_set_lower_dentry_idx(dentry, bindex, lower_dentry);
 		unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
-					    igrab(hidden_dentry->d_inode));
+					    igrab(lower_dentry->d_inode));
 	}
 
 out:
@@ -147,16 +147,16 @@ out:
 int make_dir_opaque(struct dentry *dentry, int bindex)
 {
 	int err = 0;
-	struct dentry *hidden_dentry, *diropq;
-	struct inode *hidden_dir;
+	struct dentry *lower_dentry, *diropq;
+	struct inode *lower_dir;
 
-	hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-	hidden_dir = hidden_dentry->d_inode;
+	lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+	lower_dir = lower_dentry->d_inode;
 	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode) ||
-	       !S_ISDIR(hidden_dir->i_mode));
+	       !S_ISDIR(lower_dir->i_mode));
 
-	mutex_lock(&hidden_dir->i_mutex);
-	diropq = lookup_one_len(UNIONFS_DIR_OPAQUE, hidden_dentry,
+	mutex_lock(&lower_dir->i_mutex);
+	diropq = lookup_one_len(UNIONFS_DIR_OPAQUE, lower_dentry,
 				sizeof(UNIONFS_DIR_OPAQUE) - 1);
 	if (IS_ERR(diropq)) {
 		err = PTR_ERR(diropq);
@@ -164,14 +164,14 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 	}
 
 	if (!diropq->d_inode)
-		err = vfs_create(hidden_dir, diropq, S_IRUGO, NULL);
+		err = vfs_create(lower_dir, diropq, S_IRUGO, NULL);
 	if (!err)
 		set_dbopaque(dentry, bindex);
 
 	dput(diropq);
 
 out:
-	mutex_unlock(&hidden_dir->i_mutex);
+	mutex_unlock(&lower_dir->i_mutex);
 	return err;
 }
 
@@ -184,7 +184,7 @@ int unionfs_get_nlinks(struct inode *inode)
 	int sum_nlinks = 0;
 	int dirs = 0;
 	int bindex;
-	struct inode *hidden_inode;
+	struct inode *lower_inode;
 
 	/* don't bother to do all the work since we're unlinked */
 	if (inode->i_nlink == 0)
@@ -194,16 +194,16 @@ int unionfs_get_nlinks(struct inode *inode)
 		return unionfs_lower_inode(inode)->i_nlink;
 
 	for (bindex = ibstart(inode); bindex <= ibend(inode); bindex++) {
-		hidden_inode = unionfs_lower_inode_idx(inode, bindex);
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 
 		/* ignore files */
-		if (!hidden_inode || !S_ISDIR(hidden_inode->i_mode))
+		if (!lower_inode || !S_ISDIR(lower_inode->i_mode))
 			continue;
 
-		BUG_ON(hidden_inode->i_nlink < 0);
+		BUG_ON(lower_inode->i_nlink < 0);
 
 		/* A deleted directory. */
-		if (hidden_inode->i_nlink == 0)
+		if (lower_inode->i_nlink == 0)
 			continue;
 		dirs++;
 
@@ -213,10 +213,10 @@ int unionfs_get_nlinks(struct inode *inode)
 		 * Some filesystems don't properly set the number of links
 		 * on empty directories
 		 */
-		if (hidden_inode->i_nlink == 1)
+		if (lower_inode->i_nlink == 1)
 			sum_nlinks += 2;
 		else
-			sum_nlinks += (hidden_inode->i_nlink - 2);
+			sum_nlinks += (lower_inode->i_nlink - 2);
 	}
 
 	return (!dirs ? 0 : sum_nlinks + 2);
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 0e6dad1..09e0202 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -188,7 +188,7 @@ static noinline int do_remount_mode_option(char *optarg, int cur_branches,
 	err = path_lookup(optarg, LOOKUP_FOLLOW, &nd);
 	if (err) {
 		printk(KERN_WARNING "unionfs: error accessing "
-		       "hidden directory \"%s\" (error %d)\n",
+		       "lower directory \"%s\" (error %d)\n",
 		       optarg, err);
 		goto out;
 	}
@@ -231,7 +231,7 @@ static noinline int do_remount_del_option(char *optarg, int cur_branches,
 	err = path_lookup(optarg, LOOKUP_FOLLOW, &nd);
 	if (err) {
 		printk(KERN_WARNING "unionfs: error accessing "
-		       "hidden directory \"%s\" (error %d)\n",
+		       "lower directory \"%s\" (error %d)\n",
 		       optarg, err);
 		goto out;
 	}
@@ -315,7 +315,7 @@ static noinline int do_remount_add_option(char *optarg, int cur_branches,
 	err = path_lookup(optarg, LOOKUP_FOLLOW, &nd);
 	if (err) {
 		printk(KERN_WARNING "unionfs: error accessing "
-		       "hidden directory \"%s\" (error %d)\n",
+		       "lower directory \"%s\" (error %d)\n",
 		       optarg, err);
 		goto out;
 	}
@@ -351,7 +351,7 @@ found_insertion_point:
 	err = path_lookup(new_branch, LOOKUP_FOLLOW, &nd);
 	if (err) {
 		printk(KERN_WARNING "unionfs: error accessing "
-		       "hidden directory \"%s\" (error %d)\n",
+		       "lower directory \"%s\" (error %d)\n",
 		       new_branch, err);
 		goto out;
 	}
@@ -363,7 +363,7 @@ found_insertion_point:
 	 * code base supports that correctly.
 	 */
 	if ((err = check_branch(&nd))) {
-		printk(KERN_WARNING "unionfs: hidden directory "
+		printk(KERN_WARNING "unionfs: lower directory "
 		       "\"%s\" is not a valid branch\n", optarg);
 		path_release(&nd);
 		goto out;
@@ -511,7 +511,7 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	 * and then free the temps (done near the end of this function).
 	 */
 	max_branches = cur_branches + add_branches;
-	/* allocate space for new pointers to hidden dentry */
+	/* allocate space for new pointers to lower dentry */
 	tmp_data = kcalloc(max_branches,
 			   sizeof(struct unionfs_data), GFP_KERNEL);
 	if (!tmp_data) {
@@ -652,7 +652,7 @@ out_no_change:
 		goto out_release;
 	}
 
-	/* (re)allocate space for new pointers to hidden dentry */
+	/* (re)allocate space for new pointers to lower dentry */
 	size = new_branches * sizeof(struct unionfs_data);
 	new_data = krealloc(tmp_data, size, GFP_KERNEL);
 	if (!new_data) {
@@ -799,7 +799,7 @@ out_error:
 static void unionfs_clear_inode(struct inode *inode)
 {
 	int bindex, bstart, bend;
-	struct inode *hidden_inode;
+	struct inode *lower_inode;
 	struct list_head *pos, *n;
 	struct unionfs_dir_state *rdstate;
 
@@ -810,17 +810,17 @@ static void unionfs_clear_inode(struct inode *inode)
 	}
 
 	/*
-	 * Decrement a reference to a hidden_inode, which was incremented
+	 * Decrement a reference to a lower_inode, which was incremented
 	 * by our read_inode when it was created initially.
 	 */
 	bstart = ibstart(inode);
 	bend = ibend(inode);
 	if (bstart >= 0) {
 		for (bindex = bstart; bindex <= bend; bindex++) {
-			hidden_inode = unionfs_lower_inode_idx(inode, bindex);
-			if (!hidden_inode)
+			lower_inode = unionfs_lower_inode_idx(inode, bindex);
+			if (!lower_inode)
 				continue;
-			iput(hidden_inode);
+			iput(lower_inode);
 		}
 	}
 
@@ -908,8 +908,8 @@ static int unionfs_write_inode(struct inode *inode, int sync)
  */
 static void unionfs_umount_begin(struct vfsmount *mnt, int flags)
 {
-	struct super_block *sb, *hidden_sb;
-	struct vfsmount *hidden_mnt;
+	struct super_block *sb, *lower_sb;
+	struct vfsmount *lower_mnt;
 	int bindex, bstart, bend;
 
 	if (!(flags & MNT_FORCE))
@@ -926,12 +926,12 @@ static void unionfs_umount_begin(struct vfsmount *mnt, int flags)
 	bstart = sbstart(sb);
 	bend = sbend(sb);
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_mnt = unionfs_lower_mnt_idx(sb->s_root, bindex);
-		hidden_sb = unionfs_lower_super_idx(sb, bindex);
+		lower_mnt = unionfs_lower_mnt_idx(sb->s_root, bindex);
+		lower_sb = unionfs_lower_super_idx(sb, bindex);
 
-		if (hidden_mnt && hidden_sb && hidden_sb->s_op &&
-		    hidden_sb->s_op->umount_begin)
-			hidden_sb->s_op->umount_begin(hidden_mnt, flags);
+		if (lower_mnt && lower_sb && lower_sb->s_op &&
+		    lower_sb->s_op->umount_begin)
+			lower_sb->s_op->umount_begin(lower_mnt, flags);
 	}
 
 	unionfs_read_unlock(sb);
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 3fb4c14..f9c6508 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -97,7 +97,7 @@ struct unionfs_inode_info {
 	int hashsize;
 	int cookie;
 
-	/* The hidden inodes */
+	/* The lower inodes */
 	struct inode **lower_inodes;
 	/* to keep track of reads/writes for unlinks before closes */
 	atomic_t totalopens;
@@ -278,7 +278,7 @@ extern int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
 			 loff_t len);
 
 extern int remove_whiteouts(struct dentry *dentry,
-			    struct dentry *hidden_dentry, int bindex);
+			    struct dentry *lower_dentry, int bindex);
 
 extern int do_delete_whiteouts(struct dentry *dentry, int bindex,
 			       struct unionfs_dir_state *namelist);
@@ -292,8 +292,8 @@ extern int check_empty(struct dentry *dentry,
 extern int delete_whiteouts(struct dentry *dentry, int bindex,
 			    struct unionfs_dir_state *namelist);
 
-/* Re-lookup a hidden dentry. */
-extern int unionfs_refresh_hidden_dentry(struct dentry *dentry, int bindex);
+/* Re-lookup a lower dentry. */
+extern int unionfs_refresh_lower_dentry(struct dentry *dentry, int bindex);
 
 extern void unionfs_reinterpose(struct dentry *this_dentry);
 extern struct super_block *unionfs_duplicate_super(struct super_block *sb);
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index a6b8bab..822bffe 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -21,8 +21,8 @@
 /* unlink a file by creating a whiteout */
 static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 {
-	struct dentry *hidden_dentry;
-	struct dentry *hidden_dir_dentry;
+	struct dentry *lower_dentry;
+	struct dentry *lower_dir_dentry;
 	int bindex;
 	int err = 0;
 
@@ -31,19 +31,19 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 
 	bindex = dbstart(dentry);
 
-	hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-	if (!hidden_dentry)
+	lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+	if (!lower_dentry)
 		goto out;
 
-	hidden_dir_dentry = lock_parent(hidden_dentry);
+	lower_dir_dentry = lock_parent(lower_dentry);
 
-	/* avoid destroying the hidden inode if the file is in use */
-	dget(hidden_dentry);
+	/* avoid destroying the lower inode if the file is in use */
+	dget(lower_dentry);
 	if (!(err = is_robranch_super(dentry->d_sb, bindex)))
-		err = vfs_unlink(hidden_dir_dentry->d_inode, hidden_dentry);
-	dput(hidden_dentry);
-	fsstack_copy_attr_times(dir, hidden_dir_dentry->d_inode);
-	unlock_dir(hidden_dir_dentry);
+		err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
+	dput(lower_dentry);
+	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
+	unlock_dir(lower_dir_dentry);
 
 	if (err && !IS_COPYUP_ERR(err))
 		goto out;
@@ -54,7 +54,7 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 
 		err = create_whiteout(dentry, dbstart(dentry) - 1);
 	} else if (dbopaque(dentry) != -1)
-		/* There is a hidden lower-priority file with the same name. */
+		/* There is a lower lower-priority file with the same name. */
 		err = create_whiteout(dentry, dbopaque(dentry));
 	else
 		err = create_whiteout(dentry, dbstart(dentry));
@@ -97,31 +97,31 @@ static int unionfs_rmdir_first(struct inode *dir, struct dentry *dentry,
 			       struct unionfs_dir_state *namelist)
 {
 	int err;
-	struct dentry *hidden_dentry;
-	struct dentry *hidden_dir_dentry = NULL;
+	struct dentry *lower_dentry;
+	struct dentry *lower_dir_dentry = NULL;
 
 	/* Here we need to remove whiteout entries. */
 	err = delete_whiteouts(dentry, dbstart(dentry), namelist);
 	if (err)
 		goto out;
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
-	hidden_dir_dentry = lock_parent(hidden_dentry);
+	lower_dir_dentry = lock_parent(lower_dentry);
 
-	/* avoid destroying the hidden inode if the file is in use */
-	dget(hidden_dentry);
+	/* avoid destroying the lower inode if the file is in use */
+	dget(lower_dentry);
 	if (!(err = is_robranch(dentry)))
-		err = vfs_rmdir(hidden_dir_dentry->d_inode, hidden_dentry);
-	dput(hidden_dentry);
+		err = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
+	dput(lower_dentry);
 
-	fsstack_copy_attr_times(dir, hidden_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	/* propagate number of hard-links */
 	dentry->d_inode->i_nlink = unionfs_get_nlinks(dentry->d_inode);
 
 out:
-	if (hidden_dir_dentry)
-		unlock_dir(hidden_dir_dentry);
+	if (lower_dir_dentry)
+		unlock_dir(lower_dir_dentry);
 	return err;
 }
 
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 5bb8054..92bcd20 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -54,7 +54,7 @@ void unionfs_xattr_free(void *ptr, size_t size)
 ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 			 size_t size)
 {
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
 	unionfs_read_lock(dentry->d_sb);
@@ -65,9 +65,9 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 		goto out;
 	}
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
-	err = vfs_getxattr(hidden_dentry, (char*) name, value, size);
+	err = vfs_getxattr(lower_dentry, (char*) name, value, size);
 
 out:
 	unionfs_unlock_dentry(dentry);
@@ -82,7 +82,7 @@ out:
 int unionfs_setxattr(struct dentry *dentry, const char *name,
 		     const void *value, size_t size, int flags)
 {
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
 	unionfs_read_lock(dentry->d_sb);
@@ -93,9 +93,9 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 		goto out;
 	}
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
-	err = vfs_setxattr(hidden_dentry, (char*) name, (void*) value,
+	err = vfs_setxattr(lower_dentry, (char*) name, (void*) value,
 			   size, flags);
 
 out:
@@ -110,7 +110,7 @@ out:
  */
 int unionfs_removexattr(struct dentry *dentry, const char *name)
 {
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
 
 	unionfs_read_lock(dentry->d_sb);
@@ -121,9 +121,9 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 		goto out;
 	}
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
-	err = vfs_removexattr(hidden_dentry, (char*) name);
+	err = vfs_removexattr(lower_dentry, (char*) name);
 
 out:
 	unionfs_unlock_dentry(dentry);
@@ -137,7 +137,7 @@ out:
  */
 ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	struct dentry *hidden_dentry = NULL;
+	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
 	char *encoded_list = NULL;
 
@@ -149,10 +149,10 @@ ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
 		goto out;
 	}
 
-	hidden_dentry = unionfs_lower_dentry(dentry);
+	lower_dentry = unionfs_lower_dentry(dentry);
 
 	encoded_list = list;
-	err = vfs_listxattr(hidden_dentry, encoded_list, size);
+	err = vfs_listxattr(lower_dentry, encoded_list, size);
 
 out:
 	unionfs_unlock_dentry(dentry);
-- 
1.5.2.2.238.g7cbf2f2

