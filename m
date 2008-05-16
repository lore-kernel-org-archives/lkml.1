Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbYEPQgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbYEPQgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYEPQcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33739 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbYEPQco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:44 -0400
Message-Id: <20080516163230.419112635@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:48 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: [patch 12/22] vfs: utimes cleanup
Content-Disposition: inline; filename=utimes_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Untange the mess that is do_utimes()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Ulrich Drepper <drepper@redhat.com>
---
 fs/utimes.c          |  179 ++++++++++++++++++++++++++++++---------------------
 include/linux/time.h |    3 
 2 files changed, 108 insertions(+), 74 deletions(-)

Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-16 17:50:47.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-16 17:50:47.000000000 +0200
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
@@ -121,41 +77,118 @@ long do_utimes(int dfd, char __user *fil
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
+static int do_utimes_name(int dfd, char __user *filename,
+			  struct timespec *times, int flags)
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
+ * do_utimes - change times on filename or file descriptor
+ * @dfd: open file descriptor, -1 or AT_FDCWD
+ * @filename: path name or NULL
+ * @times: new times or NULL
+ * @flags: zero or more flags (only AT_SYMLINK_NOFOLLOW for the moment)
+ *
+ * If filename is NULL and dfd refers to an open file, then operate on
+ * the file.  Otherwise look up filename, possibly using dfd as a
+ * starting point.
+ *
+ * If times==NULL, set access and modification to current time,
+ * must be owner or have write permission.
+ * Else, update from *times, must be owner or super user.
+ */
+int do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
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
+		return do_utimes_name(dfd, filename, times, flags);
+	}
 }
 
 asmlinkage long sys_utimensat(int dfd, char __user *filename, struct timespec __user *utimes, int flags)
Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h	2008-05-16 17:50:35.000000000 +0200
+++ linux-2.6/include/linux/time.h	2008-05-16 17:50:47.000000000 +0200
@@ -109,7 +109,8 @@ extern void do_gettimeofday(struct timev
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags);
+extern int do_utimes(int dfd, char __user *filename, struct timespec *times,
+		     int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);

--
