Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbZE0LSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbZE0LSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761566AbZE0LNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:13:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:65325 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761535AbZE0LNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:13:23 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:07:06 +0300
Message-Id: <20090527130706.4913.42520.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/19] periodic write-back: do not wake up unnecessarily
X-OriginalArrivalTime: 27 May 2009 11:13:05.0345 (UTC) FILETIME=[1B815B10:01C9DEBC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] periodic write-back: do not wake up unnecessarily

This patch is an optimization which is targeted to lessen
power consumption.

At the moment the periodic write-back thread (pdflush) is
woken up every 5 seconds (by default). It wake up and
writes back old dirty dirty data. And even if there are
no dirty data, the thread keeps waking up to find no
dirty data. And it repeats this every 5 seconds.

This patch makes the periodic write-back thread wake up
only when there are dirty data. Otherwise it just sleeps
and does not disturb CPU. Indeed, CPU may be resting in
a low frequency and low power consumption mode - why do
we have to distract it unnecessarily?

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/fs-writeback.c   |   41 ++++++++++++++++++++++++++++
 include/linux/fs.h  |    7 ++---
 mm/page-writeback.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 114 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e0fb2e7..133944c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -65,6 +65,24 @@ static void writeback_release(struct backing_dev_info *bdi)
 }
 
 /**
+ * enable_pwb - enable periodic write-back after an inode was marked as dirty.
+ * @inode: the inode which was marked as dirty
+ *
+ * This is a helper function for '__mark_inode_dirty()' which enables the
+ * periodic write-back, unless:
+ *   * the backing device @inode belongs to does not support write-back;
+ *   * periodic write-back is already enabled.
+ */
+static void enable_pwb(struct inode *inode)
+{
+	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+
+	if (bdi_cap_writeback_dirty(bdi) &&
+	    atomic_add_unless(&periodic_wb_enabled, 1, 1))
+		enable_periodic_wb();
+}
+
+/**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
  *	@flags: what kind of dirty (i.e. I_DIRTY_SYNC)
@@ -164,6 +182,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		if (!was_dirty) {
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
+			enable_pwb(inode);
 		}
 	}
 out:
@@ -172,6 +191,28 @@ out:
 
 EXPORT_SYMBOL(__mark_inode_dirty);
 
+/**
+ * mark_sb_dirty - mark super block as dirty.
+ * @sb: the super block to mark as dirty
+ *
+ * This function marks super block @sb as dirty and enables the periodic
+ * write-back, unless it is already enabled. Note, VFS does not serialize the
+ * super block clean/dirty (@sb->s_dirt) state changes, and each FS is
+ * responsible for doing its own serialization.
+ */
+void mark_sb_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+	/*
+	 * If 'periodic_wb_enabled' is 0, set it to 1 and enable the periodic
+	 * write-back.
+	 */
+	if (atomic_add_unless(&periodic_wb_enabled, 1, 1))
+		enable_periodic_wb();
+}
+
+EXPORT_SYMBOL(mark_sb_dirty);
+
 static int write_inode(struct inode *inode, int sync)
 {
 	if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 437939c..230e308 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1782,10 +1782,9 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 
-static inline void mark_sb_dirty(struct super_block *sb)
-{
-	sb->s_dirt = 1;
-}
+extern atomic_t periodic_wb_enabled;
+extern void enable_periodic_wb(void);
+extern void mark_sb_dirty(struct super_block *sb);
 static inline void mark_sb_clean(struct super_block *sb)
 {
 	sb->s_dirt = 0;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 8a213a9..1cbb858 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -736,6 +736,9 @@ static void laptop_timer_fn(unsigned long unused);
 
 static DEFINE_TIMER(wb_timer, wb_timer_fn, 0, 0);
 static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
+static DEFINE_SPINLOCK(wb_timer_lock);
+
+atomic_t periodic_wb_enabled;
 
 /*
  * Setup the periodic write-back timer to expires at @expires jiffies. If
@@ -753,6 +756,67 @@ static void setup_wb_timer(unsigned long expires)
 }
 
 /*
+ * Enable the periodic write-back. This function is usually called when
+ * an inode or a super block becomes dirty.
+ */
+void enable_periodic_wb(void)
+{
+	if (dirty_writeback_interval) {
+		spin_lock(&wb_timer_lock);
+		setup_wb_timer(0);
+		spin_unlock(&wb_timer_lock);
+	}
+}
+
+static void set_next_wb_timer(unsigned long expires)
+{
+	int all_clean = 1;
+	struct super_block *sb;
+
+	atomic_set(&periodic_wb_enabled, 0);
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_dirt)
+			break;
+
+		spin_lock(&inode_lock);
+		if (sb_has_dirty_inodes(sb)) {
+			struct inode *inode;
+			struct backing_dev_info *bdi;
+
+			inode = list_entry(sb->s_inodes.next,
+					   struct inode, i_sb_list);
+			bdi = inode->i_mapping->backing_dev_info;
+			if (bdi_cap_writeback_dirty(bdi)) {
+				spin_unlock(&inode_lock);
+				all_clean = 0;
+				break;
+			}
+		}
+		spin_unlock(&inode_lock);
+	}
+	spin_unlock(&sb_lock);
+
+	spin_lock(&wb_timer_lock);
+	if (all_clean && atomic_read(&periodic_wb_enabled)) {
+		/*
+		 * There are no dirty data, and no one marked an inode or
+		 * super block as dirty. The periodic update timer may be
+		 * deleted. Note, if we race with some other task which has
+		 * just marked something as dirty and just set
+		 * 'periodic_wb_enabled' to 1, then this task will call
+		 * 'enable_periodic_wb()' which will re-enable the 'wb_timer'.
+		 */
+		del_timer(&wb_timer);
+	} else {
+		atomic_set(&periodic_wb_enabled, 1);
+		setup_wb_timer(expires);
+	}
+	spin_unlock(&wb_timer_lock);
+}
+
+/*
  * Periodic writeback of "old" data.
  *
  * Define "old": the first time one of an inode's pages is dirtied, we mark the
@@ -804,10 +868,12 @@ static void wb_kupdate(unsigned long arg)
 		}
 		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 	}
-	if (time_before(next_jif, jiffies + HZ))
-		next_jif = jiffies + HZ;
-	if (dirty_writeback_interval)
-		setup_wb_timer(next_jif);
+
+	if (dirty_writeback_interval) {
+		if (time_before(next_jif, jiffies + HZ))
+			next_jif = jiffies + HZ;
+		set_next_wb_timer(next_jif);
+	}
 }
 
 /*
-- 
1.6.0.6

