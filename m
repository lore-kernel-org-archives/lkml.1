Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYKXRWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYKXRWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYKXRWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:22:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbYKXRWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:22:36 -0500
Date: Mon, 24 Nov 2008 18:22:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PULL] cpumask conversion patches for sched
Message-ID: <20081124172204.GA11971@elte.hu>
References: <200811250238.53883.rusty@rustcorp.com.au> <20081124171749.GB27851@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20081124171749.GB27851@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> Based on these good test results i've also integrated a new 
> cpus4096-next tree and pushed it out for linux-next pickup.

... and exactly one minute after i sent that mail, -tip testing found 
a CPU hotplug lockdep splat, introduced by your patches:

  [ INFO: hard-safe -> hard-unsafe lock order detected ]

see the full splat below. Reproducer is:

  echo 0 > /sys/devices/system/cpu/cpu1/online
  sleep 1
  echo 1 > /sys/devices/system/cpu/cpu1/online
  sleep 1
  echo 0 > /sys/devices/system/cpu/cpu1/online
  sleep 1
  echo 1 > /sys/devices/system/cpu/cpu1/online

config attached. I've excluded the topic for now.

	Ingo

-------------->
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code

======================================================
[ INFO: hard-safe -> hard-unsafe lock order detected ]
2.6.28-rc6-tip-00766-g9f03358-dirty #1566
------------------------------------------------------
S99local/3134 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&p->alloc_lock){--..}, at: [<c01883e7>] cpuset_cpus_allowed_locked+0x27/0x50

and this task is already holding:
 (&rq->lock){++..}, at: [<c0140384>] task_rq_lock+0x54/0x90
which would create a new lock dependency:
 (&rq->lock){++..} -> (&p->alloc_lock){--..}

but this new dependency connects a hard-irq-safe lock:
 (&rq->lock){++..}
... which became hard-irq-safe at:
  [<c0173d9e>] __lock_acquire+0x9be/0x1380
  [<c01747e9>] lock_acquire+0x89/0xc0
  [<c09257e8>] _spin_lock+0x38/0x50
  [<c014c465>] scheduler_tick+0x45/0x1c0
  [<c0159462>] update_process_times+0x52/0x70
  [<c016dd0a>] tick_periodic+0x2a/0x80
  [<c016dd7e>] tick_handle_periodic+0x1e/0x80
  [<c011ef15>] timer_interrupt+0x35/0x80
  [<c018ece0>] handle_IRQ_event+0x30/0x70
  [<c0190955>] handle_level_irq+0x75/0xe0
  [<ffffffff>] 0xffffffff

to a hard-irq-unsafe lock:
 (&p->alloc_lock){--..}
... which became hard-irq-unsafe at:
...  [<c0173c51>] __lock_acquire+0x871/0x1380
  [<c01747e9>] lock_acquire+0x89/0xc0
  [<c09257e8>] _spin_lock+0x38/0x50
  [<c01c7707>] set_task_comm+0x27/0x60
  [<c0163f01>] kthreadd+0x21/0x160
  [<c011cd0b>] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff

other info that might help us debug this:

6 locks held by S99local/3134:
 #0:  (&buffer->mutex){--..}, at: [<c02025ef>] sysfs_write_file+0x2f/0x110
 #1:  (cpu_add_remove_lock){--..}, at: [<c0150af4>] cpu_maps_update_begin+0x14/0x20
 #2:  (&cpu_hotplug.lock){--..}, at: [<c0150b5f>] cpu_hotplug_begin+0x1f/0x50
 #3:  (callback_mutex){--..}, at: [<c0187cd4>] cpuset_lock+0x14/0x20
 #4:  (tasklist_lock){..--}, at: [<c0921bda>] migration_call+0x1da/0x4a0
 #5:  (&rq->lock){++..}, at: [<c0140384>] task_rq_lock+0x54/0x90

