Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbZKRJ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbZKRJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZKRJZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:42285 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812AbZKRJZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:13 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 12/20] BKL: Remove BKL from HFS
Date: Wed, 18 Nov 2009 10:24:45 +0100
Message-Id: <1258536293-7762-13-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super and fill_super that are both protected by
the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
BKL entirely.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/hfs/super.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index a2e19ff..6e0ff34 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -19,7 +19,6 @@
 #include <linux/nls.h>
 #include <linux/parser.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 
 #include "hfs_fs.h"
@@ -78,15 +77,11 @@ static int hfs_sync_fs(struct super_block *sb, int wait)
  */
 static void hfs_put_super(struct super_block *sb)
 {
-	lock_kernel();
-
 	if (sb->s_dirt)
 		hfs_write_super(sb);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
 	hfs_mdb_put(sb);
-
-	unlock_kernel();
 }
 
 /*
@@ -381,13 +376,10 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *root_inode;
 	int res;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(struct hfs_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
+
 	sb->s_fs_info = sbi;
 	INIT_HLIST_HEAD(&sbi->rsrc_inodes);
 
@@ -433,7 +425,6 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root->d_op = &hfs_dentry_operations;
 
 	/* everything's okay */
-	unlock_kernel();
 	return 0;
 
 bail_iput:
@@ -442,7 +433,6 @@ bail_no_root:
 	printk(KERN_ERR "hfs: get root inode failed.\n");
 bail:
 	hfs_mdb_put(sb);
-	unlock_kernel();
 	return res;
 }
 
-- 
1.6.4.2

