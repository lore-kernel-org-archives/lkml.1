Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbXKAPwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbXKAPwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXKAPwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:52:08 -0400
Received: from styx.suse.cz ([82.119.242.94]:60750 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754359AbXKAPwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:52:07 -0400
Date: Thu, 1 Nov 2007 16:52:04 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: LIOU Payphone <lioupayphone@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Forbid user to change file flags on quota files
Message-ID: <20071101155204.GB30523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  attached patch fixes possible deadlock spotted by LIOU Payphone. If we
set inode flags for quota files, we first lock i_mutex and then start a
transaction (which is a standard ordering) but quota files are special and
their i_mutex should be acquired only when a transaction is started.
Because users have no reason to muck with inode flags when quota is on
anyway, just forbid users from changing inode flags when quota is on.
I've done the change for all the filesystems supporting quota so that
they are consistent. Andrew, would you please queue it? Thanks.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Forbid user from changing file flags on quota files. User has no bussiness
in playing with these flags when quota is on. Furthermore there is a remote
possibility of deadlock due to a lock inversion between quota file's i_mutex and
transaction's start (i_mutex for quota file is locked only when trasaction is
started in quota operations) in ext3 and ext4.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: LIOU Payphone <lioupayphone@gmail.com>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/fs/ext2/ioctl.c linux-2.6.24-rc1-1-forbid_setflags/fs/ext2/ioctl.c
--- linux-2.6.24-rc1/fs/ext2/ioctl.c	2007-10-24 20:43:56.000000000 +0200
+++ linux-2.6.24-rc1-1-forbid_setflags/fs/ext2/ioctl.c	2007-11-01 16:01:26.000000000 +0100
@@ -47,6 +47,11 @@ int ext2_ioctl (struct inode * inode, st
 			flags &= ~EXT2_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
+		/* Is it quota file? Don't allow user mess with it */
+		if (IS_NOQUOTA(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -EPERM;
+		}
 		oldflags = ei->i_flags;
 
 		/*
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/fs/ext3/ioctl.c linux-2.6.24-rc1-1-forbid_setflags/fs/ext3/ioctl.c
--- linux-2.6.24-rc1/fs/ext3/ioctl.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.24-rc1-1-forbid_setflags/fs/ext3/ioctl.c	2007-11-01 16:01:58.000000000 +0100
@@ -51,6 +51,11 @@ int ext3_ioctl (struct inode * inode, st
 			flags &= ~EXT3_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
+		/* Is it quota file? Don't allow user mess with it */
+		if (IS_NOQUOTA(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -EPERM;
+		}
 		oldflags = ei->i_flags;
 
 		/* The JOURNAL_DATA flag is modifiable only by root */
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/fs/ext4/ioctl.c linux-2.6.24-rc1-1-forbid_setflags/fs/ext4/ioctl.c
--- linux-2.6.24-rc1/fs/ext4/ioctl.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.24-rc1-1-forbid_setflags/fs/ext4/ioctl.c	2007-11-01 16:03:02.000000000 +0100
@@ -51,6 +51,11 @@ int ext4_ioctl (struct inode * inode, st
 			flags &= ~EXT4_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
+		/* Is it quota file? Don't allow user mess with it */
+		if (IS_NOQUOTA(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -EPERM;
+		}
 		oldflags = ei->i_flags;
 
 		/* The JOURNAL_DATA flag is modifiable only by root */
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/fs/jfs/ioctl.c linux-2.6.24-rc1-1-forbid_setflags/fs/jfs/ioctl.c
--- linux-2.6.24-rc1/fs/jfs/ioctl.c	2007-10-11 12:01:23.000000000 +0200
+++ linux-2.6.24-rc1-1-forbid_setflags/fs/jfs/ioctl.c	2007-11-01 16:13:07.000000000 +0100
@@ -79,6 +79,9 @@ int jfs_ioctl(struct inode * inode, stru
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~JFS_DIRSYNC_FL;
 
+		/* Is it quota file? Don't allow user mess with it */
+		if (IS_NOQUOTA(inode))
+			return -EPERM;
 		jfs_get_inode_flags(jfs_inode);
 		oldflags = jfs_inode->mode2;
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.24-rc1/fs/reiserfs/ioctl.c linux-2.6.24-rc1-1-forbid_setflags/fs/reiserfs/ioctl.c
--- linux-2.6.24-rc1/fs/reiserfs/ioctl.c	2007-10-24 20:43:58.000000000 +0200
+++ linux-2.6.24-rc1-1-forbid_setflags/fs/reiserfs/ioctl.c	2007-11-01 16:13:27.000000000 +0100
@@ -57,6 +57,9 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (get_user(flags, (int __user *)arg))
 				return -EFAULT;
 
+			/* Is it quota file? Don't allow user mess with it. */
+			if (IS_NOQUOTA(inode))
+				return -EPERM;
 			if (((flags ^ REISERFS_I(inode)->
 			      i_attrs) & (REISERFS_IMMUTABLE_FL |
 					  REISERFS_APPEND_FL))
