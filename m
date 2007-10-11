Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbXJKWNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbXJKWNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbXJKWNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:13:16 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45347
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756232AbXJKWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:13:15 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/7] RT: Peter Zijlstra's suggested improvements to rt-push
	patch
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Thu, 11 Oct 2007 17:59:53 -0400
Message-ID: <20071011215953.27097.46608.stgit@novell1.haskins.net>
In-Reply-To: <20071011213916.27097.42597.stgit@novell1.haskins.net>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is my own interpretation of Peter's recommended changes Steven's push-rt
patch.  Just to be clear, Peter does not endorse this patch unless he himself
specifically says so ;).

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0f0af6d..24b38b4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1499,7 +1499,7 @@ static int push_rt_task(struct rq *this_rq)
 	int dst_cpu = -1;
 	int ret = 0;
 
-	BUG_ON(!spin_is_locked(&this_rq->lock));
+	assert_spin_locked(&this_rq->lock);
 
 	next_task = rt_next_highest_task(this_rq);
 	if (!next_task)
@@ -1553,7 +1553,8 @@ static int push_rt_task(struct rq *this_rq)
 		set_task_cpu(next_task, dst_cpu);
 		activate_task(lowest_rq, next_task, 0);
 
-		set_tsk_need_resched(lowest_rq->curr);
+		resched_task(lowest_rq->curr);
+		schedstat_inc(this_rq, rto_schedule);
 
 		spin_unlock(&lowest_rq->lock);
 		ret = 1;
@@ -2290,10 +2291,9 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * then kick other CPUs, they might run it:
 	 */
 	rq->curr_prio = current->prio;
-	if (unlikely(rt_task(current) && push_rt_task(rq))) {
-		schedstat_inc(rq, rto_schedule);
-		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
-	}
+	if (unlikely(rq->rt_nr_running > 1))
+		push_rt_task(rq);
+
 #endif
 	prev_state = prev->state;
 	_finish_arch_switch(prev);

