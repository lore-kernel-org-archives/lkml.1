Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbXBEVaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbXBEVaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933479AbXBEVaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:30:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:25298 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXBEVaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:30:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=XT/jw2PwptwcHC3agwXXc5vH7Av+LYT78wXwUMeWIcoXtxX9vUmvdLOWELPTsScoUewzUtwPPk2QMamaqACaPL9jjt3DRlH3P0WbBw+hDjwlO89/H2aJGAMo0ksgQNqx1XZuUDc0Qu5RoADp2uhGwaRboPMKhfUrI/G/RHVn3VM=
Message-ID: <45C7A1CE.7050903@googlemail.com>
Date: Mon, 05 Feb 2007 22:29:50 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
References: <20070205065636.GA1652@elte.hu> <6bffcb0e0702050459y692359ai67cbd4f93e11d06e@mail.gmail.com> <20070205134708.GA6318@elte.hu>
In-Reply-To: <20070205134708.GA6318@elte.hu>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar napisał(a):
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> It looks like a bug to me
>>
>> BUG: MAX_LOCKDEP_ENTRIES too low!
>> turning off the locking correctness validator.
> 
> hm, the patch below should solve this.

Lockdep works. Thanks!

2.6.20-rt2

======================================================
[ INFO: hard-safe -> hard-unsafe lock order detected ]
[ 2.6.20-rt2 #2
------------------------------------------------------
softirq-timer/0/5 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (console_sem.lock){--..}, at: [<c0311981>] rt_mutex_slowunlock+0xc/0x5b

and this task is already holding:
 (xtime_lock){+...}, at: [<c012a8b8>] run_timer_softirq+0x47/0x9ad
which would create a new lock dependency:
 (xtime_lock){+...} -> (console_sem.lock){--..}

but this new dependency connects a hard-irq-safe lock:
 (xtime_lock){+...}
... which became hard-irq-safe at:
  [<c013d124>] mark_lock+0x6b/0x40b
  [<c013dee5>] __lock_acquire+0x3b3/0xb94
  [<c013e72e>] lock_acquire+0x68/0x82
  [<c03127d3>] __spin_lock+0x35/0x42
  [<c013a654>] tick_periodic+0x15/0x68
  [<c013a6ba>] tick_handle_periodic+0x13/0x45
  [<c010684f>] timer_interrupt+0x31/0x38
  [<c0155912>] handle_IRQ_event+0x63/0xfc
  [<c0157267>] handle_level_irq+0xa7/0xf0
  [<c0105dc1>] do_IRQ+0xa3/0xce
  [<c0103ac6>] common_interrupt+0x2e/0x34
  [<c0312e57>] __spin_unlock_irqrestore+0x42/0x59
  [<c0156075>] setup_irq+0x170/0x1e0
  [<c04907e4>] time_init_hook+0x19/0x1b
  [<c0488d87>] hpet_time_init+0xd/0xf
  [<c0485667>] start_kernel+0x271/0x42a
  [<ffffffff>] 0xffffffff

to a hard-irq-unsafe lock:
 (console_sem.lock){--..}
... which became hard-irq-unsafe at:
...  [<c013d124>] mark_lock+0x6b/0x40b
  [<c013d50e>] mark_held_locks+0x4a/0x67
  [<c013d6f1>] trace_hardirqs_on+0x10d/0x150
  [<c0312e55>] __spin_unlock_irqrestore+0x40/0x59
  [<c01431f4>] task_blocks_on_rt_mutex+0x1c4/0x20a
  [<c0311cd0>] rt_mutex_slowlock+0x140/0x234
  [<c03119fd>] rt_mutex_lock+0x2d/0x31
  [<c014441a>] rt_down+0x11/0x28
  [<c012290f>] acquire_console_sem+0x36/0x4c
  [<c0209c10>] fb_flashcursor+0x1a/0x24d
  [<c013177a>] run_workqueue+0x8b/0xd8
  [<c0132309>] worker_thread+0xf8/0x124
  [<c01344b4>] kthread+0xb5/0xe1
  [<c0103dab>] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by softirq-timer/0/5:
 #0:  (xtime_lock){+...}, at: [<c012a8b8>] run_timer_softirq+0x47/0x9ad

the hard-irq-safe lock's dependencies:
-> (xtime_lock){+...} ops: 7875 {
   initial-use  at:
                        [<c013d124>] mark_lock+0x6b/0x40b
                        [<c013dfb9>] __lock_acquire+0x487/0xb94
                        [<c013e72e>] lock_acquire+0x68/0x82
                        [<c03127d3>] __spin_lock+0x35/0x42
                        [<c04916fb>] timekeeping_init+0x25/0x143
                        [<c04855be>] start_kernel+0x1c8/0x42a
                        [<ffffffff>] 0xffffffff
   in-hardirq-W at:
                        [<c013d124>] mark_lock+0x6b/0x40b
                        [<c013dee5>] __lock_acquire+0x3b3/0xb94
                        [<c013e72e>] lock_acquire+0x68/0x82
                        [<c03127d3>] __spin_lock+0x35/0x42
                        [<c013a654>] tick_periodic+0x15/0x68
                        [<c013a6ba>] tick_handle_periodic+0x13/0x45
                        [<c010684f>] timer_interrupt+0x31/0x38
                        [<c0155912>] handle_IRQ_event+0x63/0xfc
                        [<c0157267>] handle_level_irq+0xa7/0xf0
                        [<c0105dc1>] do_IRQ+0xa3/0xce
                        [<c0103ac6>] common_interrupt+0x2e/0x34
                        [<c0312e57>] __spin_unlock_irqrestore+0x42/0x59
                        [<c0156075>] setup_irq+0x170/0x1e0
                        [<c04907e4>] time_init_hook+0x19/0x1b
                        [<c0488d87>] hpet_time_init+0xd/0xf
                        [<c0485667>] start_kernel+0x271/0x42a
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c046bb18>] xtime_lock+0x18/0x80
 -> (clocksource_lock){....} ops: 3800 {
    initial-use  at:
                          [<c013d124>] mark_lock+0x6b/0x40b
                          [<c013dfb9>] __lock_acquire+0x487/0xb94
                          [<c013e72e>] lock_acquire+0x68/0x82
                          [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                          [<c0138c4b>] clocksource_get_next+0xd/0x43
                          [<c049170b>] timekeeping_init+0x35/0x143
                          [<c04855be>] start_kernel+0x1c8/0x42a
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c046bd94>] clocksource_lock+0x14/0x80
 ... acquired at:
   [<c013c05b>] add_lock_to_list+0x65/0x89
   [<c013e544>] __lock_acquire+0xa12/0xb94
   [<c013e72e>] lock_acquire+0x68/0x82
   [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
   [<c0138c4b>] clocksource_get_next+0xd/0x43
   [<c049170b>] timekeeping_init+0x35/0x143
   [<c04855be>] start_kernel+0x1c8/0x42a
   [<ffffffff>] 0xffffffff

 -> (logbuf_lock){....} ops: 1544 {
    initial-use  at:
                          [<c013d124>] mark_lock+0x6b/0x40b
                          [<c013dfb9>] __lock_acquire+0x487/0xb94
                          [<c013e72e>] lock_acquire+0x68/0x82
                          [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                          [<c012273c>] release_console_sem+0x3c/0x1c5
                          [<c0122ed2>] vprintk+0x2cd/0x330
                          [<c0122f50>] printk+0x1b/0x1d
                          [<c0485456>] start_kernel+0x60/0x42a
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c046b694>] logbuf_lock+0x14/0x80
 ... acquired at:
   [<c013c05b>] add_lock_to_list+0x65/0x89
   [<c013e544>] __lock_acquire+0xa12/0xb94
   [<c013e72e>] lock_acquire+0x68/0x82
   [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
   [<c012273c>] release_console_sem+0x3c/0x1c5
   [<c0122ed2>] vprintk+0x2cd/0x330
   [<c0122f50>] printk+0x1b/0x1d
   [<c012aee1>] run_timer_softirq+0x670/0x9ad
   [<c0127689>] ksoftirqd+0x121/0x205
   [<c01344b4>] kthread+0xb5/0xe1
   [<c0103dab>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff


the hard-irq-unsafe lock's dependencies:
-> (console_sem.lock){--..} ops: 829 {
   initial-use  at:
                        [<c013d124>] mark_lock+0x6b/0x40b
                        [<c013dfb9>] __lock_acquire+0x487/0xb94
                        [<c013e72e>] lock_acquire+0x68/0x82
                        [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                        [<c0311981>] rt_mutex_slowunlock+0xc/0x5b
                        [<c03118e4>] rt_mutex_unlock+0x8/0xa
                        [<c014402c>] rt_up+0x25/0x45
                        [<c0122870>] release_console_sem+0x170/0x1c5
                        [<c0122ed2>] vprintk+0x2cd/0x330
                        [<c0122f50>] printk+0x1b/0x1d
                        [<c0485456>] start_kernel+0x60/0x42a
                        [<ffffffff>] 0xffffffff
   softirq-on-W at:
                        [<c013d124>] mark_lock+0x6b/0x40b
                        [<c013d50e>] mark_held_locks+0x4a/0x67
                        [<c013d709>] trace_hardirqs_on+0x125/0x150
                        [<c0312e55>] __spin_unlock_irqrestore+0x40/0x59
                        [<c01431f4>] task_blocks_on_rt_mutex+0x1c4/0x20a
                        [<c0311cd0>] rt_mutex_slowlock+0x140/0x234
                        [<c03119fd>] rt_mutex_lock+0x2d/0x31
                        [<c014441a>] rt_down+0x11/0x28
                        [<c012290f>] acquire_console_sem+0x36/0x4c
                        [<c0209c10>] fb_flashcursor+0x1a/0x24d
                        [<c013177a>] run_workqueue+0x8b/0xd8
                        [<c0132309>] worker_thread+0xf8/0x124
                        [<c01344b4>] kthread+0xb5/0xe1
                        [<c0103dab>] kernel_thread_helper+0x7/0x10
                        [<ffffffff>] 0xffffffff
   hardirq-on-W at:
                        [<c013d124>] mark_lock+0x6b/0x40b
                        [<c013d50e>] mark_held_locks+0x4a/0x67
                        [<c013d6f1>] trace_hardirqs_on+0x10d/0x150
                        [<c0312e55>] __spin_unlock_irqrestore+0x40/0x59
                        [<c01431f4>] task_blocks_on_rt_mutex+0x1c4/0x20a
                        [<c0311cd0>] rt_mutex_slowlock+0x140/0x234
                        [<c03119fd>] rt_mutex_lock+0x2d/0x31
                        [<c014441a>] rt_down+0x11/0x28
                        [<c012290f>] acquire_console_sem+0x36/0x4c
                        [<c0209c10>] fb_flashcursor+0x1a/0x24d
                        [<c013177a>] run_workqueue+0x8b/0xd8
                        [<c0132309>] worker_thread+0xf8/0x124
                        [<c01344b4>] kthread+0xb5/0xe1
                        [<c0103dab>] kernel_thread_helper+0x7/0x10
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c043c318>] console_sem+0x18/0x60
 -> ((raw_spinlock_t *)(&p->pi_lock)){....} ops: 706 {
    initial-use  at:
                          [<c013d124>] mark_lock+0x6b/0x40b
                          [<c013dfb9>] __lock_acquire+0x487/0xb94
                          [<c013e72e>] lock_acquire+0x68/0x82
                          [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                          [<c011c7a5>] sched_setscheduler+0x13f/0x22e
                          [<c0135150>] posix_cpu_thread_call+0x88/0xff
                          [<c0491d70>] posix_cpu_thread_init+0x1c/0x3c
                          [<c01003fa>] init+0x4d/0x3c3
                          [<c0103dab>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c04cc06c>] __key.24574+0x0/0x8
  -> (&rq->rq_lock_key){+...} ops: 29636 {
     initial-use  at:
                            [<c013d124>] mark_lock+0x6b/0x40b
                            [<c013dfb9>] __lock_acquire+0x487/0xb94
                            [<c013e72e>] lock_acquire+0x68/0x82
                            [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                            [<c011be68>] init_idle+0x63/0x81
                            [<c0490c3e>] sched_init+0x1a9/0x1b0
                            [<c0485516>] start_kernel+0x120/0x42a
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c013d124>] mark_lock+0x6b/0x40b
                            [<c013dee5>] __lock_acquire+0x3b3/0xb94
                            [<c013e72e>] lock_acquire+0x68/0x82
                            [<c03127d3>] __spin_lock+0x35/0x42
                            [<c011b21f>] task_running_tick+0x2a/0x23d
                            [<c011e849>] scheduler_tick+0x92/0xee
                            [<c012b88a>] update_process_times+0x3e/0x63
                            [<c013a6a5>] tick_periodic+0x66/0x68
                            [<c013a6ba>] tick_handle_periodic+0x13/0x45
                            [<c010684f>] timer_interrupt+0x31/0x38
                            [<c0155912>] handle_IRQ_event+0x63/0xfc
                            [<c0157267>] handle_level_irq+0xa7/0xf0
                            [<c0105dc1>] do_IRQ+0xa3/0xce
                            [<c0103ac6>] common_interrupt+0x2e/0x34
                            [<c013e740>] lock_acquire+0x7a/0x82
                            [<c0312430>] rt_read_lock+0x2b/0x69
                            [<c0120925>] copy_process+0x6cc/0x136b
                            [<c0121e43>] fork_idle+0x3f/0x58
                            [<c0112023>] do_boot_cpu+0x3c/0x547
                            [<c048c4a0>] smp_prepare_cpus+0x477/0x5eb
                            [<c01003eb>] init+0x3e/0x3c3
                            [<c0103dab>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c60686cc>] 0xc60686cc
   -> (&rq->rq_lock_key#2){+...} ops: 30044 {
      initial-use  at:
                              [<c013d124>] mark_lock+0x6b/0x40b
                              [<c013dfb9>] __lock_acquire+0x487/0xb94
                              [<c013e72e>] lock_acquire+0x68/0x82
                              [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                              [<c011be68>] init_idle+0x63/0x81
                              [<c0121e53>] fork_idle+0x4f/0x58
                              [<c0112023>] do_boot_cpu+0x3c/0x547
                              [<c048c4a0>] smp_prepare_cpus+0x477/0x5eb
                              [<c01003eb>] init+0x3e/0x3c3
                              [<c0103dab>] kernel_thread_helper+0x7/0x10
                              [<ffffffff>] 0xffffffff
      in-hardirq-W at:
                              [<c013d124>] mark_lock+0x6b/0x40b
                              [<c013dee5>] __lock_acquire+0x3b3/0xb94
                              [<c013e72e>] lock_acquire+0x68/0x82
                              [<c03127d3>] __spin_lock+0x35/0x42
                              [<c011b6be>] task_rq_lock+0x36/0x5d
                              [<c011ca30>] try_to_wake_up+0x29/0x3cf
                              [<c011ce79>] wake_up_process+0x19/0x1b
                              [<c0126af7>] wakeup_softirqd+0x30/0x34
                              [<c01277c6>] raise_softirq+0x59/0x77
                              [<c012b50e>] run_local_timers+0xd/0x14
                              [<c012b88f>] update_process_times+0x43/0x63
                              [<c013a6a5>] tick_periodic+0x66/0x68
                              [<c013a6ba>] tick_handle_periodic+0x13/0x45
                              [<c0113e30>] smp_apic_timer_interrupt+0xa6/0xb8
                              [<c0103ba7>] apic_timer_interrupt+0x33/0x38
                              [<c0101b16>] default_idle+0x49/0x62
                              [<c01013ec>] cpu_idle+0xd4/0x11e
                              [<c0112d05>] start_secondary+0x35a/0x362
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<c60e86cc>] 0xc60e86cc
   ... acquired at:
   [<c013c05b>] add_lock_to_list+0x65/0x89
   [<c013e544>] __lock_acquire+0xa12/0xb94
   [<c013e72e>] lock_acquire+0x68/0x82
   [<c03127d3>] __spin_lock+0x35/0x42
   [<c011b029>] double_rq_lock+0x33/0x37
   [<c011b8ab>] __migrate_task+0x58/0x131
   [<c011eb9f>] migration_thread+0x196/0x1e5
   [<c01344b4>] kthread+0xb5/0xe1
   [<c0103dab>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c013c05b>] add_lock_to_list+0x65/0x89
   [<c013e544>] __lock_acquire+0xa12/0xb94
   [<c013e72e>] lock_acquire+0x68/0x82
   [<c03127d3>] __spin_lock+0x35/0x42
   [<c011c7c3>] sched_setscheduler+0x15d/0x22e
   [<c0135150>] posix_cpu_thread_call+0x88/0xff
   [<c0491d70>] posix_cpu_thread_init+0x1c/0x3c
   [<c01003fa>] init+0x4d/0x3c3
   [<c0103dab>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  -> (&rq->rq_lock_key#2){+...} ops: 30044 {
     initial-use  at:
                            [<c013d124>] mark_lock+0x6b/0x40b
                            [<c013dfb9>] __lock_acquire+0x487/0xb94
                            [<c013e72e>] lock_acquire+0x68/0x82
                            [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                            [<c011be68>] init_idle+0x63/0x81
                            [<c0121e53>] fork_idle+0x4f/0x58
                            [<c0112023>] do_boot_cpu+0x3c/0x547
                            [<c048c4a0>] smp_prepare_cpus+0x477/0x5eb
                            [<c01003eb>] init+0x3e/0x3c3
                            [<c0103dab>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c013d124>] mark_lock+0x6b/0x40b
                            [<c013dee5>] __lock_acquire+0x3b3/0xb94
                            [<c013e72e>] lock_acquire+0x68/0x82
                            [<c03127d3>] __spin_lock+0x35/0x42
                            [<c011b6be>] task_rq_lock+0x36/0x5d
                            [<c011ca30>] try_to_wake_up+0x29/0x3cf
                            [<c011ce79>] wake_up_process+0x19/0x1b
                            [<c0126af7>] wakeup_softirqd+0x30/0x34
                            [<c01277c6>] raise_softirq+0x59/0x77
                            [<c012b50e>] run_local_timers+0xd/0x14
                            [<c012b88f>] update_process_times+0x43/0x63
                            [<c013a6a5>] tick_periodic+0x66/0x68
                            [<c013a6ba>] tick_handle_periodic+0x13/0x45
                            [<c0113e30>] smp_apic_timer_interrupt+0xa6/0xb8
                            [<c0103ba7>] apic_timer_interrupt+0x33/0x38
                            [<c0101b16>] default_idle+0x49/0x62
                            [<c01013ec>] cpu_idle+0xd4/0x11e
                            [<c0112d05>] start_secondary+0x35a/0x362
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c60e86cc>] 0xc60e86cc
  ... acquired at:
   [<c013c05b>] add_lock_to_list+0x65/0x89
   [<c013e544>] __lock_acquire+0xa12/0xb94
   [<c013e72e>] lock_acquire+0x68/0x82
   [<c03127d3>] __spin_lock+0x35/0x42
   [<c011c7c3>] sched_setscheduler+0x15d/0x22e
   [<c0135150>] posix_cpu_thread_call+0x88/0xff
   [<c012ec53>] notifier_call_chain+0x20/0x31
   [<c012ec80>] raw_notifier_call_chain+0x8/0xa
   [<c0144569>] _cpu_up+0x3d/0xbf
   [<c0144611>] cpu_up+0x26/0x38
   [<c010043e>] init+0x91/0x3c3
   [<c0103dab>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c013c05b>] add_lock_to_list+0x65/0x89
   [<c013e544>] __lock_acquire+0xa12/0xb94
   [<c013e72e>] lock_acquire+0x68/0x82
   [<c03127d3>] __spin_lock+0x35/0x42
   [<c0143055>] task_blocks_on_rt_mutex+0x25/0x20a
   [<c0311cd0>] rt_mutex_slowlock+0x140/0x234
   [<c03119fd>] rt_mutex_lock+0x2d/0x31
   [<c014441a>] rt_down+0x11/0x28
   [<c012290f>] acquire_console_sem+0x36/0x4c
   [<c0209c10>] fb_flashcursor+0x1a/0x24d
   [<c013177a>] run_workqueue+0x8b/0xd8
   [<c0132309>] worker_thread+0xf8/0x124
   [<c01344b4>] kthread+0xb5/0xe1
   [<c0103dab>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 -> (&rq->rq_lock_key#2){+...} ops: 30044 {
    initial-use  at:
                          [<c013d124>] mark_lock+0x6b/0x40b
                          [<c013dfb9>] __lock_acquire+0x487/0xb94
                          [<c013e72e>] lock_acquire+0x68/0x82
                          [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
                          [<c011be68>] init_idle+0x63/0x81
                          [<c0121e53>] fork_idle+0x4f/0x58
                          [<c0112023>] do_boot_cpu+0x3c/0x547
                          [<c048c4a0>] smp_prepare_cpus+0x477/0x5eb
                          [<c01003eb>] init+0x3e/0x3c3
                          [<c0103dab>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [<c013d124>] mark_lock+0x6b/0x40b
                          [<c013dee5>] __lock_acquire+0x3b3/0xb94
                          [<c013e72e>] lock_acquire+0x68/0x82
                          [<c03127d3>] __spin_lock+0x35/0x42
                          [<c011b6be>] task_rq_lock+0x36/0x5d
                          [<c011ca30>] try_to_wake_up+0x29/0x3cf
                          [<c011ce79>] wake_up_process+0x19/0x1b
                          [<c0126af7>] wakeup_softirqd+0x30/0x34
                          [<c01277c6>] raise_softirq+0x59/0x77
                          [<c012b50e>] run_local_timers+0xd/0x14
                          [<c012b88f>] update_process_times+0x43/0x63
                          [<c013a6a5>] tick_periodic+0x66/0x68
                          [<c013a6ba>] tick_handle_periodic+0x13/0x45
                          [<c0113e30>] smp_apic_timer_interrupt+0xa6/0xb8
                          [<c0103ba7>] apic_timer_interrupt+0x33/0x38
                          [<c0101b16>] default_idle+0x49/0x62
                          [<c01013ec>] cpu_idle+0xd4/0x11e
                          [<c0112d05>] start_secondary+0x35a/0x362
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c60e86cc>] 0xc60e86cc
 ... acquired at:
   [<c013c05b>] add_lock_to_list+0x65/0x89
   [<c013e544>] __lock_acquire+0xa12/0xb94
   [<c013e72e>] lock_acquire+0x68/0x82
   [<c03127d3>] __spin_lock+0x35/0x42
   [<c011b6be>] task_rq_lock+0x36/0x5d
   [<c011ca30>] try_to_wake_up+0x29/0x3cf
   [<c011ce79>] wake_up_process+0x19/0x1b
   [<c014281e>] wakeup_next_waiter+0x1d9/0x1e1
   [<c03119b8>] rt_mutex_slowunlock+0x43/0x5b
   [<c03118e4>] rt_mutex_unlock+0x8/0xa
   [<c014402c>] rt_up+0x25/0x45
   [<c0122870>] release_console_sem+0x170/0x1c5
   [<c0122ed2>] vprintk+0x2cd/0x330
   [<c0122f50>] printk+0x1b/0x1d
   [<c0288c89>] usb_register_driver+0xa3/0xeb
   [<c049c440>] usb_usual_init+0xf/0x29
   [<c01004df>] init+0x132/0x3c3
   [<c0103dab>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff


stack backtrace:
 [<c01041a3>] dump_trace+0x63/0x1eb
 [<c0104348>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a23>] show_trace+0x12/0x14
 [<c0104ab6>] dump_stack+0x16/0x18
 [<c013da8f>] check_usage+0x241/0x24b
 [<c013e451>] __lock_acquire+0x91f/0xb94
 [<c013e72e>] lock_acquire+0x68/0x82
 [<c0312a40>] __spin_lock_irqsave+0x3e/0x4e
 [<c0311981>] rt_mutex_slowunlock+0xc/0x5b
 [<c03118e4>] rt_mutex_unlock+0x8/0xa
 [<c014402c>] rt_up+0x25/0x45
 [<c0122870>] release_console_sem+0x170/0x1c5
 [<c0122ed2>] vprintk+0x2cd/0x330
 [<c0122f50>] printk+0x1b/0x1d
 [<c012aee1>] run_timer_softirq+0x670/0x9ad
 [<c0127689>] ksoftirqd+0x121/0x205
 [<c01344b4>] kthread+0xb5/0xe1
 [<c0103dab>] kernel_thread_helper+0x7/0x10
 =======================
---------------------------
| preempt count: 00000003 ]
| 3-level deep critical section nesting:
----------------------------------------
.. [<c03127b1>] .... __spin_lock+0x13/0x42
.....[<c012a8b8>] ..   ( <= run_timer_softirq+0x47/0x9ad)
.. [<c0144017>] .... rt_up+0x10/0x45
.....[<c0122870>] ..   ( <= release_console_sem+0x170/0x1c5)
.. [<c0312a1e>] .... __spin_lock_irqsave+0x1c/0x4e
.....[<c0311981>] ..   ( <= rt_mutex_slowunlock+0xc/0x5b)

0xc03127b1 is in __spin_lock (kernel/spinlock.c:218).
213     EXPORT_SYMBOL(__write_lock_bh);
214
215     void __lockfunc __spin_lock(raw_spinlock_t *lock)
216     {
217             preempt_disable();
218             spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
219             _raw_spin_lock(lock);
220     }
221
222     EXPORT_SYMBOL(__spin_lock);

0xc012a8b8 is in run_timer_softirq (include/linux/seqlock.h:148).
143     }
144
145     static __always_inline void __write_seqlock_raw(raw_seqlock_t *sl)
146     {
147             spin_lock(&sl->lock);
148             ++sl->sequence;
149             smp_wmb();
150     }
151
152     static __always_inline void __write_sequnlock_raw(raw_seqlock_t *sl)


0xc0144017 is in rt_up (include/asm/atomic.h:189).
184             if(unlikely(boot_cpu_data.x86==3))
185                     goto no_xadd;
186     #endif
187             /* Modern 486+ processor */
188             __i = i;
189             __asm__ __volatile__(
190                     LOCK_PREFIX "xaddl %0, %1"
191                     :"+r" (i), "+m" (v->counter)
192                     : : "memory");
193             return i + __i;

0xc0122870 is in release_console_sem (kernel/printk.c:864).
859              * up only if we are in a preemptible section. We normally dont
860              * printk from non-preemptible sections so this is for the emergency
861              * case only.
862              */
863     #ifdef CONFIG_PREEMPT_RT
864             if (!in_atomic() && !irqs_disabled())
865     #endif
866             if (wake_klogd && !oops_in_progress && waitqueue_active(&log_wait))
867                     wake_up_interruptible(&log_wait);
868     }

0xc0312a1e is in __spin_lock_irqsave (kernel/spinlock.c:122).
117     {
118             unsigned long flags;
119
120             local_irq_save(flags);
121             preempt_disable();
122             spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
123             /*
124              * On lockdep we dont want the hand-coded irq-enable of
125              * _raw_spin_lock_flags() code, because lockdep assumes
126              * that interrupts are not re-enabled during lock-acquire:


0xc0311981 is in rt_mutex_slowunlock (kernel/rtmutex.c:1053).
1048    static void __sched
1049    rt_mutex_slowunlock(struct rt_mutex *lock)
1050    {
1051            unsigned long flags;
1052
1053            spin_lock_irqsave(&lock->wait_lock, flags);
1054
1055            debug_rt_mutex_unlock(lock);
1056
1057            rt_mutex_deadlock_account_unlock(current);

http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt2/rt-config
http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt2/rt-dmesg

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
