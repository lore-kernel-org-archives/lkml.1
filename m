Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYA0QcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYA0QcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYA0QcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:32:00 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:35309 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYA0Qb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:31:59 -0500
Date: Sun, 27 Jan 2008 17:31:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] [14/18] BKL-removal: Add unlocked_fasync v2
Message-ID: <20080127163140.GB28796@basil.nowhere.org>
References: <9Q5hR-3MI-9@gated-at.bofh.it> <9Q5rE-3ZD-17@gated-at.bofh.it> <E1JJ5TR-0003VJ-3U@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JJ5TR-0003VJ-3U@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Jan 2008 16:25:24.0533 (UTC) FILETIME=[382C0650:01C86101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No goto if you use unlocked_fasync?

Indeed. There was another problem in the patch too. Here's an updated
patch that also fixes another latent bug.

The whole f_flags still seems to be somewhat fragile because
the checks tend to happen without any lock, but that has not
changed to the previous state.

---

Add unlocked_fasync v2

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

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/filesystems/vfs.txt |    5 ++++-
 fs/fcntl.c                        |    6 +++++-
 fs/ioctl.c                        |    5 ++++-
 include/linux/fs.h                |    1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

Index: linux/fs/fcntl.c
===================================================================
--- linux.orig/fs/fcntl.c
+++ linux/fs/fcntl.c
@@ -238,18 +238,26 @@ static int setfl(int fd, struct file * f
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
@@ -105,10 +105,14 @@ int vfs_ioctl(struct file *filp, unsigne
 			if(O_NONBLOCK != O_NDELAY)
 				flag |= O_NDELAY;
 #endif
+
+			mutex_lock(&filp->f_dentry->d_inode->i_mutex);
 			if (on)
 				filp->f_flags |= flag;
 			else
 				filp->f_flags &= ~flag;
+
+			mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
 			break;
 
 		case FIOASYNC:
@@ -117,8 +121,13 @@ int vfs_ioctl(struct file *filp, unsigne
 			flag = on ? FASYNC : 0;
 
 			/* Did FASYNC state change ? */
+			/* AK: potential race here: ->fasync could be called with on two times
+			   in a row. We hope the drivers deal with it. */
 			if ((flag ^ filp->f_flags) & FASYNC) {
-				if (filp->f_op && filp->f_op->fasync) {
+				if (filp->f_op && filp->f_op->unlocked_fasync)
+					error = filp->f_op->unlocked_fasync(fd,
+							filp, on);
+				else if (filp->f_op && filp->f_op->fasync) {
 					lock_kernel();
 					error = filp->f_op->fasync(fd, filp, on);
 					unlock_kernel();
@@ -128,10 +137,12 @@ int vfs_ioctl(struct file *filp, unsigne
 			if (error != 0)
 				break;
 
+			mutex_lock(&filp->f_dentry->d_inode->i_mutex);
 			if (on)
 				filp->f_flags |= FASYNC;
 			else
 				filp->f_flags &= ~FASYNC;
+			mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
 			break;
 
 		case FIOQSIZE:
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -1179,6 +1179,7 @@ struct file_operations {
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
@@ -769,6 +769,7 @@ struct file_operations {
 	int (*fsync) (struct file *, struct dentry *, int datasync);
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
+	int (*unlocked_fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
 	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long, loff_t *);
 	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long, loff_t *);
@@ -828,7 +829,9 @@ otherwise noted.
   fsync: called by the fsync(2) system call
 
   fasync: called by the fcntl(2) system call when asynchronous
-	(non-blocking) mode is enabled for a file
+	(non-blocking) mode is enabled for a file. BKL hold
+
+  unlocked_fasync: like fasync, but without BKL
 
   lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
   	commands
