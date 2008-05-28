Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYE1QYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYE1QYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYE1QYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:24:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45889 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYE1QYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:24:41 -0400
Date: Wed, 28 May 2008 22:03:18 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080528163318.GG30285@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C4F5A.2010104@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 12:13:46PM -0600, Chris Friesen wrote:
>> Can you check if this makes a difference for you as well?
>
> Initially it looked promising.  I put pid 2498 in group A, and pids 2499 
> and 2500 in group B.  2498 got basically a full cpu, and the other two got 
> 50% each.
>
> However, I then moved pid 2499 from group B to group A, and the system got 
> stuck in the following behaviour:
>
> 2498 cfriesen  20   0  3800  392  336 R 99.7  0.0   3:00.22 cat
> 2500 cfriesen  20   0  3800  392  336 R 66.7  0.0   1:39.10 cat
> 2499 cfriesen  20   0  3800  392  336 R 33.0  0.0   1:24.31 cat
>
> I reproduced this a number of times.

Thanks for trying this combination. I discovered a task-leak in this loop
(__load_balance_iterator):

        /* Skip over entities that are not tasks */
        do {
                se = list_entry(next, struct sched_entity, group_node);
                next = next->next;
        } while (next != &cfs_rq->tasks && !entity_is_task(se));

        if (next == &cfs_rq->tasks)
                return NULL;

We seem to be skipping the last element in the task list always. In your
case, the lone task in Group a/b is always skipped because of this.

The following hunk seems to fix this:

@@ -1386,9 +1386,6 @@ __load_balance_iterator(struct cfs_rq *c
 		next = next->next;
 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
 	cfs_rq->balance_iterator = next;
 
 	if (entity_is_task(se))


Updated patch (on top of 2.6.26-rc3 +
http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/)
below.  Pls let me know how it fares!


---
 include/linux/sched.h |    4 ++++
 init/Kconfig          |    2 +-
 kernel/sched.c        |    5 ++++-
 kernel/sched_debug.c  |    3 ++-
 kernel/sched_fair.c   |    3 ---
 5 files changed, 11 insertions(+), 6 deletions(-)

Index: current/include/linux/sched.h
===================================================================
--- current.orig/include/linux/sched.h
+++ current/include/linux/sched.h
@@ -698,7 +698,11 @@ enum cpu_idle_type {
 #define SCHED_LOAD_SHIFT	10
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#define SCHED_LOAD_SCALE_FUZZ	0
+#else
 #define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
+#endif
 
 #ifdef CONFIG_SMP
 #define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */
Index: current/init/Kconfig
===================================================================
--- current.orig/init/Kconfig
+++ current/init/Kconfig
@@ -349,7 +349,7 @@ config RT_GROUP_SCHED
 	  See Documentation/sched-rt-group.txt for more information.
 
 choice
-	depends on GROUP_SCHED
+	depends on GROUP_SCHED && (FAIR_GROUP_SCHED || RT_GROUP_SCHED)
 	prompt "Basis for grouping tasks"
 	default USER_SCHED
 
Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -1534,6 +1534,9 @@ tg_shares_up(struct task_group *tg, int 
 	unsigned long shares = 0;
 	int i;
 
+	if (!tg->parent)
+		return;
+
 	for_each_cpu_mask(i, sd->span) {
 		rq_weight += tg->cfs_rq[i]->load.weight;
 		shares += tg->cfs_rq[i]->shares;
@@ -2919,7 +2922,7 @@ next:
 	 * skip a task if it will be the highest priority task (i.e. smallest
 	 * prio value) on its new queue regardless of its load weight
 	 */
-	skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
+	skip_for_load = (p->se.load.weight >> 1) >= rem_load_move +
 							 SCHED_LOAD_SCALE_FUZZ;
 	if ((skip_for_load && p->prio >= *this_best_prio) ||
 	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
Index: current/kernel/sched_debug.c
===================================================================
--- current.orig/kernel/sched_debug.c
+++ current/kernel/sched_debug.c
@@ -119,7 +119,7 @@ void print_cfs_rq(struct seq_file *m, in
 	struct sched_entity *last;
 	unsigned long flags;
 
-#if !defined(CONFIG_CGROUP_SCHED) || !defined(CONFIG_USER_SCHED)
+#ifndef CONFIG_CGROUP_SCHED
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #else
 	char path[128] = "";
@@ -170,6 +170,7 @@ void print_cfs_rq(struct seq_file *m, in
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
+	SEQ_printf(m, "  .%-30s: %lu\n", "h_load", cfs_rq->h_load);
 #endif
 #endif
 }
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -1386,9 +1386,6 @@ __load_balance_iterator(struct cfs_rq *c
 		next = next->next;
 	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
 	cfs_rq->balance_iterator = next;
 
 	if (entity_is_task(se))


-- 
Regards,
vatsa
