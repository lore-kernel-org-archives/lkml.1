Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbYA0CVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbYA0CVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYA0CRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:54358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbYA0CRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:17 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: shaggy@austin.ibm.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [9/18] BKL-removal: Use unlocked_ioctl for jfs
Message-Id: <20080127021715.B24FE14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert jfs_ioctl over to not use the BKL. The only potential race
I could see was with two ioctls in parallel changing the flags
and losing the updates. Use the i_mutex to protect against this.

Cc: shaggy@austin.ibm.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/jfs/file.c      |    2 +-
 fs/jfs/ioctl.c     |   13 ++++++++++---
 fs/jfs/jfs_inode.h |    3 +--
 fs/jfs/namei.c     |    2 +-
 4 files changed, 13 insertions(+), 7 deletions(-)

Index: linux/fs/jfs/ioctl.c
===================================================================
--- linux.orig/fs/jfs/ioctl.c
+++ linux/fs/jfs/ioctl.c
@@ -51,9 +51,9 @@ static long jfs_map_ext2(unsigned long f
 }
 
 
-int jfs_ioctl(struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct jfs_inode_info *jfs_inode = JFS_IP(inode);
 	unsigned int flags;
 
@@ -82,6 +82,10 @@ int jfs_ioctl(struct inode * inode, stru
 		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode))
 			return -EPERM;
+
+		/* Lock against other parallel changes of flags */
+		mutex_lock(&inode->i_mutex);
+
 		jfs_get_inode_flags(jfs_inode);
 		oldflags = jfs_inode->mode2;
 
@@ -92,8 +96,10 @@ int jfs_ioctl(struct inode * inode, stru
 		if ((oldflags & JFS_IMMUTABLE_FL) ||
 			((flags ^ oldflags) &
 			(JFS_APPEND_FL | JFS_IMMUTABLE_FL))) {
-			if (!capable(CAP_LINUX_IMMUTABLE))
+			if (!capable(CAP_LINUX_IMMUTABLE)) {
+				mutex_unlock(&inode->i_mutex);
 				return -EPERM;
+			}
 		}
 
 		flags = flags & JFS_FL_USER_MODIFIABLE;
@@ -101,6 +107,7 @@ int jfs_ioctl(struct inode * inode, stru
 		jfs_inode->mode2 = flags;
 
 		jfs_set_inode_flags(inode);
+		mutex_unlock(&inode->i_mutex);
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
 		return 0;
Index: linux/fs/jfs/file.c
===================================================================
--- linux.orig/fs/jfs/file.c
+++ linux/fs/jfs/file.c
@@ -112,5 +112,5 @@ const struct file_operations jfs_file_op
 	.splice_write	= generic_file_splice_write,
 	.fsync		= jfs_fsync,
 	.release	= jfs_release,
-	.ioctl		= jfs_ioctl,
+	.unlocked_ioctl = jfs_ioctl,
 };
Index: linux/fs/jfs/jfs_inode.h
===================================================================
--- linux.orig/fs/jfs/jfs_inode.h
+++ linux/fs/jfs/jfs_inode.h
@@ -22,8 +22,7 @@ struct fid;
 
 extern struct inode *ialloc(struct inode *, umode_t);
 extern int jfs_fsync(struct file *, struct dentry *, int);
-extern int jfs_ioctl(struct inode *, struct file *,
-			unsigned int, unsigned long);
+extern long jfs_ioctl(struct file *, unsigned int, unsigned long);
 extern void jfs_read_inode(struct inode *);
 extern int jfs_commit_inode(struct inode *, int);
 extern int jfs_write_inode(struct inode*, int);
Index: linux/fs/jfs/namei.c
===================================================================
--- linux.orig/fs/jfs/namei.c
+++ linux/fs/jfs/namei.c
@@ -1562,7 +1562,7 @@ const struct file_operations jfs_dir_ope
 	.read		= generic_read_dir,
 	.readdir	= jfs_readdir,
 	.fsync		= jfs_fsync,
-	.ioctl		= jfs_ioctl,
+	.unlocked_ioctl = jfs_ioctl,
 };
 
 static int jfs_ci_hash(struct dentry *dir, struct qstr *this)
