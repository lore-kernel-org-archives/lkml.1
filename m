Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbXJWRHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbXJWRHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXJWRFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:05:37 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:35076
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754695AbXJWRFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:05:35 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 07/13] RT: Clean up some of the push-rt logic
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 23 Oct 2007 12:50:59 -0400
Message-ID: <20071023165059.5536.51340.stgit@novell1.haskins.net>
In-Reply-To: <20071023164156.5536.95573.stgit@novell1.haskins.net>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the superfluous dst_cpu, and move the cpu_mask inside the search
function.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c17e2e4..0600062 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1517,20 +1517,21 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
 #define RT_PUSH_MAX_TRIES 3
 
 /* Will lock the rq it finds */
-static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
-				      struct task_struct *task,
+static struct rq *find_lock_lowest_rq(struct task_struct *task,
 				      struct rq *this_rq)
 {
 	struct rq *lowest_rq = NULL;
-	int dst_cpu = -1;
 	int cpu;
 	int tries;
+	cpumask_t cpu_mask;
+
+	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
 
 	for (tries = 0; tries < RT_PUSH_MAX_TRIES; tries++) {
 		/*
 		 * Scan each rq for the lowest prio.
 		 */
-		for_each_cpu_mask(cpu, *cpu_mask) {
+		for_each_cpu_mask(cpu, cpu_mask) {
 			struct rq *rq = &per_cpu(runqueues, cpu);
 
 			if (cpu == smp_processor_id())
@@ -1539,7 +1540,6 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 			/* We look for lowest RT prio or non-rt CPU */
 			if (rq->highest_prio >= MAX_RT_PRIO) {
 				lowest_rq = rq;
-				dst_cpu = cpu;
 				break;
 			}
 
@@ -1547,7 +1547,6 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 			if (rq->highest_prio > task->prio &&
 			    (!lowest_rq || rq->highest_prio < lowest_rq->highest_prio)) {
 				lowest_rq = rq;
-				dst_cpu = cpu;
 			}
 		}
 
@@ -1562,7 +1561,7 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 			 * migrated already or had its affinity changed.
 			 */
 			if (unlikely(task_rq(task) != this_rq ||
-				     !cpu_isset(dst_cpu, task->cpus_allowed))) {
+				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed))) {
 				spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
 				break;
@@ -1593,7 +1592,6 @@ static int push_rt_task(struct rq *this_rq)
 	struct rq *lowest_rq;
 	int dst_cpu;
 	int ret = 0;
-	cpumask_t cpu_mask;
 
 	assert_spin_locked(&this_rq->lock);
 
@@ -1601,13 +1599,11 @@ static int push_rt_task(struct rq *this_rq)
 	if (!next_task)
 		return 0;
 
-	cpus_and(cpu_mask, cpu_online_map, next_task->cpus_allowed);
-
 	/* We might release this_rq lock */
 	get_task_struct(next_task);
 
 	/* find_lock_lowest_rq locks the rq if found */
-	lowest_rq = find_lock_lowest_rq(&cpu_mask, next_task, this_rq);
+	lowest_rq = find_lock_lowest_rq(next_task, this_rq);
 	if (!lowest_rq)
 		goto out;
 

