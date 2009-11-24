Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbZKXNtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbZKXNtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbZKXNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:49:44 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:53626 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbZKXNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=L6575Clmm1t2ShxZCGSLIWTDG6zeiDgKl9YGnzfMcDoU9O/649qGxMhbC9xQ9Fso7S
         +nqo/brs5NL9sHwB1UsAPOHlw3SVYZhGiaguEbKMbQ83W2+FkDJhWa2qkPI8AAnYSTWI
         e5qPLPUxHCOpT9tDPboen/2VcKHejXq5+7m/s=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 4/4] cfq-iosched: fix corner cases in idling logic
Date: Tue, 24 Nov 2009 14:49:36 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911241449.36336.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idling logic was disabled in some corner cases, leading to unfair share
for noidle queues.
* the idle timer was not armed if there were other requests in the
  driver. unfortunately, those requests could come from other workloads,
  or queues for which we don't enable idling. So we will check only
  pending requests from the active queue
* rq_noidle check on no-idle queue could disable the end of tree idle if
  the last completed request was rq_noidle. Now, we will disable that
  idle only if all the queues served in the no-idle tree had rq_noidle
  requests.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 373e80f..d44f8a4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -172,6 +172,7 @@ struct cfq_data {
 	enum wl_prio_t serving_prio;
 	enum wl_type_t serving_type;
 	unsigned long workload_expires;
+	bool noidle_tree_requires_idle;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -1249,9 +1250,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 		return;
 
 	/*
-	 * still requests with the driver, don't idle
+	 * still active requests from this queue, don't idle
 	 */
-	if (rq_in_driver(cfqd))
+	if (cfqq->dispatched)
 		return;
 
 	/*
@@ -1487,6 +1488,7 @@ static void choose_service_tree(struct cfq_data *cfqd)
 
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
 	cfqd->workload_expires = jiffies + slice;
+	cfqd->noidle_tree_requires_idle = false;
 }
 
 /*
@@ -2606,17 +2608,27 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			cfq_clear_cfqq_slice_new(cfqq);
 		}
 		/*
-		 * If there are no requests waiting in this queue, and
-		 * there are other queues ready to issue requests, AND
-		 * those other queues are issuing requests within our
-		 * mean seek distance, give them a chance to run instead
-		 * of idling.
+		 * Idling is not enabled on:
+		 * - expired queues
+		 * - idle-priority queues
+		 * - async queues
+		 * - queues with still some requests queued
+		 * - when there is a close cooperator
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
-		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq) &&
-			 sync && !rq_noidle(rq))
-			cfq_arm_slice_timer(cfqd);
+		else if (sync && cfqq_empty &&
+			 !cfq_close_cooperator(cfqd, cfqq)) {
+			cfqd->noidle_tree_requires_idle |= !rq_noidle(rq);
+			/*
+			 * Idling is enabled for SYNC_WORKLOAD.
+			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
+			 * only if we processed at least one !rq_noidle request
+			 */
+			if (cfqd->serving_type == SYNC_WORKLOAD
+			    || cfqd->noidle_tree_requires_idle)
+				cfq_arm_slice_timer(cfqd);
+		}
 	}
 
 	if (!rq_in_driver(cfqd))
-- 
1.6.2.5


