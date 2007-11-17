Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbXKQG3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbXKQG3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761430AbXKQGYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:45 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:44634 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973AbXKQGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:40 -0500
Message-Id: <20071117062404.828623332@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 11/17] RT: Break out the search function
Content-Disposition: inline; filename=0003-rt-balance-break-out-search.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

Isolate the search logic into a function so that it can be used later
in places other than find_locked_lowest_rq().

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |   62 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 22:23:39.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:23:43.000000000 -0500
@@ -256,43 +256,55 @@ static struct task_struct *pick_next_hig
 	return next;
 }
 
-/* Will lock the rq it finds */
-static struct rq *find_lock_lowest_rq(struct task_struct *task,
-				      struct rq *rq)
+static int find_lowest_rq(struct task_struct *task)
 {
-	struct rq *lowest_rq = NULL;
-	cpumask_t cpu_mask;
 	int cpu;
-	int tries;
+	cpumask_t cpu_mask;
+	struct rq *lowest_rq = NULL;
 
 	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
 
-	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
-		/*
-		 * Scan each rq for the lowest prio.
-		 */
-		for_each_cpu_mask(cpu, cpu_mask) {
-			struct rq *curr_rq = &per_cpu(runqueues, cpu);
+	/*
+	 * Scan each rq for the lowest prio.
+	 */
+	for_each_cpu_mask(cpu, cpu_mask) {
+		struct rq *rq = cpu_rq(cpu);
 
-			if (cpu == rq->cpu)
-				continue;
+		if (cpu == rq->cpu)
+			continue;
 
-			/* We look for lowest RT prio or non-rt CPU */
-			if (curr_rq->rt.highest_prio >= MAX_RT_PRIO) {
-				lowest_rq = curr_rq;
-				break;
-			}
+		/* We look for lowest RT prio or non-rt CPU */
+		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
+			lowest_rq = rq;
+			break;
+		}
 
-			/* no locking for now */
-			if (curr_rq->rt.highest_prio > task->prio &&
-			    (!lowest_rq || curr_rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
-				lowest_rq = curr_rq;
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
+
+	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
+		cpu = find_lowest_rq(task);
 
-		if (!lowest_rq)
+		if (cpu == -1)
 			break;
 
+		lowest_rq = cpu_rq(cpu);
+
 		/* if the prio of this runqueue changed, try again */
 		if (double_lock_balance(rq, lowest_rq)) {
 			/*

-- 
