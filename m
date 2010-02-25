Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab0BYVXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:23:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933961Ab0BYVXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:23:31 -0500
Date: Thu, 25 Feb 2010 22:22:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/21] v6 add lockdep-based diagnostics to
 rcu_dereference()
Message-ID: <20100225212226.GA9134@elte.hu>
References: <20100223010435.GA666@linux.vnet.ibm.com>
 <20100225100022.GA25261@elte.hu>
 <20100225100147.GA28060@elte.hu>
 <20100225120444.GA17623@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225120444.GA17623@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


plus there's one with a lockdep warning as well:

PM: Adding info for No Bus:vcsa10
eth0: no IPv6 routers present
------------[ cut here ]------------
WARNING: at kernel/softirq.c:143 _local_bh_enable_ip+0x3a/0x9d()
Hardware name: System Product Name
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.33-tip-00754-gbd37c01-dirty #18764
Call Trace:
 [<c1036212>] warn_slowpath_common+0x6a/0x81
 [<c103b97f>] ? _local_bh_enable_ip+0x3a/0x9d
 [<c15aa645>] ? inet_putpeer+0x4c/0x4f
 [<c103623b>] warn_slowpath_null+0x12/0x15
 [<c103b97f>] _local_bh_enable_ip+0x3a/0x9d
 [<c103b9ef>] local_bh_enable_ip+0xd/0xf
 [<c168189b>] _raw_spin_unlock_bh+0x2a/0x2d
 [<c15aa645>] inet_putpeer+0x4c/0x4f
 [<c15a6f71>] ipv4_dst_destroy+0x2b/0x44
 [<c1591167>] dst_destroy+0x63/0xaf
 [<c15a6d7e>] dst_free+0x1e/0x29
 [<c15a6d96>] dst_rcu_free+0xd/0xf
 [<c107998c>] rcu_do_batch+0x91/0x16f
 [<c1079afb>] __rcu_process_callbacks+0x91/0x95
 [<c1079c08>] rcu_needs_cpu+0x109/0x132
 [<c105870f>] tick_nohz_stop_sched_tick+0x15c/0x36f
 [<c1001c09>] cpu_idle+0x78/0xb3
 [<c16470a0>] rest_init+0x9c/0xa1
 [<c1a3c958>] start_kernel+0x373/0x378
 [<c1a3c0ab>] i386_start_kernel+0xab/0xb2
---[ end trace 1110cdd88992d6b2 ]---

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.33-tip-00754-gbd37c01-dirty #18764
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&(&base->lock)->rlock){+.-.-.}, at: [<c10414a3>] get_next_timer_interrupt+0x27/0x1ba
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&(&np->lock)->rlock){-.-...}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by swapper/0.

