Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZGWIho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZGWIho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZGWIhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:37:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42212 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZGWIhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:37:37 -0400
Date: Thu, 23 Jul 2009 10:37:17 +0200
From: John Kacur <jkacur@redhat.com>
To: linux-rt-users@vger.kernel.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, williams@redhat.com, peterz@infradead.org
Subject: Re: irq lock inversion w/2.6.31-rc3-rtx
Message-ID: <20090723083717.GA5140@tycho.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have a better traceback. (without the chars cut off at the end of a line)


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lockinversion2.txt"

[jkacur@alfred ~]$ su --login
Password: 
[root@alfred ~]# minicom -c on


Welcome to minicom 2.3

OPTIONS: I18n 
Compiled on Feb 26 2009, 00:28:27.
Port /dev/ttyUSB0

                 Press CTRL-A Z for help on special keys                                           
                                                                                                   
metacity used greatest stack depth: 1336 bytes left                                                
fuse init (API version 7.12)                                                                       
                                                                                                   
=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.31-rc3-rt1 #1
---------------------------------------------------------
canberra-gtk-pl/3583 just changed the state of lock:
 ((raw_spinlock_t *)(&lock->wait_lock)){+...-.}, at: [<ffffffff8108c4f8>] do_futex+0x68e/0x961
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&irq_desc_lock_class){-.....}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
1 lock held by canberra-gtk-pl/3583:
 #0:  (&futex_queues[i].lock){+.+...}, at: [<ffffffff8108c421>] do_futex+0x5b7/0x961

