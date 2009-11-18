Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZKRJ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZKRJ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZKRJ3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:29:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:42236 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbZKRJZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 05/20] BKL: Remove BKL from Amiga FFS
Date: Wed, 18 Nov 2009 10:24:38 +0100
Message-Id: <1258536293-7762-6-git-send-email-jblunck@suse.de>
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
 fs/affs/super.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index 151b930..ede5e44 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -16,7 +16,6 @@
 #include <linux/parser.h>
 #include <linux/magic.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include "affs.h"
 
 extern struct timezone sys_tz;
@@ -43,8 +42,6 @@ affs_put_super(struct super_block *sb)
 	struct affs_sb_info *sbi = AFFS_SB(sb);
 	pr_debug("AFFS: put_super()\n");
 
-	lock_kernel();
-
 	if (!(sb->s_flags & MS_RDONLY))
 		affs_commit_super(sb, 1);
 
@@ -53,8 +50,6 @@ affs_put_super(struct super_block *sb)
 	affs_brelse(sbi->s_root_bh);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
-
-	unlock_kernel();
 }
 
 static void
@@ -298,8 +293,6 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	u8			 sig[4];
 	int			 ret = -EINVAL;
 
-	lock_kernel();
-
 	save_mount_options(sb, data);
 
 	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
@@ -309,10 +302,9 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags |= MS_NODIRATIME;
 
 	sbi = kzalloc(sizeof(struct affs_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
+
 	sb->s_fs_info = sbi;
 	mutex_init(&sbi->s_bmlock);
 
@@ -490,7 +482,6 @@ got_root:
 	sb->s_root->d_op = &affs_dentry_operations;
 
 	pr_debug("AFFS: s_flags=%lX\n",sb->s_flags);
-	unlock_kernel();
 	return 0;
 
 	/*
@@ -506,7 +497,6 @@ out_error_noinode:
 out_error_free_sbi:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
-	unlock_kernel();
 	return ret;
 }
 
@@ -534,7 +524,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		kfree(new_opts);
 		return -EINVAL;
 	}
-	lock_kernel();
+
 	replace_mount_options(sb, new_opts);
 
 	sbi->s_flags = mount_flags;
@@ -542,10 +532,9 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	sbi->s_uid   = uid;
 	sbi->s_gid   = gid;
 
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
-		unlock_kernel();
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
-	}
+
 	if (*flags & MS_RDONLY) {
 		sb->s_dirt = 1;
 		while (sb->s_dirt)
@@ -554,7 +543,6 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	} else
 		res = affs_init_bitmap(sb, flags);
 
-	unlock_kernel();
 	return res;
 }
 
-- 
1.6.4.2

