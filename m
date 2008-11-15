Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbYKOBPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYKOBPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 20:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYKOBPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 20:15:21 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYKOBPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 20:15:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=FeulDUGJ9oTjArSR+UX/vd2yg4Gc1aPYxfYGi4zpGEamivI+Op0QHgU9roXl/A3KV
	hikqASB8l3957tvuPdhag==
Date: Fri, 14 Nov 2008 17:14:53 -0800
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: busted CFS group load balancer?
Message-ID: <20081115011452.GA28135@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that the fair-group load balancer in 2.6.27 does not work
properly.  It broke down severely with real-world application workload
here at google.  We are trying to use CFS cgroup scheduler as a
proportional scheduler to control CPU cycle allocation for concurrent
groups of tasks on the same server machine.  For example, we have one
cgroup named 'bee' which has a cfs weight of 1024, and another cgroup
named 'ant' that has a cfs weight of 2.  Ideally, I would expect 99.8%
of CPU cycles goes into 'bee' cgroup while the remaining 0.2% goes into
'ant'.  However, when evaluating 2.6.27, the result deviates significantly
from the expectation.  It appears that the fair-group load balancer is sub
par and not doing its job properly.

Attached is a snapshot of /proc/sched_debug.  Two CPUs were dominated by
tasks of a very low weight 'ant' cgroup, while multiple tasks in higher
weight 'bee' cgroup landed on the same CPU and competing among themselves.
I think the load balancer does its job poorly.  Have you seen similar l-b
deficiency?

- Ken


Sched Debug Version: v0.07, 2.6.27 #1
now at 62931690.049344 msecs
  .sysctl_sched_latency                    : 80.000000
  .sysctl_sched_min_granularity            : 16.000000
  .sysctl_sched_wakeup_granularity         : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 7935

cpu#0, 2333.417 MHz
  .nr_running                    : 2
  .load                          : 103
  .nr_switches                   : 12943039
  .nr_load_updates               : 62738664
  .nr_uninterruptible            : -260
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599094
  .curr->pid                     : 12721
  .clock                         : 62969376.294574
  .cpu_load[0]                   : 103
  .cpu_load[1]                   : 121
  .cpu_load[2]                   : 143
  .cpu_load[3]                   : 158
  .cpu_load[4]                   : 166

cfs_rq[0]:/ant
  .exec_clock                    : 53371626.919067
  .MIN_vruntime                  : 60790257.707167
  .min_vruntime                  : 44998074.291781
  .max_vruntime                  : 60790257.707167
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14251
  .sched_switch                  : 0
  .sched_count                   : 12981786
  .sched_goidle                  : 288336
  .ttwu_count                    : 6565365
  .ttwu_local                    : 5442677
  .bkl_count                     : 46781
  .nr_spread_over                : 12567
  .shares                        : 0

cfs_rq[0]:/bee
  .exec_clock                    : 9183712.055274
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 44998074.291781
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14251
  .sched_switch                  : 0
  .sched_count                   : 12981786
  .sched_goidle                  : 288336
  .ttwu_count                    : 6565365
  .ttwu_local                    : 5442677
  .bkl_count                     : 46781
  .nr_spread_over                : 442289
  .shares                        : 101

cfs_rq[0]:/
  .exec_clock                    : 62567144.106498
  .MIN_vruntime                  : 44998074.291781
  .min_vruntime                  : 44998074.291781
  .max_vruntime                  : 44998074.291781
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 2
  .load                          : 103
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14251
  .sched_switch                  : 0
  .sched_count                   : 12981786
  .sched_goidle                  : 288336
  .ttwu_count                    : 6565365
  .ttwu_local                    : 5442677
  .bkl_count                     : 46781
  .nr_spread_over                : 43480
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             hog  4202  60790257.707167   5421910   120  60790257.707167  53371613.637974         0.000000 /ant
R           hpro 12721  10434396.891434    425169   120  10434396.891434   2351102.444642   1015320.568226 /bee

cpu#1, 2333.417 MHz
  .nr_running                    : 2
  .load                          : 102
  .nr_switches                   : 35564399
  .nr_load_updates               : 62728095
  .nr_uninterruptible            : 371
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599133
  .curr->pid                     : 12727
  .clock                         : 62969376.338300
  .cpu_load[0]                   : 103
  .cpu_load[1]                   : 109
  .cpu_load[2]                   : 121
  .cpu_load[3]                   : 136
  .cpu_load[4]                   : 150

