Return-Path: <linux-kernel-owner+w=401wt.eu-S1946251AbXBPWfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946251AbXBPWfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946263AbXBPWfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:35:47 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:34734 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946251AbXBPWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=MAJlS2S0H80BZTQ32ycOB46eXCOxWVCACT7b3lCU6LPFXEQtNd4igFSxbY3DB1c9jpZuT8Jgg+Hwd6V3K9mVI7SvV7QjvE9DML9X21RrPLpTH/71wc7/GKtfiHOfBDIu7pDzs8SxE0t2QNbIvpD6NDAy0M2jKIDzDhRxdR8K3SI=
Message-ID: <45D631BA.6010709@googlemail.com>
Date: Fri, 16 Feb 2007 23:35:38 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.20-rt8
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Test scenario:
- normal boot
- echo shutdown > /sys/power/disk; echo disk > /sys/power/state
- echo platform > /sys/power/disk; echo disk > /sys/power/state

======================================================
[ INFO: hard-safe -> hard-unsafe lock order detected ]
[ 2.6.20-rt8 #1
------------------------------------------------------
softirq-timer/0/5 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 ((raw_spinlock_t *)(&lock->wait_lock)){--..}, at: [<c031404f>] rt_spin_lock_slowlock+0x21/0x18f

and this task is already holding:
 (xtime_lock){+...}, at: [<c012aa40>] run_timer_softirq+0x47/0x9ad
which would create a new lock dependency:
 (xtime_lock){+...} -> ((raw_spinlock_t *)(&lock->wait_lock)){--..}

but this new dependency connects a hard-irq-safe lock:
 (xtime_lock){+...}
... which became hard-irq-safe at:
  [<c013d37c>] mark_lock+0x6b/0x40b
  [<c013e13d>] __lock_acquire+0x3b3/0xb94
  [<c013e986>] lock_acquire+0x68/0x82
  [<c0314dfb>] __spin_lock+0x35/0x42
  [<c013a7eb>] tick_periodic+0x15/0x68
  [<c013a856>] tick_handle_periodic+0x18/0x66
  [<c010689b>] timer_interrupt+0x31/0x38
  [<c0158112>] handle_IRQ_event+0x63/0x101
  [<c0159a6b>] handle_level_irq+0xa7/0xf0
  [<c0105e0e>] do_IRQ+0xc0/0xea
  [<c0103ae6>] common_interrupt+0x2e/0x34
  [<c031547f>] __spin_unlock_irqrestore+0x42/0x59
  [<c0158879>] setup_irq+0x170/0x1e0
  [<c04937b5>] time_init_hook+0x19/0x1b
  [<c048bd8c>] hpet_time_init+0xd/0xf
  [<c048866c>] start_kernel+0x276/0x42f
  [<ffffffff>] 0xffffffff

to a hard-irq-unsafe lock:
 ((raw_spinlock_t *)(&lock->wait_lock)){--..}
... which became hard-irq-unsafe at:
...  [<c013d37c>] mark_lock+0x6b/0x40b
  [<c013d766>] mark_held_locks+0x4a/0x67
  [<c013d949>] trace_hardirqs_on+0x10d/0x150
  [<c031547d>] __spin_unlock_irqrestore+0x40/0x59
  [<c0143445>] task_blocks_on_rt_mutex+0x1c4/0x20a
  [<c03140e7>] rt_spin_lock_slowlock+0xb9/0x18f
  [<c03147e8>] rt_spin_lock+0xe/0x38
  [<c011d48b>] complete+0x14/0x57
  [<c011ed39>] migration_thread+0x1a4/0x1e5
  [<c0134694>] kthread+0xb5/0xe1
  [<c0103dcb>] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by softirq-timer/0/5:
 #0:  (xtime_lock){+...}, at: [<c012aa40>] run_timer_softirq+0x47/0x9ad

the hard-irq-safe lock's dependencies:
-> (xtime_lock){+...} ops: 9269 {
   initial-use  at:
                        [<c013d37c>] mark_lock+0x6b/0x40b
                        [<c013e211>] __lock_acquire+0x487/0xb94
                        [<c013e986>] lock_acquire+0x68/0x82
                        [<c0314dfb>] __spin_lock+0x35/0x42
                        [<c04946cc>] timekeeping_init+0x25/0x143
                        [<c04885be>] start_kernel+0x1c8/0x42f
                        [<ffffffff>] 0xffffffff
   in-hardirq-W at:
                        [<c013d37c>] mark_lock+0x6b/0x40b
                        [<c013e13d>] __lock_acquire+0x3b3/0xb94
                        [<c013e986>] lock_acquire+0x68/0x82
                        [<c0314dfb>] __spin_lock+0x35/0x42
                        [<c013a7eb>] tick_periodic+0x15/0x68
                        [<c013a856>] tick_handle_periodic+0x18/0x66
                        [<c010689b>] timer_interrupt+0x31/0x38
                        [<c0158112>] handle_IRQ_event+0x63/0x101
                        [<c0159a6b>] handle_level_irq+0xa7/0xf0
                        [<c0105e0e>] do_IRQ+0xc0/0xea
                        [<c0103ae6>] common_interrupt+0x2e/0x34
                        [<c031547f>] __spin_unlock_irqrestore+0x42/0x59
                        [<c0158879>] setup_irq+0x170/0x1e0
                        [<c04937b5>] time_init_hook+0x19/0x1b
                        [<c048bd8c>] hpet_time_init+0xd/0xf
                        [<c048866c>] start_kernel+0x276/0x42f
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c046eb18>] xtime_lock+0x18/0x80
 -> (clocksource_lock){....} ops: 4435 {
    initial-use  at:
                          [<c013d37c>] mark_lock+0x6b/0x40b
                          [<c013e211>] __lock_acquire+0x487/0xb94
                          [<c013e986>] lock_acquire+0x68/0x82
                          [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                          [<c0138e53>] clocksource_get_next+0xd/0x43
                          [<c04946dc>] timekeeping_init+0x35/0x143
                          [<c04885be>] start_kernel+0x1c8/0x42f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c046ed94>] clocksource_lock+0x14/0x80
 ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
   [<c0138e53>] clocksource_get_next+0xd/0x43
   [<c04946dc>] timekeeping_init+0x35/0x143
   [<c04885be>] start_kernel+0x1c8/0x42f
   [<ffffffff>] 0xffffffff

 -> (logbuf_lock){....} ops: 1563 {
    initial-use  at:
                          [<c013d37c>] mark_lock+0x6b/0x40b
                          [<c013e211>] __lock_acquire+0x487/0xb94
                          [<c013e986>] lock_acquire+0x68/0x82
                          [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                          [<c01229b2>] release_console_sem+0x3c/0x1c5
                          [<c0123148>] vprintk+0x2cd/0x330
                          [<c01231c6>] printk+0x1b/0x1d
                          [<c0488456>] start_kernel+0x60/0x42f
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c046e694>] logbuf_lock+0x14/0x80
 ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
   [<c01229b2>] release_console_sem+0x3c/0x1c5
   [<c0123148>] vprintk+0x2cd/0x330
   [<c01231c6>] printk+0x1b/0x1d
   [<c012b069>] run_timer_softirq+0x670/0x9ad
   [<c0127837>] ksoftirqd+0x121/0x205
   [<c0134694>] kthread+0xb5/0xe1
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff


the hard-irq-unsafe lock's dependencies:
-> ((raw_spinlock_t *)(&lock->wait_lock)){--..} ops: 151167 {
   initial-use  at:
                        [<c013d37c>] mark_lock+0x6b/0x40b
                        [<c013e211>] __lock_acquire+0x487/0xb94
                        [<c013e986>] lock_acquire+0x68/0x82
                        [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                        [<c031404f>] rt_spin_lock_slowlock+0x21/0x18f
                        [<c03147e8>] rt_spin_lock+0xe/0x38
                        [<c012a534>] lock_timer_base+0x18/0x35
                        [<c012a97a>] __mod_timer+0x20/0x9f
                        [<c012bb22>] mod_timer+0x21/0x27
                        [<c049c99c>] con_init+0xb9/0x203
                        [<c049c3f7>] console_init+0x1e/0x2c
                        [<c04885eb>] start_kernel+0x1f5/0x42f
                        [<ffffffff>] 0xffffffff
   softirq-on-W at:
                        [<c013d37c>] mark_lock+0x6b/0x40b
                        [<c013d766>] mark_held_locks+0x4a/0x67
                        [<c013d961>] trace_hardirqs_on+0x125/0x150
                        [<c031547d>] __spin_unlock_irqrestore+0x40/0x59
                        [<c0143445>] task_blocks_on_rt_mutex+0x1c4/0x20a
                        [<c03140e7>] rt_spin_lock_slowlock+0xb9/0x18f
                        [<c03147e8>] rt_spin_lock+0xe/0x38
                        [<c011d48b>] complete+0x14/0x57
                        [<c011ed39>] migration_thread+0x1a4/0x1e5
                        [<c0134694>] kthread+0xb5/0xe1
                        [<c0103dcb>] kernel_thread_helper+0x7/0x10
                        [<ffffffff>] 0xffffffff
   hardirq-on-W at:
                        [<c013d37c>] mark_lock+0x6b/0x40b
                        [<c013d766>] mark_held_locks+0x4a/0x67
                        [<c013d949>] trace_hardirqs_on+0x10d/0x150
                        [<c031547d>] __spin_unlock_irqrestore+0x40/0x59
                        [<c0143445>] task_blocks_on_rt_mutex+0x1c4/0x20a
                        [<c03140e7>] rt_spin_lock_slowlock+0xb9/0x18f
                        [<c03147e8>] rt_spin_lock+0xe/0x38
                        [<c011d48b>] complete+0x14/0x57
                        [<c011ed39>] migration_thread+0x1a4/0x1e5
                        [<c0134694>] kthread+0xb5/0xe1
                        [<c0103dcb>] kernel_thread_helper+0x7/0x10
                        [<ffffffff>] 0xffffffff
 }
 ... key      at: [<c0832b48>] __key.11113+0x0/0x8
 -> ((raw_spinlock_t *)(&p->pi_lock)){....} ops: 571 {
    initial-use  at:
                          [<c013d37c>] mark_lock+0x6b/0x40b
                          [<c013e211>] __lock_acquire+0x487/0xb94
                          [<c013e986>] lock_acquire+0x68/0x82
                          [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                          [<c011c8d2>] sched_setscheduler+0x13f/0x22e
                          [<c0135330>] posix_cpu_thread_call+0x88/0xff
                          [<c0494d41>] posix_cpu_thread_init+0x1c/0x3c
                          [<c01003fa>] init+0x4d/0x3be
                          [<c0103dcb>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c04cf06c>] __key.24601+0x0/0x8
  -> (&rq->rq_lock_key){+...} ops: 34146 {
     initial-use  at:
                            [<c013d37c>] mark_lock+0x6b/0x40b
                            [<c013e211>] __lock_acquire+0x487/0xb94
                            [<c013e986>] lock_acquire+0x68/0x82
                            [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                            [<c011bf95>] init_idle+0x5c/0x7a
                            [<c0493c0f>] sched_init+0x1a9/0x1b0
                            [<c0488516>] start_kernel+0x120/0x42f
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c013d37c>] mark_lock+0x6b/0x40b
                            [<c013e13d>] __lock_acquire+0x3b3/0xb94
                            [<c013e986>] lock_acquire+0x68/0x82
                            [<c0314dfb>] __spin_lock+0x35/0x42
                            [<c011b3c3>] task_running_tick+0x2a/0x23d
                            [<c011e9d5>] scheduler_tick+0x92/0xee
                            [<c012ba20>] update_process_times+0x3e/0x63
                            [<c013a83c>] tick_periodic+0x66/0x68
                            [<c013a856>] tick_handle_periodic+0x18/0x66
                            [<c010689b>] timer_interrupt+0x31/0x38
                            [<c0158112>] handle_IRQ_event+0x63/0x101
                            [<c0159a6b>] handle_level_irq+0xa7/0xf0
                            [<c0105e0e>] do_IRQ+0xc0/0xea
                            [<c0103ae6>] common_interrupt+0x2e/0x34
                            [<c024c681>] serial_in+0x69/0x6f
                            [<c024cadd>] serial8250_console_write+0xa6/0x11e
                            [<c012280a>] __call_console_drivers+0x66/0x79
                            [<c0122874>] _call_console_drivers+0x57/0x5b
                            [<c0122ac3>] release_console_sem+0x14d/0x1c5
                            [<c0123148>] vprintk+0x2cd/0x330
                            [<c01231c6>] printk+0x1b/0x1d
                            [<c048f074>] smp_prepare_cpus+0x46/0x5eb
                            [<c01003eb>] init+0x3e/0x3be
                            [<c0103dcb>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c60686cc>] 0xc60686cc
   -> (&rq->rq_lock_key#2){+...} ops: 33028 {
      initial-use  at:
                              [<c013d37c>] mark_lock+0x6b/0x40b
                              [<c013e211>] __lock_acquire+0x487/0xb94
                              [<c013e986>] lock_acquire+0x68/0x82
                              [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                              [<c011bf95>] init_idle+0x5c/0x7a
                              [<c01220ac>] fork_idle+0x4f/0x58
                              [<c011202f>] do_boot_cpu+0x3c/0x547
                              [<c048f4a5>] smp_prepare_cpus+0x477/0x5eb
                              [<c01003eb>] init+0x3e/0x3be
                              [<c0103dcb>] kernel_thread_helper+0x7/0x10
                              [<ffffffff>] 0xffffffff
      in-hardirq-W at:
                              [<c013d37c>] mark_lock+0x6b/0x40b
                              [<c013e13d>] __lock_acquire+0x3b3/0xb94
                              [<c013e986>] lock_acquire+0x68/0x82
                              [<c0314dfb>] __spin_lock+0x35/0x42
                              [<c011b88f>] task_rq_lock+0x36/0x5d
                              [<c011cb69>] try_to_wake_up+0x35/0x41a
                              [<c011cff1>] wake_up_process+0x19/0x1b
                              [<c0126d6b>] wakeup_softirqd+0x30/0x34
                              [<c012794e>] raise_softirq+0x33/0x51
                              [<c012b505>] run_local_timers+0xd/0x14
                              [<c012ba25>] update_process_times+0x43/0x63
                              [<c013a83c>] tick_periodic+0x66/0x68
                              [<c013a856>] tick_handle_periodic+0x18/0x66
                              [<c0113e4b>] smp_apic_timer_interrupt+0xb5/0xc7
                              [<c0103bc7>] apic_timer_interrupt+0x33/0x38
                              [<c0101b16>] default_idle+0x49/0x62
                              [<c01013ec>] cpu_idle+0xd4/0x11e
                              [<c0112d11>] start_secondary+0x35a/0x362
                              [<ffffffff>] 0xffffffff
    }
    ... key      at: [<c60e86cc>] 0xc60e86cc
   ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0314dfb>] __spin_lock+0x35/0x42
   [<c011af4c>] double_rq_lock+0x33/0x37
   [<c011b9df>] __migrate_task+0x58/0x131
   [<c011ed2b>] migration_thread+0x196/0x1e5
   [<c0134694>] kthread+0xb5/0xe1
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0314dfb>] __spin_lock+0x35/0x42
   [<c011c8f0>] sched_setscheduler+0x15d/0x22e
   [<c0135330>] posix_cpu_thread_call+0x88/0xff
   [<c0494d41>] posix_cpu_thread_init+0x1c/0x3c
   [<c01003fa>] init+0x4d/0x3be
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

  -> (&rq->rq_lock_key#2){+...} ops: 33028 {
     initial-use  at:
                            [<c013d37c>] mark_lock+0x6b/0x40b
                            [<c013e211>] __lock_acquire+0x487/0xb94
                            [<c013e986>] lock_acquire+0x68/0x82
                            [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                            [<c011bf95>] init_idle+0x5c/0x7a
                            [<c01220ac>] fork_idle+0x4f/0x58
                            [<c011202f>] do_boot_cpu+0x3c/0x547
                            [<c048f4a5>] smp_prepare_cpus+0x477/0x5eb
                            [<c01003eb>] init+0x3e/0x3be
                            [<c0103dcb>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c013d37c>] mark_lock+0x6b/0x40b
                            [<c013e13d>] __lock_acquire+0x3b3/0xb94
                            [<c013e986>] lock_acquire+0x68/0x82
                            [<c0314dfb>] __spin_lock+0x35/0x42
                            [<c011b88f>] task_rq_lock+0x36/0x5d
                            [<c011cb69>] try_to_wake_up+0x35/0x41a
                            [<c011cff1>] wake_up_process+0x19/0x1b
                            [<c0126d6b>] wakeup_softirqd+0x30/0x34
                            [<c012794e>] raise_softirq+0x33/0x51
                            [<c012b505>] run_local_timers+0xd/0x14
                            [<c012ba25>] update_process_times+0x43/0x63
                            [<c013a83c>] tick_periodic+0x66/0x68
                            [<c013a856>] tick_handle_periodic+0x18/0x66
                            [<c0113e4b>] smp_apic_timer_interrupt+0xb5/0xc7
                            [<c0103bc7>] apic_timer_interrupt+0x33/0x38
                            [<c0101b16>] default_idle+0x49/0x62
                            [<c01013ec>] cpu_idle+0xd4/0x11e
                            [<c0112d11>] start_secondary+0x35a/0x362
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c60e86cc>] 0xc60e86cc
  ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0314dfb>] __spin_lock+0x35/0x42
   [<c011c8f0>] sched_setscheduler+0x15d/0x22e
   [<c0135330>] posix_cpu_thread_call+0x88/0xff
   [<c012edf7>] notifier_call_chain+0x20/0x31
   [<c012ee24>] raw_notifier_call_chain+0x8/0xa
   [<c01447d9>] _cpu_up+0x3d/0xbf
   [<c0144881>] cpu_up+0x26/0x38
   [<c010043e>] init+0x91/0x3be
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0314dfb>] __spin_lock+0x35/0x42
   [<c01432a6>] task_blocks_on_rt_mutex+0x25/0x20a
   [<c03140e7>] rt_spin_lock_slowlock+0xb9/0x18f
   [<c03147e8>] rt_spin_lock+0xe/0x38
   [<c011d48b>] complete+0x14/0x57
   [<c011ed39>] migration_thread+0x1a4/0x1e5
   [<c0134694>] kthread+0xb5/0xe1
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 -> (&rq->rq_lock_key){+...} ops: 34146 {
    initial-use  at:
                          [<c013d37c>] mark_lock+0x6b/0x40b
                          [<c013e211>] __lock_acquire+0x487/0xb94
                          [<c013e986>] lock_acquire+0x68/0x82
                          [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                          [<c011bf95>] init_idle+0x5c/0x7a
                          [<c0493c0f>] sched_init+0x1a9/0x1b0
                          [<c0488516>] start_kernel+0x120/0x42f
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [<c013d37c>] mark_lock+0x6b/0x40b
                          [<c013e13d>] __lock_acquire+0x3b3/0xb94
                          [<c013e986>] lock_acquire+0x68/0x82
                          [<c0314dfb>] __spin_lock+0x35/0x42
                          [<c011b3c3>] task_running_tick+0x2a/0x23d
                          [<c011e9d5>] scheduler_tick+0x92/0xee
                          [<c012ba20>] update_process_times+0x3e/0x63
                          [<c013a83c>] tick_periodic+0x66/0x68
                          [<c013a856>] tick_handle_periodic+0x18/0x66
                          [<c010689b>] timer_interrupt+0x31/0x38
                          [<c0158112>] handle_IRQ_event+0x63/0x101
                          [<c0159a6b>] handle_level_irq+0xa7/0xf0
                          [<c0105e0e>] do_IRQ+0xc0/0xea
                          [<c0103ae6>] common_interrupt+0x2e/0x34
                          [<c024c681>] serial_in+0x69/0x6f
                          [<c024cadd>] serial8250_console_write+0xa6/0x11e
                          [<c012280a>] __call_console_drivers+0x66/0x79
                          [<c0122874>] _call_console_drivers+0x57/0x5b
                          [<c0122ac3>] release_console_sem+0x14d/0x1c5
                          [<c0123148>] vprintk+0x2cd/0x330
                          [<c01231c6>] printk+0x1b/0x1d
                          [<c048f074>] smp_prepare_cpus+0x46/0x5eb
                          [<c01003eb>] init+0x3e/0x3be
                          [<c0103dcb>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c60686cc>] 0xc60686cc
  -> (&rq->rq_lock_key#2){+...} ops: 33028 {
     initial-use  at:
                            [<c013d37c>] mark_lock+0x6b/0x40b
                            [<c013e211>] __lock_acquire+0x487/0xb94
                            [<c013e986>] lock_acquire+0x68/0x82
                            [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                            [<c011bf95>] init_idle+0x5c/0x7a
                            [<c01220ac>] fork_idle+0x4f/0x58
                            [<c011202f>] do_boot_cpu+0x3c/0x547
                            [<c048f4a5>] smp_prepare_cpus+0x477/0x5eb
                            [<c01003eb>] init+0x3e/0x3be
                            [<c0103dcb>] kernel_thread_helper+0x7/0x10
                            [<ffffffff>] 0xffffffff
     in-hardirq-W at:
                            [<c013d37c>] mark_lock+0x6b/0x40b
                            [<c013e13d>] __lock_acquire+0x3b3/0xb94
                            [<c013e986>] lock_acquire+0x68/0x82
                            [<c0314dfb>] __spin_lock+0x35/0x42
                            [<c011b88f>] task_rq_lock+0x36/0x5d
                            [<c011cb69>] try_to_wake_up+0x35/0x41a
                            [<c011cff1>] wake_up_process+0x19/0x1b
                            [<c0126d6b>] wakeup_softirqd+0x30/0x34
                            [<c012794e>] raise_softirq+0x33/0x51
                            [<c012b505>] run_local_timers+0xd/0x14
                            [<c012ba25>] update_process_times+0x43/0x63
                            [<c013a83c>] tick_periodic+0x66/0x68
                            [<c013a856>] tick_handle_periodic+0x18/0x66
                            [<c0113e4b>] smp_apic_timer_interrupt+0xb5/0xc7
                            [<c0103bc7>] apic_timer_interrupt+0x33/0x38
                            [<c0101b16>] default_idle+0x49/0x62
                            [<c01013ec>] cpu_idle+0xd4/0x11e
                            [<c0112d11>] start_secondary+0x35a/0x362
                            [<ffffffff>] 0xffffffff
   }
   ... key      at: [<c60e86cc>] 0xc60e86cc
  ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0314dfb>] __spin_lock+0x35/0x42
   [<c011af4c>] double_rq_lock+0x33/0x37
   [<c011b9df>] __migrate_task+0x58/0x131
   [<c011ed2b>] migration_thread+0x196/0x1e5
   [<c0134694>] kthread+0xb5/0xe1
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0314dfb>] __spin_lock+0x35/0x42
   [<c011b88f>] task_rq_lock+0x36/0x5d
   [<c011cb69>] try_to_wake_up+0x35/0x41a
   [<c011cfb8>] wake_up_process_mutex+0x19/0x1b
   [<c0142a66>] wakeup_next_waiter+0x1d0/0x1e1
   [<c0313f8a>] rt_spin_lock_slowunlock+0x46/0x5e
   [<c031482f>] rt_spin_unlock+0x1d/0x20
   [<c0313572>] wait_for_completion+0x69/0x93
   [<c011d8d1>] set_cpus_allowed+0x82/0xa2
   [<c011d989>] measure_one+0x98/0x163
   [<c011df9a>] build_sched_domains+0x546/0xb5c
   [<c011e5cb>] arch_init_sched_domains+0x1b/0x1d
   [<c0493a21>] sched_init_smp+0x15/0x5a
   [<c010047d>] init+0xd0/0x3be
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff

 -> (&rq->rq_lock_key#2){+...} ops: 33028 {
    initial-use  at:
                          [<c013d37c>] mark_lock+0x6b/0x40b
                          [<c013e211>] __lock_acquire+0x487/0xb94
                          [<c013e986>] lock_acquire+0x68/0x82
                          [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
                          [<c011bf95>] init_idle+0x5c/0x7a
                          [<c01220ac>] fork_idle+0x4f/0x58
                          [<c011202f>] do_boot_cpu+0x3c/0x547
                          [<c048f4a5>] smp_prepare_cpus+0x477/0x5eb
                          [<c01003eb>] init+0x3e/0x3be
                          [<c0103dcb>] kernel_thread_helper+0x7/0x10
                          [<ffffffff>] 0xffffffff
    in-hardirq-W at:
                          [<c013d37c>] mark_lock+0x6b/0x40b
                          [<c013e13d>] __lock_acquire+0x3b3/0xb94
                          [<c013e986>] lock_acquire+0x68/0x82
                          [<c0314dfb>] __spin_lock+0x35/0x42
                          [<c011b88f>] task_rq_lock+0x36/0x5d
                          [<c011cb69>] try_to_wake_up+0x35/0x41a
                          [<c011cff1>] wake_up_process+0x19/0x1b
                          [<c0126d6b>] wakeup_softirqd+0x30/0x34
                          [<c012794e>] raise_softirq+0x33/0x51
                          [<c012b505>] run_local_timers+0xd/0x14
                          [<c012ba25>] update_process_times+0x43/0x63
                          [<c013a83c>] tick_periodic+0x66/0x68
                          [<c013a856>] tick_handle_periodic+0x18/0x66
                          [<c0113e4b>] smp_apic_timer_interrupt+0xb5/0xc7
                          [<c0103bc7>] apic_timer_interrupt+0x33/0x38
                          [<c0101b16>] default_idle+0x49/0x62
                          [<c01013ec>] cpu_idle+0xd4/0x11e
                          [<c0112d11>] start_secondary+0x35a/0x362
                          [<ffffffff>] 0xffffffff
  }
  ... key      at: [<c60e86cc>] 0xc60e86cc
 ... acquired at:
   [<c013c2b3>] add_lock_to_list+0x65/0x89
   [<c013e79c>] __lock_acquire+0xa12/0xb94
   [<c013e986>] lock_acquire+0x68/0x82
   [<c0314dfb>] __spin_lock+0x35/0x42
   [<c011b88f>] task_rq_lock+0x36/0x5d
   [<c011cb69>] try_to_wake_up+0x35/0x41a
   [<c011cfb8>] wake_up_process_mutex+0x19/0x1b
   [<c0142a66>] wakeup_next_waiter+0x1d0/0x1e1
   [<c0313f8a>] rt_spin_lock_slowunlock+0x46/0x5e
   [<c031482f>] rt_spin_unlock+0x1d/0x20
   [<c0313572>] wait_for_completion+0x69/0x93
   [<c011d8d1>] set_cpus_allowed+0x82/0xa2
   [<c011d925>] measure_one+0x34/0x163
   [<c011df9a>] build_sched_domains+0x546/0xb5c
   [<c011e5cb>] arch_init_sched_domains+0x1b/0x1d
   [<c0493a21>] sched_init_smp+0x15/0x5a
   [<c010047d>] init+0xd0/0x3be
   [<c0103dcb>] kernel_thread_helper+0x7/0x10
   [<ffffffff>] 0xffffffff


stack backtrace:
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c013dce7>] check_usage+0x241/0x24b
 [<c013e6a9>] __lock_acquire+0x91f/0xb94
 [<c013e986>] lock_acquire+0x68/0x82
 [<c0315068>] __spin_lock_irqsave+0x3e/0x4e
 [<c031404f>] rt_spin_lock_slowlock+0x21/0x18f
 [<c03147e8>] rt_spin_lock+0xe/0x38
 [<c024ca81>] serial8250_console_write+0x4a/0x11e
 [<c012280a>] __call_console_drivers+0x66/0x79
 [<c0122874>] _call_console_drivers+0x57/0x5b
 [<c0122a89>] release_console_sem+0x113/0x1c5
 [<c0123148>] vprintk+0x2cd/0x330
 [<c01231c6>] printk+0x1b/0x1d
 [<c012b069>] run_timer_softirq+0x670/0x9ad
 [<c0127837>] ksoftirqd+0x121/0x205
 [<c0134694>] kthread+0xb5/0xe1
 [<c0103dcb>] kernel_thread_helper+0x7/0x10
 =======================
---------------------------
| preempt count: 00000002 ]
| 2-level deep critical section nesting:
----------------------------------------
.. [<c0314dd9>] .... __spin_lock+0x13/0x42
.....[<c012aa40>] ..   ( <= run_timer_softirq+0x47/0x9ad)
.. [<c0315046>] .... __spin_lock_irqsave+0x1c/0x4e
.....[<c031404f>] ..   ( <= rt_spin_lock_slowlock+0x21/0x18f)

0xc0314dd9 is in __spin_lock (kernel/spinlock.c:218).
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

0xc012aa40 is in run_timer_softirq (include/linux/seqlock.h:148).
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

0xc0315046 is in __spin_lock_irqsave (kernel/spinlock.c:122).
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

0xc031404f is in rt_spin_lock_slowlock (kernel/rtmutex.c:640).
635             unsigned long saved_state, state, flags;
636
637             debug_rt_mutex_init_waiter(&waiter);
638             waiter.task = NULL;
639
640             spin_lock_irqsave(&lock->wait_lock, flags);
641             init_lists(lock);
642
643             /* Try to acquire the lock again: */
644             if (try_to_take_rt_mutex(lock)) {

========================================
echo shutdown > /sys/power/disk; echo disk > /sys/power/state



Disabling non-boot CPUs ...
CPU1 playing dead
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c01013a5>] cpu_idle+0x8d/0x11e
 [<c0112d11>] start_secondary+0x35a/0x362
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c010142b>] .... cpu_idle+0x113/0x11e
.....[<c0112d11>] ..   ( <= start_secondary+0x35a/0x362)

0xc010142b is in cpu_idle (arch/i386/kernel/process.c:204).
199                     tick_nohz_restart_sched_tick();
200                     local_irq_disable();
201                     __preempt_enable_no_resched();
202                     __schedule();
203                     preempt_disable();
204                     local_irq_enable();
205             }
206     }
207
208     void cpu_idle_wait(void)

0xc0112d11 is in start_secondary (arch/i386/kernel/smpboot.c:432).
427             /* We can take interrupts now: we're officially "up". */
428             local_irq_enable();
429
430             wmb();
431             cpu_idle();
432     }
433
434     /*
435      * Everything has been set up for the secondary
436      * CPUs - they just need to reload everything


CPU 1 is now offline
lockdep: not fixing up alternatives.
CPU1 is down
Stopping tasks ... done.
Shrinking memory...  -\|done (13953 pages freed)
Freed 55812 kbytes in 0.42 seconds (132.88 MB/s)
Suspending console(s)
lapic suspend on CPU#0
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c0113ad4>] lapic_suspend+0xd8/0x101
 [<c025683c>] sysdev_suspend+0x8d/0x1ee
 [<c025a593>] device_power_down+0x119/0x152
 [<c014adb2>] swsusp_suspend+0x17/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 [<b7f73410>] 0xb7f73410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

swsusp: critical section:
swsusp: Need to copy 126290 pages
BUG: sleeping function called from invalid context swsusp_shutdown(3247) at arch/i386/mm/highmem.c:8
in_atomic():1 [00000001], irqs_disabled():1
no locks held by swsusp_shutdown/3247.
irq event stamp: 0
hardirqs last  enabled at (0): [<00000000>] 0x0
hardirqs last disabled at (0): [<c0120a00>] copy_process+0x526/0x1343
softirqs last  enabled at (0): [<c0120a1e>] copy_process+0x544/0x1343
softirqs last disabled at (0): [<00000000>] 0x0
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c011b852>] __might_sleep+0x10d/0x114
 [<c011a20d>] kmap+0x3b/0x46
 [<c014c324>] swsusp_save+0x2a9/0x3a8
 [<c02bfdfa>] swsusp_arch_suspend+0x2a/0x2c
DWARF2 unwinder stuck at swsusp_arch_suspend+0x2a/0x2c
Leftover inexact backtrace:
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0108538>] .... kernel_fpu_begin+0x16/0x49
.....[<c02bfd85>] ..   ( <= __save_processor_state+0xb/0x3d)


0xc0120a00 is in copy_process (kernel/fork.c:1121).
1116    #else
1117            p->hardirqs_enabled = 0;
1118    #endif
1119            p->hardirq_enable_ip = 0;
1120            p->hardirq_enable_event = 0;
1121            p->hardirq_disable_ip = _THIS_IP_;
1122            p->hardirq_disable_event = 0;
1123            p->softirqs_enabled = 1;
1124            p->softirq_enable_ip = _THIS_IP_;
1125            p->softirq_enable_event = 0;

0xc0120a1e is in copy_process (kernel/fork.c:1124).
1119            p->hardirq_enable_ip = 0;
1120            p->hardirq_enable_event = 0;
1121            p->hardirq_disable_ip = _THIS_IP_;
1122            p->hardirq_disable_event = 0;
1123            p->softirqs_enabled = 1;
1124            p->softirq_enable_ip = _THIS_IP_;
1125            p->softirq_enable_event = 0;
1126            p->softirq_disable_ip = 0;
1127            p->softirq_disable_event = 0;
1128            p->hardirq_context = 0;

0xc0108538 is in kernel_fpu_begin (arch/i386/kernel/i387.c:76).
71      void kernel_fpu_begin(void)
72      {
73              struct thread_info *thread = current_thread_info();
74
75              preempt_disable();
76              if (thread->status & TS_USEDFPU) {
77                      __save_init_fpu(thread->task);
78                      return;
79              }
80              clts();

0xc02bfd85 is in __save_processor_state (arch/i386/power/cpu.c:29).
24              kernel_fpu_begin();
25
26              /*
27               * descriptor tables
28               */
29              store_gdt(&ctxt->gdt);
30              store_idt(&ctxt->idt);
31              store_tr(ctxt->tr);
32
33              /*


swsusp: critical section/: done (126290 pages copied)
BUG: using smp_processor_id() in preemptible [00000000] code: swsusp_shutdown/3247
caller is intel_p4_mcheck_init+0x7b/0x18e
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c01f837b>] debug_smp_processor_id+0x9f/0xac
 [<c010c4bb>] intel_p4_mcheck_init+0x7b/0x18e
 [<c010c238>] mcheck_init+0x57/0x6b
 [<c02bfd65>] __restore_processor_state+0x1b5/0x1bb
 [<c02bfd78>] restore_processor_state+0xd/0xf
 [<c014adeb>] swsusp_suspend+0x50/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 [<b7f73410>] 0xb7f73410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c01f832c>] .... debug_smp_processor_id+0x50/0xac
.....[<c010c4bb>] ..   ( <= intel_p4_mcheck_init+0x7b/0x18e)

0xc010c440 is in intel_p4_mcheck_init (arch/i386/kernel/cpu/mcheck/p4.c:226).
221             wrmsr (MSR_IA32_MCG_STATUS,mcgstl, mcgsth);
222     }
223
224
225     void intel_p4_mcheck_init(struct cpuinfo_x86 *c)
226     {
227             u32 l, h;
228             int i;
229
230             machine_check_vector = intel_machine_check;

0xc01f832c is in debug_smp_processor_id (lib/smp_processor_id.c:42).
37              /*
38               * Avoid recursion:
39               */
40              preempt_disable();
41
42              if (!printk_ratelimit())
43                      goto out_enable;
44
45              printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] code: %s/%d\n", preempt_count()-1, current->comm, current->pid);
46              print_symbol("caller is %s\n", (long)__builtin_return_address(0));

