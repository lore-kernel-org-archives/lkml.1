Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbXJIOkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbXJIOkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXJIOjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:39:13 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45551
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755200AbXJIOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:39:11 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 5/5] RT - Track which CPUs should get IPI'd on rt-overload
To: mingo@elte.hu, linux-rt-users@vger.kernel.org, rostedt@goodmis.org
Cc: kravetz@us.ibm.com, linux-kernel@vger.kernel.org, ghaskins@novell.com,
       pmorreale@novell.com, sdietrich@novell.com
Date: Tue, 09 Oct 2007 10:26:10 -0400
Message-ID: <20071009142610.4941.90103.stgit@novell1.haskins.net>
In-Reply-To: <20071009142044.4941.65189.stgit@novell1.haskins.net>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The code currently blindly fires IPIs out whenever an overload occurs.
However, there are strict events that govern when a rt-overload exists
(e.g. RT task added to a RQ, or an RT task preempted).  Therefore, we
attempt to efficiently track which CPUs are eligible for rebalancing, and we
only IPI those affected units.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Peter W. Morreale <pmorreale@novell.com>
---

 kernel/sched.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a28ca9d..6ca5f4f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -359,6 +359,8 @@ struct rq {
 	unsigned long rto_pulled;
 #endif
 	struct lock_class_key rq_lock_key;
+
+	cpumask_t rto_resched; /* Which of our peers needs rescheduling */
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -645,6 +647,9 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 			smp_wmb();
 			atomic_inc(&rt_overload);
 		}
+
+		cpus_or(rq->rto_resched, rq->rto_resched, p->cpus_allowed);
+		cpu_clear(rq->cpu, rq->rto_resched);
 # endif
 	}
 #endif
@@ -2213,9 +2218,15 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * If we pushed an RT task off the runqueue,
 	 * then kick other CPUs, they might run it:
 	 */
-	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
+	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
+		cpus_or(rq->rto_resched, rq->rto_resched, prev->cpus_allowed);
+		cpu_clear(rq->cpu, rq->rto_resched);
+	}
+
+	if (unlikely(rq->rt_nr_running > 1 && !cpus_empty(rq->rto_resched))) {
 		schedstat_inc(rq, rto_schedule);
-		smp_send_reschedule_allbutself();
+		smp_send_reschedule_allbutself_cpumask(rq->rto_resched);
+		cpus_clear(rq->rto_resched);
 	}
 #endif
 	prev_state = prev->state;

