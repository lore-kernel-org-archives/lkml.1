Return-Path: <linux-kernel-owner+w=401wt.eu-S1765281AbYEFJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765281AbYEFJUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764303AbYEFJOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:14:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59541 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764151AbYEFJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:14:37 -0400
Message-Id: <20080506091422.705393283@szeredi.hu>
References: <20080506091327.259950960@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 May 2008 11:13:40 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: [patch 13/24] vfs: utimes cleanup
Content-Disposition: inline; filename=utimes_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Untange the mess that is do_utimes()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Ulrich Drepper <drepper@redhat.com>
---
 fs/compat.c |    4 -
 fs/utimes.c |  197 +++++++++++++++++++++++++++++++++++++-----------------------
 2 files changed, 124 insertions(+), 77 deletions(-)

Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-06 11:04:36.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-06 11:04:37.000000000 +0200
@@ -53,54 +53,10 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-/* If times==NULL, set access and modification to current time,
- * must be owner or have write permission.
- * Else, update from *times, must be owner or super user.
- */
-long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
+static int utimes_common(struct path *path, struct timespec *times)
 {
 	int error;
-	struct nameidata nd;
-	struct dentry *dentry;
-	struct inode *inode;
 	struct iattr newattrs;
-	struct file *f = NULL;
-	struct vfsmount *mnt;
-
-	error = -EINVAL;
-	if (times && (!nsec_valid(times[0].tv_nsec) ||
-		      !nsec_valid(times[1].tv_nsec))) {
-		goto out;
-	}
-
-	if (flags & ~AT_SYMLINK_NOFOLLOW)
-		goto out;
-
-	if (filename == NULL && dfd != AT_FDCWD) {
-		error = -EINVAL;
-		if (flags & AT_SYMLINK_NOFOLLOW)
-			goto out;
-
-		error = -EBADF;
-		f = fget(dfd);
-		if (!f)
-			goto out;
-		dentry = f->f_path.dentry;
-		mnt = f->f_path.mnt;
-	} else {
-		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
-		if (error)
-			goto out;
-
-		dentry = nd.path.dentry;
-		mnt = nd.path.mnt;
-	}
-
-	inode = dentry->d_inode;
-
-	error = mnt_want_write(mnt);
-	if (error)
-		goto dput_and_out;
 
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
@@ -121,41 +77,132 @@ long do_utimes(int dfd, char __user *fil
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
 	}
+	mutex_lock(&path->dentry->d_inode->i_mutex);
+	error = mnt_want_write(path->mnt);
+	if (!error) {
+		error = notify_change(path->dentry, &newattrs);
+		mnt_drop_write(path->mnt);
+	}
+	mutex_unlock(&path->dentry->d_inode->i_mutex);
+
+	return error;
+}
+
+/*
+ * If times is NULL or both times are either UTIME_OMIT or UTIME_NOW, then
+ * need to check permissions, because inode_change_ok() won't do it.
+ */
+static bool utimes_need_permission(struct timespec *times)
+{
+	return !times || (nsec_special(times[0].tv_nsec) &&
+			  nsec_special(times[1].tv_nsec));
+}
+
+static int do_futimes(int fd, struct timespec *times)
+{
+	int error;
+	struct file *file = fget(fd);
+
+	if (!file)
+		return -EBADF;
+
+	if (utimes_need_permission(times)) {
+		struct inode *inode = file->f_path.dentry->d_inode;
+
+		error = -EACCES;
+		if (!is_owner_or_cap(inode) && !(file->f_mode & FMODE_WRITE))
+			goto out_fput;
+	}
+	error = utimes_common(&file->f_path, times);
+
+ out_fput:
+	fput(file);
+
+	return error;
+}
+
+
+/*
+ * do_futimesat - change times on filename
+ * @dfd: open file descriptor, -1 or AT_FDCWD
+ * @filename: path name
+ * @times: new times or NULL
+ * @flags: zero or more flags (only AT_SYMLINK_NOFOLLOW for the moment)
+ *
+ * Caller must verify the values in times (if not NULL)
+ *
+ * If times==NULL, set access and modification to current time,
+ * must be owner or have write permission.
+ * Else, update from *times, must be owner or super user.
+ */
+int do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
+{
+	int error;
+	struct nameidata nd;
+	int lookup_flags;
+
+	if (flags & ~AT_SYMLINK_NOFOLLOW)
+		return -EINVAL;
+
+	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	error = __user_walk_fd(dfd, filename, lookup_flags, &nd);
+	if (error)
+		return error;
+
+
+	if (utimes_need_permission(times)) {
+		struct inode *inode = nd.path.dentry->d_inode;
 
-	/*
-	 * If times is NULL or both times are either UTIME_OMIT or
-	 * UTIME_NOW, then need to check permissions, because
-	 * inode_change_ok() won't do it.
-	 */
-	if (!times || (nsec_special(times[0].tv_nsec) &&
-		       nsec_special(times[1].tv_nsec))) {
 		error = -EACCES;
-		if (!f && IS_IMMUTABLE(inode))
-			goto mnt_drop_write_and_out;
+		if (IS_IMMUTABLE(inode))
+			goto out_path_put;
 
 		if (!is_owner_or_cap(inode)) {
-			if (f) {
-				if (!(f->f_mode & FMODE_WRITE))
-					goto mnt_drop_write_and_out;
-			} else {
-				error = vfs_permission(&nd, MAY_WRITE);
-				if (error)
-					goto mnt_drop_write_and_out;
-			}
+			error = vfs_permission(&nd, MAY_WRITE);
+			if (error)
+				goto out_path_put;
 		}
 	}
-	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
-	mutex_unlock(&inode->i_mutex);
-mnt_drop_write_and_out:
-	mnt_drop_write(mnt);
-dput_and_out:
-	if (f)
-		fput(f);
-	else
-		path_put(&nd.path);
-out:
+	error = utimes_common(&nd.path, times);
+
+ out_path_put:
+	path_put(&nd.path);
+
 	return error;
+
+}
+
+/*
+ * do_futimesat - change times on filename or file descriptor
+ * @dfd: open file descriptor, -1 or AT_FDCWD
+ * @filename: path name or NULL
+ * @times: new times or NULL
+ * @flags: zero or more flags (only AT_SYMLINK_NOFOLLOW for the moment)
+ *
+ * If filename is NULL and dfd defers to an open file, then operate on
+ * the file.  Otherwise look up filename, possibly using dfd as a
+ * starting point.
+ *
+ * If times==NULL, set access and modification to current time,
+ * must be owner or have write permission.
+ * Else, update from *times, must be owner or super user.
+ */
+int do_futimesat(int dfd, char __user *filename, struct timespec *times,
+		 int flags)
+{
+	if (times && (!nsec_valid(times[0].tv_nsec) ||
+		      !nsec_valid(times[1].tv_nsec))) {
+		return -EINVAL;
+	}
+
+	if (filename == NULL && dfd != AT_FDCWD) {
+		if (flags)
+			return -EINVAL;
+
+		return do_futimes(dfd, times);
+	} else {
+		return do_utimes(dfd, filename, times, flags);
+	}
 }
 
 asmlinkage long sys_utimensat(int dfd, char __user *filename, struct timespec __user *utimes, int flags)
@@ -180,7 +227,7 @@ asmlinkage long sys_utimensat(int dfd, c
 			return 0;
 	}
 
-	return do_utimes(dfd, filename, utimes ? tstimes : NULL, flags);
+	return do_futimesat(dfd, filename, utimes ? tstimes : NULL, flags);
 }
 
 asmlinkage long sys_futimesat(int dfd, char __user *filename, struct timeval __user *utimes)
