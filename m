Return-Path: <linux-kernel-owner+w=401wt.eu-S966824AbZLHWxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966824AbZLHWxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966687AbZLHWw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:52:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965737AbZLHWw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:52:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: jmoyer@redhat.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, guijianfeng@cn.fujitsu.com
Subject: [PATCH 2/2] cfq-iosched: Take care of corner cases of group losing share due to deletion
Date: Tue,  8 Dec 2009 17:52:58 -0500
Message-Id: <1260312778-4725-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1260312778-4725-1-git-send-email-vgoyal@redhat.com>
References: <1260312778-4725-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a sequential reader running in a group, we wait for next request
to come in that group after slice expiry and once new request is in, we expire
the queue. Otherwise we delete the group from service tree and group looses
its fair share.

So far I was marking a queue as wait_busy if it had consumed its slice and
it was last queue in the group. But this condition did not cover following
two cases.

1.If a request completed and slice has not expired yet. Next request comes
  in and is dispatched to disk. Now select_queue() hits and slice has expired.
  This group will be deleted. Because request is still in the disk, this queue
  will never get a chance to wait_busy.

2.If request completed and slice has not expired yet. Before next request
  comes in (delay due to think time), select_queue() hits and expires the
  queue hence group. This queue never got a chance to wait busy.

Gui was hitting the boundary condition 1 and not getting fairness numbers
proportional to weight.

This patch puts the checks for above two conditions and improves the fairness
numbers for sequential workload on rotational media. Check in select_queue()
takes care of case 1 and additional check in should_wait_busy() takes care
of case 2.

Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   55 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 276d765..50da108 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2135,8 +2135,22 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
-	if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq))
-		goto expire;
+	if (cfq_slice_used(cfqq) && !cfq_cfqq_must_dispatch(cfqq)) {
+		/*
+		 * If slice had not expired at the completion of last request
+		 * we might not have turned on wait_busy flag. Don't expire
+		 * the queue yet. Allow the group to get backlogged.
+		 *
+		 * The very fact that we have used the slice, that means we
+		 * have been idling all along on this queue and it should be
+		 * ok to wait for this request to complete.
+		 */
+		if (cfqq->cfqg->nr_cfqq == 1 && cfqq->dispatched
+		    && cfq_should_idle(cfqd, cfqq))
+			goto keep_queue;
+		else
+			goto expire;
+	}
 
 	/*
 	 * The active queue has requests and isn't expired, allow it to
@@ -3250,6 +3264,36 @@ static void cfq_update_hw_tag(struct cfq_data *cfqd)
 		cfqd->hw_tag = 0;
 }
 
+static inline bool
+cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	struct cfq_io_context *cic = cfqd->active_cic;
+
+	/* If there are other queues in the group, don't wait */
+	if (cfqq->cfqg->nr_cfqq > 1)
+		return false;
+
+	if (cfq_slice_used(cfqq))
+		return true;
+
+	/* if slice left is less than think time, wait busy */
+	if (cic && sample_valid(cic->ttime_samples)
+	    && (cfqq->slice_end - jiffies < cic->ttime_mean))
+		return true;
+
+	/*
+	 * If think times is less than a jiffy than ttime_mean=0 and above
+	 * will not be true. It might happen that slice has not expired yet
+	 * but will expire soon (4-5 ns) during select_queue(). To cover the
+	 * case where think time is less than a jiffy, mark the queue wait
+	 * busy if only 1 jiffy is left in the slice.
+	 */
+	if (cfqq->slice_end - jiffies == 1)
+		return true;
+
+	return false;
+}
+
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -3288,11 +3332,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		}
 
 		/*
-		 * If this queue consumed its slice and this is last queue
-		 * in the group, wait for next request before we expire
-		 * the queue
+		 * Should we wait for next request to come in before we expire
+		 * the queue.
 		 */
-		if (cfq_slice_used(cfqq) && cfqq->cfqg->nr_cfqq == 1) {
+		if (cfq_should_wait_busy(cfqd, cfqq)) {
 			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
 			cfq_mark_cfqq_wait_busy(cfqq);
 		}
-- 
1.6.2.5

