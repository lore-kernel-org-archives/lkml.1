Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYA0CT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYA0CT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbYA0CR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:26 -0500
Received: from mx1.suse.de ([195.135.220.2]:54382 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448AbYA0CRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:22 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [14/18] BKL-removal: Add unlocked_fasync
Message-Id: <20080127021721.08AEA14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new fops entry point to allow fasync without BKL. While it's arguably
unclear this entry point is called often enough for it really matters
it was still relatively easy to do. And there are far less async users
in the tree than ioctls so it's likely they can be all converted 
eventually and then the non unlocked async entry point could be dropped.

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
@@ -240,11 +240,15 @@ static int setfl(int fd, struct file * f
 
 	lock_kernel();
 	if ((arg ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
+		if (filp->f_op && filp->f_op->unlocked_fasync)
+			error = filp->f_op->unlocked_fasync(fd, filp,
+					!!(arg & FASYNC));
+		else if (filp->f_op && filp->f_op->fasync) {
 			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
 			if (error < 0)
 				goto out;
 		}
+		/* AK: no else error = -EINVAL here? */
 	}
 
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c
+++ linux/fs/ioctl.c
@@ -118,7 +118,10 @@ int vfs_ioctl(struct file *filp, unsigne
 
 			/* Did FASYNC state change ? */
 			if ((flag ^ filp->f_flags) & FASYNC) {
-				if (filp->f_op && filp->f_op->fasync) {
+				if (filp->f_op && filp->f_op->unlocked_fasync)
+					error = filp->f_op->unlocked_fasync(fd,
+							filp, on);
+				else if (filp->f_op && filp->f_op->fasync) {
 					lock_kernel();
 					error = filp->f_op->fasync(fd, filp, on);
 					unlock_kernel();
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
