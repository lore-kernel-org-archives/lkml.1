Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbXIQS3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbXIQS3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXIQS1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54889 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbXIQS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:28 -0400
Subject: [PATCH 05/24] elevate write count open()'d files
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:24 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182724.5402E082@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is the first really tricky patch in the series.  It
elevates the writer count on a mount each time a
non-special file is opened for write.

This is not completely apparent in the patch because the
two if() conditions in may_open() above the
mnt_want_write() call are, combined, equivalent to
special_file().

There is also an elevated count around the vfs_create()
call in open_namei().  The count needs to be kept elevated
all the way into the may_open() call.  Otherwise, when the
write is dropped, a ro->rw transisition could occur.  This
would lead to having rw access on the newly created file,
while the vfsmount is ro.  That is bad.

Some filesystems forego the use of normal vfs calls to create
struct files.  Make sure that these users elevate the mnt writer
count because they will get __fput(), and we need to make
sure they're balanced.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/file_table.c |    9 ++++++++-
 lxc-dave/fs/namei.c      |   20 ++++++++++++++++----
 lxc-dave/ipc/mqueue.c    |    3 +++
 3 files changed, 27 insertions(+), 5 deletions(-)

diff -puN fs/file_table.c~tricky-elevate-write-count-files-are-open-ed fs/file_table.c
--- lxc/fs/file_table.c~tricky-elevate-write-count-files-are-open-ed	2007-09-17 09:43:57.000000000 -0700
+++ lxc-dave/fs/file_table.c	2007-09-17 09:43:57.000000000 -0700
@@ -167,6 +167,10 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
+	if (mode & FMODE_WRITE) {
+		error = mnt_want_write(mnt);
+		WARN_ON(error);
+	}
 	return error;
 }
 EXPORT_SYMBOL(init_file);
@@ -204,8 +208,11 @@ void fastcall __fput(struct file *file)
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
diff -puN fs/namei.c~tricky-elevate-write-count-files-are-open-ed fs/namei.c
--- lxc/fs/namei.c~tricky-elevate-write-count-files-are-open-ed	2007-09-17 09:43:57.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-17 09:43:57.000000000 -0700
@@ -1620,8 +1620,15 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
-		return -EROFS;
+	} else if (flag & FMODE_WRITE) {
+		/*
+		 * effectively: !special_file()
+		 * balanced by __fput()
+		 */
+		error = mnt_want_write(nd->mnt);
+		if (error)
+			return error;
+	}
 
 	error = vfs_permission(nd, acc_mode);
 	if (error)
@@ -1764,14 +1771,17 @@ do_last:
 	}
 
 	if (IS_ERR(nd->intent.open.file)) {
-		mutex_unlock(&dir->d_inode->i_mutex);
 		error = PTR_ERR(nd->intent.open.file);
-		goto exit_dput;
+		goto exit_mutex_unlock;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
+		error = mnt_want_write(nd->mnt);
+		if (error)
+			goto exit_mutex_unlock;
 		error = open_namei_create(nd, &path, flag, mode);
+		mnt_drop_write(nd->mnt);
 		if (error)
 			goto exit;
 		return 0;
@@ -1809,6 +1819,8 @@ ok:
 		goto exit;
 	return 0;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	dput_path(&path, nd);
 exit:
diff -puN ipc/mqueue.c~tricky-elevate-write-count-files-are-open-ed ipc/mqueue.c
--- lxc/ipc/mqueue.c~tricky-elevate-write-count-files-are-open-ed	2007-09-17 09:43:57.000000000 -0700
+++ lxc-dave/ipc/mqueue.c	2007-09-17 09:43:57.000000000 -0700
@@ -683,6 +683,9 @@ asmlinkage long sys_mq_open(const char _
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
