Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZGGQQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZGGQQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbZGGQPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:15:42 -0400
Received: from smtp.nokia.com ([192.100.122.233]:60597 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745AbZGGQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:15:40 -0400
From: Artem Bityutskiy <dedekind1@nokia.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 21:05:56 +0300
Message-Id: <20090707180556.17048.53072.sendpatchset@localhost.localdomain>
In-Reply-To: <20090707180541.17048.49901.sendpatchset@localhost.localdomain>
References: <20090707180541.17048.49901.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/2] writeback: optimize periodic sync_supers
X-OriginalArrivalTime: 07 Jul 2009 16:15:21.0648 (UTC) FILETIME=[20855300:01C9FF1E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] writeback: optimize periodic sync_supers

The sync_supers thread wakes up every 5 seconds (by default) and
writes back all super blocks. It keeps waking up even if there
are no dirty super-blocks.

This patch improves it and makes sleep if there is nothing to do.
This optimization is quite important for small battery-powered
devices.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/fs.h |    5 +----
 mm/backing-dev.c   |   34 +++++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d98d8d1..b968f43 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1793,10 +1793,7 @@ int __put_super_and_need_restart(struct super_block *sb);
  * Note, VFS does not provide any protection for the super block clean/dirty
  * state. File-systems should take care of this.
  */
-static inline void mark_sb_dirty(struct super_block *sb)
-{
-	sb->s_dirt = 1;
-}
+void mark_sb_dirty(struct super_block *sb);
 static inline void mark_sb_clean(struct super_block *sb)
 {
 	sb->s_dirt = 0;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 75e6c47..4501626 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -32,6 +32,8 @@ LIST_HEAD(bdi_pending_list);
 
 static struct task_struct *sync_supers_tsk;
 static struct timer_list sync_supers_timer;
+static int supers_timer_armed;
+static DEFINE_SPINLOCK(supers_timer_lock);
 
 static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
@@ -440,6 +442,11 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
  * or we risk deadlocking on ->s_umount. The longer term solution would be
  * to implement sync_supers_bdi() or similar and simply do it from the
  * bdi writeback tasks individually.
+ *
+ * Historically this thread woke up periodically, regardless of whether
+ * there was any dirty super block. However, nowadays it is optimized to
+ * wake up only when there is something to sync - this is better from the
+ * power management point of view.
  */
 static int bdi_sync_supers(void *unused)
 {
@@ -449,10 +456,22 @@ static int bdi_sync_supers(void *unused)
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 
+		spin_lock(&supers_timer_lock);
+		supers_timer_armed = -1;
+		spin_unlock(&supers_timer_lock);
+
 		/*
 		 * Do this periodically, like kupdated() did before.
 		 */
 		sync_supers();
+
+		spin_lock(&supers_timer_lock);
+		if (supers_timer_armed == 1)
+			/* A super block was marked as dirty meanwhile */
+			arm_supers_timer();
+		else
+			supers_timer_armed = 0;
+		spin_unlock(&supers_timer_lock);
 	}
 
 	return 0;
@@ -469,9 +488,22 @@ static void arm_supers_timer(void)
 static void sync_supers_timer_fn(unsigned long unused)
 {
 	wake_up_process(sync_supers_tsk);
-	arm_supers_timer();
 }
 
+void mark_sb_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+	spin_lock(&supers_timer_lock);
+	if (!supers_timer_armed) {
+		arm_supers_timer();
+		supers_timer_armed = 1;
+	} else if (supers_timer_armed == -1) {
+		supers_timer_armed = 1;
+	}
+	spin_unlock(&supers_timer_lock);
+}
+EXPORT_SYMBOL(mark_sb_dirty);
+
 static int bdi_forker_task(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
-- 
1.6.0.6

