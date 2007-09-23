Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXIWLh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXIWLh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 07:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXIWLhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 07:37:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:32926 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751230AbXIWLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 07:37:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Pi7oIW5DPy5kl0kWjb5RkQ/Aj8GNy0c7G8MPaDj
	oegdDmMzg5PGod
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1190531662.11524.15.camel@Homer.simpson.net>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920075155.GA31641@elte.hu>
	 <1190275870.9232.6.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
	 <1190455308.7404.19.camel@Homer.simpson.net>
	 <1190531662.11524.15.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 13:37:45 +0200
Message-Id: <1190547465.15044.16.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I haven't chased down the exact scenario, but using a min_vruntime which
is about to change definitely seems to be what's causing my latency
woes.  Does the below cure your fairness woes as well?

(first bit is just some debug format changes for your convenience if you
try it)

diff -uprNX /root/dontdiff git/linux-2.6.sched-devel/kernel/sched_debug.c linux-2.6.23-rc7.d/kernel/sched_debug.c
--- git/linux-2.6.sched-devel/kernel/sched_debug.c	2007-09-22 13:37:32.000000000 +0200
+++ linux-2.6.23-rc7.d/kernel/sched_debug.c	2007-09-21 12:12:27.000000000 +0200
@@ -67,7 +67,7 @@ print_task(struct seq_file *m, struct rq
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
 #ifdef CONFIG_SCHEDSTATS
-	SEQ_printf(m, "%15Ld.%06ld %15Ld.%06ld %15Ld.%06ld\n",
+	SEQ_printf(m, "%9Ld.%06ld %9Ld.%06ld %9Ld.%06ld\n",
 		SPLIT_NS(p->se.vruntime),
 		SPLIT_NS(p->se.sum_exec_runtime),
 		SPLIT_NS(p->se.sum_sleep_runtime));
@@ -83,10 +83,10 @@ static void print_rq(struct seq_file *m,
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
-	"            task   PID        tree-key  switches  prio"
-	"    exec-runtime        sum-exec       sum-sleep\n"
+	"            task   PID         tree-key  switches  prio"
+	"     exec-runtime         sum-exec        sum-sleep\n"
 	"------------------------------------------------------"
-	"------------------------------------------------");
+	"----------------------------------------------------\n");
 
 	read_lock_irq(&tasklist_lock);
 
@@ -134,7 +134,7 @@ void print_cfs_rq(struct seq_file *m, in
 	spread0 = min_vruntime - rq0_min_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
 			SPLIT_NS(spread0));
-	SEQ_printf(m, "  .%-30s: %ld\n", "spread0",
+	SEQ_printf(m, "  .%-30s: %ld\n", "nr_sync_min_vruntime",
 			cfs_rq->nr_sync_min_vruntime);
 }
 
diff -uprNX /root/dontdiff git/linux-2.6.sched-devel/kernel/sched_fair.c linux-2.6.23-rc7.d/kernel/sched_fair.c
--- git/linux-2.6.sched-devel/kernel/sched_fair.c	2007-09-22 13:37:32.000000000 +0200
+++ linux-2.6.23-rc7.d/kernel/sched_fair.c	2007-09-23 12:53:11.000000000 +0200
@@ -290,14 +290,19 @@ __update_curr(struct cfs_rq *cfs_rq, str
 static void sync_vruntime(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq;
-	int cpu;
+	int cpu, wrote = 0;
 
 	for_each_online_cpu(cpu) {
 		rq = &per_cpu(runqueues, cpu);
+		if (!spin_trylock(&rq->lock))
+			continue;
 		cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime,
 				rq->cfs.min_vruntime);
+		spin_unlock(&rq->lock);
+		wrote++;
 	}
-	schedstat_inc(cfs_rq, nr_sync_min_vruntime);
+	if (wrote)
+		schedstat_inc(cfs_rq, nr_sync_min_vruntime);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -306,8 +311,10 @@ static void update_curr(struct cfs_rq *c
 	u64 now = rq_of(cfs_rq)->clock;
 	unsigned long delta_exec;
 
-	if (unlikely(!curr))
+	if (unlikely(!cfs_rq->nr_running))
 		return sync_vruntime(cfs_rq);
+	if (unlikely(!curr))
+		return;
 
 	/*
 	 * Get the amount of time the current task was running


