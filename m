Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXDKU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXDKU2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXDKU2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:28:35 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:47734 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965356AbXDKU2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:28:34 -0400
Message-Id: <20070411202618.047341551@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Apr 2007 13:26:18 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [PATCH] sched: consolidate sched_clock drift adjustments
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes .. 

I created sched_clock_drift_adjust() which holds similar code from
different places in the scheduler which all appear to do the same thing.
I also added an explicit ifdef on CONFIG_SMP, the comments seemed to 
suggest it wasn't needed, but it can't hurt to make it explicit .


Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/sched.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

Index: linux-2.6.20/kernel/sched.c
===================================================================
--- linux-2.6.20.orig/kernel/sched.c
+++ linux-2.6.20/kernel/sched.c
@@ -659,6 +659,20 @@ sched_info_switch(struct task_struct *pr
 #define sched_info_switch(t, next)	do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
+#ifdef CONFIG_SMP
+static inline unsigned long long
+sched_clock_drift_adjust(unsigned long long timestamp, struct rq *from,
+			 struct rq *to)
+{
+	return (timestamp - from->most_recent_timestamp)
+		+ to->most_recent_timestamp;
+}
+#else
+static inline unsigned long long
+sched_clock_drift_adjust(unsigned long long timestamp, struct rq *from,
+			 struct rq *to) { }
+#endif
+
 static inline int task_queued(struct task_struct *task)
 {
 	return !list_empty(&task->run_list);
@@ -1018,10 +1032,10 @@ static void activate_task(struct task_st
 
 #ifdef CONFIG_SMP
 	if (!local) {
-		/* Compensate for drifting sched_clock */
 		struct rq *this_rq = this_rq();
-		now = (now - this_rq->most_recent_timestamp)
-			+ rq->most_recent_timestamp;
+
+		/* Compensate for drifting sched_clock */
+		now = sched_clock_drift_adjust(now, this_rq, rq);
 	}
 #endif
 
@@ -1742,8 +1756,8 @@ void fastcall wake_up_new_task(struct ta
 		 * Not the local CPU - must adjust timestamp. This should
 		 * get optimised away in the !CONFIG_SMP case.
 		 */
-		p->timestamp = (p->timestamp - this_rq->most_recent_timestamp)
-					+ rq->most_recent_timestamp;
+		p->timestamp =
+			sched_clock_drift_adjust(p->timestamp, this_rq, rq);
 		activate_task(p, rq, 0);
 		try_preempt(p, rq);
 
@@ -2118,8 +2132,7 @@ static void pull_task(struct rq *src_rq,
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
 	enqueue_task(p, this_rq);
-	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
-				+ this_rq->most_recent_timestamp;
+	p->timestamp = sched_clock_drift_adjust(p->timestamp, src_rq, this_rq);
 	try_preempt(p, this_rq);
 }
 
@@ -5054,8 +5067,8 @@ static int __migrate_task(struct task_st
 		 * afterwards, and pretending it was a local activate.
 		 * This way is cleaner and logically correct.
 		 */
-		p->timestamp = p->timestamp - rq_src->most_recent_timestamp
-				+ rq_dest->most_recent_timestamp;
+		p->timestamp =
+			sched_clock_drift_adjust(p->timestamp, rq_src, rq_dest);
 		deactivate_task(p, rq_src);
 		__activate_task(p, rq_dest);
 		try_preempt(p, rq_dest);
-- 

-- 