the shortest dependencies between 2nd lock and 1st lock:
 -> (&(&np->lock)->rlock){-.-...} ops: 4907 {
    IN-HARDIRQ-W at:
                          [<c105b42d>] mark_irqflags+0x50/0x110
                          [<c105c895>] __lock_acquire+0x21d/0x3d7
                          [<c105cae1>] lock_acquire+0x92/0xa9
                          [<c16811c3>] _raw_spin_lock+0x23/0x53
                          [<c14a1cdc>] spin_lock+0xd/0xf
                          [<c14a2e4a>] nv_nic_irq_optimized+0xcf/0x242
                          [<c1074f66>] handle_IRQ_event+0x4b/0xf1
                          [<c1076924>] handle_fasteoi_irq+0x7b/0xb2
                          [<c1004340>] handle_irq+0x40/0x4c
                          [<c1003b8e>] do_IRQ+0x46/0x9f
                          [<c1002f55>] common_interrupt+0x35/0x40
    IN-SOFTIRQ-W at:
                          [<c105b44c>] mark_irqflags+0x6f/0x110
                          [<c105c895>] __lock_acquire+0x21d/0x3d7
                          [<c105cae1>] lock_acquire+0x92/0xa9
                          [<c16812de>] _raw_spin_lock_irqsave+0x2c/0x5f
                          [<c14a3541>] nv_start_xmit_optimized+0x81/0x406
                          [<c158d70b>] dev_hard_start_xmit+0x141/0x1d3
                          [<c15a1b6e>] sch_direct_xmit+0x55/0x134
                          [<c158daca>] dev_queue_xmit+0x241/0x38b
                          [<c1594609>] neigh_resolve_output+0x10d/0x133
                          [<c15ed540>] ip6_output_finish+0x7b/0xb0
                          [<c15ef305>] ip6_output2+0x1d0/0x1d8
                          [<c15efc2c>] ip6_output+0xc2/0xc6
                          [<c160249a>] dst_output+0xe/0x10
                          [<c1603389>] mld_sendpack+0x1ae/0x2aa
                          [<c1603d95>] mld_send_cr+0x1e0/0x1e8
                          [<c1603dad>] mld_ifc_timer_expire+0x10/0x33
                          [<c1040e87>] run_timer_softirq+0x172/0x207
                          [<c103b6f9>] __do_softirq+0xb7/0x169
                          [<c103b7db>] do_softirq+0x30/0x48
                          [<c103b912>] irq_exit+0x3a/0x6d
                          [<c1016328>] smp_apic_timer_interrupt+0x6d/0x7b
                          [<c1682006>] apic_timer_interrupt+0x36/0x40
    INITIAL USE at:
                         [<c105c8ac>] __lock_acquire+0x234/0x3d7
                         [<c105cae1>] lock_acquire+0x92/0xa9
                         [<c1681282>] _raw_spin_lock_irq+0x29/0x59
                         [<c149f2d1>] spin_lock_irq+0xd/0xf
                         [<c166ab67>] nv_probe+0xa24/0xe40
                         [<c127d7a8>] local_pci_probe+0x13/0x15
                         [<c127e229>] pci_device_probe+0x48/0x6b
                         [<c13206d7>] really_probe+0x8e/0x165
                         [<c13207fa>] driver_probe_device+0x4c/0x82
                         [<c1320878>] __driver_attach+0x48/0x64
                         [<c131fd71>] bus_for_each_dev+0x42/0x6c
                         [<c1320501>] driver_attach+0x19/0x1b
                         [<c13201d6>] bus_add_driver+0xb6/0x200
                         [<c1320adf>] driver_register+0x7e/0xe5
                         [<c127e428>] __pci_register_driver+0x51/0xae
                         [<c1a69b69>] init_nic+0x14/0x16
                         [<c1001143>] do_one_initcall+0x51/0x13b
                         [<c1a3c360>] do_basic_setup+0x3f/0x52
                         [<c1a3c3e2>] kernel_init+0x6f/0xb0
                         [<c1002f66>] kernel_thread_helper+0x6/0x10
  }
  ... key      at: [<c22d7bd4>] __key.40874+0x0/0x8
  ... acquired at:
   [<c105c1da>] check_prev_add+0x177/0x1ae
   [<c105c5f6>] validate_chain+0x3e5/0x467
   [<c105c9d8>] __lock_acquire+0x360/0x3d7
   [<c105cae1>] lock_acquire+0x92/0xa9
   [<c16812de>] _raw_spin_lock_irqsave+0x2c/0x5f
   [<c104106d>] lock_timer_base+0x26/0x45
   [<c10410b3>] __mod_timer+0x27/0x109
   [<c10411dc>] mod_timer+0x20/0x27
   [<c14a4920>] nv_open+0x43c/0x45b
   [<c158ea3a>] dev_open+0x8b/0xc5
   [<c158e0c1>] dev_change_flags+0x9a/0x149
   [<c15cd6a9>] devinet_ioctl+0x22e/0x43f
   [<c15ce863>] inet_ioctl+0x93/0xac
   [<c157f817>] sock_ioctl+0x1ce/0x1f2
   [<c10cfe65>] vfs_ioctl+0x2c/0x94
   [<c10d02c3>] do_vfs_ioctl+0x267/0x27e
   [<c10d0320>] sys_ioctl+0x46/0x66
   [<c10029fb>] sysenter_do_call+0x12/0x36

