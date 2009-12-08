Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZLHPEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZLHPEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZLHPEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:04:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbZLHPEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:04:11 -0500
Date: Tue, 8 Dec 2009 10:04:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH] cfq-iosched: Wait for next request if we are about to
	expire the queue
Message-ID: <20091208150412.GC28615@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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

- If think time of process is more than slice left, we will not arm the timer
  and queue will be expired. 

- If we hit the boundary condition where slice has not expired after request
  completion but almost immediately after (4-5 ns), select_queue() hits and
  by that time slice has expired because jiffies has incremented by one.

Gui was hitting the boundary condition and not getting fairness numbers
proportional to weight.

This patch puts the checks for above two conditions and improves the fairness
numbers for sequential workload on rotational media.

Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com> 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Gui Jianfeng <guijiafneng@cn.fujitsu.com>
---
 block/cfq-iosched.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

Index: linux1/block/cfq-iosched.c
===================================================================
--- linux1.orig/block/cfq-iosched.c	2009-12-07 14:40:03.000000000 -0500
+++ linux1/block/cfq-iosched.c	2009-12-07 14:40:04.000000000 -0500
@@ -3251,6 +3251,29 @@ static void cfq_update_hw_tag(struct cfq
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
+	if (cfqq->slice_end - jiffies == 1)
+		return true;
+
+	/* if slice left is less than think time, wait busy */
+	if (cic && sample_valid(cic->ttime_samples)
+	    && (cfqq->slice_end - jiffies < cic->ttime_mean))
+		return true;
+
+	return false;
+}
+
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -3289,11 +3312,10 @@ static void cfq_completed_request(struct
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
