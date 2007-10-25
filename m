Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXJYPBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXJYPBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbXJYPBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:01:11 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45112
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757867AbXJYPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:01:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/3] RT: cleanup some push-rt logic
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Thu, 25 Oct 2007 10:46:23 -0400
Message-ID: <20071025144623.19876.47236.stgit@novell1.haskins.net>
In-Reply-To: <20071025144456.19876.94333.stgit@novell1.haskins.net>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 55da7d0..b59dc20 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -292,7 +292,6 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 {
 	struct rq *lowest_rq = NULL;
 	cpumask_t cpu_mask;
-	int dst_cpu = -1;
 	int cpu;
 	int tries;
 
@@ -311,14 +310,12 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 			/* We look for lowest RT prio or non-rt CPU */
 			if (rq->rt.highest_prio >= MAX_RT_PRIO) {
 				lowest_rq = rq;
-				dst_cpu = cpu;
 				break;
 			}
 
 			/* no locking for now */
 			if (rq->rt.highest_prio > task->prio &&
 			    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
-				dst_cpu = cpu;
 				lowest_rq = rq;
 			}
 		}
@@ -335,7 +332,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 			 * Also make sure that it wasn't scheduled on its rq.
 			 */
 			if (unlikely(task_rq(task) != this_rq ||
-				     !cpu_isset(dst_cpu, task->cpus_allowed) ||
+				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
 				     task_running(this_rq, task) ||
 				     !task->se.on_rq)) {
 				spin_unlock(&lowest_rq->lock);
@@ -365,7 +362,6 @@ static int push_rt_task(struct rq *this_rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
-	int dst_cpu;
 	int ret = 0;
 	int paranoid = RT_MAX_TRIES;
 
@@ -412,12 +408,10 @@ static int push_rt_task(struct rq *this_rq)
 		goto out;
 	}
 
-	dst_cpu = lowest_rq->cpu;
-
 	assert_spin_locked(&lowest_rq->lock);
 
 	deactivate_task(this_rq, next_task, 0);
-	set_task_cpu(next_task, dst_cpu);
+	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
 
 	resched_task(lowest_rq->curr);

