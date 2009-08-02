Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbZHBNOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbZHBNOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZHBNOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:14:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:33857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbZHBNOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:14:05 -0400
Date: Sun, 2 Aug 2009 13:13:25 GMT
From: tip-bot for Gregory Haskins <ghaskins@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, maxk@qualcomm.com,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, maxk@qualcomm.com,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <20090730145723.25226.24493.stgit@dev.haskins.net>
References: <20090730145723.25226.24493.stgit@dev.haskins.net>
Subject: [tip:sched/core] sched: Fully integrate cpus_active_map and root-domain code
Message-ID: <tip-00aec93d10a051ea64f83eff75d4065a19508ea6@git.kernel.org>
Git-Commit-ID: 00aec93d10a051ea64f83eff75d4065a19508ea6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00aec93d10a051ea64f83eff75d4065a19508ea6
Gitweb:     http://git.kernel.org/tip/00aec93d10a051ea64f83eff75d4065a19508ea6
Author:     Gregory Haskins <ghaskins@novell.com>
AuthorDate: Thu, 30 Jul 2009 10:57:23 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:26:12 +0200

sched: Fully integrate cpus_active_map and root-domain code

Reflect "active" cpus in the rq->rd->online field, instead of
the online_map.

The motivation is that things that use the root-domain code
(such as cpupri) only care about cpus classified as "active"
anyway. By synchronizing the root-domain state with the active
map, we allow several optimizations.

For instance, we can remove an extra cpumask_and from the
scheduler hotpath by utilizing rq->rd->online (since it is now
a cached version of cpu_active_map & rq->rd->span).

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Max Krasnyansky <maxk@qualcomm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090730145723.25226.24493.stgit@dev.haskins.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   10 +++++++---
 kernel/sched_rt.c   |    7 -------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 613fee5..475138c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7927,7 +7927,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	rq->rd = rd;
 
 	cpumask_set_cpu(rq->cpu, rd->span);
-	if (cpumask_test_cpu(rq->cpu, cpu_online_mask))
+	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 652e8bd..4934729 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1046,17 +1046,21 @@ static void yield_task_fair(struct rq *rq)
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
@@ -1089,10 +1093,10 @@ static int wake_idle(int cpu, struct task_struct *p)
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
