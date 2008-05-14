Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYENMar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYENMar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYENMaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:30:39 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:13015
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbYENMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:30:38 -0400
Message-ID: <482ADB69.8010305@qumranet.com>
Date: Wed, 14 May 2008 15:30:33 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [BUG] cpu hotplug vs scheduler
References: <4829A6A0.5040208@qumranet.com> <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com>
In-Reply-To: <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> Hi,
>
>   
>> [ ... ]
>>
>>  [4298303.713901] Call Trace:
>>  [4298303.713901]  [<ffffffff804373fe>] schedule+0x414/0x6ab
>>  [4298303.713901]  [<ffffffff8023060a>] ? hrtick_set+0x9d/0xe8
>>  [4298303.713901]  [<ffffffff8043772f>] ? thread_return+0x9a/0xbf
>>  [4298303.713901]  [<ffffffff80231652>] migration_thread+0x185/0x22d
>>  [4298303.713901]  [<ffffffff802314cd>] ? migration_thread+0x0/0x22d
>>  [4298303.713901]  [<ffffffff8024afe6>] kthread+0x49/0x77
>>  [4298303.713901]  [<ffffffff8020d228>] child_rip+0xa/0x12
>>  [4298303.713901]  [<ffffffff8024af9d>] ? kthread+0x0/0x77
>>  [4298303.713901]  [<ffffffff8020d21e>] ? child_rip+0x0/0x12
>>  [4298303.713901]
>>  [4298303.713901]
>>  [4298303.713901] Code: c0 74 28 48 8b 7b 58 4c 8d 60 f0 48 85 ff 74 10 4c
>> 89 e6 e8 df cc ff ff 85 c0 75 04 4c 8b 63 58 4c 89 e6 48 89 df e8 4a e5 ff
>> ff <49> 8b 9c 24 58 01 00 00 48 85 db 75 bf 49 83 ec 38 4c 89 ef 4c
>>  [4298303.713901] RIP  [<ffffffff8022e722>] pick_next_task_fair+0x55/0x7c
>>
>>  This seems to be the assignment to cfs_rq after pick_next_entity().
>>     
>
> [ cc'ed a few folks. ]
>
>
> So the cfs-tree likely gets out-of-sync. I pressume, it won't be
> reproducible with CONFIG_SCHED_GROUP options being disabled.
>
> Anyway, would you try one of these debug-patches (not sure about the
> workability of the second one though :-/)
>
> Let's check what are the values for 'cfs_rq->weight.load/nr_running'.
>
>   

Got this for the first patch:

[4302727.615522] Booting processor 3/7 ip 6000
[4302727.625923] Initializing CPU#3
[4302727.625923] Calibrating delay using timer specific routine.. 
5319.76 BogoMIPS (lpj=2659883)
[4302727.625923] CPU: L1 I cache: 32K, L1 D cache: 32K
[4302727.625923] CPU: L2 cache: 4096K
[4302727.625923] CPU: Physical Processor ID: 3
[4302727.625923] CPU: Processor Core ID: 1
[4302727.625923] x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106
[4302727.692484] CPU3: Intel(R) Xeon(R) CPU            5150  @ 2.66GHz 
stepping 06
[4302727.694236] checking TSC synchronization [CPU#1 -> CPU#3]: passed.
[4302727.824185] Switched to high resolution mode on CPU 3
[4302727.859184] kvm: enabling virtualization on CPU3
[4302727.859714] Sched Debug Version: v0.07, 2.6.26-rc2 #726
[4302727.859714] now at 6918576.148656 msecs
[4302727.859714]   .sysctl_sched_latency                    : 60.000000
[4302727.859714]   .sysctl_sched_min_granularity            : 12.000000
[4302727.859714]   .sysctl_sched_wakeup_granularity         : 30.000000
[4302727.859714]   .sysctl_sched_child_runs_first           : 0.000001
[4302727.860191]   .sysctl_sched_features                   : 895
[4302727.860191]
[4302727.860191] cpu#0, 2659.999 MHz
[4302727.860191]   .nr_running                    : 2
[4302727.860191]   .load                          : 841
[4302727.860191]   .nr_switches                   : 3427530
[4302727.861205]   .nr_load_updates               : 2183358
[4302727.861205]   .nr_uninterruptible            : 15
[4302727.861205]   .jiffies                       : 4301585875
[4302727.861205]   .next_balance                  : 4301.585696
[4302727.861205]   .curr->pid                     : 4678
[4302727.861205]   .clock                         : 6918579.002757
[4302727.862216]   .cpu_load[0]                   : 841
[4302727.862216]   .cpu_load[1]                   : 841
[4302727.862216]   .cpu_load[2]                   : 841
[4302727.862216]   .cpu_load[3]                   : 841
[4302727.862216]   .cpu_load[4]                   : 841
[4302727.862216]
[4302727.862216] cfs_rq[0]:
[4302727.867209]   .exec_clock                    : 3970.569663
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 5178969.408050
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : 0.000000
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 513
[4302727.867209]   .nr_spread_over                : 6
[4302727.867209]   .shares                        : 1024
[4302727.867209]
[4302727.867209] cfs_rq[0]:
[4302727.867209]   .exec_clock                    : 14.588517
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 5178971.405628
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : 0.000000
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 513
[4302727.867209]   .nr_spread_over                : 0
[4302727.867209]   .shares                        : 1024
[4302727.867209]
[4302727.867209] cfs_rq[0]:
[4302727.867209]   .exec_clock                    : 41.615870
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 5178973.403544
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : 0.000000
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 513
[4302727.867209]   .nr_spread_over                : 2
[4302727.867209]   .shares                        : 1024
[4302727.867209]
[4302727.867209] cfs_rq[0]:
[4302727.867209]   .exec_clock                    : 0.000000
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 5178975.401320
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : 0.000000
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 513
[4302727.867209]   .nr_spread_over                : 0
[4302727.867209]   .shares                        : 0
[4302727.867209]
[4302727.867209] cfs_rq[0]:
[4302727.867209]   .exec_clock                    : 0.000001
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 5178977.398314
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : 0.000000
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 513
[4302727.867209]   .nr_spread_over                : 0
[4302727.867209]   .shares                        : 0
[4302727.867209]
[4302727.867209] cfs_rq[0]:
[4302727.867209]   .exec_clock                    : 2165242.484786
[4302727.867209]   .MIN_vruntime                  : 10323214.742376
[4302727.867209]   .min_vruntime                  : 5178979.396488
[4302727.867209]   .max_vruntime                  : 10323214.742376
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : 0.000000
[4302727.867209]   .nr_running                    : 2
[4302727.867209]   .load                          : 2048
[4302727.867209]   .bkl_count                     : 513
[4302727.867209]   .nr_spread_over                : 1789825
[4302727.867209]   .shares                        : 843
[4302727.867209]
[4302727.867209] runnable tasks:
[4302727.867209]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[4302727.867209] 
----------------------------------------------------------------------------------------------------------
[4302727.867209] Rqemu-system-x86  4678  10323337.578253    553310   
120  10323337.578255   1380505.796830     42439.250368
[4302727.867209]
[4302727.867209] cpu#1, 2659.999 MHz
[4302727.867209]   .nr_running                    : 3
[4302727.867209]   .load                          : 415
[4302727.867209]   .nr_switches                   : 629498
[4302727.867209]   .nr_load_updates               : 838874
[4302727.867209]   .nr_uninterruptible            : -6
[4302727.867209]   .jiffies                       : 4301585895
[4302727.867209]   .next_balance                  : 4301.585634
[4302727.867209]   .curr->pid                     : 7799
[4302727.867209]   .clock                         : 6918576.130865
[4302727.867209]   .cpu_load[0]                   : 415
[4302727.867209]   .cpu_load[1]                   : 415
[4302727.867209]   .cpu_load[2]                   : 415
[4302727.867209]   .cpu_load[3]                   : 415
[4302727.867209]   .cpu_load[4]                   : 415
[4302727.867209]
[4302727.867209] cfs_rq[1]:
[4302727.867209]   .exec_clock                    : 74.637431
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 759396.868495
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : -4419588.520858
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 299
[4302727.867209]   .nr_spread_over                : 1
[4302727.867209]   .shares                        : 0
[4302727.867209]
[4302727.867209] cfs_rq[1]:
[4302727.867209]   .exec_clock                    : 22.707771
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 759396.868495
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : -4419590.518446
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 299
[4302727.867209]   .nr_spread_over                : 1
[4302727.867209]   .shares                        : 0
[4302727.867209]
[4302727.867209] cfs_rq[1]:
[4302727.867209]   .exec_clock                    : 0.033026
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 759396.868495
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : -4419590.518446
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 299
[4302727.867209]   .nr_spread_over                : 0
[4302727.867209]   .shares                        : 0
[4302727.867209]
[4302727.867209] cfs_rq[1]:
[4302727.867209]   .exec_clock                    : 0.000000
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 759396.868495
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : -4419590.518446
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 299
[4302727.867209]   .nr_spread_over                : 0
[4302727.867209]   .shares                        : 0
[4302727.867209]
[4302727.867209] cfs_rq[1]:
[4302727.867209]   .exec_clock                    : 0.026450
[4302727.867209]   .MIN_vruntime                  : 0.000001
[4302727.867209]   .min_vruntime                  : 759396.868495
[4302727.867209]   .max_vruntime                  : 0.000001
[4302727.867209]   .spread                        : 0.000000
[4302727.867209]   .spread0                       : -4419590.518446
[4302727.867209]   .nr_running                    : 0
[4302727.867209]   .load                          : 0
[4302727.867209]   .bkl_count                     : 299
[4302727.867209]   .nr_spread_over                : 0
[4302727.867209]   .shares                        : 0
[4302727.867209]
[4302727.867210] cfs_rq[1]:
[4302727.867210]   .exec_clock                    : 754981.092689
[4302727.867210]   .MIN_vruntime                  : 1239813.449102
[4302727.867210]   .min_vruntime                  : 759396.868495
[4302727.867210]   .max_vruntime                  : 1239819.334711
[4302727.867210]   .spread                        : 5.885609
[4302727.867210]   .spread0                       : -4419590.518446
[4302727.867210]   .nr_running                    : 3
[4302727.867210]   .load                          : 3072
[4302727.867210]   .bkl_count                     : 299
[4302727.867210]   .nr_spread_over                : 53817
[4302727.867210]   .shares                        : 415
[4302727.867210]
[4302727.867210] runnable tasks:
[4302727.867210]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[4302727.867210] 
----------------------------------------------------------------------------------------------------------
[4302727.900184]  qemu-system-x86  4987   1239813.449102    709828   
120   1239813.449102   1410504.949783     22865.206608
[4302727.900184]  qemu-system-x86  5052   1239819.334711    530481   
120   1239819.334711   1365146.519564     50937.064744
[4302727.900184] Rtoggle-processo  7799   1239811.208673     47886   
120   1239811.208673     57552.631854   1592798.974913
[4302727.900184]
[4302727.900184] cpu#3, 2659.999 MHz
[4302727.900184]   .nr_running                    : 1
[4302727.900184]   .load                          : 285
[4302727.900184]   .nr_switches                   : 611209
[4302727.900184]   .nr_load_updates               : 843051
[4302727.900184]   .nr_uninterruptible            : -2
[4302727.900184]   .jiffies                       : 4301585916
[4302727.900184]   .next_balance                  : 4301.586873
[4302727.900184]   .curr->pid                     : 0
[4302727.900184]   .clock                         : 6918576.376068
[4302727.900184]   .cpu_load[0]                   : 0
[4302727.900184]   .cpu_load[1]                   : 0
[4302727.900184]   .cpu_load[2]                   : 0
[4302727.900184]   .cpu_load[3]                   : 181
[4302727.900184]   .cpu_load[4]                   : 1108
[4302727.900184]
[4302727.900184] cfs_rq[3]:
[4302727.900184]   .exec_clock                    : 8.224765
[4302727.900184] BUG: spinlock recursion on CPU#3, swapper/0
[4302727.900184]  lock: ffff81000103df00, .magic: dead4ead, .owner: 
swapper/0, .owner_cpu: 3
[4302727.900184] Pid: 0, comm: swapper Not tainted 2.6.26-rc2 #726
[4302727.900184]
[4302727.900184] Call Trace:
[4302727.900184]  [<ffffffff803249de>] spin_bug+0x9e/0xe9
[4302727.900184]  [<ffffffff80324af4>] _raw_spin_lock+0x41/0x123
[4302727.900184]  [<ffffffff80439638>] _spin_lock_irqsave+0x2f/0x37
[4302727.900184]  [<ffffffff8022ef7c>] print_cfs_rq+0xca/0x46a
[4302727.900184]  [<ffffffff80231f97>] sched_debug_show+0x7a3/0xb8c
[4302727.900184]  [<ffffffff8023238d>] sysrq_sched_debug_show+0xd/0xf
[4302727.900184]  [<ffffffff802323ee>] pick_next_task_fair+0x5f/0x86
[4302727.900184]  [<ffffffff804373f6>] schedule+0x3fc/0x6ab
[4302727.900184]  [<ffffffff8024e03f>] ? ktime_get_ts+0x49/0x4e
[4302727.900184]  [<ffffffff80253a28>] ? tick_nohz_stop_idle+0x2d/0x54
[4302727.900184]  [<ffffffff8021283f>] ? mwait_idle+0x0/0x59
[4302727.900184]  [<ffffffff8020ae37>] cpu_idle+0xc8/0xd7
[4302727.900184]  [<ffffffff804332f1>] start_secondary+0x173/0x178
[4302727.900184]




-- 
error compiling committee.c: too many arguments to function

