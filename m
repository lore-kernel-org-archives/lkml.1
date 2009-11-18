Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZKRJ3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZKRJ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbZKRJ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:29:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:42256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbZKRJZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:08 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Andreas Dilger <adilger@sun.com>
Subject: [PATCH 08/20] BKL: Remove BKL from ext3 fill_super()
Date: Wed, 18 Nov 2009 10:24:41 +0100
Message-Id: <1258536293-7762-9-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is protecting nothing than two memory allocations here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 0955c3f..373fc54 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1570,19 +1570,14 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	__le32 features;
 	int err;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
@@ -1591,8 +1586,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_resgid = EXT3_DEF_RESGID;
 	sbi->s_sb_block = sb_block;
 
-	unlock_kernel();
-
 	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		printk(KERN_ERR "EXT3-fs: unable to set blocksize\n");
@@ -1998,8 +1991,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
 
-	lock_kernel();
-	unlock_kernel();
 	return 0;
 
 cantfind_ext3:
@@ -2029,8 +2020,6 @@ out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-	lock_kernel();
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

