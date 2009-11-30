Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZK3DC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZK3DC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZK3DBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbZK3DAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 17/21] blkio: Wait for cfq queue to get backlogged if group is empty
Date: Sun, 29 Nov 2009 21:59:24 -0500
Message-Id: <1259549968-10369-18-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o If a queue consumes its slice and then gets deleted from service tree, its
  associated group will also get deleted from service tree if this was the
  only queue in the group. That will make group loose its share.

o For the queues on which we have idling on and if these have used their
  slice, wait a bit for these queues to get backlogged again and then
  expire these queues so that group does not loose its share.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a9fea9e..52d504b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -116,6 +116,7 @@ struct cfq_queue {
 
 	/* time when queue got scheduled in to dispatch first request. */
 	unsigned long dispatch_start;
+	unsigned int allocated_slice;
 	/* time when first request from queue completed and slice started. */
 	unsigned long slice_start;
 	unsigned long slice_end;
@@ -313,6 +314,8 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
+	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
+	CFQ_CFQQ_FLAG_wait_busy_done,	/* Got new request. Expire the queue */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -340,6 +343,8 @@ CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(deep);
+CFQ_CFQQ_FNS(wait_busy);
+CFQ_CFQQ_FNS(wait_busy_done);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_DEBUG_CFQ_IOSCHED
@@ -575,6 +580,7 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	}
 	cfqq->slice_start = jiffies;
 	cfqq->slice_end = jiffies + slice;
+	cfqq->allocated_slice = slice;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
 
@@ -861,7 +867,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 {
-	unsigned int slice_used, allocated_slice;
+	unsigned int slice_used;
 
 	/*
 	 * Queue got expired before even a single request completed or
@@ -878,9 +884,8 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 					1);
 	} else {
 		slice_used = jiffies - cfqq->slice_start;
-		allocated_slice = cfqq->slice_end - cfqq->slice_start;
-		if (slice_used > allocated_slice)
-			slice_used = allocated_slice;
+		if (slice_used > cfqq->allocated_slice)
+			slice_used = cfqq->allocated_slice;
 	}
 
 	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u sect=%lu", slice_used,
@@ -1497,6 +1502,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfq_log_cfqq(cfqd, cfqq, "set_active");
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
+		cfqq->allocated_slice = 0;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
 		cfqq->nr_sectors = 0;
@@ -1526,6 +1532,8 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		del_timer(&cfqd->idle_slice_timer);
 
 	cfq_clear_cfqq_wait_request(cfqq);
+	cfq_clear_cfqq_wait_busy(cfqq);
+	cfq_clear_cfqq_wait_busy_done(cfqq);
 
 	/*
 	 * store what was left of this slice, if the queue idled/timed out
@@ -2068,7 +2076,8 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
-	if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq))
+	if ((cfq_slice_used(cfqq) || cfq_cfqq_wait_busy_done(cfqq))
+	     && !cfq_cfqq_must_dispatch(cfqq))
 		goto expire;
 
 	/*
@@ -3098,6 +3107,10 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
 
 	if (cfqq == cfqd->active_queue) {
+		if (cfq_cfqq_wait_busy(cfqq)) {
+			cfq_clear_cfqq_wait_busy(cfqq);
+			cfq_mark_cfqq_wait_busy_done(cfqq);
+		}
 		/*
 		 * Remember that we saw a request from this process, but
 		 * don't start queuing just yet. Otherwise we risk seeing lots
@@ -3216,6 +3229,17 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			cfq_set_prio_slice(cfqd, cfqq);
 			cfq_clear_cfqq_slice_new(cfqq);
 		}
+
+		/*
+		 * If this queue consumed its slice and this is last queue
+		 * in the group, wait for next request before we expire
+		 * the queue
+		 */
+		if (cfq_slice_used(cfqq) && cfqq->cfqg->nr_cfqq == 1) {
+			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
+			cfq_mark_cfqq_wait_busy(cfqq);
+		}
+
 		/*
 		 * Idling is not enabled on:
 		 * - expired queues
-- 
1.6.2.5

