Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZIOUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZIOUMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZIOUMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:12:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48848 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZIOUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:content-disposition:from:date:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=iGK8cGFo6O3eCaBluarPZT9QoK0W/27zmFIyeHHCIfifoOj1mLPo/X/P/SObpUIkMM
         j35Ledp6s4gnqvcChF4LgY7WN9K/TV38WDwjsBUpJS5erXq+q5HTPA8G7JBDmcVbVO9o
         mGQfnzgRINhojpEO9RstSCUZp2mQ3y9qSRmKs=
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC] cfq: adapt slice to number of processes doing I/O (v2.1)
Content-Disposition: inline
From: Corrado Zoccolo <czoccolo@gmail.com>
Date: Tue, 15 Sep 2009 22:12:53 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909152212.53883.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the number of processes performing I/O concurrently increases,
a fixed time slice per process will cause large latencies.

This (v2.1) patch will scale the time slice assigned to each process,
according to a target latency (tunable from sysfs, default 300ms).

In order to keep fairness among processes, we adopt two devices, w.r.t. v1.

* The number of active processes is computed using a special form of
running average, that quickly follows sudden increases (to keep latency low),
and decrease slowly (to have fairness in spite of rapid decreases of this 
value).

* The idle time is computed using remaining slice as a maximum.

To safeguard sequential bandwidth, we impose a minimum time slice
(computed using 2*cfq_slice_idle as base, adjusted according to priority
and async-ness).

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>

---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0e3814b..ca90d42 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -27,6 +27,8 @@ static const int cfq_slice_sync = HZ / 10;
 static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
+static int cfq_target_latency = HZ * 3/10; /* 300 ms */
+static int cfq_hist_divisor = 4;
 
 /*
  * offset from end of service tree
@@ -134,6 +136,9 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
+	unsigned int busy_queues_avg;
+	unsigned int busy_rt_queues;
+	unsigned int busy_rt_queues_avg;
 
 	int rq_in_driver[2];
 	int sync_flight;
@@ -173,6 +178,8 @@ struct cfq_data {
 	unsigned int cfq_slice[2];
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
+	unsigned int cfq_target_latency;
+	unsigned int cfq_hist_divisor;
 
 	struct list_head cic_list;
 
@@ -301,10 +308,40 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
+static inline unsigned
+cfq_get_interested_queues(struct cfq_data *cfqd, bool rt) {
+	unsigned min_q, max_q;
+	unsigned mult = cfqd->cfq_hist_divisor - 1;
+	unsigned round = cfqd->cfq_hist_divisor / 2;
+	if (rt) {
+		min_q = min(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
+		max_q = max(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
+		cfqd->busy_rt_queues_avg = (mult * max_q + min_q + round) /
+			cfqd->cfq_hist_divisor;
+		return cfqd->busy_rt_queues_avg;
+	} else {
+		min_q = min(cfqd->busy_queues_avg, cfqd->busy_queues);
+		max_q = max(cfqd->busy_queues_avg, cfqd->busy_queues);
+		cfqd->busy_queues_avg = (mult * max_q + min_q + round) /
+			cfqd->cfq_hist_divisor;
+		return cfqd->busy_queues_avg;
+	}
+}
+
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
+	unsigned process_thr = cfqd->cfq_target_latency / cfqd->cfq_slice[1];
+	unsigned iq = cfq_get_interested_queues(cfqd, cfq_class_rt(cfqq));
+	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
+
+	if (iq > process_thr) {
+		unsigned low_slice = 2 * slice * cfqd->cfq_slice_idle
+			/ cfqd->cfq_slice[1];
+		slice = max(slice * process_thr / iq, min(slice, low_slice));
+	}
+
+	cfqq->slice_end = jiffies + slice;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
 
@@ -646,6 +683,8 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues++;
 
 	cfq_resort_rr_list(cfqd, cfqq);
 }
@@ -669,6 +708,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues--;
 }
 
 /*
@@ -1092,7 +1133,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 * fair distribution of slice time for a process doing back-to-back
 	 * seeks. so allow a little bit of time for him to submit a new rq
 	 */
-	sl = cfqd->cfq_slice_idle;
+	sl = min_t(unsigned, cfqd->cfq_slice_idle, cfqq->slice_end - jiffies);
 	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 
@@ -2480,6 +2521,8 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice[1] = cfq_slice_sync;
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
+	cfqd->cfq_target_latency = cfq_target_latency;
+	cfqd->cfq_hist_divisor = cfq_hist_divisor;
 	cfqd->hw_tag = 1;
 
 	return cfqd;
@@ -2549,6 +2592,8 @@ SHOW_FUNCTION(cfq_slice_idle_show, cfqd->cfq_slice_idle, 1);
 SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
+SHOW_FUNCTION(cfq_target_latency_show, cfqd->cfq_target_latency, 1);
+SHOW_FUNCTION(cfq_hist_divisor_show, cfqd->cfq_hist_divisor, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -2580,6 +2625,10 @@ STORE_FUNCTION(cfq_slice_sync_store, &cfqd->cfq_slice[1], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
+
+STORE_FUNCTION(cfq_target_latency_store, &cfqd->cfq_target_latency, 1, 1000, 1);
+STORE_FUNCTION(cfq_hist_divisor_store, &cfqd->cfq_hist_divisor, 1, 100, 0);
+
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -2595,6 +2644,8 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_async),
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
+	CFQ_ATTR(target_latency),
+	CFQ_ATTR(hist_divisor),
 	__ATTR_NULL
 };
 

