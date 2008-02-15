Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbYBOWsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbYBOWsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbYBOWiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:00 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36190 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761208AbYBOWhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:51 -0500
Subject: [PATCH 20/30] r/o bind mounts: elevate write count for open()s
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:48 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223748.C78D65D3@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the first really tricky patch in the series.  It elevates the writer
count on a mount each time a non-special file is opened for write.

We used to do this in may_open(), but Miklos pointed out that __dentry_open()
is used as well to create filps.  This will cover even those cases, while a
call in may_open() would not have.

There is also an elevated count around the vfs_create() call in open_namei(). 
See the comments for more details, but we need this to fix a 'create, remount,
fail r/w open()' race.

Some filesystems forego the use of normal vfs calls to create
struct files.   Make sure that these users elevate the mnt
writer count because they will get __fput(), and we need
to make sure they're balanced.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/file_table.c |   14 ++++++
 linux-2.6.git-dave/fs/namei.c      |   75 ++++++++++++++++++++++++++++++++-----
 linux-2.6.git-dave/fs/open.c       |   36 ++++++++++++++++-
 linux-2.6.git-dave/ipc/mqueue.c    |   16 ++++++-
 4 files changed, 127 insertions(+), 14 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-opened-files fs/file_table.c
--- linux-2.6.git/fs/file_table.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-15 13:25:53.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2008-02-15 13:25:53.000000000 -0800
@@ -199,6 +199,17 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
+
+	/*
+	 * These mounts don't really matter in practice
+	 * for r/o bind mounts.  They aren't userspace-
+	 * visible.  We do this for consistency, and so
+	 * that we can do debugging checks at __fput()
+	 */
+	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		error = mnt_want_write(mnt);
+		WARN_ON(error);
+	}
 	return error;
 }
 EXPORT_SYMBOL(init_file);
@@ -221,10 +232,13 @@ EXPORT_SYMBOL(fput);
  */
 void drop_file_write_access(struct file *file)
 {
+	struct vfsmount *mnt = file->f_path.mnt;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 
 	put_write_access(inode);
+	if (!special_file(inode->i_mode))
+		mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL_GPL(drop_file_write_access);
 
diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-opened-files fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-15 13:25:53.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:53.000000000 -0800
@@ -1622,8 +1622,7 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (acc_mode & MAY_WRITE))
-		return -EROFS;
+	}
 
 	error = vfs_permission(nd, acc_mode);
 	if (error)
@@ -1723,18 +1722,32 @@ static inline int open_to_namei_flags(in
 	return flag;
 }
 
+static int open_will_write_to_fs(int flag, struct inode *inode)
+{
+	/*
+	 * We'll never write to the fs underlying
+	 * a device file.
+	 */
+	if (special_file(inode->i_mode))
+		return 0;
+	return (flag & O_TRUNC);
+}
+
 /*
- * Note that the low bits of "flag" aren't the same as in the open
- * system call.  See open_to_namei_flags().
+ * Note that the low bits of the passed in "open_flag"
+ * are not the same as in the local variable "flag". See
+ * open_to_namei_flags() for more details.
  */
 struct file *do_filp_open(int dfd, const char *pathname,
 		int open_flag, int mode)
 {
+	struct file *filp;
 	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
 	int count = 0;
+	int will_write;
 	int flag = open_to_namei_flags(open_flag);
 
 	acc_mode = ACC_MODE(flag);
@@ -1790,17 +1803,30 @@ do_last:
 	}
 
 	if (IS_ERR(nd.intent.open.file)) {
-		mutex_unlock(&dir->d_inode->i_mutex);
 		error = PTR_ERR(nd.intent.open.file);
-		goto exit_dput;
+		goto exit_mutex_unlock;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = __open_namei_create(&nd, &path, flag, mode);
+		/*
+		 * This write is needed to ensure that a
+		 * ro->rw transition does not occur between
+		 * the time when the file is created and when
+		 * a permanent write count is taken through
+		 * the 'struct file' in nameidata_to_filp().
+		 */
+		error = mnt_want_write(nd.path.mnt);
 		if (error)
+			goto exit_mutex_unlock;
+		error = __open_namei_create(&nd, &path, flag, mode);
+		if (error) {
+			mnt_drop_write(nd.path.mnt);
 			goto exit;
-		return nameidata_to_filp(&nd, open_flag);
+		}
+		filp = nameidata_to_filp(&nd, open_flag);
+		mnt_drop_write(nd.path.mnt);
+		return filp;
 	}
 
 	/*
@@ -1830,11 +1856,40 @@ do_last:
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
+	/*
+	 * Consider:
+	 * 1. may_open() truncates a file
+	 * 2. a rw->ro mount transition occurs
+	 * 3. nameidata_to_filp() fails due to
+	 *    the ro mount.
+	 * That would be inconsistent, and should
+	 * be avoided. Taking this mnt write here
+	 * ensures that (2) can not occur.
+	 */
+	will_write = open_will_write_to_fs(flag, nd.path.dentry->d_inode);
+	if (will_write) {
+		error = mnt_want_write(nd.path.mnt);
+		if (error)
+			goto exit;
+	}
 	error = may_open(&nd, acc_mode, flag);
