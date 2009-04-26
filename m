Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZDZKiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZDZKiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 06:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZDZKga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 06:36:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZDZKgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 06:36:25 -0400
Message-Id: <20090426102953.436066523@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sun, 26 Apr 2009 20:25:55 +1000
From: npiggin@suse.de
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [patch 3/5] fs: introduce mnt_clone_write
References: <20090426102552.947523845@suse.de>
Content-Disposition: inline; filename=mnt_clone_write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch speeds up lmbench lat_mmap test by about another 2% after the
first patch.

Before:
 avg = 462.286
 std = 5.46106

After:
 avg = 453.12
 std = 9.58257

(50 runs of each, stddev gives a reasonable confidence)

It does this by introducing mnt_clone_write, which avoids some heavyweight
operations of mnt_want_write if called on a vfsmount which we know already
has a write count; and mnt_want_write_file, which can call mnt_clone_write
if the file is open for write.

After these two patches, mnt_want_write and mnt_drop_write go from 7% on
the profile down to 1.3% (including mnt_clone_write).

Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/file_table.c       |    2 +-
 fs/inode.c            |    2 +-
 fs/namespace.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/open.c             |    4 ++--
 fs/xattr.c            |    4 ++--
 include/linux/mount.h |    4 ++++
 6 files changed, 50 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c
+++ linux-2.6/fs/file_table.c
@@ -214,7 +214,7 @@ int init_file(struct file *file, struct
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
 		file_take_write(file);
-		error = mnt_want_write(mnt);
+		error = mnt_clone_write(mnt);
 		WARN_ON(error);
 	}
 	return error;
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -1401,7 +1401,7 @@ void file_update_time(struct file *file)
 	if (IS_NOCMTIME(inode))
 		return;
 
-	err = mnt_want_write(file->f_path.mnt);
+	err = mnt_want_write_file(file->f_path.mnt, file);
 	if (err)
 		return;
 
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c
+++ linux-2.6/fs/namespace.c
@@ -265,6 +265,46 @@ out:
 EXPORT_SYMBOL_GPL(mnt_want_write);
 
 /**
+ * mnt_clone_write - get write access to a mount
+ * @mnt: the mount on which to take a write
+ *
+ * This is effectively like mnt_want_write, except
+ * it must only be used to take an extra write reference
+ * on a mountpoint that we already know has a write reference
+ * on it. This allows some optimisation.
+ *
+ * After finished, mnt_drop_write must be called as usual to
+ * drop the reference.
+ */
+int mnt_clone_write(struct vfsmount *mnt)
+{
+	/* superblock may be r/o */
+	if (__mnt_is_readonly(mnt))
+		return -EROFS;
+	preempt_disable();
+	inc_mnt_writers(mnt);
+	preempt_enable();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mnt_clone_write);
+
+/**
+ * mnt_want_write_file - get write access to a file's mount
+ * @file: the file who's mount on which to take a write
+ *
+ * This is like mnt_want_write, but it takes a file and can
+ * do some optimisations if the file is open for write already
+ */
+int mnt_want_write_file(struct vfsmount *mnt, struct file *file)
+{
+	if (!(file->f_mode & FMODE_WRITE))
+		return mnt_want_write(mnt);
+	else
+		return mnt_clone_write(mnt);
+}
+EXPORT_SYMBOL_GPL(mnt_want_write_file);
+
+/**
  * mnt_drop_write - give up write access to a mount
  * @mnt: the mount on which to give up write access
  *
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c
+++ linux-2.6/fs/open.c
@@ -612,7 +612,7 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd
 
 	audit_inode(NULL, dentry);
 
-	err = mnt_want_write(file->f_path.mnt);
+	err = mnt_want_write_file(file->f_path.mnt, file);
 	if (err)
 		goto out_putf;
 	mutex_lock(&inode->i_mutex);
@@ -761,7 +761,7 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd
 	if (!file)
 		goto out;
 
-	error = mnt_want_write(file->f_path.mnt);
+	error = mnt_want_write_file(file->f_path.mnt, file);
 	if (error)
 		goto out_fput;
 	dentry = file->f_path.dentry;
Index: linux-2.6/fs/xattr.c
===================================================================
--- linux-2.6.orig/fs/xattr.c
+++ linux-2.6/fs/xattr.c
@@ -297,7 +297,7 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, cons
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = mnt_want_write(f->f_path.mnt);
+	error = mnt_want_write_file(f->f_path.mnt, f);
 	if (!error) {
 		error = setxattr(dentry, name, value, size, flags);
 		mnt_drop_write(f->f_path.mnt);
@@ -524,7 +524,7 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, c
 		return error;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = mnt_want_write(f->f_path.mnt);
+	error = mnt_want_write_file(f->f_path.mnt, f);
 	if (!error) {
 		error = removexattr(dentry, name);
 		mnt_drop_write(f->f_path.mnt);
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h
+++ linux-2.6/include/linux/mount.h
@@ -88,7 +88,11 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
+struct file; /* forward dec */
+
 extern int mnt_want_write(struct vfsmount *mnt);
+extern int mnt_want_write_file(struct vfsmount *mnt, struct file *file);
+extern int mnt_clone_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);