cfs_rq[1]:/ant
  .exec_clock                    : 50553231.251769
  .MIN_vruntime                  : 98877044.002500
  .min_vruntime                  : 49317332.550674
  .max_vruntime                  : 98877044.002500
  .spread                        : 0.000000
  .spread0                       : 4319258.258893
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 19005
  .sched_switch                  : 0
  .sched_count                   : 35601762
  .sched_goidle                  : 284437
  .ttwu_count                    : 18517385
  .ttwu_local                    : 16585787
  .bkl_count                     : 24693
  .nr_spread_over                : 21321
  .shares                        : 0

cfs_rq[1]:/bee
  .exec_clock                    : 12002883.375364
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 49317332.550674
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 4319258.258893
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 19005
  .sched_switch                  : 0
  .sched_count                   : 35601762
  .sched_goidle                  : 284437
  .ttwu_count                    : 18517385
  .ttwu_local                    : 16585787
  .bkl_count                     : 24693
  .nr_spread_over                : 341849
  .shares                        : 100

cfs_rq[1]:/
  .exec_clock                    : 62568079.552049
  .MIN_vruntime                  : 49317332.550674
  .min_vruntime                  : 49317332.550674
  .max_vruntime                  : 49317332.550674
  .spread                        : 0.000000
  .spread0                       : 4319258.258893
  .nr_running                    : 2
  .load                          : 102
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 19005
  .sched_switch                  : 0
  .sched_count                   : 35601762
  .sched_goidle                  : 284437
  .ttwu_count                    : 18517385
  .ttwu_local                    : 16585787
  .bkl_count                     : 24693
  .nr_spread_over                : 50967
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             hog  4200  98877044.002500  14797192   120  98877044.002500  50553231.092595         0.000000 /ant
R           hpro 12727  14039095.103079    422222   120  14039095.103079   2347785.641546   1017814.287309 /bee

cpu#2, 2333.417 MHz
  .nr_running                    : 3
  .load                          : 205
  .nr_switches                   : 5452324
  .nr_load_updates               : 62703726
  .nr_uninterruptible            : 1143
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599024
  .curr->pid                     : 12728
  .clock                         : 62969376.294927
  .cpu_load[0]                   : 205
  .cpu_load[1]                   : 198
  .cpu_load[2]                   : 190
  .cpu_load[3]                   : 184
  .cpu_load[4]                   : 183

cfs_rq[2]:/ant
  .exec_clock                    : 53265000.243513
  .MIN_vruntime                  : 62505737.284348
  .min_vruntime                  : 44986496.033419
  .max_vruntime                  : 62505737.284348
  .spread                        : 0.000000
  .spread0                       : -11578.258362
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14697
  .sched_switch                  : 0
  .sched_count                   : 5470658
  .sched_goidle                  : 47945
  .ttwu_count                    : 2792641
  .ttwu_local                    : 1831019
  .bkl_count                     : 43426
  .nr_spread_over                : 16899
  .shares                        : 0

cfs_rq[2]:/bee
  .exec_clock                    : 9290734.241942
  .MIN_vruntime                  : 10838701.944779
  .min_vruntime                  : 44986496.033419
  .max_vruntime                  : 10838701.944779
  .spread                        : 0.000000
  .spread0                       : -11578.258362
  .nr_running                    : 2
  .load                          : 2048
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14697
  .sched_switch                  : 0
  .sched_count                   : 5470658
  .sched_goidle                  : 47945
  .ttwu_count                    : 2792641
  .ttwu_local                    : 1831019
  .bkl_count                     : 43426
  .nr_spread_over                : 403151
  .shares                        : 203

