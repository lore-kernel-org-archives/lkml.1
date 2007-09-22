Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbXIVD1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbXIVD1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 23:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbXIVD1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 23:27:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:54177 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbXIVD1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 23:27:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,286,1186383600"; 
   d="scan'208";a="147825229"
Date: Fri, 21 Sep 2007 20:27:33 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Tong Li <tong.n.li@intel.com>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
In-Reply-To: <1190275870.9232.6.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
  <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com> 
 <1190183324.9737.7.camel@Homer.simpson.net>  <1190188261.9185.21.camel@Homer.simpson.net>
  <1190191368.8687.5.camel@Homer.simpson.net>  <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
  <1190264114.6411.4.camel@Homer.simpson.net>  <1190272507.27867.20.camel@Homer.simpson.net>
  <20070920075155.GA31641@elte.hu> <1190275870.9232.6.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Could you try this patch to see if it solves the latency problem?

   tong

Changes:

1. Modified vruntime adjustment logic in set_task_cpu(). See comments in 
code. This fixed the negative vruntime problem.

2. This code in update_curr() seems to be wrong:

if (unlikely(!curr))
 	return sync_vruntime(cfs_rq);

cfs_rq->curr can be NULL even if cfs_rq->nr_running is non-zero (e.g., 
when an RT task is running). We only want to call sync_vruntime when 
cfs_rq->nr_running is 0. This fixed the large latency problem (at least in 
my tests).

Signed-off-by: Tong Li <tong.n.li@intel.com>
---
diff -uprN linux-2.6-sched-devel-orig/kernel/sched.c linux-2.6-sched-devel/kernel/sched.c
--- linux-2.6-sched-devel-orig/kernel/sched.c	2007-09-20 12:15:41.000000000 -0700
+++ linux-2.6-sched-devel/kernel/sched.c	2007-09-21 19:40:08.000000000 -0700
@@ -1033,9 +1033,20 @@ void set_task_cpu(struct task_struct *p,
  	if (p->se.block_start)
  		p->se.block_start -= clock_offset;
  #endif
-	if (likely(new_rq->cfs.min_vruntime))
-		p->se.vruntime -= old_rq->cfs.min_vruntime -
-						new_rq->cfs.min_vruntime;
+	/* 
+	 * Reset p's vruntime if it moves to new_cpu whose min_vruntime is 
+	 * 100,000,000 (equivalent to 100ms for nice-0 tasks) larger or
+	 * smaller than p's vruntime. This improves interactivity when
+	 * pinned and unpinned tasks co-exist. For example, pinning a few
+	 * tasks to a CPU can cause its min_vruntime much smaller than the
+	 * other CPUs. If a task moves to this CPU, its vruntime can be so
+	 * large it won't be scheduled until the locally pinned tasks'
+	 * vruntimes catch up, causing large delays.
+	 */
+	if (unlikely(old_cpu != new_cpu && p->se.vruntime && 
+		(p->se.vruntime > new_rq->cfs.min_vruntime + 100000000 || 
+		 p->se.vruntime + 100000000 < new_rq->cfs.min_vruntime)))
+		p->se.vruntime = new_rq->cfs.min_vruntime;

  	__set_task_cpu(p, new_cpu);
  }
@@ -1599,6 +1610,7 @@ static void __sched_fork(struct task_str
  	p->se.exec_start		= 0;
  	p->se.sum_exec_runtime		= 0;
  	p->se.prev_sum_exec_runtime	= 0;
+	p->se.vruntime			= 0;

  #ifdef CONFIG_SCHEDSTATS
  	p->se.wait_start		= 0;
diff -uprN linux-2.6-sched-devel-orig/kernel/sched_fair.c linux-2.6-sched-devel/kernel/sched_fair.c
--- linux-2.6-sched-devel-orig/kernel/sched_fair.c	2007-09-20 12:15:41.000000000 -0700
+++ linux-2.6-sched-devel/kernel/sched_fair.c	2007-09-21 17:23:09.000000000 -0700
@@ -306,8 +306,10 @@ static void update_curr(struct cfs_rq *c
  	u64 now = rq_of(cfs_rq)->clock;
  	unsigned long delta_exec;

-	if (unlikely(!curr))
+	if (unlikely(!cfs_rq->nr_running))
  		return sync_vruntime(cfs_rq);
+	if (unlikely(!curr))
+		return;

  	/*
  	 * Get the amount of time the current task was running
