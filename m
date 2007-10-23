Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbXJWRG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbXJWRG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXJWRFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:05:16 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:35040
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754512AbXJWRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:05:14 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 03/13] RT: Add a per-cpu rt_overload indication
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 23 Oct 2007 12:50:39 -0400
Message-ID: <20071023165039.5536.54119.stgit@novell1.haskins.net>
In-Reply-To: <20071023164156.5536.95573.stgit@novell1.haskins.net>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net>
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
index daeb8ed..e22eec7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -632,6 +632,7 @@ static inline struct rq *this_rq_lock(void)
 
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 static __cacheline_aligned_in_smp atomic_t rt_overload;
+static cpumask_t rto_cpus;
 #endif
 
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
@@ -640,8 +641,11 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
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
@@ -654,8 +658,10 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
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
@@ -1622,7 +1628,7 @@ static void balance_rt_tasks(struct rq *this_rq, int this_cpu)
 	 */
 	next = pick_next_task(this_rq, this_rq->curr);
 
-	for_each_online_cpu(cpu) {
+	for_each_cpu_mask(cpu, rto_cpus) {
 		if (cpu == this_cpu)
 			continue;
 		src_rq = cpu_rq(cpu);