cfs_rq[2]:/
  .exec_clock                    : 62557630.621219
  .MIN_vruntime                  : 44986496.033419
  .min_vruntime                  : 44986496.033419
  .max_vruntime                  : 44986496.033419
  .spread                        : 0.000000
  .spread0                       : -11578.258362
  .nr_running                    : 2
  .load                          : 205
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14697
  .sched_switch                  : 0
  .sched_count                   : 5470658
  .sched_goidle                  : 47945
  .ttwu_count                    : 2792641
  .ttwu_local                    : 1831019
  .bkl_count                     : 43426
  .nr_spread_over                : 83787
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             hog  4205  62505737.284348   1919921   120  62505737.284348  53264991.605391         0.000000 /ant
            hpro 12726  10838701.944779    423772   120  10838701.944779   2344927.648792   1017455.081051 /bee
R           hpro 12728  10838780.058709    421699   120  10838780.058709   2345123.009711   1019061.435473 /bee

cpu#3, 2333.417 MHz
  .nr_running                    : 1
  .load                          : 2
  .nr_switches                   : 4682853
  .nr_load_updates               : 62711242
  .nr_uninterruptible            : -1414
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599007
  .curr->pid                     : 4204
  .clock                         : 62969376.294206
  .cpu_load[0]                   : 2
  .cpu_load[1]                   : 48
  .cpu_load[2]                   : 68
  .cpu_load[3]                   : 78
  .cpu_load[4]                   : 82

cfs_rq[3]:/ant
  .exec_clock                    : 53314990.134015
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 44976333.787158
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -21740.504623
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14720
  .sched_switch                  : 0
  .sched_count                   : 4699788
  .sched_goidle                  : 23093
  .ttwu_count                    : 2413046
  .ttwu_local                    : 1516294
  .bkl_count                     : 38944
  .nr_spread_over                : 36602
  .shares                        : 0

cfs_rq[3]:/bee
  .exec_clock                    : 9240891.195912
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 44976333.787158
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -21740.504623
  .nr_running                    : 0
  .load                          : 0
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14720
  .sched_switch                  : 0
  .sched_count                   : 4699788
  .sched_goidle                  : 23093
  .ttwu_count                    : 2413046
  .ttwu_local                    : 1516294
  .bkl_count                     : 38944
  .nr_spread_over                : 368326
  .shares                        : 101

cfs_rq[3]:/
  .exec_clock                    : 62560353.760642
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 44976333.787158
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -21740.504623
  .nr_running                    : 1
  .load                          : 2
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 14720
  .sched_switch                  : 0
  .sched_count                   : 4699788
  .sched_goidle                  : 23093
  .ttwu_count                    : 2413046
  .ttwu_local                    : 1516294
  .bkl_count                     : 38944
  .nr_spread_over                : 278060
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            hog  4204  61265712.229407   1590630   120  61265712.229407  53314966.642964         0.000000 /ant

cpu#4, 2333.417 MHz
  .nr_running                    : 3
  .load                          : 205
  .nr_switches                   : 6034988
  .nr_load_updates               : 62701982
  .nr_uninterruptible            : -489
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599098
  .curr->pid                     : 12722
  .clock                         : 62969376.294969
  .cpu_load[0]                   : 205
  .cpu_load[1]                   : 198
  .cpu_load[2]                   : 190
  .cpu_load[3]                   : 181
  .cpu_load[4]                   : 163

cfs_rq[4]:/ant
  .exec_clock                    : 57463524.397256
  .MIN_vruntime                  : 61439338.118634
  .min_vruntime                  : 43422727.063373
  .max_vruntime                  : 61439338.118634
  .spread                        : 0.000000
  .spread0                       : -1575347.228408
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 7979
  .sched_switch                  : 0
  .sched_count                   : 6043766
  .sched_goidle                  : 18552
  .ttwu_count                    : 3180073
  .ttwu_local                    : 2221510
  .bkl_count                     : 8680
  .nr_spread_over                : 19946
  .shares                        : 0

cfs_rq[4]:/bee
  .exec_clock                    : 5093116.134219
  .MIN_vruntime                  : 5520870.121561
  .min_vruntime                  : 43422727.063373
  .max_vruntime                  : 5520870.121561
  .spread                        : 0.000000
  .spread0                       : -1575347.228408
  .nr_running                    : 2
  .load                          : 2048
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 7979
  .sched_switch                  : 0
  .sched_count                   : 6043766
  .sched_goidle                  : 18552
  .ttwu_count                    : 3180073
  .ttwu_local                    : 2221510
  .bkl_count                     : 8680
  .nr_spread_over                : 369128
  .shares                        : 203

