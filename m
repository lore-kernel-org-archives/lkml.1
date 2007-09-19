Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXISGEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXISGEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 02:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXISGEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 02:04:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:11314 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbXISGEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 02:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,271,1186383600"; 
   d="scan'208";a="313188568"
Date: Tue, 18 Sep 2007 23:03:59 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Ingo Molnar <mingo@elte.hu>
cc: dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git] CFS-devel, group scheduler, fixes
In-Reply-To: <20070918201622.GA1632@elte.hu>
Message-ID: <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch attempts to improve CFS's SMP global fairness based on the new 
virtual time design.

Removed vruntime adjustment in set_task_cpu() as it skews global fairness.

Modified small_imbalance logic in find_busiest_group(). If there's small 
imbalance, move tasks from busiest to local sched_group only if the local 
group contains a CPU whose min_vruntime is the maximum among all CPUs in 
the same sched_domain. This prevents any CPU from advancing too far ahead 
in virtual time and avoids tasks thrashing between two CPUs without 
utilizing other CPUs in the system. For example, for 10 tasks on 8 CPUs, 
since the load is not evenly divisible by the number of CPUs, we want the 
extra load to have a fair use of every CPU in the system.

Tested with a microbenchmark running 10 nice-0 tasks on 8 CPUs. Each task 
runs a trivial while (1) loop. The benchmark runs for 300 seconds and, at 
every T seconds, it samples for each task the following:

1. Actual CPU time the task received during the past 60 seconds.

2. Ideal CPU time it would receive under a perfect fair scheduler.

3. Lag = ideal time - actual time, where a positive lag means the task 
received less CPU time than its fair share and negative means it received 
more.

4. Error = lag / ideal time

The following shows the max and min errors among all samples for all tasks 
before and after applying the patch:

Before:

Sampling interval: 30 s
Max error: 100.00%
Min error: -25.00%

Sampling interval: 10 s
Max error: 27.62%
Min error: -25.00%

After:

Sampling interval: 30 s
Max error: 1.33%
Min error: -1.29%

Sampling interval: 10 s
Max error: 7.38%
Min error: -6.25%

The errors for the 10s sampling interval are still not as small as I had 
hoped for, but looks like it does have some improvement.

    tong

Signed-off-by: Tong Li <tong.n.li@intel.com>
---
--- linux-2.6-sched-devel-orig/kernel/sched.c	2007-09-15 22:00:48.000000000 -0700
+++ linux-2.6-sched-devel/kernel/sched.c	2007-09-18 22:10:52.000000000 -0700
@@ -1033,9 +1033,6 @@ void set_task_cpu(struct task_struct *p,
  	if (p->se.block_start)
  		p->se.block_start -= clock_offset;
  #endif
-	if (likely(new_rq->cfs.min_vruntime))
-		p->se.vruntime -= old_rq->cfs.min_vruntime -
-						new_rq->cfs.min_vruntime;

  	__set_task_cpu(p, new_cpu);
  }
@@ -1599,6 +1596,7 @@ static void __sched_fork(struct task_str
  	p->se.exec_start		= 0;
  	p->se.sum_exec_runtime		= 0;
  	p->se.prev_sum_exec_runtime	= 0;
+	p->se.vruntime			= 0;

  #ifdef CONFIG_SCHEDSTATS
  	p->se.wait_start		= 0;
@@ -2277,6 +2275,8 @@ find_busiest_group(struct sched_domain *
  		   int *sd_idle, cpumask_t *cpus, int *balance)
  {
  	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_group *max_vruntime_group = NULL;
+	u64 max_vruntime = 0;
  	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
  	unsigned long max_pull;
  	unsigned long busiest_load_per_task, busiest_nr_running;
@@ -2322,6 +2322,11 @@ find_busiest_group(struct sched_domain *

  			rq = cpu_rq(i);

+			if (rq->cfs.min_vruntime > max_vruntime) {
+				max_vruntime = rq->cfs.min_vruntime;
+				max_vruntime_group = group;
+			}
+
  			if (*sd_idle && rq->nr_running)
  				*sd_idle = 0;

@@ -2483,59 +2488,16 @@ group_next:
  	 * moved
  	 */
  	if (*imbalance < busiest_load_per_task) {
-		unsigned long tmp, pwr_now, pwr_move;
-		unsigned int imbn;
-
  small_imbalance:
-		pwr_move = pwr_now = 0;
-		imbn = 2;
-		if (this_nr_running) {
-			this_load_per_task /= this_nr_running;
-			if (busiest_load_per_task > this_load_per_task)
-				imbn = 1;
-		} else
-			this_load_per_task = SCHED_LOAD_SCALE;
-
-		if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
-					busiest_load_per_task * imbn) {
-			*imbalance = busiest_load_per_task;
-			return busiest;
-		}
-
-		/*
-		 * OK, we don't have enough imbalance to justify moving tasks,
-		 * however we may be able to increase total CPU power used by
-		 * moving them.
+		/* 
+		 * When there's small imbalance, move tasks only if this
+		 * sched_group contains a CPU whose min_vruntime is the 
+		 * maximum among all CPUs in the same domain.
  		 */
-
-		pwr_now += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load);
-		pwr_now += this->__cpu_power *
-				min(this_load_per_task, this_load);
-		pwr_now /= SCHED_LOAD_SCALE;
-
-		/* Amount of load we'd subtract */
-		tmp = sg_div_cpu_power(busiest,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		if (max_load > tmp)
-			pwr_move += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load - tmp);
-
-		/* Amount of load we'd add */
-		if (max_load * busiest->__cpu_power <
-				busiest_load_per_task * SCHED_LOAD_SCALE)
-			tmp = sg_div_cpu_power(this,
-					max_load * busiest->__cpu_power);
-		else
-			tmp = sg_div_cpu_power(this,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		pwr_move += this->__cpu_power *
-				min(this_load_per_task, this_load + tmp);
-		pwr_move /= SCHED_LOAD_SCALE;
-
-		/* Move if we gain throughput */
-		if (pwr_move > pwr_now)
+		if (max_vruntime_group == this)
  			*imbalance = busiest_load_per_task;
+		else
+			*imbalance = 0;
  	}

  	return busiest;
