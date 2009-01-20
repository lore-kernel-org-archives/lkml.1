Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbZATXKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbZATXKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZATXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:10:10 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:54406 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbZATXKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:10:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEALjmdUlMQWt2/2dsb2JhbACBbchlhXM
Date: Tue, 20 Jan 2009 18:05:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ben Gamari <bgamari@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andrea Arcangeli <andrea@suse.de>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090120230505.GA9608@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk> <720e76b80901201222m72ae2e98l972c81ef5886a12e@mail.gmail.com> <720e76b80901201423p6b82aa77kdfbf3eddb8592bd5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <720e76b80901201423p6b82aa77kdfbf3eddb8592bd5@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:03:33 up 19 days, 23:01,  2 users,  load average: 0.59, 0.48,
	0.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ben Gamari (bgamari@gmail.com) wrote:
> The kernel build finally finished. Unfortunately, it crashes quickly
> after booting with moderate disk IO, bringing down the entire machine.
> For this reason, I haven't been able to complete a fio benchmark.
> Jens, what do you think about this backtrace?
> 


Hi Ben,

Try with this new patch I just did. It solves the problem for me. Jens
seems to have done a list_del in a non-safe list iteration.

Mathieu

Fixes cfq iosched test patch

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 block/cfq-iosched.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/block/cfq-iosched.c
===================================================================
--- linux-2.6-lttng.orig/block/cfq-iosched.c	2009-01-20 10:31:46.000000000 -0500
+++ linux-2.6-lttng/block/cfq-iosched.c	2009-01-20 17:41:06.000000000 -0500
@@ -1761,6 +1761,36 @@ cfq_update_idle_window(struct cfq_data *
 }
 
 /*
+ * Pull dispatched requests from 'cfqq' back into the scheduler
+ */
+static void cfq_pull_dispatched_requests(struct cfq_data *cfqd,
+					 struct cfq_queue *cfqq)
+{
+	struct request_queue *q = cfqd->queue;
+	struct request *rq, *tmp;
+
+	list_for_each_entry_safe_reverse(rq, tmp, &q->queue_head, queuelist) {
+		if (rq->cmd_flags & REQ_STARTED)
+			break;
+
+		if (RQ_CFQQ(rq) != cfqq)
+			continue;
+
+		/*
+		 * Pull off the dispatch list and put it back into the cfqq
+		 */
+		list_del(&rq->queuelist);
+		cfqq->dispatched--;
+		if (cfq_cfqq_sync(cfqq))
+			cfqd->sync_flight--;
+
+		cfq_add_rq_rb(rq);
+		q->nr_sorted++;
+		list_add_tail(&rq->queuelist, &cfqq->fifo);
+	}
+}
+
+/*
  * Check if new_cfqq should preempt the currently active queue. Return 0 for
  * no or if we aren't sure, a 1 will cause a preempt.
  */
@@ -1816,8 +1846,14 @@ cfq_should_preempt(struct cfq_data *cfqd
  */
 static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct cfq_queue *old_cfqq = cfqd->active_queue;
+
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
-	cfq_slice_expired(cfqd, 1);
+
+	if (old_cfqq) {
+		__cfq_slice_expired(cfqd, old_cfqq, 1);
+		cfq_pull_dispatched_requests(cfqd, old_cfqq);
+	}
 
 	/*
 	 * Put the new queue at the front of the of the current list,

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
