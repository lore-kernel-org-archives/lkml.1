Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYIZJA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYIZJA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYIZI66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:58:58 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60825 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbYIZI64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:58:56 -0400
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/10] jfs: Fix error handling in write_super_lockfs/unlockfs
Message-Id: <20080926175837t-sato@mail.jp.nec.com>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:1K0086
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:58:37 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed write_super_lockfs so that it returns 0 because there is no
case of an error.  unlockfs always returns 0.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-gfs2/Documentation/dontdiff linux-2.6.27-rc7-lockfs-gfs2/fs/jfs/super.c linux-2.6.
27-rc7-lockfs-jfs/fs/jfs/super.c
--- linux-2.6.27-rc7-lockfs-gfs2/fs/jfs/super.c	2008-09-26 14:30:30.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-jfs/fs/jfs/super.c	2008-09-26 17:05:59.000000000 +0900
@@ -543,7 +543,7 @@ out_kfree:
 	return ret;
 }
 
-static void jfs_write_super_lockfs(struct super_block *sb)
+static int jfs_freeze(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -553,9 +553,10 @@ static void jfs_write_super_lockfs(struc
 		lmLogShutdown(log);
 		updateSuper(sb, FM_CLEAN);
 	}
+	return 0;
 }
 
-static void jfs_unlockfs(struct super_block *sb)
+static int jfs_unfreeze(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -568,6 +569,7 @@ static void jfs_unlockfs(struct super_bl
 		else
 			txResume(sb);
 	}
+	return 0;
 }
 
 static int jfs_get_sb(struct file_system_type *fs_type,
@@ -735,8 +737,8 @@ static const struct super_operations jfs
 	.delete_inode	= jfs_delete_inode,
 	.put_super	= jfs_put_super,
 	.sync_fs	= jfs_sync_fs,
-	.write_super_lockfs = jfs_write_super_lockfs,
-	.unlockfs       = jfs_unlockfs,
+	.freeze_fs	= jfs_freeze,
+	.unfreeze_fs	= jfs_unfreeze,
 	.statfs		= jfs_statfs,
 	.remount_fs	= jfs_remount,
 	.show_options	= jfs_show_options,
