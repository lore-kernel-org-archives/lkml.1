Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbYDIAyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbYDIAyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 20:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYDIAyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 20:54:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47118 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYDIAyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 20:54:04 -0400
Date: Tue, 8 Apr 2008 20:53:14 -0400
Message-Id: <200804090053.m390rE9k007085@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Unionfs: use the new path_* VFS helpers
In-reply-to: Your message of "Wed, 02 Apr 2008 22:12:47 +0200."
             <20080402201247.358430231@szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos and Al,

As promised, here is a patch for Unionfs to use the new path_* VFS helpers
which now take a struct path *.  I've used Al's vfs git tree plus all 12
patches you've outlined (ten path_* patches + 2 others).  I've run Unionfs
through my basic regression suite; I haven't done more extensive testing
yet.  This patch can be used in -mm if/when your path_* patches make it
there (this patch will be a standalone one to be used on top of my
unionfs.git tree).

Al, I'm not too pleased with the resulting additional code complexity to
Unionfs, due to these new helpers.  See the diffstat below.  These VFS
helpers have widened the gap between the f/s API and the VFS helpers': the
helpers now need a struct path/vfsmount, but the most ->ops that a
filesystem is being called with, don't have a path/vfsmount passed.

You've said before that a filesystems has no business dealing with vfsmounts
(with the exception of follow_link).  Fine.  But the irony now is that the
new vfs helpers that a filesystems is likely to use, FORCE you to know a lot
more about vfsmounts!  If indeed a filesystem shouldn't have to know or deal
with vfsmounts, then none of the VFS helpers should require a struct
vfsmount (or a struct path, or a nameidata, which embed a vfsmount+dentry
pair).  Otherwise, let's admit that some filesystems have to know about
vfsmounts and hence let's pass them to all appropriate fs ->ops.  (BTW, if
that's done, then it'd also be helpful for a struct vfsmount to have a "void
*private" into which a stacked f/s can store "lower objects").

I hope your planned Big VFS Overhaul can reverse this trend by making it
possible for a filesystem to not know anything (or know very little) about
vfsmounts and the structs that embed them.

Thanks,
Erez.


 commonfops.c |    5 +++-
 copyup.c     |   41 ++++++++++++++++++++++++++--------
 dirhelper.c  |   10 ++++++--
 inode.c      |   70 +++++++++++++++++++++++++++++++++++++++++------------------
 lookup.c     |    8 +++++-
 rename.c     |   34 +++++++++++++++++++---------
 sioq.c       |   10 ++++----
 sioq.h       |    1 
 subr.c       |   22 +++++++++++-------
 union.h      |    3 +-
 unlink.c     |   10 +++++---
 xattr.c      |   11 ++++++---
 12 files changed, 158 insertions(+), 67 deletions(-)



Unionfs: use new path_* helpers instead of vfs_* helpers

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 0fc7963..e9878bb 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -35,6 +35,7 @@ static int copyup_deleted_file(struct file *file, struct dentry *dentry,
 	struct dentry *tmp_dentry = NULL;
 	struct dentry *lower_dentry;
 	struct dentry *lower_dir_dentry = NULL;
+	struct path path;
 
 	lower_dentry = unionfs_lower_dentry_idx(dentry, bstart);
 
@@ -88,7 +89,9 @@ retry:
 					    lower_dentry->d_inode);
 	}
 	lower_dir_dentry = lock_parent(lower_dentry);
-	err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
+	path.dentry = lower_dir_dentry;
+	path.mnt = unionfs_lower_mnt_idx(dentry->d_parent, dbstart(dentry));
+	err = path_unlink(&path, lower_dentry);
 	unlock_dir(lower_dir_dentry);
 
 out:
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 6d1e461..ea658e6 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -26,13 +26,15 @@
 #ifdef CONFIG_UNION_FS_XATTR
 /* copyup all extended attrs for a given dentry */
 static int copyup_xattrs(struct dentry *old_lower_dentry,
-			 struct dentry *new_lower_dentry)
+			 struct dentry *new_lower_dentry,
+			 struct vfsmount *new_lower_mnt)
 {
 	int err = 0;
 	ssize_t list_size = -1;
 	char *name_list = NULL;
 	char *attr_value = NULL;
 	char *name_list_buf = NULL;
+	struct path path;
 
 	/* query the actual size of the xattr list */
 	list_size = vfs_listxattr(old_lower_dentry, NULL, 0);
@@ -82,8 +84,9 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
 			goto out;
 		}
 		/* Don't lock here since vfs_setxattr does it for us. */
