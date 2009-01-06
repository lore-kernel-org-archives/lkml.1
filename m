Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZAFG02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZAFG02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZAFG0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:26:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:44989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZAFG0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:26:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=iUTV4NKxGDdt9tUlPbFzmqSbJuVCYZXvdyakWJI5Mqx6dVXItNHM2YR2P+GJA0CEv
	rCENbluDyAYZXuvE89lPw==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] Allow RT requests to pre-empt ongoing BE timeslice in CFQ.
To: jens.axboe@oracle.com
Cc: nauman@google.com, mikew@google.com, linux-kernel@vger.kernel.org
Date: Mon, 05 Jan 2009 22:26:07 -0800
Message-ID: <20090106062242.6330.27688.stgit@austin.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.143
X-GMailtapped: dpshah
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to pre-empt an ongoing BE timeslice when a RT
request is waiting for the current timeslice to complete. This reduces the
wait time to disk for RT requests from an upper bound of 4 (current value
of cfq_quantum) to 1 disk request.

Signed-off-by: Divyesh Shah <dpshah@google.com>
---
Patch based on 2.6.28 linus tree.

Test Results:
Latency(secs) for the RT task when doing sequential reads from 10G file.
                         only RT | RT + BE | RT + BE + this patch
small (512 byte) reads | 143     | 163     | 146
large (1Mb) reads      | 142     | 158     | 146

 block/cfq-iosched.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..d0ded09 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -54,6 +54,7 @@ static DEFINE_SPINLOCK(ioc_gone_lock);
 
 #define CFQ_PRIO_LISTS		IOPRIO_BE_NR
 #define cfq_class_idle(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_IDLE)
+#define cfq_class_be(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_BE)
 #define cfq_class_rt(cfqq)	((cfqq)->ioprio_class == IOPRIO_CLASS_RT)
 
 #define ASYNC			(0)
@@ -992,13 +993,29 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
  */
 static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 {
-	struct cfq_queue *cfqq;
+	struct cfq_queue *cfqq, *first_cfqq;
 
 	cfqq = cfqd->active_queue;
 	if (!cfqq)
 		goto new_queue;
 
 	/*
+	 * If we have a RT cfqq waiting, then we pre-empt the current BE cfqq
+	 * provided its not already used up its timeslice.
+	 */
+	first_cfqq = cfq_rb_first(&cfqd->service_tree);
+	if (first_cfqq && cfq_class_rt(first_cfqq) &&
+	    cfq_class_be(cfqq) && !cfq_slice_used(cfqq)) {
+		/*
+		 * We simulate this as cfqq timed out so that it gets to bank
+		 * the remaining of its time slice.
+		 */
+		cfq_log_cfqq(cfqd, cfqq, "preempt");
+		cfq_slice_expired(cfqd, 1);
+		goto new_queue;
+	}
+
+	/*
 	 * The active queue has run out of time, expire it and select new.
 	 */
 	if (cfq_slice_used(cfqq))
@@ -1044,6 +1061,7 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	do {
 		struct request *rq;
+		struct cfqq *first_cfqq;
 
 		/*
 		 * follow expired path, else get first next available
@@ -1067,6 +1085,15 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		if (RB_EMPTY_ROOT(&cfqq->sort_list))
 			break;
 
+		/*
+		 * If there is a non-empty RT cfqq waiting for current
+		 * cfqq's timeslice to complete, pre-empt this cfqq
+		 */
+		first_cfqq = cfq_rb_first(&cfqd->service_tree);
+		if (cfq_class_be(cfqq) && first_cfqq &&
+		    cfq_class_rt(first_cfqq))
+			break;
+
 	} while (dispatched < max_dispatch);
 
 	/*
@@ -1797,6 +1824,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (rq_is_meta(rq) && !cfqq->meta_pending)
 		return 1;
 
+	/*
+	 * Allow an RT request to pre-empt an ongoing BE cfqq timeslice.
+	 */
+	if (cfq_class_rt(new_cfqq) && cfq_class_be(cfqq))
+		return 1;
+	
 	if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
 		return 0;
 
@@ -1866,7 +1899,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		/*
 		 * not the active queue - expire current slice if it is
 		 * idle and has expired it's mean thinktime or this new queue
-		 * has some old slice time left and is of higher priority
+		 * has some old slice time left and is of higher priority or
+		 * this new queue is RT and the current one is BE
 		 */
 		cfq_preempt_queue(cfqd, cfqq);
 		cfq_mark_cfqq_must_dispatch(cfqq);

