Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbXKAXOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbXKAXOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759416AbXKAXI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38232 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759216AbXKAXIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:52 -0400
Subject: [PATCH 17/27] r-o-bind-mounts-elevate-write-count-opend-files
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:49 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230849.0AC329D1@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is an old patch combined with a couple other ones I've
been working on.  It should the issues that Miklos has
spotted.

--

This is the first really tricky patch in the series.  It
elevates the writer count on a mount each time a non-special
file is opened for write.

We used to do this in may_open(), but Miklos pointed out
that __dentry_open() is used as well to create filps.  This
will cover even those cases, while a call in may_open()
would not have.

There is also an elevated count around the vfs_create() call
in open_namei().  See the comments for more details, but we
need this to fix a 'create, remount, fail r/w open()' race.

Some filesystems forego the use of normal vfs calls to create
struct files.   Make sure that these users elevate the mnt
writer count because they will get __fput(), and we need
to make sure they're balanced.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/file_table.c |   16 +++++++-
 linux-2.6.git-dave/fs/namei.c      |   74 ++++++++++++++++++++++++++++++++-----
 linux-2.6.git-dave/fs/open.c       |   36 +++++++++++++++++-
 linux-2.6.git-dave/ipc/mqueue.c    |    3 +
 4 files changed, 116 insertions(+), 13 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-opend-files fs/file_table.c
--- linux-2.6.git/fs/file_table.c~r-o-bind-mounts-elevate-write-count-opend-files	2007-11-01 14:46:16.000000000 -0700
+++ linux-2.6.git-dave/fs/file_table.c	2007-11-01 14:46:16.000000000 -0700
@@ -193,6 +193,17 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
+
+	/*
+	 * These mounts don't really matter in practice
+	 * for r/o bind mounts.  They aren't userspace-
+	 * visible.  We do this for consistency, and so
+	 * that we can do debugging checks at __fput()e
+	 */
+	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		error = mnt_want_write(mnt);
+		WARN_ON(error);
+	}
 	return error;
 }
 EXPORT_SYMBOL(init_file);
@@ -230,8 +241,11 @@ void fastcall __fput(struct file *file)
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-	if (file->f_mode & FMODE_WRITE)
+	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		if (!special_file(inode->i_mode))
+			mnt_drop_write(mnt);
+	}
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-opend-files fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-write-count-opend-files	2007-11-01 14:46:16.000000000 -0700
+++ linux-2.6.git-dave/fs/namei.c	2007-11-01 14:46:16.000000000 -0700
@@ -1620,12 +1620,12 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
-		return -EROFS;
+	}
 
 	error = vfs_permission(nd, acc_mode);
 	if (error)
 		return error;
+
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
@@ -1721,18 +1721,31 @@ static inline int sys_open_flags_to_name
 	return flag;
 }
 
+static inline int open_will_write_to_fs(int flag, struct inode *inode)
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
  *	open_pathname()
  *
  * namei for open - this is in fact almost the whole open-routine.
  *
- * Note that the low bits of "flag" aren't the same as in the open
- * system call.  See sys_open_flags_to_namei_flags().
+ * Note that the low bits of the passed in "sys_open_flag"
+ * are not the same as in the local variable "flag". See
+ * sys_open_flags_to_namei_flags() for more details.
  * SMP-safe
  */
 struct file *open_pathname(int dfd, const char *pathname,
 			   int sys_open_flag, int mode)
 {
+	struct file *filp;
 	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
@@ -1792,17 +1805,30 @@ do_last:
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
-		return nameidata_to_filp(&nd, sys_open_flag);
+		}
+		filp = nameidata_to_filp(&nd, sys_open_flag);
+		mnt_drop_write(nd.mnt);
+		return filp;
 	}
 
 	/*
@@ -1832,11 +1858,39 @@ do_last:
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
+	if (open_will_write_to_fs(flag, nd.dentry->d_inode)) {
+		error = mnt_want_write(nd.mnt);
+		if (error)
+			goto exit;
+	}
 	error = may_open(&nd, acc_mode, flag);
-	if (error)
+	if (error) {
+		if (open_will_write_to_fs(flag, nd.dentry->d_inode))
+			mnt_drop_write(nd.mnt);
 		goto exit;
-	return nameidata_to_filp(&nd, sys_open_flag);
+	}
+	filp = nameidata_to_filp(&nd, sys_open_flag);
+	/*
+	 * It is now safe to drop the mnt write
+	 * because the filp has had a write taken
+	 * on its behalf.
+	 */
+	if (open_will_write_to_fs(flag, nd.dentry->d_inode))
+		mnt_drop_write(nd.mnt);
+	return filp;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	dput_path(&path, &nd);
 exit:
diff -puN fs/open.c~r-o-bind-mounts-elevate-write-count-opend-files fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-elevate-write-count-opend-files	2007-11-01 14:46:16.000000000 -0700
+++ linux-2.6.git-dave/fs/open.c	2007-11-01 14:46:16.000000000 -0700
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
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-opend-files ipc/mqueue.c
--- linux-2.6.git/ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-opend-files	2007-11-01 14:46:16.000000000 -0700
+++ linux-2.6.git-dave/ipc/mqueue.c	2007-11-01 14:46:16.000000000 -0700
@@ -682,6 +682,9 @@ asmlinkage long sys_mq_open(const char _
 				goto out;
 			filp = do_open(dentry, oflag);
 		} else {
+			error = mnt_want_write(mqueue_mnt);
+			if (error)
+				goto out;
 			filp = do_create(mqueue_mnt->mnt_root, dentry,
 						oflag, mode, u_attr);
 		}
_
