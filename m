Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZG3O5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZG3O5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZG3O5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:57:30 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51983 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZG3O52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:57:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] [RESEND] sched: Fully integrate cpus_active_map and
	root-domain code
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au,
       maxk@qualcomm.com, mingo@elte.hu
Date: Thu, 30 Jul 2009 10:57:23 -0400
Message-ID: <20090730145723.25226.24493.stgit@dev.haskins.net>
In-Reply-To: <20090730145623.25226.29033.stgit@dev.haskins.net>
References: <20090730145623.25226.29033.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to 2.6.31-rc4)

[
	This patch was originaly sent about a year ago, but got dropped
	presumably by accident.  Here is the original thread.

	http://lkml.org/lkml/2008/7/22/281

	At that time, Peter and Max acked it.  It has now been forward
	ported to the new cpumask interface.  I will be so bold as to
	carry their acks forward since the basic logic is the same.
	However, a new acknowledgement, if they have the time to review,
	would be ideal.

	I have tested this patch on a 4-way system using Max's recommended
	"echo 0|1 > cpu1/online" technique and it appears to work properly
]

What: Reflect "active" cpus in the rq->rd->online field, instead of the
online_map.

Motivation:  Things that use the root-domain code (such as cpupri) only
care about cpus classified as "active" anyway.  By synchronizing the
root-domain state with the active map, we allow several optimizations.

For instance, we can remove an extra cpumask_and from the scheduler
hotpath by utilizing rq->rd->online (since it is now a cached version
of cpu_active_map & rq->rd->span).

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Max Krasnyansky <maxk@qualcomm.com>
---

 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   10 +++++++---
 kernel/sched_rt.c   |    7 -------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1a104e6..38a1526 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7874,7 +7874,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpumask_set_cpu(rq->cpu, rd->span);
-	if (cpumask_test_cpu(rq->cpu, cpu_online_mask))
+	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9ffb2b2..2b9cae6 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1040,17 +1040,21 @@ static void yield_task_fair(struct rq *rq)
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
  * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (cpu_active_mask)
+ * hence we need to mask them out (rq->rd->online)
  *
  * Returns the CPU we should wake onto.
  */
 #if defined(ARCH_HAS_SCHED_WAKE_IDLE)
+
+#define cpu_rd_active(cpu, rq) cpumask_test_cpu(cpu, rq->rd->online)
+
 static int wake_idle(int cpu, struct task_struct *p)
 {
 	struct sched_domain *sd;
 	int i;
 	unsigned int chosen_wakeup_cpu;
 	int this_cpu;
+	struct rq *task_rq = task_rq(p);
 
 	/*
 	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
@@ -1083,10 +1087,10 @@ static int wake_idle(int cpu, struct task_struct *p)
 	for_each_domain(cpu, sd) {
 		if ((sd->flags & SD_WAKE_IDLE)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
-			&& !task_hot(p, task_rq(p)->clock, sd))) {
+			&& !task_hot(p, task_rq->clock, sd))) {
 			for_each_cpu_and(i, sched_domain_span(sd),
 					 &p->cpus_allowed) {
-				if (cpu_active(i) && idle_cpu(i)) {
+				if (cpu_rd_active(i, task_rq) && idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
 						       se.nr_wakeups_idle);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a8f89bc..13f728e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1173,13 +1173,6 @@ static int find_lowest_rq(struct task_struct *task)
 		return -1; /* No targets found */
 
 	/*
-	 * Only consider CPUs that are usable for migration.
-	 * I guess we might want to change cpupri_find() to ignore those
-	 * in the first place.
-	 */
-	cpumask_and(lowest_mask, lowest_mask, cpu_active_mask);
-
-	/*
 	 * At this point we have built a mask of cpus representing the
 	 * lowest priority tasks in the system.  Now we want to elect
 	 * the best one based on our affinity and topology.

