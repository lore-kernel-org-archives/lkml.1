Return-Path: <linux-kernel-owner+w=401wt.eu-S1764908AbXKUBR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764908AbXKUBR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbXKUBNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:13:55 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:59854 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760322AbXKUBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:49 -0500
Message-Id: <20071121011250.617947971@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 11/20] RT: Break out the search function
Content-Disposition: inline; filename=sched-break-out-search.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

Isolate the search logic into a function so that it can be used later
in places other than find_locked_lowest_rq().

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   66 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:04.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:05.000000000 -0500
@@ -260,54 +260,66 @@ static struct task_struct *pick_next_hig
 
 static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
 
-/* Will lock the rq it finds */
-static struct rq *find_lock_lowest_rq(struct task_struct *task,
-				      struct rq *this_rq)
+static int find_lowest_rq(struct task_struct *task)
 {
-	struct rq *lowest_rq = NULL;
 	int cpu;
-	int tries;
 	cpumask_t *cpu_mask = &__get_cpu_var(local_cpu_mask);
+	struct rq *lowest_rq = NULL;
 
 	cpus_and(*cpu_mask, cpu_online_map, task->cpus_allowed);
 
-	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
-		/*
-		 * Scan each rq for the lowest prio.
-		 */
-		for_each_cpu_mask(cpu, *cpu_mask) {
-			struct rq *rq = &per_cpu(runqueues, cpu);
+	/*
+	 * Scan each rq for the lowest prio.
+	 */
+	for_each_cpu_mask(cpu, *cpu_mask) {
+		struct rq *rq = cpu_rq(cpu);
 
-			if (cpu == this_rq->cpu)
-				continue;
+		if (cpu == rq->cpu)
+			continue;
 
-			/* We look for lowest RT prio or non-rt CPU */
-			if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-				lowest_rq = rq;
-				break;
-			}
+		/* We look for lowest RT prio or non-rt CPU */
+		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
+			lowest_rq = rq;
+			break;
+		}
 
-			/* no locking for now */
-			if (rq->rt.highest_prio > task->prio &&
-			    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
-				lowest_rq = rq;
-			}
+		/* no locking for now */
+		if (rq->rt.highest_prio > task->prio &&
+		    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
+			lowest_rq = rq;
 		}
+	}
+
+	return lowest_rq ? lowest_rq->cpu : -1;
+}
+
+/* Will lock the rq it finds */
+static struct rq *find_lock_lowest_rq(struct task_struct *task,
+				      struct rq *rq)
+{
+	struct rq *lowest_rq = NULL;
+	int cpu;
+	int tries;
 
-		if (!lowest_rq)
+	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
+		cpu = find_lowest_rq(task);
+
+		if (cpu == -1)
 			break;
 
+		lowest_rq = cpu_rq(cpu);
+
 		/* if the prio of this runqueue changed, try again */
-		if (double_lock_balance(this_rq, lowest_rq)) {
+		if (double_lock_balance(rq, lowest_rq)) {
 			/*
 			 * We had to unlock the run queue. In
 			 * the mean time, task could have
 			 * migrated already or had its affinity changed.
 			 * Also make sure that it wasn't scheduled on its rq.
 			 */
-			if (unlikely(task_rq(task) != this_rq ||
+			if (unlikely(task_rq(task) != rq ||
 				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
-				     task_running(this_rq, task) ||
+				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 				spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;

-- 
