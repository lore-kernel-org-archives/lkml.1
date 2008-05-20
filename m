Return-Path: <linux-kernel-owner+w=401wt.eu-S933981AbYETPdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981AbYETPdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbYETPac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:32 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35658 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbYETPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/11] Add unlocked_fasync
Message-Id: <20080520152843.CF4181B4205@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:43 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:42.0965 (UTC) FILETIME=[356E8650:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new fops entry point to allow fasync without BKL. While it's arguably
unclear this entry point is called often enough for it really matters
it was still relatively easy to do. And there are far less async users
in the tree than ioctls so it's likely they can be all converted 
eventually and then the non unlocked async entry point could be dropped.

There was still the problem of the actual flags change being
protected against other setters of flags. Instead of using BKL
for this use the i_mutex now.

I also added a mutex_lock against one other flags change
that was lockless and could potentially lose updates.

There are a couple of potential problems I added comments about on.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/filesystems/vfs.txt |    5 ++++-
 fs/fcntl.c                        |   22 +++++++++++++++-------
 fs/ioctl.c                        |   13 ++++++++++++-
 include/linux/fs.h                |    1 +
 4 files changed, 32 insertions(+), 9 deletions(-)

Index: linux/fs/fcntl.c
===================================================================
--- linux.orig/fs/fcntl.c
+++ linux/fs/fcntl.c
@@ -227,18 +227,26 @@ static int setfl(int fd, struct file * f
 	if (error)
 		return error;
 
-	lock_kernel();
+	/* AK: potential race here. Since test is unlocked fasync could
+	   be called several times in a row with on. We hope the drivers
+	   deal with it. */
 	if ((arg ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
-			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
-			if (error < 0)
-				goto out;
+		int on = !!(arg & FASYNC);
+		if (filp->f_op && filp->f_op->unlocked_fasync)
+			error = filp->f_op->unlocked_fasync(fd, filp, on);
+		else if (filp->f_op && filp->f_op->fasync) {
+			lock_kernel();
+			error = filp->f_op->fasync(fd, filp, on);
+			unlock_kernel();
 		}
+		/* AK: no else error = -EINVAL here? */
+		if (error < 0)
+			return error;
 	}
 
+	mutex_lock(&filp->f_dentry->d_inode->i_mutex);
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
- out:
-	unlock_kernel();
+	mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
 	return error;
 }
 
Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c
+++ linux/fs/ioctl.c
@@ -103,10 +103,13 @@ static int ioctl_fionbio(struct file *fi
 	if (O_NONBLOCK != O_NDELAY)
 		flag |= O_NDELAY;
 #endif
+	/* Protect f_flags */
+	mutex_lock(&filp->f_dentry->d_inode->i_mutex);
 	if (on)
 		filp->f_flags |= flag;
 	else
 		filp->f_flags &= ~flag;
+	mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
 	return error;
 }
 
@@ -122,8 +125,13 @@ static int ioctl_fioasync(unsigned int f
 	flag = on ? FASYNC : 0;
 
 	/* Did FASYNC state change ? */
+	/* AK: potential race here: ->fasync could be called with on two times
+	   in a row. We hope the drivers deal with it. */
 	if ((flag ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
+		if (filp->f_op && filp->f_op->unlocked_fasync) {
+			error = filp->f_op->unlocked_fasync(fd,
+							    filp, on);
+		} else if (filp->f_op && filp->f_op->fasync) {
 			lock_kernel();
 			error = filp->f_op->fasync(fd, filp, on);
 			unlock_kernel();
@@ -133,10 +141,13 @@ static int ioctl_fioasync(unsigned int f
 	if (error)
 		return error;
 
+	/* Protect f_flags */
+	mutex_lock(&filp->f_dentry->d_inode->i_mutex);
 	if (on)
 		filp->f_flags |= FASYNC;
 	else
 		filp->f_flags &= ~FASYNC;
+	mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
 	return error;
 }
 
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -1237,6 +1237,7 @@ struct file_operations {
 	int (*fsync) (struct file *, struct dentry *, int datasync);
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
+	int (*unlocked_fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
Index: linux/Documentation/filesystems/vfs.txt
===================================================================
--- linux.orig/Documentation/filesystems/vfs.txt
+++ linux/Documentation/filesystems/vfs.txt
@@ -755,6 +755,7 @@ struct file_operations {
 	int (*fsync) (struct file *, struct dentry *, int datasync);
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
+	int (*unlocked_fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
 	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long, loff_t *);
 	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long, loff_t *);
@@ -814,7 +815,9 @@ otherwise noted.
   fsync: called by the fsync(2) system call
 
   fasync: called by the fcntl(2) system call when asynchronous
-	(non-blocking) mode is enabled for a file
+	(non-blocking) mode is enabled for a file. BKL hold
+
+  unlocked_fasync: like fasync, but without BKL
 
   lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
   	commands
