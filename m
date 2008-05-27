Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbYE0RH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbYE0RH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYE0RHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:07:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59154 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691AbYE0RHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:07:17 -0400
Date: Tue, 27 May 2008 22:45:28 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080527171528.GD30285@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834B75A.40900@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 05:59:22PM -0600, Chris Friesen wrote:
> I just downloaded the current git head and started playing with the fair 
> group scheduler.  (This is on a dual cpu Mac G5.)
>
> I created two groups, "a" and "b".  Each of them was left with the default 
> share of 1024.
>
> I created three cpu hogs by doing "cat /dev/zero > /dev/null".  One hog 
> (pid 2435) was put into group "a", while the other two were put into group 
> "b".
>
> After giving them time to settle down, "top" showed the following:
>
> 2438 cfriesen  20   0  3800  392  336 R 99.5  0.0   4:02.82 cat 
> 2435 cfriesen  20   0  3800  392  336 R 65.9  0.0   3:30.94 cat 
> 2437 cfriesen  20   0  3800  392  336 R 34.3  0.0   3:14.89 cat 
>
>
> Where pid 2435 should have gotten a whole cpu worth of time, it actually 
> only got 66% of a cpu. Is this expected behaviour?

Definitely not an expected behavior and I think I understand why this is
happening.

But first, note that Groups "a" and "b" share bandwidth with all tasks
in /dev/cgroup/tasks. Lets say that /dev/cgroup/tasks had T0-T1,
/dev/cgroup/a/tasks has TA1 while /dev/cgroup/b/tasks has
TB1 (all tasks of weight 1024).

Then TA1 is expected to get 1/(1+1+2) = 25% bandwidth

Similarly T0, T1, TB1 all get 25% bandwidth.

IOW, Groups "a" and "b" are peers of each task in /dev/cgroup/tasks.

Having said that, here's what I do for my testing:

	# mkdir /cgroup
	# mount -t cgroup -ocpu none /cgroup
	# cd /cgroup

	# #Move all tasks to 'sys' group and give it low shares
	# mkdir sys
	# cd sys
	# for i in `cat ../tasks`
	  do
		echo $i > tasks
	  done
	# echo 100 > cpu.shares

	# mkdir a
	# mkdir b

	# echo <pid> > a/tasks
	..

Now, why did Group "a" get less than what it deserved? Here's what was
happening:

	CPU0		CPU1

	  a0		b0
	  b1

cpu0.load = 1024 (Grp a load) + 512 (Grp b load)
cpu1.load = 512 (Grp b load)

imbalance = 1024

max_load_move = 512 (to equalize load)

load_balance_fair() is invoked on CPU1 with this max_load_move target of 512. 
Ideally it can move b1 to CPU1, which would attain perfect balance. This
does not happen because:

load_balance_fair() iterates thr' the task list in the order they
were created. So it first examines what tasks it can pull from Group "a".

	It invokes __load_balance_fair() to see if it can pull any tasks
	worth max weight 512 (rem_load). Ideally since a0's weight is
	1024, it should not pull a0. However, balance_tasks() is eager
	to pull atleast one task (because of SCHED_LOAD_SCALE_FUZZ) and
	ends up pulling a0. This results in more load being moved (1024)
	than the required target.

Next, when CPU0 tries pulling load of 512, it ends up pulling a0 again.

This a0 ping pongs between both CPUs.


The following experimental patch (on top of 2.6.26-rc3 +
http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/) seems 
to fix the problem.

Note that this works only when /dev/cgroup/sys/cpu.shares = 100 (or some low
number). Otherwise top (or whatever command you run to observe load 
distribution) contributes to some load in /dev/cgroup/sys group, which skews the
results. IMHO, find_busiest_group() needs to use cpu utilization (rather than 
cpu load) as the metric to balance across CPUs (rather than task/group load).

Can you check if this makes a difference for you as well?


Not-yet-Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 include/linux/sched.h |    4 ++++
 init/Kconfig          |    2 +-
 kernel/sched.c        |    5 ++++-
 kernel/sched_debug.c  |    2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)

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




















	





>
>
>
> I then redid the test with two hogs in one group and three hogs in the 
> other group.  Unfortunately, the cpu shares were not equally distributed 
> within each group.  Using a 10-sec interval in "top", I got the following:
>
>
> 2522 cfriesen  20   0  3800  392  336 R 52.2  0.0   1:33.38 cat 
> 2523 cfriesen  20   0  3800  392  336 R 48.9  0.0   1:37.85 cat 
> 2524 cfriesen  20   0  3800  392  336 R 37.0  0.0   1:23.22 cat 
> 2525 cfriesen  20   0  3800  392  336 R 32.6  0.0   1:22.62 cat 
> 2559 cfriesen  20   0  3800  392  336 R 28.7  0.0   0:24.30 cat 
>
> Do we expect to see upwards of 9% relative unfairness between processes 
> within a class?
>
> I tried messing with the tuneables in /proc/sys/kernel (sched_latency_ns, 
> sched_migration_cost, sched_min_granularity_ns) but was unable to 
> significantly improve these results.
>
> Any pointers would be appreciated.
>
> Thanks,
>
> Chris

-- 
Regards,
vatsa
