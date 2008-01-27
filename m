Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYA0CXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYA0CXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYA0CRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:17 -0500
Received: from ns2.suse.de ([195.135.220.15]:54452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbYA0CRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:11 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [3/18] BKL-removal: Convert ext3 to use unlocked_ioctl
Message-Id: <20080127021709.55F0814D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I checked ext3_ioctl and it looked largely safe to not be used
without BKL.  So convert it over to unlocked_ioctl.

The only case where I wasn't quite sure was for the
dynamic fs grow ioctls versus umounting -- I kept the BKL for those. 

Cc: sct@redhat.com
Cc: adilger@clusterfs.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext3/dir.c           |    2 +-
 fs/ext3/file.c          |    2 +-
 fs/ext3/ioctl.c         |   21 +++++++++++----------
 include/linux/ext3_fs.h |    3 +--
 4 files changed, 14 insertions(+), 14 deletions(-)

Index: linux/fs/ext3/dir.c
===================================================================
--- linux.orig/fs/ext3/dir.c
+++ linux/fs/ext3/dir.c
@@ -42,7 +42,7 @@ const struct file_operations ext3_dir_op
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext3_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext3_ioctl,		/* BKL held */
+	.unlocked_ioctl = ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
Index: linux/fs/ext3/file.c
===================================================================
--- linux.orig/fs/ext3/file.c
+++ linux/fs/ext3/file.c
@@ -112,7 +112,7 @@ const struct file_operations ext3_file_o
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext3_file_write,
-	.ioctl		= ext3_ioctl,
+	.unlocked_ioctl = ext3_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
Index: linux/fs/ext3/ioctl.c
===================================================================
--- linux.orig/fs/ext3/ioctl.c
+++ linux/fs/ext3/ioctl.c
@@ -17,9 +17,9 @@
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
-int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext3_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -224,10 +224,14 @@ flags_err:
 		if (get_user(n_blocks_count, (__u32 __user *)arg))
 			return -EFAULT;
 
+		/* AK: not sure the BKL is needed, but this might prevent
+		 * races against umount */
+		lock_kernel();
 		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		unlock_kernel();
 
 		return err;
 	}
@@ -245,11 +249,14 @@ flags_err:
 		if (copy_from_user(&input, (struct ext3_new_group_input __user *)arg,
 				sizeof(input)))
 			return -EFAULT;
-
+		/* AK: not sure the BKL is needed, but this might prevent
+		 * races against umount */
+		lock_kernel();
 		err = ext3_group_add(sb, &input);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		unlock_kernel();
 
 		return err;
 	}
@@ -263,9 +270,6 @@ flags_err:
 #ifdef CONFIG_COMPAT
 long ext3_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT3_IOC32_GETFLAGS:
@@ -305,9 +309,6 @@ long ext3_compat_ioctl(struct file *file
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
-	ret = ext3_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
-	return ret;
+	return ext3_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
Index: linux/include/linux/ext3_fs.h
===================================================================
--- linux.orig/include/linux/ext3_fs.h
+++ linux/include/linux/ext3_fs.h
@@ -838,8 +838,7 @@ extern void ext3_get_inode_flags(struct 
 extern void ext3_set_aops(struct inode *inode);
 
 /* ioctl.c */
-extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext3_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* namei.c */