the hard-irq-safe lock's dependencies:
-> (&rq->lock){++..} ops: 143281 {
   initial-use  at:
                        [<c017359d>] __lock_acquire+0x1bd/0x1380
                        [<c01747e9>] lock_acquire+0x89/0xc0
                        [<c0925908>] _spin_lock_irqsave+0x58/0x70
                        [<c014332d>] rq_attach_root+0x1d/0xb0
                        [<c0ce8fa7>] sched_init+0x327/0x4a0
                        [<c0cd2694>] start_kernel+0x154/0x360
                        [<c0cd2066>] i386_start_kernel+0x66/0x70
                        [<ffffffff>] 0xffffffff
   in-hardirq-W at:
                        [<c0173d9e>] __lock_acquire+0x9be/0x1380
                        [<c01747e9>] lock_acquire+0x89/0xc0
                        [<c09257e8>] _spin_lock+0x38/0x50
                        [<c014c465>] scheduler_tick+0x45/0x1c0
                        [<c0159462>] update_process_times+0x52/0x70
                        [<c016dd0a>] tick_periodic+0x2a/0x80
                        [<c016dd7e>] tick_handle_periodic+0x1e/0x80
                        [<c011ef15>] timer_interrupt+0x35/0x80
                        [<c018ece0>] handle_IRQ_event+0x30/0x70
                        [<c0190955>] handle_level_irq+0x75/0xe0
                        [<ffffffff>] 0xffffffff
   in-softirq-W at:
                        [<c0173b46>] __lock_acquire+0x766/0x1380
                        [<c01747e9>] lock_acquire+0x89/0xc0
                        [<c0925908>] _spin_lock_irqsave+0x58/0x70
                        [<c014782a>] tg_shares_up+0x13a/0x190
                        [<c013f9cb>] walk_tg_tree+0xab/0xe0
                        [<c0143416>] update_shares+0x56/0x70
                        [<c0149c6f>] rebalance_domains+0xff/0x440
                        [<c014a9a6>] run_rebalance_domains+0x36/0xc0
                        [<c01547b9>] __do_softirq+0xa9/0x180
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c0d7ff20>] __key.44534+0x0/0x8
 -> (&vec->lock){.+..} ops: 859 {
    initial-use  at:
                          [<c017359d>] __lock_acquire+0x1bd/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c0925908>] _spin_lock_irqsave+0x58/0x70
                          [<c019f57f>] cpupri_set+0x7f/0xd0
                          [<c01425b0>] rq_online_rt+0x40/0x70
                          [<c013f4db>] set_rq_online+0x4b/0x60
                          [<c0143387>] rq_attach_root+0x77/0xb0
                          [<c0ce8fa7>] sched_init+0x327/0x4a0
                          [<c0cd2694>] start_kernel+0x154/0x360
                          [<c0cd2066>] i386_start_kernel+0x66/0x70
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c0173b46>] __lock_acquire+0x766/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c0925908>] _spin_lock_irqsave+0x58/0x70
                          [<c019f54c>] cpupri_set+0x4c/0xd0
                          [<c01481bb>] __enqueue_rt_entity+0xcb/0x200
                          [<c014835b>] enqueue_rt_entity+0x1b/0x30
                          [<c014839f>] enqueue_task_rt+0x2f/0x50
                          [<c013fd9c>] enqueue_task+0x5c/0x80
                          [<c013fddf>] activate_task+0x1f/0x30
                          [<c0147de8>] try_to_wake_up+0x248/0x2c0
                          [<c0147eb4>] wake_up_process+0x14/0x20
                          [<c0158fbd>] process_timeout+0xd/0x10
                          [<c0158dd1>] run_timer_softirq+0x181/0x1c0
                          [<c01547b9>] __do_softirq+0xa9/0x180
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c133c0f4>] __key.13648+0x0/0xc
 ... acquired at:
   [<c017437a>] __lock_acquire+0xf9a/0x1380
   [<c01747e9>] lock_acquire+0x89/0xc0
   [<c0925908>] _spin_lock_irqsave+0x58/0x70
   [<c019f57f>] cpupri_set+0x7f/0xd0
   [<c01425b0>] rq_online_rt+0x40/0x70
   [<c013f4db>] set_rq_online+0x4b/0x60
   [<c0143387>] rq_attach_root+0x77/0xb0
   [<c0ce8fa7>] sched_init+0x327/0x4a0
   [<c0cd2694>] start_kernel+0x154/0x360
   [<c0cd2066>] i386_start_kernel+0x66/0x70
   [<ffffffff>] 0xffffffff

 -> (&rt_b->rt_runtime_lock){.+..} ops: 24 {
    initial-use  at:
                          [<c017359d>] __lock_acquire+0x1bd/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c09257e8>] _spin_lock+0x38/0x50
                          [<c014822c>] __enqueue_rt_entity+0x13c/0x200
                          [<c014835b>] enqueue_rt_entity+0x1b/0x30
                          [<c014839f>] enqueue_task_rt+0x2f/0x50
                          [<c013fd9c>] enqueue_task+0x5c/0x80
                          [<c013fddf>] activate_task+0x1f/0x30
                          [<c0147de8>] try_to_wake_up+0x248/0x2c0
                          [<c0147eb4>] wake_up_process+0x14/0x20
                          [<c0921a90>] migration_call+0x90/0x4a0
                          [<c0ce9158>] migration_init+0x38/0x50
                          [<c010111f>] do_one_initcall+0x2f/0x170
                          [<c0cd294a>] kernel_init+0x5a/0x170
                          [<c011cd0b>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c0173b46>] __lock_acquire+0x766/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c09257e8>] _spin_lock+0x38/0x50
                          [<c014822c>] __enqueue_rt_entity+0x13c/0x200
                          [<c014835b>] enqueue_rt_entity+0x1b/0x30
                          [<c014839f>] enqueue_task_rt+0x2f/0x50
                          [<c013fd9c>] enqueue_task+0x5c/0x80
                          [<c013fddf>] activate_task+0x1f/0x30
                          [<c0147de8>] try_to_wake_up+0x248/0x2c0
                          [<c0147eb4>] wake_up_process+0x14/0x20
                          [<c0149f6d>] rebalance_domains+0x3fd/0x440
                          [<c014a9a6>] run_rebalance_domains+0x36/0xc0
                          [<c01547b9>] __do_softirq+0xa9/0x180
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0d7ff10>] __key.35881+0x0/0x8
  -> (&cpu_base->lock){++..} ops: 25602 {
     initial-use  at:
                            [<c017359d>] __lock_acquire+0x1bd/0x1380
                            [<c01747e9>] lock_acquire+0x89/0xc0
                            [<c0925897>] _spin_lock_irq+0x47/0x60
                            [<c0167286>] run_hrtimer_pending+0x16/0x150
                            [<c0167b21>] hrtimer_run_pending+0x71/0x160
                            [<c0158c72>] run_timer_softirq+0x22/0x1c0
                            [<c01547b9>] __do_softirq+0xa9/0x180
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c0173d9e>] __lock_acquire+0x9be/0x1380
                            [<c01747e9>] lock_acquire+0x89/0xc0
                            [<c09257e8>] _spin_lock+0x38/0x50
                            [<c0167d09>] hrtimer_run_queues+0xf9/0x1a0
                            [<c01590cd>] run_local_timers+0xd/0x20
                            [<c0159444>] update_process_times+0x34/0x70
                            [<c016dd0a>] tick_periodic+0x2a/0x80
                            [<c016dd7e>] tick_handle_periodic+0x1e/0x80
                            [<c012fd0b>] smp_apic_timer_interrupt+0x5b/0x90
                            [<c011cbe1>] apic_timer_interrupt+0x2d/0x34
                            [<c01507b0>] printk+0x20/0x30
                            [<c0101201>] do_one_initcall+0x111/0x170
                            [<c0cd294a>] kernel_init+0x5a/0x170
                            [<c011cd0b>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
     in-softirq-W at:
                            [<c0173b46>] __lock_acquire+0x766/0x1380
                            [<c01747e9>] lock_acquire+0x89/0xc0
                            [<c0925897>] _spin_lock_irq+0x47/0x60
                            [<c0167286>] run_hrtimer_pending+0x16/0x150
                            [<c0167b21>] hrtimer_run_pending+0x71/0x160
                            [<c0158c72>] run_timer_softirq+0x22/0x1c0
                            [<c01547b9>] __do_softirq+0xa9/0x180
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0f82ed8>] __key.20177+0x0/0x8
  ... acquired at:
   [<c017437a>] __lock_acquire+0xf9a/0x1380
   [<c01747e9>] lock_acquire+0x89/0xc0
   [<c0925908>] _spin_lock_irqsave+0x58/0x70
   [<c0167618>] lock_hrtimer_base+0x28/0x50
   [<c01676ae>] hrtimer_start_range_ns+0x1e/0x180
   [<c0148273>] __enqueue_rt_entity+0x183/0x200
   [<c014835b>] enqueue_rt_entity+0x1b/0x30
   [<c014839f>] enqueue_task_rt+0x2f/0x50
   [<c013fd9c>] enqueue_task+0x5c/0x80
   [<c013fddf>] activate_task+0x1f/0x30
   [<c0147de8>] try_to_wake_up+0x248/0x2c0
   [<c0147eb4>] wake_up_process+0x14/0x20
   [<c0921a90>] migration_call+0x90/0x4a0
   [<c0ce9158>] migration_init+0x38/0x50
   [<c010111f>] do_one_initcall+0x2f/0x170
   [<c0cd294a>] kernel_init+0x5a/0x170
   [<c011cd0b>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  -> (&rt_rq->rt_runtime_lock){+...} ops: 458 {
     initial-use  at:
                            [<c017359d>] __lock_acquire+0x1bd/0x1380
                            [<c01747e9>] lock_acquire+0x89/0xc0
                            [<c09257e8>] _spin_lock+0x38/0x50
                            [<c014ada9>] update_curr_rt+0x169/0x250
                            [<c014afbb>] dequeue_task_rt+0x1b/0x40
                            [<c0140100>] dequeue_task+0xe0/0x130
                            [<c014016f>] deactivate_task+0x1f/0x30
                            [<c092388b>] schedule+0x49b/0x8c0
                            [<c014a585>] migration_thread+0x155/0x250
                            [<c0163ea7>] kthread+0x47/0x80
                            [<c011cd0b>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c0173d9e>] __lock_acquire+0x9be/0x1380
                            [<c01747e9>] lock_acquire+0x89/0xc0
                            [<c09257e8>] _spin_lock+0x38/0x50
                            [<c014b103>] sched_rt_period_timer+0x123/0x280
                            [<c01674ec>] __run_hrtimer+0x9c/0xb0
                            [<c0167d87>] hrtimer_run_queues+0x177/0x1a0
                            [<c01590cd>] run_local_timers+0xd/0x20
                            [<c0159444>] update_process_times+0x34/0x70
                            [<c016dd0a>] tick_periodic+0x2a/0x80
                            [<c016dd7e>] tick_handle_periodic+0x1e/0x80
                            [<c012fd0b>] smp_apic_timer_interrupt+0x5b/0x90
                            [<c011cbe1>] apic_timer_interrupt+0x2d/0x34
                            [<c01507b0>] printk+0x20/0x30
                            [<c0101226>] do_one_initcall+0x136/0x170
                            [<c0cd2a02>] kernel_init+0x112/0x170
                            [<c011cd0b>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c0d7ff18>] __key.44461+0x0/0x8
  ... acquired at:
   [<c017437a>] __lock_acquire+0xf9a/0x1380
   [<c01747e9>] lock_acquire+0x89/0xc0
   [<c09257e8>] _spin_lock+0x38/0x50
   [<c0142474>] __enable_runtime+0x64/0xd0
   [<c0142596>] rq_online_rt+0x26/0x70
   [<c013f4db>] set_rq_online+0x4b/0x60
   [<c0921abe>] migration_call+0xbe/0x4a0
   [<c0168c8b>] notifier_call_chain+0x4b/0x70
   [<c0168d6e>] __raw_notifier_call_chain+0x1e/0x30
   [<c0168d9f>] raw_notifier_call_chain+0x1f/0x30
   [<c0921fb0>] _cpu_up+0xb0/0x100
   [<c092204d>] cpu_up+0x4d/0x70
   [<c0cd29a0>] kernel_init+0xb0/0x170
   [<c011cd0b>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c017437a>] __lock_acquire+0xf9a/0x1380
   [<c01747e9>] lock_acquire+0x89/0xc0
   [<c09257e8>] _spin_lock+0x38/0x50
   [<c014822c>] __enqueue_rt_entity+0x13c/0x200
   [<c014835b>] enqueue_rt_entity+0x1b/0x30
   [<c014839f>] enqueue_task_rt+0x2f/0x50
   [<c013fd9c>] enqueue_task+0x5c/0x80
   [<c013fddf>] activate_task+0x1f/0x30
   [<c0147de8>] try_to_wake_up+0x248/0x2c0
   [<c0147eb4>] wake_up_process+0x14/0x20
   [<c0921a90>] migration_call+0x90/0x4a0
   [<c0ce9158>] migration_init+0x38/0x50
   [<c010111f>] do_one_initcall+0x2f/0x170
   [<c0cd294a>] kernel_init+0x5a/0x170
   [<c011cd0b>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c017437a>] __lock_acquire+0xf9a/0x1380
   [<c01747e9>] lock_acquire+0x89/0xc0
   [<c09257e8>] _spin_lock+0x38/0x50
   [<c014ada9>] update_curr_rt+0x169/0x250
   [<c014afbb>] dequeue_task_rt+0x1b/0x40
   [<c0140100>] dequeue_task+0xe0/0x130
   [<c014016f>] deactivate_task+0x1f/0x30
   [<c092388b>] schedule+0x49b/0x8c0
   [<c014a585>] migration_thread+0x155/0x250
   [<c0163ea7>] kthread+0x47/0x80
   [<c011cd0b>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 -> (&rq->lock/1){.+..} ops: 617 {
    initial-use  at:
                          [<c017359d>] __lock_acquire+0x1bd/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c0925796>] _spin_lock_nested+0x36/0x50
                          [<c0147ab6>] double_rq_lock+0x76/0x90
                          [<c0149d02>] rebalance_domains+0x192/0x440
                          [<c014a9a6>] run_rebalance_domains+0x36/0xc0
                          [<c01547b9>] __do_softirq+0xa9/0x180
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c0173b46>] __lock_acquire+0x766/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c0925796>] _spin_lock_nested+0x36/0x50
                          [<c0147ab6>] double_rq_lock+0x76/0x90
                          [<c0149d02>] rebalance_domains+0x192/0x440
                          [<c014a9a6>] run_rebalance_domains+0x36/0xc0
                          [<c01547b9>] __do_softirq+0xa9/0x180
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c0d7ff21>] __key.44534+0x1/0x8
 ... acquired at:
   [<c017437a>] __lock_acquire+0xf9a/0x1380
   [<c01747e9>] lock_acquire+0x89/0xc0
   [<c0925796>] _spin_lock_nested+0x36/0x50
   [<c0147ab6>] double_rq_lock+0x76/0x90
   [<c0149d02>] rebalance_domains+0x192/0x440
   [<c014a9a6>] run_rebalance_domains+0x36/0xc0
   [<c01547b9>] __do_softirq+0xa9/0x180
   [<ffffffff>] 0xffffffff

 -> (&cpu_buffer->reader_lock){.+..} ops: 5064 {
    initial-use  at:
                          [<c017359d>] __lock_acquire+0x1bd/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c0925908>] _spin_lock_irqsave+0x58/0x70
                          [<c019920d>] ring_buffer_reset_cpu+0x2d/0x60
                          [<c019b00a>] tracing_reset+0x1a/0x30
                          [<c019b0dd>] register_tracer+0xbd/0x1b0
                          [<c0cec253>] tracer_alloc_buffers+0xd3/0x140
                          [<c010111f>] do_one_initcall+0x2f/0x170
                          [<c0cd294a>] kernel_init+0x5a/0x170
                          [<c011cd0b>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-softirq-W at:
                          [<c0173b46>] __lock_acquire+0x766/0x1380
                          [<c01747e9>] lock_acquire+0x89/0xc0
                          [<c0925908>] _spin_lock_irqsave+0x58/0x70
                          [<c019920d>] ring_buffer_reset_cpu+0x2d/0x60
                          [<c019b00a>] tracing_reset+0x1a/0x30
                          [<c019e7e9>] __wakeup_reset+0x19/0x80
                          [<c019ecf5>] probe_wakeup+0xb5/0x150
                          [<c0147e50>] try_to_wake_up+0x2b0/0x2c0
                          [<c0147eb4>] wake_up_process+0x14/0x20
                          [<c0158fbd>] process_timeout+0xd/0x10
                          [<c0158dd1>] run_timer_softirq+0x181/0x1c0
                          [<c01547b9>] __do_softirq+0xa9/0x180
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c1319940>] __key.21839+0x0/0x20
 ... acquired at:
   [<c017437a>] __lock_acquire+0xf9a/0x1380
   [<c01747e9>] lock_acquire+0x89/0xc0
   [<c0925908>] _spin_lock_irqsave+0x58/0x70
   [<c019920d>] ring_buffer_reset_cpu+0x2d/0x60
   [<c019b00a>] tracing_reset+0x1a/0x30
   [<c019e7e9>] __wakeup_reset+0x19/0x80
   [<c019ecf5>] probe_wakeup+0xb5/0x150
   [<c0147e50>] try_to_wake_up+0x2b0/0x2c0
   [<c0147eb4>] wake_up_process+0x14/0x20
   [<c019baeb>] trace_selftest_startup_wakeup+0xab/0x160
   [<c019b117>] register_tracer+0xf7/0x1b0
   [<c0cec2fd>] init_wakeup_tracer+0xd/0x10
   [<c010111f>] do_one_initcall+0x2f/0x170
   [<c0cd2a02>] kernel_init+0x112/0x170
   [<c011cd0b>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff


the hard-irq-unsafe lock's dependencies:
-> (&p->alloc_lock){--..} ops: 21231 {
   initial-use  at:
                        [<c017359d>] __lock_acquire+0x1bd/0x1380
                        [<c01747e9>] lock_acquire+0x89/0xc0
                        [<c09257e8>] _spin_lock+0x38/0x50
                        [<c01c7707>] set_task_comm+0x27/0x60
                        [<c0163f01>] kthreadd+0x21/0x160
                        [<c011cd0b>] kernel_thread_helper+0x7/0x10
                        [<ffffffff>] 0xffffffff
   softirq-on-W at:
                        [<c0173c77>] __lock_acquire+0x897/0x1380
                        [<c01747e9>] lock_acquire+0x89/0xc0
                        [<c09257e8>] _spin_lock+0x38/0x50
                        [<c01c7707>] set_task_comm+0x27/0x60
                        [<c0163f01>] kthreadd+0x21/0x160
                        [<c011cd0b>] kernel_thread_helper+0x7/0x10
                        [<ffffffff>] 0xffffffff
   hardirq-on-W at:
                        [<c0173c51>] __lock_acquire+0x871/0x1380
                        [<c01747e9>] lock_acquire+0x89/0xc0
                        [<c09257e8>] _spin_lock+0x38/0x50
                        [<c01c7707>] set_task_comm+0x27/0x60
                        [<c0163f01>] kthreadd+0x21/0x160
                        [<c011cd0b>] kernel_thread_helper+0x7/0x10
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c0d80ea0>] __key.38217+0x0/0x8

stack backtrace:
Pid: 3134, comm: S99local Not tainted 2.6.28-rc6-tip-00766-g9f03358-dirty #1566
Call Trace:
 [<c0172a18>] check_usage+0x2e8/0x340
 [<c0174090>] __lock_acquire+0xcb0/0x1380
 [<c01747e9>] lock_acquire+0x89/0xc0
 [<c01883e7>] ? cpuset_cpus_allowed_locked+0x27/0x50
 [<c09257e8>] _spin_lock+0x38/0x50
 [<c01883e7>] ? cpuset_cpus_allowed_locked+0x27/0x50
 [<c01883e7>] cpuset_cpus_allowed_locked+0x27/0x50
 [<c0148de2>] move_task_off_dead_cpu+0xc2/0x140
 [<c0921c27>] migration_call+0x227/0x4a0
 [<c017507b>] ? trace_hardirqs_on+0xb/0x10
 [<c0926e85>] ? _etext+0x0/0xb
 [<c0168c8b>] notifier_call_chain+0x4b/0x70
 [<c0168d6e>] __raw_notifier_call_chain+0x1e/0x30
 [<c0168d9f>] raw_notifier_call_chain+0x1f/0x30
 [<c08e7a59>] _cpu_down+0x129/0x260
 [<c0161eb2>] ? synchronize_rcu+0x32/0x40
 [<c0161d80>] ? wakeme_after_rcu+0x0/0x20
 [<c08e7be6>] cpu_down+0x56/0x70
 [<c08e940c>] store_online+0x3c/0x80
 [<c08e93d0>] ? store_online+0x0/0x80
 [<c051b64a>] sysdev_store+0x2a/0x40
 [<c020267e>] sysfs_write_file+0xbe/0x110
 [<c01c3bbb>] vfs_write+0x9b/0x130
 [<c02025c0>] ? sysfs_write_file+0x0/0x110
 [<c01c3d12>] sys_write+0x42/0x70
 [<c011c46f>] sysenter_do_call+0x12/0x43
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
CPU 1 irqstacks, hard=c0d64000 soft=c0d5c000


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-rc6
# Mon Nov 24 18:07:29 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
# CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED is not set
# CONFIG_BOOTPARAM_SUPPORT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_BOOT_ALLOWED4=y
# CONFIG_BROKEN_BOOT_ALLOWED3 is not set
# CONFIG_BROKEN_BOOT_EUROPE is not set
# CONFIG_BROKEN_BOOT_TITAN is not set
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=21
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_NS is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MM_OWNER=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
# CONFIG_BUG is not set
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_TINY_SHMEM=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP_SUPPORT=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
# CONFIG_UP_WANTED_1 is not set
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_RDC321X=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_VMI=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
# CONFIG_X86_PTRACE_BTS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_MMU_NOTIFIER=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
CONFIG_APM_CPU_IDLE=y
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y
CONFIG_APM_REAL_MODE_POWER_OFF=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
CONFIG_MCA_PROC_FS=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=m
CONFIG_OLPC=y
CONFIG_PCCARD=m
CONFIG_PCMCIA_DEBUG=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_IBM=m
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=m
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
CONFIG_DEFAULT_HTCP=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="htcp"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=m
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_TIME=m
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=m
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=y
# CONFIG_IP_VS_LBLCR is not set
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
# CONFIG_IP_NF_TARGET_REJECT is not set
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
# CONFIG_IP_NF_ARPFILTER is not set
# CONFIG_IP_NF_ARP_MANGLE is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set
# CONFIG_IP_DCCP_TFRC_LIB is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_TRAILER is not set
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_IPDDP_DECAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_ECONET=m
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
CONFIG_SCC=m
# CONFIG_SCC_DELAY is not set
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
# CONFIG_YAM is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
CONFIG_BT=m
CONFIG_BT_L2CAP=m
# CONFIG_BT_SCO is not set
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUSB is not set
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIVHCI is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_PHONET=y
# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y
CONFIG_IEEE80211=y
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_XD=m
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=m
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_7000FASST=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=m
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_FD_MCS is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_GENERIC_NCR5380 is not set
CONFIG_SCSI_GENERIC_NCR5380_MMIO=m
CONFIG_SCSI_IBMMCA=m
# CONFIG_IBMMCA_SCSI_ORDER_STANDARD is not set
CONFIG_IBMMCA_SCSI_DEV_RESET=y
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
# CONFIG_SCSI_NCR53C406A is not set
CONFIG_SCSI_NCR_D700=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_NCR_Q720=y
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=32
CONFIG_SCSI_NCR53C8XX_SYNC=20
# CONFIG_SCSI_PAS16 is not set
CONFIG_SCSI_QLOGIC_FAS=y
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
CONFIG_SCSI_SYM53C416=y
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=m
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
CONFIG_SCSI_NSP32=m
CONFIG_SCSI_SRP=m
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=m
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=m
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
# CONFIG_PATA_ISAPNP is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=y
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_LEGACY=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=y
CONFIG_PATA_NS87415=y
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_OPTIDMA=m
# CONFIG_PATA_PDC_OLD is not set
CONFIG_PATA_QDI=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=m
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=y
CONFIG_PATA_WINBOND_VLB=m
CONFIG_PATA_PLATFORM=m
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=y
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LAN is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_IEEE1394=y
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
CONFIG_TUN=y
CONFIG_VETH=m
CONFIG_NET_SB1000=y
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_VORTEX=y
CONFIG_LANCE=m
CONFIG_NET_VENDOR_SMC=y
# CONFIG_ULTRAMCA is not set
CONFIG_ULTRA=m
# CONFIG_SMC9194 is not set
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NI52=m
# CONFIG_NI65 is not set
# CONFIG_NET_TULIP is not set
CONFIG_AT1700=y
CONFIG_DEPCA=y
CONFIG_HP100=y
CONFIG_NET_ISA=y
CONFIG_E2100=m
CONFIG_EWRK3=y
CONFIG_EEXPRESS=y
CONFIG_EEXPRESS_PRO=m
CONFIG_HPLAN=m
CONFIG_LP486E=m
CONFIG_ETH16I=m
CONFIG_NE2000=y
CONFIG_ZNET=m
# CONFIG_SEEQ8005 is not set
CONFIG_NE2_MCA=m
CONFIG_IBMLANA=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
# CONFIG_AMD8111_ETH is not set
CONFIG_ADAPTEC_STARFIRE=m
# CONFIG_AC3200 is not set
CONFIG_APRICOT=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_CS89x0=y
CONFIG_EEPRO100=y
CONFIG_E100=y
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=y
# CONFIG_VIA_RHINE is not set
CONFIG_SC92031=m
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=m
CONFIG_IGB_LRO=y
# CONFIG_IGB_DCA is not set
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=y
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_QLA3XXX=m
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_JME=m
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
CONFIG_IBMTR=m
# CONFIG_IBMOL is not set
# CONFIG_IBMLS is not set
CONFIG_3C359=y
CONFIG_TMS380TR=m
# CONFIG_TMSPCI is not set
CONFIG_SKISA=m
# CONFIG_PROTEON is not set
CONFIG_ABYSS=m
# CONFIG_MADGEMC is not set
CONFIG_SMCTR=y

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_STRIP is not set
# CONFIG_ARLAN is not set
CONFIG_WAVELAN=m
CONFIG_WLAN_80211=y
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
# CONFIG_IPW2200 is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
# CONFIG_LIBERTAS_SDIO is not set
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=m
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
CONFIG_PRISM54=y
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=m

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC95XX=m
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_HSO=m
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SDLA is not set
# CONFIG_WAN_ROUTER_DRIVERS is not set
CONFIG_LAPBETHER=y
CONFIG_X25_ASY=y
# CONFIG_SBNI is not set
CONFIG_FDDI=y
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
CONFIG_MOUSE_PC110PAD=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_HTCPEN=m
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
CONFIG_DIGIEPCA=m
CONFIG_ESPSERIAL=m
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=y
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
CONFIG_SX=y
CONFIG_RIO=y
# CONFIG_RIO_OLDPCI is not set
CONFIG_STALDRV=y
# CONFIG_STALLION is not set
CONFIG_ISTALLION=m
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_MCA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_DTLK=y
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_SONYPI=y
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_STUB is not set
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
# CONFIG_AT24 is not set
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
CONFIG_PCF8575=m
CONFIG_SENSORS_PCA9539=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_BQ27x00=m
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_WM8400=m
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
CONFIG_VIDEO_IR_I2C=m

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# Video decoders
#
CONFIG_VIDEO_BT819=m
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_TCM825X=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA7111=m
CONFIG_VIDEO_SAA7114=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_SAA7191=m
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_SAA5246A=m
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
# CONFIG_SOC_CAMERA_MT9M111 is not set
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_VIDEO_SH_MOBILE_CEU=m
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_STK014 is not set
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
# CONFIG_USB_GSPCA_TV8532 is not set
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
# CONFIG_VIDEO_PVRUSB2_SYSFS is not set
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_EM28XX is not set
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
CONFIG_USB_STV680=m
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_CADET is not set
CONFIG_RADIO_RTRACK=m
CONFIG_RADIO_RTRACK2=m
CONFIG_RADIO_AZTECH=m
CONFIG_RADIO_GEMTEK=m
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_RADIO_SF16FMI=m
CONFIG_RADIO_SF16FMR2=m
# CONFIG_RADIO_TERRATEC is not set
# CONFIG_RADIO_TRUST is not set
CONFIG_RADIO_TYPHOON=m
CONFIG_RADIO_TYPHOON_PROC_FS=y
# CONFIG_RADIO_ZOLTRIX is not set
# CONFIG_USB_DSBR is not set
CONFIG_USB_SI470X=m
# CONFIG_USB_MR800 is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_PLL=m
CONFIG_DVB_ISL6421=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=m
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=m
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
CONFIG_BACKLIGHT_SAHARA=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=m
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=m
CONFIG_SND_AD1816A=y
CONFIG_SND_AD1848=m
# CONFIG_SND_ALS100 is not set
CONFIG_SND_AZT2320=m
CONFIG_SND_CMI8330=m
CONFIG_SND_CS4231=m
# CONFIG_SND_CS4232 is not set
CONFIG_SND_CS4236=y
CONFIG_SND_DT019X=y
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=y
CONFIG_SND_SC6000=m
CONFIG_SND_GUSCLASSIC=y
CONFIG_SND_GUSEXTREME=m
CONFIG_SND_GUSMAX=y
CONFIG_SND_INTERWAVE=y
CONFIG_SND_INTERWAVE_STB=y
# CONFIG_SND_OPL3SA2 is not set
CONFIG_SND_OPTI92X_AD1848=y
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
CONFIG_SND_SB8=m
CONFIG_SND_SB16=y
CONFIG_SND_SBAWE=y
CONFIG_SND_SB16_CSP=y
CONFIG_SND_SGALAXY=y
CONFIG_SND_SSCAPE=m
CONFIG_SND_WAVEFRONT=y
# CONFIG_SND_WAVEFRONT_FIRMWARE_IN_KERNEL is not set
# CONFIG_SND_PCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
# CONFIG_SND_USB_CAIAQ is not set
CONFIG_SND_USB_US122L=y
CONFIG_SND_SOC=m
# CONFIG_SND_SOC_ALL_CODECS is not set
# CONFIG_SOUND_PRIME is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_HID=m
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=m
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=y
# CONFIG_USB_PHIDGET is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_WLP=m
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_NET48XX=m
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_HP_DISK=m
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_INFINIBAND_SRP=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_SMX=m
CONFIG_UIO_SERCOS3=m
CONFIG_STAGING_EXCLUDE_BUILD=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_CRAMFS=m
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_SUNRPC_REGISTER_V4=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ALLOW_WARNINGS=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_HIGHMEM=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_RET_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_RET_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_BOOT_TRACER is not set
CONFIG_STACK_TRACER=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_PRINTK_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
CONFIG_KVM_TRACE=y
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--sm4nu43k4a2Rpi4c--
