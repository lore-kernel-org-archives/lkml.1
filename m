Return-Path: <linux-kernel-owner+w=401wt.eu-S966839AbZLHWxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966839AbZLHWxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966690AbZLHWw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:52:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966678AbZLHWw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:52:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: jmoyer@redhat.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, guijianfeng@cn.fujitsu.com
Subject: [PATCH 1/2] cfq-iosched: Get rid of cfqq wait_busy_done flag
Date: Tue,  8 Dec 2009 17:52:57 -0500
Message-Id: <1260312778-4725-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Get rid of wait_busy_done flag. This flag only tells we were doing wait
  busy on a queue and that queue got request so expire it. That information
  can easily be obtained by (cfq_cfqq_wait_busy() && queue_is_not_empty). So
  remove this flag and keep code simple.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cfb0b2f..276d765 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -319,7 +319,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
-	CFQ_CFQQ_FLAG_wait_busy_done,	/* Got new request. Expire the queue */
 };
 
 #define CFQ_CFQQ_FNS(name)						\
@@ -348,7 +347,6 @@ CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
 CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
-CFQ_CFQQ_FNS(wait_busy_done);
 #undef CFQ_CFQQ_FNS
 
 #ifdef CONFIG_DEBUG_CFQ_IOSCHED
@@ -1574,7 +1572,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	cfq_clear_cfqq_wait_request(cfqq);
 	cfq_clear_cfqq_wait_busy(cfqq);
-	cfq_clear_cfqq_wait_busy_done(cfqq);
 
 	/*
 	 * store what was left of this slice, if the queue idled/timed out
@@ -2128,11 +2125,17 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 
 	if (!cfqd->rq_queued)
 		return NULL;
+
+	/*
+	 * We were waiting for group to get backlogged. Expire the queue
+	 */
+	if (cfq_cfqq_wait_busy(cfqq) && !RB_EMPTY_ROOT(&cfqq->sort_list))
+		goto expire;
+
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
-	if ((cfq_slice_used(cfqq) || cfq_cfqq_wait_busy_done(cfqq))
-	     && !cfq_cfqq_must_dispatch(cfqq))
+	if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq))
 		goto expire;
 
 	/*
@@ -3165,10 +3168,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
 
 	if (cfqq == cfqd->active_queue) {
-		if (cfq_cfqq_wait_busy(cfqq)) {
-			cfq_clear_cfqq_wait_busy(cfqq);
-			cfq_mark_cfqq_wait_busy_done(cfqq);
-		}
 		/*
 		 * Remember that we saw a request from this process, but
 		 * don't start queuing just yet. Otherwise we risk seeing lots
-- 
1.6.2.5

