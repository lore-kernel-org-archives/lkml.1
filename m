Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbXIYKgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbXIYKgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXIYKgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:36:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbXIYKga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:36:30 -0400
Date: Tue, 25 Sep 2007 12:36:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925103617.GA3426@elte.hu>
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <20070925094440.GK26289@linux.vnet.ibm.com> <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu> <20070925102855.GL26289@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925102855.GL26289@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Sep 25, 2007 at 12:10:44PM +0200, Ingo Molnar wrote:
> > So the patch below just removes the is_same_group() condition. But i can 
> > still see bad (and obvious) latencies with Mike's 2-hogs test:
> > 
> >  taskset 01 perl -e 'while (1) {}' &
> >  nice -19 taskset 02 perl -e 'while (1) {}' &
> > 
> > So something's amiss.
> 
> While I try recreating this myself, I wonder if this patch helps?

you should be able to recreate this easily by booting with maxcpus=1 and 
the commands above - then run a few instances of chew-max (without them 
being bound to any particular CPUs) and the latencies should show up.

i have tried your patch and it does not solve the problem - i think 
there's a more fundamental bug lurking, besides the wakeup latency 
problem.

Find below a /proc/sched_debug output of a really large latency. The 
latency is caused by the _huge_ (~450 seconds!) vruntime offset that 
'loop_silent' and 'sshd' has:

            task   PID         tree-key  switches  prio     exec-runtime
     -------------------------------------------------------------------
     loop_silent  2391     55344.211189       203   120     55344.211189
            sshd  2440    513334.978030         4   120    513334.978030
R            cat  2496    513672.558835         4   120    513672.558835

hm. perhaps this fixup in kernel/sched.c:set_task_cpu():

        p->se.vruntime -= old_rq->cfs.min_vruntime - new_rq->cfs.min_vruntime;

needs to become properly group-hierarchy aware?

	Ingo

------------------>
Sched Debug Version: v0.05-v20, 2.6.23-rc7 #89
now at 95878.065440 msecs
  .sysctl_sched_latency                    : 20.000000
  .sysctl_sched_min_granularity            : 2.000000
  .sysctl_sched_wakeup_granularity         : 2.000000
  .sysctl_sched_batch_wakeup_granularity   : 25.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 3

cpu#0, 1828.868 MHz
  .nr_running                    : 3
  .load                          : 3072
  .nr_switches                   : 32032
  .nr_load_updates               : 95906
  .nr_uninterruptible            : 4294967238
  .jiffies                       : 4294763202
  .next_balance                  : 4294.763420
  .curr->pid                     : 2496
  .clock                         : 95893.484495
  .idle_clock                    : 55385.089335
  .prev_clock_raw                : 84753.749367
  .clock_warps                   : 0
  .clock_overflows               : 1737
  .clock_deep_idle_events        : 71815
  .clock_max_delta               : 0.999843
  .cpu_load[0]                   : 3072
  .cpu_load[1]                   : 2560
  .cpu_load[2]                   : 2304
  .cpu_load[3]                   : 2176
  .cpu_load[4]                   : 2119

cfs_rq
  .exec_clock                    : 38202.223241
  .MIN_vruntime                  : 36334.281860
  .min_vruntime                  : 36334.279140
  .max_vruntime                  : 36334.281860
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 2
  .load                          : 3072
  .bkl_cnt                       : 3934
  .nr_spread_over                : 37

cfs_rq
  .exec_clock                    : 34769.316246
  .MIN_vruntime                  : 55344.211189
  .min_vruntime                  : 36334.279140
  .max_vruntime                  : 513334.978030
  .spread                        : 457990.766841
  .spread0                       : 0.000000
  .nr_running                    : 2
  .load                          : 2048
  .bkl_cnt                       : 3934
  .nr_spread_over                : 10

cfs_rq
  .exec_clock                    : 36.982394
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 36334.279140
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .bkl_cnt                       : 3934
  .nr_spread_over                : 1

cfs_rq
  .exec_clock                    : 20.244893
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 36334.279140
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .bkl_cnt                       : 3934
  .nr_spread_over                : 0

cfs_rq
  .exec_clock                    : 3305.155973
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 36334.279140
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .bkl_cnt                       : 3934
  .nr_spread_over                : 13

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     loop_silent  2391     55344.211189       203   120     55344.211189     34689.036169        42.855690
            sshd  2440    513334.978030         4   120    513334.978030         0.726092         0.000000
R            cat  2496    513672.558835         4   120    513672.558835         0.656690        26.294621

cpu#1, 1828.868 MHz
  .nr_running                    : 3
  .load                          : 2063
  .nr_switches                   : 22792
  .nr_load_updates               : 95625
  .nr_uninterruptible            : 58
  .jiffies                       : 4294763202
  .next_balance                  : 4294.763333
  .curr->pid                     : 2427
  .clock                         : 95643.855219
  .idle_clock                    : 54735.436719
  .prev_clock_raw                : 84754.067800
  .clock_warps                   : 0
  .clock_overflows               : 2521
  .clock_deep_idle_events        : 120633
  .clock_max_delta               : 0.999843
  .cpu_load[0]                   : 2063
  .cpu_load[1]                   : 2063
  .cpu_load[2]                   : 2063
  .cpu_load[3]                   : 2063
  .cpu_load[4]                   : 2063

cfs_rq
  .exec_clock                    : 38457.557282
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 35360.227495
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -974.051645
  .nr_running                    : 1
  .load                          : 1024
  .bkl_cnt                       : 456
  .nr_spread_over                : 18

cfs_rq
  .exec_clock                    : 32536.311766
  .MIN_vruntime                  : 610653.297636
  .min_vruntime                  : 35360.227495
  .max_vruntime                  : 610702.945490
  .spread                        : 49.647854
  .spread0                       : -974.051645
  .nr_running                    : 3
  .load                          : 2063
  .bkl_cnt                       : 456
  .nr_spread_over                : 202

cfs_rq
  .exec_clock                    : 17.392835
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 35360.227495
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -974.051645
  .nr_running                    : 0
  .load                          : 0
  .bkl_cnt                       : 456
  .nr_spread_over                : 1

cfs_rq
  .exec_clock                    : 0.428251
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 35360.227495
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -974.051645
  .nr_running                    : 0
  .load                          : 0
  .bkl_cnt                       : 456
  .nr_spread_over                : 1

cfs_rq
  .exec_clock                    : 5812.752391
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 35360.227495
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -974.051645
  .nr_running                    : 0
  .load                          : 0
  .bkl_cnt                       : 456
  .nr_spread_over                : 11

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     loop_silent  2400    610702.945490       859   139    610702.945490      8622.783425        13.951214
R       chew-max  2427    610644.849769      2057   120    610644.849769     13737.197972        10.079232
        chew-max  2433    610653.297636      1969   120    610653.297636      9679.778096        10.750704

