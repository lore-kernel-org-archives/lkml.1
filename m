Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbZJGIBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbZJGIBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933487AbZJGIBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:58309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933416AbZJGIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971249"
Message-Id: <20091007074903.307800809@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/45] writeback: only allow two background writeback works
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-limit-background-work.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balance_dirty_pages() need a reliable way to ensure some background work
is scheduled for running. We cannot simply run bdi_start_writeback()
because that would queue up huge number of works (which takes memory and
time).

CC: Jens Axboe <jens.axboe@oracle.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   14 ++------------
 include/linux/backing-dev.h |   26 +++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 13 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:38:42.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:38:43.000000000 +0800
@@ -85,18 +85,6 @@ static inline void bdi_work_init(struct 
 int sysctl_dirty_debug __read_mostly;
 
 
-/**
- * writeback_in_progress - determine whether there is writeback in progress
- * @bdi: the device's backing_dev_info structure.
- *
- * Determine whether there is writeback waiting to be handled against a
- * backing device.
- */
-int writeback_in_progress(struct backing_dev_info *bdi)
-{
-	return !list_empty(&bdi->work_list);
-}
-
 static void bdi_work_clear(struct bdi_work *work)
 {
 	clear_bit(WS_USED_B, &work->state);
@@ -147,6 +135,8 @@ static void wb_clear_pending(struct bdi_
 
 		spin_lock(&bdi->wb_lock);
 		list_del_rcu(&work->list);
+		if (work->args.for_background)
+			clear_bit(WB_FLAG_BACKGROUND_WORK, &bdi->wb_mask);
 		spin_unlock(&bdi->wb_lock);
 
 		wb_work_complete(work);
--- linux.orig/include/linux/backing-dev.h	2009-10-06 23:37:47.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-06 23:38:43.000000000 +0800
@@ -94,6 +94,11 @@ struct backing_dev_info {
 #endif
 };
 
+/*
+ * background work queued, set to avoid redundant background works
+ */
+#define WB_FLAG_BACKGROUND_WORK		30
+
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
@@ -248,7 +253,26 @@ int bdi_set_max_ratio(struct backing_dev
 extern struct backing_dev_info default_backing_dev_info;
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page);
 
-int writeback_in_progress(struct backing_dev_info *bdi);
+/**
+ * writeback_in_progress - determine whether there is writeback in progress
+ * @bdi: the device's backing_dev_info structure.
+ *
+ * Determine whether there is writeback waiting to be handled against a
+ * backing device.
+ */
+static inline int writeback_in_progress(struct backing_dev_info *bdi)
+{
+	return !list_empty(&bdi->work_list);
+}
+
+/*
+ * Helper to limit # of background writeback works in circulation to 2.
+ * (one running and another queued)
+ */
+static inline int can_submit_background_writeback(struct backing_dev_info *bdi)
+{
+       return !test_and_set_bit(WB_FLAG_BACKGROUND_WORK, &bdi->wb_mask);
+}
 
 static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {


