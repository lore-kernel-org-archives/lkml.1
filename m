Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbZJTSL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbZJTSL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJTSL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:11:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23407 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZJTSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=mmd9LJ9Pm4vMv8/AKaRk1hSgkeiGysmDiwMg/+i+ah1BAYUbwZp06CipWt4jnEuNFr
         e/vW0z7LSdDgsYWAPwRBD6/4H2OlekJcGxvN5T6A/QOtoYI+vLqdIYc8c7GOW+bBOFO3
         iW1LO7Mse7L3yBSbh55Kb3tchisZFpqzm06Co=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC V2 PATCH 1/5] cfq-iosched: adapt slice to number of processes doing I/O
Date: Tue, 20 Oct 2009 20:11:53 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910202011.53858.czoccolo@gmail.com>
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
 block/cfq-iosched.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 069a610..25a3f46 100644
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
@@ -134,6 +136,8 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
+	unsigned int busy_rt_queues;
+	unsigned int busy_queues_avg[2];
 
 	int rq_in_driver[2];
 	int sync_flight;
@@ -301,10 +305,45 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
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
+		unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
+		unsigned process_thr = cfq_target_latency / cfqd->cfq_slice[1];
+		if (iq > process_thr) {
+			unsigned low_slice = 2 * slice * cfqd->cfq_slice_idle
+				/ cfqd->cfq_slice[1];
+			slice = max(slice * cfq_target_latency /
+				(cfqd->cfq_slice[1] * iq),
+				min(slice, low_slice));
+		}
+	}
+	cfqq->slice_end = jiffies + slice;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
 
@@ -655,7 +694,8 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
-
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues++;
 	cfq_resort_rr_list(cfqd, cfqq);
 }
 
@@ -678,6 +718,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues--;
 }
 
 /*
-- 
1.6.2.5