-> (&(&base->lock)->rlock){+.-.-.} ops: 142011 {
   HARDIRQ-ON-W at:
                        [<c105b48f>] mark_irqflags+0xb2/0x110
                        [<c105c895>] __lock_acquire+0x21d/0x3d7
                        [<c105cae1>] lock_acquire+0x92/0xa9
                        [<c16811c3>] _raw_spin_lock+0x23/0x53
                        [<c10414a3>] get_next_timer_interrupt+0x27/0x1ba
                        [<c1058904>] tick_nohz_stop_sched_tick+0x351/0x36f
                        [<c1001c09>] cpu_idle+0x78/0xb3
                        [<c16470a0>] rest_init+0x9c/0xa1
                        [<c1a3c958>] start_kernel+0x373/0x378
                        [<c1a3c0ab>] i386_start_kernel+0xab/0xb2
   IN-SOFTIRQ-W at:
                        [<c105b44c>] mark_irqflags+0x6f/0x110
                        [<c105c895>] __lock_acquire+0x21d/0x3d7
                        [<c105cae1>] lock_acquire+0x92/0xa9
                        [<c1681282>] _raw_spin_lock_irq+0x29/0x59
                        [<c1040d4c>] run_timer_softirq+0x37/0x207
                        [<c103b6f9>] __do_softirq+0xb7/0x169
                        [<c103b7db>] do_softirq+0x30/0x48
                        [<c103b912>] irq_exit+0x3a/0x6d
                        [<c1003bd3>] do_IRQ+0x8b/0x9f
                        [<c1002f55>] common_interrupt+0x35/0x40
                        [<c1075c0c>] __setup_irq+0x1e2/0x26b
                        [<c1075cb3>] setup_irq+0x1e/0x22
                        [<c1a3f0ff>] setup_default_timer_irq+0xf/0x11
                        [<c1a3f117>] hpet_time_init+0x16/0x18
                        [<c1a3f0e9>] x86_late_time_init+0x9/0x10
                        [<c1a3c8cd>] start_kernel+0x2e8/0x378
                        [<c1a3c0ab>] i386_start_kernel+0xab/0xb2
   IN-RECLAIM_FS-W at:
                           [<c105b4d6>] mark_irqflags+0xf9/0x110
                           [<c105c895>] __lock_acquire+0x21d/0x3d7
                           [<c105cae1>] lock_acquire+0x92/0xa9
                           [<c16812de>] _raw_spin_lock_irqsave+0x2c/0x5f
                           [<c104106d>] lock_timer_base+0x26/0x45
                           [<c10410b3>] __mod_timer+0x27/0x109
                           [<c167ff60>] schedule_timeout+0x79/0x9d
                           [<c10a3d7e>] kswapd+0xde/0x178
                           [<c104b87c>] kthread+0x6f/0x74
                           [<c1002f66>] kernel_thread_helper+0x6/0x10
   INITIAL USE at:
                       [<c105c8ac>] __lock_acquire+0x234/0x3d7
                       [<c105cae1>] lock_acquire+0x92/0xa9
                       [<c16812de>] _raw_spin_lock_irqsave+0x2c/0x5f
                       [<c104106d>] lock_timer_base+0x26/0x45
                       [<c10410b3>] __mod_timer+0x27/0x109
                       [<c10411dc>] mod_timer+0x20/0x27
                       [<c1a6106a>] con_init+0xa9/0x1cb
                       [<c1a607c1>] console_init+0x12/0x20
                       [<c1a3c7f2>] start_kernel+0x20d/0x378
                       [<c1a3c0ab>] i386_start_kernel+0xab/0xb2
 }
 ... key      at: [<c1d4a0ec>] __key.33971+0x0/0x8
 ... acquired at:
   [<c105bb85>] check_usage_backwards+0x64/0x6f
   [<c105b240>] mark_lock_irq+0x5b/0xca
   [<c105b36e>] mark_lock+0xbf/0x12e
   [<c105b48f>] mark_irqflags+0xb2/0x110
   [<c105c895>] __lock_acquire+0x21d/0x3d7
   [<c105cae1>] lock_acquire+0x92/0xa9
   [<c16811c3>] _raw_spin_lock+0x23/0x53
   [<c10414a3>] get_next_timer_interrupt+0x27/0x1ba
   [<c1058904>] tick_nohz_stop_sched_tick+0x351/0x36f
   [<c1001c09>] cpu_idle+0x78/0xb3
   [<c16470a0>] rest_init+0x9c/0xa1
   [<c1a3c958>] start_kernel+0x373/0x378
   [<c1a3c0ab>] i386_start_kernel+0xab/0xb2


stack backtrace:
Pid: 0, comm: swapper Tainted: G        W  2.6.33-tip-00754-gbd37c01-dirty #18764
Call Trace:
 [<c167f62e>] ? printk+0x14/0x16
 [<c105baa7>] print_irq_inversion_bug+0xde/0xe9
 [<c105bb85>] check_usage_backwards+0x64/0x6f
 [<c100440c>] ? dump_trace+0x7b/0xa8
 [<c105b240>] mark_lock_irq+0x5b/0xca
 [<c105bb21>] ? check_usage_backwards+0x0/0x6f
 [<c105b36e>] mark_lock+0xbf/0x12e
 [<c105b48f>] mark_irqflags+0xb2/0x110
 [<c105c895>] __lock_acquire+0x21d/0x3d7
 [<c10414a3>] ? get_next_timer_interrupt+0x27/0x1ba
 [<c105cae1>] lock_acquire+0x92/0xa9
 [<c10414a3>] ? get_next_timer_interrupt+0x27/0x1ba
 [<c16811c3>] _raw_spin_lock+0x23/0x53
 [<c10414a3>] ? get_next_timer_interrupt+0x27/0x1ba
 [<c10414a3>] get_next_timer_interrupt+0x27/0x1ba
 [<c1079c08>] ? rcu_needs_cpu+0x109/0x132
 [<c1058904>] tick_nohz_stop_sched_tick+0x351/0x36f
 [<c1001c09>] cpu_idle+0x78/0xb3
 [<c16470a0>] rest_init+0x9c/0xa1
 [<c1a3c958>] start_kernel+0x373/0x378
 [<c1a3c0ab>] i386_start_kernel+0xab/0xb2
