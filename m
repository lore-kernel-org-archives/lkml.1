Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZKRJ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZKRJ1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbZKRJ1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:27:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:42310 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848AbZKRJZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:17 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Anton Altaparmakov <aia21@cantab.net>
Subject: [PATCH 16/20] BKL: Remove BKL from NTFS
Date: Wed, 18 Nov 2009 10:24:49 +0100
Message-Id: <1258536293-7762-17-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super, fill_super and remount_fs that are all
three protected by the superblocks s_umount rw_semaphore. Therefore it is
safe to remove the BKL entirely.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ntfs/super.c |   29 ++---------------------------
 1 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index ab09c02..4aa55d7 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -30,7 +30,6 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/moduleparam.h>
-#include <linux/smp_lock.h>
 
 #include "sysctl.h"
 #include "logfile.h"
@@ -443,7 +442,6 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 
 	ntfs_debug("Entering with remount options string: %s", opt);
 
-	lock_kernel();
 #ifndef NTFS_RW
 	/* For read-only compiled driver, enforce read-only flag. */
 	*flags |= MS_RDONLY;
@@ -467,18 +465,15 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 		if (NVolErrors(vol)) {
 			ntfs_error(sb, "Volume has errors and is read-only%s",
 					es);
-			unlock_kernel();
 			return -EROFS;
 		}
 		if (vol->vol_flags & VOLUME_IS_DIRTY) {
 			ntfs_error(sb, "Volume is dirty and read-only%s", es);
-			unlock_kernel();
 			return -EROFS;
 		}
 		if (vol->vol_flags & VOLUME_MODIFIED_BY_CHKDSK) {
 			ntfs_error(sb, "Volume has been modified by chkdsk "
 					"and is read-only%s", es);
-			unlock_kernel();
 			return -EROFS;
 		}
 		if (vol->vol_flags & VOLUME_MUST_MOUNT_RO_MASK) {
@@ -486,13 +481,11 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 					"(0x%x) and is read-only%s",
 					(unsigned)le16_to_cpu(vol->vol_flags),
 					es);
-			unlock_kernel();
 			return -EROFS;
 		}
 		if (ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY)) {
 			ntfs_error(sb, "Failed to set dirty bit in volume "
 					"information flags%s", es);
-			unlock_kernel();
 			return -EROFS;
 		}
 #if 0
@@ -512,21 +505,18 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 			ntfs_error(sb, "Failed to empty journal $LogFile%s",
 					es);
 			NVolSetErrors(vol);
-			unlock_kernel();
 			return -EROFS;
 		}
 		if (!ntfs_mark_quotas_out_of_date(vol)) {
 			ntfs_error(sb, "Failed to mark quotas out of date%s",
 					es);
 			NVolSetErrors(vol);
-			unlock_kernel();
 			return -EROFS;
 		}
 		if (!ntfs_stamp_usnjrnl(vol)) {
 			ntfs_error(sb, "Failed to stamp transation log "
 					"($UsnJrnl)%s", es);
 			NVolSetErrors(vol);
-			unlock_kernel();
 			return -EROFS;
 		}
 	} else if (!(sb->s_flags & MS_RDONLY) && (*flags & MS_RDONLY)) {
@@ -542,11 +532,9 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 
 	// TODO: Deal with *flags.
 
-	if (!parse_options(vol, opt)) {
-		unlock_kernel();
+	if (!parse_options(vol, opt))
 		return -EINVAL;
-	}
-	unlock_kernel();
+
 	ntfs_debug("Done.");
 	return 0;
 }
@@ -2259,8 +2247,6 @@ static void ntfs_put_super(struct super_block *sb)
 
 	ntfs_debug("Entering.");
 
-	lock_kernel();
-
 #ifdef NTFS_RW
 	/*
 	 * Commit all inodes while they are still open in case some of them
@@ -2431,8 +2417,6 @@ static void ntfs_put_super(struct super_block *sb)
 
 	sb->s_fs_info = NULL;
 	kfree(vol);
-
-	unlock_kernel();
 }
 
 /**
@@ -2723,8 +2707,6 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 	struct inode *tmp_ino;
 	int blocksize, result;
 
-	lock_kernel();
-
 	/*
 	 * We do a pretty difficult piece of bootstrap by reading the
 	 * MFT (and other metadata) from disk into memory. We'll only
@@ -2748,7 +2730,6 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 			ntfs_error(sb, "Allocation of NTFS volume structure "
 					"failed. Aborting mount...");
 		lockdep_on();
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	/* Initialize ntfs_volume structure. */
@@ -2766,8 +2747,6 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 	init_rwsem(&vol->mftbmp_lock);
 	init_rwsem(&vol->lcnbmp_lock);
 
-	unlock_kernel();
-
 	/* By default, enable sparse support. */
 	NVolSetSparseEnabled(vol);
 
@@ -2934,9 +2913,7 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 		}
 		mutex_unlock(&ntfs_lock);
 		sb->s_export_op = &ntfs_export_ops;
-		lock_kernel();
 		lockdep_on();
-		unlock_kernel();
 		return 0;
 	}
 	ntfs_error(sb, "Failed to allocate root directory.");
@@ -3052,12 +3029,10 @@ iput_tmp_ino_err_out_now:
 	}
 	/* Errors at this stage are irrelevant. */
 err_out_now:
-	lock_kernel();
 	sb->s_fs_info = NULL;
 	kfree(vol);
 	ntfs_debug("Failed, returning -EINVAL.");
 	lockdep_on();
-	unlock_kernel();
 	return -EINVAL;
 }
 
-- 
1.6.4.2

