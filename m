Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZD0Osv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZD0Osv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbZD0OoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:44:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739AbZD0On5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:43:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/8] vfs: Make __fsync_super() a static function (version 4)
Date: Mon, 27 Apr 2009 16:43:50 +0200
Message-Id: <1240843435-1786-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240843435-1786-1-git-send-email-jack@suse.cz>
References: <1240843435-1786-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__fsync_super() does the same thing as fsync_super(). So change the only
caller to use fsync_super() and make __fsync_super() static. This removes
unnecessarily duplicated call to sync_blockdev() and prepares ground
for the changes to __fsync_super() in the following patches.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c     |    2 +-
 fs/super.c         |    7 +++----
 include/linux/fs.h |    1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index f45dbc1..48d1290 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -240,7 +240,7 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 		sb->s_frozen = SB_FREEZE_WRITE;
 		smp_wmb();
 
-		__fsync_super(sb);
+		fsync_super(sb);
 
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
diff --git a/fs/super.c b/fs/super.c
index d9759e0..05f32a0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -263,7 +263,7 @@ EXPORT_SYMBOL(unlock_super);
  * device.  Takes the superblock lock.  Requires a second blkdev
  * flush by the caller to complete the operation.
  */
-void __fsync_super(struct super_block *sb)
+static int __fsync_super(struct super_block *sb)
 {
 	sync_inodes_sb(sb, 0);
 	vfs_dq_sync(sb);
@@ -274,7 +274,7 @@ void __fsync_super(struct super_block *sb)
 	unlock_super(sb);
 	if (sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, 1);
-	sync_blockdev(sb->s_bdev);
+	return sync_blockdev(sb->s_bdev);
 }
 
 /*
@@ -284,8 +284,7 @@ void __fsync_super(struct super_block *sb)
  */
 int fsync_super(struct super_block *sb)
 {
-	__fsync_super(sb);
-	return sync_blockdev(sb->s_bdev);
+	return __fsync_super(sb);
 }
 EXPORT_SYMBOL_GPL(fsync_super);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4bad02e..47a67c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2084,7 +2084,6 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
 extern int vfs_fsync(struct file *file, struct dentry *dentry, int datasync);
 extern void sync_supers(void);
 extern void sync_filesystems(int wait);
-extern void __fsync_super(struct super_block *sb);
 extern void emergency_sync(void);
 extern void emergency_remount(void);
 extern int do_remount_sb(struct super_block *sb, int flags,
-- 
1.6.0.2

