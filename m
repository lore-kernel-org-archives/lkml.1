Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426Ab0BZRDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:03:11 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49888 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965375Ab0BZRDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:03:09 -0500
Date: Fri, 26 Feb 2010 09:02:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] rcu: fixes for RCU lockdep
Message-ID: <20100226170229.GB6733@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100225220624.GA7013@linux.vnet.ibm.com> <20100226115018.GA4519@elte.hu> <20100226131931.GA19695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226131931.GA19695@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 02:19:31PM +0100, Ingo Molnar wrote:
> 
> another lockdep splat:
> 
> [   26.484222] PM: Adding info for No Bus:vcs10
> [   26.484520] PM: Adding info for No Bus:vcsa10
> [  297.312223] ------------[ cut here ]------------
> [  297.313012] WARNING: at kernel/softirq.c:143 local_bh_enable_ip+0x90/0xd0()
> [  297.313012] Hardware name: System Product Name
> [  297.313012] Modules linked in:
> [  297.313012] Pid: 0, comm: swapper Not tainted 2.6.33-tip-00954-g8f6d799-dirty #18817
> [  297.313012] Call Trace:
> [  297.313012]  [<c103bf6d>] warn_slowpath_common+0x6d/0xa0
> [  297.313012]  [<c1042880>] ? local_bh_enable_ip+0x90/0xd0
> [  297.313012]  [<c1042880>] ? local_bh_enable_ip+0x90/0xd0
> [  297.313012]  [<c16c91d0>] ? inet_putpeer+0x40/0x50
> [  297.313012]  [<c103bfb5>] warn_slowpath_null+0x15/0x20
> [  297.313012]  [<c1042880>] local_bh_enable_ip+0x90/0xd0
> [  297.313012]  [<c17a787f>] _raw_spin_unlock_bh+0x2f/0x40
> [  297.313012]  [<c16c91d0>] inet_putpeer+0x40/0x50
> [  297.313012]  [<c16c581e>] ipv4_dst_destroy+0x2e/0x70
> [  297.313012]  [<c1690eff>] dst_destroy+0x3f/0xd0
> [  297.313012]  [<c16c587f>] dst_rcu_free+0x1f/0x30
> [  297.313012]  [<c10898b0>] rcu_do_batch+0xa0/0x200
> [  297.313012]  [<c1089a62>] __rcu_process_callbacks+0x52/0xb0
> [  297.313012]  [<c108a1b1>] rcu_needs_cpu+0x111/0x1a0
> [  297.313012]  [<c1064172>] tick_nohz_stop_sched_tick+0x152/0x5d0
> [  297.313012]  [<c17a4f34>] ? schedule+0x454/0x720
> [  297.313012]  [<c1001d30>] cpu_idle+0x70/0x110
> [  297.313012]  [<c17a20a6>] start_secondary+0xcb/0xce
> [  297.313012] ---[ end trace aeda9d92a5036c87 ]---
> [  297.436645] 
> [  297.436646] =========================================================
> [  297.437613] [ INFO: possible irq lock inversion dependency detected ]
> [  297.437613] 2.6.33-tip-00954-g8f6d799-dirty #18817
> [  297.437613] ---------------------------------------------------------

I believe that this one is a side-effect of my bogus CONFIG_RCU_FAST_NO_HZ
patch.  I have a prototype fix for this, and am testing it.  My
overnight tests passed, but a config botch failed to actually set
CONFIG_RCU_FAST_NO_HZ.  :-/

But at least my scripts now tell me when this happens!
]
							Thanx, Paul

> [  297.437613] swapper/0 just changed the state of lock:
> [  297.437613]  (&(&base->lock)->rlock){+.-.-.}, at: [<c1047498>] get_next_timer_interrupt+0x28/0x250
> [  297.437613] but this lock was taken by another, HARDIRQ-safe lock in the past:
> [  297.437613]  (&(&np->lock)->rlock){-.-...}
> [  297.437613] 
> [  297.437613] and interrupts could create inverse lock ordering between them.
> [  297.437613] 
> [  297.437613] 
> [  297.437613] other info that might help us debug this:
> [  297.437613] no locks held by swapper/0.
> [  297.437613] 
> [  297.437613] the shortest dependencies between 2nd lock and 1st lock:
> [  297.437613]  -> (&(&np->lock)->rlock){-.-...} ops: 0 {
> [  297.437613]     IN-HARDIRQ-W at:
> [  297.437613]                                          [<c1068e55>] mark_irqflags+0x155/0x160
> [  297.437613]                                          [<c106a29a>] __lock_acquire+0x39a/0x470
> [  297.437613]                                          [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]                                          [<c17a7100>] _raw_spin_lock+0x40/0x70
> [  297.437613]                                          [<c153a977>] nv_nic_irq_optimized+0x77/0x2b0
> [  297.437613]                                          [<c1084fce>] handle_IRQ_event+0x2e/0xc0
> [  297.437613]                                          [<c10872d3>] handle_fasteoi_irq+0x63/0xd0
> [  297.437613]     IN-SOFTIRQ-W at:
> [  297.437613]                                          [<c1068de6>] mark_irqflags+0xe6/0x160
> [  297.437613]                                          [<c106a29a>] __lock_acquire+0x39a/0x470
> [  297.437613]                                          [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]                                          [<c17a728f>] _raw_spin_lock_irqsave+0x4f/0x90
> [  297.437613]                                          [<c153ad10>] nv_start_xmit_optimized+0x90/0x570
> [  297.437613]                                          [<c168d9ed>] dev_hard_start_xmit+0x1bd/0x240
> [  297.437613]                                          [<c16a552c>] sch_direct_xmit+0xbc/0x180
> [  297.437613]                                          [<c168ddd8>] dev_queue_xmit+0x368/0x4b0
> [  297.437613]                                          [<c16ef8d7>] arp_xmit+0x57/0x60
> [  297.437613]                                          [<c16efd45>] arp_send+0x55/0x60
> [  297.437613]                                          [<c16f0923>] arp_solicit+0x163/0x2a0
> [  297.437613]                                          [<c169450a>] neigh_timer_handler+0xca/0x2f0
> [  297.437613]                                          [<c1047b68>] run_timer_softirq+0x168/0x260
> [  297.437613]                                          [<c1041e1e>] __do_softirq+0x9e/0x140
> [  297.437613]     INITIAL USE at:
> [  297.437613]                                         [<c106a0c9>] __lock_acquire+0x1c9/0x470
> [  297.437613]                                         [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]                                         [<c17a7206>] _raw_spin_lock_irq+0x46/0x80
> [  297.437613]                                         [<c1535098>] spin_lock_irq+0x8/0x10
> [  297.437613]                                         [<c1792761>] nv_probe+0xa48/0xeae
> [  297.437613]                                         [<c130059e>] local_pci_probe+0xe/0x10
> [  297.437613]                                         [<c13012b0>] pci_device_probe+0x60/0x80
> [  297.437613]                                         [<c13f0a19>] really_probe+0x59/0x1e0
> [  297.437613]                                         [<c13f0bcd>] driver_probe_device+0x2d/0x80
> [  297.437613]                                         [<c13f0c99>] __driver_attach+0x79/0x80
> [  297.437613]                                         [<c13f01b8>] bus_for_each_dev+0x48/0x70
> [  297.437613]                                         [<c13f0839>] driver_attach+0x19/0x20
> [  297.437613]                                         [<c13efac7>] bus_add_driver+0x1b7/0x2b0
> [  297.437613]                                         [<c13f0f15>] driver_register+0x65/0x120
> [  297.437613]                                         [<c1300d84>] __pci_register_driver+0x54/0xc0
> [  297.437613]                                         [<c1b46923>] init_nic+0x14/0x16
> [  297.437613]                                         [<c100112d>] do_one_initcall+0x2d/0x190
> [  297.437613]                                         [<c1b1635c>] do_basic_setup+0x42/0x52
> [  297.437613]                                         [<c1b163de>] kernel_init+0x72/0xb9
> [  297.437613]                                         [<c1003402>] kernel_thread_helper+0x6/0x34
> [  297.437613]   }
> [  297.437613]   ... key      at: [<c2407564>] __key.40066+0x0/0x8
> [  297.437613]   ... acquired at:
> [  297.437613]    [<c106958f>] check_prev_add+0x23f/0x4d0
> [  297.437613]    [<c1069dc0>] validate_chain+0x5a0/0x6e0
> [  297.437613]    [<c106a1f6>] __lock_acquire+0x2f6/0x470
> [  297.437613]    [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]    [<c17a728f>] _raw_spin_lock_irqsave+0x4f/0x90
> [  297.437613]    [<c10472c7>] lock_timer_base+0x27/0x50
> [  297.437613]    [<c10480f6>] mod_timer+0x46/0x180
> [  297.437613]    [<c153a45e>] nv_open+0x3de/0x4f0
> [  297.437613]    [<c168bd1d>] dev_open+0x8d/0xe0
> [  297.437613]    [<c168bb76>] dev_change_flags+0x76/0x190
> [  297.437613]    [<c16f3f1c>] devinet_ioctl+0x57c/0x610
> [  297.437613]    [<c16f522a>] inet_ioctl+0x9a/0xc0
> [  297.437613]    [<c167b373>] sock_ioctl+0x63/0x260
> [  297.437613]    [<c10cdf0d>] vfs_ioctl+0x2d/0xc0
> [  297.437613]    [<c10ce7b7>] do_vfs_ioctl+0x67/0x320
> [  297.437613]    [<c10ceacf>] sys_ioctl+0x5f/0x80
> [  297.437613]    [<c1002e73>] sysenter_do_call+0x12/0x32
> [  297.437613] 
> [  297.437613] -> (&(&base->lock)->rlock){+.-.-.} ops: 0 {
> [  297.437613]    HARDIRQ-ON-W at:
> [  297.437613]                                        [<c1068e06>] mark_irqflags+0x106/0x160
> [  297.437613]                                        [<c106a29a>] __lock_acquire+0x39a/0x470
> [  297.437613]                                        [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]                                        [<c17a7100>] _raw_spin_lock+0x40/0x70
> [  297.437613]                                        [<c1047498>] get_next_timer_interrupt+0x28/0x250
> [  297.437613]                                        [<c1064328>] tick_nohz_stop_sched_tick+0x308/0x5d0
> [  297.437613]                                        [<c1001d30>] cpu_idle+0x70/0x110
> [  297.437613]                                        [<c17a20a6>] start_secondary+0xcb/0xce
> [  297.437613]    IN-SOFTIRQ-W at:
> [  297.437613]                                        [<c1068de6>] mark_irqflags+0xe6/0x160
> [  297.437613]                                        [<c106a29a>] __lock_acquire+0x39a/0x470
> [  297.437613]                                        [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]                                        [<c17a7206>] _raw_spin_lock_irq+0x46/0x80
> [  297.437613]                                        [<c1047a37>] run_timer_softirq+0x37/0x260
> [  297.437613]                                        [<c1041e1e>] __do_softirq+0x9e/0x140
> [  297.437613]    IN-RECLAIM_FS-W at:
> [  297.437613]                                           [<c1068db2>] mark_irqflags+0xb2/0x160
> [  297.437613]                                           [<c106a29a>] __lock_acquire+0x39a/0x470
> [  297.437613]                                           [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]                                           [<c17a728f>] _raw_spin_lock_irqsave+0x4f/0x90
> [  297.437613]                                           [<c10472c7>] lock_timer_base+0x27/0x50
> [  297.437613]                                           [<c17a54aa>] schedule_timeout+0x7a/0x210
> [  297.437613]                                           [<c10a48c7>] kswapd+0x1b7/0x1e0
> [  297.437613]                                           [<c1052e2c>] kthread+0x7c/0x90
> [  297.437613]                                           [<c1003402>] kernel_thread_helper+0x6/0x34
> [  297.437613]    INITIAL USE at:
> [  297.437613]                                       [<c106a0c9>] __lock_acquire+0x1c9/0x470
> [  297.437613]                                       [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]                                       [<c17a728f>] _raw_spin_lock_irqsave+0x4f/0x90
> [  297.437613]                                       [<c10472c7>] lock_timer_base+0x27/0x50
> [  297.437613]                                       [<c10480f6>] mod_timer+0x46/0x180
> [  297.437613]                                       [<c1b36c85>] con_init+0xae/0x1fb
> [  297.437613]                                       [<c1b364a1>] console_init+0x12/0x20
> [  297.437613]                                       [<c1b1681d>] start_kernel+0x222/0x2ed
> [  297.437613]                                       [<c1b16089>] i386_start_kernel+0x89/0x8b
> [  297.437613]  }
> [  297.437613]  ... key      at: [<c1e071c0>] __key.30254+0x0/0x8
> [  297.437613]  ... acquired at:
> [  297.437613]    [<c1068402>] check_usage_backwards+0x82/0xe0
> [  297.437613]    [<c10689b4>] mark_lock_irq+0x84/0x240
> [  297.437613]    [<c1068c72>] mark_lock+0x102/0x190
> [  297.437613]    [<c1068e06>] mark_irqflags+0x106/0x160
> [  297.437613]    [<c106a29a>] __lock_acquire+0x39a/0x470
> [  297.437613]    [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]    [<c17a7100>] _raw_spin_lock+0x40/0x70
> [  297.437613]    [<c1047498>] get_next_timer_interrupt+0x28/0x250
> [  297.437613]    [<c1064328>] tick_nohz_stop_sched_tick+0x308/0x5d0
> [  297.437613]    [<c1001d30>] cpu_idle+0x70/0x110
> [  297.437613]    [<c17a20a6>] start_secondary+0xcb/0xce
> [  297.437613] 
> [  297.437613] 
> [  297.437613] stack backtrace:
> [  297.437613] Pid: 0, comm: swapper Tainted: G        W  2.6.33-tip-00954-g8f6d799-dirty #18817
> [  297.437613] Call Trace:
> [  297.437613]  [<c17a46c1>] ? printk+0x18/0x1a
> [  297.437613]  [<c1067f64>] print_irq_inversion_bug+0x104/0x120
> [  297.437613]  [<c1068402>] check_usage_backwards+0x82/0xe0
> [  297.437613]  [<c1005daf>] ? dump_trace+0x7f/0xd0
> [  297.437613]  [<c10689b4>] mark_lock_irq+0x84/0x240
> [  297.437613]  [<c1068380>] ? check_usage_backwards+0x0/0xe0
> [  297.437613]  [<c1068c72>] mark_lock+0x102/0x190
> [  297.437613]  [<c1068e06>] mark_irqflags+0x106/0x160
> [  297.437613]  [<c106a29a>] __lock_acquire+0x39a/0x470
> [  297.437613]  [<c106919b>] ? trace_hardirqs_on+0xb/0x10
> [  297.437613]  [<c10b8c76>] ? slob_free+0xa6/0x310
> [  297.437613]  [<c106a3d4>] lock_acquire+0x64/0x80
> [  297.437613]  [<c1047498>] ? get_next_timer_interrupt+0x28/0x250
> [  297.437613]  [<c17a7100>] _raw_spin_lock+0x40/0x70
> [  297.437613]  [<c1047498>] ? get_next_timer_interrupt+0x28/0x250
> [  297.437613]  [<c1047498>] get_next_timer_interrupt+0x28/0x250
> [  297.437613]  [<c1089a62>] ? __rcu_process_callbacks+0x52/0xb0
> [  297.437613]  [<c108a1b1>] ? rcu_needs_cpu+0x111/0x1a0
> [  297.437613]  [<c1064328>] tick_nohz_stop_sched_tick+0x308/0x5d0
> [  297.437613]  [<c17a4f34>] ? schedule+0x454/0x720
> [  297.437613]  [<c1001d30>] cpu_idle+0x70/0x110
> [  297.437613]  [<c17a20a6>] start_secondary+0xcb/0xce
> 
> 	Ingo

> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.33
> # Fri Feb 26 16:20:51 2010
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_GPIO=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> # CONFIG_GENERIC_TIME_VSYSCALL is not set
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_HAVE_EARLY_RES=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_TRAMPOLINE=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_LZO=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> # CONFIG_KERNEL_LZO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> # CONFIG_AUDIT is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_TREE_PREEMPT_RCU is not set
> # CONFIG_TINY_RCU is not set
> # CONFIG_RCU_TRACE is not set
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_EXACT=y
> CONFIG_RCU_FAST_NO_HZ=y
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=m
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=20
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> # CONFIG_CGROUPS is not set
> # CONFIG_SYSFS_DEPRECATED_V2 is not set
> CONFIG_RELAY=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
> # CONFIG_NET_NS is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_LZO=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_KALLSYMS_EXTRA_PASS=y
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_USE_VMALLOC=y
> CONFIG_PERF_EVENTS_NMI=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_PERF_COUNTERS is not set
> CONFIG_DEBUG_PERF_USE_VMALLOC=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_SLUB_DEBUG=y
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> # CONFIG_KPROBES is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_SLOW_WORK is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> # CONFIG_LBDAF is not set
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_INTEGRITY=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=m
> CONFIG_IOSCHED_CFQ=m
> # CONFIG_DEFAULT_DEADLINE is not set
> # CONFIG_DEFAULT_CFQ is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> # CONFIG_INLINE_SPIN_TRYLOCK is not set
> # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK is not set
> # CONFIG_INLINE_SPIN_LOCK_BH is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_SPIN_UNLOCK is not set
> # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
> # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_READ_TRYLOCK is not set
> # CONFIG_INLINE_READ_LOCK is not set
> # CONFIG_INLINE_READ_LOCK_BH is not set
> # CONFIG_INLINE_READ_LOCK_IRQ is not set
> # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_READ_UNLOCK is not set
> # CONFIG_INLINE_READ_UNLOCK_BH is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQ is not set
> # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> # CONFIG_INLINE_WRITE_TRYLOCK is not set
> # CONFIG_INLINE_WRITE_LOCK is not set
> # CONFIG_INLINE_WRITE_LOCK_BH is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> # CONFIG_INLINE_WRITE_UNLOCK is not set
> # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
> # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> # CONFIG_MUTEX_SPIN_ON_OWNER is not set
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> # CONFIG_SPARSE_IRQ is not set
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_BIGSMP=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> CONFIG_X86_ELAN=y
> # CONFIG_X86_MRST is not set
> CONFIG_X86_RDC321X=y
> CONFIG_X86_32_NON_STANDARD=y
> CONFIG_X86_NUMAQ=y
> CONFIG_X86_SUMMIT=y
> CONFIG_X86_ES7000=y
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> CONFIG_PARAVIRT_GUEST=y
> # CONFIG_VMI is not set
> CONFIG_KVM_CLOCK=y
> CONFIG_KVM_GUEST=y
> CONFIG_LGUEST_GUEST=y
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_SPINLOCKS=y
> CONFIG_PARAVIRT_CLOCK=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_NO_BOOTMEM is not set
> # CONFIG_MEMTEST is not set
> CONFIG_X86_SUMMIT_NUMA=y
> CONFIG_X86_CYCLONE_TIMER=y
> CONFIG_X86_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=7
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=4
> CONFIG_X86_XADD=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_ALIGNMENT_16=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_CPU_SUP_UMC_32=y
> # CONFIG_X86_DS is not set
> # CONFIG_HPET_TIMER is not set
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> # CONFIG_IOMMU_API is not set
> CONFIG_NR_CPUS=32
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> # CONFIG_X86_ANCIENT_MCE is not set
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> # CONFIG_MICROCODE_INTEL is not set
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=y
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> # CONFIG_HIGHMEM4G is not set
> CONFIG_HIGHMEM64G=y
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_X86_PAE=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_NUMA=y
> CONFIG_NODES_SHIFT=4
> CONFIG_HAVE_ARCH_BOOTMEM=y
> CONFIG_NEED_NODE_MEMMAP_SIZE=y
> CONFIG_HAVE_ARCH_ALLOC_REMAP=y
> CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
> CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_NEED_MULTIPLE_NODES=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_STATIC=y
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> # CONFIG_MIGRATION is not set
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_HIGHPTE=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW_64K=y
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> CONFIG_KEXEC_JUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> # CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID is not set
> 
> #
> # Power management and ACPI options
> #
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> CONFIG_PM_VERBOSE=y
> CONFIG_CAN_PM_TRACE=y
> CONFIG_PM_TRACE=y
> CONFIG_PM_TRACE_RTC=y
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_SLEEP=y
> CONFIG_SUSPEND=y
> # CONFIG_PM_TEST_SUSPEND is not set
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATION_NVS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_PROCFS_POWER=y
> # CONFIG_ACPI_POWER_METER is not set
> CONFIG_ACPI_SYSFS_POWER=y
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> # CONFIG_ACPI_BUTTON is not set
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
> # CONFIG_ACPI_THERMAL is not set
> CONFIG_ACPI_NUMA=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> CONFIG_ACPI_DEBUG=y
> CONFIG_ACPI_DEBUG_FUNC_TRACE=y
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_SBS=m
> # CONFIG_SFI is not set
> # CONFIG_APM is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_DEBUG=y
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> CONFIG_CPU_FREQ_GOV_USERSPACE=m
> # CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_ACPI_CPUFREQ=m
> CONFIG_ELAN_CPUFREQ=y
> CONFIG_SC520_CPUFREQ=m
> CONFIG_X86_POWERNOW_K6=m
> CONFIG_X86_POWERNOW_K7=y
> CONFIG_X86_POWERNOW_K7_ACPI=y
> CONFIG_X86_POWERNOW_K8=m
> CONFIG_X86_GX_SUSPMOD=m
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> CONFIG_X86_SPEEDSTEP_ICH=y
> CONFIG_X86_SPEEDSTEP_SMI=m
> CONFIG_X86_P4_CLOCKMOD=m
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> CONFIG_X86_LONGRUN=m
> CONFIG_X86_LONGHAUL=m
> CONFIG_X86_E_POWERSAVER=y
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_OLPC=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_DMAR is not set
> CONFIG_PCIEPORTBUS=y
> # CONFIG_PCIEAER is not set
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_LEGACY is not set
> CONFIG_PCI_DEBUG=y
> CONFIG_PCI_STUB=y
> CONFIG_HT_IRQ=y
> CONFIG_PCI_IOV=y
> CONFIG_PCI_IOAPIC=y
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> CONFIG_MCA=y
> CONFIG_MCA_LEGACY=y
> # CONFIG_MCA_PROC_FS is not set
> # CONFIG_SCx200 is not set
> CONFIG_OLPC=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=m
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_PCMCIA_IOCTL=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=y
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_PD6729=m
> CONFIG_I82092=m
> CONFIG_PCCARD_NONSTATIC=y
> # CONFIG_HOTPLUG_PCI is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_BINFMT_MISC=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> # CONFIG_PACKET_MMAP is not set
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=m
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_NET_KEY=y
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_PNP=y
> # CONFIG_IP_PNP_DHCP is not set
> CONFIG_IP_PNP_BOOTP=y
> # CONFIG_IP_PNP_RARP is not set
> CONFIG_NET_IPIP=y
> # CONFIG_NET_IPGRE is not set
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> CONFIG_ARPD=y
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> CONFIG_INET_ESP=m
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=y
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> CONFIG_INET_LRO=y
> # CONFIG_INET_DIAG is not set
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> # CONFIG_TCP_CONG_HSTCP is not set
> # CONFIG_TCP_CONG_HYBLA is not set
> CONFIG_TCP_CONG_VEGAS=y
> # CONFIG_TCP_CONG_SCALABLE is not set
> CONFIG_TCP_CONG_LP=m
> # CONFIG_TCP_CONG_VENO is not set
> CONFIG_TCP_CONG_YEAH=y
> CONFIG_TCP_CONG_ILLINOIS=y
> # CONFIG_DEFAULT_BIC is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=m
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> # CONFIG_INET6_IPCOMP is not set
> # CONFIG_IPV6_MIP6 is not set
> # CONFIG_INET6_XFRM_TUNNEL is not set
> CONFIG_INET6_TUNNEL=m
> # CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
> # CONFIG_INET6_XFRM_MODE_TUNNEL is not set
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_SIT=m
> # CONFIG_IPV6_SIT_6RD is not set
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=m
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> CONFIG_IPV6_MROUTE=y
> CONFIG_IPV6_PIMSM_V2=y
> CONFIG_NETLABEL=y
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETFILTER is not set
> CONFIG_IP_DCCP=m
> 
> #
> # DCCP CCIDs Configuration (EXPERIMENTAL)
> #
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=y
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_CCID3_RTO=100
> CONFIG_IP_DCCP_TFRC_LIB=y
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_IP_SCTP=m
> CONFIG_SCTP_DBG_MSG=y
> CONFIG_SCTP_DBG_OBJCNT=y
> # CONFIG_SCTP_HMAC_NONE is not set
> # CONFIG_SCTP_HMAC_SHA1 is not set
> CONFIG_SCTP_HMAC_MD5=y
> CONFIG_RDS=y
> # CONFIG_RDS_TCP is not set
> CONFIG_RDS_DEBUG=y
> CONFIG_TIPC=m
> # CONFIG_TIPC_ADVANCED is not set
> CONFIG_TIPC_DEBUG=y
> CONFIG_ATM=m
> # CONFIG_ATM_CLIP is not set
> CONFIG_ATM_LANE=m
> CONFIG_ATM_MPOA=m
> # CONFIG_ATM_BR2684 is not set
> CONFIG_STP=y
> CONFIG_GARP=m
> CONFIG_BRIDGE=y
> CONFIG_NET_DSA=y
> # CONFIG_NET_DSA_TAG_DSA is not set
> CONFIG_NET_DSA_TAG_EDSA=y
> CONFIG_NET_DSA_TAG_TRAILER=y
> CONFIG_NET_DSA_MV88E6XXX=y
> CONFIG_NET_DSA_MV88E6060=y
> # CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
> # CONFIG_NET_DSA_MV88E6131 is not set
> CONFIG_NET_DSA_MV88E6123_61_65=y
> CONFIG_VLAN_8021Q=m
> CONFIG_VLAN_8021Q_GVRP=y
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_IPX=y
> CONFIG_IPX_INTERN=y
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> CONFIG_PHONET=y
> CONFIG_IEEE802154=m
> # CONFIG_NET_SCHED is not set
> CONFIG_DCB=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> CONFIG_AX25=y
> # CONFIG_AX25_DAMA_SLAVE is not set
> # CONFIG_NETROM is not set
> CONFIG_ROSE=m
> 
> #
> # AX.25 network device drivers
> #
> CONFIG_MKISS=y
> CONFIG_6PACK=y
> CONFIG_BPQETHER=m
> CONFIG_BAYCOM_SER_FDX=m
> CONFIG_BAYCOM_SER_HDX=y
> # CONFIG_BAYCOM_PAR is not set
> # CONFIG_BAYCOM_EPP is not set
> CONFIG_YAM=y
> CONFIG_CAN=y
> CONFIG_CAN_RAW=y
> CONFIG_CAN_BCM=m
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=m
> CONFIG_CAN_DEV=m
> CONFIG_CAN_CALC_BITTIMING=y
> CONFIG_CAN_MCP251X=m
> CONFIG_CAN_SJA1000=m
> CONFIG_CAN_SJA1000_PLATFORM=m
> CONFIG_CAN_EMS_PCI=m
> CONFIG_CAN_KVASER_PCI=m
> 
> #
> # CAN USB interfaces
> #
> CONFIG_CAN_EMS_USB=m
> CONFIG_CAN_DEBUG_DEVICES=y
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=m
> # CONFIG_IRNET is not set
> CONFIG_IRCOMM=y
> CONFIG_IRDA_ULTRA=y
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> # CONFIG_IRDA_FAST_RR is not set
> # CONFIG_IRDA_DEBUG is not set
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> # CONFIG_IRTTY_SIR is not set
> 
> #
> # Dongle support
> #
> CONFIG_KINGSUN_DONGLE=y
> CONFIG_KSDAZZLE_DONGLE=y
> # CONFIG_KS959_DONGLE is not set
> 
> #
> # FIR device drivers
> #
> CONFIG_USB_IRDA=y
> CONFIG_SIGMATEL_FIR=m
> CONFIG_NSC_FIR=m
> CONFIG_WINBOND_FIR=y
> CONFIG_TOSHIBA_FIR=y
> CONFIG_SMC_IRCC_FIR=m
> # CONFIG_ALI_FIR is not set
> CONFIG_VLSI_FIR=y
> # CONFIG_VIA_FIR is not set
> # CONFIG_MCS_FIR is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> # CONFIG_LIB80211 is not set
> 
> #
> # CFG80211 needs to be enabled for MAC80211
> #
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> CONFIG_DEVTMPFS=y
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_DEBUG_DRIVER=y
> CONFIG_DEBUG_DEVRES=y
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> CONFIG_PARPORT=m
> CONFIG_PARPORT_PC=m
> CONFIG_PARPORT_SERIAL=m
> CONFIG_PARPORT_PC_FIFO=y
> CONFIG_PARPORT_PC_SUPERIO=y
> CONFIG_PARPORT_PC_PCMCIA=m
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=m
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=m
> # CONFIG_PARIDE is not set
> CONFIG_BLK_CPQ_DA=y
> CONFIG_BLK_CPQ_CISS_DA=m
> CONFIG_CISS_SCSI_TAPE=y
> CONFIG_BLK_DEV_DAC960=y
> CONFIG_BLK_DEV_UMEM=m
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> 
> #
> # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> #
> CONFIG_BLK_DEV_NBD=m
> CONFIG_BLK_DEV_SX8=m
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=m
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_XIP=y
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_VIRTIO_BLK is not set
> CONFIG_BLK_DEV_HD=y
> CONFIG_MISC_DEVICES=y
> CONFIG_AD525X_DPOT=y
> # CONFIG_IBM_ASM is not set
> CONFIG_PHANTOM=y
> # CONFIG_SGI_IOC4 is not set
> CONFIG_TIFM_CORE=m
> CONFIG_TIFM_7XX1=m
> CONFIG_ICS932S401=m
> CONFIG_ENCLOSURE_SERVICES=m
> CONFIG_CS5535_MFGPT=y
> CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
> # CONFIG_HP_ILO is not set
> CONFIG_ISL29003=y
> # CONFIG_DS1682 is not set
> # CONFIG_TI_DAC7512 is not set
> CONFIG_C2PORT=m
> CONFIG_C2PORT_DURAMAR_2150=m
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=m
> # CONFIG_EEPROM_AT25 is not set
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=m
> CONFIG_CB710_CORE=y
> CONFIG_CB710_DEBUG=y
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> CONFIG_IWMC3200TOP=m
> CONFIG_IWMC3200TOP_DEBUG=y
> # CONFIG_IWMC3200TOP_DEBUGFS is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=y
> # CONFIG_SCSI_ENCLOSURE is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=m
> CONFIG_SCSI_FC_TGT_ATTRS=y
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> CONFIG_SCSI_SAS_HOST_SMP=y
> # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
> CONFIG_SCSI_SRP_ATTRS=y
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> # CONFIG_ATA_ACPI is not set
> # CONFIG_SATA_PMP is not set
> CONFIG_SATA_AHCI=y
> CONFIG_SATA_SIL24=m
> CONFIG_ATA_SFF=y
> # CONFIG_SATA_SVW is not set
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_MV is not set
> CONFIG_SATA_NV=y
> CONFIG_PDC_ADMA=m
> # CONFIG_SATA_QSTOR is not set
> CONFIG_SATA_PROMISE=m
> CONFIG_SATA_SX4=m
> CONFIG_SATA_SIL=m
> CONFIG_SATA_SIS=m
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> CONFIG_SATA_VITESSE=m
> CONFIG_SATA_INIC162X=y
> CONFIG_PATA_ALI=y
> CONFIG_PATA_AMD=y
> CONFIG_PATA_ARTOP=y
> # CONFIG_PATA_ATP867X is not set
> CONFIG_PATA_ATIIXP=m
> CONFIG_PATA_CMD640_PCI=m
> # CONFIG_PATA_CMD64X is not set
> CONFIG_PATA_CS5520=y
> CONFIG_PATA_CS5530=y
> CONFIG_PATA_CS5535=y
> CONFIG_PATA_CS5536=y
> CONFIG_PATA_CYPRESS=y
> CONFIG_PATA_EFAR=y
> CONFIG_ATA_GENERIC=m
> CONFIG_PATA_HPT366=m
> CONFIG_PATA_HPT37X=m
> # CONFIG_PATA_HPT3X2N is not set
> CONFIG_PATA_HPT3X3=m
> CONFIG_PATA_HPT3X3_DMA=y
> CONFIG_PATA_IT821X=m
> CONFIG_PATA_IT8213=m
> # CONFIG_PATA_JMICRON is not set
> CONFIG_PATA_TRIFLEX=y
> CONFIG_PATA_MARVELL=y
> CONFIG_PATA_MPIIX=y
> CONFIG_PATA_OLDPIIX=y
> CONFIG_PATA_NETCELL=y
> CONFIG_PATA_NINJA32=m
> # CONFIG_PATA_NS87410 is not set
> CONFIG_PATA_NS87415=y
> # CONFIG_PATA_OPTI is not set
> CONFIG_PATA_OPTIDMA=y
> CONFIG_PATA_PCMCIA=m
> CONFIG_PATA_PDC2027X=m
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> CONFIG_PATA_RZ1000=y
> CONFIG_PATA_SC1200=m
> CONFIG_PATA_SERVERWORKS=y
> CONFIG_PATA_SIL680=m
> CONFIG_PATA_SIS=m
> # CONFIG_PATA_TOSHIBA is not set
> CONFIG_PATA_VIA=y
> CONFIG_PATA_WINBOND=m
> CONFIG_PATA_SCH=y
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> # CONFIG_MD_AUTODETECT is not set
> CONFIG_MD_LINEAR=y
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=y
> CONFIG_MULTICORE_RAID456=y
> CONFIG_MD_RAID6_PQ=y
> CONFIG_ASYNC_RAID6_TEST=y
> CONFIG_MD_MULTIPATH=y
> CONFIG_MD_FAULTY=m
> # CONFIG_BLK_DEV_DM is not set
> CONFIG_FUSION=y
> # CONFIG_FUSION_SPI is not set
> CONFIG_FUSION_FC=m
> # CONFIG_FUSION_SAS is not set
> CONFIG_FUSION_MAX_SGE=128
> # CONFIG_FUSION_CTL is not set
> CONFIG_FUSION_LOGGING=y
> 
> #
> # IEEE 1394 (FireWire) support
> #
> 
> #
> # You can enable one or both FireWire driver stacks.
> #
> 
> #
> # The newer stack is recommended.
> #
> # CONFIG_FIREWIRE is not set
> CONFIG_IEEE1394=m
> CONFIG_IEEE1394_OHCI1394=m
> # CONFIG_IEEE1394_PCILYNX is not set
> CONFIG_IEEE1394_SBP2=m
> CONFIG_IEEE1394_SBP2_PHYS_DMA=y
> CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
> CONFIG_IEEE1394_ETH1394=m
> # CONFIG_IEEE1394_RAWIO is not set
> # CONFIG_IEEE1394_VIDEO1394 is not set
> CONFIG_IEEE1394_DV1394=m
> # CONFIG_IEEE1394_VERBOSEDEBUG is not set
> CONFIG_I2O=y
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> CONFIG_I2O_EXT_ADAPTEC=y
> CONFIG_I2O_EXT_ADAPTEC_DMA64=y
> # CONFIG_I2O_CONFIG is not set
> # CONFIG_I2O_BUS is not set
> CONFIG_I2O_BLOCK=m
> # CONFIG_I2O_SCSI is not set
> # CONFIG_I2O_PROC is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> CONFIG_NETDEVICES=y
> CONFIG_DUMMY=m
> CONFIG_BONDING=m
> CONFIG_MACVLAN=y
> CONFIG_EQUALIZER=y
> # CONFIG_TUN is not set
> CONFIG_VETH=y
> CONFIG_NET_SB1000=y
> # CONFIG_ARCNET is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=m
> # CONFIG_CICADA_PHY is not set
> CONFIG_VITESSE_PHY=m
> CONFIG_SMSC_PHY=y
> CONFIG_BROADCOM_PHY=y
> CONFIG_ICPLUS_PHY=m
> # CONFIG_REALTEK_PHY is not set
> CONFIG_NATIONAL_PHY=m
> CONFIG_STE10XP=y
> # CONFIG_LSI_ET1011C_PHY is not set
> CONFIG_FIXED_PHY=y
> # CONFIG_MDIO_BITBANG is not set
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> CONFIG_NET_VENDOR_SMC=y
> CONFIG_ULTRAMCA=m
> CONFIG_ENC28J60=y
> CONFIG_ENC28J60_WRITEVERIFY=y
> CONFIG_ETHOC=y
> CONFIG_DNET=y
> CONFIG_NET_TULIP=y
> # CONFIG_DE2104X is not set
> CONFIG_TULIP=m
> CONFIG_TULIP_MWI=y
> CONFIG_TULIP_MMIO=y
> CONFIG_TULIP_NAPI=y
> CONFIG_TULIP_NAPI_HW_MITIGATION=y
> CONFIG_DE4X5=m
> CONFIG_WINBOND_840=m
> CONFIG_DM9102=y
> CONFIG_ULI526X=m
> # CONFIG_PCMCIA_XIRCOM is not set
> CONFIG_AT1700=y
> # CONFIG_DEPCA is not set
> # CONFIG_HP100 is not set
> CONFIG_NE2_MCA=m
> CONFIG_IBMLANA=y
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
> # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
> # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
> CONFIG_NET_PCI=y
> CONFIG_PCNET32=m
> CONFIG_AMD8111_ETH=y
> # CONFIG_ADAPTEC_STARFIRE is not set
> CONFIG_B44=m
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> CONFIG_FORCEDETH=y
> CONFIG_FORCEDETH_NAPI=y
> CONFIG_E100=y
> CONFIG_FEALNX=m
> CONFIG_NATSEMI=m
> CONFIG_NE2K_PCI=y
> CONFIG_8139CP=m
> CONFIG_8139TOO=y
> # CONFIG_8139TOO_PIO is not set
> CONFIG_8139TOO_TUNE_TWISTER=y
> CONFIG_8139TOO_8129=y
> CONFIG_8139_OLD_RX_RESET=y
> CONFIG_R6040=y
> # CONFIG_SIS900 is not set
> CONFIG_EPIC100=m
> # CONFIG_SMSC9420 is not set
> # CONFIG_SUNDANCE is not set
> CONFIG_TLAN=m
> # CONFIG_KS8842 is not set
> CONFIG_KS8851=y
> CONFIG_KS8851_MLL=y
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> # CONFIG_NET_POCKET is not set
> CONFIG_ATL2=m
> CONFIG_NETDEV_1000=y
> CONFIG_ACENIC=y
> CONFIG_ACENIC_OMIT_TIGON_I=y
> CONFIG_DL2K=m
> CONFIG_E1000=m
> CONFIG_E1000E=y
> CONFIG_IP1000=m
> CONFIG_IGB=m
> CONFIG_IGB_DCA=y
> CONFIG_IGBVF=y
> CONFIG_NS83820=y
> CONFIG_HAMACHI=y
> CONFIG_YELLOWFIN=y
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> CONFIG_SKGE=y
> CONFIG_SKGE_DEBUG=y
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> CONFIG_TIGON3=y
> CONFIG_BNX2=y
> # CONFIG_CNIC is not set
> CONFIG_QLA3XXX=y
> CONFIG_ATL1=y
> CONFIG_ATL1E=m
> CONFIG_ATL1C=y
> # CONFIG_JME is not set
> CONFIG_NETDEV_10000=y
> CONFIG_MDIO=y
> CONFIG_CHELSIO_T1=m
> CONFIG_CHELSIO_T1_1G=y
> CONFIG_CHELSIO_T3_DEPENDS=y
> CONFIG_CHELSIO_T3=m
> # CONFIG_ENIC is not set
> CONFIG_IXGBE=y
> CONFIG_IXGBE_DCB=y
> CONFIG_IXGB=y
> CONFIG_S2IO=m
> CONFIG_MYRI10GE=y
> CONFIG_NIU=m
> CONFIG_MLX4_EN=y
> CONFIG_MLX4_CORE=y
> CONFIG_MLX4_DEBUG=y
> CONFIG_TEHUTI=m
> CONFIG_BNX2X=m
> CONFIG_QLGE=y
> CONFIG_SFC=y
> # CONFIG_BE2NET is not set
> # CONFIG_TR is not set
> # CONFIG_WLAN is not set
> 
> #
> # WiMAX Wireless Broadband devices
> #
> CONFIG_WIMAX_I2400M=m
> CONFIG_WIMAX_I2400M_SDIO=m
> CONFIG_WIMAX_IWMC3200_SDIO=y
> CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
> 
> #
> # USB Network Adapters
> #
> CONFIG_USB_CATC=y
> # CONFIG_USB_KAWETH is not set
> CONFIG_USB_PEGASUS=m
> CONFIG_USB_RTL8150=m
> CONFIG_USB_USBNET=m
> CONFIG_USB_NET_AX8817X=m
> CONFIG_USB_NET_CDCETHER=m
> CONFIG_USB_NET_CDC_EEM=m
> # CONFIG_USB_NET_DM9601 is not set
> CONFIG_USB_NET_SMSC95XX=m
> CONFIG_USB_NET_GL620A=m
> CONFIG_USB_NET_NET1080=m
> # CONFIG_USB_NET_PLUSB is not set
> # CONFIG_USB_NET_MCS7830 is not set
> CONFIG_USB_NET_RNDIS_HOST=m
> CONFIG_USB_NET_CDC_SUBSET=m
> CONFIG_USB_ALI_M5632=y
> # CONFIG_USB_AN2720 is not set
> # CONFIG_USB_BELKIN is not set
> CONFIG_USB_ARMLINUX=y
> # CONFIG_USB_EPSON2888 is not set
> # CONFIG_USB_KC2190 is not set
> # CONFIG_USB_NET_ZAURUS is not set
> CONFIG_USB_HSO=y
> CONFIG_USB_NET_INT51X1=m
> # CONFIG_USB_CDC_PHONET is not set
> CONFIG_NET_PCMCIA=y
> CONFIG_PCMCIA_3C589=m
> # CONFIG_PCMCIA_3C574 is not set
> # CONFIG_PCMCIA_FMVJ18X is not set
> # CONFIG_PCMCIA_PCNET is not set
> CONFIG_PCMCIA_NMCLAN=m
> CONFIG_PCMCIA_SMC91C92=m
> CONFIG_PCMCIA_XIRC2PS=m
> CONFIG_PCMCIA_AXNET=m
> CONFIG_WAN=y
> # CONFIG_HDLC is not set
> # CONFIG_DLCI is not set
> # CONFIG_SBNI is not set
> CONFIG_ATM_DRIVERS=y
> # CONFIG_ATM_DUMMY is not set
> # CONFIG_ATM_TCP is not set
> CONFIG_ATM_LANAI=m
> CONFIG_ATM_ENI=m
> # CONFIG_ATM_ENI_DEBUG is not set
> # CONFIG_ATM_ENI_TUNE_BURST is not set
> # CONFIG_ATM_FIRESTREAM is not set
> CONFIG_ATM_ZATM=m
> # CONFIG_ATM_ZATM_DEBUG is not set
> # CONFIG_ATM_NICSTAR is not set
> # CONFIG_ATM_IDT77252 is not set
> # CONFIG_ATM_AMBASSADOR is not set
> CONFIG_ATM_HORIZON=m
> CONFIG_ATM_HORIZON_DEBUG=y
> # CONFIG_ATM_IA is not set
> # CONFIG_ATM_FORE200E is not set
> # CONFIG_ATM_HE is not set
> CONFIG_ATM_SOLOS=m
> CONFIG_IEEE802154_DRIVERS=m
> # CONFIG_IEEE802154_FAKEHARD is not set
> CONFIG_FDDI=m
> CONFIG_DEFXX=m
> CONFIG_DEFXX_MMIO=y
> # CONFIG_SKFP is not set
> CONFIG_HIPPI=y
> CONFIG_ROADRUNNER=y
> CONFIG_ROADRUNNER_LARGE_RINGS=y
> CONFIG_PLIP=m
> CONFIG_PPP=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> # CONFIG_PPP_DEFLATE is not set
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_MPPE=m
> # CONFIG_PPPOE is not set
> CONFIG_PPPOATM=m
> CONFIG_PPPOL2TP=m
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
> # CONFIG_NET_FC is not set
> CONFIG_NETCONSOLE=y
> # CONFIG_NETCONSOLE_DYNAMIC is not set
> CONFIG_NETPOLL=y
> CONFIG_NETPOLL_TRAP=y
> CONFIG_NET_POLL_CONTROLLER=y
> # CONFIG_VIRTIO_NET is not set
> # CONFIG_VMXNET3 is not set
> CONFIG_ISDN=y
> CONFIG_ISDN_I4L=y
> CONFIG_ISDN_PPP=y
> # CONFIG_ISDN_PPP_VJ is not set
> CONFIG_ISDN_MPP=y
> # CONFIG_IPPP_FILTER is not set
> CONFIG_ISDN_PPP_BSDCOMP=y
> CONFIG_ISDN_AUDIO=y
> # CONFIG_ISDN_TTY_FAX is not set
> 
> #
> # ISDN feature submodules
> #
> CONFIG_ISDN_DIVERSION=y
> 
> #
> # ISDN4Linux hardware drivers
> #
> 
> #
> # Passive cards
> #
> CONFIG_ISDN_DRV_HISAX=y
> 
> #
> # D-channel protocol features
> #
> CONFIG_HISAX_EURO=y
> CONFIG_DE_AOC=y
> CONFIG_HISAX_NO_SENDCOMPLETE=y
> # CONFIG_HISAX_NO_LLC is not set
> CONFIG_HISAX_NO_KEYPAD=y
> CONFIG_HISAX_1TR6=y
> CONFIG_HISAX_NI1=y
> CONFIG_HISAX_MAX_CARDS=8
> 
> #
> # HiSax supported cards
> #
> # CONFIG_HISAX_16_3 is not set
> CONFIG_HISAX_S0BOX=y
> CONFIG_HISAX_FRITZPCI=y
> CONFIG_HISAX_AVM_A1_PCMCIA=y
> CONFIG_HISAX_ELSA=y
> CONFIG_HISAX_DIEHLDIVA=y
> CONFIG_HISAX_SEDLBAUER=y
> # CONFIG_HISAX_NICCY is not set
> CONFIG_HISAX_GAZEL=y
> # CONFIG_HISAX_HFC_SX is not set
> CONFIG_HISAX_DEBUG=y
> 
> #
> # HiSax PCMCIA card service modules
> #
> CONFIG_HISAX_SEDLBAUER_CS=m
> CONFIG_HISAX_ELSA_CS=m
> CONFIG_HISAX_AVM_A1_CS=m
> 
> #
> # HiSax sub driver modules
> #
> CONFIG_HISAX_ST5481=m
> # CONFIG_HISAX_HFCUSB is not set
> CONFIG_HISAX_HFC4S8S=y
> 
> #
> # Active cards
> #
> CONFIG_HYSDN=m
> CONFIG_HYSDN_CAPI=y
> CONFIG_ISDN_HDLC=m
> CONFIG_ISDN_CAPI=y
> # CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
> # CONFIG_CAPI_TRACE is not set
> # CONFIG_ISDN_CAPI_MIDDLEWARE is not set
> CONFIG_ISDN_CAPI_CAPI20=m
> # CONFIG_ISDN_CAPI_CAPIDRV is not set
> 
> #
> # CAPI hardware drivers
> #
> # CONFIG_CAPI_AVM is not set
> CONFIG_CAPI_EICON=y
> CONFIG_ISDN_DIVAS=m
> # CONFIG_ISDN_DIVAS_BRIPCI is not set
> CONFIG_ISDN_DIVAS_PRIPCI=y
> CONFIG_ISDN_DIVAS_DIVACAPI=m
> CONFIG_ISDN_DIVAS_USERIDI=m
> CONFIG_ISDN_DIVAS_MAINT=m
> CONFIG_ISDN_DRV_GIGASET=y
> CONFIG_GIGASET_CAPI=y
> # CONFIG_GIGASET_I4L is not set
> # CONFIG_GIGASET_DUMMYLL is not set
> # CONFIG_GIGASET_BASE is not set
> CONFIG_GIGASET_M105=y
> # CONFIG_GIGASET_M101 is not set
> CONFIG_GIGASET_DEBUG=y
> CONFIG_PHONE=y
> CONFIG_PHONE_IXJ=y
> CONFIG_PHONE_IXJ_PCMCIA=m
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=m
> CONFIG_INPUT_EVDEV=y
> CONFIG_INPUT_EVBUG=m
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5520=m
> # CONFIG_KEYBOARD_ADP5588 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_QT2160 is not set
> CONFIG_KEYBOARD_LKKBD=m
> # CONFIG_KEYBOARD_GPIO is not set
> CONFIG_KEYBOARD_MATRIX=m
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> CONFIG_KEYBOARD_NEWTON=m
> # CONFIG_KEYBOARD_OPENCORES is not set
> CONFIG_KEYBOARD_STOWAWAY=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> CONFIG_KEYBOARD_TWL4030=m
> CONFIG_KEYBOARD_XTKBD=y
> # CONFIG_INPUT_MOUSE is not set
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=m
> # CONFIG_JOYSTICK_A3D is not set
> # CONFIG_JOYSTICK_ADI is not set
> CONFIG_JOYSTICK_COBRA=y
> CONFIG_JOYSTICK_GF2K=m
> CONFIG_JOYSTICK_GRIP=m
> CONFIG_JOYSTICK_GRIP_MP=y
> CONFIG_JOYSTICK_GUILLEMOT=y
> # CONFIG_JOYSTICK_INTERACT is not set
> # CONFIG_JOYSTICK_SIDEWINDER is not set
> CONFIG_JOYSTICK_TMDC=m
> # CONFIG_JOYSTICK_IFORCE is not set
> # CONFIG_JOYSTICK_WARRIOR is not set
> # CONFIG_JOYSTICK_MAGELLAN is not set
> CONFIG_JOYSTICK_SPACEORB=y
> # CONFIG_JOYSTICK_SPACEBALL is not set
> # CONFIG_JOYSTICK_STINGER is not set
> CONFIG_JOYSTICK_TWIDJOY=m
> # CONFIG_JOYSTICK_ZHENHUA is not set
> CONFIG_JOYSTICK_DB9=m
> CONFIG_JOYSTICK_GAMECON=m
> CONFIG_JOYSTICK_TURBOGRAFX=m
> CONFIG_JOYSTICK_JOYDUMP=y
> CONFIG_JOYSTICK_XPAD=m
> # CONFIG_JOYSTICK_XPAD_FF is not set
> # CONFIG_JOYSTICK_XPAD_LEDS is not set
> CONFIG_JOYSTICK_WALKERA0701=m
> CONFIG_INPUT_TABLET=y
> CONFIG_TABLET_USB_ACECAD=m
> # CONFIG_TABLET_USB_AIPTEK is not set
> CONFIG_TABLET_USB_GTCO=y
> # CONFIG_TABLET_USB_KBTAB is not set
> CONFIG_TABLET_USB_WACOM=m
> CONFIG_INPUT_TOUCHSCREEN=y
> # CONFIG_TOUCHSCREEN_ADS7846 is not set
> # CONFIG_TOUCHSCREEN_AD7877 is not set
> CONFIG_TOUCHSCREEN_AD7879_I2C=m
> CONFIG_TOUCHSCREEN_AD7879=m
> CONFIG_TOUCHSCREEN_DA9034=m
> # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> # CONFIG_TOUCHSCREEN_EETI is not set
> CONFIG_TOUCHSCREEN_FUJITSU=m
> CONFIG_TOUCHSCREEN_GUNZE=y
> CONFIG_TOUCHSCREEN_ELO=m
> # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> CONFIG_TOUCHSCREEN_MTOUCH=m
> CONFIG_TOUCHSCREEN_INEXIO=y
> CONFIG_TOUCHSCREEN_MK712=m
> # CONFIG_TOUCHSCREEN_PENMOUNT is not set
> # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
> # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
> CONFIG_TOUCHSCREEN_UCB1400=m
> CONFIG_TOUCHSCREEN_WM97XX=m
> CONFIG_TOUCHSCREEN_WM9705=y
> CONFIG_TOUCHSCREEN_WM9712=y
> # CONFIG_TOUCHSCREEN_WM9713 is not set
> CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
> CONFIG_TOUCHSCREEN_USB_EGALAX=y
> CONFIG_TOUCHSCREEN_USB_PANJIT=y
> CONFIG_TOUCHSCREEN_USB_3M=y
> CONFIG_TOUCHSCREEN_USB_ITM=y
> CONFIG_TOUCHSCREEN_USB_ETURBO=y
> CONFIG_TOUCHSCREEN_USB_GUNZE=y
> CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
> CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
> CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
> CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
> CONFIG_TOUCHSCREEN_USB_GOTOP=y
> CONFIG_TOUCHSCREEN_USB_JASTEC=y
> # CONFIG_TOUCHSCREEN_USB_E2I is not set
> CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
> CONFIG_TOUCHSCREEN_USB_ETT_TC5UH=y
> CONFIG_TOUCHSCREEN_TOUCHIT213=y
> CONFIG_TOUCHSCREEN_TSC2007=y
> CONFIG_TOUCHSCREEN_PCAP=y
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_PCSPKR=m
> CONFIG_INPUT_APANEL=m
> CONFIG_INPUT_WISTRON_BTNS=m
> CONFIG_INPUT_ATLAS_BTNS=m
> CONFIG_INPUT_ATI_REMOTE=y
> CONFIG_INPUT_ATI_REMOTE2=y
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> CONFIG_INPUT_POWERMATE=m
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_TWL4030_PWRBUTTON=m
> CONFIG_INPUT_UINPUT=y
> CONFIG_INPUT_WINBOND_CIR=y
> # CONFIG_INPUT_PCF50633_PMU is not set
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
> CONFIG_INPUT_WM831X_ON=y
> CONFIG_INPUT_PCAP=m
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> CONFIG_SERIO_CT82C710=m
> CONFIG_SERIO_PARKBD=m
> CONFIG_SERIO_PCIPS2=m
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_GAMEPORT=y
> # CONFIG_GAMEPORT_NS558 is not set
> CONFIG_GAMEPORT_L4=m
> CONFIG_GAMEPORT_EMU10K1=m
> CONFIG_GAMEPORT_FM801=y
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_DEVKMEM=y
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_COMPUTONE=y
> CONFIG_ROCKETPORT=m
> CONFIG_CYCLADES=m
> CONFIG_CYZ_INTR=y
> # CONFIG_DIGIEPCA is not set
> # CONFIG_MOXA_INTELLIO is not set
> # CONFIG_MOXA_SMARTIO is not set
> CONFIG_ISI=m
> # CONFIG_SYNCLINK is not set
> CONFIG_SYNCLINKMP=y
> CONFIG_SYNCLINK_GT=y
> # CONFIG_N_HDLC is not set
> CONFIG_RISCOM8=m
> # CONFIG_SPECIALIX is not set
> CONFIG_STALDRV=y
> # CONFIG_STALLION is not set
> # CONFIG_ISTALLION is not set
> CONFIG_NOZOMI=m
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CS=m
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_MCA is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MAX3100=m
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_PRINTER is not set
> CONFIG_PPDEV=m
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_IPMI_HANDLER=y
> CONFIG_IPMI_PANIC_EVENT=y
> # CONFIG_IPMI_PANIC_STRING is not set
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=y
> CONFIG_HW_RANDOM=m
> CONFIG_HW_RANDOM_TIMERIOMEM=m
> # CONFIG_HW_RANDOM_INTEL is not set
> CONFIG_HW_RANDOM_AMD=m
> CONFIG_HW_RANDOM_GEODE=m
> # CONFIG_HW_RANDOM_VIA is not set
> # CONFIG_HW_RANDOM_VIRTIO is not set
> CONFIG_NVRAM=m
> CONFIG_R3964=m
> CONFIG_APPLICOM=y
> CONFIG_SONYPI=y
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=m
> # CONFIG_CARDMAN_4000 is not set
> # CONFIG_CARDMAN_4040 is not set
> CONFIG_IPWIRELESS=m
> CONFIG_MWAVE=m
> CONFIG_PC8736x_GPIO=m
> CONFIG_NSC_GPIO=m
> # CONFIG_CS5535_GPIO is not set
> CONFIG_RAW_DRIVER=m
> CONFIG_MAX_RAW_DEVS=256
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> # CONFIG_HANGCHECK_TIMER is not set
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> # CONFIG_TCG_NSC is not set
> # CONFIG_TCG_ATMEL is not set
> # CONFIG_TCG_INFINEON is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=y
> CONFIG_I2C_ALI1563=m
> CONFIG_I2C_ALI15X3=y
> CONFIG_I2C_AMD756=m
> CONFIG_I2C_AMD8111=m
> CONFIG_I2C_I801=m
> CONFIG_I2C_ISCH=y
> CONFIG_I2C_PIIX4=m
> # CONFIG_I2C_NFORCE2 is not set
> CONFIG_I2C_SIS5595=m
> CONFIG_I2C_SIS630=y
> CONFIG_I2C_SIS96X=y
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
> 
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=y
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_GPIO=m
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_SIMTEC is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=m
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> CONFIG_I2C_TINY_USB=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_STUB is not set
> CONFIG_SCx200_ACB=m
> 
> #
> # Miscellaneous I2C Chip support
> #
> # CONFIG_SENSORS_TSL2550 is not set
> CONFIG_I2C_DEBUG_CORE=y
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_BITBANG=m
> CONFIG_SPI_BUTTERFLY=m
> # CONFIG_SPI_GPIO is not set
> # CONFIG_SPI_LM70_LLP is not set
> # CONFIG_SPI_XILINX is not set
> # CONFIG_SPI_DESIGNWARE is not set
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> # CONFIG_SPI_TLE62X0 is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> # CONFIG_DEBUG_GPIO is not set
> # CONFIG_GPIO_SYSFS is not set
> 
> #
> # Memory mapped GPIO expanders:
> #
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCA953X is not set
> # CONFIG_GPIO_PCF857X is not set
> CONFIG_GPIO_TWL4030=m
> # CONFIG_GPIO_WM831X is not set
> CONFIG_GPIO_ADP5520=y
> CONFIG_GPIO_ADP5588=y
> 
> #
> # PCI GPIO expanders:
> #
> CONFIG_GPIO_CS5535=m
> # CONFIG_GPIO_BT8XX is not set
> CONFIG_GPIO_LANGWELL=y
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> # CONFIG_GPIO_MCP23S08 is not set
> # CONFIG_GPIO_MC33880 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> # CONFIG_GPIO_UCB1400 is not set
> CONFIG_W1=y
> 
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=y
> # CONFIG_W1_MASTER_DS2490 is not set
> CONFIG_W1_MASTER_DS2482=y
> # CONFIG_W1_MASTER_GPIO is not set
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> CONFIG_W1_SLAVE_SMEM=m
> CONFIG_W1_SLAVE_DS2431=y
> CONFIG_W1_SLAVE_DS2433=m
> CONFIG_W1_SLAVE_DS2433_CRC=y
> CONFIG_W1_SLAVE_DS2760=y
> CONFIG_W1_SLAVE_BQ27000=m
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> # CONFIG_PDA_POWER is not set
> CONFIG_WM831X_BACKUP=m
> CONFIG_WM831X_POWER=m
> CONFIG_BATTERY_DS2760=y
> CONFIG_BATTERY_DS2782=y
> CONFIG_BATTERY_OLPC=m
> CONFIG_BATTERY_BQ27x00=m
> # CONFIG_BATTERY_DA9030 is not set
> CONFIG_BATTERY_MAX17040=y
> CONFIG_CHARGER_PCF50633=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> CONFIG_HWMON_DEBUG_CHIP=y
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> CONFIG_SENSORS_AD7414=m
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADCXX is not set
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=y
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7462=m
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7473=y
> CONFIG_SENSORS_ADT7475=y
> CONFIG_SENSORS_K8TEMP=y
> # CONFIG_SENSORS_K10TEMP is not set
> CONFIG_SENSORS_ASB100=y
> CONFIG_SENSORS_ATXP1=m
> CONFIG_SENSORS_DS1621=m
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=m
> # CONFIG_SENSORS_F71882FG is not set
> CONFIG_SENSORS_F75375S=m
> CONFIG_SENSORS_FSCHMD=m
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_GL518SM=y
> # CONFIG_SENSORS_GL520SM is not set
> CONFIG_SENSORS_CORETEMP=m
> CONFIG_SENSORS_IBMAEM=y
> CONFIG_SENSORS_IBMPEX=y
> CONFIG_SENSORS_IT87=m
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM70 is not set
> # CONFIG_SENSORS_LM73 is not set
> # CONFIG_SENSORS_LM75 is not set
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=m
> CONFIG_SENSORS_LM87=m
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4245=m
> CONFIG_SENSORS_LM95241=m
> # CONFIG_SENSORS_MAX1111 is not set
> CONFIG_SENSORS_MAX1619=m
> # CONFIG_SENSORS_MAX6650 is not set
> CONFIG_SENSORS_PC87360=y
> CONFIG_SENSORS_PC87427=m
> CONFIG_SENSORS_PCF8591=y
> # CONFIG_SENSORS_SHT15 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> CONFIG_SENSORS_DME1737=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_THMC50=m
> CONFIG_SENSORS_TMP401=m
> CONFIG_SENSORS_TMP421=m
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> CONFIG_SENSORS_VT8231=y
> # CONFIG_SENSORS_W83781D is not set
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83L785TS=m
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> CONFIG_SENSORS_WM831X=m
> # CONFIG_SENSORS_HDAPS is not set
> CONFIG_SENSORS_LIS3_I2C=m
> CONFIG_SENSORS_APPLESMC=y
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ATK0110=y
> # CONFIG_SENSORS_LIS3LV02D is not set
> CONFIG_THERMAL=y
> # CONFIG_THERMAL_HWMON is not set
> CONFIG_WATCHDOG=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=y
> # CONFIG_WM831X_WATCHDOG is not set
> CONFIG_TWL4030_WATCHDOG=m
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=m
> CONFIG_ALIM1535_WDT=m
> CONFIG_ALIM7101_WDT=m
> CONFIG_GEODE_WDT=y
> CONFIG_SC520_WDT=y
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> # CONFIG_IBMASR is not set
> # CONFIG_WAFER_WDT is not set
> # CONFIG_I6300ESB_WDT is not set
> CONFIG_ITCO_WDT=m
> CONFIG_ITCO_VENDOR_SUPPORT=y
> # CONFIG_IT8712F_WDT is not set
> CONFIG_IT87_WDT=y
> # CONFIG_HP_WATCHDOG is not set
> # CONFIG_SC1200_WDT is not set
> CONFIG_PC87413_WDT=m
> # CONFIG_RDC321X_WDT is not set
> # CONFIG_60XX_WDT is not set
> # CONFIG_SBC8360_WDT is not set
> CONFIG_SBC7240_WDT=m
> CONFIG_CPU5_WDT=m
> CONFIG_SMSC_SCH311X_WDT=y
> CONFIG_SMSC37B787_WDT=y
> CONFIG_W83627HF_WDT=m
> # CONFIG_W83697HF_WDT is not set
> # CONFIG_W83697UG_WDT is not set
> CONFIG_W83877F_WDT=y
> # CONFIG_W83977F_WDT is not set
> CONFIG_MACHZ_WDT=y
> CONFIG_SBC_EPX_C3_WATCHDOG=y
> 
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=m
> CONFIG_WDTPCI=m
> 
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=m
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> CONFIG_SSB_PCMCIAHOST=y
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> CONFIG_HTC_PASIC3=y
> CONFIG_UCB1400_CORE=m
> # CONFIG_TPS65010 is not set
> CONFIG_TWL4030_CORE=y
> CONFIG_TWL4030_CODEC=y
> # CONFIG_MFD_TMIO is not set
> CONFIG_PMIC_DA903X=y
> CONFIG_PMIC_ADP5520=y
> # CONFIG_MFD_WM8400 is not set
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_PCF50633=y
> # CONFIG_MFD_MC13783 is not set
> CONFIG_PCF50633_ADC=m
> CONFIG_PCF50633_GPIO=y
> # CONFIG_AB3100_CORE is not set
> CONFIG_EZX_PCAP=y
> CONFIG_MFD_88PM8607=y
> CONFIG_AB4500_CORE=y
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> CONFIG_REGULATOR_USERSPACE_CONSUMER=m
> # CONFIG_REGULATOR_BQ24022 is not set
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8660=y
> # CONFIG_REGULATOR_TWL4030 is not set
> CONFIG_REGULATOR_WM831X=y
> CONFIG_REGULATOR_DA903X=m
> # CONFIG_REGULATOR_PCF50633 is not set
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_PCAP is not set
> # CONFIG_REGULATOR_TPS65023 is not set
> # CONFIG_REGULATOR_TPS6507X is not set
> CONFIG_REGULATOR_88PM8607=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_TTM=y
> CONFIG_DRM_TDFX=m
> CONFIG_DRM_R128=m
> CONFIG_DRM_RADEON=y
> # CONFIG_DRM_MGA is not set
> CONFIG_DRM_VIA=y
> CONFIG_DRM_SAVAGE=y
> CONFIG_VGASTATE=y
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
> CONFIG_FB_DDC=m
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> CONFIG_FB_FOREIGN_ENDIAN=y
> # CONFIG_FB_BOTH_ENDIAN is not set
> # CONFIG_FB_BIG_ENDIAN is not set
> CONFIG_FB_LITTLE_ENDIAN=y
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> CONFIG_FB_PM2=y
> CONFIG_FB_PM2_FIFO_DISCONNECT=y
> CONFIG_FB_CYBER2000=m
> CONFIG_FB_ARC=y
> # CONFIG_FB_ASILIANT is not set
> CONFIG_FB_IMSTT=y
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=y
> CONFIG_FB_HGA_ACCEL=y
> CONFIG_FB_S1D13XXX=y
> # CONFIG_FB_NVIDIA is not set
> CONFIG_FB_RIVA=m
> CONFIG_FB_RIVA_I2C=y
> CONFIG_FB_RIVA_DEBUG=y
> CONFIG_FB_RIVA_BACKLIGHT=y
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> CONFIG_FB_ATY128=m
> # CONFIG_FB_ATY128_BACKLIGHT is not set
> CONFIG_FB_ATY=y
> CONFIG_FB_ATY_CT=y
> # CONFIG_FB_ATY_GENERIC_LCD is not set
> CONFIG_FB_ATY_GX=y
> CONFIG_FB_ATY_BACKLIGHT=y
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> CONFIG_FB_VIA=y
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> CONFIG_FB_3DFX=m
> CONFIG_FB_3DFX_ACCEL=y
> CONFIG_FB_3DFX_I2C=y
> CONFIG_FB_VOODOO1=y
> CONFIG_FB_VT8623=y
> CONFIG_FB_TRIDENT=y
> CONFIG_FB_ARK=y
> CONFIG_FB_PM3=y
> CONFIG_FB_CARMINE=y
> # CONFIG_FB_CARMINE_DRAM_EVAL is not set
> CONFIG_CARMINE_DRAM_CUSTOM=y
> # CONFIG_FB_GEODE is not set
> CONFIG_FB_TMIO=y
> CONFIG_FB_TMIO_ACCELL=y
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_FB_METRONOME=m
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> CONFIG_LCD_LMS283GF05=m
> # CONFIG_LCD_LTV350QV is not set
> CONFIG_LCD_ILI9320=m
> CONFIG_LCD_TDO24M=m
> CONFIG_LCD_VGG2432A4=m
> CONFIG_LCD_PLATFORM=m
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> # CONFIG_BACKLIGHT_PROGEAR is not set
> # CONFIG_BACKLIGHT_DA903X is not set
> # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
> CONFIG_BACKLIGHT_SAHARA=m
> # CONFIG_BACKLIGHT_WM831X is not set
> CONFIG_BACKLIGHT_ADP5520=m
> 
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> CONFIG_FONTS=y
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> CONFIG_FONT_6x11=y
> CONFIG_FONT_7x14=y
> CONFIG_FONT_PEARL_8x8=y
> # CONFIG_FONT_ACORN_8x8 is not set
> CONFIG_FONT_MINI_4x6=y
> # CONFIG_FONT_SUN8x16 is not set
> # CONFIG_FONT_SUN12x22 is not set
> # CONFIG_FONT_10x18 is not set
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> CONFIG_LOGO_LINUX_VGA16=y
> # CONFIG_LOGO_LINUX_CLUT224 is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_JACK=y
> CONFIG_SND_SEQUENCER=m
> # CONFIG_SND_SEQ_DUMMY is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> # CONFIG_SND_PCM_OSS is not set
> CONFIG_SND_SEQUENCER_OSS=y
> CONFIG_SND_HRTIMER=m
> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> CONFIG_SND_DYNAMIC_MINORS=y
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PROCFS=y
> CONFIG_SND_VERBOSE_PRINTK=y
> CONFIG_SND_DEBUG=y
> CONFIG_SND_DEBUG_VERBOSE=y
> CONFIG_SND_PCM_XRUN_DEBUG=y
> CONFIG_SND_VMASTER=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=m
> CONFIG_SND_OPL3_LIB_SEQ=m
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> CONFIG_SND_EMU10K1_SEQ=m
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_OPL3_LIB=m
> CONFIG_SND_VX_LIB=m
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_PCSP=m
> CONFIG_SND_DUMMY=m
> # CONFIG_SND_VIRMIDI is not set
> # CONFIG_SND_MTS64 is not set
> CONFIG_SND_SERIAL_U16550=m
> CONFIG_SND_MPU401=m
> CONFIG_SND_PORTMAN2X4=m
> CONFIG_SND_AC97_POWER_SAVE=y
> CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
> CONFIG_SND_SB_COMMON=m
> CONFIG_SND_SB16_DSP=m
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> CONFIG_SND_ALS300=m
> CONFIG_SND_ALS4000=m
> # CONFIG_SND_ALI5451 is not set
> CONFIG_SND_ATIIXP=m
> CONFIG_SND_ATIIXP_MODEM=m
> CONFIG_SND_AU8810=m
> CONFIG_SND_AU8820=m
> CONFIG_SND_AU8830=m
> # CONFIG_SND_AW2 is not set
> CONFIG_SND_AZT3328=m
> CONFIG_SND_BT87X=m
> CONFIG_SND_BT87X_OVERCLOCK=y
> CONFIG_SND_CA0106=m
> # CONFIG_SND_CMIPCI is not set
> CONFIG_SND_OXYGEN_LIB=m
> CONFIG_SND_OXYGEN=m
> CONFIG_SND_CS4281=m
> # CONFIG_SND_CS46XX is not set
> CONFIG_SND_CS5530=m
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> CONFIG_SND_DARLA20=m
> # CONFIG_SND_GINA20 is not set
> CONFIG_SND_LAYLA20=m
> # CONFIG_SND_DARLA24 is not set
> CONFIG_SND_GINA24=m
> CONFIG_SND_LAYLA24=m
> CONFIG_SND_MONA=m
> CONFIG_SND_MIA=m
> # CONFIG_SND_ECHO3G is not set
> CONFIG_SND_INDIGO=m
> CONFIG_SND_INDIGOIO=m
> CONFIG_SND_INDIGODJ=m
> # CONFIG_SND_INDIGOIOX is not set
> CONFIG_SND_INDIGODJX=m
> CONFIG_SND_EMU10K1=m
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> CONFIG_SND_ENS1371=m
> CONFIG_SND_ES1938=m
> CONFIG_SND_ES1968=m
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> # CONFIG_SND_HDA_HWDEP is not set
> CONFIG_SND_HDA_INPUT_BEEP=y
> CONFIG_SND_HDA_INPUT_BEEP_MODE=1
> # CONFIG_SND_HDA_INPUT_JACK is not set
> # CONFIG_SND_HDA_PATCH_LOADER is not set
> CONFIG_SND_HDA_CODEC_REALTEK=y
> CONFIG_SND_HDA_CODEC_ANALOG=y
> CONFIG_SND_HDA_CODEC_SIGMATEL=y
> CONFIG_SND_HDA_CODEC_VIA=y
> CONFIG_SND_HDA_CODEC_ATIHDMI=y
> CONFIG_SND_HDA_CODEC_NVHDMI=y
> # CONFIG_SND_HDA_CODEC_INTELHDMI is not set
> # CONFIG_SND_HDA_CODEC_CIRRUS is not set
> # CONFIG_SND_HDA_CODEC_CONEXANT is not set
> # CONFIG_SND_HDA_CODEC_CA0110 is not set
> # CONFIG_SND_HDA_CODEC_CMEDIA is not set
> CONFIG_SND_HDA_CODEC_SI3054=y
> CONFIG_SND_HDA_GENERIC=y
> # CONFIG_SND_HDA_POWER_SAVE is not set
> CONFIG_SND_HDSP=m
> CONFIG_SND_HDSPM=m
> CONFIG_SND_HIFIER=m
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> CONFIG_SND_INTEL8X0=m
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> CONFIG_SND_LX6464ES=m
> CONFIG_SND_MAESTRO3=m
> CONFIG_SND_MIXART=m
> # CONFIG_SND_NM256 is not set
> CONFIG_SND_PCXHR=m
> CONFIG_SND_RIPTIDE=m
> CONFIG_SND_RME32=m
> # CONFIG_SND_RME96 is not set
> CONFIG_SND_RME9652=m
> # CONFIG_SND_SIS7019 is not set
> CONFIG_SND_SONICVIBES=m
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> CONFIG_SND_VIA82XX_MODEM=m
> # CONFIG_SND_VIRTUOSO is not set
> CONFIG_SND_VX222=m
> CONFIG_SND_YMFPCI=m
> CONFIG_SND_SPI=y
> # CONFIG_SND_USB is not set
> # CONFIG_SND_PCMCIA is not set
> CONFIG_SND_SOC=m
> CONFIG_SND_SOC_I2C_AND_SPI=m
> CONFIG_SND_SOC_ALL_CODECS=m
> CONFIG_SND_SOC_WM_HUBS=m
> CONFIG_SND_SOC_AD1836=m
> CONFIG_SND_SOC_AD1938=m
> CONFIG_SND_SOC_AD73311=m
> CONFIG_SND_SOC_ADS117X=m
> CONFIG_SND_SOC_AK4104=m
> CONFIG_SND_SOC_AK4535=m
> CONFIG_SND_SOC_AK4642=m
> CONFIG_SND_SOC_AK4671=m
> CONFIG_SND_SOC_CS4270=m
> CONFIG_SND_SOC_L3=m
> CONFIG_SND_SOC_PCM3008=m
> CONFIG_SND_SOC_SPDIF=m
> CONFIG_SND_SOC_SSM2602=m
> CONFIG_SND_SOC_TLV320AIC23=m
> CONFIG_SND_SOC_TLV320AIC26=m
> CONFIG_SND_SOC_TLV320AIC3X=m
> CONFIG_SND_SOC_TLV320DAC33=m
> CONFIG_SND_SOC_TWL4030=m
> CONFIG_SND_SOC_UDA134X=m
> CONFIG_SND_SOC_UDA1380=m
> CONFIG_SND_SOC_WM8510=m
> CONFIG_SND_SOC_WM8523=m
> CONFIG_SND_SOC_WM8580=m
> CONFIG_SND_SOC_WM8711=m
> CONFIG_SND_SOC_WM8727=m
> CONFIG_SND_SOC_WM8728=m
> CONFIG_SND_SOC_WM8731=m
> CONFIG_SND_SOC_WM8750=m
> CONFIG_SND_SOC_WM8753=m
> CONFIG_SND_SOC_WM8776=m
> CONFIG_SND_SOC_WM8900=m
> CONFIG_SND_SOC_WM8903=m
> CONFIG_SND_SOC_WM8940=m
> CONFIG_SND_SOC_WM8960=m
> CONFIG_SND_SOC_WM8961=m
> CONFIG_SND_SOC_WM8971=m
> CONFIG_SND_SOC_WM8974=m
> CONFIG_SND_SOC_WM8988=m
> CONFIG_SND_SOC_WM8990=m
> CONFIG_SND_SOC_WM8993=m
> CONFIG_SND_SOC_WM9081=m
> CONFIG_SND_SOC_MAX9877=m
> CONFIG_SND_SOC_TPA6130A2=m
> CONFIG_SOUND_PRIME=y
> # CONFIG_SOUND_OSS is not set
> CONFIG_AC97_BUS=m
> # CONFIG_HID_SUPPORT is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> CONFIG_USB_DEBUG=y
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> CONFIG_USB_DYNAMIC_MINORS=y
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_OTG is not set
> CONFIG_USB_MON=m
> CONFIG_USB_WUSB=y
> CONFIG_USB_WUSB_CBAF=m
> CONFIG_USB_WUSB_CBAF_DEBUG=y
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_XHCI_HCD=m
> CONFIG_USB_XHCI_HCD_DEBUGGING=y
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_OXU210HP_HCD=m
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_ISP1760_HCD=y
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=y
> CONFIG_USB_U132_HCD=m
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> CONFIG_USB_HWA_HCD=m
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=y
> # CONFIG_USB_WDM is not set
> CONFIG_USB_TMC=m
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> CONFIG_USB_STORAGE_DEBUG=y
> CONFIG_USB_STORAGE_DATAFAB=m
> CONFIG_USB_STORAGE_FREECOM=y
> CONFIG_USB_STORAGE_ISD200=y
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> CONFIG_USB_STORAGE_SDDR55=y
> CONFIG_USB_STORAGE_JUMPSHOT=y
> CONFIG_USB_STORAGE_ALAUDA=y
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> CONFIG_USB_STORAGE_KARMA=y
> CONFIG_USB_STORAGE_CYPRESS_ATACB=m
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=m
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> CONFIG_USB_EMI26=y
> CONFIG_USB_ADUTUX=m
> # CONFIG_USB_SEVSEG is not set
> CONFIG_USB_RIO500=m
> # CONFIG_USB_LEGOTOWER is not set
> CONFIG_USB_LCD=m
> CONFIG_USB_BERRY_CHARGE=m
> CONFIG_USB_LED=m
> CONFIG_USB_CYPRESS_CY7C63=m
> CONFIG_USB_CYTHERM=m
> # CONFIG_USB_IDMOUSE is not set
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=m
> CONFIG_USB_SISUSBVGA=y
> CONFIG_USB_SISUSBVGA_CON=y
> CONFIG_USB_LD=m
> CONFIG_USB_TRANCEVIBRATOR=y
> CONFIG_USB_IOWARRIOR=y
> CONFIG_USB_TEST=m
> CONFIG_USB_ISIGHTFW=m
> CONFIG_USB_VST=m
> CONFIG_USB_ATM=m
> CONFIG_USB_SPEEDTOUCH=m
> CONFIG_USB_CXACRU=m
> CONFIG_USB_UEAGLEATM=m
> CONFIG_USB_XUSBATM=m
> 
> #
> # OTG and related infrastructure
> #
> CONFIG_USB_OTG_UTILS=y
> # CONFIG_USB_GPIO_VBUS is not set
> CONFIG_NOP_USB_XCEIV=m
> CONFIG_UWB=y
> CONFIG_UWB_HWA=m
> CONFIG_UWB_WHCI=y
> CONFIG_UWB_WLP=m
> CONFIG_UWB_I1480U=m
> # CONFIG_UWB_I1480U_WLP is not set
> CONFIG_MMC=m
> CONFIG_MMC_DEBUG=y
> # CONFIG_MMC_UNSAFE_RESUME is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_BOUNCE=y
> # CONFIG_SDIO_UART is not set
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=m
> CONFIG_MMC_SDHCI_PCI=m
> # CONFIG_MMC_RICOH_MMC is not set
> # CONFIG_MMC_SDHCI_PLTFM is not set
> CONFIG_MMC_WBSD=m
> # CONFIG_MMC_AT91 is not set
> # CONFIG_MMC_ATMELMCI is not set
> CONFIG_MMC_TIFM_SD=m
> # CONFIG_MMC_SDRICOH_CS is not set
> CONFIG_MMC_CB710=m
> CONFIG_MMC_VIA_SDMMC=m
> CONFIG_MEMSTICK=y
> CONFIG_MEMSTICK_DEBUG=y
> 
> #
> # MemoryStick drivers
> #
> CONFIG_MEMSTICK_UNSAFE_RESUME=y
> CONFIG_MSPRO_BLOCK=y
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=m
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_ALIX2=y
> # CONFIG_LEDS_PCA9532 is not set
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_GPIO_PLATFORM=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_CLEVO_MAIL=y
> # CONFIG_LEDS_PCA955X is not set
> CONFIG_LEDS_WM831X_STATUS=m
> # CONFIG_LEDS_DA903X is not set
> # CONFIG_LEDS_DAC124S085 is not set
> # CONFIG_LEDS_REGULATOR is not set
> CONFIG_LEDS_BD2802=y
> CONFIG_LEDS_LT3593=y
> # CONFIG_LEDS_ADP5520 is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> # CONFIG_LEDS_TRIGGER_GPIO is not set
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_ACCESSIBILITY=y
> CONFIG_A11Y_BRAILLE_CONSOLE=y
> CONFIG_INFINIBAND=y
> # CONFIG_INFINIBAND_USER_MAD is not set
> CONFIG_INFINIBAND_USER_ACCESS=y
> CONFIG_INFINIBAND_USER_MEM=y
> # CONFIG_INFINIBAND_MTHCA is not set
> # CONFIG_INFINIBAND_AMSO1100 is not set
> # CONFIG_INFINIBAND_CXGB3 is not set
> CONFIG_MLX4_INFINIBAND=y
> # CONFIG_INFINIBAND_NES is not set
> # CONFIG_INFINIBAND_IPOIB is not set
> CONFIG_INFINIBAND_SRP=y
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> # CONFIG_RTC_INTF_PROC is not set
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> CONFIG_RTC_DRV_TEST=m
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=m
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=m
> CONFIG_RTC_DRV_MAX6900=y
> CONFIG_RTC_DRV_RS5C372=y
> # CONFIG_RTC_DRV_ISL1208 is not set
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PCF8563=m
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=m
> CONFIG_RTC_DRV_M41T80_WDT=y
> CONFIG_RTC_DRV_BQ32K=m
> CONFIG_RTC_DRV_TWL4030=m
> # CONFIG_RTC_DRV_S35390A is not set
> CONFIG_RTC_DRV_FM3130=m
> CONFIG_RTC_DRV_RX8581=m
> # CONFIG_RTC_DRV_RX8025 is not set
> 
> #
> # SPI RTC drivers
> #
> # CONFIG_RTC_DRV_M41T94 is not set
> CONFIG_RTC_DRV_DS1305=m
> CONFIG_RTC_DRV_DS1390=m
> CONFIG_RTC_DRV_MAX6902=y
> CONFIG_RTC_DRV_R9701=y
> CONFIG_RTC_DRV_RS5C348=m
> CONFIG_RTC_DRV_DS3234=m
> CONFIG_RTC_DRV_PCF2123=m
> 
> #
> # Platform RTC drivers
> #
> # CONFIG_RTC_DRV_CMOS is not set
> CONFIG_RTC_DRV_DS1286=y
> # CONFIG_RTC_DRV_DS1511 is not set
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=y
> # CONFIG_RTC_DRV_STK17TA8 is not set
> CONFIG_RTC_DRV_M48T86=m
> CONFIG_RTC_DRV_M48T35=y
> # CONFIG_RTC_DRV_M48T59 is not set
> CONFIG_RTC_DRV_MSM6242=m
> # CONFIG_RTC_DRV_BQ4802 is not set
> CONFIG_RTC_DRV_RP5C01=m
> CONFIG_RTC_DRV_V3020=y
> CONFIG_RTC_DRV_WM831X=y
> CONFIG_RTC_DRV_PCF50633=m
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_PCAP is not set
> # CONFIG_CS5535_CLOCK_EVENT_SRC is not set
> CONFIG_DMADEVICES=y
> 
> #
> # DMA Devices
> #
> CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
> CONFIG_INTEL_IOATDMA=m
> CONFIG_DMA_ENGINE=y
> 
> #
> # DMA Clients
> #
> # CONFIG_NET_DMA is not set
> CONFIG_ASYNC_TX_DMA=y
> # CONFIG_DMATEST is not set
> CONFIG_DCA=m
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_UIO=m
> CONFIG_UIO_CIF=m
> CONFIG_UIO_PDRV=m
> CONFIG_UIO_PDRV_GENIRQ=m
> # CONFIG_UIO_SMX is not set
> CONFIG_UIO_AEC=m
> CONFIG_UIO_SERCOS3=m
> CONFIG_UIO_PCI_GENERIC=m
> 
> #
> # TI VLYNQ
> #
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> CONFIG_ACER_WMI=y
> CONFIG_ASUS_LAPTOP=y
> CONFIG_DELL_LAPTOP=m
> CONFIG_DELL_WMI=m
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_TC1100_WMI is not set
> CONFIG_HP_WMI=y
> CONFIG_MSI_LAPTOP=m
> CONFIG_PANASONIC_LAPTOP=y
> CONFIG_COMPAL_LAPTOP=y
> # CONFIG_SONY_LAPTOP is not set
> CONFIG_THINKPAD_ACPI=m
> # CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
> # CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
> # CONFIG_THINKPAD_ACPI_DEBUG is not set
> CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
> # CONFIG_THINKPAD_ACPI_VIDEO is not set
> CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
> CONFIG_ACPI_WMI=y
> CONFIG_MSI_WMI=y
> # CONFIG_ACPI_ASUS is not set
> CONFIG_TOPSTAR_LAPTOP=m
> CONFIG_ACPI_TOSHIBA=y
> CONFIG_TOSHIBA_BT_RFKILL=y
> CONFIG_ACPI_CMPC=y
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> CONFIG_DMIID=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> # CONFIG_EXT2_FS_SECURITY is not set
> CONFIG_EXT2_FS_XIP=y
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4_FS=m
> # CONFIG_EXT4_FS_XATTR is not set
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_FS_XIP=y
> CONFIG_JBD=y
> CONFIG_JBD_DEBUG=y
> CONFIG_JBD2=y
> CONFIG_JBD2_DEBUG=y
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=m
> CONFIG_REISERFS_CHECK=y
> CONFIG_REISERFS_PROC_INFO=y
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=m
> CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> CONFIG_OCFS2_DEBUG_FS=y
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> CONFIG_NILFS2_FS=m
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> # CONFIG_PRINT_QUOTA_WARNING is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=m
> CONFIG_QFMT_V2=m
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS_FS=m
> CONFIG_AUTOFS4_FS=m
> CONFIG_FUSE_FS=m
> # CONFIG_CUSE is not set
> CONFIG_GENERIC_ACL=y
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> # CONFIG_JOLIET is not set
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=m
> CONFIG_NTFS_DEBUG=y
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=y
> # CONFIG_ADFS_FS_RW is not set
> # CONFIG_AFFS_FS is not set
> CONFIG_HFS_FS=m
> CONFIG_HFSPLUS_FS=y
> CONFIG_BEFS_FS=m
> CONFIG_BEFS_DEBUG=y
> CONFIG_BFS_FS=m
> CONFIG_EFS_FS=y
> CONFIG_CRAMFS=m
> CONFIG_SQUASHFS=m
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> CONFIG_VXFS_FS=m
> # CONFIG_MINIX_FS is not set
> CONFIG_OMFS_FS=m
> CONFIG_HPFS_FS=y
> CONFIG_QNX4FS_FS=m
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_BACKED_BY_BLOCK=y
> # CONFIG_ROMFS_BACKED_BY_MTD is not set
> # CONFIG_ROMFS_BACKED_BY_BOTH is not set
> CONFIG_ROMFS_ON_BLOCK=y
> CONFIG_SYSV_FS=m
> CONFIG_UFS_FS=y
> CONFIG_UFS_FS_WRITE=y
> CONFIG_UFS_DEBUG=y
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_EXPORTFS=y
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> CONFIG_ACORN_PARTITION_CUMANA=y
> CONFIG_ACORN_PARTITION_EESOX=y
> CONFIG_ACORN_PARTITION_ICS=y
> CONFIG_ACORN_PARTITION_ADFS=y
> CONFIG_ACORN_PARTITION_POWERTEC=y
> CONFIG_ACORN_PARTITION_RISCIX=y
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> # CONFIG_UNIXWARE_DISKLABEL is not set
> CONFIG_LDM_PARTITION=y
> # CONFIG_LDM_DEBUG is not set
> # CONFIG_SGI_PARTITION is not set
> CONFIG_ULTRIX_PARTITION=y
> CONFIG_SUN_PARTITION=y
> CONFIG_KARMA_PARTITION=y
> CONFIG_EFI_PARTITION=y
> CONFIG_SYSV68_PARTITION=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=m
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=y
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=y
> # CONFIG_NLS_CODEPAGE_862 is not set
> CONFIG_NLS_CODEPAGE_863=m
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=m
> CONFIG_NLS_CODEPAGE_869=m
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=y
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_UTF8=y
> CONFIG_DLM=m
> CONFIG_DLM_DEBUG=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> # CONFIG_PRINTK_TIME is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_STRIP_ASM_SYMS=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_DETECT_SOFTLOCKUP=y
> CONFIG_NMI_WATCHDOG=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> # CONFIG_TIMER_STATS is not set
> CONFIG_DEBUG_OBJECTS=y
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> # CONFIG_DEBUG_OBJECTS_WORK is not set
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_SLUB_DEBUG_ON=y
> # CONFIG_SLUB_STATS is not set
> # CONFIG_DEBUG_PREEMPT is not set
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_PROVE_RCU=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_TRACE_IRQFLAGS=y
> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_INFO is not set
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_WRITECOUNT=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_LIST=y
> CONFIG_DEBUG_SG=y
> CONFIG_DEBUG_NOTIFIERS=y
> # CONFIG_DEBUG_CREDENTIALS is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> CONFIG_RCU_TORTURE_TEST=y
> CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
> CONFIG_RCU_CPU_STALL_DETECTOR=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> # CONFIG_SYSCTL_SYSCALL_CHECK is not set
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
> CONFIG_BUILD_DOCSRC=y
> # CONFIG_DYNAMIC_DEBUG is not set
> CONFIG_DMA_API_DEBUG=y
> CONFIG_SAMPLES=y
> CONFIG_SAMPLE_KOBJECT=m
> # CONFIG_SAMPLE_HW_BREAKPOINT is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_STRICT_DEVMEM=y
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACK_USAGE is not set
> CONFIG_DEBUG_PER_CPU_MAPS=y
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> # CONFIG_DEBUG_NX_TEST is not set
> # CONFIG_4KSTACKS is not set
> CONFIG_DOUBLEFAULT=y
> CONFIG_IOMMU_STRESS=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> CONFIG_DEBUG_BOOT_PARAMS=y
> CONFIG_CPA_DEBUG=y
> CONFIG_OPTIMIZE_INLINING=y
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_PATH=y
> # CONFIG_SECURITY_SMACK is not set
> CONFIG_SECURITY_TOMOYO=y
> CONFIG_IMA=y
> CONFIG_IMA_MEASURE_PCR_IDX=10
> CONFIG_IMA_AUDIT=y
> # CONFIG_DEFAULT_SECURITY_SELINUX is not set
> # CONFIG_DEFAULT_SECURITY_SMACK is not set
> # CONFIG_DEFAULT_SECURITY_TOMOYO is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=y
> CONFIG_ASYNC_MEMCPY=y
> CONFIG_ASYNC_XOR=y
> CONFIG_ASYNC_PQ=y
> CONFIG_ASYNC_RAID6_RECOV=y
> CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
> CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_GF128MUL=m
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=m
> CONFIG_CRYPTO_AUTHENC=y
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=m
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=m
> CONFIG_CRYPTO_ECB=y
> # CONFIG_CRYPTO_LRW is not set
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=m
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_VMAC=m
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=m
> CONFIG_CRYPTO_GHASH=m
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=m
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_586 is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=m
> # CONFIG_CRYPTO_BLOWFISH is not set
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_SALSA20=m
> CONFIG_CRYPTO_SALSA20_586=m
> CONFIG_CRYPTO_SEED=m
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_586=m
> 
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> CONFIG_CRYPTO_ZLIB=m
> # CONFIG_CRYPTO_LZO is not set
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=m
> CONFIG_CRYPTO_DEV_PADLOCK_AES=m
> CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
> # CONFIG_CRYPTO_DEV_GEODE is not set
> CONFIG_CRYPTO_DEV_HIFN_795X=m
> # CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> CONFIG_VIRTIO=y
> CONFIG_VIRTIO_RING=y
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> CONFIG_GENERIC_FIND_LAST_BIT=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPUMASK_OFFSTACK=y
> CONFIG_NLATTR=y

