Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZKRJ3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZKRJ3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZKRJ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:28:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:42303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbZKRJZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:15 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: [PATCH 14/20] BKL: Remove BKL from JFS
Date: Wed, 18 Nov 2009 10:24:47 +0100
Message-Id: <1258536293-7762-15-git-send-email-jblunck@suse.de>
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
 fs/jfs/super.c |   36 +++++++-----------------------------
 1 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index a8e6046..5ccbb32 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -32,7 +32,6 @@
 #include <linux/crc32.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
@@ -173,8 +172,6 @@ static void jfs_put_super(struct super_block *sb)
 
 	jfs_info("In jfs_put_super");
 
-	lock_kernel();
-
 	rc = jfs_umount(sb);
 	if (rc)
 		jfs_err("jfs_umount failed with return code %d", rc);
@@ -185,8 +182,6 @@ static void jfs_put_super(struct super_block *sb)
 	iput(sbi->direct_inode);
 
 	kfree(sbi);
-
-	unlock_kernel();
 }
 
 enum {
@@ -366,19 +361,16 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
 	if (!parse_options(data, sb, &newLVSize, &flag)) {
 		return -EINVAL;
 	}
-	lock_kernel();
+
 	if (newLVSize) {
 		if (sb->s_flags & MS_RDONLY) {
 			printk(KERN_ERR
 		  "JFS: resize requires volume to be mounted read-write\n");
-			unlock_kernel();
 			return -EROFS;
 		}
 		rc = jfs_extendfs(sb, newLVSize, 0);
-		if (rc) {
-			unlock_kernel();
+		if (rc)
 			return rc;
-		}
 	}
 
 	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
@@ -390,30 +382,25 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
 
 		JFS_SBI(sb)->flag = flag;
 		ret = jfs_mount_rw(sb, 1);
-		unlock_kernel();
 		return ret;
 	}
 	if ((!(sb->s_flags & MS_RDONLY)) && (*flags & MS_RDONLY)) {
 		rc = jfs_umount_rw(sb);
 		JFS_SBI(sb)->flag = flag;
-		unlock_kernel();
 		return rc;
 	}
 	if ((JFS_SBI(sb)->flag & JFS_NOINTEGRITY) != (flag & JFS_NOINTEGRITY))
 		if (!(sb->s_flags & MS_RDONLY)) {
 			rc = jfs_umount_rw(sb);
-			if (rc) {
-				unlock_kernel();
+			if (rc)
 				return rc;
-			}
+
 			JFS_SBI(sb)->flag = flag;
 			ret = jfs_mount_rw(sb, 1);
-			unlock_kernel();
 			return ret;
 		}
 	JFS_SBI(sb)->flag = flag;
 
-	unlock_kernel();
 	return 0;
 }
 
@@ -425,20 +412,15 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	s64 newLVSize = 0;
 	int flag, ret = -EINVAL;
 
-	lock_kernel();
-
 	jfs_info("In jfs_read_super: s_flags=0x%lx", sb->s_flags);
 
-	if (!new_valid_dev(sb->s_bdev->bd_dev)) {
-		unlock_kernel();
+	if (!new_valid_dev(sb->s_bdev->bd_dev))
 		return -EOVERFLOW;
-	}
 
 	sbi = kzalloc(sizeof (struct jfs_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
+
 	sb->s_fs_info = sbi;
 	sbi->sb = sb;
 	sbi->uid = sbi->gid = sbi->umask = -1;
@@ -448,7 +430,6 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!parse_options((char *) data, sb, &newLVSize, &flag)) {
 		kfree(sbi);
-		unlock_kernel();
 		return -EINVAL;
 	}
 	sbi->flag = flag;
@@ -460,7 +441,6 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
 		kfree(sbi);
-		unlock_kernel();
 		return -EINVAL;
 	}
 
@@ -536,7 +516,6 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1, sb->s_maxbytes);
 #endif
 	sb->s_time_gran = 1;
-	unlock_kernel();
 	return 0;
 
 out_no_root:
@@ -558,7 +537,6 @@ out_kfree:
 	if (sbi->nls_tab)
 		unload_nls(sbi->nls_tab);
 	kfree(sbi);
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

