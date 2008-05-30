Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYE3PfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYE3PfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYE3Pe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:34:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:42108 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYE3Pez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=AkAP/avc8nwQJwllMj8t6DDJO8FBAxepjRyT5jHjHNWa1qVp4OpRHMj/RslqSsCvp7E7gFeuM7nBc7RlPmlQbZNnGSrIesSemXmI+ZtpNSsw1sDI8DRKOYy7RpN+y1VlO4UqMiCXoiQjgb1VgUcUNAsSPrbgSKzBXQz6/+5hRyo=
Message-ID: <48401E7E.9090304@gmail.com>
Date: Fri, 30 May 2008 17:34:22 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: drepper@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] utimensat() non-conformances and fixes [v3]
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Here's a further version of the patch, against 2.6.26rc2, with the
2008-05-19 git changes you sent me applied.  This patch is based on
the draft patch you sent me.  I've tested this version of the patch,
and it works as for all cases except the one mentioned below.  But
note the following points:

1) I didn't make use of the code in notify_change() that checks
IS_IMMUTABLE() and IS_APPEND() (i.e., I did not add
ATTR_OWNER_CHECK to the mask in the controlling if statement).
Doing this can't easily be made to work for the
do_futimes() case without reworking the arguments passed to
notify_change().  Actually, I'm inclined to doubt whether it
is a good idea to try to roll that check into notify_change() --
at least for utimensat() it seems simpler to not do so.

2) I've found yet another divergence from the spec -- but this
was in the original implementation, rather than being
something that has been introduced.  In do_futimes() there is

        if (!times && !(file->f_mode & FMODE_WRITE))
                write_error = -EACCES;

However, the check here should not be against the f_mode (file access
mode), but the against actual permission of the file referred to by
the underlying descriptor.  This means that for the do_futimes() +
times==NULL case, a set-user-ID root program could open a file
descriptor O_RDWR/O_WRONLY for which the real UID does not have write
access, and then even after reverting the the effective UID, the real
user could still update file.

I'm not sure of the correct way to get the required nameidata (to do a
vfs_permission() call) from the file descriptor.  Can you give me a
tip there?

Cheers,

Michael

--- linux-2.6.26-rc2-miklos.git-080519/fs/utimes.c	2008-05-19 17:40:37.000000000 +0200
+++ linux-2.6.26-rc2-miklos.git-080519-utimensat-fix-v3/fs/utimes.c	2008-05-30 16:29:00.000000000 +0200
@@ -53,14 +53,19 @@
 	return nsec >= 0 && nsec <= 999999999;
 }

-static int utimes_common(struct path *path, struct timespec *times)
+static int utimes_common(struct path *path, struct timespec *times,
+			 int write_error)
 {
 	int error;
 	struct iattr newattrs;
+	struct inode *inode = path->dentry->d_inode;

 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
+		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+			return -EPERM;
+
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
 		else if (times[0].tv_nsec != UTIME_NOW) {
@@ -76,7 +81,15 @@
 			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
+		newattrs.ia_valid |= ATTR_OWNER_CHECK;
+	} else {
+                if (IS_IMMUTABLE(inode))
+			return -EACCES;
+
+		if (write_error)
+			newattrs.ia_valid |= ATTR_OWNER_CHECK;
 	}
+
 	mutex_lock(&path->dentry->d_inode->i_mutex);
 	error = mnt_want_write(path->mnt);
 	if (!error) {
@@ -85,37 +98,26 @@
 	}
 	mutex_unlock(&path->dentry->d_inode->i_mutex);

-	return error;
-}
+	if (write_error && error)
+		error = write_error;

