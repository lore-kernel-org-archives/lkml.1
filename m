Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZD0Oum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZD0Oum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbZD0OoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:44:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817AbZD0On7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:43:59 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 6/8] vfs: Rename fsync_super() to sync_filesystem() (version 4)
Date: Mon, 27 Apr 2009 16:43:53 +0200
Message-Id: <1240843435-1786-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240843435-1786-1-git-send-email-jack@suse.cz>
References: <1240843435-1786-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the function so that it better describe what it really does. Also
remove the unnecessary include of buffer_head.h.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c     |    4 ++--
 fs/super.c         |    5 ++---
 fs/sync.c          |   14 +++++++-------
 include/linux/fs.h |    2 +-
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2609cce..40370c5 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -203,7 +203,7 @@ int fsync_bdev(struct block_device *bdev)
 {
 	struct super_block *sb = get_super(bdev);
 	if (sb) {
-		int res = fsync_super(sb);
+		int res = sync_filesystem(sb);
 		drop_super(sb);
 		return res;
 	}
@@ -245,7 +245,7 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 		sb->s_frozen = SB_FREEZE_WRITE;
 		smp_wmb();
 
-		fsync_super(sb);
+		sync_filesystem(sb);
 
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
diff --git a/fs/super.c b/fs/super.c
index c0302a5..a7df36c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -28,7 +28,6 @@
 #include <linux/blkdev.h>
 #include <linux/quotaops.h>
 #include <linux/namei.h>
-#include <linux/buffer_head.h>		/* for fsync_super() */
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -278,7 +277,7 @@ void generic_shutdown_super(struct super_block *sb)
 
 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
-		fsync_super(sb);
+		sync_filesystem(sb);
 		lock_super(sb);
 		sb->s_flags &= ~MS_ACTIVE;
 
@@ -561,7 +560,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	if (flags & MS_RDONLY)
 		acct_auto_close(sb);
 	shrink_dcache_sb(sb);
-	fsync_super(sb);
+	sync_filesystem(sb);
 
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
diff --git a/fs/sync.c b/fs/sync.c
index a0a163a..c3ef04e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -12,7 +12,7 @@
 #include <linux/linkage.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
-#include <linux/buffer_head.h>
+#include <linux/async.h>
 
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
@@ -24,7 +24,7 @@
  * case write_inode() functions do sync_dirty_buffer() and thus effectively
  * write one block at a time.
  */
-static int __fsync_super(struct super_block *sb, int wait)
+static int __sync_filesystem(struct super_block *sb, int wait)
 {
 	vfs_dq_sync(sb);
 	sync_inodes_sb(sb, wait);
@@ -42,16 +42,16 @@ static int __fsync_super(struct super_block *sb, int wait)
  * superblock.  Filesystem data as well as the underlying block
  * device.  Takes the superblock lock.
  */
-int fsync_super(struct super_block *sb)
+int sync_filesystem(struct super_block *sb)
 {
 	int ret;
 
-	ret = __fsync_super(sb, 0);
+	ret = __sync_filesystem(sb, 0);
 	if (ret < 0)
 		return ret;
-	return __fsync_super(sb, 1);
+	return __sync_filesystem(sb, 1);
 }
-EXPORT_SYMBOL_GPL(fsync_super);
+EXPORT_SYMBOL_GPL(sync_filesystem);
 
 /*
  * Sync all the data for all the filesystems (called by sys_sync() and
@@ -92,7 +92,7 @@ restart:
 		down_read(&sb->s_umount);
 		async_synchronize_full_domain(&sb->s_async_list);
 		if (sb->s_root)
-			__fsync_super(sb, wait);
+			__sync_filesystem(sb, wait);
 		up_read(&sb->s_umount);
 		/* restart only when sb is no longer on the list */
 		spin_lock(&sb_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cbef739..71a59ee 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1947,7 +1947,7 @@ extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
 extern int fsync_bdev(struct block_device *);
-extern int fsync_super(struct super_block *);
+extern int sync_filesystem(struct super_block *);
 extern int fsync_no_super(struct block_device *);
 #else
 static inline void bd_forget(struct inode *inode) {}
-- 
1.6.0.2

