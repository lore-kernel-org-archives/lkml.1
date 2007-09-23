Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbXIWHOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbXIWHOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 03:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXIWHO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 03:14:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:44989 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750753AbXIWHO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 03:14:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BtaEjb9qBeTJqVKQaKPdOcJuVSExDhON0YGI47X
	cFbJp7LPBA2C/4
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1190455308.7404.19.camel@Homer.simpson.net>
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
Content-Type: multipart/mixed; boundary="=-PHWclrcrGUqacNpxleWB"
Date: Sun, 23 Sep 2007 09:14:22 +0200
Message-Id: <1190531662.11524.15.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PHWclrcrGUqacNpxleWB
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2007-09-22 at 12:01 +0200, Mike Galbraith wrote:
> On Fri, 2007-09-21 at 20:27 -0700, Tong Li wrote:
> > Mike,
> > 
> > Could you try this patch to see if it solves the latency problem?
> 
> No, but it helps some when running two un-pinned busy loops, one at nice
> 0, and the other at nice 19.  Yesterday I hit latencies of up to 1.2
> _seconds_ doing this, and logging sched_debug and /proc/`pidof
> Xorg`/sched from SCHED_RR shells.

Looking at a log (snippet attached) from this morning with the last hunk
of your patch still intact, it looks like min_vruntime is being modified
after a task is queued.  If you look at the snippet, you'll see the nice
19 bash busy loop on CPU1 with a vruntime of 3010385.345325, and one
second later on CPU1 with it's vruntime at 2814952.425082, but
min_vruntime is 3061874.838356.

I took a hammer to it, and my latencies running this test went away.

diff -uprNX /root/dontdiff git/linux-2.6.sched-devel/kernel/sched_fair.c linux-2.6.23-rc7.d/kernel/sched_fair.c
--- git/linux-2.6.sched-devel/kernel/sched_fair.c	2007-09-22 13:37:32.000000000 +0200
+++ linux-2.6.23-rc7.d/kernel/sched_fair.c	2007-09-23 08:29:38.000000000 +0200
@@ -290,14 +290,19 @@ __update_curr(struct cfs_rq *cfs_rq, str
 static void sync_vruntime(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq;
-	int cpu;
+	int cpu, wrote = 0;
 
 	for_each_online_cpu(cpu) {
 		rq = &per_cpu(runqueues, cpu);
+		if (spin_is_locked(&rq->lock))
+			continue;
+		smp_wmb();
 		cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime,
 				rq->cfs.min_vruntime);
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


--=-PHWclrcrGUqacNpxleWB
Content-Disposition: attachment; filename=sched_debug.save2
Content-Type: text/plain; name=sched_debug.save2; charset=us-ascii
Content-Transfer-Encoding: 7bit

Sched Debug Version: v0.05-v20, 2.6.23-rc7-smp-d #57
now at 682203.468012 msecs

cpu#0, 2992.611 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 196616
  .nr_load_updates               : 118674
  .nr_uninterruptible            : 4294966769
  .jiffies                       : 382203
  .next_balance                  : 0.382295
  .curr->pid                     : 6322
  .clock                         : 118656.313628
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 705696.529916
  .clock_warps                   : 0
  .clock_overflows               : 171665
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 0.999848
  .cpu_load[0]                   : 178561
  .cpu_load[1]                   : 134173
  .cpu_load[2]                   : 78694
  .cpu_load[3]                   : 42634
  .cpu_load[4]                   : 22523

cfs_rq
  .exec_clock                    : 71557.235360
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 2798832.982741
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_sync_min_vruntime          : 76120

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R           bash  6322   2798832.982741       603   120   2798832.982741      4423.956624     18419.152603

cpu#1, 2992.611 MHz
  .nr_running                    : 2
  .load                          : 177537
  .nr_switches                   : 154505
  .nr_load_updates               : 121679
  .nr_uninterruptible            : 527
  .jiffies                       : 382203
  .next_balance                  : 0.382234
  .curr->pid                     : 6633
  .clock                         : 121660.572179
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 705696.537576
  .clock_warps                   : 0
  .clock_overflows               : 127876
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 0.999848
  .cpu_load[0]                   : 177537
  .cpu_load[1]                   : 155347
  .cpu_load[2]                   : 102646
  .cpu_load[3]                   : 58613
  .cpu_load[4]                   : 31265

cfs_rq
  .exec_clock                    : 32989.995528
  .MIN_vruntime                  : 3010385.345325
  .min_vruntime                  : 3010385.345325
  .max_vruntime                  : 3010385.345325
  .spread                        : 0.000000
  .spread0                       : 211552.362584
  .nr_sync_min_vruntime          : 62486

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  6324   3010385.345325       448   139   3010385.345325      4089.662816     18698.650954
R            cat  6633   2771173.427733         1    98   2771173.427733         0.099100         0.000000

Sched Debug Version: v0.05-v20, 2.6.23-rc7-smp-d #57
now at 683208.774593 msecs

cpu#0, 2992.611 MHz
  .nr_running                    : 3
  .load                          : 4160
  .nr_switches                   : 197117
  .nr_load_updates               : 119679
  .nr_uninterruptible            : 4294966769
  .jiffies                       : 383208
  .next_balance                  : 0.383306
  .curr->pid                     : 6324
  .clock                         : 119661.418716
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 706701.424587
  .clock_warps                   : 0
  .clock_overflows               : 171860
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 0.999848
  .cpu_load[0]                   : 181682
  .cpu_load[1]                   : 92921
  .cpu_load[2]                   : 48541
  .cpu_load[3]                   : 26351
  .cpu_load[4]                   : 15382

cfs_rq
  .exec_clock                    : 72539.463238
  .MIN_vruntime                  : 3061874.838356
  .min_vruntime                  : 3061894.838356
  .max_vruntime                  : 3061874.838356
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_sync_min_vruntime          : 76121

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     ksoftirqd/0     4   3061874.838356     10021   115   3061874.838356        20.667212    119265.488607
 hald-addon-stor  4815   3061874.838356      1842   120   3061874.838356        63.581807    108065.895877
R           bash  6324   2814952.425082       516   139   2814952.425082      5069.832468     18698.650954

cpu#1, 2992.611 MHz
  .nr_running                    : 2
  .load                          : 178546
  .nr_switches                   : 154769
  .nr_load_updates               : 122684
  .nr_uninterruptible            : 527
  .jiffies                       : 383208
  .next_balance                  : 0.383218
  .curr->pid                     : 6642
  .clock                         : 122665.419419
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 706701.171511
  .clock_warps                   : 0
  .clock_overflows               : 128064
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 0.999848
  .cpu_load[0]                   : 178546
  .cpu_load[1]                   : 178546
  .cpu_load[2]                   : 128623
  .cpu_load[3]                   : 76639
  .cpu_load[4]                   : 42094

cfs_rq
  .exec_clock                    : 33972.085103
  .MIN_vruntime                  : 3062114.882734
  .min_vruntime                  : 3062114.882734
  .max_vruntime                  : 3062114.882734
  .spread                        : 0.000000
  .spread0                       : 220.044378
  .nr_sync_min_vruntime          : 62486

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  6322   3062114.882734       747   120   3062114.882734      5360.029921     18419.152603
R            cat  6642   2771173.427733         1    98   2771173.427733         0.099097         0.000000

--=-PHWclrcrGUqacNpxleWB--