-/*
- * If times is NULL or both times are either UTIME_OMIT or UTIME_NOW, then
- * need to check permissions, because inode_change_ok() won't do it.
- */
-static bool utimes_need_permission(struct timespec *times)
-{
-	return !times || (nsec_special(times[0].tv_nsec) &&
-			  nsec_special(times[1].tv_nsec));
+	return error;
 }

 static int do_futimes(int fd, struct timespec *times)
 {
 	int error;
+	int write_error = 0;
 	struct file *file = fget(fd);

 	if (!file)
 		return -EBADF;

-	if (utimes_need_permission(times)) {
-		struct inode *inode = file->f_path.dentry->d_inode;
+	if (!times && !(file->f_mode & FMODE_WRITE))
+		write_error = -EACCES;

-		error = -EACCES;
-		if (!is_owner_or_cap(inode) && !(file->f_mode & FMODE_WRITE))
-			goto out_fput;
-	}
-	error = utimes_common(&file->f_path, times);
+	error = utimes_common(&file->f_path, times, write_error);

- out_fput:
 	fput(file);

 	return error;
@@ -125,6 +127,7 @@
 			  struct timespec *times, int flags)
 {
 	int error;
+	int write_error = 0;
 	struct nameidata nd;
 	int lookup_flags;

@@ -136,23 +139,10 @@
 	if (error)
 		return error;

+	if (!times)
+		write_error = vfs_permission(&nd, MAY_WRITE);

-	if (utimes_need_permission(times)) {
-		struct inode *inode = nd.path.dentry->d_inode;
-
-		error = -EACCES;
-		if (IS_IMMUTABLE(inode))
-			goto out_path_put;
-
-		if (!is_owner_or_cap(inode)) {
-			error = vfs_permission(&nd, MAY_WRITE);
-			if (error)
-				goto out_path_put;
-		}
-	}
-	error = utimes_common(&nd.path, times);
-
- out_path_put:
+	error = utimes_common(&nd.path, times, write_error);
 	path_put(&nd.path);

 	return error;
@@ -181,6 +171,10 @@
 		return -EINVAL;
 	}

+	if (times && times[0].tv_nsec == UTIME_NOW &&
+		     times[1].tv_nsec == UTIME_NOW)
+		times = NULL;
+
 	if (filename == NULL && dfd != AT_FDCWD) {
 		if (flags)
 			return -EINVAL;
--- linux-2.6.26-rc2-miklos.git-080519/fs/attr.c	2008-05-19 17:40:37.000000000 +0200
+++ linux-2.6.26-rc2-miklos.git-080519-utimensat-fix-v3/fs/attr.c	2008-05-30 15:33:21.000000000 +0200
@@ -51,7 +51,8 @@
 	}

 	/* Check for setting the inode time. */
-	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
+	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET |
+			ATTR_OWNER_CHECK)) {
 		if (!is_owner_or_cap(inode))
 			goto error;
 	}
--- linux-2.6.26-rc2-miklos.git-080519/include/linux/fs.h	2008-05-19 17:40:37.000000000 +0200
+++ linux-2.6.26-rc2-miklos.git-080519-utimensat-fix-v3/include/linux/fs.h	2008-05-29 07:08:50.000000000 +0200
@@ -317,22 +317,23 @@
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
  */
-#define ATTR_MODE	1
-#define ATTR_UID	2
-#define ATTR_GID	4
-#define ATTR_SIZE	8
-#define ATTR_ATIME	16
-#define ATTR_MTIME	32
-#define ATTR_CTIME	64
-#define ATTR_ATIME_SET	128
-#define ATTR_MTIME_SET	256
-#define ATTR_FORCE	512	/* Not a change, but a change it */
-#define ATTR_ATTR_FLAG	1024
-#define ATTR_KILL_SUID	2048
-#define ATTR_KILL_SGID	4096
-#define ATTR_FILE	8192
-#define ATTR_KILL_PRIV	16384
-#define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
+#define ATTR_MODE	    (1 << 0)
+#define ATTR_UID	    (1 << 1)
+#define ATTR_GID	    (1 << 2)
+#define ATTR_SIZE	    (1 << 3)
+#define ATTR_ATIME	    (1 << 4)
+#define ATTR_MTIME	    (1 << 5)
+#define ATTR_CTIME	    (1 << 6)
+#define ATTR_ATIME_SET	    (1 << 7)
+#define ATTR_MTIME_SET	    (1 << 8)
+#define ATTR_FORCE	    (1 << 9)	/* Not a change, but a change it */
+#define ATTR_ATTR_FLAG	    (1 << 10)
+#define ATTR_KILL_SUID	    (1 << 11)
+#define ATTR_KILL_SGID	    (1 << 12)
+#define ATTR_FILE	    (1 << 13)
+#define ATTR_KILL_PRIV	    (1 << 14)
+#define ATTR_OPEN	    (1 << 15)	/* Truncating from open(O_TRUNC) */
+#define ATTR_OWNER_CHECK    (1 << 16)

 /*
  * This is the Inode Attributes structure, used for notify_change().  It


