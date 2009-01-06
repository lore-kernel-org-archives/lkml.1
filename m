Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbZAFJAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbZAFJAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZAFJAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:00:47 -0500
Received: from brick.kernel.dk ([93.163.65.50]:6544 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZAFJAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:00:46 -0500
Date: Tue, 6 Jan 2009 09:59:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: nauman@google.com, mikew@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow RT requests to pre-empt ongoing BE timeslice in CFQ.
Message-ID: <20090106085941.GB32491@kernel.dk>
References: <20090106062242.6330.27688.stgit@austin.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106062242.6330.27688.stgit@austin.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05 2009, Divyesh Shah wrote:
> This patch adds the ability to pre-empt an ongoing BE timeslice when a RT
> request is waiting for the current timeslice to complete. This reduces the
> wait time to disk for RT requests from an upper bound of 4 (current value
> of cfq_quantum) to 1 disk request.
> 
> Signed-off-by: Divyesh Shah <dpshah@google.com>
> ---
> Patch based on 2.6.28 linus tree.
> 
> Test Results:
> Latency(secs) for the RT task when doing sequential reads from 10G file.
>                          only RT | RT + BE | RT + BE + this patch
> small (512 byte) reads | 143     | 163     | 146
> large (1Mb) reads      | 142     | 158     | 146

Results look good. I'm not too keen on doing the rb lookup, how about we
just track pending rt queues instead? Add a counter to cfqd
(busy_rq_queues) and inc/dec that along with busy_queues, then check
that in the two locations? If that value is non-zero, an rt queue should
be returned with cfq_rb_first() as well.

Also, the places that test cfq_class_be() seem more appropriate as
!cfq_class_rt() checks, as that also covers idle queues.

How does the below look to you? It's untested here, but it compiles. I'd
appreciate your comments and testing!

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e8525fa..8640199 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -84,6 +84,7 @@ struct cfq_data {
 	 */
 	struct cfq_rb_root service_tree;
 	unsigned int busy_queues;
+	unsigned int busy_rt_queues;
 
 	int rq_in_driver;
 	int sync_flight;
@@ -562,6 +563,8 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues++;
 
 	cfq_resort_rr_list(cfqd, cfqq);
 }
@@ -581,6 +584,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
+	if (cfq_class_rt(cfqq))
+		cfqd->busy_rt_queues--;
 }
 
 /*
@@ -1005,6 +1010,20 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto expire;
 
 	/*
+	 * If we have RT queues waiting, then we preempt the current non-rt
+	 * cfqq.
+	 */
+	if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues) {
+		/*
+		 * We simulate this as cfqq timed out so that it gets to bank
+		 * the remaining of its time slice.
+		 */
+		cfq_log_cfqq(cfqd, cfqq, "preempt from RT");
+		cfq_slice_expired(cfqd, 1);
+		goto new_queue;
+	}
+
+	/*
 	 * The active queue has requests and isn't expired, allow it to
 	 * dispatch.
 	 */
@@ -1067,6 +1086,12 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		if (RB_EMPTY_ROOT(&cfqq->sort_list))
 			break;
 
+		/*
+		 * If we have pending rt queues, stop dispatching
+		 */
+		if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues)
+			break;
+
 	} while (dispatched < max_dispatch);
 
 	/*
@@ -1801,6 +1826,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_meta(rq) && !cfqq->meta_pending)
 		return 1;
 
+	/*
+	 * Allow an RT request to pre-empt an ongoing BE cfqq timeslice.
+	 */
+	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
+		return 1;
+
 	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
 		return 0;
 

-- 
Jens Axboe