0xc010c4bb is in intel_p4_mcheck_init (arch/i386/kernel/cpu/mcheck/p4.c:245).
240                     wrmsr (MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
241                     wrmsr (MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
242             }
243
244             set_in_cr4 (X86_CR4_MCE);
245             printk (KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
246                     smp_processor_id());
247
248             /* Check for P4/Xeon extended MCE MSRs */
249             rdmsr (MSR_IA32_MCG_CAP, l, h);


BUG: swsusp_shutdown:3247 task might have lost a preemption check!
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c011eeea>] preempt_enable_no_resched+0x5a/0x5c
 [<c01f8380>] debug_smp_processor_id+0xa4/0xac
 [<c010c4bb>] intel_p4_mcheck_init+0x7b/0x18e
 [<c010c238>] mcheck_init+0x57/0x6b
 [<c02bfd65>] __restore_processor_state+0x1b5/0x1bb
 [<c02bfd78>] restore_processor_state+0xd/0xf
 [<c014adeb>] swsusp_suspend+0x50/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 [<b7f73410>] 0xb7f73410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

BUG: using smp_processor_id() in preemptible [00000000] code: swsusp_shutdown/3247
caller is intel_p4_mcheck_init+0xac/0x18e
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c01f837b>] debug_smp_processor_id+0x9f/0xac
 [<c010c4ec>] intel_p4_mcheck_init+0xac/0x18e
 [<c010c238>] mcheck_init+0x57/0x6b
 [<c02bfd65>] __restore_processor_state+0x1b5/0x1bb
 [<c02bfd78>] restore_processor_state+0xd/0xf
 [<c014adeb>] swsusp_suspend+0x50/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 [<b7f73410>] 0xb7f73410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c01f832c>] .... debug_smp_processor_id+0x50/0xac
