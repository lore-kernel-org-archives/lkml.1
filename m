Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYESKNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYESKNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 06:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYESKM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 06:12:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50422 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYESKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 06:12:55 -0400
To: mtk.manpages@googlemail.com
CC: drepper@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <E1Jy20a-0007pv-Ij@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 19 May 2008 11:50:20 +0200)
Subject: Re: [PATCH] utimensat() non-conformances and fixes -- version 2
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <482F38A1.9070704@gmail.com> <E1Jy20a-0007pv-Ij@pomaz-ex.szeredi.hu>
Message-Id: <E1Jy2M9-0007sC-EK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 May 2008 12:12:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not only fragile, it's ugly as sin.  I'd rather do it this way:
> 
> - initialize error to zero
> - if no write access then set error, and the ATTR_TIMES_UPDATE(*) flag
> - set error2 from result of notify_change()
> - if error is zero then return error2, otherwise return error

Something like this (haven't thought it through, totally untested,
etc...)

Miklos

---
 fs/utimes.c |   48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-17 08:50:01.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-19 12:08:18.000000000 +0200
@@ -53,7 +53,8 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-static int utimes_common(struct path *path, struct timespec *times)
+static int utimes_common(struct path *path, struct timespec *times,
+			 int write_error)
 {
 	int error;
 	struct iattr newattrs;
@@ -76,11 +77,18 @@ static int utimes_common(struct path *pa
 			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
+		newattrs.ia_valid |= ATTR_OWNER_CHECK;
+	} else if (write_error) {
+		newattrs.ia_valid |= ATTR_OWNER_CHECK;
 	}
+
 	mutex_lock(&path->dentry->d_inode->i_mutex);
 	error = path_setattr(path, &newattrs);
 	mutex_unlock(&path->dentry->d_inode->i_mutex);
 
+	if (write_error && error)
+		error = write_error;
+
 	return error;
 }
 
@@ -97,21 +105,16 @@ static bool utimes_need_permission(struc
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
-
- out_fput:
+	error = utimes_common(&file->f_path, times, write_error);
 	fput(file);
 
 	return error;
@@ -121,6 +124,7 @@ static int do_utimes_name(int dfd, char 
 			  struct timespec *times, int flags)
 {
 	int error;
+	int write_error = 0;
 	struct nameidata nd;
 	int lookup_flags;
 
@@ -132,23 +136,10 @@ static int do_utimes_name(int dfd, char 
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
@@ -177,6 +168,11 @@ int do_utimes(int dfd, char __user *file
 		return -EINVAL;
 	}
 
+	if (times && times[0].tv_nsec == UTIME_NOW &&
+	    times[1].tv_nsec == UTIME_NOW) {
+		times = NULL;
+	}
+
 	if (filename == NULL && dfd != AT_FDCWD) {
 		if (flags)
 			return -EINVAL;

