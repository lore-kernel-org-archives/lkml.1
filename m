Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYE2XNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYE2XNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYE2XNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:13:38 -0400
Received: from vena.lwn.net ([206.168.112.25]:53008 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbYE2XNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:13:37 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression caused by bf726e "semaphore: fix,") 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Thu, 29 May 2008 14:37:13 PDT."
             <alpine.LFD.1.10.0805291413490.3873@woody.linux-foundation.org> 
Date: Thu, 29 May 2008 17:13:37 -0600
Message-ID: <17765.1212102817@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Jonathan, do you want an updated replacement patch, or an incremental one, 
> or will you just do that trivial fix yourself?

Something like the attached?  Seems to work for me.  If nobody gripes
I'll stick it into the bkl-removal tree.

jon

Remove deadlocking lock_super() calls from FAT

Linus sez:

	So the end result of that is all the "lock_kernel()" calls in
	fs/fat/file.c should actually just go away - not be replaced by
	lock_super() at alL!

This patch causes that to be.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>


diff --git a/fs/fat/file.c b/fs/fat/file.c
index 7059928..bdf91e9 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -11,7 +11,6 @@
 #include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
@@ -229,8 +228,7 @@ static int fat_free(struct inode *inode, int skip)
 
 void fat_truncate(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	const unsigned int cluster_size = sbi->cluster_size;
 	int nr_clusters;
 
@@ -243,9 +241,7 @@ void fat_truncate(struct inode *inode)
 
 	nr_clusters = (inode->i_size + (cluster_size - 1)) >> sbi->cluster_bits;
 
-	lock_super(sb);
 	fat_free(inode, nr_clusters);
-	unlock_super(sb);
 	fat_flush_inodes(inode->i_sb, inode, NULL);
 }
 
@@ -298,14 +294,11 @@ static int fat_allow_set_time(struct msdos_sb_info *sbi, struct inode *inode)
 
 int fat_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	struct super_block *sb = dentry->d_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
 	int mask, error = 0;
 	unsigned int ia_valid;
 
-	lock_super(sb);
-
 	/*
 	 * Expand the file. Since inode_setattr() updates ->i_size
 	 * before calling the ->truncate(), but FAT needs to fill the
@@ -358,7 +351,6 @@ int fat_setattr(struct dentry *dentry, struct iattr *attr)
 		mask = sbi->options.fs_fmask;
 	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
 out:
-	unlock_super(sb);
 	return error;
 }
 EXPORT_SYMBOL_GPL(fat_setattr);
