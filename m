Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZKDP0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZKDP0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZKDP0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:26:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:57372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579AbZKDP0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:26:38 -0500
Date: Wed, 4 Nov 2009 15:26:12 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au, ghaskins@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, rostedt@goodmis.org, tglx@linutronix.de,
       ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <200911031453.15350.rusty@rustcorp.com.au>
References: <200911031453.15350.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpumask: Simplify sched_rt.c
Message-ID: <tip-e2c880630438f80b474378d5487b511b07665051@git.kernel.org>
Git-Commit-ID: e2c880630438f80b474378d5487b511b07665051
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2c880630438f80b474378d5487b511b07665051
Gitweb:     http://git.kernel.org/tip/e2c880630438f80b474378d5487b511b07665051
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 3 Nov 2009 14:53:15 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:16:38 +0100

cpumask: Simplify sched_rt.c

find_lowest_rq() wants to call pick_optimal_cpu() on the
intersection of sched_domain_span(sd) and lowest_mask.  Rather
than doing a cpus_and into a temporary, we can open-code it.

This actually makes the code slightly clearer, IMHO.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <200911031453.15350.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |   61 ++++++++++++++++++++--------------------------------
 1 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..5c5fef3 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1153,29 +1153,12 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
-static inline int pick_optimal_cpu(int this_cpu,
-				   const struct cpumask *mask)
-{
-	int first;
-
-	/* "this_cpu" is cheaper to preempt than a remote processor */
-	if ((this_cpu != -1) && cpumask_test_cpu(this_cpu, mask))
-		return this_cpu;
-
-	first = cpumask_first(mask);
-	if (first < nr_cpu_ids)
-		return first;
-
-	return -1;
-}
-
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
 	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
-	cpumask_var_t domain_mask;
 
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
@@ -1198,28 +1181,26 @@ static int find_lowest_rq(struct task_struct *task)
 	 * Otherwise, we consult the sched_domains span maps to figure
 	 * out which cpu is logically closest to our hot cache data.
 	 */
-	if (this_cpu == cpu)
-		this_cpu = -1; /* Skip this_cpu opt if the same */
-
-	if (alloc_cpumask_var(&domain_mask, GFP_ATOMIC)) {
-		for_each_domain(cpu, sd) {
-			if (sd->flags & SD_WAKE_AFFINE) {
-				int best_cpu;
+	if (!cpumask_test_cpu(this_cpu, lowest_mask))
+		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
 
-				cpumask_and(domain_mask,
-					    sched_domain_span(sd),
-					    lowest_mask);
+	for_each_domain(cpu, sd) {
+		if (sd->flags & SD_WAKE_AFFINE) {
+			int best_cpu;
 
-				best_cpu = pick_optimal_cpu(this_cpu,
-							    domain_mask);
-
-				if (best_cpu != -1) {
-					free_cpumask_var(domain_mask);
-					return best_cpu;
-				}
-			}
+			/*
+			 * "this_cpu" is cheaper to preempt than a
+			 * remote processor.
+			 */
+			if (this_cpu != -1 &&
+			    cpumask_test_cpu(this_cpu, sched_domain_span(sd)))
+				return this_cpu;
+
+			best_cpu = cpumask_first_and(lowest_mask,
+						     sched_domain_span(sd));
+			if (best_cpu < nr_cpu_ids)
+				return best_cpu;
 		}
-		free_cpumask_var(domain_mask);
 	}
 
 	/*
@@ -1227,7 +1208,13 @@ static int find_lowest_rq(struct task_struct *task)
 	 * just give the caller *something* to work with from the compatible
 	 * locations.
 	 */
-	return pick_optimal_cpu(this_cpu, lowest_mask);
+	if (this_cpu != -1)
+		return this_cpu;
+
+	cpu = cpumask_any(lowest_mask);
+	if (cpu < nr_cpu_ids)
+		return cpu;
+	return -1;
 }
 
 /* Will lock the rq it finds */
