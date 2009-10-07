Return-Path: <linux-kernel-owner+w=401wt.eu-S934074AbZJGIDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbZJGIDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934045AbZJGIC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:02:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934061AbZJGICy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195972033"
Message-Id: <20091007074905.569676747@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:52 +0800
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
Subject: [PATCH 34/45] writeback: sync livelock - kick background writeback
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-sync-pending.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The periodic/background writeback can run forever. So when any
sync work is enqueued, increase bdi->sync_works to notify the
active non-sync works to exit. Non-sync works queued after all sync
works won't be affected.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   11 +++++++++++
 include/linux/backing-dev.h |    5 +++++
 mm/backing-dev.c            |    1 +
 3 files changed, 17 insertions(+)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:39:33.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:39:33.000000000 +0800
@@ -139,6 +139,8 @@ static void wb_clear_pending(struct bdi_
 		list_del_rcu(&work->list);
 		if (work->args.for_background)
 			clear_bit(WB_FLAG_BACKGROUND_WORK, &bdi->wb_mask);
+		if (work->args.for_sync)
+			bdi->sync_works--;
 		spin_unlock(&bdi->wb_lock);
 
 		wb_work_complete(work);
@@ -159,6 +161,8 @@ static void bdi_queue_work(struct backin
 	 */
 	spin_lock(&bdi->wb_lock);
 	list_add_tail_rcu(&work->list, &bdi->work_list);
+	if (work->args.for_sync)
+		bdi->sync_works++;
 	spin_unlock(&bdi->wb_lock);
 
 	/*
@@ -811,6 +815,13 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
+		 * background/periodic works can run forever, need to abort
+		 * on seeing any pending sync work, to prevent livelock it.
+		 */
+		if (!args->for_sync && wb->bdi->sync_works > 0)
+			break;
+
+		/*
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
--- linux.orig/include/linux/backing-dev.h	2009-10-06 23:39:33.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-06 23:39:33.000000000 +0800
@@ -84,6 +84,11 @@ struct backing_dev_info {
 	struct list_head wb_list; /* the flusher threads hanging off this bdi */
 	unsigned long wb_mask;	  /* bitmask of registered tasks */
 	unsigned int wb_cnt;	  /* number of registered tasks */
+	/*
+	 * sync works queued, background works shall abort on seeing this,
+	 * to prevent livelocking the sync works
+	 */
+	unsigned int sync_works;
 
 	struct list_head work_list;
 
--- linux.orig/mm/backing-dev.c	2009-10-06 23:38:52.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-06 23:39:33.000000000 +0800
@@ -647,6 +647,7 @@ int bdi_init(struct backing_dev_info *bd
 	 */
 	bdi->wb_mask = 1;
 	bdi->wb_cnt = 1;
+	bdi->sync_works = 0;
 
 	bdi->write_bandwidth = MAX_WRITEBACK_PAGES;
 