@@ -207,7 +254,7 @@ asmlinkage long sys_futimesat(int dfd, c
 		tstimes[1].tv_nsec = 1000 * times[1].tv_usec;
 	}
 
-	return do_utimes(dfd, filename, utimes ? tstimes : NULL, 0);
+	return do_futimesat(dfd, filename, utimes ? tstimes : NULL, 0);
 }
 
 asmlinkage long sys_utimes(char __user *filename, struct timeval __user *utimes)
Index: linux-2.6/fs/compat.c
===================================================================
--- linux-2.6.orig/fs/compat.c	2008-05-06 11:04:28.000000000 +0200
+++ linux-2.6/fs/compat.c	2008-05-06 11:04:37.000000000 +0200
@@ -110,7 +110,7 @@ asmlinkage long compat_sys_utimensat(uns
 		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
 			return 0;
 	}
-	return do_utimes(dfd, filename, t ? tv : NULL, flags);
+	return do_futimesat(dfd, filename, t ? tv : NULL, flags);
 }
 
 asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename, struct compat_timeval __user *t)
@@ -129,7 +129,7 @@ asmlinkage long compat_sys_futimesat(uns
 		tv[0].tv_nsec *= 1000;
 		tv[1].tv_nsec *= 1000;
 	}
-	return do_utimes(dfd, filename, t ? tv : NULL, 0);
+	return do_futimesat(dfd, filename, t ? tv : NULL, 0);
 }
 
 asmlinkage long compat_sys_utimes(char __user *filename, struct compat_timeval __user *t)

--
