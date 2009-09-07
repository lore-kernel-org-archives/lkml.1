Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZIGO5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZIGO5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZIGO5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:57:46 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64801 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZIGO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fBBt07qAR+RM2rQ63NTL46ZUtVEOtrwaetqJFm/k1Gm3zb2w7JFTfyt2MK7h0v3Kjt
         UCV2XmQMVeKCSGi9ugtKRvLqavjCaMedNfrMKszmC9Gv1Bfza5meQyI9KR2vaOqCnmu2
         kwIg856UE52RyCm/c1tU1l9A3F3XssY1oKKgY=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
Date: Mon, 7 Sep 2009 16:57:50 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31cz; KDE/4.2.4; i686; ; )
Cc: Jeff Moyer <jmoyer@redhat.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com> <4e5e476b0909030936l66ac3f22jd3b43d38bca0249b@mail.gmail.com> <20090905161635.GI18599@kernel.dk>
In-Reply-To: <20090905161635.GI18599@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909071657.50954.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sat, Sep 05 2009 18:16:35, Jens Axboe wrote:
: > On Thu, Sep 03 2009, Corrado Zoccolo wrote:
> > Hi Jens,
> >
> > [snip]
> >
> > This is the reason that I have a minimum slice. It is already reached
> > for 32 processes as in my example, so the throughput drop is at most
> > 20%.
> > Currently it is computed as 2*slice_idle for sync, and 1*slice_idle
> > for async queues.
> > I think this causes the leveling of data transferred regardless of
> > priorities. I'll cook up a formula to better scale also the minimum
> > slice according to priority, to fix this issue.
>
> For your case, it may be different for other hardware. But I think the
> approach is sane to some degree, it'll require more work though. One
> problem is that the count of busy queues will fluctuate a lot for sync
> IO, so you'll have fairness issues. The number of potentially interested
> processes needs to be a rolling average of some sort, not just looking
> at ->busy_queues.
here is the new patch, with the improved formula for minimum time slice,
and with rolling average for number of processes doing I/O.
The average is computed in such a way that it can quickly follow
sudden increases (to keep latency low),
and decrease slowly (to have fairness in spite of rapid decreases of this value).

I added 2 tunables, for testing:
* the preferred latency, used to compute the threshold on number of processes (that was hardcoded in previous version).
* the divisor in the averaging formula, to alter the weights (weights are computed as 1/d and (d-1)/d).
they can be removed if/when we find the optimal values.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd7080e..b200b13 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -27,6 +27,8 @@ static const int cfq_slice_sync = HZ / 10;
 static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
+static int cfq_preferred_latency = HZ * 3/10; /* 300 ms */
+static int cfq_queue_hist_divisor = 4;
 
 /*
  * offset from end of service tree
@@ -134,11 +136,13 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
+	unsigned int busy_queues_avg;
 	/*
 	 * Used to track any pending rt requests so we can pre-empt current
 	 * non-RT cfqq in service when this value is non-zero.
 	 */
 	unsigned int busy_rt_queues;
+	unsigned int busy_rt_queues_avg;
 
 	int rq_in_driver;
 	int sync_flight;
@@ -178,6 +182,8 @@ struct cfq_data {
 	unsigned int cfq_slice[2];
 	unsigned int cfq_slice_async_rq;
 	unsigned int cfq_slice_idle;
+	unsigned int cfq_preferred_latency;
+	unsigned int cfq_queue_hist_divisor;
 
 	struct list_head cic_list;
 
@@ -303,10 +309,37 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
+static inline unsigned
+cfq_get_interested_queues(struct cfq_data *cfqd, bool rt) {
+	unsigned min_q, max_q;
+	unsigned mult = cfqd->cfq_queue_hist_divisor -1;
+	unsigned round = cfqd->cfq_queue_hist_divisor / 2;
+	if (rt) {
+		min_q = min(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
+		max_q = max(cfqd->busy_rt_queues_avg, cfqd->busy_rt_queues);
+		cfqd->busy_rt_queues_avg = (mult * max_q + min_q + round) / cfqd->cfq_queue_hist_divisor;
+		return cfqd->busy_rt_queues_avg;
+	} else {
+		min_q = min(cfqd->busy_queues_avg, cfqd->busy_queues);
+		max_q = max(cfqd->busy_queues_avg, cfqd->busy_queues);
+		cfqd->busy_queues_avg = (mult * max_q + min_q + round) / cfqd->cfq_queue_hist_divisor;
+		return cfqd->busy_queues_avg;
+	}
+}
+
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
+	unsigned process_threshold = cfqd->cfq_preferred_latency / cfqd->cfq_slice[1];
+	unsigned interested_queues = cfq_get_interested_queues(cfqd, cfq_class_rt(cfqq));
+	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
+
+	if (interested_queues > process_threshold) {
+		unsigned low_slice = min(slice, 2 * slice * cfqd->cfq_slice_idle / cfqd->cfq_slice[1]);
+		slice = max(slice * process_threshold / interested_queues, low_slice);
+	}
+
+	cfqq->slice_end = jiffies + slice;
 	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
 }
 
@@ -2494,6 +2527,8 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice[1] = cfq_slice_sync;
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
+	cfqd->cfq_preferred_latency = cfq_preferred_latency;
+	cfqd->cfq_queue_hist_divisor = cfq_queue_hist_divisor;
 	cfqd->hw_tag = 1;
 
 	return cfqd;
@@ -2563,6 +2598,8 @@ SHOW_FUNCTION(cfq_slice_idle_show, cfqd->cfq_slice_idle, 1);
 SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
+SHOW_FUNCTION(cfq_preferred_latency_show, cfqd->cfq_preferred_latency, 1);
+SHOW_FUNCTION(cfq_queue_hist_divisor_show, cfqd->cfq_queue_hist_divisor, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -2594,6 +2631,10 @@ STORE_FUNCTION(cfq_slice_sync_store, &cfqd->cfq_slice[1], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
+
+STORE_FUNCTION(cfq_preferred_latency_store, &cfqd->cfq_preferred_latency, 1, 1000, 1);
+STORE_FUNCTION(cfq_queue_hist_divisor_store, &cfqd->cfq_queue_hist_divisor, 1, 100, 0);
+
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -2609,6 +2650,8 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_async),
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
+	CFQ_ATTR(preferred_latency),
+	CFQ_ATTR(queue_hist_divisor),
 	__ATTR_NULL
 };
 

