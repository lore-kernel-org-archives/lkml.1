Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbYBHWgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbYBHWgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbYBHW1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:25 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43017 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYBHW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:18 -0500
Subject: [RFC][PATCH 20/30] r/o bind mounts: elevate write count for open()s
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:27:14 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222714.989BEE44@kernel>
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

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/file_table.c |   14 ++++++
 linux-2.6.git-dave/fs/namei.c      |   75 ++++++++++++++++++++++++++++++++-----
 linux-2.6.git-dave/fs/open.c       |   36 ++++++++++++++++-
 linux-2.6.git-dave/ipc/mqueue.c    |   16 ++++++-
 4 files changed, 127 insertions(+), 14 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-opened-files fs/file_table.c
--- linux-2.6.git/fs/file_table.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-08 13:04:55.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2008-02-08 13:04:55.000000000 -0800
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
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-08 13:04:55.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-08 13:04:55.000000000 -0800
@@ -1620,8 +1620,7 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (acc_mode & MAY_WRITE))
-		return -EROFS;
+	}
 
 	error = vfs_permission(nd, acc_mode);
 	if (error)
@@ -1721,18 +1720,32 @@ static inline int open_to_namei_flags(in
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
@@ -1788,17 +1801,30 @@ do_last:
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
+		error = mnt_want_write(nd.mnt);
 		if (error)
+			goto exit_mutex_unlock;
+		error = __open_namei_create(&nd, &path, flag, mode);
+		if (error) {
+			mnt_drop_write(nd.mnt);
 			goto exit;
-		return nameidata_to_filp(&nd, open_flag);
+		}
+		filp = nameidata_to_filp(&nd, open_flag);
+		mnt_drop_write(nd.mnt);
+		return filp;
 	}
 
 	/*
@@ -1828,11 +1854,40 @@ do_last:
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
+	will_write = open_will_write_to_fs(flag, nd.dentry->d_inode);
+	if (will_write) {
+		error = mnt_want_write(nd.mnt);
+		if (error)
+			goto exit;
+	}
 	error = may_open(&nd, acc_mode, flag);
-	if (error)
+	if (error) {
+		if (will_write)
+			mnt_drop_write(nd.mnt);
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
+		mnt_drop_write(nd.mnt);
+	return filp;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	dput_path(&path, &nd);
 exit:
diff -puN fs/open.c~r-o-bind-mounts-elevate-write-count-opened-files fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-08 13:04:55.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-08 13:04:55.000000000 -0800
@@ -734,6 +734,35 @@ out:
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
@@ -746,7 +775,7 @@ static struct file *__dentry_open(struct
 				FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = get_write_access(inode);
+		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
 	}
@@ -788,8 +817,11 @@ static struct file *__dentry_open(struct
 
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
--- linux-2.6.git/ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-opened-files	2008-02-08 13:04:55.000000000 -0800
+++ linux-2.6.git-dave/ipc/mqueue.c	2008-02-08 13:04:55.000000000 -0800
@@ -599,6 +599,7 @@ static struct file *do_create(struct den
 			int oflag, mode_t mode, struct mq_attr __user *u_attr)
 {
 	struct mq_attr attr;
+	struct file *result;
 	int ret;
 
 	if (u_attr) {
@@ -613,13 +614,24 @@ static struct file *do_create(struct den
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