cfs_rq[4]:/
  .exec_clock                    : 62557994.778412
  .MIN_vruntime                  : 43422727.063373
  .min_vruntime                  : 43422727.063373
  .max_vruntime                  : 43422727.063373
  .spread                        : 0.000000
  .spread0                       : -1575347.228408
  .nr_running                    : 2
  .load                          : 205
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 7979
  .sched_switch                  : 0
  .sched_count                   : 6043766
  .sched_goidle                  : 18552
  .ttwu_count                    : 3180073
  .ttwu_local                    : 2221510
  .bkl_count                     : 8680
  .nr_spread_over                : 191336
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             hog  4199  61439338.118634   2252113   120  61439338.118634  57463477.501906         0.000000 /ant
R           hpro 12722   5520893.049620    423940   120   5520893.049620   2353601.970167   1016247.261338 /bee
            hpro 12725   5520870.121561    417763   120   5520870.121561   2352852.333553   1020343.133648 /bee

cpu#5, 2333.417 MHz
  .nr_running                    : 2
  .load                          : 102
  .nr_switches                   : 36228963
  .nr_load_updates               : 62712542
  .nr_uninterruptible            : 1684
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599094
  .curr->pid                     : 12724
  .clock                         : 62969376.294760
  .cpu_load[0]                   : 103
  .cpu_load[1]                   : 109
  .cpu_load[2]                   : 115
  .cpu_load[3]                   : 112
  .cpu_load[4]                   : 105

cfs_rq[5]:/ant
  .exec_clock                    : 50479803.539169
  .MIN_vruntime                  : 97702539.108896
  .min_vruntime                  : 49951986.086422
  .max_vruntime                  : 97702539.108896
  .spread                        : 0.000000
  .spread0                       : 4953911.794641
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 19372
  .sched_switch                  : 0
  .sched_count                   : 36250568
  .sched_goidle                  : 40214
  .ttwu_count                    : 19127707
  .ttwu_local                    : 17723882
  .bkl_count                     : 1632
  .nr_spread_over                : 17524
  .shares                        : 0

cfs_rq[5]:/bee
  .exec_clock                    : 12079214.598498
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 49951986.086422
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 4953911.794641
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 19372
  .sched_switch                  : 0
  .sched_count                   : 36250568
  .sched_goidle                  : 40214
  .ttwu_count                    : 19127707
  .ttwu_local                    : 17723882
  .bkl_count                     : 1632
  .nr_spread_over                : 257170
  .shares                        : 100

cfs_rq[5]:/
  .exec_clock                    : 62560310.280302
  .MIN_vruntime                  : 49951986.086422
  .min_vruntime                  : 49951986.086422
  .max_vruntime                  : 49951986.086422
  .spread                        : 0.000000
  .spread0                       : 4953911.794641
  .nr_running                    : 2
  .load                          : 102
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 19372
  .sched_switch                  : 0
  .sched_count                   : 36250568
  .sched_goidle                  : 40214
  .ttwu_count                    : 19127707
  .ttwu_local                    : 17723882
  .bkl_count                     : 1632
  .nr_spread_over                : 51023
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             hog  4201  97702539.108896  15313291   120  97702539.108896  50479803.305704         0.000000 /ant
R           hpro 12724  13553228.752335    428968   120  13553228.752335   2359267.848257   1021475.119277 /bee

cpu#6, 2333.417 MHz
  .nr_running                    : 2
  .load                          : 103
  .nr_switches                   : 5740323
  .nr_load_updates               : 62705164
  .nr_uninterruptible            : -483
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599088
  .curr->pid                     : 18280
  .clock                         : 62969376.299341
  .cpu_load[0]                   : 103
  .cpu_load[1]                   : 78
  .cpu_load[2]                   : 47
  .cpu_load[3]                   : 26
  .cpu_load[4]                   : 15

