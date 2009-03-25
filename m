Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZCYEby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZCYEby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZCYEbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:31:31 -0400
Received: from ozlabs.org ([203.10.76.45]:41001 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZCYEb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:31:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched_rt: don't allocate cpumask in fastpath
Date: Wed, 25 Mar 2009 15:01:22 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251501.22664.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

As pointed out by Steven Rostedt.  Since the arg in question is
unused, we simply change cpupri_find() to accept NULL.

Cc: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched_cpupri.c |    5 +++--
 kernel/sched_rt.c     |   15 ++++-----------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -55,7 +55,7 @@ static int convert_prio(int prio)
  * cpupri_find - find the best (lowest-pri) CPU in the system
  * @cp: The cpupri context
  * @p: The task
- * @lowest_mask: A mask to fill in with selected CPUs
+ * @lowest_mask: A mask to fill in with selected CPUs (or NULL)
  *
  * Note: This function returns the recommended CPUs as calculated during the
  * current invokation.  By the time the call returns, the CPUs may have in
@@ -81,7 +81,8 @@ int cpupri_find(struct cpupri *cp, struc
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
-		cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+		if (lowest_mask)
+			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
 		return 1;
 	}
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -805,20 +805,15 @@ static int select_task_rq_rt(struct task
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	cpumask_var_t mask;
-
 	if (rq->curr->rt.nr_cpus_allowed == 1)
 		return;
 
-	if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
+	if (p->rt.nr_cpus_allowed != 1
+	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
 
-	if (p->rt.nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, mask))
-		goto free;
-
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, mask))
-		goto free;
+	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
+		return;
 
 	/*
 	 * There appears to be other cpus that can accept
@@ -827,8 +822,6 @@ static void check_preempt_equal_prio(str
 	 */
 	requeue_task_rt(rq, p, 1);
 	resched_task(rq->curr);
-free:
-	free_cpumask_var(mask);
 }
 
 #endif /* CONFIG_SMP */
