Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbXJIOkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbXJIOkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbXJIOjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:39:08 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45543
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754974AbXJIOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:39:07 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 4/5] RT: Add a per-cpu rt_overload indication
To: mingo@elte.hu, linux-rt-users@vger.kernel.org, rostedt@goodmis.org
Cc: kravetz@us.ibm.com, linux-kernel@vger.kernel.org, ghaskins@novell.com,
       pmorreale@novell.com, sdietrich@novell.com
Date: Tue, 09 Oct 2007 10:26:05 -0400
Message-ID: <20071009142605.4941.95952.stgit@novell1.haskins.net>
In-Reply-To: <20071009142044.4941.65189.stgit@novell1.haskins.net>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The system currently evaluates all online CPUs whenever one or more enters
an rt_overload condition.  This suffers from scalability limitations as
the # of online CPUs increases.  So we introduce a cpumask to track
exactly which CPUs need RT balancing.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Peter W. Morreale <pmorreale@novell.com>
---

 kernel/sched.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 551629b..a28ca9d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -631,6 +631,7 @@ static inline struct rq *this_rq_lock(void)
 
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 static __cacheline_aligned_in_smp atomic_t rt_overload;
+static cpumask_t rto_cpus;
 #endif
 
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
@@ -639,8 +640,11 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 	if (rt_task(p)) {
 		rq->rt_nr_running++;
 # ifdef CONFIG_SMP
-		if (rq->rt_nr_running == 2)
+		if (rq->rt_nr_running == 2) {
+			cpu_set(rq->cpu, rto_cpus);
+			smp_wmb();
 			atomic_inc(&rt_overload);
+		}
 # endif
 	}
 #endif
@@ -653,8 +657,10 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 		WARN_ON(!rq->rt_nr_running);
 		rq->rt_nr_running--;
 # ifdef CONFIG_SMP
-		if (rq->rt_nr_running == 1)
+		if (rq->rt_nr_running == 1) {
 			atomic_dec(&rt_overload);
+			cpu_clear(rq->cpu, rto_cpus);
+		}
 # endif
 	}
 #endif
@@ -1503,7 +1509,7 @@ static void balance_rt_tasks(struct rq *this_rq, int this_cpu)
 	 */
 	next = pick_next_task(this_rq, this_rq->curr);
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu_mask(cpu, rto_cpus) {
 		if (cpu == this_cpu)
 			continue;
 		src_rq = cpu_rq(cpu);

