Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYGANCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYGANCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYGANB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:01:59 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44033 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbYGANB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:01:57 -0400
Message-Id: <20080701130152.476828745@szeredi.hu>
References: <20080701130125.529844715@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 01 Jul 2008 15:01:27 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       Ulrich Drepper <drepper@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [patch 2/4] vfs: utimes cleanup
Content-Disposition: inline; filename=vfs-utimes-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Untange the mess that is do_utimes().  Add kerneldoc comment to
do_utimes().

CC: Ulrich Drepper <drepper@redhat.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/utimes.c |  114 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 65 insertions(+), 49 deletions(-)

Index: linux/fs/utimes.c
===================================================================
--- linux.orig/fs/utimes.c	2008-06-13 11:35:24.000000000 +0200
+++ linux/fs/utimes.c	2008-06-13 11:49:37.000000000 +0200
@@ -48,54 +48,15 @@ static bool nsec_valid(long nsec)
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
+	struct inode *inode = path->dentry->d_inode;
 
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
+	error = mnt_want_write(path->mnt);
 	if (error)
-		goto dput_and_out;
+		goto out;
 
 	if (times && times[0].tv_nsec == UTIME_NOW &&
 		     times[1].tv_nsec == UTIME_NOW)
@@ -145,15 +106,70 @@ long do_utimes(int dfd, char __user *fil
 		}
 	}
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, &newattrs);
+	error = notify_change(path->dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
+
 mnt_drop_write_and_out:
-	mnt_drop_write(mnt);
-dput_and_out:
-	if (f)
-		fput(f);
-	else
+	mnt_drop_write(path->mnt);
+out:
+	return error;
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
+long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
+{
+	int error = -EINVAL;
+
+	if (times && (!nsec_valid(times[0].tv_nsec) ||
+		      !nsec_valid(times[1].tv_nsec))) {
+		goto out;
+	}
+
+	if (flags & ~AT_SYMLINK_NOFOLLOW)
+		goto out;
+
+	if (filename == NULL && dfd != AT_FDCWD) {
+		struct file *file;
+
+		if (flags & AT_SYMLINK_NOFOLLOW)
+			goto out;
+
+		file = fget(dfd);
+		error = -EBADF;
+		if (!file)
+			goto out;
+
+		error = utimes_common(&file->f_path, times);
+		fput(file);
+	} else {
+		struct nameidata nd;
+		int lookup_flags = 0;
+
+		if (!(flags & AT_SYMLINK_NOFOLLOW))
+			lookup_flags |= LOOKUP_FOLLOW;
+
+		error = __user_walk_fd(dfd, filename, lookup_flags, &nd);
+		if (error)
+			goto out;
+
+		error = utimes_common(&nd.path, times);
 		path_put(&nd.path);
+	}
+
 out:
 	return error;
 }

--