the first lock's dependencies:
-> ((raw_spinlock_t *)(&lock->wait_lock)){+...-.} ops: 15793743 {
   HARDIRQ-ON-W at:
                        [<ffffffff810860d5>] __lock_acquire+0x2fd/0xc61
                        [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                        [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                        [<ffffffff8108c4f8>] do_futex+0x68e/0x961
                        [<ffffffff8108c8e8>] sys_futex+0x11d/0x14f
                        [<ffffffff8100bfeb>] system_call_fastpath+0x16/0x1b
                        [<ffffffffffffffff>] 0xffffffffffffffff
   IN-RECLAIM_FS-W at:
                           [<ffffffff81086139>] __lock_acquire+0x361/0xc61
                           [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                           [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                           [<ffffffff813db8e6>] rt_spin_lock_slowlock+0x42/0x2aa
                           [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                           [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                           [<ffffffff810712b7>] prepare_to_wait+0x2d/0x85
                           [<ffffffff810e8085>] kswapd+0xfb/0x686
                           [<ffffffff81070b13>] kthread+0xa6/0xae
                           [<ffffffff8100d15a>] child_rip+0xa/0x20
                           [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                       [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                       [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                       [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                       [<ffffffff813db8e6>] rt_spin_lock_slowlock+0x42/0x2aa
                       [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                       [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                       [<ffffffff810de771>] free_pages_bulk+0x3b/0xda
                       [<ffffffff810dfea7>] free_hot_cold_page+0x1eb/0x228
                       [<ffffffff810dffa0>] free_hot_page+0x1e/0x34
                       [<ffffffff810dffef>] __free_pages+0x39/0x56
                       [<ffffffff8164f9f4>] __free_pages_bootmem+0x91/0xa7
                       [<ffffffff8163368f>] free_all_bootmem_core+0x102/0x1e5
                       [<ffffffff816337d5>] free_all_bootmem_node+0x23/0x39
                       [<ffffffff8162af96>] numa_free_all_bootmem+0x55/0x9f
                       [<ffffffff8162a077>] mem_init+0x38/0x187
                       [<ffffffff81611e23>] start_kernel+0x20b/0x421
                       [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                       [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff82135df8>] __key.17785+0x0/0x8
 -> ((raw_spinlock_t *)(&p->pi_lock)){......} ops: 80807 {
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff8104aa1c>] __sched_setscheduler+0x17a/0x2a3
                         [<ffffffff8104ab63>] sched_setscheduler_nocheck+0x1e/0x34
                         [<ffffffff81070dfe>] kthread_create+0xf7/0x145
                         [<ffffffff813d6147>] migration_call+0x55/0x4f7
                         [<ffffffff8162d874>] migration_init+0x35/0x82
                         [<ffffffff81009092>] do_one_initcall+0x65/0x153
                         [<ffffffff8161178c>] kernel_init+0x8e/0x289
                         [<ffffffff8100d15a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff81883460>] __key.42870+0x0/0x8
  -> ((raw_spinlock_t *)(&rq->lock)){-...-.} ops: 1242223 {
     IN-HARDIRQ-W at:
                            [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                            [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                            [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                            [<ffffffff8104fa79>] scheduler_tick+0x55/0x280
                            [<ffffffff8106240e>] update_process_times+0x59/0x80
                            [<ffffffff8107efec>] tick_periodic+0x76/0x96
                            [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                            [<ffffffff8100f559>] timer_interrupt+0x2d/0x48
                            [<ffffffff810b5195>] handle_irq_action+0x88/0xab
                            [<ffffffff810b4c4e>] handle_IRQ_event+0x90/0x189
                            [<ffffffff810b6ff0>] handle_level_irq+0x8f/0x106
                            [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                            [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                            [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                            [<ffffffffffffffff>] 0xffffffffffffffff
     IN-RECLAIM_FS-W at:
                               [<ffffffff81086139>] __lock_acquire+0x361/0xc61
                               [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                               [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                               [<ffffffff81041779>] task_rq_lock+0x51/0x9b
                               [<ffffffff8104f5f5>] set_cpus_allowed_ptr+0x2e/0x12e
                               [<ffffffff810e8019>] kswapd+0x8f/0x686
                               [<ffffffff81070b13>] kthread+0xa6/0xae
                               [<ffffffff8100d15a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                           [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                           [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                           [<ffffffff8104715b>] rq_attach_root+0x29/0xf6
                           [<ffffffff8162d3e7>] sched_init+0x2cf/0x4b3
                           [<ffffffff81611e32>] start_kernel+0x21a/0x421
                           [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                           [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff81881178>] __key.50609+0x0/0x8
   -> ((raw_spinlock_t *)(&vec->lock)){-.....} ops: 608654 {
      IN-HARDIRQ-W at:
                              [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                              [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                              [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                              [<ffffffff810d1fe3>] cpupri_set+0x88/0x153
                              [<ffffffff810459d2>] enqueue_task_rt+0x11a/0x292
                              [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                              [<ffffffff8103d6e5>] activate_task+0x37/0x56
                              [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                              [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                              [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
                              [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
                              [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
                              [<ffffffff8106239a>] run_local_timers+0x26/0x41
                              [<ffffffff810623f4>] update_process_times+0x3f/0x80
                              [<ffffffff8107efec>] tick_periodic+0x76/0x96
                              [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                              [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                              [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                              [<ffffffffffffffff>] 0xffffffffffffffff
      INITIAL USE at:
                             [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                             [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                             [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                             [<ffffffff810d2038>] cpupri_set+0xdd/0x153
                             [<ffffffff8104520a>] rq_online_rt+0x79/0x94
                             [<ffffffff81040b0b>] set_rq_online+0x5b/0x7f
                             [<ffffffff810471e6>] rq_attach_root+0xb4/0xf6
                             [<ffffffff8162d3e7>] sched_init+0x2cf/0x4b3
                             [<ffffffff81611e32>] start_kernel+0x21a/0x421
                             [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                             [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff82163eb0>] __key.15528+0x0/0x10
   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff810d2038>] cpupri_set+0xdd/0x153
   [<ffffffff8104520a>] rq_online_rt+0x79/0x94
   [<ffffffff81040b0b>] set_rq_online+0x5b/0x7f
   [<ffffffff810471e6>] rq_attach_root+0xb4/0xf6
   [<ffffffff8162d3e7>] sched_init+0x2cf/0x4b3
   [<ffffffff81611e32>] start_kernel+0x21a/0x421
   [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
   [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> ((raw_spinlock_t *)(&rt_b->rt_runtime_lock)){-.....} ops: 217 {
      IN-HARDIRQ-W at:
                              [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                              [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                              [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                              [<ffffffff81045a66>] enqueue_task_rt+0x1ae/0x292
                              [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                              [<ffffffff8103d6e5>] activate_task+0x37/0x56
                              [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                              [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                              [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
                              [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
                              [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
                              [<ffffffff8106239a>] run_local_timers+0x26/0x41
                              [<ffffffff810623f4>] update_process_times+0x3f/0x80
                              [<ffffffff8108052c>] tick_sched_timer+0x82/0xc2
                              [<ffffffff81074464>] __run_hrtimer+0x89/0xd5
                              [<ffffffff81075676>] hrtimer_interrupt+0x127/0x1a9
                              [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                              [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                              [<ffffffffffffffff>] 0xffffffffffffffff
      INITIAL USE at:
                             [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                             [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                             [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                             [<ffffffff81045a66>] enqueue_task_rt+0x1ae/0x292
                             [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                             [<ffffffff8103d6e5>] activate_task+0x37/0x56
                             [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                             [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                             [<ffffffff813d61e0>] migration_call+0xee/0x4f7
                             [<ffffffff8162d896>] migration_init+0x57/0x82
                             [<ffffffff81009092>] do_one_initcall+0x65/0x153
                             [<ffffffff8161178c>] kernel_init+0x8e/0x289
                             [<ffffffff8100d15a>] child_rip+0xa/0x20
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff81881180>] __key.41271+0x0/0x8
    -> ((raw_spinlock_t *)(&cpu_base->lock)){-.....} ops: 474372 {
       IN-HARDIRQ-W at:
                                [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                                [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                [<ffffffff810748ff>] hrtimer_run_queues+0x112/0x18f
                                [<ffffffff81062390>] run_local_timers+0x1c/0x41
                                [<ffffffff810623f4>] update_process_times+0x3f/0x80
                                [<ffffffff8107efec>] tick_periodic+0x76/0x96
                                [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                                [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                                [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                               [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                               [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                               [<ffffffff81074d01>] lock_hrtimer_base+0x34/0x72
                               [<ffffffff81074fc3>] __hrtimer_start_range_ns+0x3b/0x21f
                               [<ffffffff81045ab5>] enqueue_task_rt+0x1fd/0x292
                               [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                               [<ffffffff8103d6e5>] activate_task+0x37/0x56
                               [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                               [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                               [<ffffffff813d61e0>] migration_call+0xee/0x4f7
                               [<ffffffff8162d896>] migration_init+0x57/0x82
                               [<ffffffff81009092>] do_one_initcall+0x65/0x153
                               [<ffffffff8161178c>] kernel_init+0x8e/0x289
                               [<ffffffff8100d15a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff818a6a18>] __key.20973+0x0/0x8
    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff81074d01>] lock_hrtimer_base+0x34/0x72
   [<ffffffff81074fc3>] __hrtimer_start_range_ns+0x3b/0x21f
   [<ffffffff81045ab5>] enqueue_task_rt+0x1fd/0x292
   [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
   [<ffffffff8103d6e5>] activate_task+0x37/0x56
   [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
   [<ffffffff8104b518>] wake_up_process+0x25/0x3b
   [<ffffffff813d61e0>] migration_call+0xee/0x4f7
   [<ffffffff8162d896>] migration_init+0x57/0x82
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> ((raw_spinlock_t *)(&rt_rq->rt_runtime_lock)){-.....} ops: 356036 {
       IN-HARDIRQ-W at:
                                [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                                [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
                                [<ffffffff81044902>] task_tick_rt+0x25/0xf1
                                [<ffffffff8104fb55>] scheduler_tick+0x131/0x280
                                [<ffffffff8106240e>] update_process_times+0x59/0x80
                                [<ffffffff8107efec>] tick_periodic+0x76/0x96
                                [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                                [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                                [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                               [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                               [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                               [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
                               [<ffffffff8104541c>] dequeue_task_rt+0x27/0xb4
                               [<ffffffff8103d68c>] dequeue_task+0xe0/0x102
                               [<ffffffff8103d73b>] deactivate_task+0x37/0x56
                               [<ffffffff813d9ee7>] __schedule+0x1b8/0x8ef
                               [<ffffffff813daa18>] schedule+0x22/0x5c
                               [<ffffffff8104ef14>] migration_thread+0x198/0x235
                               [<ffffffff81070b13>] kthread+0xa6/0xae
                               [<ffffffff8100d15a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff81881188>] __key.50587+0x0/0x8
    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81042188>] __enable_runtime+0x4b/0xa3
   [<ffffffff810451ee>] rq_online_rt+0x5d/0x94
   [<ffffffff81040b0b>] set_rq_online+0x5b/0x7f
   [<ffffffff813d6234>] migration_call+0x142/0x4f7
   [<ffffffff813e15df>] notifier_call_chain+0x40/0x7f
   [<ffffffff81076930>] raw_notifier_call_chain+0x22/0x38
   [<ffffffff813d67eb>] _cpu_up+0xef/0x154
   [<ffffffff813d68c4>] cpu_up+0x74/0x9f
   [<ffffffff816117e2>] kernel_init+0xe4/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81045a66>] enqueue_task_rt+0x1ae/0x292
   [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
   [<ffffffff8103d6e5>] activate_task+0x37/0x56
   [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
   [<ffffffff8104b518>] wake_up_process+0x25/0x3b
   [<ffffffff813d61e0>] migration_call+0xee/0x4f7
   [<ffffffff8162d896>] migration_init+0x57/0x82
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
   [<ffffffff8104541c>] dequeue_task_rt+0x27/0xb4
   [<ffffffff8103d68c>] dequeue_task+0xe0/0x102
   [<ffffffff8103d73b>] deactivate_task+0x37/0x56
   [<ffffffff813d9ee7>] __schedule+0x1b8/0x8ef
   [<ffffffff813daa18>] schedule+0x22/0x5c
   [<ffffffff8104ef14>] migration_thread+0x198/0x235
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> ((raw_spinlock_t *)(&rq->lock)/1){......} ops: 1243 {
      INITIAL USE at:
                             [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                             [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                             [<ffffffff813dd83e>] __spin_lock_nested+0x4e/0x99
                             [<ffffffff8104a68f>] double_rq_lock+0x5d/0xa0
                             [<ffffffff8104a712>] double_lock_balance+0x40/0x62
                             [<ffffffff8104d83f>] push_rt_task+0xc8/0x20e
                             [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
                             [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
                             [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
                             [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
                             [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
                             [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
                             [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                             [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                             [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
                             [<ffffffff8110f6c0>] kfree+0x9d/0xeb
                             [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
                             [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
                             [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
                             [<ffffffff81070b13>] kthread+0xa6/0xae
                             [<ffffffff8100d15a>] child_rip+0xa/0x20
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff81881179>] __key.50609+0x1/0x8
    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
   [<ffffffff8104541c>] dequeue_task_rt+0x27/0xb4
   [<ffffffff8103d68c>] dequeue_task+0xe0/0x102
   [<ffffffff8103d73b>] deactivate_task+0x37/0x56
   [<ffffffff8104d901>] push_rt_task+0x18a/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff810d1fe3>] cpupri_set+0x88/0x153
   [<ffffffff810459d2>] enqueue_task_rt+0x11a/0x292
   [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
   [<ffffffff8103d6e5>] activate_task+0x37/0x56
   [<ffffffff8104d91e>] push_rt_task+0x1a7/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd83e>] __spin_lock_nested+0x4e/0x99
   [<ffffffff8104a68f>] double_rq_lock+0x5d/0xa0
   [<ffffffff8104a712>] double_lock_balance+0x40/0x62
   [<ffffffff8104d83f>] push_rt_task+0xc8/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   -> ((raw_spinlock_t *)(&sig->cputimer.lock)){-.....} ops: 3290 {
      IN-HARDIRQ-W at:
                              [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                              [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                              [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                              [<ffffffff810418a7>] account_group_exec_runtime+0x46/0x75
                              [<ffffffff810419ad>] update_curr+0xd7/0xf6
                              [<ffffffff81041b41>] check_preempt_wakeup+0x56/0x195
                              [<ffffffff8104b35f>] try_to_wake_up+0x28a/0x2f3
                              [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                              [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
                              [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
                              [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
                              [<ffffffff8106239a>] run_local_timers+0x26/0x41
                              [<ffffffff810623f4>] update_process_times+0x3f/0x80
                              [<ffffffff8108052c>] tick_sched_timer+0x82/0xc2
                              [<ffffffff81074464>] __run_hrtimer+0x89/0xd5
                              [<ffffffff81075676>] hrtimer_interrupt+0x127/0x1a9
                              [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                              [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                              [<ffffffffffffffff>] 0xffffffffffffffff
      INITIAL USE at:
                             [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                             [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                             [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                             [<ffffffff810725e0>] thread_group_cputimer+0x3c/0xd9
                             [<ffffffff81073ca5>] posix_cpu_timers_exit_group+0x24/0x5e
                             [<ffffffff8105794f>] release_task+0xdd/0x468
                             [<ffffffff810592db>] do_exit+0x6e1/0x7d9
                             [<ffffffff81069b68>] usermodehelper_disable+0x0/0xe2
                             [<ffffffff8100d15a>] child_rip+0xa/0x20
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff81883468>] __key.22358+0x0/0x8
   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff810418a7>] account_group_exec_runtime+0x46/0x75
   [<ffffffff810419ad>] update_curr+0xd7/0xf6
   [<ffffffff81041b41>] check_preempt_wakeup+0x56/0x195
   [<ffffffff8104b35f>] try_to_wake_up+0x28a/0x2f3
   [<ffffffff8104b518>] wake_up_process+0x25/0x3b
   [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
   [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
   [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
   [<ffffffff8106239a>] run_local_timers+0x26/0x41
   [<ffffffff810623f4>] update_process_times+0x3f/0x80
   [<ffffffff8108052c>] tick_sched_timer+0x82/0xc2
   [<ffffffff81074464>] __run_hrtimer+0x89/0xd5
   [<ffffffff81075676>] hrtimer_interrupt+0x127/0x1a9
   [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
   [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81042324>] __task_rq_lock+0x40/0x86
   [<ffffffff8104aa28>] __sched_setscheduler+0x186/0x2a3
   [<ffffffff8104ab63>] sched_setscheduler_nocheck+0x1e/0x34
   [<ffffffff81070dfe>] kthread_create+0xf7/0x145
   [<ffffffff813d6147>] migration_call+0x55/0x4f7
   [<ffffffff8162d874>] migration_init+0x35/0x82
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81087486>] lock_release_non_nested+0x163/0x1d8
   [<ffffffff810876ff>] lock_release+0x204/0x24a
   [<ffffffff813dd65d>] __spin_unlock+0x2d/0x7d
   [<ffffffff81044efc>] double_unlock_balance+0x23/0x58
   [<ffffffff8104d936>] push_rt_task+0x1bf/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff8108d5e1>] task_blocks_on_rt_mutex+0x43/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff813d9b8e>] wait_for_common+0xd2/0x124
   [<ffffffff813d9d19>] wait_for_completion+0x2b/0x41
   [<ffffffff81070da2>] kthread_create+0x9b/0x145
   [<ffffffff813d69d9>] cpu_callback+0xea/0x215
   [<ffffffff8162e03f>] spawn_ksoftirqd+0x33/0x7b
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (init_task.pi_lock){......} ops: 6 {
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                         [<ffffffff8108d6a4>] task_blocks_on_rt_mutex+0x106/0x1a0
                         [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
                         [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                         [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                         [<ffffffff81061b34>] lock_timer_base+0x39/0x77
                         [<ffffffff81061b9b>] try_to_del_timer_sync+0x29/0x86
                         [<ffffffff81062792>] del_timer_sync+0x82/0xb1
                         [<ffffffffa00f457d>] ata_scsi_error+0x15e/0x674 [libata]
                         [<ffffffffa00abaf6>] scsi_error_handler+0xf6/0x58e [scsi_mod]
                         [<ffffffff81070b13>] kthread+0xa6/0xae
                         [<ffffffff8100d15a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff81586780>] init_task+0x760/0x2510
  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81041779>] task_rq_lock+0x51/0x9b
   [<ffffffff8104cb09>] task_setprio+0x42/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff81061b34>] lock_timer_base+0x39/0x77
   [<ffffffff81061b9b>] try_to_del_timer_sync+0x29/0x86
   [<ffffffff81062792>] del_timer_sync+0x82/0xb1
   [<ffffffffa00f457d>] ata_scsi_error+0x15e/0x674 [libata]
   [<ffffffffa00abaf6>] scsi_error_handler+0xf6/0x58e [scsi_mod]
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff8108d6a4>] task_blocks_on_rt_mutex+0x106/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff81061b34>] lock_timer_base+0x39/0x77
   [<ffffffff81061b9b>] try_to_del_timer_sync+0x29/0x86
   [<ffffffff81062792>] del_timer_sync+0x82/0xb1
   [<ffffffffa00f457d>] ata_scsi_error+0x15e/0x674 [libata]
   [<ffffffffa00abaf6>] scsi_error_handler+0xf6/0x58e [scsi_mod]
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff


the second lock's dependencies:
-> (&irq_desc_lock_class){-.....} ops: 260006 {
   IN-HARDIRQ-W at:
                        [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                        [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                        [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                        [<ffffffff810b6f91>] handle_level_irq+0x30/0x106
                        [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                        [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                        [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                        [<ffffffffffffffff>] 0xffffffffffffffff
   INITIAL USE at:
                       [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                       [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                       [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                       [<ffffffff810b724a>] set_irq_chip+0x6d/0xaa
                       [<ffffffff810b72b1>] set_irq_chip_and_handler_name+0x2a/0x59
                       [<ffffffff816163d9>] native_init_IRQ+0x63/0x228
                       [<ffffffff81611e66>] start_kernel+0x24e/0x421
                       [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                       [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                       [<ffffffffffffffff>] 0xffffffffffffffff
 }
 ... key      at: [<ffffffff8213c4a0>] irq_desc_lock_class+0x0/0x8
 -> (i8259A_lock){-.....} ops: 264 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                          [<ffffffff8101078a>] mask_and_ack_8259A+0x35/0x115
                          [<ffffffff810b6891>] mask_ack_irq+0x43/0x5e
                          [<ffffffff810b6f9c>] handle_level_irq+0x3b/0x106
                          [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                          [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                          [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff81010898>] init_8259A+0x2e/0x107
                         [<ffffffff8161639e>] native_init_IRQ+0x28/0x228
                         [<ffffffff81611e66>] start_kernel+0x24e/0x421
                         [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                         [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff815f5018>] i8259A_lock+0x18/0x40
 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff8101068f>] enable_8259A_irq+0x26/0x76
   [<ffffffff810b6976>] default_enable+0x2d/0x52
   [<ffffffff810b692c>] default_startup+0x2f/0x4c
   [<ffffffff810b59fa>] __setup_irq+0x1c7/0x340
   [<ffffffff810b5ba6>] setup_irq+0x33/0x50
   [<ffffffff816154f8>] hpet_time_init+0x33/0x49
   [<ffffffff81611f76>] start_kernel+0x35e/0x421
   [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
   [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (ioapic_lock){-.....} ops: 10458 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                          [<ffffffff81027740>] mask_IO_APIC_irq_desc+0x33/0x77
                          [<ffffffff81027c2e>] mask_IO_APIC_irq+0x24/0x3a
                          [<ffffffff810b5171>] handle_irq_action+0x64/0xab
                          [<ffffffff810b4c4e>] handle_IRQ_event+0x90/0x189
                          [<ffffffff810b6f08>] handle_fasteoi_irq+0xa5/0xfe
                          [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                          [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                          [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff8162221d>] io_apic_get_version+0x26/0x84
                         [<ffffffff8161d210>] mp_register_ioapic+0xff/0x179
                         [<ffffffff8161d2cd>] acpi_parse_ioapic+0x43/0x67
                         [<ffffffff8163ec8d>] acpi_table_parse_entries+0xca/0x14f
                         [<ffffffff8163ed42>] acpi_table_parse_madt+0x30/0x46
                         [<ffffffff8161d571>] acpi_boot_init+0x1d2/0x390
                         [<ffffffff81616209>] setup_arch+0x984/0xa2c
                         [<ffffffff81611cfd>] start_kernel+0xe5/0x421
                         [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                         [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff815f5418>] ioapic_lock+0x18/0x40
  -> (vector_lock){-.....} ops: 100 {
     IN-HARDIRQ-W at:
                            [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                            [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                            [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                            [<ffffffff81028116>] assign_irq_vector+0x33/0x77
                            [<ffffffff8102819c>] set_desc_affinity+0x42/0x90
                            [<ffffffff810292a5>] set_msi_irq_affinity+0x34/0xab
                            [<ffffffff810b8098>] move_masked_irq+0x90/0xd4
                            [<ffffffff810b8132>] move_native_irq+0x56/0x84
                            [<ffffffff81028e67>] ack_apic_edge+0x33/0x62
                            [<ffffffff810b6d9d>] handle_edge_irq+0x88/0x14e
                            [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                            [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                            [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                            [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                           [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                           [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                           [<ffffffff81028116>] assign_irq_vector+0x33/0x77
                           [<ffffffff81028923>] setup_IO_APIC_irq+0x69/0x1c0
                           [<ffffffff81623871>] setup_IO_APIC+0x23d/0x8e2
                           [<ffffffff8161e9e5>] native_smp_prepare_cpus+0x3a4/0x45f
                           [<ffffffff8161177e>] kernel_init+0x80/0x289
                           [<ffffffff8100d15a>] child_rip+0xa/0x20
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff815f5458>] vector_lock+0x18/0x40
  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff81028116>] assign_irq_vector+0x33/0x77
   [<ffffffff8102819c>] set_desc_affinity+0x42/0x90
   [<ffffffff8102822f>] set_ioapic_affinity_irq_desc+0x45/0x130
   [<ffffffff8162338f>] setup_ioapic_dest+0xbb/0xf8
   [<ffffffff8161e4fe>] native_smp_cpus_done+0xbf/0xe3
   [<ffffffff8161182e>] kernel_init+0x130/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff81010705>] disable_8259A_irq+0x26/0x76
   [<ffffffff81028ed5>] startup_ioapic_irq+0x3f/0x9e
   [<ffffffff810b59fa>] __setup_irq+0x1c7/0x340
   [<ffffffff810b6104>] request_threaded_irq+0x164/0x1c0
   [<ffffffff8122af4f>] acpi_os_install_interrupt_handler+0x7d/0xc0
   [<ffffffff8123ed06>] acpi_ev_install_sci_handler+0x31/0x47
   [<ffffffff8123ddca>] acpi_ev_install_xrupt_handlers+0x1d/0x80
   [<ffffffff8125a1ab>] acpi_enable_subsystem+0x14c/0x16d
   [<ffffffff8163fa2c>] acpi_init+0x88/0x28d
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff81028ec0>] startup_ioapic_irq+0x2a/0x9e
   [<ffffffff810b59fa>] __setup_irq+0x1c7/0x340
   [<ffffffff810b6104>] request_threaded_irq+0x164/0x1c0
   [<ffffffff8122af4f>] acpi_os_install_interrupt_handler+0x7d/0xc0
   [<ffffffff8123ed06>] acpi_ev_install_sci_handler+0x31/0x47
   [<ffffffff8123ddca>] acpi_ev_install_xrupt_handlers+0x1d/0x80
   [<ffffffff8125a1ab>] acpi_enable_subsystem+0x14c/0x16d
   [<ffffffff8163fa2c>] acpi_init+0x88/0x28d
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (logbuf_lock){-.....} ops: 175289 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                          [<ffffffff8105558d>] release_console_sem+0x51/0x1fc
                          [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
                          [<ffffffff813d9817>] printk+0x4b/0x64
                          [<ffffffffa04466dd>] 0xffffffffa04466dd
                          [<ffffffffa044632b>] 0xffffffffa044632b
                          [<ffffffff810901af>] generic_smp_call_function_single_interrupt+0x86/0xd4
                          [<ffffffff81024b92>] smp_call_function_single_interrupt+0x35/0x59
                          [<ffffffff8100cdd3>] call_function_single_interrupt+0x13/0x20
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff8105558d>] release_console_sem+0x51/0x1fc
                         [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
                         [<ffffffff813d9817>] printk+0x4b/0x64
                         [<ffffffff81611cf2>] start_kernel+0xda/0x421
                         [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                         [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff815f6098>] logbuf_lock+0x18/0x40
 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff8105558d>] release_console_sem+0x51/0x1fc
   [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
   [<ffffffff813d9817>] printk+0x4b/0x64
   [<ffffffff810b66fb>] check_irq_resend+0x4c/0xd9
   [<ffffffff810b5815>] __enable_irq+0x78/0x96
   [<ffffffff810b5c0d>] enable_irq+0x4a/0x75
   [<ffffffff810b6133>] request_threaded_irq+0x193/0x1c0
   [<ffffffff813cd792>] i8042_probe+0x1e3/0x5e5
   [<ffffffff8129f8e3>] platform_drv_probe+0x25/0x3b
   [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
   [<ffffffff8129e649>] __device_attach+0x46/0x66
   [<ffffffff8129d722>] bus_for_each_drv+0x63/0xae
   [<ffffffff8129e728>] device_attach+0x70/0x9b
   [<ffffffff8129d4dd>] bus_attach_device+0x3b/0x8b
   [<ffffffff8129b88f>] device_add+0x4cc/0x64c
   [<ffffffff812a0485>] platform_device_add+0x105/0x165
   [<ffffffff8164603d>] i8042_init+0x376/0x3c3
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> ((raw_spinlock_t *)(&lock->wait_lock)){+...-.} ops: 15793743 {
    HARDIRQ-ON-W at:
                          [<ffffffff810860d5>] __lock_acquire+0x2fd/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                          [<ffffffff8108c4f8>] do_futex+0x68e/0x961
                          [<ffffffff8108c8e8>] sys_futex+0x11d/0x14f
                          [<ffffffff8100bfeb>] system_call_fastpath+0x16/0x1b
                          [<ffffffffffffffff>] 0xffffffffffffffff
    IN-RECLAIM_FS-W at:
                             [<ffffffff81086139>] __lock_acquire+0x361/0xc61
                             [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                             [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                             [<ffffffff813db8e6>] rt_spin_lock_slowlock+0x42/0x2aa
                             [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                             [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                             [<ffffffff810712b7>] prepare_to_wait+0x2d/0x85
                             [<ffffffff810e8085>] kswapd+0xfb/0x686
                             [<ffffffff81070b13>] kthread+0xa6/0xae
                             [<ffffffff8100d15a>] child_rip+0xa/0x20
                             [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff813db8e6>] rt_spin_lock_slowlock+0x42/0x2aa
                         [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                         [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                         [<ffffffff810de771>] free_pages_bulk+0x3b/0xda
                         [<ffffffff810dfea7>] free_hot_cold_page+0x1eb/0x228
                         [<ffffffff810dffa0>] free_hot_page+0x1e/0x34
                         [<ffffffff810dffef>] __free_pages+0x39/0x56
                         [<ffffffff8164f9f4>] __free_pages_bootmem+0x91/0xa7
                         [<ffffffff8163368f>] free_all_bootmem_core+0x102/0x1e5
                         [<ffffffff816337d5>] free_all_bootmem_node+0x23/0x39
                         [<ffffffff8162af96>] numa_free_all_bootmem+0x55/0x9f
                         [<ffffffff8162a077>] mem_init+0x38/0x187
                         [<ffffffff81611e23>] start_kernel+0x20b/0x421
                         [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                         [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff82135df8>] __key.17785+0x0/0x8
  -> ((raw_spinlock_t *)(&p->pi_lock)){......} ops: 80807 {
     INITIAL USE at:
                           [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                           [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                           [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                           [<ffffffff8104aa1c>] __sched_setscheduler+0x17a/0x2a3
                           [<ffffffff8104ab63>] sched_setscheduler_nocheck+0x1e/0x34
                           [<ffffffff81070dfe>] kthread_create+0xf7/0x145
                           [<ffffffff813d6147>] migration_call+0x55/0x4f7
                           [<ffffffff8162d874>] migration_init+0x35/0x82
                           [<ffffffff81009092>] do_one_initcall+0x65/0x153
                           [<ffffffff8161178c>] kernel_init+0x8e/0x289
                           [<ffffffff8100d15a>] child_rip+0xa/0x20
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff81883460>] __key.42870+0x0/0x8
   -> ((raw_spinlock_t *)(&rq->lock)){-...-.} ops: 1242223 {
      IN-HARDIRQ-W at:
                              [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                              [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                              [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                              [<ffffffff8104fa79>] scheduler_tick+0x55/0x280
                              [<ffffffff8106240e>] update_process_times+0x59/0x80
                              [<ffffffff8107efec>] tick_periodic+0x76/0x96
                              [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                              [<ffffffff8100f559>] timer_interrupt+0x2d/0x48
                              [<ffffffff810b5195>] handle_irq_action+0x88/0xab
                              [<ffffffff810b4c4e>] handle_IRQ_event+0x90/0x189
                              [<ffffffff810b6ff0>] handle_level_irq+0x8f/0x106
                              [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                              [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                              [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                              [<ffffffffffffffff>] 0xffffffffffffffff
      IN-RECLAIM_FS-W at:
                                 [<ffffffff81086139>] __lock_acquire+0x361/0xc61
                                 [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                 [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                 [<ffffffff81041779>] task_rq_lock+0x51/0x9b
                                 [<ffffffff8104f5f5>] set_cpus_allowed_ptr+0x2e/0x12e
                                 [<ffffffff810e8019>] kswapd+0x8f/0x686
                                 [<ffffffff81070b13>] kthread+0xa6/0xae
                                 [<ffffffff8100d15a>] child_rip+0xa/0x20
                                 [<ffffffffffffffff>] 0xffffffffffffffff
      INITIAL USE at:
                             [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                             [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                             [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                             [<ffffffff8104715b>] rq_attach_root+0x29/0xf6
                             [<ffffffff8162d3e7>] sched_init+0x2cf/0x4b3
                             [<ffffffff81611e32>] start_kernel+0x21a/0x421
                             [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                             [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                             [<ffffffffffffffff>] 0xffffffffffffffff
    }
    ... key      at: [<ffffffff81881178>] __key.50609+0x0/0x8
    -> ((raw_spinlock_t *)(&vec->lock)){-.....} ops: 608654 {
       IN-HARDIRQ-W at:
                                [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                                [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                                [<ffffffff810d1fe3>] cpupri_set+0x88/0x153
                                [<ffffffff810459d2>] enqueue_task_rt+0x11a/0x292
                                [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                                [<ffffffff8103d6e5>] activate_task+0x37/0x56
                                [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                                [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                                [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
                                [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
                                [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
                                [<ffffffff8106239a>] run_local_timers+0x26/0x41
                                [<ffffffff810623f4>] update_process_times+0x3f/0x80
                                [<ffffffff8107efec>] tick_periodic+0x76/0x96
                                [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                                [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                                [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                               [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                               [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                               [<ffffffff810d2038>] cpupri_set+0xdd/0x153
                               [<ffffffff8104520a>] rq_online_rt+0x79/0x94
                               [<ffffffff81040b0b>] set_rq_online+0x5b/0x7f
                               [<ffffffff810471e6>] rq_attach_root+0xb4/0xf6
                               [<ffffffff8162d3e7>] sched_init+0x2cf/0x4b3
                               [<ffffffff81611e32>] start_kernel+0x21a/0x421
                               [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                               [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff82163eb0>] __key.15528+0x0/0x10
    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff810d2038>] cpupri_set+0xdd/0x153
   [<ffffffff8104520a>] rq_online_rt+0x79/0x94
   [<ffffffff81040b0b>] set_rq_online+0x5b/0x7f
   [<ffffffff810471e6>] rq_attach_root+0xb4/0xf6
   [<ffffffff8162d3e7>] sched_init+0x2cf/0x4b3
   [<ffffffff81611e32>] start_kernel+0x21a/0x421
   [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
   [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> ((raw_spinlock_t *)(&rt_b->rt_runtime_lock)){-.....} ops: 217 {
       IN-HARDIRQ-W at:
                                [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                                [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                [<ffffffff81045a66>] enqueue_task_rt+0x1ae/0x292
                                [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                                [<ffffffff8103d6e5>] activate_task+0x37/0x56
                                [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                                [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                                [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
                                [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
                                [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
                                [<ffffffff8106239a>] run_local_timers+0x26/0x41
                                [<ffffffff810623f4>] update_process_times+0x3f/0x80
                                [<ffffffff8108052c>] tick_sched_timer+0x82/0xc2
                                [<ffffffff81074464>] __run_hrtimer+0x89/0xd5
                                [<ffffffff81075676>] hrtimer_interrupt+0x127/0x1a9
                                [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                                [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                               [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                               [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                               [<ffffffff81045a66>] enqueue_task_rt+0x1ae/0x292
                               [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                               [<ffffffff8103d6e5>] activate_task+0x37/0x56
                               [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                               [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                               [<ffffffff813d61e0>] migration_call+0xee/0x4f7
                               [<ffffffff8162d896>] migration_init+0x57/0x82
                               [<ffffffff81009092>] do_one_initcall+0x65/0x153
                               [<ffffffff8161178c>] kernel_init+0x8e/0x289
                               [<ffffffff8100d15a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff81881180>] __key.41271+0x0/0x8
     -> ((raw_spinlock_t *)(&cpu_base->lock)){-.....} ops: 474372 {
        IN-HARDIRQ-W at:
                                  [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                                  [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                  [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                  [<ffffffff810748ff>] hrtimer_run_queues+0x112/0x18f
                                  [<ffffffff81062390>] run_local_timers+0x1c/0x41
                                  [<ffffffff810623f4>] update_process_times+0x3f/0x80
                                  [<ffffffff8107efec>] tick_periodic+0x76/0x96
                                  [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                                  [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                                  [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                                  [<ffffffffffffffff>] 0xffffffffffffffff
        INITIAL USE at:
                                 [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                                 [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                 [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                                 [<ffffffff81074d01>] lock_hrtimer_base+0x34/0x72
                                 [<ffffffff81074fc3>] __hrtimer_start_range_ns+0x3b/0x21f
                                 [<ffffffff81045ab5>] enqueue_task_rt+0x1fd/0x292
                                 [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
                                 [<ffffffff8103d6e5>] activate_task+0x37/0x56
                                 [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
                                 [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                                 [<ffffffff813d61e0>] migration_call+0xee/0x4f7
                                 [<ffffffff8162d896>] migration_init+0x57/0x82
                                 [<ffffffff81009092>] do_one_initcall+0x65/0x153
                                 [<ffffffff8161178c>] kernel_init+0x8e/0x289
                                 [<ffffffff8100d15a>] child_rip+0xa/0x20
                                 [<ffffffffffffffff>] 0xffffffffffffffff
      }
      ... key      at: [<ffffffff818a6a18>] __key.20973+0x0/0x8
     ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff81074d01>] lock_hrtimer_base+0x34/0x72
   [<ffffffff81074fc3>] __hrtimer_start_range_ns+0x3b/0x21f
   [<ffffffff81045ab5>] enqueue_task_rt+0x1fd/0x292
   [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
   [<ffffffff8103d6e5>] activate_task+0x37/0x56
   [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
   [<ffffffff8104b518>] wake_up_process+0x25/0x3b
   [<ffffffff813d61e0>] migration_call+0xee/0x4f7
   [<ffffffff8162d896>] migration_init+0x57/0x82
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

     -> ((raw_spinlock_t *)(&rt_rq->rt_runtime_lock)){-.....} ops: 356036 {
        IN-HARDIRQ-W at:
                                  [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                                  [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                  [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                  [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
                                  [<ffffffff81044902>] task_tick_rt+0x25/0xf1
                                  [<ffffffff8104fb55>] scheduler_tick+0x131/0x280
                                  [<ffffffff8106240e>] update_process_times+0x59/0x80
                                  [<ffffffff8107efec>] tick_periodic+0x76/0x96
                                  [<ffffffff8107f03a>] tick_handle_periodic+0x2e/0x94
                                  [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                                  [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                                  [<ffffffffffffffff>] 0xffffffffffffffff
        INITIAL USE at:
                                 [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                                 [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                 [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                 [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
                                 [<ffffffff8104541c>] dequeue_task_rt+0x27/0xb4
                                 [<ffffffff8103d68c>] dequeue_task+0xe0/0x102
                                 [<ffffffff8103d73b>] deactivate_task+0x37/0x56
                                 [<ffffffff813d9ee7>] __schedule+0x1b8/0x8ef
                                 [<ffffffff813daa18>] schedule+0x22/0x5c
                                 [<ffffffff8104ef14>] migration_thread+0x198/0x235
                                 [<ffffffff81070b13>] kthread+0xa6/0xae
                                 [<ffffffff8100d15a>] child_rip+0xa/0x20
                                 [<ffffffffffffffff>] 0xffffffffffffffff
      }
      ... key      at: [<ffffffff81881188>] __key.50587+0x0/0x8
     ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81042188>] __enable_runtime+0x4b/0xa3
   [<ffffffff810451ee>] rq_online_rt+0x5d/0x94
   [<ffffffff81040b0b>] set_rq_online+0x5b/0x7f
   [<ffffffff813d6234>] migration_call+0x142/0x4f7
   [<ffffffff813e15df>] notifier_call_chain+0x40/0x7f
   [<ffffffff81076930>] raw_notifier_call_chain+0x22/0x38
   [<ffffffff813d67eb>] _cpu_up+0xef/0x154
   [<ffffffff813d68c4>] cpu_up+0x74/0x9f
   [<ffffffff816117e2>] kernel_init+0xe4/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81045a66>] enqueue_task_rt+0x1ae/0x292
   [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
   [<ffffffff8103d6e5>] activate_task+0x37/0x56
   [<ffffffff8104b266>] try_to_wake_up+0x191/0x2f3
   [<ffffffff8104b518>] wake_up_process+0x25/0x3b
   [<ffffffff813d61e0>] migration_call+0xee/0x4f7
   [<ffffffff8162d896>] migration_init+0x57/0x82
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
   [<ffffffff8104541c>] dequeue_task_rt+0x27/0xb4
   [<ffffffff8103d68c>] dequeue_task+0xe0/0x102
   [<ffffffff8103d73b>] deactivate_task+0x37/0x56
   [<ffffffff813d9ee7>] __schedule+0x1b8/0x8ef
   [<ffffffff813daa18>] schedule+0x22/0x5c
   [<ffffffff8104ef14>] migration_thread+0x198/0x235
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> ((raw_spinlock_t *)(&rq->lock)/1){......} ops: 1243 {
       INITIAL USE at:
                               [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                               [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                               [<ffffffff813dd83e>] __spin_lock_nested+0x4e/0x99
                               [<ffffffff8104a68f>] double_rq_lock+0x5d/0xa0
                               [<ffffffff8104a712>] double_lock_balance+0x40/0x62
                               [<ffffffff8104d83f>] push_rt_task+0xc8/0x20e
                               [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
                               [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
                               [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
                               [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
                               [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
                               [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
                               [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                               [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                               [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
                               [<ffffffff8110f6c0>] kfree+0x9d/0xeb
                               [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
                               [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
                               [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
                               [<ffffffff81070b13>] kthread+0xa6/0xae
                               [<ffffffff8100d15a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff81881179>] __key.50609+0x1/0x8
     ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81041f0e>] update_curr_rt+0xd8/0x166
   [<ffffffff8104541c>] dequeue_task_rt+0x27/0xb4
   [<ffffffff8103d68c>] dequeue_task+0xe0/0x102
   [<ffffffff8103d73b>] deactivate_task+0x37/0x56
   [<ffffffff8104d901>] push_rt_task+0x18a/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

     ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff810d1fe3>] cpupri_set+0x88/0x153
   [<ffffffff810459d2>] enqueue_task_rt+0x11a/0x292
   [<ffffffff8103d58a>] enqueue_task+0x6a/0x8c
   [<ffffffff8103d6e5>] activate_task+0x37/0x56
   [<ffffffff8104d91e>] push_rt_task+0x1a7/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd83e>] __spin_lock_nested+0x4e/0x99
   [<ffffffff8104a68f>] double_rq_lock+0x5d/0xa0
   [<ffffffff8104a712>] double_lock_balance+0x40/0x62
   [<ffffffff8104d83f>] push_rt_task+0xc8/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

    -> ((raw_spinlock_t *)(&sig->cputimer.lock)){-.....} ops: 3290 {
       IN-HARDIRQ-W at:
                                [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                                [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                                [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                                [<ffffffff810418a7>] account_group_exec_runtime+0x46/0x75
                                [<ffffffff810419ad>] update_curr+0xd7/0xf6
                                [<ffffffff81041b41>] check_preempt_wakeup+0x56/0x195
                                [<ffffffff8104b35f>] try_to_wake_up+0x28a/0x2f3
                                [<ffffffff8104b518>] wake_up_process+0x25/0x3b
                                [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
                                [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
                                [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
                                [<ffffffff8106239a>] run_local_timers+0x26/0x41
                                [<ffffffff810623f4>] update_process_times+0x3f/0x80
                                [<ffffffff8108052c>] tick_sched_timer+0x82/0xc2
                                [<ffffffff81074464>] __run_hrtimer+0x89/0xd5
                                [<ffffffff81075676>] hrtimer_interrupt+0x127/0x1a9
                                [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
                                [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
                                [<ffffffffffffffff>] 0xffffffffffffffff
       INITIAL USE at:
                               [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                               [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                               [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                               [<ffffffff810725e0>] thread_group_cputimer+0x3c/0xd9
                               [<ffffffff81073ca5>] posix_cpu_timers_exit_group+0x24/0x5e
                               [<ffffffff8105794f>] release_task+0xdd/0x468
                               [<ffffffff810592db>] do_exit+0x6e1/0x7d9
                               [<ffffffff81069b68>] usermodehelper_disable+0x0/0xe2
                               [<ffffffff8100d15a>] child_rip+0xa/0x20
                               [<ffffffffffffffff>] 0xffffffffffffffff
     }
     ... key      at: [<ffffffff81883468>] __key.22358+0x0/0x8
    ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff810418a7>] account_group_exec_runtime+0x46/0x75
   [<ffffffff810419ad>] update_curr+0xd7/0xf6
   [<ffffffff81041b41>] check_preempt_wakeup+0x56/0x195
   [<ffffffff8104b35f>] try_to_wake_up+0x28a/0x2f3
   [<ffffffff8104b518>] wake_up_process+0x25/0x3b
   [<ffffffff8105b191>] wakeup_softirqd+0x56/0x72
   [<ffffffff8105b1d9>] raise_softirq_irqoff+0x2c/0x42
   [<ffffffff8105b37a>] raise_softirq+0x2c/0x62
   [<ffffffff8106239a>] run_local_timers+0x26/0x41
   [<ffffffff810623f4>] update_process_times+0x3f/0x80
   [<ffffffff8108052c>] tick_sched_timer+0x82/0xc2
   [<ffffffff81074464>] __run_hrtimer+0x89/0xd5
   [<ffffffff81075676>] hrtimer_interrupt+0x127/0x1a9
   [<ffffffff8102635a>] smp_apic_timer_interrupt+0x94/0xbe
   [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81042324>] __task_rq_lock+0x40/0x86
   [<ffffffff8104aa28>] __sched_setscheduler+0x186/0x2a3
   [<ffffffff8104ab63>] sched_setscheduler_nocheck+0x1e/0x34
   [<ffffffff81070dfe>] kthread_create+0xf7/0x145
   [<ffffffff813d6147>] migration_call+0x55/0x4f7
   [<ffffffff8162d874>] migration_init+0x35/0x82
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81087486>] lock_release_non_nested+0x163/0x1d8
   [<ffffffff810876ff>] lock_release+0x204/0x24a
   [<ffffffff813dd65d>] __spin_unlock+0x2d/0x7d
   [<ffffffff81044efc>] double_unlock_balance+0x23/0x58
   [<ffffffff8104d936>] push_rt_task+0x1bf/0x20e
   [<ffffffff8104d9b7>] switched_to_rt+0x32/0x84
   [<ffffffff8103d7ff>] check_class_changed+0x54/0x7e
   [<ffffffff8104cc6a>] task_setprio+0x1a3/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff8110dd1c>] _slab_irq_disable+0x4f/0x89
   [<ffffffff8110f6c0>] kfree+0x9d/0xeb
   [<ffffffff810784b2>] release_tgcred_rcu+0x4c/0x67
   [<ffffffff810b8d1e>] rcu_process_callbacks+0x8c/0xb3
   [<ffffffff8105b7d3>] ksoftirqd+0x176/0x2bf
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff8108d5e1>] task_blocks_on_rt_mutex+0x43/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff813d9b8e>] wait_for_common+0xd2/0x124
   [<ffffffff813d9d19>] wait_for_completion+0x2b/0x41
   [<ffffffff81070da2>] kthread_create+0x9b/0x145
   [<ffffffff813d69d9>] cpu_callback+0xea/0x215
   [<ffffffff8162e03f>] spawn_ksoftirqd+0x33/0x7b
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff8161178c>] kernel_init+0x8e/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  -> (init_task.pi_lock){......} ops: 6 {
     INITIAL USE at:
                           [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                           [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                           [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
                           [<ffffffff8108d6a4>] task_blocks_on_rt_mutex+0x106/0x1a0
                           [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
                           [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
                           [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
                           [<ffffffff81061b34>] lock_timer_base+0x39/0x77
                           [<ffffffff81061b9b>] try_to_del_timer_sync+0x29/0x86
                           [<ffffffff81062792>] del_timer_sync+0x82/0xb1
                           [<ffffffffa00f457d>] ata_scsi_error+0x15e/0x674 [libata]
                           [<ffffffffa00abaf6>] scsi_error_handler+0xf6/0x58e [scsi_mod]
                           [<ffffffff81070b13>] kthread+0xa6/0xae
                           [<ffffffff8100d15a>] child_rip+0xa/0x20
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff81586780>] init_task+0x760/0x2510
   ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff81041779>] task_rq_lock+0x51/0x9b
   [<ffffffff8104cb09>] task_setprio+0x42/0x1d2
   [<ffffffff8108cf8f>] __rt_mutex_adjust_prio+0x2f/0x4a
   [<ffffffff8108d6c8>] task_blocks_on_rt_mutex+0x12a/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff81061b34>] lock_timer_base+0x39/0x77
   [<ffffffff81061b9b>] try_to_del_timer_sync+0x29/0x86
   [<ffffffff81062792>] del_timer_sync+0x82/0xb1
   [<ffffffffa00f457d>] ata_scsi_error+0x15e/0x674 [libata]
   [<ffffffffa00abaf6>] scsi_error_handler+0xf6/0x58e [scsi_mod]
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff8108d6a4>] task_blocks_on_rt_mutex+0x106/0x1a0
   [<ffffffff813db9a3>] rt_spin_lock_slowlock+0xff/0x2aa
   [<ffffffff8108de4a>] rt_spin_lock_fastlock+0x67/0x82
   [<ffffffff813dc5e5>] rt_spin_lock+0x2e/0x68
   [<ffffffff81061b34>] lock_timer_base+0x39/0x77
   [<ffffffff81061b9b>] try_to_del_timer_sync+0x29/0x86
   [<ffffffff81062792>] del_timer_sync+0x82/0xb1
   [<ffffffffa00f457d>] ata_scsi_error+0x15e/0x674 [libata]
   [<ffffffffa00abaf6>] scsi_error_handler+0xf6/0x58e [scsi_mod]
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff8108d19e>] rt_mutex_slowtrylock+0x27/0xb2
   [<ffffffff813dc48b>] rt_spin_trylock_irqsave+0x29/0x76
   [<ffffffff81295cb9>] serial8250_console_write+0x4b/0x100
   [<ffffffff81055026>] __call_console_drivers+0xc9/0x108
   [<ffffffff810550cf>] _call_console_drivers+0x6a/0x85
   [<ffffffff8105566a>] release_console_sem+0x12e/0x1fc
   [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
   [<ffffffff813d9817>] printk+0x4b/0x64
   [<ffffffff810b66fb>] check_irq_resend+0x4c/0xd9
   [<ffffffff810b5815>] __enable_irq+0x78/0x96
   [<ffffffff810b5c0d>] enable_irq+0x4a/0x75
   [<ffffffff810b6133>] request_threaded_irq+0x193/0x1c0
   [<ffffffff813cd792>] i8042_probe+0x1e3/0x5e5
   [<ffffffff8129f8e3>] platform_drv_probe+0x25/0x3b
   [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
   [<ffffffff8129e649>] __device_attach+0x46/0x66
   [<ffffffff8129d722>] bus_for_each_drv+0x63/0xae
   [<ffffffff8129e728>] device_attach+0x70/0x9b
   [<ffffffff8129d4dd>] bus_attach_device+0x3b/0x8b
   [<ffffffff8129b88f>] device_add+0x4cc/0x64c
   [<ffffffff812a0485>] platform_device_add+0x105/0x165
   [<ffffffff8164603d>] i8042_init+0x376/0x3c3
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (printing_lock.wait_lock){-.....} ops: 2286 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                          [<ffffffff8108d19e>] rt_mutex_slowtrylock+0x27/0xb2
                          [<ffffffff813dc4fa>] rt_spin_trylock+0x22/0x6f
                          [<ffffffff81282997>] vt_console_print+0x52/0x2c1
                          [<ffffffff81055026>] __call_console_drivers+0xc9/0x108
                          [<ffffffff810550cf>] _call_console_drivers+0x6a/0x85
                          [<ffffffff8105566a>] release_console_sem+0x12e/0x1fc
                          [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
                          [<ffffffff813d9817>] printk+0x4b/0x64
                          [<ffffffffa04466dd>] 0xffffffffa04466dd
                          [<ffffffffa044632b>] 0xffffffffa044632b
                          [<ffffffff810901af>] generic_smp_call_function_single_interrupt+0x86/0xd4
                          [<ffffffff81024b92>] smp_call_function_single_interrupt+0x35/0x59
                          [<ffffffff8100cdd3>] call_function_single_interrupt+0x13/0x20
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff8108d19e>] rt_mutex_slowtrylock+0x27/0xb2
                         [<ffffffff813dc4fa>] rt_spin_trylock+0x22/0x6f
                         [<ffffffff81282997>] vt_console_print+0x52/0x2c1
                         [<ffffffff81055026>] __call_console_drivers+0xc9/0x108
                         [<ffffffff810550cf>] _call_console_drivers+0x6a/0x85
                         [<ffffffff8105566a>] release_console_sem+0x12e/0x1fc
                         [<ffffffff8105616f>] register_console+0x23d/0x260
                         [<ffffffff816431d4>] con_init+0x219/0x237
                         [<ffffffff816426c3>] console_init+0x28/0x50
                         [<ffffffff81611ec2>] start_kernel+0x2aa/0x421
                         [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                         [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff815fdd58>] printing_lock.27541+0x18/0x100
 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff8108d19e>] rt_mutex_slowtrylock+0x27/0xb2
   [<ffffffff813dc4fa>] rt_spin_trylock+0x22/0x6f
   [<ffffffff81282997>] vt_console_print+0x52/0x2c1
   [<ffffffff81055026>] __call_console_drivers+0xc9/0x108
   [<ffffffff810550cf>] _call_console_drivers+0x6a/0x85
   [<ffffffff8105566a>] release_console_sem+0x12e/0x1fc
   [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
   [<ffffffff813d9817>] printk+0x4b/0x64
   [<ffffffff810b66fb>] check_irq_resend+0x4c/0xd9
   [<ffffffff810b5815>] __enable_irq+0x78/0x96
   [<ffffffff810b5c0d>] enable_irq+0x4a/0x75
   [<ffffffff810b6133>] request_threaded_irq+0x193/0x1c0
   [<ffffffff813cd792>] i8042_probe+0x1e3/0x5e5
   [<ffffffff8129f8e3>] platform_drv_probe+0x25/0x3b
   [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
   [<ffffffff8129e649>] __device_attach+0x46/0x66
   [<ffffffff8129d722>] bus_for_each_drv+0x63/0xae
   [<ffffffff8129e728>] device_attach+0x70/0x9b
   [<ffffffff8129d4dd>] bus_attach_device+0x3b/0x8b
   [<ffffffff8129b88f>] device_add+0x4cc/0x64c
   [<ffffffff812a0485>] platform_device_add+0x105/0x165
   [<ffffffff8164603d>] i8042_init+0x376/0x3c3
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (vga_lock){-.....} ops: 6593 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                          [<ffffffff8121aad2>] write_vga+0x2b/0x77
                          [<ffffffff8121b2f0>] vgacon_cursor+0xa1/0x198
                          [<ffffffff812824bd>] hide_cursor+0x38/0x94
                          [<ffffffff81282a0f>] vt_console_print+0xca/0x2c1
                          [<ffffffff81055026>] __call_console_drivers+0xc9/0x108
                          [<ffffffff810550cf>] _call_console_drivers+0x6a/0x85
                          [<ffffffff8105566a>] release_console_sem+0x12e/0x1fc
                          [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
                          [<ffffffff813d9817>] printk+0x4b/0x64
                          [<ffffffffa04466dd>] 0xffffffffa04466dd
                          [<ffffffffa044632b>] 0xffffffffa044632b
                          [<ffffffff810901af>] generic_smp_call_function_single_interrupt+0x86/0xd4
                          [<ffffffff81024b92>] smp_call_function_single_interrupt+0x35/0x59
                          [<ffffffff8100cdd3>] call_function_single_interrupt+0x13/0x20
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff8121aad2>] write_vga+0x2b/0x77
                         [<ffffffff8121ab4d>] vga_set_mem_top+0x2f/0x45
                         [<ffffffff8121aba9>] vgacon_set_origin+0x46/0x6f
                         [<ffffffff8128346d>] set_origin+0x5f/0xb2
                         [<ffffffff81643150>] con_init+0x195/0x237
                         [<ffffffff816426c3>] console_init+0x28/0x50
                         [<ffffffff81611ec2>] start_kernel+0x2aa/0x421
                         [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                         [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff815fd5d8>] vga_lock+0x18/0x40
 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff8121aad2>] write_vga+0x2b/0x77
   [<ffffffff8121b2f0>] vgacon_cursor+0xa1/0x198
   [<ffffffff812824bd>] hide_cursor+0x38/0x94
   [<ffffffff81282a0f>] vt_console_print+0xca/0x2c1
   [<ffffffff81055026>] __call_console_drivers+0xc9/0x108
   [<ffffffff810550cf>] _call_console_drivers+0x6a/0x85
   [<ffffffff8105566a>] release_console_sem+0x12e/0x1fc
   [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
   [<ffffffff813d9817>] printk+0x4b/0x64
   [<ffffffff810b66fb>] check_irq_resend+0x4c/0xd9
   [<ffffffff810b5815>] __enable_irq+0x78/0x96
   [<ffffffff810b5c0d>] enable_irq+0x4a/0x75
   [<ffffffff810b6133>] request_threaded_irq+0x193/0x1c0
   [<ffffffff813cd792>] i8042_probe+0x1e3/0x5e5
   [<ffffffff8129f8e3>] platform_drv_probe+0x25/0x3b
   [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
   [<ffffffff8129e649>] __device_attach+0x46/0x66
   [<ffffffff8129d722>] bus_for_each_drv+0x63/0xae
   [<ffffffff8129e728>] device_attach+0x70/0x9b
   [<ffffffff8129d4dd>] bus_attach_device+0x3b/0x8b
   [<ffffffff8129b88f>] device_add+0x4cc/0x64c
   [<ffffffff812a0485>] platform_device_add+0x105/0x165
   [<ffffffff8164603d>] i8042_init+0x376/0x3c3
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (console_sem.lock){-.....} ops: 3156 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                          [<ffffffff813db75f>] rt_mutex_slowunlock+0x22/0x99
                          [<ffffffff813db7f2>] rt_mutex_unlock+0x1c/0x32
                          [<ffffffff8108f28b>] rt_up+0x3b/0x77
                          [<ffffffff810556d3>] release_console_sem+0x197/0x1fc
                          [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
                          [<ffffffff813d9817>] printk+0x4b/0x64
                          [<ffffffffa04466dd>] 0xffffffffa04466dd
                          [<ffffffffa044632b>] 0xffffffffa044632b
                          [<ffffffff810901af>] generic_smp_call_function_single_interrupt+0x86/0xd4
                          [<ffffffff81024b92>] smp_call_function_single_interrupt+0x35/0x59
                          [<ffffffff8100cdd3>] call_function_single_interrupt+0x13/0x20
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff813db75f>] rt_mutex_slowunlock+0x22/0x99
                         [<ffffffff813db7f2>] rt_mutex_unlock+0x1c/0x32
                         [<ffffffff8108f28b>] rt_up+0x3b/0x77
                         [<ffffffff810556d3>] release_console_sem+0x197/0x1fc
                         [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
                         [<ffffffff813d9817>] printk+0x4b/0x64
                         [<ffffffff81611cf2>] start_kernel+0xda/0x421
                         [<ffffffff816112a9>] x86_64_start_reservations+0xb9/0xd4
                         [<ffffffff81611394>] x86_64_start_kernel+0xd0/0xeb
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff8158f510>] console_sem+0x20/0xa0
  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94
   [<ffffffff8108d5e1>] task_blocks_on_rt_mutex+0x43/0x1a0
   [<ffffffff813db6bc>] __rt_mutex_slowlock+0xae/0x12f
   [<ffffffff813dbc90>] rt_mutex_slowlock+0x142/0x1f9
   [<ffffffff813dbde0>] rt_mutex_lock+0x3d/0x58
   [<ffffffff8108f220>] rt_down+0x29/0x59
   [<ffffffff810557f3>] acquire_console_sem+0x3e/0x71
   [<ffffffff81284eac>] con_open+0x2b/0xeb
   [<ffffffff81273d3e>] tty_open+0x31c/0x45a
   [<ffffffff8111ac38>] chrdev_open+0x12b/0x15e
   [<ffffffff81115294>] __dentry_open+0x1aa/0x2ec
   [<ffffffff811154da>] nameidata_to_filp+0x50/0x78
   [<ffffffff81124123>] do_filp_open+0x562/0xa7e
   [<ffffffff81114f74>] do_sys_open+0x6b/0x12f
   [<ffffffff8111509b>] sys_open+0x2e/0x44
   [<ffffffff8100bfeb>] system_call_fastpath+0x16/0x1b
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff813db75f>] rt_mutex_slowunlock+0x22/0x99
   [<ffffffff813db7f2>] rt_mutex_unlock+0x1c/0x32
   [<ffffffff8108f28b>] rt_up+0x3b/0x77
   [<ffffffff810556d3>] release_console_sem+0x197/0x1fc
   [<ffffffff81055e51>] vprintk+0x3a1/0x3e3
   [<ffffffff813d9817>] printk+0x4b/0x64
   [<ffffffff810b66fb>] check_irq_resend+0x4c/0xd9
   [<ffffffff810b5815>] __enable_irq+0x78/0x96
   [<ffffffff810b5c0d>] enable_irq+0x4a/0x75
   [<ffffffff810b6133>] request_threaded_irq+0x193/0x1c0
   [<ffffffff813cd792>] i8042_probe+0x1e3/0x5e5
   [<ffffffff8129f8e3>] platform_drv_probe+0x25/0x3b
   [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
   [<ffffffff8129e649>] __device_attach+0x46/0x66
   [<ffffffff8129d722>] bus_for_each_drv+0x63/0xae
   [<ffffffff8129e728>] device_attach+0x70/0x9b
   [<ffffffff8129d4dd>] bus_attach_device+0x3b/0x8b
   [<ffffffff8129b88f>] device_add+0x4cc/0x64c
   [<ffffffff812a0485>] platform_device_add+0x105/0x165
   [<ffffffff8164603d>] i8042_init+0x376/0x3c3
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff81028bf6>] ioapic_retrigger_irq+0x3b/0xae
   [<ffffffff810b672d>] check_irq_resend+0x7e/0xd9
   [<ffffffff810b5815>] __enable_irq+0x78/0x96
   [<ffffffff810b5c0d>] enable_irq+0x4a/0x75
   [<ffffffff810b6133>] request_threaded_irq+0x193/0x1c0
   [<ffffffff813cd792>] i8042_probe+0x1e3/0x5e5
   [<ffffffff8129f8e3>] platform_drv_probe+0x25/0x3b
   [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
   [<ffffffff8129e649>] __device_attach+0x46/0x66
   [<ffffffff8129d722>] bus_for_each_drv+0x63/0xae
   [<ffffffff8129e728>] device_attach+0x70/0x9b
   [<ffffffff8129d4dd>] bus_attach_device+0x3b/0x8b
   [<ffffffff8129b88f>] device_add+0x4cc/0x64c
   [<ffffffff812a0485>] platform_device_add+0x105/0x165
   [<ffffffff8164603d>] i8042_init+0x376/0x3c3
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 -> (pci_lock){-.....} ops: 13220 {
    IN-HARDIRQ-W at:
                          [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                          [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                          [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                          [<ffffffff811ffbbe>] pci_bus_read_config_dword+0x4b/0xaa
                          [<ffffffff81211432>] read_msi_msg_desc+0x6f/0xd6
                          [<ffffffff810292d2>] set_msi_irq_affinity+0x61/0xab
                          [<ffffffff810b8098>] move_masked_irq+0x90/0xd4
                          [<ffffffff810b8132>] move_native_irq+0x56/0x84
                          [<ffffffff81028e67>] ack_apic_edge+0x33/0x62
                          [<ffffffff810b6d9d>] handle_edge_irq+0x88/0x14e
                          [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                          [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                          [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                          [<ffffffffffffffff>] 0xffffffffffffffff
    INITIAL USE at:
                         [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                         [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                         [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                         [<ffffffff811ffbbe>] pci_bus_read_config_dword+0x4b/0xaa
                         [<ffffffff813c762d>] pci_scan_single_device+0x54/0x15f
                         [<ffffffff81201a91>] pci_scan_slot+0x2c/0xbe
                         [<ffffffff813c93fa>] pci_scan_child_bus+0x37/0xc7
                         [<ffffffff813ce751>] pci_acpi_scan_root+0x2d3/0x34b
                         [<ffffffff813cbc23>] acpi_pci_root_add+0x184/0x297
                         [<ffffffff8122dfea>] acpi_device_probe+0x66/0x1e7
                         [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
                         [<ffffffff8129e5c9>] __driver_attach+0x67/0xa1
                         [<ffffffff8129dafa>] bus_for_each_dev+0x63/0xae
                         [<ffffffff8129e2a7>] driver_attach+0x2f/0x45
                         [<ffffffff8129d232>] bus_add_driver+0xca/0x22f
                         [<ffffffff8129e9e3>] driver_register+0xc5/0x14a
                         [<ffffffff8122fba2>] acpi_bus_register_driver+0x51/0x67
                         [<ffffffff81640354>] acpi_pci_root_init+0x2c/0x4f
                         [<ffffffff81009092>] do_one_initcall+0x65/0x153
                         [<ffffffff81611877>] kernel_init+0x179/0x289
                         [<ffffffff8100d15a>] child_rip+0xa/0x20
                         [<ffffffffffffffff>] 0xffffffffffffffff
  }
  ... key      at: [<ffffffff815fd398>] pci_lock+0x18/0x40
  -> (pci_config_lock){-.....} ops: 13377 {
     IN-HARDIRQ-W at:
                            [<ffffffff8108605a>] __lock_acquire+0x282/0xc61
                            [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                            [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                            [<ffffffff8131354a>] pci_conf1_read+0x6a/0x108
                            [<ffffffff81314f4d>] raw_pci_read+0x31/0x5d
                            [<ffffffff81315012>] pci_read+0x3a/0x50
                            [<ffffffff811ffbdc>] pci_bus_read_config_dword+0x69/0xaa
                            [<ffffffff81211432>] read_msi_msg_desc+0x6f/0xd6
                            [<ffffffff810292d2>] set_msi_irq_affinity+0x61/0xab
                            [<ffffffff810b8098>] move_masked_irq+0x90/0xd4
                            [<ffffffff810b8132>] move_native_irq+0x56/0x84
                            [<ffffffff81028e67>] ack_apic_edge+0x33/0x62
                            [<ffffffff810b6d9d>] handle_edge_irq+0x88/0x14e
                            [<ffffffff8100eecd>] handle_irq+0x98/0xb7
                            [<ffffffff8100e27b>] do_IRQ+0x71/0xe6
                            [<ffffffff8100ca13>] ret_from_intr+0x0/0xf
                            [<ffffffffffffffff>] 0xffffffffffffffff
     INITIAL USE at:
                           [<ffffffff81086152>] __lock_acquire+0x37a/0xc61
                           [<ffffffff81086b46>] lock_acquire+0x10d/0x145
                           [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
                           [<ffffffff81648ab8>] pci_direct_probe+0x5f/0x1f5
                           [<ffffffff81648711>] pci_arch_init+0x1d/0x7d
                           [<ffffffff81009092>] do_one_initcall+0x65/0x153
                           [<ffffffff81611877>] kernel_init+0x179/0x289
                           [<ffffffff8100d15a>] child_rip+0xa/0x20
                           [<ffffffffffffffff>] 0xffffffffffffffff
   }
   ... key      at: [<ffffffff815ff158>] pci_config_lock+0x18/0x40
  ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff8131354a>] pci_conf1_read+0x6a/0x108
   [<ffffffff81314f4d>] raw_pci_read+0x31/0x5d
   [<ffffffff81315012>] pci_read+0x3a/0x50
   [<ffffffff811ffbdc>] pci_bus_read_config_dword+0x69/0xaa
   [<ffffffff813c762d>] pci_scan_single_device+0x54/0x15f
   [<ffffffff81201a91>] pci_scan_slot+0x2c/0xbe
   [<ffffffff813c93fa>] pci_scan_child_bus+0x37/0xc7
   [<ffffffff813ce751>] pci_acpi_scan_root+0x2d3/0x34b
   [<ffffffff813cbc23>] acpi_pci_root_add+0x184/0x297
   [<ffffffff8122dfea>] acpi_device_probe+0x66/0x1e7
   [<ffffffff8129e4a6>] driver_probe_device+0xa9/0x165
   [<ffffffff8129e5c9>] __driver_attach+0x67/0xa1
   [<ffffffff8129dafa>] bus_for_each_dev+0x63/0xae
   [<ffffffff8129e2a7>] driver_attach+0x2f/0x45
   [<ffffffff8129d232>] bus_add_driver+0xca/0x22f
   [<ffffffff8129e9e3>] driver_register+0xc5/0x14a
   [<ffffffff8122fba2>] acpi_bus_register_driver+0x51/0x67
   [<ffffffff81640354>] acpi_pci_root_init+0x2c/0x4f
   [<ffffffff81009092>] do_one_initcall+0x65/0x153
   [<ffffffff81611877>] kernel_init+0x179/0x289
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff

 ... acquired at:
   [<ffffffff8108688c>] __lock_acquire+0xab4/0xc61
   [<ffffffff81086b46>] lock_acquire+0x10d/0x145
   [<ffffffff813ddaa1>] __spin_lock_irqsave+0x56/0xa4
   [<ffffffff811ffbbe>] pci_bus_read_config_dword+0x4b/0xaa
   [<ffffffff81211432>] read_msi_msg_desc+0x6f/0xd6
   [<ffffffff810292d2>] set_msi_irq_affinity+0x61/0xab
   [<ffffffff810b538c>] setup_affinity+0x80/0x9d
   [<ffffffff810b5a1c>] __setup_irq+0x1e9/0x340
   [<ffffffff810b6104>] request_threaded_irq+0x164/0x1c0
   [<ffffffff810b7676>] devm_request_threaded_irq+0x7d/0xcb
   [<ffffffffa00e705f>] ata_host_activate+0x9a/0x113 [libata]
   [<ffffffffa0117f89>] ahci_init_one+0xd7a/0xdae [ahci]
   [<ffffffff81206951>] local_pci_probe+0x25/0x3d
   [<ffffffff8106b81a>] do_work_for_cpu+0x28/0x54
   [<ffffffff81070b13>] kthread+0xa6/0xae
   [<ffffffff8100d15a>] child_rip+0xa/0x20
   [<ffffffffffffffff>] 0xffffffffffffffff


stack backtrace:
Pid: 3583, comm: canberra-gtk-pl Not tainted 2.6.31-rc3-rt1 #1
Call Trace:
 [<ffffffff81085601>] print_irq_inversion_bug+0x132/0x157
 [<ffffffff81082ba8>] ? find_usage_backwards+0x122/0x161
 [<ffffffff810856a1>] ? check_usage_backwards+0x0/0x78
 [<ffffffff810856fa>] check_usage_backwards+0x59/0x78
 [<ffffffff81084d63>] mark_lock+0x13f/0x24e
 [<ffffffff81084c55>] ? mark_lock+0x31/0x24e
 [<ffffffff810860d5>] __lock_acquire+0x2fd/0xc61
 [<ffffffff81086a16>] ? __lock_acquire+0xc3e/0xc61
 [<ffffffff8108c4f8>] ? do_futex+0x68e/0x961
 [<ffffffff81084ed2>] ? mark_held_locks+0x60/0x94                                                                       
 [<ffffffff810b9760>] ? __rcu_read_unlock+0x9d/0xbf                                                                     
 [<ffffffff8108c4f8>] ? do_futex+0x68e/0x961                                                                            
 [<ffffffff81086b46>] lock_acquire+0x10d/0x145                                                                          
 [<ffffffff8108c4f8>] ? do_futex+0x68e/0x961                                                                            
 [<ffffffff813dd8d4>] __spin_lock+0x4b/0x94                                                                             
 [<ffffffff8108c4f8>] ? do_futex+0x68e/0x961                                                                            
 [<ffffffff8108c4f8>] do_futex+0x68e/0x961                                                                              
 [<ffffffff813dd594>] ? __spin_unlock_irqrestore+0x5c/0x9e                                                              
 [<ffffffff810851e4>] ? trace_hardirqs_on_caller+0x126/0x169                                                            
 [<ffffffff813dd5b1>] ? __spin_unlock_irqrestore+0x79/0x9e                                                              
 [<ffffffff813db795>] ? rt_mutex_slowunlock+0x58/0x99                                                                   
 [<ffffffff8108c8e8>] sys_futex+0x11d/0x14f                                                                             
 [<ffffffff8100bfeb>] system_call_fastpath+0x16/0x1b                                                                    
CPU0 attaching NULL sched-domain.                                                                                       
CPU1 attaching NULL sched-domain.                                                                                       
CPU0 attaching sched-domain:                                                                                            
 domain 0: span 0-1 level MC                                                                                            
  groups: 0 1                                                                                                           
CPU1 attaching sched-domain:                                                                                            
 domain 0: span 0-1 level MC                                                                                            
  groups: 1 0                                                                                                           
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_intel.c:1557: azx_pcm_prepare: bufsize=0x10000, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1057: hda_codec_setup_stream: NID=0x1c, stream=0x5, channel=0, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1057: hda_codec_setup_stream: NID=0x10, stream=0x5, channel=0, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_intel.c:1557: azx_pcm_prepare: bufsize=0x10000, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1057: hda_codec_setup_stream: NID=0x1c, stream=0x5, channel=0, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1057: hda_codec_setup_stream: NID=0x10, stream=0x5, channel=0, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_intel.c:1557: azx_pcm_prepare: bufsize=0x10000, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1057: hda_codec_setup_stream: NID=0x14, stream=0x1, channel=0, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_intel.c:1557: azx_pcm_prepare: bufsize=0x10000, format=0x4011               
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1057: hda_codec_setup_stream: NID=0x14, stream=0x1, channel=0, format=0x4011
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1070: hda_codec_cleanup_stream: NID=0x14                            
wlan0: authenticate with AP 00:1a:4f:02:80:6b                                                                                
wlan0: authenticated                                                                                                         
wlan0: associate with AP 00:1a:4f:02:80:6b                                                                                           
wlan0: RX AssocResp from 00:1a:4f:02:80:6b (capab=0x411 status=0 aid=1)                                                              
wlan0: associated                                                                                                                    
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready                                                                                   
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1070: hda_codec_cleanup_stream: NID=0x10                                    
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1070: hda_codec_cleanup_stream: NID=0x1c                            
ALSA /home/jkacur/rt.linux.git/sound/pci/hda/hda_codec.c:1070: hda_codec_cleanup_stream: NID=0x10                            
wlan0: no IPv6 routers present                                                                                               
wlan0: authenticate with AP 00:1a:4f:23:08:f8                                                                                
wlan0: authenticated                                                                                                         
wlan0: associate with AP 00:1a:4f:23:08:f8                                                                                   
wlan0: RX ReassocResp from 00:1a:4f:23:08:f8 (capab=0x411 status=1 aid=1)                                                    
wlan0: AP denied association (code=1)                                                                                        
wlan0: associate with AP 00:1a:4f:23:08:f8                                                                                   
wlan0: RX AssocResp from 00:1a:4f:23:08:f8 (capab=0x411 status=1 aid=1)                                                      
wlan0: AP denied association (code=1)                                                                                        
wlan0: associate with AP 00:1a:4f:23:08:f8                                                                                   
wlan0: RX AssocResp from 00:1a:4f:23:08:f8 (capab=0x411 status=1 aid=1)                                                      
wlan0: AP denied association (code=1)                                                                                        
wlan0: association with AP 00:1a:4f:23:08:f8 timed out                                                                       
wlan0: authenticate with AP 00:1a:4f:23:08:f8                                                                                
wlan0: authenticated                                                                                                         
wlan0: associate with AP 00:1a:4f:23:08:f8                                                                                   
wlan0: RX AssocResp from 00:1a:4f:23:08:f8 (capab=0x411 status=1 aid=1)                                                      
wlan0: AP denied association (code=1)                                                                                        
wlan0: associate with AP 00:1a:4f:23:08:f8                                                                                   
wlan0: RX AssocResp from 00:1a:4f:23:08:f8 (capab=0x411 status=1 aid=1)                                                      
wlan0: AP denied association (code=1)                                                                                        
wlan0: associate with AP 00:1a:4f:23:08:f8                                                                                   
wlan0: RX AssocResp from 00:1a:4f:23:08:f8 (capab=0x411 status=1 aid=1)                                                      
wlan0: AP denied association (code=1)                                                                                        
wlan0: association with AP 00:1a:4f:23:08:f8 timed out                                                                       
wlan0: authenticate with AP 00:1a:4f:02:80:6b                                                                                
wlan0: authenticated                                                                                                         
wlan0: associate with AP 00:1a:4f:02:80:6b                                                                                   
wlan0: RX AssocResp from 00:1a:4f:02:80:6b (capab=0x411 status=0 aid=1)
wlan0: associated                                                                                                            

 CTRL-A Z for help |115200 8N1 | NOR | Minicom 2.3    | VT102 | Online 00:09                                                                                                



--Nq2Wo0NMKNjxTN9z--
