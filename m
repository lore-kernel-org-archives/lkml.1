Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbYESNV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbYESNV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759981AbYESNRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:48 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45072 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957AbYESNRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:43 -0400
To: mtk.manpages@googlemail.com
CC: miklos@szeredi.hu, drepper@redhat.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <cfd18e0f0805190524w7d0e5a47s42cb2c469c26a262@mail.gmail.com>
	(mtk.manpages@googlemail.com)
Subject: Re: [PATCH] utimensat() non-conformances and fixes -- version 2
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <482F38A1.9070704@gmail.com>
	 <E1Jy20a-0007pv-Ij@pomaz-ex.szeredi.hu> <cfd18e0f0805190524w7d0e5a47s42cb2c469c26a262@mail.gmail.com>
Message-Id: <E1Jy5Eu-0008DJ-OK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 May 2008 15:17:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also could you do the patch against the
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-cleanups
> >
> > tree, which does big structural cleanups to do_utimes?
> 
> You keep moving the goalposts here...  First, it was provide an
> obvious correct fix (for the non-conformances); then: can you cleanup
> the owner checks;

Sorry, that was just an idea, but since it's not as simple as it
should be, I guess we should leave that till later.  My main objection
was against introducing more is_owner_or_cap() checks.  Just doing the
times == NULL case with ATTR_OWNER_CHECK should be fine.

That reminds me, one more comment about the patch: if you are
reindenting the ATTR_* definitions anyway, why not also change them to
the cleaner (1 << N) format?

>  then: can you rewrite against my git tree...  My
> time at the moment is fairly limited, and I have a problem: currently,
> I'm not a git user.  That'll change soon, but I don't have the time to
> change it now.  Can I just download a snapshot tarball of your git
> changes somehwere?  Alternatively, when do you expect your changes to
> make it into an rc?

Here's the relevant part (dfe9b50d..aeb1fe4b) of that tree as a single
patch.  I hope it compiles.

Thanks,
Miklos



diff --git a/fs/attr.c b/fs/attr.c
index 966b73e..e8bd11b 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -108,6 +108,12 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
+			ATTR_ATIME_SET | ATTR_MTIME_SET)) {
+		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+			return -EPERM;
+	}
+
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
diff --git a/fs/exec.c b/fs/exec.c
index 1f8a24a..b68682a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1763,7 +1763,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		goto close_fail;
 	if (!file->f_op->write)
 		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+	if (!ispipe && file_truncate(file, 0, 0) != 0)
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
diff --git a/fs/open.c b/fs/open.c
index a145008..bb604a6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -195,6 +195,13 @@ out:
 	return error;
 }
 
+/*
+ * do_truncate - truncate (or extend) an inode
+ * @dentry: the dentry to truncate
+ * @length: the new length
+ * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
+ * @filp: an open file or NULL (see file_truncate() as well)
+ */
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
@@ -221,6 +228,17 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	return err;
 }
 
+/*
+ * file_truncate - truncate (or extend) an open file
+ * @filp: the open file
+ * @length: the new length
+ * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
+ */
+int file_truncate(struct file *filp, loff_t length, unsigned int time_attrs)
+{
+	return do_truncate(filp->f_path.dentry, length, time_attrs, filp);
+}
+
 static long do_sys_truncate(const char __user * path, loff_t length)
 {
 	struct nameidata nd;
@@ -254,7 +272,7 @@ static long do_sys_truncate(const char __user * path, loff_t length)
 		goto mnt_drop_write_and_out;
 
 	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
 	error = get_write_access(inode);
@@ -294,7 +312,6 @@ asmlinkage long sys_truncate(const char __user * path, unsigned long length)
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
 	struct inode * inode;
-	struct dentry *dentry;
 	struct file * file;
 	int error;
 
@@ -310,8 +327,7 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = file->f_path.dentry;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
 		goto out_putf;
@@ -327,7 +343,7 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = file_truncate(file, length, ATTR_MTIME|ATTR_CTIME);
 out_putf:
 	fput(file);
 out:
@@ -582,9 +598,6 @@ asmlinkage long sys_fchmod(unsigned int fd, mode_t mode)
 	err = mnt_want_write(file->f_path.mnt);
 	if (err)
 		goto out_putf;
-	err = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -592,8 +605,6 @@ asmlinkage long sys_fchmod(unsigned int fd, mode_t mode)
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
 out_putf:
 	fput(file);
@@ -617,11 +628,6 @@ asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto dput_and_out;
-
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_drop_write;
-
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -629,8 +635,6 @@ asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-
-out_drop_write:
 	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
@@ -645,18 +649,10 @@ asmlinkage long sys_chmod(const char __user *filename, mode_t mode)
 
 static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
 {
-	struct inode * inode;
+	struct inode *inode = dentry->d_inode;
 	int error;
 	struct iattr newattrs;
 
-	error = -ENOENT;
-	if (!(inode = dentry->d_inode)) {
-		printk(KERN_ERR "chown_common: NULL inode\n");
-		goto out;
-	}
-	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out;
 	newattrs.ia_valid =  ATTR_CTIME;
 	if (user != (uid_t) -1) {
 		newattrs.ia_valid |= ATTR_UID;
@@ -672,7 +668,7 @@ static int chown_common(struct dentry * dentry, uid_t user, gid_t group)
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
-out:
+
 	return error;
 }
 
diff --git a/fs/utimes.c b/fs/utimes.c
index af059d5..cccefe4 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -53,62 +53,14 @@ static bool nsec_valid(long nsec)
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
 	if (times) {
-		error = -EPERM;
-                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto mnt_drop_write_and_out;
-
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
 		else if (times[0].tv_nsec != UTIME_NOW) {
@@ -125,41 +77,118 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
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
-                if (IS_IMMUTABLE(inode))
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f413085..5b382ca 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1600,6 +1600,8 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+extern int file_truncate(struct file *filp, loff_t start,
+			 unsigned int time_attrs);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
diff --git a/include/linux/time.h b/include/linux/time.h
index d32ef0a..d757ffc 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -109,7 +109,8 @@ extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags);
+extern int do_utimes(int dfd, char __user *filename, struct timespec *times,
+		     int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
diff --git a/mm/tiny-shmem.c b/mm/tiny-shmem.c
index ae532f5..65226ce 100644
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -80,7 +80,7 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
+	error = file_truncate(file, size, 0);
 	if (error < 0)
 		goto close_file;
 
