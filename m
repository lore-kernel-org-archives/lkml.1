Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbYA0CXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbYA0CXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYA0CST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:18:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbYA0CRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:13 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [6/18] BKL-removal: Convert ext4 to use unlocked_ioctl
Message-Id: <20080127021712.8275914D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I checked ext4_ioctl and it looked largely safe to not be used
without BKL.  So convert it over to unlocked_ioctl.

The only case where I wasn't quite sure was for the
dynamic fs grow ioctls versus umounting -- I kept the BKL for those. 

Cc: sct@redhat.com
Cc: adilger@clusterfs.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/ext4/dir.c           |    2 +-
 fs/ext4/file.c          |    2 +-
 fs/ext4/ioctl.c         |   20 +++++++++++---------
 include/linux/ext4_fs.h |    3 +--
 4 files changed, 14 insertions(+), 13 deletions(-)

Index: linux/fs/ext4/dir.c
===================================================================
--- linux.orig/fs/ext4/dir.c
+++ linux/fs/ext4/dir.c
@@ -42,7 +42,7 @@ const struct file_operations ext4_dir_op
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= ext4_readdir,		/* we take BKL. needed?*/
-	.ioctl		= ext4_ioctl,		/* BKL held */
+	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
Index: linux/fs/ext4/file.c
===================================================================
--- linux.orig/fs/ext4/file.c
+++ linux/fs/ext4/file.c
@@ -112,7 +112,7 @@ const struct file_operations ext4_file_o
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= ext4_file_write,
-	.ioctl		= ext4_ioctl,
+	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
Index: linux/fs/ext4/ioctl.c
===================================================================
--- linux.orig/fs/ext4/ioctl.c
+++ linux/fs/ext4/ioctl.c
@@ -17,9 +17,9 @@
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
-int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
-		unsigned long arg)
+long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -224,10 +224,14 @@ flags_err:
 		if (get_user(n_blocks_count, (__u32 __user *)arg))
 			return -EFAULT;
 
+		/* AK: not sure the BKL is needed, but this might prevent
+		 * races against umount. */
+		lock_kernel();
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		unlock_kernel();
 
 		return err;
 	}
@@ -246,10 +250,14 @@ flags_err:
 				sizeof(input)))
 			return -EFAULT;
 
+		/* AK: not sure the BKL is needed, but this might prevent
+		 * races against umount. */
+		lock_kernel();
 		err = ext4_group_add(sb, &input);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		unlock_kernel();
 
 		return err;
 	}
@@ -262,9 +270,6 @@ flags_err:
 #ifdef CONFIG_COMPAT
 long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
 	case EXT4_IOC32_GETFLAGS:
@@ -304,9 +309,6 @@ long ext4_compat_ioctl(struct file *file
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
-	ret = ext4_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
-	return ret;
+	return ext4_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
Index: linux/include/linux/ext4_fs.h
===================================================================
--- linux.orig/include/linux/ext4_fs.h
+++ linux/include/linux/ext4_fs.h
@@ -939,8 +939,7 @@ extern int ext4_block_truncate_page(hand
 		struct address_space *mapping, loff_t from);
 
 /* ioctl.c */
-extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
-		       unsigned long);
+extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
 
 /* namei.c */
