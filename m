Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbZDAL2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbZDAL2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZDAL2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:28:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:37641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935AbZDAL2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:28:09 -0400
Date: Wed, 1 Apr 2009 11:27:27 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200903251501.22664.rusty@rustcorp.com.au>
References: <200903251501.22664.rusty@rustcorp.com.au>
Subject: [tip:sched/urgent] sched_rt: don't allocate cpumask in fastpath
Message-ID: <tip-13b8bd0a5713bdf05659019badd7c0407984ece1@git.kernel.org>
Git-Commit-ID: 13b8bd0a5713bdf05659019badd7c0407984ece1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:27:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13b8bd0a5713bdf05659019badd7c0407984ece1
Gitweb:     http://git.kernel.org/tip/13b8bd0a5713bdf05659019badd7c0407984ece1
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Wed, 25 Mar 2009 15:01:22 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 13:24:51 +0200

sched_rt: don't allocate cpumask in fastpath

Impact: cleanup

As pointed out by Steven Rostedt.  Since the arg in question is
unused, we simply change cpupri_find() to accept NULL.

Reported-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <200903251501.22664.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_cpupri.c |    5 +++--
 kernel/sched_rt.c     |   15 ++++-----------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 1e00bfa..cdd3c89 100644
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
@@ -81,7 +81,8 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
-		cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+		if (lowest_mask)
+			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
 		return 1;
 	}
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bac1061..fbec5a5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -805,20 +805,15 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	cpumask_var_t mask;
-
 	if (rq->curr->rt.nr_cpus_allowed == 1)
 		return;
 
-	if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
-		return;
-
 	if (p->rt.nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, mask))
-		goto free;
+	    && cpupri_find(&rq->rd->cpupri, p, NULL))
+		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, mask))
-		goto free;
+	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
+		return;
 
 	/*
 	 * There appears to be other cpus that can accept
@@ -827,8 +822,6 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 	 */
 	requeue_task_rt(rq, p, 1);
 	resched_task(rq->curr);
-free:
-	free_cpumask_var(mask);
 }
 
 #endif /* CONFIG_SMP */