.....[<c010c4ec>] ..   ( <= intel_p4_mcheck_init+0xac/0x18e)

BUG: using smp_processor_id() in preemptible [00000000] code: swsusp_shutdown/3247
caller is intel_p4_mcheck_init+0xc5/0x18e
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c01f837b>] debug_smp_processor_id+0x9f/0xac
 [<c010c505>] intel_p4_mcheck_init+0xc5/0x18e
 [<c010c238>] mcheck_init+0x57/0x6b
 [<c02bfd65>] __restore_processor_state+0x1b5/0x1bb
 [<c02bfd78>] restore_processor_state+0xd/0xf
 [<c014adeb>] swsusp_suspend+0x50/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 [<b7f73410>] 0xb7f73410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c01f832c>] .... debug_smp_processor_id+0x50/0xac
.....[<c010c505>] ..   ( <= intel_p4_mcheck_init+0xc5/0x18e)

lapic resume on CPU#0
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c0113b2e>] lapic_resume+0x31/0x1c3
 [<c02564ca>] __sysdev_resume+0x14/0x57
 [<c02569b6>] sysdev_resume+0x19/0x54
 [<c025aa23>] device_power_up+0x8/0xf
 [<c014adf5>] swsusp_suspend+0x5a/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 [<b7f73410>] 0xb7f73410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

