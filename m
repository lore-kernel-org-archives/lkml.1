Return-Path: <linux-kernel-owner+w=401wt.eu-S932559AbXKUBXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbXKUBXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765395AbXKUBOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:14:10 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:45800 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765475AbXKUBNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:52 -0500
Message-Id: <20071121011251.913977352@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 19/20] Optimize out cpu_clears
Content-Disposition: inline; filename=rt-balance-optimize-cpu-search.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes several cpumask operations by keeping track
of the first of the CPUS that is of the lowest priority. When
the search for the lowest priority runqueue is completed, all
the bits up to the first CPU with the lowest priority runqueue
is cleared.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/sched_rt.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:15.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:17.000000000 -0500
@@ -293,22 +293,20 @@ static struct task_struct *pick_next_hig
 }
 
 static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
-static DEFINE_PER_CPU(cpumask_t, valid_cpu_mask);
 
 static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 {
-	int       cpu;
-	cpumask_t *valid_mask = &__get_cpu_var(valid_cpu_mask);
 	int       lowest_prio = -1;
+	int       lowest_cpu  = 0;
 	int       count       = 0;
+	int       cpu;
 
-	cpus_clear(*lowest_mask);
-	cpus_and(*valid_mask, cpu_online_map, task->cpus_allowed);
+	cpus_and(*lowest_mask, cpu_online_map, task->cpus_allowed);
 
 	/*
 	 * Scan each rq for the lowest prio.
 	 */
-	for_each_cpu_mask(cpu, *valid_mask) {
+	for_each_cpu_mask(cpu, *lowest_mask) {
 		struct rq *rq = cpu_rq(cpu);
 
 		/* We look for lowest RT prio or non-rt CPU */
@@ -325,13 +323,30 @@ static int find_lowest_cpus(struct task_
 			if (rq->rt.highest_prio > lowest_prio) {
 				/* new low - clear old data */
 				lowest_prio = rq->rt.highest_prio;
-				if (count) {
-					cpus_clear(*lowest_mask);
-					count = 0;
-				}
+				lowest_cpu = cpu;
+				count = 0;
 			}
 			cpu_set(rq->cpu, *lowest_mask);
 			count++;
+		} else
+			cpu_clear(cpu, *lowest_mask);
+	}
+
+	/*
+	 * Clear out all the set bits that represent
+	 * runqueues that were of higher prio than
+	 * the lowest_prio.
+	 */
+	if (lowest_cpu) {
+		/*
+		 * Perhaps we could add another cpumask op to
+		 * zero out bits. Like cpu_zero_bits(cpumask, nrbits);
+		 * Then that could be optimized to use memset and such.
+		 */
+		for_each_cpu_mask(cpu, *lowest_mask) {
+			if (cpu >= lowest_cpu)
+				break;
+			cpu_clear(cpu, *lowest_mask);
 		}
 	}
 

-- 