-		err = vfs_setxattr(new_lower_dentry, name_list, attr_value,
-				   size, 0);
+		path.dentry = new_lower_dentry;
+		path.mnt = new_lower_mnt;
+		err = path_setxattr(&path, name_list, attr_value, size, 0);
 		/*
 		 * Selinux depends on "security.*" xattrs, so to maintain
 		 * the security of copied-up files, if Selinux is active,
@@ -93,8 +96,8 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
 		 */
 		if (err == -EPERM && !capable(CAP_FOWNER)) {
 			cap_raise(current->cap_effective, CAP_FOWNER);
-			err = vfs_setxattr(new_lower_dentry, name_list,
-					   attr_value, size, 0);
+			err = path_setxattr(&path, name_list, attr_value,
+					    size, 0);
 			cap_lower(current->cap_effective, CAP_FOWNER);
 		}
 		if (err < 0)
@@ -167,12 +170,16 @@ out:
 static int __copyup_ndentry(struct dentry *old_lower_dentry,
 			    struct dentry *new_lower_dentry,
 			    struct dentry *new_lower_parent_dentry,
+			    struct vfsmount *new_lower_parent_mnt,
 			    char *symbuf)
 {
 	int err = 0;
 	umode_t old_mode = old_lower_dentry->d_inode->i_mode;
 	struct sioq_args args;
 
+	args.path.dentry = new_lower_parent_dentry;
+	args.path.mnt = new_lower_parent_mnt;
+
 	if (S_ISDIR(old_mode)) {
 		args.mkdir.parent = new_lower_parent_dentry->d_inode;
 		args.mkdir.dentry = new_lower_dentry;
@@ -199,7 +206,9 @@ static int __copyup_ndentry(struct dentry *old_lower_dentry,
 		err = args.err;
 	} else if (S_ISREG(old_mode)) {
 		struct nameidata nd;
-		err = init_lower_nd(&nd, LOOKUP_CREATE);
+
+		err = init_lower_nd(&nd, args.path.dentry, args.path.mnt,
+				    LOOKUP_CREATE);
 		if (unlikely(err < 0))
 			goto out;
 		args.create.nd = &nd;
@@ -387,6 +396,8 @@ int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
 	struct dentry *new_lower_parent_dentry = NULL;
 	mm_segment_t oldfs;
 	char *symbuf = NULL;
+	struct path path;
+	struct vfsmount *mnt;
 
 	verify_locked(dentry);
 
@@ -444,10 +455,13 @@ int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
 
 	/* Now we lock the parent, and create the object in the new branch. */
 	new_lower_parent_dentry = lock_parent(new_lower_dentry);
+	mnt = unionfs_lower_mnt_idx(dentry->d_parent, new_bindex);
+	if (!mnt)
+		mnt = unionfs_lower_mnt_idx(sb->s_root, new_bindex);
 
 	/* create the new inode */
 	err = __copyup_ndentry(old_lower_dentry, new_lower_dentry,
-			       new_lower_parent_dentry, symbuf);
+			       new_lower_parent_dentry, mnt, symbuf);
 
 	if (err) {
 		__clear(dentry, old_lower_dentry,
@@ -470,8 +484,9 @@ int copyup_dentry(struct inode *dir, struct dentry *dentry, int bstart,
 		goto out_unlink;
 
 #ifdef CONFIG_UNION_FS_XATTR
+	mnt = unionfs_lower_mnt_idx(dentry, new_bindex);
 	/* Selinux uses extended attributes for permissions. */
-	err = copyup_xattrs(old_lower_dentry, new_lower_dentry);
+	err = copyup_xattrs(old_lower_dentry, new_lower_dentry, mnt);
 	if (err)
 		goto out_unlink;
 #endif /* CONFIG_UNION_FS_XATTR */
@@ -488,7 +503,9 @@ out_unlink:
 	 * quota, or something else happened so let's unlink; we don't
 	 * really care about the return value of vfs_unlink
 	 */
-	vfs_unlink(new_lower_parent_dentry->d_inode, new_lower_dentry);
+	path.dentry = new_lower_parent_dentry;
+	path.mnt = unionfs_lower_mnt_idx(dentry->d_parent, new_bindex);
+	path_unlink(&path, new_lower_dentry);
 
 	if (copyup_file) {
 		/* need to close the file */
@@ -664,7 +681,7 @@ static void __set_dentry(struct dentry *upper, struct dentry *lower,
 
 /*
  * This function replicates the directory structure up-to given dentry
- * in the bindex branch.
+ * in the bindex branch.  On success, fill in @mntp;
  */
 struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 			      const char *name, int bindex)
@@ -682,6 +699,7 @@ struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 	int old_bend;
 	struct dentry **path = NULL;
 	struct super_block *sb;
+	struct vfsmount *lower_parent_mnt;
 
 	verify_locked(dentry);
 
@@ -753,6 +771,7 @@ struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 begin:
 	/* get lower parent dir in the current branch */
 	lower_parent_dentry = unionfs_lower_dentry_idx(parent_dentry, bindex);
+	lower_parent_mnt = unionfs_lower_mnt_idx(sb->s_root, bindex);
 	dput(parent_dentry);
 
 	/* init the values to lookup */
@@ -796,6 +815,8 @@ begin:
 		/* it's a negative dentry, create a new dir */
 		lower_parent_dentry = lock_parent(lower_dentry);
 
+		args.path.dentry = lower_parent_dentry;
+		args.path.mnt = lower_parent_mnt;
 		args.mkdir.parent = lower_parent_dentry->d_inode;
 		args.mkdir.dentry = lower_dentry;
 		args.mkdir.mode = child_dentry->d_inode->i_mode;
diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index 4b73bb6..7a8a654 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -34,6 +34,7 @@ int do_delete_whiteouts(struct dentry *dentry, int bindex,
 	int i;
 	struct list_head *pos;
 	struct filldir_node *cursor;
+	struct path path;
 
 	/* Find out lower parent dentry */
 	lower_dir_dentry = unionfs_lower_dentry_idx(dentry, bindex);
@@ -69,8 +70,12 @@ int do_delete_whiteouts(struct dentry *dentry, int bindex,
 				err = PTR_ERR(lower_dentry);
 				break;
 			}
-			if (lower_dentry->d_inode)
-				err = vfs_unlink(lower_dir, lower_dentry);
+			if (lower_dentry->d_inode) {
+				path.dentry = lower_dir_dentry;
+				path.mnt = unionfs_lower_mnt_idx(dentry,
+								 bindex);
+				err = path_unlink(&path, lower_dentry);
+			}
 			dput(lower_dentry);
 			if (err)
 				break;
@@ -113,6 +118,7 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 	if (!permission(lower_dir, MAY_WRITE | MAY_EXEC, NULL)) {
 		err = do_delete_whiteouts(dentry, bindex, namelist);
 	} else {
+		/* __delete_whiteouts doesn't need args.path filled */
 		args.deletewh.namelist = namelist;
 		args.deletewh.dentry = dentry;
 		args.deletewh.bindex = bindex;
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index a1d7aaf..2cf161e 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -36,6 +36,7 @@ static int check_for_whiteout(struct dentry *dentry,
 	struct dentry *wh_dentry = NULL;
 	struct dentry *lower_dir_dentry;
 	char *name = NULL;
+	struct path path;
 
 	/*
 	 * check if whiteout exists in this branch, i.e. lookup .wh.foo
@@ -60,9 +61,11 @@ static int check_for_whiteout(struct dentry *dentry,
 
 	/* .wh.foo has been found, so let's unlink it */
 	lower_dir_dentry = lock_parent_wh(wh_dentry);
+	path.dentry = lower_dir_dentry;
+	path.mnt = unionfs_lower_mnt(dentry);
 	/* see Documentation/filesystems/unionfs/issues.txt */
 	lockdep_off();
-	err = vfs_unlink(lower_dir_dentry->d_inode, wh_dentry);
+	err = path_unlink(&path, wh_dentry);
 	lockdep_on();
 	unlock_dir(lower_dir_dentry);
 
@@ -97,13 +100,16 @@ out:
  * suitable, also tries branch 0 (which may require a copyup).
  *
  * Return a lower_dentry we can use to create object in, or ERR_PTR.
+ * On success, fills in @mntp with lower_dentry's corresponding vfsmount.
  */
 static struct dentry *find_writeable_branch(struct inode *parent,
-					    struct dentry *dentry)
+					    struct dentry *dentry,
+					    struct vfsmount **mntp)
 {
 	int err = -EINVAL;
 	int bindex, istart, iend;
 	struct dentry *lower_dentry = NULL;
+	struct vfsmount *m;
 
 	istart = ibstart(parent);
 	iend = ibend(parent);
@@ -160,6 +166,11 @@ begin:
 			goto out;
 		}
 	}
+	m = unionfs_lower_mnt_idx(dentry->d_parent, bindex);
+	if (!m)
+		m = unionfs_lower_mnt_idx(dentry->d_sb->s_root, bindex);
+	*mntp = m;
+
 	err = 0;		/* all's well */
 out:
 	if (err)
@@ -175,6 +186,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	struct dentry *lower_parent_dentry = NULL;
 	int valid = 0;
 	struct nameidata lower_nd;
+	struct vfsmount *mnt = NULL;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -193,7 +205,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 	 */
 	BUG_ON(!valid && dentry->d_inode);
 
-	lower_dentry = find_writeable_branch(parent, dentry);
+	lower_dentry = find_writeable_branch(parent, dentry, &mnt);
 	if (IS_ERR(lower_dentry)) {
 		err = PTR_ERR(lower_dentry);
 		goto out;
@@ -205,11 +217,11 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 		goto out;
 	}
 
-	err = init_lower_nd(&lower_nd, LOOKUP_CREATE);
+	err = init_lower_nd(&lower_nd, lower_parent_dentry, mnt,
+			    LOOKUP_CREATE);
 	if (unlikely(err < 0))
 		goto out;
-	err = vfs_create(lower_parent_dentry->d_inode, lower_dentry, mode,
-			 &lower_nd);
+	err = path_create(&lower_nd.path, lower_dentry, mode, &lower_nd);
 	release_lower_nd(&lower_nd, err);
 
 	if (!err) {
@@ -304,6 +316,7 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *whiteout_dentry;
 	char *name = NULL;
+	struct path path;
 
 	unionfs_read_lock(old_dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_double_lock_dentry(new_dentry, old_dentry);
@@ -346,10 +359,11 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 		lower_dir_dentry = lock_parent_wh(whiteout_dentry);
 		err = is_robranch_super(new_dentry->d_sb, dbstart(new_dentry));
 		if (!err) {
+			path.dentry = lower_dir_dentry;
+			path.mnt = unionfs_lower_mnt(new_dentry);
 			/* see Documentation/filesystems/unionfs/issues.txt */
 			lockdep_off();
-			err = vfs_unlink(lower_dir_dentry->d_inode,
-					 whiteout_dentry);
+			err = path_unlink(&path, whiteout_dentry);
 			lockdep_on();
 		}
 
@@ -379,10 +393,13 @@ static int unionfs_link(struct dentry *old_dentry, struct inode *dir,
 	lower_dir_dentry = lock_parent(lower_new_dentry);
 	err = is_robranch(old_dentry);
 	if (!err) {
+		path.dentry = lower_dir_dentry;
+		path.mnt = unionfs_lower_mnt(new_dentry->d_parent);
+		if (!path.mnt)
+			path.mnt = unionfs_lower_mnt(new_dentry->d_sb->s_root);
 		/* see Documentation/filesystems/unionfs/issues.txt */
 		lockdep_off();
-		err = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
-			       lower_new_dentry);
+		err = path_link(lower_old_dentry, &path, lower_new_dentry);
 		lockdep_on();
 	}
 	unlock_dir(lower_dir_dentry);
@@ -406,12 +423,16 @@ docopyup:
 					       bindex);
 			lower_old_dentry = unionfs_lower_dentry(old_dentry);
 			lower_dir_dentry = lock_parent(lower_new_dentry);
+			path.dentry = lower_dir_dentry;
+			path.mnt = unionfs_lower_mnt_idx(new_dentry, bindex);
+			if (!path.mnt)
+				path.mnt = unionfs_lower_mnt_idx(
+					new_dentry->d_sb->s_root, bindex);
 			/* see Documentation/filesystems/unionfs/issues.txt */
 			lockdep_off();
 			/* do vfs_link */
-			err = vfs_link(lower_old_dentry,
-				       lower_dir_dentry->d_inode,
-				       lower_new_dentry);
+			err = path_link(lower_old_dentry, &path,
+					lower_new_dentry);
 			lockdep_on();
 			unlock_dir(lower_dir_dentry);
 			goto check_link;
@@ -463,6 +484,7 @@ static int unionfs_symlink(struct inode *parent, struct dentry *dentry,
 	char *name = NULL;
 	int valid = 0;
 	umode_t mode;
+	struct path path;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -485,7 +507,7 @@ static int unionfs_symlink(struct inode *parent, struct dentry *dentry,
 	 */
 	BUG_ON(!valid && dentry->d_inode);
 
-	lower_dentry = find_writeable_branch(parent, dentry);
+	lower_dentry = find_writeable_branch(parent, dentry, &path.mnt);
 	if (IS_ERR(lower_dentry)) {
 		err = PTR_ERR(lower_dentry);
 		goto out;
@@ -498,8 +520,8 @@ static int unionfs_symlink(struct inode *parent, struct dentry *dentry,
 	}
 
 	mode = S_IALLUGO;
-	err = vfs_symlink(lower_parent_dentry->d_inode, lower_dentry,
-			  symname, mode);
+	path.dentry = lower_parent_dentry;
+	err = path_symlink(&path, lower_dentry, symname, mode);
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
@@ -538,6 +560,7 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 	int whiteout_unlinked = 0;
 	struct sioq_args args;
 	int valid;
+	struct path path;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -581,9 +604,11 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 	} else {
 		lower_parent_dentry = lock_parent_wh(whiteout_dentry);
 
-		/* found a.wh.foo entry, remove it then do vfs_mkdir */
+		/* found a.wh.foo entry, remove it then do path_mkdir */
 		err = is_robranch_super(dentry->d_sb, bstart);
 		if (!err) {
+			args.path.dentry = lower_parent_dentry;
+			args.path.mnt = unionfs_lower_mnt(dentry->d_parent);
 			args.unlink.parent = lower_parent_dentry->d_inode;
 			args.unlink.dentry = whiteout_dentry;
 			run_sioq(__unionfs_unlink, &args);
@@ -629,8 +654,9 @@ static int unionfs_mkdir(struct inode *parent, struct dentry *dentry, int mode)
 			goto out;
 		}
 
-		err = vfs_mkdir(lower_parent_dentry->d_inode, lower_dentry,
-				mode);
+		path.dentry = lower_parent_dentry;
+		path.mnt = unionfs_lower_mnt_idx(dentry->d_parent, bindex);
+		err = path_mkdir(&path, lower_dentry, mode);
 
 		unlock_dir(lower_parent_dentry);
 
@@ -699,6 +725,7 @@ static int unionfs_mknod(struct inode *parent, struct dentry *dentry, int mode,
 	struct dentry *lower_parent_dentry = NULL;
 	char *name = NULL;
 	int valid = 0;
+	struct path path;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -721,7 +748,7 @@ static int unionfs_mknod(struct inode *parent, struct dentry *dentry, int mode,
 	 */
 	BUG_ON(!valid && dentry->d_inode);
 
-	lower_dentry = find_writeable_branch(parent, dentry);
+	lower_dentry = find_writeable_branch(parent, dentry, &path.mnt);
 	if (IS_ERR(lower_dentry)) {
 		err = PTR_ERR(lower_dentry);
 		goto out;
@@ -733,7 +760,8 @@ static int unionfs_mknod(struct inode *parent, struct dentry *dentry, int mode,
 		goto out;
 	}
 
-	err = vfs_mknod(lower_parent_dentry->d_inode, lower_dentry, mode, dev);
+	path.dentry = lower_parent_dentry;
+	err = path_mknod(&path, lower_dentry, mode, dev);
 	if (!err) {
 		err = PTR_ERR(unionfs_interpose(dentry, parent->i_sb, 0));
 		if (!err) {
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 7f512c2..5bfbdf6 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -52,6 +52,7 @@ static noinline_for_stack int is_opaque_dir(struct dentry *dentry, int bindex)
 			lookup_one_len(UNIONFS_DIR_OPAQUE, lower_dentry,
 				       sizeof(UNIONFS_DIR_OPAQUE) - 1);
 	} else {
+		/* __is_opaque_dir doesn't need args.path filled */
 		args.is_opaque.dentry = lower_dentry;
 		run_sioq(__is_opaque_dir, &args);
 		wh_lower_dentry = args.ret;
@@ -603,7 +604,8 @@ void update_bstart(struct dentry *dentry)
  * separate intent-structure, and (2) open_namei() is broken into a VFS-only
  * function and a method that other file systems can call.
  */
-int init_lower_nd(struct nameidata *nd, unsigned int flags)
+int init_lower_nd(struct nameidata *nd, struct dentry *dentry,
+		  struct vfsmount *mnt, unsigned int flags)
 {
 	int err = 0;
 #ifdef ALLOC_LOWER_ND_FILE
@@ -648,6 +650,10 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 		break;
 	}
 
+	/* initialize lower path (dentry+vfsmount) */
+	nd->path.dentry = dentry;
+	nd->path.mnt = mnt;
+
 	return err;
 }
 
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index cc16eb2..8f9703a 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -31,6 +31,7 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct dentry *lower_wh_dir_dentry;
 	struct dentry *trap;
 	char *wh_name = NULL;
+	struct path path;
 
 	lower_new_dentry = unionfs_lower_dentry_idx(new_dentry, bindex);
 	lower_old_dentry = unionfs_lower_dentry_idx(old_dentry, bindex);
@@ -79,9 +80,11 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		lower_wh_dir_dentry = lock_parent_wh(lower_wh_dentry);
 		err = is_robranch_super(old_dentry->d_sb, bindex);
-		if (!err)
-			err = vfs_unlink(lower_wh_dir_dentry->d_inode,
-					 lower_wh_dentry);
+		if (!err) {
+			path.dentry = lower_wh_dir_dentry;
+			path.mnt = unionfs_lower_mnt_idx(new_dentry, bindex);
+			err = path_unlink(&path, lower_wh_dentry);
+		}
 
 		dput(lower_wh_dentry);
 		unlock_dir(lower_wh_dir_dentry);
@@ -135,8 +138,10 @@ static int __unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		err = -ENOTEMPTY;
 		goto out_err_unlock;
 	}
-	err = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
-			 lower_new_dir_dentry->d_inode, lower_new_dentry);
+	path.dentry = lower_old_dir_dentry;
+	path.mnt = unionfs_lower_mnt_idx(old_dentry, bindex);
+	err = path_rename(&path, lower_old_dentry,
+			  lower_new_dir_dentry->d_inode, lower_new_dentry);
 out_err_unlock:
 	if (!err) {
 		/* update parent dir times */
@@ -220,9 +225,12 @@ static int do_unionfs_rename(struct inode *old_dir,
 
 		unlink_dir_dentry = lock_parent(unlink_dentry);
 		err = is_robranch_super(old_dir->i_sb, bindex);
-		if (!err)
-			err = vfs_unlink(unlink_dir_dentry->d_inode,
-					 unlink_dentry);
+		if (!err) {
+			struct path path;
+			path.dentry = unlink_dir_dentry;
+			path.mnt = unionfs_lower_mnt_idx(new_dentry, bindex);
+			err = path_unlink(&path, unlink_dentry);
+		}
 
 		fsstack_copy_attr_times(new_dentry->d_parent->d_inode,
 					unlink_dir_dentry->d_inode);
@@ -283,6 +291,8 @@ static int do_unionfs_rename(struct inode *old_dir,
 	if ((old_bstart != old_bend) || (do_copyup != -1)) {
 		struct dentry *lower_parent;
 		struct nameidata nd;
+		struct vfsmount *mnt;
+
 		if (!wh_old || wh_old->d_inode || bwh_old < 0) {
 			printk(KERN_ERR "unionfs: rename error "
 			       "(wh_old=%p/%p bwh_old=%d)\n", wh_old,
@@ -290,12 +300,14 @@ static int do_unionfs_rename(struct inode *old_dir,
 			err = -EIO;
 			goto out;
 		}
-		err = init_lower_nd(&nd, LOOKUP_CREATE);
+		mnt = unionfs_lower_mnt_idx(old_dentry, bwh_old);
+		err = init_lower_nd(&nd, NULL, /* set nd.path.dentry below */
+				    mnt, LOOKUP_CREATE);
 		if (unlikely(err < 0))
 			goto out;
 		lower_parent = lock_parent_wh(wh_old);
-		local_err = vfs_create(lower_parent->d_inode, wh_old, S_IRUGO,
-				       &nd);
+		nd.path.dentry = lower_parent;
+		local_err = path_create(&nd.path, wh_old, S_IRUGO, &nd);
 		unlock_dir(lower_parent);
 		if (!local_err) {
 			set_dbopaque(old_dentry, bwh_old);
diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index 2a8c88e..2d94e85 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -60,7 +60,7 @@ void __unionfs_create(struct work_struct *work)
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct create_args *c = &args->create;
 
-	args->err = vfs_create(c->parent, c->dentry, c->mode, c->nd);
+	args->err = path_create(&args->path, c->dentry, c->mode, c->nd);
 	complete(&args->comp);
 }
 
@@ -69,7 +69,7 @@ void __unionfs_mkdir(struct work_struct *work)
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct mkdir_args *m = &args->mkdir;
 
-	args->err = vfs_mkdir(m->parent, m->dentry, m->mode);
+	args->err = path_mkdir(&args->path, m->dentry, m->mode);
 	complete(&args->comp);
 }
 
@@ -78,7 +78,7 @@ void __unionfs_mknod(struct work_struct *work)
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct mknod_args *m = &args->mknod;
 
-	args->err = vfs_mknod(m->parent, m->dentry, m->mode, m->dev);
+	args->err = path_mknod(&args->path, m->dentry, m->mode, m->dev);
 	complete(&args->comp);
 }
 
@@ -87,7 +87,7 @@ void __unionfs_symlink(struct work_struct *work)
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct symlink_args *s = &args->symlink;
 
-	args->err = vfs_symlink(s->parent, s->dentry, s->symbuf, s->mode);
+	args->err = path_symlink(&args->path, s->dentry, s->symbuf, s->mode);
 	complete(&args->comp);
 }
 
@@ -96,7 +96,7 @@ void __unionfs_unlink(struct work_struct *work)
 	struct sioq_args *args = container_of(work, struct sioq_args, work);
 	struct unlink_args *u = &args->unlink;
 
-	args->err = vfs_unlink(u->parent, u->dentry);
+	args->err = path_unlink(&args->path, u->dentry);
 	complete(&args->comp);
 }
 
diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index afb71ee..633b06a 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -63,6 +63,7 @@ struct sioq_args {
 	struct work_struct work;
 	int err;
 	void *ret;
+	struct path path;
 
 	union {
 		struct deletewh_args deletewh;
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 1a40f63..dbe5e06 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -26,12 +26,13 @@
 int create_whiteout(struct dentry *dentry, int start)
 {
 	int bstart, bend, bindex;
-	struct dentry *lower_dir_dentry;
+	struct dentry *lower_dir_dentry = NULL;
 	struct dentry *lower_dentry;
 	struct dentry *lower_wh_dentry;
 	struct nameidata nd;
 	char *name = NULL;
 	int err = -EINVAL;
+	struct vfsmount *mnt;
 
 	verify_locked(dentry);
 
@@ -87,16 +88,19 @@ int create_whiteout(struct dentry *dentry, int start)
 			goto out;
 		}
 
-		err = init_lower_nd(&nd, LOOKUP_CREATE);
+		mnt = unionfs_lower_mnt_idx(dentry->d_parent, bindex);
+		err = init_lower_nd(&nd, NULL, /* lower dentry set below */
+				    mnt, LOOKUP_CREATE);
 		if (unlikely(err < 0))
 			goto out;
 		lower_dir_dentry = lock_parent_wh(lower_wh_dentry);
+		nd.path.dentry = lower_dir_dentry;
 		err = is_robranch_super(dentry->d_sb, bindex);
 		if (!err)
-			err = vfs_create(lower_dir_dentry->d_inode,
-					 lower_wh_dentry,
-					 ~current->fs->umask & S_IRWXUGO,
-					 &nd);
+			err = path_create(&nd.path,
+					  lower_wh_dentry,
+					  ~current->fs->umask & S_IRWXUGO,
+					  &nd);
 		unlock_dir(lower_dir_dentry);
 		dput(lower_wh_dentry);
 		release_lower_nd(&nd, err);
@@ -189,11 +193,13 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 		goto out;
 	}
 
-	err = init_lower_nd(&nd, LOOKUP_CREATE);
+	err = init_lower_nd(&nd, lower_dentry,
+			    unionfs_lower_mnt_idx(dentry, bindex),
+			    LOOKUP_CREATE);
 	if (unlikely(err < 0))
 		goto out;
 	if (!diropq->d_inode)
-		err = vfs_create(lower_dir, diropq, S_IRUGO, &nd);
+		err = path_create(&nd.path, diropq, S_IRUGO, &nd);
 	if (!err)
 		set_dbopaque(dentry, bindex);
 	release_lower_nd(&nd, err);
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 735d40c..681eab1 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -303,7 +303,8 @@ static inline void unionfs_double_lock_dentry(struct dentry *d1,
 extern int new_dentry_private_data(struct dentry *dentry, int subclass);
 extern void free_dentry_private_data(struct dentry *dentry);
 extern void update_bstart(struct dentry *dentry);
-extern int init_lower_nd(struct nameidata *nd, unsigned int flags);
+extern int init_lower_nd(struct nameidata *nd, struct dentry *dentry,
+			 struct vfsmount *mnt, unsigned int flags);
 extern void release_lower_nd(struct nameidata *nd, int err);
 
 /*
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index cad0386..6216f8a 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -67,14 +67,16 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 		dget(lower_dentry);
 		err = is_robranch_super(dentry->d_sb, bindex);
 		if (!err) {
+			struct path path;
+			path.dentry = lower_dir_dentry;
+			path.mnt = unionfs_lower_mnt_idx(dentry->d_parent,
+							 bindex);
 			/* see Documentation/filesystems/unionfs/issues.txt */
 			lockdep_off();
 			if (!S_ISDIR(lower_dentry->d_inode->i_mode))
-				err = vfs_unlink(lower_dir_dentry->d_inode,
-								lower_dentry);
+				err = path_unlink(&path, lower_dentry);
 			else
-				err = vfs_rmdir(lower_dir_dentry->d_inode,
-								lower_dentry);
+				err = path_rmdir(&path, lower_dentry);
 			lockdep_on();
 		}
 
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 8001c65..f168bea 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -73,6 +73,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 {
 	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
+	struct path path;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -83,9 +84,10 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 	}
 
 	lower_dentry = unionfs_lower_dentry(dentry);
+	path.dentry = lower_dentry;
+	path.mnt = unionfs_lower_mnt(dentry);
 
-	err = vfs_setxattr(lower_dentry, (char *) name, (void *) value,
-			   size, flags);
+	err = path_setxattr(&path, (char *) name, (void *) value, size, flags);
 
 out:
 	unionfs_check_dentry(dentry);
@@ -102,6 +104,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct dentry *lower_dentry = NULL;
 	int err = -EOPNOTSUPP;
+	struct path path;
 
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
@@ -112,8 +115,10 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 	}
 
 	lower_dentry = unionfs_lower_dentry(dentry);
+	path.dentry = lower_dentry;
+	path.mnt = unionfs_lower_mnt(dentry);
 
-	err = vfs_removexattr(lower_dentry, (char *) name);
+	err = path_removexattr(&path, (char *) name);
 
 out:
 	unionfs_check_dentry(dentry);
