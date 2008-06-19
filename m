Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbYFSSFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbYFSSFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYFSSFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:05:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:43554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYFSSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:05:29 -0400
Subject: Re: [BUG] CFS vs cpu hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20080619161949.GA11062@osiris.ibm.com>
References: <20080619161949.GA11062@osiris.ibm.com>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 20:05:10 +0200
Message-Id: <1213898711.3223.107.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-19 at 18:19 +0200, Heiko Carstens wrote:
> Hi Ingo, Peter,
> 
> I'm still seeing kernel crashes on cpu hotplug with Linus' current git tree.
> All I have to do is to make all cpus busy (make -j4 of the kernel source is
> sufficient) and then start cpu hotplug stress.
> It usually takes below a minute to crash the system like this:
> 
> Unable to handle kernel pointer dereference at virtual kernel address 005a800000031000
> Oops: 0038 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 1 Not tainted 2.6.26-rc6-00232-g9bedbcb #356
> Process swapper (pid: 0, task: 000000002fe7ccf8, ksp: 000000002fe93d78)
> Krnl PSW : 0400e00180000000 0000000000032c6c (pick_next_task_fair+0x34/0xb0)

I presume this is:

                se = pick_next_entity(cfs_rq);

>            R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:3 CC:2 PM:0 EA:3
> Krnl GPRS: 00000000001ff000 0000000000030bd8 000000000075a380 000000002fe7ccf8
>            0000000000386690 0000000000000008 0000000000000000 000000002fe7cf58
>            0000000000000001 000000000075a300 0000000000000000 000000002fe93d40
>            005a800000031201 0000000000386010 000000002fe93d78 000000002fe93d40
> Krnl Code: 0000000000032c5c: e3e0f0980024       stg     %r14,152(%r15)
>            0000000000032c62: d507d000c010       clc     0(8,%r13),16(%r12)
>            0000000000032c68: a784003c           brc     8,32ce0
>           >0000000000032c6c: d507d000c030       clc     0(8,%r13),48(%r12)
>            0000000000032c72: b904002c           lgr     %r2,%r12
>            0000000000032c76: a7a90000           lghi    %r10,0
>            0000000000032c7a: a7840021           brc     8,32cbc
>            0000000000032c7e: c0e5ffffefe3       brasl   %r14,30c44
> Call Trace:
> ([<000000000075a300>] 0x75a300)
>  [<000000000037195a>] schedule+0x162/0x7f4
>  [<000000000001a2be>] cpu_idle+0x1ca/0x25c
>  [<000000000036f368>] start_secondary+0xac/0xb8
>  [<0000000000000000>] 0x0
>  [<0000000000000000>] 0x0
> Last Breaking-Event-Address:
>  [<0000000000032cc6>] pick_next_task_fair+0x8e/0xb0
>  <4>---[ end trace 9bb55df196feedcc ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> 
> Please note that the above call trace is from s390, however Avi reported the
> same bug on x86_64.
> 
> I tried to bisect this and ended up somewhere at the beginning of 2.6.23 when
> the CFS patches got merged. Unfortunately it got harder and harder to reproduce
> so that I couldn't bisect this down to a single patch.
> 
> One observation however is that this always happens after cpu_up(), not
> cpu_down().
> 
> I modified the kernel sources a bit (actually only added a single "noinline")
> to get some sensible debug data and dumped a crashed system. These are the
> contents of the scheduler data structures which cause the crash:
> 
> >> px *(cfs_rq *) 0x75a380
> struct cfs_rq {
>         load = struct load_weight {
>                 weight = 0x800
>                 inv_weight = 0x0
>         }
>         nr_running = 0x1
>         exec_clock = 0x0
>         min_vruntime = 0xbf7e9776
>         tasks_timeline = struct rb_root {
>                 rb_node = (nil)
>         }
>         rb_leftmost = (nil)          <<<<<<<<<<<< shouldn't be NULL
>         tasks = struct list_head {
>                 next = 0x759328
>                 prev = 0x759328
>         }
>         balance_iterator = (nil)
>         curr = 0x759300
>         next = (nil)
>         nr_spread_over = 0x0
>         rq = 0x75a300
>         leaf_cfs_rq_list = struct list_head {
>                 next = (nil)
>                 prev = (nil)
>         }
>         tg = 0x564970
> }

Right, this cfs_rq is buggered. rb_leftmost may be null when the tree is
empty (as is the case here). 

However cfs_rq->curr != NULL and cfs_rq->nr_running != 0.

So this hints at a missing put_prev_entity() - we keep current out of
the tree, and put it back in right before we schedule(). The advantage
is that we don't need to reposition (dequeue/enqueue) curr in the tree
every time we update its virtual timeline.

So what races so that we can miss put_prev_entity() and how is cpu_up()
special..

> The sched_entity that belongs to the cfs_rq:
> 
> >> px *(sched_entity *) 0x759300
> struct sched_entity {
>         load = struct load_weight {
>                 weight = 0x800
>                 inv_weight = 0x1ffc01
>         }
>         run_node = struct rb_node {
>                 rb_parent_color = 0x1
>                 rb_right = (nil)
>                 rb_left = (nil)
>         }
>         group_node = struct list_head {
>                 next = 0x75a3b8
>                 prev = 0x75a3b8
>         }
>         on_rq = 0x1
>         exec_start = 0x189685acb4aa46
>         sum_exec_runtime = 0x188a2b84c
>         vruntime = 0xd036bd29
>         prev_sum_exec_runtime = 0x1672e3f62
>         last_wakeup = 0x0
>         avg_overlap = 0x0
>         parent = (nil)
>         cfs_rq = 0x75a380
>         my_q = 0x759400
> }
> 
> And the rq:
> 
> >> px *(rq *) 0x75a300
> struct rq {
>         lock = spinlock_t {
>                 raw_lock = raw_spinlock_t {
>                         owner_cpu = 0xfffffffe
>                 }
>                 break_lock = 0x1
>                 magic = 0xdead4ead
>                 owner_cpu = 0x1
>                 owner = 0x2ef95350
>         }
>         nr_running = 0x1
>         cpu_load = {
>                 [0] 0x3062
>                 [1] 0x2bdf
>                 [2] 0x20db
>                 [3] 0x171e
>                 [4] 0x1010
>         }
>         idle_at_tick = 0x0
>         last_tick_seen = 0x0
>         in_nohz_recently = 0x0
>         load = struct load_weight {
>                 weight = 0xc31
>                 inv_weight = 0x0
>         }
>         nr_load_updates = 0x95f
>         nr_switches = 0x3f68
>         cfs = struct cfs_rq {
>                 load = struct load_weight {
>                         weight = 0x800
>                         inv_weight = 0x0
>                 }
>                 nr_running = 0x1
>                 exec_clock = 0x0
>                 min_vruntime = 0xbf7e9776
>                 tasks_timeline = struct rb_root {
>                         rb_node = (nil)
>                 }
>                 rb_leftmost = (nil)
>                 tasks = struct list_head {
>                         next = 0x759328
>                         prev = 0x759328
>                 }
>                 balance_iterator = (nil)
>                 curr = 0x759300
>                 next = (nil)
>                 nr_spread_over = 0x0
>                 rq = 0x75a300
>                 leaf_cfs_rq_list = struct list_head {
>                         next = (nil)
>                         prev = (nil)
>                 }
>                 tg = 0x564970
>         }
>         rt = struct rt_rq {
>                 active = struct rt_prio_array {
>                         bitmap = {
>                                 [0] 0x0
>                                 [1] 0x1000000000
>                         }
>                         queue = {
>                                 [0] struct list_head {
>                                         next = 0x75a418
>                                         prev = 0x75a418
>                                 }
>                                 [1] struct list_head {
>                                         next = 0x75a428
>                                         prev = 0x75a428
>                                 }
>                                 [2] struct list_head {
>                                         next = 0x75a438
>                                         prev = 0x75a438
>                                 }
>                                 [3] struct list_head {
>                                         next = 0x75a448
>                                         prev = 0x75a448
>                                 }
>                                 [4] struct list_head {
>                                         next = 0x75a458
>                                         prev = 0x75a458
>                                 }
>                                 [5] struct list_head {
>                                         next = 0x75a468
>                                         prev = 0x75a468
>                                 }
>                                 [6] struct list_head {
>                                         next = 0x75a478
>                                         prev = 0x75a478
>                                 }
>                                 [7] struct list_head {
>                                         next = 0x75a488
>                                         prev = 0x75a488
>                                 }
>                                 [8] struct list_head {
>                                         next = 0x75a498
>                                         prev = 0x75a498
>                                 }
>                                 [9] struct list_head {
>                                         next = 0x75a4a8
>                                         prev = 0x75a4a8
>                                 }
>                                 [10] struct list_head {
>                                         next = 0x75a4b8
>                                         prev = 0x75a4b8
>                                 }
>                                 [11] struct list_head {
>                                         next = 0x75a4c8
>                                         prev = 0x75a4c8
>                                 }
>                                 [12] struct list_head {
>                                         next = 0x75a4d8
>                                         prev = 0x75a4d8
>                                 }
>                                 [13] struct list_head {
>                                         next = 0x75a4e8
>                                         prev = 0x75a4e8
>                                 }
>                                 [14] struct list_head {
>                                         next = 0x75a4f8
>                                         prev = 0x75a4f8
>                                 }
>                                 [15] struct list_head {
>                                         next = 0x75a508
>                                         prev = 0x75a508
>                                 }
>                                 [16] struct list_head {
>                                         next = 0x75a518
>                                         prev = 0x75a518
>                                 }
>                                 [17] struct list_head {
>                                         next = 0x75a528
>                                         prev = 0x75a528
>                                 }
>                                 [18] struct list_head {
>                                         next = 0x75a538
>                                         prev = 0x75a538
>                                 }
>                                 [19] struct list_head {
>                                         next = 0x75a548
>                                         prev = 0x75a548
>                                 }
>                                 [20] struct list_head {
>                                         next = 0x75a558
>                                         prev = 0x75a558
>                                 }
>                                 [21] struct list_head {
>                                         next = 0x75a568
>                                         prev = 0x75a568
>                                 }
>                                 [22] struct list_head {
>                                         next = 0x75a578
>                                         prev = 0x75a578
>                                 }
>                                 [23] struct list_head {
>                                         next = 0x75a588
>                                         prev = 0x75a588
>                                 }
>                                 [24] struct list_head {
>                                         next = 0x75a598
>                                         prev = 0x75a598
>                                 }
>                                 [25] struct list_head {
>                                         next = 0x75a5a8
>                                         prev = 0x75a5a8
>                                 }
>                                 [26] struct list_head {
>                                         next = 0x75a5b8
>                                         prev = 0x75a5b8
>                                 }
>                                 [27] struct list_head {
>                                         next = 0x75a5c8
>                                         prev = 0x75a5c8
>                                 }
>                                 [28] struct list_head {
>                                         next = 0x75a5d8
>                                         prev = 0x75a5d8
>                                 }
>                                 [29] struct list_head {
>                                         next = 0x75a5e8
>                                         prev = 0x75a5e8
>                                 }
>                                 [30] struct list_head {
>                                         next = 0x75a5f8
>                                         prev = 0x75a5f8
>                                 }
>                                 [31] struct list_head {
>                                         next = 0x75a608
>                                         prev = 0x75a608
>                                 }
>                                 [32] struct list_head {
>                                         next = 0x75a618
>                                         prev = 0x75a618
>                                 }
>                                 [33] struct list_head {
>                                         next = 0x75a628
>                                         prev = 0x75a628
>                                 }
>                                 [34] struct list_head {
>                                         next = 0x75a638
>                                         prev = 0x75a638
>                                 }
>                                 [35] struct list_head {
>                                         next = 0x75a648
>                                         prev = 0x75a648
>                                 }
>                                 [36] struct list_head {
>                                         next = 0x75a658
>                                         prev = 0x75a658
>                                 }
>                                 [37] struct list_head {
>                                         next = 0x75a668
>                                         prev = 0x75a668
>                                 }
>                                 [38] struct list_head {
>                                         next = 0x75a678
>                                         prev = 0x75a678
>                                 }
>                                 [39] struct list_head {
>                                         next = 0x75a688
>                                         prev = 0x75a688
>                                 }
>                                 [40] struct list_head {
>                                         next = 0x75a698
>                                         prev = 0x75a698
>                                 }
>                                 [41] struct list_head {
>                                         next = 0x75a6a8
>                                         prev = 0x75a6a8
>                                 }
>                                 [42] struct list_head {
>                                         next = 0x75a6b8
>                                         prev = 0x75a6b8
>                                 }
>                                 [43] struct list_head {
>                                         next = 0x75a6c8
>                                         prev = 0x75a6c8
>                                 }
>                                 [44] struct list_head {
>                                         next = 0x75a6d8
>                                         prev = 0x75a6d8
>                                 }
>                                 [45] struct list_head {
>                                         next = 0x75a6e8
>                                         prev = 0x75a6e8
>                                 }
>                                 [46] struct list_head {
>                                         next = 0x75a6f8
>                                         prev = 0x75a6f8
>                                 }
>                                 [47] struct list_head {
>                                         next = 0x75a708
>                                         prev = 0x75a708
>                                 }
>                                 [48] struct list_head {
>                                         next = 0x75a718
>                                         prev = 0x75a718
>                                 }
>                                 [49] struct list_head {
>                                         next = 0x75a728
>                                         prev = 0x75a728
>                                 }
>                                 [50] struct list_head {
>                                         next = 0x75a738
>                                         prev = 0x75a738
>                                 }
>                                 [51] struct list_head {
>                                         next = 0x75a748
>                                         prev = 0x75a748
>                                 }
>                                 [52] struct list_head {
>                                         next = 0x75a758
>                                         prev = 0x75a758
>                                 }
>                                 [53] struct list_head {
>                                         next = 0x75a768
>                                         prev = 0x75a768
>                                 }
>                                 [54] struct list_head {
>                                         next = 0x75a778
>                                         prev = 0x75a778
>                                 }
>                                 [55] struct list_head {
>                                         next = 0x75a788
>                                         prev = 0x75a788
>                                 }
>                                 [56] struct list_head {
>                                         next = 0x75a798
>                                         prev = 0x75a798
>                                 }
>                                 [57] struct list_head {
>                                         next = 0x75a7a8
>                                         prev = 0x75a7a8
>                                 }
>                                 [58] struct list_head {
>                                         next = 0x75a7b8
>                                         prev = 0x75a7b8
>                                 }
>                                 [59] struct list_head {
>                                         next = 0x75a7c8
>                                         prev = 0x75a7c8
>                                 }
>                                 [60] struct list_head {
>                                         next = 0x75a7d8
>                                         prev = 0x75a7d8
>                                 }
>                                 [61] struct list_head {
>                                         next = 0x75a7e8
>                                         prev = 0x75a7e8
>                                 }
>                                 [62] struct list_head {
>                                         next = 0x75a7f8
>                                         prev = 0x75a7f8
>                                 }
>                                 [63] struct list_head {
>                                         next = 0x75a808
>                                         prev = 0x75a808
>                                 }
>                                 [64] struct list_head {
>                                         next = 0x75a818
>                                         prev = 0x75a818
>                                 }
>                                 [65] struct list_head {
>                                         next = 0x75a828
>                                         prev = 0x75a828
>                                 }
>                                 [66] struct list_head {
>                                         next = 0x75a838
>                                         prev = 0x75a838
>                                 }
>                                 [67] struct list_head {
>                                         next = 0x75a848
>                                         prev = 0x75a848
>                                 }
>                                 [68] struct list_head {
>                                         next = 0x75a858
>                                         prev = 0x75a858
>                                 }
>                                 [69] struct list_head {
>                                         next = 0x75a868
>                                         prev = 0x75a868
>                                 }
>                                 [70] struct list_head {
>                                         next = 0x75a878
>                                         prev = 0x75a878
>                                 }
>                                 [71] struct list_head {
>                                         next = 0x75a888
>                                         prev = 0x75a888
>                                 }
>                                 [72] struct list_head {
>                                         next = 0x75a898
>                                         prev = 0x75a898
>                                 }
>                                 [73] struct list_head {
>                                         next = 0x75a8a8
>                                         prev = 0x75a8a8
>                                 }
>                                 [74] struct list_head {
>                                         next = 0x75a8b8
>                                         prev = 0x75a8b8
>                                 }
>                                 [75] struct list_head {
>                                         next = 0x75a8c8
>                                         prev = 0x75a8c8
>                                 }
>                                 [76] struct list_head {
>                                         next = 0x75a8d8
>                                         prev = 0x75a8d8
>                                 }
>                                 [77] struct list_head {
>                                         next = 0x75a8e8
>                                         prev = 0x75a8e8
>                                 }
>                                 [78] struct list_head {
>                                         next = 0x75a8f8
>                                         prev = 0x75a8f8
>                                 }
>                                 [79] struct list_head {
>                                         next = 0x75a908
>                                         prev = 0x75a908
>                                 }
>                                 [80] struct list_head {
>                                         next = 0x75a918
>                                         prev = 0x75a918
>                                 }
>                                 [81] struct list_head {
>                                         next = 0x75a928
>                                         prev = 0x75a928
>                                 }
>                                 [82] struct list_head {
>                                         next = 0x75a938
>                                         prev = 0x75a938
>                                 }
>                                 [83] struct list_head {
>                                         next = 0x75a948
>                                         prev = 0x75a948
>                                 }
>                                 [84] struct list_head {
>                                         next = 0x75a958
>                                         prev = 0x75a958
>                                 }
>                                 [85] struct list_head {
>                                         next = 0x75a968
>                                         prev = 0x75a968
>                                 }
>                                 [86] struct list_head {
>                                         next = 0x75a978
>                                         prev = 0x75a978
>                                 }
>                                 [87] struct list_head {
>                                         next = 0x75a988
>                                         prev = 0x75a988
>                                 }
>                                 [88] struct list_head {
>                                         next = 0x75a998
>                                         prev = 0x75a998
>                                 }
>                                 [89] struct list_head {
>                                         next = 0x75a9a8
>                                         prev = 0x75a9a8
>                                 }
>                                 [90] struct list_head {
>                                         next = 0x75a9b8
>                                         prev = 0x75a9b8
>                                 }
>                                 [91] struct list_head {
>                                         next = 0x75a9c8
>                                         prev = 0x75a9c8
>                                 }
>                                 [92] struct list_head {
>                                         next = 0x75a9d8
>                                         prev = 0x75a9d8
>                                 }
>                                 [93] struct list_head {
>                                         next = 0x75a9e8
>                                         prev = 0x75a9e8
>                                 }
>                                 [94] struct list_head {
>                                         next = 0x75a9f8
>                                         prev = 0x75a9f8
>                                 }
>                                 [95] struct list_head {
>                                         next = 0x75aa08
>                                         prev = 0x75aa08
>                                 }
>                                 [96] struct list_head {
>                                         next = 0x75aa18
>                                         prev = 0x75aa18
>                                 }
>                                 [97] struct list_head {
>                                         next = 0x75aa28
>                                         prev = 0x75aa28
>                                 }
>                                 [98] struct list_head {
>                                         next = 0x75aa38
>                                         prev = 0x75aa38
>                                 }
>                                 [99] struct list_head {
>                                         next = 0x75aa48
>                                         prev = 0x75aa48
>                                 }
>                         }
>                 }
>                 rt_nr_running = 0x0
>                 highest_prio = 0x64
>                 rt_nr_migratory = 0x0
>                 overloaded = 0x0
>                 rt_throttled = 0x0
>                 rt_time = 0x123a999
>                 rt_runtime = 0x389fd980
>                 rt_runtime_lock = spinlock_t {
>                         raw_lock = raw_spinlock_t {
>                                 owner_cpu = 0x0
>                         }
>                         break_lock = 0x0
>                         magic = 0xdead4ead
>                         owner_cpu = 0xffffffff
>                         owner = 0xffffffffffffffff
>                 }
>         }
>         leaf_cfs_rq_list = struct list_head {
>                 next = 0x2f5a8970
>                 prev = 0x759470
>         }
>         nr_uninterruptible = 0xfffffffffffffffe
>         curr = 0x2ef95350
>         idle = 0x2fe7ccf8
>         next_balance = 0x10000093b
>         prev_mm = (nil)
>         clock = 0x189685acb4d536
>         nr_iowait = atomic_t {
>                 counter = 0x0
>         }
>         rd = 0x564a58
>         sd = (nil)
>         active_balance = 0x0
>         push_cpu = 0x0
>         cpu = 0x1
>         migration_thread = 0x2ef95350
>         migration_queue = struct list_head {
>                 next = 0x75ab10
>                 prev = 0x75ab10
>         }
>         rq_lock_key = struct lock_class_key {
>         }
> }
> 
> Hopefully all of this debug data is of any use. If you need more, just let me
> know.
> 
> Thanks!

