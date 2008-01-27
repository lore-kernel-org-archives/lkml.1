Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbYA0CTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbYA0CTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYA0CRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:54486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbYA0CRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: shaggy@austin.ibm.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [10/18] BKL-removal: Implement a compat_ioctl handler for JFS
Message-Id: <20080127021716.BE0B714D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ioctls were already compatible except for the actual values so this
was fairly easy to do.

Cc: shaggy@austin.ibm.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/jfs/file.c       |    3 +++
 fs/jfs/ioctl.c      |   18 ++++++++++++++++++
 fs/jfs/jfs_dinode.h |    2 ++
 fs/jfs/jfs_inode.h  |    1 +
 fs/jfs/namei.c      |    3 +++
 5 files changed, 27 insertions(+)

Index: linux/fs/jfs/file.c
===================================================================
--- linux.orig/fs/jfs/file.c
+++ linux/fs/jfs/file.c
@@ -113,4 +113,7 @@ const struct file_operations jfs_file_op
 	.fsync		= jfs_fsync,
 	.release	= jfs_release,
 	.unlocked_ioctl = jfs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= jfs_compat_ioctl,
+#endif
 };
Index: linux/fs/jfs/ioctl.c
===================================================================
--- linux.orig/fs/jfs/ioctl.c
+++ linux/fs/jfs/ioctl.c
@@ -117,3 +117,21 @@ long jfs_ioctl(struct file *filp, unsign
 	}
 }
 
+#ifdef CONFIG_COMPAT
+long jfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	/* While these ioctl numbers defined with 'long' and have different
+	 * numbers than the 64bit ABI,
+	 * the actual implementation only deals with ints and is compatible.
+	 */
+	switch (cmd) {
+	case JFS_IOC_GETFLAGS32:
+		cmd = JFS_IOC_GETFLAGS;
+		break;
+	case JFS_IOC_SETFLAGS32:
+		cmd = JFS_IOC_SETFLAGS;
+		break;
+	}
+	return jfs_ioctl(filp, cmd, arg);
+}
+#endif
Index: linux/fs/jfs/jfs_inode.h
===================================================================
--- linux.orig/fs/jfs/jfs_inode.h
+++ linux/fs/jfs/jfs_inode.h
@@ -23,6 +23,7 @@ struct fid;
 extern struct inode *ialloc(struct inode *, umode_t);
 extern int jfs_fsync(struct file *, struct dentry *, int);
 extern long jfs_ioctl(struct file *, unsigned int, unsigned long);
+extern long jfs_compat_ioctl(struct file *, unsigned int, unsigned long);
 extern void jfs_read_inode(struct inode *);
 extern int jfs_commit_inode(struct inode *, int);
 extern int jfs_write_inode(struct inode*, int);
Index: linux/fs/jfs/namei.c
===================================================================
--- linux.orig/fs/jfs/namei.c
+++ linux/fs/jfs/namei.c
@@ -1563,6 +1563,9 @@ const struct file_operations jfs_dir_ope
 	.readdir	= jfs_readdir,
 	.fsync		= jfs_fsync,
 	.unlocked_ioctl = jfs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= jfs_compat_ioctl,
+#endif
 };
 
 static int jfs_ci_hash(struct dentry *dir, struct qstr *this)
Index: linux/fs/jfs/jfs_dinode.h
===================================================================
--- linux.orig/fs/jfs/jfs_dinode.h
+++ linux/fs/jfs/jfs_dinode.h
@@ -170,5 +170,7 @@ struct dinode {
 #define JFS_IOC_GETFLAGS	_IOR('f', 1, long)
 #define JFS_IOC_SETFLAGS	_IOW('f', 2, long)
 
+#define JFS_IOC_GETFLAGS32	_IOR('f', 1, int)
+#define JFS_IOC_SETFLAGS32	_IOW('f', 2, int)
 
 #endif /*_H_JFS_DINODE */