-	if (error)
+	if (error) {
+		if (will_write)
+			mnt_drop_write(nd.path.mnt);
 		goto exit;
-	return nameidata_to_filp(&nd, open_flag);
+	}
+	filp = nameidata_to_filp(&nd, open_flag);
+	/*
+	 * It is now safe to drop the mnt write
+	 * because the filp has had a write taken
+	 * on its behalf.
+	 */
+	if (will_write)
+		mnt_drop_write(nd.path.mnt);
+	return filp;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	path_put_conditional(&path, &nd);
 exit:
diff -puN fs/open.c~r-o-bind-mounts-elevate-write-count-opened-files fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-15 13:25:53.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-15 13:25:53.000000000 -0800
@@ -730,6 +730,35 @@ out:
 	return error;
 }
 
+/*
+ * You have to be very careful that these write
+ * counts get cleaned up in error cases and
+ * upon __fput().  This should probably never
+ * be called outside of __dentry_open().
+ */
+static inline int __get_file_write_access(struct inode *inode,
+					  struct vfsmount *mnt)
+{
+	int error;
+	error = get_write_access(inode);
+	if (error)
+		return error;
+	/*
+	 * Do not take mount writer counts on
+	 * special files since no writes to
+	 * the mount itself will occur.
+	 */
+	if (!special_file(inode->i_mode)) {
+		/*
+		 * Balanced in __fput()
+		 */
+		error = mnt_want_write(mnt);
+		if (error)
+			put_write_access(inode);
+	}
+	return error;
+}
+
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					int flags, struct file *f,
 					int (*open)(struct inode *, struct file *))
@@ -742,7 +771,7 @@ static struct file *__dentry_open(struct
 				FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = get_write_access(inode);
+		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
 	}
@@ -784,8 +813,11 @@ static struct file *__dentry_open(struct
 
 cleanup_all:
 	fops_put(f->f_op);
-	if (f->f_mode & FMODE_WRITE)
+	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		if (!special_file(inode->i_mode))
+			mnt_drop_write(mnt);
+	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-opened-files ipc/mqueue.c
--- linux-2.6.git/ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-15 13:25:53.000000000 -0800
+++ linux-2.6.git-dave/ipc/mqueue.c	2008-02-15 13:25:53.000000000 -0800
@@ -598,6 +598,7 @@ static struct file *do_create(struct den
 			int oflag, mode_t mode, struct mq_attr __user *u_attr)
 {
 	struct mq_attr attr;
+	struct file *result;
 	int ret;
 
 	if (u_attr) {
@@ -612,13 +613,24 @@ static struct file *do_create(struct den
 	}
 
 	mode &= ~current->fs->umask;
+	ret = mnt_want_write(mqueue_mnt);
+	if (ret)
+		goto out;
 	ret = vfs_create(dir->d_inode, dentry, mode, NULL);
 	dentry->d_fsdata = NULL;
 	if (ret)
-		goto out;
+		goto out_drop_write;
 
-	return dentry_open(dentry, mqueue_mnt, oflag);
+	result = dentry_open(dentry, mqueue_mnt, oflag);
+	/*
+	 * dentry_open() took a persistent mnt_want_write(),
+	 * so we can now drop this one.
+	 */
+	mnt_drop_write(mqueue_mnt);
+	return result;
 
+out_drop_write:
+	mnt_drop_write(mqueue_mnt);
 out:
 	dput(dentry);
 	mntput(mqueue_mnt);
_