============================================

Resume


swsusp: Resume From Partition /dev/sda2
PM: Checking swsusp image.
swsusp: Signature found, resuming
PM: Preparing processes for restore.
Disabling non-boot CPUs ...
CPU1 playing dead
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c01013a5>] cpu_idle+0x8d/0x11e
 [<c0112d11>] start_secondary+0x35a/0x362
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c010142b>] .... cpu_idle+0x113/0x11e
.....[<c0112d11>] ..   ( <= start_secondary+0x35a/0x362)


etc...

===================================

echo platform > /sys/power/disk; echo disk > /sys/power/state

CPU1 playing dead
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c01013a5>] cpu_idle+0x8d/0x11e
 [<c0112d11>] start_secondary+0x35a/0x362
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c010142b>] .... cpu_idle+0x113/0x11e
.....[<c0112d11>] ..   ( <= start_secondary+0x35a/0x362)

etc.../

=======================================

Resume

CPU1 playing dead
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c01013a5>] cpu_idle+0x8d/0x11e
 [<c0112d11>] start_secondary+0x35a/0x362
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c010142b>] .... cpu_idle+0x113/0x11e
.....[<c0112d11>] ..   ( <= start_secondary+0x35a/0x362)

 fb0: PM: suspend 0->1, parent 0000:01:00.0 already 1
