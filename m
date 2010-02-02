Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0BBB4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:56:39 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44960 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab0BBB4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=ekVFOExD3nmZqCU3AnfwVcYlGAWNn/rNEiqTi045JgWk79f/mWLKBIAyFCMouUXafl
         IIkwg7WfzNNpN8+fNSHFj6rYbqmc4rUO6tGy2WASVRH63GchnT4N/L3H/wXS3QQPBbtb
         g6o9YXbDap82fc43/JWQUUI+lD+r7h+C/WGBU=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 5/7] VFS: add super operation writeback_inodes
Date: Tue, 2 Feb 2010 02:56:21 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Message-Id: <201002020256.21266.edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, jens.axboe@oracle.com
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. add ->writeback_inodes() super operation.

    This patch adds new operation to struct super_operations -
    writeback_inodes, generic implementaion and changes
    fs-writeback.c:writeback_inodes_wb() to call filesystem's
    writeback_inodes if it is defined or generic implementaion
    otherwise. This new operation allows filesystem to decide
    itself what to flush.

    Reiser4 flushes dirty pages on basic of atoms, not of inodes.
    writeback_inodes_wb used to call address space flushing
    method (writepages) for every dirty inode. For reiser4 it
    caused having to commit atoms unnecessarily often.  This
    turned into substantial slowdown.  Having this method helped
    to fix that problem.

. add vfs library function writeback_skip_sb_inodes()

   This function is for file systems which have their own means
   of periodical writeout of old data.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/fs-writeback.c         |   47 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/fs.h        |   10 +++++++++
 include/linux/writeback.h |    6 +++++
 3 files changed, 59 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc5-mm1/include/linux/fs.h
===================================================================
--- linux-2.6.33-rc5-mm1.orig/include/linux/fs.h
+++ linux-2.6.33-rc5-mm1/include/linux/fs.h
@@ -514,6 +514,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct bdi_writeback;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -1565,6 +1566,9 @@ struct super_operations {
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct super_block *);
+	int (*writeback_inodes)(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct writeback_control *wbc);
 
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
@@ -2073,6 +2077,12 @@ extern int invalidate_inode_pages2(struc
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
+extern void writeback_skip_sb_inodes(struct super_block *sb,
+				     struct bdi_writeback *wb);
+extern void writeback_inodes_wbc(struct writeback_control *wbc);
+extern int generic_writeback_sb_inodes(struct super_block *sb,
+				       struct bdi_writeback *wb,
+				       struct writeback_control *wbc);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
Index: linux-2.6.33-rc5-mm1/include/linux/writeback.h
===================================================================
--- linux-2.6.33-rc5-mm1.orig/include/linux/writeback.h
+++ linux-2.6.33-rc5-mm1/include/linux/writeback.h
@@ -13,6 +13,12 @@ extern spinlock_t inode_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
+static inline int is_flush_bd_task(struct task_struct *task)
+{
+       return task->flags & PF_FLUSHER;
+}
+#define current_is_flush_bd_task()  is_flush_bd_task(current)
+
 /*
  * fs/fs-writeback.c
  */
Index: linux-2.6.33-rc5-mm1/fs/fs-writeback.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.33-rc5-mm1/fs/fs-writeback.c
@@ -605,9 +605,9 @@ static enum sb_pin_state pin_sb_for_writ
  * Return 1, if the caller writeback routine should be
  * interrupted. Otherwise return 0.
  */
-static int writeback_sb_inodes(struct super_block *sb,
-			       struct bdi_writeback *wb,
-			       struct writeback_control *wbc)
+int generic_writeback_sb_inodes(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct writeback_control *wbc)
 {
 	while (!list_empty(&wb->b_io)) {
 		long pages_skipped;
@@ -658,6 +658,32 @@ static int writeback_sb_inodes(struct su
 	/* b_io is empty */
 	return 1;
 }
+EXPORT_SYMBOL(generic_writeback_sb_inodes);
+
+/*
+ * This function is for file systems which have their
+ * own means of periodical write-out of old data.
+ * NOTE: inode_lock should be hold.
+ *
+ * Skip a portion of b_io inodes which belong to @sb
+ * and go sequentially in reverse order.
+ */
+void writeback_skip_sb_inodes(struct super_block *sb,
+			      struct bdi_writeback *wb)
+{
+	while (1) {
+		struct inode *inode;
+
+		if (list_empty(&wb->b_io))
+			break;
+		inode = list_entry(wb->b_io.prev, struct inode, i_list);
+		if (sb != inode->i_sb)
+			break;
+		redirty_tail(inode);
+	}
+}
+EXPORT_SYMBOL(writeback_skip_sb_inodes);
+
 
 static void writeback_inodes_wb(struct bdi_writeback *wb,
 				struct writeback_control *wbc)
@@ -687,7 +713,10 @@ static void writeback_inodes_wb(struct b
 			requeue_io(inode);
 			continue;
 		}
-		ret = writeback_sb_inodes(sb, wb, wbc);
+		if (sb->s_op->writeback_inodes)
+			ret = sb->s_op->writeback_inodes(sb, wb, wbc);
+		else
+			ret = generic_writeback_sb_inodes(sb, wb, wbc);
 
 		if (state == SB_PINNED)
 			unpin_sb_for_writeback(sb);
@@ -704,6 +733,7 @@ void writeback_inodes_wbc(struct writeba
 
 	writeback_inodes_wb(&bdi->wb, wbc);
 }
+EXPORT_SYMBOL(writeback_inodes_wbc);
 
 /*
  * The maximum number of pages to writeout in a single bdi flush/kupdate
@@ -1289,3 +1319,12 @@ int sync_inode(struct inode *inode, stru
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
+/*
+ * Local variables:
+ * c-indentation-style: "K&R"
+ * mode-name: "LC"
+ * c-basic-offset: 8
+ * tab-width: 8
+ * fill-column: 79
+ * End:
+ */
