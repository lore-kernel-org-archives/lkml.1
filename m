Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYA0CWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYA0CWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYA0CSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:18:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:54368 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbYA0CRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:19 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: mark.fasheh@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [11/18] BKL-removal: Convert ocfs2 over to unlocked_ioctl
Message-Id: <20080127021717.CE2C715044@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As far as I can see there is nothing in ocfs2_ioctl that requires the BKL,
so use unlocked_ioctl

Cc: mark.fasheh@oracle.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ocfs2/file.c  |    4 ++--
 fs/ocfs2/ioctl.c |   12 +++---------
 fs/ocfs2/ioctl.h |    3 +--
 3 files changed, 6 insertions(+), 13 deletions(-)

Index: linux/fs/ocfs2/ioctl.c
===================================================================
--- linux.orig/fs/ocfs2/ioctl.c
+++ linux/fs/ocfs2/ioctl.c
@@ -111,9 +111,9 @@ bail:
 	return status;
 }
 
-int ocfs2_ioctl(struct inode * inode, struct file * filp,
-	unsigned int cmd, unsigned long arg)
+long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int flags;
 	int status;
 	struct ocfs2_space_resv sr;
@@ -148,9 +148,6 @@ int ocfs2_ioctl(struct inode * inode, st
 #ifdef CONFIG_COMPAT
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	switch (cmd) {
 	case OCFS2_IOC32_GETFLAGS:
 		cmd = OCFS2_IOC_GETFLAGS;
@@ -167,9 +164,6 @@ long ocfs2_compat_ioctl(struct file *fil
 		return -ENOIOCTLCMD;
 	}
 
-	lock_kernel();
-	ret = ocfs2_ioctl(inode, file, cmd, arg);
-	unlock_kernel();
-	return ret;
+	return ocfs2_ioctl(file, cmd, arg);
 }
 #endif
Index: linux/fs/ocfs2/ioctl.h
===================================================================
--- linux.orig/fs/ocfs2/ioctl.h
+++ linux/fs/ocfs2/ioctl.h
@@ -10,8 +10,7 @@
 #ifndef OCFS2_IOCTL_H
 #define OCFS2_IOCTL_H
 
-int ocfs2_ioctl(struct inode * inode, struct file * filp,
-	unsigned int cmd, unsigned long arg);
+long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
 #endif /* OCFS2_IOCTL_H */
Index: linux/fs/ocfs2/file.c
===================================================================
--- linux.orig/fs/ocfs2/file.c
+++ linux/fs/ocfs2/file.c
@@ -2212,7 +2212,7 @@ const struct file_operations ocfs2_fops 
 	.open		= ocfs2_file_open,
 	.aio_read	= ocfs2_file_aio_read,
 	.aio_write	= ocfs2_file_aio_write,
-	.ioctl		= ocfs2_ioctl,
+	.unlocked_ioctl = ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
@@ -2224,7 +2224,7 @@ const struct file_operations ocfs2_dops 
 	.read		= generic_read_dir,
 	.readdir	= ocfs2_readdir,
 	.fsync		= ocfs2_sync_file,
-	.ioctl		= ocfs2_ioctl,
+	.unlocked_ioctl = ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
