Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZKRJ1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZKRJ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbZKRJ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:27:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbZKRJZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:17 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 15/20] BKL: Remove BKL from NILFS2
Date: Wed, 18 Nov 2009 10:24:48 +0100
Message-Id: <1258536293-7762-16-git-send-email-jblunck@suse.de>
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
 fs/nilfs2/ioctl.c |    1 -
 fs/nilfs2/super.c |   19 +------------------
 2 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f6af760..30f7b41 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -22,7 +22,6 @@
 
 #include <linux/fs.h>
 #include <linux/wait.h>
-#include <linux/smp_lock.h>	/* lock_kernel(), unlock_kernel() */
 #include <linux/capability.h>	/* capable() */
 #include <linux/uaccess.h>	/* copy_from_user(), copy_to_user() */
 #include <linux/vmalloc.h>
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 3448ec3..0086dc2 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -45,7 +45,6 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/crc32.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
 #include <linux/kobject.h>
@@ -310,8 +309,6 @@ static void nilfs_put_super(struct super_block *sb)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 
-	lock_kernel();
-
 	nilfs_detach_segment_constructor(sbi);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -330,8 +327,6 @@ static void nilfs_put_super(struct super_block *sb)
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
 	nilfs_put_sbinfo(sbi);
-
-	unlock_kernel();
 }
 
 static int nilfs_sync_fs(struct super_block *sb, int wait)
@@ -893,8 +888,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct nilfs_mount_options old_opts;
 	int err;
 
-	lock_kernel();
-
 	down_write(&nilfs->ns_super_sem);
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
@@ -974,7 +967,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	}
  out:
 	up_write(&nilfs->ns_super_sem);
-	unlock_kernel();
 	return 0;
 
  restore_opts:
@@ -982,7 +974,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	sbi->s_mount_opt = old_opts.mount_opt;
 	sbi->s_snapshot_cno = old_opts.snapshot_cno;
 	up_write(&nilfs->ns_super_sem);
-	unlock_kernel();
 	return err;
 }
 
@@ -1059,13 +1050,9 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	struct the_nilfs *nilfs;
 	int err, need_to_close = 1;
 
-	lock_kernel();
-
 	sd.bdev = open_bdev_exclusive(dev_name, flags, fs_type);
-	if (IS_ERR(sd.bdev)) {
-		unlock_kernel();
+	if (IS_ERR(sd.bdev))
 		return PTR_ERR(sd.bdev);
-	}
 
 	/*
 	 * To get mount instance using sget() vfs-routine, NILFS needs
@@ -1146,7 +1133,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	if (need_to_close)
 		close_bdev_exclusive(sd.bdev, flags);
 	simple_set_mnt(mnt, s);
-	unlock_kernel();
 	return 0;
 
  failed_unlock:
@@ -1154,8 +1140,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	put_nilfs(nilfs);
  failed:
 	close_bdev_exclusive(sd.bdev, flags);
-
-	unlock_kernel();
 	return err;
 
  cancel_new:
@@ -1169,7 +1153,6 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	 * We must finish all post-cleaning before this call;
 	 * put_nilfs() needs the block device.
 	 */
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2