cfs_rq[6]:/ant
  .exec_clock                    : 57412441.111827
  .MIN_vruntime                  : 60648319.346763
  .min_vruntime                  : 43681901.531907
  .max_vruntime                  : 60648319.346763
  .spread                        : 0.000000
  .spread0                       : -1316172.759874
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 8292
  .sched_switch                  : 0
  .sched_count                   : 5749245
  .sched_goidle                  : 17290
  .ttwu_count                    : 2988054
  .ttwu_local                    : 2083371
  .bkl_count                     : 8904
  .nr_spread_over                : 11085
  .shares                        : 0

cfs_rq[6]:/bee
  .exec_clock                    : 5144065.252998
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 43681901.531907
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1316172.759874
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 8292
  .sched_switch                  : 0
  .sched_count                   : 5749245
  .sched_goidle                  : 17290
  .ttwu_count                    : 2988054
  .ttwu_local                    : 2083371
  .bkl_count                     : 8904
  .nr_spread_over                : 372629
  .shares                        : 101

cfs_rq[6]:/
  .exec_clock                    : 62561266.440406
  .MIN_vruntime                  : 43681901.531907
  .min_vruntime                  : 43681901.531907
  .max_vruntime                  : 43681901.531907
  .spread                        : 0.000000
  .spread0                       : -1316172.759874
  .nr_running                    : 2
  .load                          : 103
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 8292
  .sched_switch                  : 0
  .sched_count                   : 5749245
  .sched_goidle                  : 17290
  .ttwu_count                    : 2988054
  .ttwu_local                    : 2083371
  .bkl_count                     : 8904
  .nr_spread_over                : 73618
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             hog  4198  60648319.346763   2155112   120  60648319.346763  57412425.922637         0.000000 /ant
R            cat 18280   5564927.823046         3   120   5564927.823046         1.995011         0.012258 /bee

cpu#7, 2333.417 MHz
  .nr_running                    : 2
  .load                          : 103
  .nr_switches                   : 6910780
  .nr_load_updates               : 62705080
  .nr_uninterruptible            : -552
  .jiffies                       : 4357598986
  .next_balance                  : 4357.599016
  .curr->pid                     : 12723
  .clock                         : 62969376.305631
  .cpu_load[0]                   : 103
  .cpu_load[1]                   : 99
  .cpu_load[2]                   : 94
  .cpu_load[3]                   : 93
  .cpu_load[4]                   : 103

cfs_rq[7]:/ant
  .exec_clock                    : 57417395.762701
  .MIN_vruntime                  : 61941066.080427
  .min_vruntime                  : 43566817.296538
  .max_vruntime                  : 61941066.080427
  .spread                        : 0.000000
  .spread0                       : -1431256.995243
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 8673
  .sched_switch                  : 0
  .sched_count                   : 6928312
  .sched_goidle                  : 24889
  .ttwu_count                    : 3645419
  .ttwu_local                    : 2666683
  .bkl_count                     : 16970
  .nr_spread_over                : 12049
  .shares                        : 0

cfs_rq[7]:/bee
  .exec_clock                    : 5142675.452517
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 43566817.296538
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1431256.995243
  .nr_running                    : 1
  .load                          : 1024
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 8673
  .sched_switch                  : 0
  .sched_count                   : 6928312
  .sched_goidle                  : 24889
  .ttwu_count                    : 3645419
  .ttwu_local                    : 2666683
  .bkl_count                     : 16970
  .nr_spread_over                : 389009
  .shares                        : 101

cfs_rq[7]:/
  .exec_clock                    : 62561246.337270
  .MIN_vruntime                  : 43566817.296538
  .min_vruntime                  : 43566817.296538
  .max_vruntime                  : 43566817.296538
  .spread                        : 0.000000
  .spread0                       : -1431256.995243
  .nr_running                    : 2
  .load                          : 103
  .yld_exp_empty                 : 0
  .yld_act_empty                 : 0
  .yld_both_empty                : 0
  .yld_count                     : 8673
  .sched_switch                  : 0
  .sched_count                   : 6928312
  .sched_goidle                  : 24889
  .ttwu_count                    : 3645419
  .ttwu_local                    : 2666683
  .bkl_count                     : 16970
  .nr_spread_over                : 31384
  .shares                        : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             hog  4203  61941066.080427   2636297   120  61941066.080427  57417288.830170         0.000000 /ant
R           hpro 12723   5580819.679520    424397   120   5580819.679520   2359524.675698   1020120.649702 /bee