i2c_adapter i2c-2: PM: suspend 0->1, parent 0000:01:00.0 already 1
i2c_adapter i2c-1: PM: suspend 0->1, parent 0000:01:00.0 already 1
i2c_adapter i2c-0: PM: suspend 0->1, parent 0000:01:00.0 already 1
lapic suspend on CPU#0
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c0113ad4>] lapic_suspend+0xd8/0x101
 [<c025683c>] sysdev_suspend+0x8d/0x1ee
 [<c025a593>] device_power_down+0x119/0x152
 [<c014adb2>] swsusp_suspend+0x17/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25
 [<c01ae5b6>] sysfs_write_file+0xa1/0xc2
 [<c0179d9a>] vfs_write+0xaf/0x163
 [<c017a412>] sys_write+0x40/0x67
 [<c0103101>] syscall_call+0x7/0xb
 [<b7f8c410>] 0xb7f8c410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

swsusp: critical section:
swsusp: Need to copy 126417 pages
lapic resume on CPU#0
 [<c01041c3>] dump_trace+0x63/0x1eb
 [<c0104368>] show_trace_log_lvl+0x1d/0x3a
 [<c0104a43>] show_trace+0x12/0x14
 [<c0104ad6>] dump_stack+0x16/0x18
 [<c0113b2e>] lapic_resume+0x31/0x1c3
 [<c02564ca>] __sysdev_resume+0x14/0x57
 [<c02569b6>] sysdev_resume+0x19/0x54
 [<c025aa23>] device_power_up+0x8/0xf
 [<c014adf5>] swsusp_suspend+0x5a/0x67
 [<c014b511>] pm_suspend_disk+0x9a/0x161
 [<c014a3d9>] enter_state+0x52/0x1bb
 [<c014a5c8>] state_store+0x86/0x9c
 [<c01ae314>] subsys_attr_store+0x20/0x25


My system hangs here.

http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt8/boot2.log
http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rt8/rt-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
