Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZJZVoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZJZVoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZJZVoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:44:09 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45379 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZJZVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=qzZislnXrBwHpkE2YMmOy+Zh7BsbeJlTRSbrAehqUMPvO59y4wOJuZ7cQ/Aiu8CYj/
         kFGK7+OuvKful5SqN6obKKSxfkHy0Wb54ehke/nPOa4iE1k+TIWmCLZ++xKvEbYvwB+3
         sLGURdQtzsv/9cuJdqX0gw5Q4cqjJ/deMljwc=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/5] cfq-iosched: adapt slice to number of processes doing I/O
Date: Mon, 26 Oct 2009 22:44:04 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910262244.05130.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the number of processes performing I/O concurrently increases,
a fixed time slice per process will cause large latencies.

This patch, if low_latency mode is enabled,  will scale the time slice
assigned to each process according to a 300ms target latency.

In order to keep fairness among processes:
* The number of active processes is computed using a special form of
running average, that quickly follows sudden increases (to keep latency low),
and decrease slowly (to have fairness in spite of rapid decreases of this
value).

To safeguard sequential bandwidth, we impose a minimum time slice
(computed using 2*cfq_slice_idle as base, adjusted according to priority
and async-ness).

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 47d6aac..95bba2a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -27,6 +27,8 @@ static const int cfq_slice_sync = HZ / 10;
 static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
+static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
+static const int cfq_hist_divisor = 4;
 
 /*
  * offset from end of service tree
@@ -148,6 +150,8 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
+	unsigned int busy_rt_queues;
+	unsigned int busy_queues_avg[2];
 
 	int rq_in_driver[2];
 	int sync_flight;
@@ -315,10 +319,52 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
+/*
+ * get averaged number of queues of RT/BE priority.
+ * average is updated, with a formula that gives more weight to higher numbers,
+ * to quickly follows sudden increases and decrease slowly
+ */
+
+static inline unsigned
+cfq_get_avg_queues(struct cfq_data *cfqd, bool rt) {
+	unsigned min_q, max_q;
+	unsigned mult  = cfq_hist_divisor - 1;
+	unsigned round = cfq_hist_divisor / 2;
+	unsigned busy = cfqd->busy_rt_queues;
+
+	if (!rt)
+		busy = cfqd->busy_queues - cfqd->busy_rt_queues;
+
+	min_q = min(cfqd->busy_queues_avg[rt], busy);
+	max_q = max(cfqd->busy_queues_avg[rt], busy);
+	cfqd->busy_queues_avg[rt] = (mult * max_q + min_q + round) /
+		cfq_hist_divisor;
+	return cfqd->busy_queues_avg[rt];
+}
+
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
+	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
+	if (cfqd->cfq_latency) {
+		/* interested queues (we consider only the ones with the same
+		 * priority class) */
+		unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
+		unsigned sync_slice = cfqd->cfq_slice[1];
+		unsigned expect_latency = sync_slice * iq;
+		if (expect_latency > cfq_target_latency) {
+			unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
+			/* scale low_slice according to IO priority
+			 * and sync vs async */
+			unsigned low_slice =
+				min(slice, base_low_slice * slice / sync_slice);
+			/* the adapted slice value is scaled to fit all iqs
+			 * into the target latency */
+			slice = max(slice * cfq_target_latency / expect_latency,
+				    low_slice);
+		}
+	}
+	cfqq->slice_end = jiffies + slice;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
 
@@ -669,7 +715,8 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
-
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues++;
 	cfq_resort_rr_list(cfqd, cfqq);
 }
 
@@ -692,6 +739,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues--;
 }
 
 /*
-- 
1.6.2.5


