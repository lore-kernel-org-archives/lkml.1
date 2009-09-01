Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZIALTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZIALTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZIALTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:19:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45114 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZIALTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:19:38 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/8] writeback: move super_block argument to struct writeback_control
Date: Tue,  1 Sep 2009 13:18:59 +0200
Message-Id: <1251803946-9243-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/staging/pohmelfs/inode.c |    3 ++-
 fs/fs-writeback.c                |   14 +++++++-------
 fs/ubifs/budget.c                |    5 +++--
 fs/ubifs/super.c                 |    3 ++-
 include/linux/fs.h               |    3 +--
 include/linux/writeback.h        |    2 ++
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 7b60579..9a94c5a 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -1951,12 +1951,13 @@ static int pohmelfs_get_sb(struct file_system_type *fs_type,
 static void pohmelfs_kill_super(struct super_block *sb)
 {
 	struct writeback_control wbc = {
+		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
 		.nr_to_write	= LONG_MAX,
 	};
-	generic_sync_sb_inodes(sb, &wbc);
+	generic_sync_sb_inodes(&wbc);
 
 	kill_anon_super(sb);
 }
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c54226b..8c43ca4 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -458,9 +458,9 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-void generic_sync_sb_inodes(struct super_block *sb,
-				struct writeback_control *wbc)
+void generic_sync_sb_inodes(struct writeback_control *wbc)
 {
+	struct super_block *sb = wbc->sb;
 	const unsigned long start = jiffies;	/* livelock avoidance */
 	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
@@ -595,10 +595,9 @@ void generic_sync_sb_inodes(struct super_block *sb,
 }
 EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
 
-static void sync_sb_inodes(struct super_block *sb,
-				struct writeback_control *wbc)
+static void sync_sb_inodes(struct writeback_control *wbc)
 {
-	generic_sync_sb_inodes(sb, wbc);
+	generic_sync_sb_inodes(wbc);
 }
 
 /*
@@ -640,7 +639,7 @@ restart:
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
 				if (sb->s_root)
-					sync_sb_inodes(sb, wbc);
+					sync_sb_inodes(wbc);
 				up_read(&sb->s_umount);
 			}
 			spin_lock(&sb_lock);
@@ -666,6 +665,7 @@ restart:
 void sync_inodes_sb(struct super_block *sb, int wait)
 {
 	struct writeback_control wbc = {
+		.sb		= sb,
 		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_NONE,
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
@@ -680,7 +680,7 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 	} else
 		wbc.nr_to_write = LONG_MAX; /* doesn't actually matter */
 
-	sync_sb_inodes(sb, &wbc);
+	sync_sb_inodes(&wbc);
 }
 
 /**
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index eaf6d89..0f680b9 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -66,12 +66,13 @@ static int shrink_liability(struct ubifs_info *c, int nr_to_write)
 {
 	int nr_written;
 	struct writeback_control wbc = {
+		.sb	     = c->vfs_sb,
 		.sync_mode   = WB_SYNC_NONE,
 		.range_end   = LLONG_MAX,
 		.nr_to_write = nr_to_write,
 	};
 
-	generic_sync_sb_inodes(c->vfs_sb, &wbc);
+	generic_sync_sb_inodes(&wbc);
 	nr_written = nr_to_write - wbc.nr_to_write;
 
 	if (!nr_written) {
@@ -83,7 +84,7 @@ static int shrink_liability(struct ubifs_info *c, int nr_to_write)
 		wbc.sync_mode   = WB_SYNC_ALL;
 		wbc.range_end   = LLONG_MAX;
 		wbc.nr_to_write = nr_to_write;
-		generic_sync_sb_inodes(c->vfs_sb, &wbc);
+		generic_sync_sb_inodes(&wbc);
 		nr_written = nr_to_write - wbc.nr_to_write;
 	}
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 26d2e0d..06e80e3 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -439,6 +439,7 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
 	int i, err;
 	struct ubifs_info *c = sb->s_fs_info;
 	struct writeback_control wbc = {
+		.sb	     = sb,
 		.sync_mode   = WB_SYNC_ALL,
 		.range_start = 0,
 		.range_end   = LLONG_MAX,
@@ -462,7 +463,7 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
 	 * the user be able to get more accurate results of 'statfs()' after
 	 * they synchronize the file system.
 	 */
-	generic_sync_sb_inodes(sb, &wbc);
+	generic_sync_sb_inodes(&wbc);
 
 	/*
 	 * Synchronize write buffers, because 'ubifs_run_commit()' does not
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73e9b64..b0da459 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2070,8 +2070,7 @@ static inline void invalidate_remote_inode(struct inode *inode)
 extern int invalidate_inode_pages2(struct address_space *mapping);
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
-extern void generic_sync_sb_inodes(struct super_block *sb,
-				struct writeback_control *wbc);
+extern void generic_sync_sb_inodes(struct writeback_control *wbc);
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 3224820..5b4ceef 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -40,6 +40,8 @@ enum writeback_sync_modes {
 struct writeback_control {
 	struct backing_dev_info *bdi;	/* If !NULL, only write back this
 					   queue */
+	struct super_block *sb;		/* if !NULL, only write inodes from
+					   this super_block */
 	enum writeback_sync_modes sync_mode;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
-- 
1.6.4.1.207.g68ea

