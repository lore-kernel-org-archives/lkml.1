Return-Path: <linux-kernel-owner+w=401wt.eu-S1946449AbXBIWzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946449AbXBIWzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946474AbXBIWyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:32 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46666 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423366AbXBIWxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:40 -0500
Subject: [PATCH 12/22] elevate write count files are open()ed
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:37 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225337.C8EC7257@localhost.localdomain>
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

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/file_table.c |    5 ++++-
 lxc-dave/fs/namei.c      |   22 ++++++++++++++++++----
 lxc-dave/ipc/mqueue.c    |    3 +++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff -puN fs/file_table.c~14-24-tricky-elevate-write-count-files-are-open-ed fs/file_table.c
--- lxc/fs/file_table.c~14-24-tricky-elevate-write-count-files-are-open-ed	2007-02-09 14:26:54.000000000 -0800
+++ lxc-dave/fs/file_table.c	2007-02-09 14:26:54.000000000 -0800
@@ -209,8 +209,11 @@ void fastcall __fput(struct file *file)
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-	if (file->f_mode & FMODE_WRITE)
+	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		if(!special_file(inode->i_mode))
+			mnt_drop_write(mnt);
+	}
 	put_pid(file->f_owner.pid);
 	put_user_ns(file->f_owner.user_ns);
 	file_kill(file);
diff -puN fs/namei.c~14-24-tricky-elevate-write-count-files-are-open-ed fs/namei.c
--- lxc/fs/namei.c~14-24-tricky-elevate-write-count-files-are-open-ed	2007-02-09 14:26:54.000000000 -0800
+++ lxc-dave/fs/namei.c	2007-02-09 14:26:54.000000000 -0800
@@ -1548,8 +1548,17 @@ int may_open(struct nameidata *nd, int a
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
+		if (IS_RDONLY(inode))
+			return -EROFS;
+	}
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
@@ -1688,14 +1697,17 @@ do_last:
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
@@ -1733,6 +1745,8 @@ ok:
 		goto exit;
 	return 0;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	dput_path(&path, nd);
 exit:
diff -puN ipc/mqueue.c~14-24-tricky-elevate-write-count-files-are-open-ed ipc/mqueue.c
--- lxc/ipc/mqueue.c~14-24-tricky-elevate-write-count-files-are-open-ed	2007-02-09 14:26:54.000000000 -0800
+++ lxc-dave/ipc/mqueue.c	2007-02-09 14:26:54.000000000 -0800
@@ -687,6 +687,9 @@ asmlinkage long sys_mq_open(const char _
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
