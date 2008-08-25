Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYHYMot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYHYMot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYHYMol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:44:41 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24457 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbYHYMoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:44:39 -0400
Message-ID: <48B2A91F.8000302@hp.com>
Date: Mon, 25 Aug 2008 08:44:15 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030100080109070101040806"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030100080109070101040806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> On Sat, 23 Aug 2008, Linus Torvalds wrote:
>> This one makes no sense. It's triggering a BUG_ON(in_interrupt()), but 
>> then the call chain shows that there is no interrupt going on.
> 
> Ahh, later in that thread there's another totally unrelated oops in 
> debug_mutex_add_waiter().
> 
> I'd guess that it is really wild pointer corrupting memory, quite possibly 
> due to a double free or something like that. Alan - it would be good to 
> run with DEBUG_PAGE_ALLOC and SLUB debugging etc if you don't already do 
> that?

With /just/ DEBUG_PAGE_ALLOC defined, I have seen two general panic types:

o  A new double fault w/ SMP_DEBUG_PAGEALLOC problem (prob4.txt)

o  The NULL pointer dereference @ 0x858 (prob4a.txt)

Enabling SLUB debugging to see what that shows

Alan

--------------030100080109070101040806
Content-Type: text/plain;
 name="prob4.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="prob4.txt"

Begin: Loading essential drivers... ...
[    6.680626] fuse init (API version 7.9)
[    6.680626] modprobe used greatest stack depth: 1720 bytes left
[    6.704224] double fault: 0000 [1] SMP DEBUG_PAGEALLOC
[    6.704224] CPU 1
[    6.704224] Modules linked in: processor(+) fan thermal_sys fuse
[    6.710629] Pid: 1259, comm: modprobe Not tainted 2.6.27-rc3 #30
[    6.710629] RIP: 0010:[<ffffffff802214dc>]  [<ffffffff802214dc>] flat_send_IPI_allbutself+0x2c/0x80
[    6.710629] RSP: 0018:ffff88021a513ff8  EFLAGS: 00010282
[    6.710629] RAX: ffffffff805f5520 RBX: ffff88021a5141f8 RCX: 000000000000003f
[    6.710629] RDX: 0000000000000200 RSI: ffffffff80bf7920 RDI: ffff88021a5141f8
[    6.710629] RBP: ffff88021a514408 R08: 0000000000000040 R09: 0000000000000040
[    6.710629] R10: 0000000000001000 R11: 0000000000000000 R12: 00000000000000fc
[    6.710629] R13: ffff88021a514eb8 R14: 0000000000000001 R15: ffffffff8021cba0
[    6.710629] FS:  00007f39acc136e0(0000) GS:ffff88022fc81a00(0000) knlGS:0000000000000000
[    6.710629] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.710629] CR2: ffff88021a513fe8 CR3: 000000021a469000 CR4: 00000000000006e0
[    6.710629] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.710629] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.710629] Process modprobe (pid: 1259, threadinfo ffff88021a514000, task ffff88021a9da050)
[    6.710629] Stack: <1>BUG: unable to handle kernel paging request at ffff88021a513ff8
[    6.710629] IP: [<ffffffff8020dd22>] show_stack_log_lvl+0x82/0x130
[    6.710629] PGD 202063 PUD 10067 PMD 22f176163 PTE 800000021a513160
[    6.710629] Oops: 0000 [2] SMP DEBUG_PAGEALLOC
[    6.710629] CPU 1
[    6.710629] Modules linked in: processor(+) fan thermal_sys fuse
[    6.710629] Pid: 1259, comm: modprobe Not tainted 2.6.27-rc3 #30
[    6.710629] RIP: 0010:[<ffffffff8020dd22>]  [<ffffffff8020dd22>] show_stack_log_lvl+0x82/0x130
[    6.710629] RSP: 0018:ffff88022f12ce28  EFLAGS: 00010046
[    6.710629] RAX: ffff88022fc81a00 RBX: ffff88021a513ff8 RCX: 000000000000000c
[    6.710629] RDX: ffff88021a513ff8 RSI: ffff88022f12cf58 RDI: 0000000000000000
[    6.710629] RBP: ffff88022f12ce78 R08: ffffffff8059aea9 R09: 0000000000000001
[    6.710629] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    6.710629] R13: ffff88022f127fc0 R14: ffff88022f12bfc0 R15: 0000000000000000
[    6.710629] FS:  00007f39acc136e0(0000) GS:ffff88022fc81a00(0000) knlGS:0000000000000000
[    6.710629] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.710629] CR2: ffff88021a513ff8 CR3: 000000021a469000 CR4: 00000000000006e0
[    6.710629] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.710629] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.710629] Process modprobe (pid: 1259, threadinfo ffff88021a514000, task ffff88021a9da050)
[    6.710629] Stack:  ffff88022f12ce78 ffffffff8059aea9 ffff88021a514408 ffff88022f12cf58
[    6.710629]  ffff88021a513ff8 ffff88021a9da050 0000000000000000 ffff88022f12cf58
[    6.710629]  0000000000000040 000000000000002b ffff88022f12ceb8 ffffffff8020dea8
[    6.710629] Call Trace:
[    6.710629]  <#DF>  [<ffffffff8020dea8>] show_registers+0xd8/0x260
[    6.710629]  [<ffffffff8021cba0>] ? do_flush_tlb_all+0x0/0x40
[    6.710629]  [<ffffffff804a2083>] __die+0xa3/0x120
[    6.710629]  [<ffffffff8020e073>] die+0x43/0x90
[    6.710629]  [<ffffffff8020e1e3>] do_double_fault+0x63/0x70
[    6.710629]  [<ffffffff8020d4fd>] double_fault+0x7d/0x90
[    6.710629]  [<ffffffff8021cba0>] ? do_flush_tlb_all+0x0/0x40
[    6.710629]  [<ffffffff802214dc>] ? flat_send_IPI_allbutself+0x2c/0x80
[    6.710629]  <<EOE>>
[    6.710629]
[    6.710629] Code: 55 d0 85 c9 48 89 d3 7e 5a 45 31 e4 eb 44 4c 39 f3 77 44 66 0f 1f 44 00 00 74 7e 45 85 e4 74 0b 41 f6 c4 03 0f 1f 44 00 00 7
[    6.720629] RIP  [<ffffffff8020dd22>] show_stack_log_lvl+0x82/0x130
[    6.720629]  RSP <ffff88022f12ce28>
[    6.720629] CR2: ffff88021a513ff8
[    6.720629] ---[ end trace d4fdf12ff3e07cc3 ]---
[    7.052961] modprobe used greatest stack depth: 920 bytes left
Killed

--------------030100080109070101040806
Content-Type: text/plain;
 name="prob4a.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="prob4a.txt"

[    6.551876] all_generic_ide used greatest stack depth: 4784 bytes left
Begin: Loading essential drivers... ...
[    6.658003] fuse init (API version 7.9)
[    6.661876] modprobe used greatest stack depth: 1720 bytes left
[    6.683510] ACPI: SSDT CFFD0D0A, 08C4 (r1 HPQOEM  CPU_TM2        1 MSFT  100000E)
[    6.690632] BUG: unable to handle kernel NULL pointer dereference at 0000000000000858
[    6.690632] IP: [<ffffffff8025e512>] debug_mutex_add_waiter+0x32/0x80
[    6.690632] PGD 21a145067 PUD 22f13a067 PMD 0
[    6.690632] Oops: 0002 [1] SMP DEBUG_PAGEALLOC
[    6.690632] CPU 1
[    6.690632] Modules linked in: processor(+) fan thermal_sys fuse
[    6.690632] Pid: 1259, comm: modprobe Not tainted 2.6.27-rc3 #30
[    6.690632] RIP: 0010:[<ffffffff8025e512>]  [<ffffffff8025e512>] debug_mutex_add_waiter+0x32/0x80
[    6.690632] RSP: 0018:ffff88021a959998  EFLAGS: 00010002
[    6.690632] RAX: 0000000000000000 RBX: ffff88021a9599d8 RCX: 0000000000000000
[    6.690632] RDX: 0000000000000001 RSI: ffff88021a9599d8 RDI: ffffffffa0091a60
[    6.690632] RBP: ffff88021a9599b8 R08: ffffffff811deff0 R09: ffff8800a6fdb000
[    6.690632] R10: ffffffffa008f524 R11: 0000000000000000 R12: ffffffffa0091a60
[    6.690632] R13: ffff88021a958000 R14: ffff88021a1c2050 R15: ffffffffa0091a98
[    6.690632] FS:  00007f28063c16e0(0000) GS:ffff88022fc81a00(0000) knlGS:0000000000000000
[    6.690632] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.690632] CR2: 0000000000000858 CR3: 0000000219c64000 CR4: 00000000000006e0
[    6.690632] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.690632] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.690632] Process modprobe (pid: 1259, threadinfo ffff88021a958000, task ffff88021a1c2050)
[    6.690632] Stack:  0000000000000000 ffffffffa0091a60 0000000000000246 ffffffffa008f524
[    6.690632]  ffff88021a959a38 ffffffff8049f856 ffffffffa008f524 ffffffffa0091a18
[    6.690632]  ffff88021a9599d8 ffff88021a9599d8 1111111111111111 1111111111111111
[    6.690632] Call Trace:
[    6.690632]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    6.690632]  [<ffffffff8049f856>] mutex_lock_nested+0xa6/0x250
[    6.690632]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    6.690632]  [<ffffffff80363884>] ? idr_pre_get+0x44/0x90
[    6.690632]  [<ffffffffa008f524>] get_idr+0x44/0xa0 [thermal_sys]
[    6.690632]  [<ffffffffa008fe43>] thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    6.690632]  [<ffffffffa019b2a3>] acpi_processor_start+0x64b/0x774 [processor]
[    6.690632]  [<ffffffff8031ac0b>] ? __sysfs_add_one+0x6b/0xa0
[    6.690632]  [<ffffffff8031bcfc>] ? sysfs_do_create_link+0xbc/0x150
[    6.690632]  [<ffffffff803a821e>] acpi_start_single_object+0x2d/0x52
[    6.690632]  [<ffffffff803a9816>] acpi_device_probe+0x7e/0x92
[    6.690632]  [<ffffffff803dd6ab>] driver_probe_device+0x9b/0x1a0
[    6.690632]  [<ffffffff803dd836>] __driver_attach+0x86/0x90
[    6.690632]  [<ffffffff803dd7b0>] ? __driver_attach+0x0/0x90
[    6.690632]  [<ffffffff803dcbfd>] bus_for_each_dev+0x5d/0x90
[    6.690632]  [<ffffffff803dd4ec>] driver_attach+0x1c/0x20
[    6.690632]  [<ffffffff803dd239>] bus_add_driver+0x1e9/0x260
[    6.690632]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    6.690632]  [<ffffffff803dda0f>] driver_register+0x5f/0x140
[    6.690632]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    6.690632]  [<ffffffff803a9b26>] acpi_bus_register_driver+0x3e/0x40
[    6.690632]  [<ffffffffa0222094>] acpi_processor_init+0x94/0x107 [processor]
[    6.690632]  [<ffffffff80209040>] _stext+0x40/0x180
[    6.690632]  [<ffffffff802a8bd1>] ? __vunmap+0xa1/0x110
[    6.690632]  [<ffffffff802678d2>] sys_init_module+0x142/0x1dc0
[    6.690632]  [<ffffffff80367dd6>] ? __up_read+0x46/0xb0
[    6.690632]  [<ffffffff8048e830>] ? cpu_down+0x0/0x70
[    6.690632]  [<ffffffff8020c34b>] system_call_fastpath+0x16/0x1b
[    6.690632]
[    6.690632]
[    6.690632] Code: 20 48 89 5d e8 4c 89 65 f0 48 89 f3 4c 89 6d f8 8b 47 08 49 89 d5 49 89 fc 89 c2 25 ff ff 00 00 c1 ea 10 39 c2 74 1d 49 8b 4
[    6.690632] RIP  [<ffffffff8025e512>] debug_mutex_add_waiter+0x32/0x80
[    6.690632]  RSP <ffff88021a959998>
[    6.690632] CR2: 0000000000000858
[    6.690632] ---[ end trace 62c38812ae35bad0 ]---
[    7.060556] ------------[ cut here ]------------
[    7.060741] WARNING: at kernel/sched_fair.c:884 hrtick_start_fair+0x187/0x190()
[    7.060741] Modules linked in: processor(+) fan thermal_sys fuse
[    7.060741] Pid: 1259, comm: modprobe Tainted: G      D   2.6.27-rc3 #30
[    7.060741]
[    7.060741] Call Trace:
[    7.060741]  <IRQ>  [<ffffffff8023bcff>] warn_on_slowpath+0x5f/0x80
[    7.060741]  [<ffffffff8022db37>] hrtick_start_fair+0x187/0x190
[    7.060741]  [<ffffffff8022ee89>] enqueue_task_fair+0x49/0x250
[    7.060741]  [<ffffffff8022c4a0>] enqueue_task+0x50/0x60
[    7.060741]  [<ffffffff8022c4d3>] activate_task+0x23/0x40
[    7.060741]  [<ffffffff80231863>] try_to_wake_up+0x253/0x280
[    7.060741]  [<ffffffff8023189d>] default_wake_function+0xd/0x10
[    7.060741]  [<ffffffff802523e1>] autoremove_wake_function+0x11/0x40
[    7.060741]  [<ffffffff8022bf7a>] __wake_up_common+0x5a/0x90
[    7.060741]  [<ffffffff8022d583>] __wake_up+0x43/0x70
[    7.060741]  [<ffffffff8024eb20>] ? delayed_work_timer_fn+0x0/0x40
[    7.060741]  [<ffffffff8024e178>] insert_work+0x48/0x50
[    7.060741]  [<ffffffff8024eb01>] __queue_work+0x31/0x50
[    7.060741]  [<ffffffff8024eb52>] delayed_work_timer_fn+0x32/0x40
[    7.060741]  [<ffffffff8024606b>] run_timer_softirq+0x1bb/0x230
[    7.060741]  [<ffffffff80255d0a>] ? ktime_get_ts+0x4a/0x60
[    7.060741]  [<ffffffff8024178a>] __do_softirq+0x7a/0xf0
[    7.060741]  [<ffffffff8025cf9e>] ? tick_program_event+0x3e/0x70
[    7.060741]  [<ffffffff8020d69c>] call_softirq+0x1c/0x30
[    7.060741]  [<ffffffff8020f28d>] do_softirq+0x3d/0x80
[    7.060741]  [<ffffffff80241705>] irq_exit+0x85/0x90
[    7.060741]  [<ffffffff8021d648>] smp_apic_timer_interrupt+0x88/0xc0
[    7.060741]  [<ffffffff8020d0e6>] apic_timer_interrupt+0x66/0x70
[    7.060741]  <EOI>  [<ffffffff804a15eb>] ? _spin_unlock_irq+0x2b/0x30
[    7.060741]  [<ffffffff804a0e75>] ? __down_read+0xa5/0xb7
[    7.060741]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060741]  [<ffffffff8049fe57>] ? down_read+0x37/0x40
[    7.060741]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060741]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060741]  [<ffffffff8023f4ad>] ? do_exit+0x18d/0xa10
[    7.060741]  [<ffffffff803c8019>] ? do_unblank_screen+0x19/0x130
[    7.060741]  [<ffffffff804a1d17>] ? oops_end+0x87/0x90
[    7.060741]  [<ffffffff804a3fe3>] ? do_page_fault+0x663/0x800
[    7.060741]  [<ffffffff804a18ed>] ? error_exit+0x0/0x9a
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffff8025e512>] ? debug_mutex_add_waiter+0x32/0x80
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffff8049f856>] ? mutex_lock_nested+0xa6/0x250
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffff80363884>] ? idr_pre_get+0x44/0x90
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffffa008fe43>] ? thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    7.060741]  [<ffffffffa019b2a3>] ? acpi_processor_start+0x64b/0x774 [processor]
[    7.060741]  [<ffffffff8031ac0b>] ? __sysfs_add_one+0x6b/0xa0
[    7.060741]  [<ffffffff8031bcfc>] ? sysfs_do_create_link+0xbc/0x150
[    7.060741]  [<ffffffff803a821e>] ? acpi_start_single_object+0x2d/0x52
[    7.060741]  [<ffffffff803a9816>] ? acpi_device_probe+0x7e/0x92
[    7.060741]  [<ffffffff803dd6ab>] ? driver_probe_device+0x9b/0x1a0
[    7.060741]  [<ffffffff803dd836>] ? __driver_attach+0x86/0x90
[    7.060741]  [<ffffffff803dd7b0>] ? __driver_attach+0x0/0x90
[    7.060741]  [<ffffffff803dcbfd>] ? bus_for_each_dev+0x5d/0x90
[    7.060741]  [<ffffffff803dd4ec>] ? driver_attach+0x1c/0x20
[    7.060741]  [<ffffffff803dd239>] ? bus_add_driver+0x1e9/0x260
[    7.060741]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.060741]  [<ffffffff803dda0f>] ? driver_register+0x5f/0x140
[    7.060741]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.060741]  [<ffffffff803a9b26>] ? acpi_bus_register_driver+0x3e/0x40
[    7.060741]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor]
[    7.060741]  [<ffffffff80209040>] ? _stext+0x40/0x180
[    7.060741]  [<ffffffff802a8bd1>] ? __vunmap+0xa1/0x110
[    7.060741]  [<ffffffff802678d2>] ? sys_init_module+0x142/0x1dc0
[    7.060741]  [<ffffffff80367dd6>] ? __up_read+0x46/0xb0
[    7.060741]  [<ffffffff8048e830>] ? cpu_down+0x0/0x70
[    7.060741]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b
[    7.060741]
[    7.060741] ---[ end trace 62c38812ae35bad0 ]---
[    7.060741] ------------[ cut here ]------------
[    7.060741] kernel BUG at kernel/sched.c:1155!
[    7.060741] invalid opcode: 0000 [2] SMP DEBUG_PAGEALLOC
[    7.060741] CPU 1
[    7.060741] Modules linked in: processor(+) fan thermal_sys fuse
[    7.060741] Pid: 1259, comm: modprobe Tainted: G      D W 2.6.27-rc3 #30
[    7.060741] RIP: 0010:[<ffffffff8022ce3b>]  [<ffffffff8022ce3b>] resched_task+0x6b/0x70
[    7.060741] RSP: 0018:ffff88022f12bce0  EFLAGS: 00010046
[    7.060741] RAX: 00000000000006e5 RBX: 00000000012c627a RCX: ffff88021a958000
[    7.060741] RDX: 00000000000006e5 RSI: 0000000000000000 RDI: ffff88021a1c2050
[    7.060741] RBP: ffff88022f12bce0 R08: ffff88022f1d8038 R09: ffff88021a1c2088
[    7.060741] R10: ffffffff810c9e00 R11: 0000000000000000 R12: ffff8800a6fc9000
[    7.060741] R13: ffffffff810c9e00 R14: ffff88021a1c2050 R15: 0000000000000001
[    7.060741] FS:  00007f28063c16e0(0000) GS:ffff88022fc81a00(0000) knlGS:0000000000000000
[    7.060741] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.060741] CR2: 0000000000000858 CR3: 0000000219c64000 CR4: 00000000000006e0
[    7.060741] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.060741] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.060741] Process modprobe (pid: 1259, threadinfo ffff88021a958000, task ffff88021a1c2050)
[    7.060741] Stack:  ffff88022f12bd20 ffffffff802389c3 0000000000000400 0000000000400000
[    7.060741]  ffff88022f1d8000 ffff8800280a4e00 0000000000000001 0000000000000003
[    7.060741]  ffff88022f12bd70 ffffffff802316cf 0000000100000001 0000000000000000
[    7.060741] Call Trace:
[    7.060741]  <IRQ>  [<ffffffff802389c3>] check_preempt_wakeup+0x133/0x1c0
[    7.060741]  [<ffffffff802316cf>] try_to_wake_up+0xbf/0x280
[    7.060741]  [<ffffffff8023189d>] default_wake_function+0xd/0x10
[    7.060741]  [<ffffffff802523e1>] autoremove_wake_function+0x11/0x40
[    7.060741]  [<ffffffff8022bf7a>] __wake_up_common+0x5a/0x90
[    7.060741]  [<ffffffff8022d583>] __wake_up+0x43/0x70
[    7.060741]  [<ffffffff8024eb20>] ? delayed_work_timer_fn+0x0/0x40
[    7.060741]  [<ffffffff8024e178>] insert_work+0x48/0x50
[    7.060741]  [<ffffffff8024eb01>] __queue_work+0x31/0x50
[    7.060741]  [<ffffffff8024eb52>] delayed_work_timer_fn+0x32/0x40
[    7.060741]  [<ffffffff8024606b>] run_timer_softirq+0x1bb/0x230
[    7.060741]  [<ffffffff80255d0a>] ? ktime_get_ts+0x4a/0x60
[    7.060741]  [<ffffffff8024178a>] __do_softirq+0x7a/0xf0
[    7.060741]  [<ffffffff8025cf9e>] ? tick_program_event+0x3e/0x70
[    7.060741]  [<ffffffff8020d69c>] call_softirq+0x1c/0x30
[    7.060741]  [<ffffffff8020f28d>] do_softirq+0x3d/0x80
[    7.060741]  [<ffffffff80241705>] irq_exit+0x85/0x90
[    7.060741]  [<ffffffff8021d648>] smp_apic_timer_interrupt+0x88/0xc0
[    7.060741]  [<ffffffff8020d0e6>] apic_timer_interrupt+0x66/0x70
[    7.060741]  <EOI>  [<ffffffff804a15eb>] ? _spin_unlock_irq+0x2b/0x30
[    7.060741]  [<ffffffff804a0e75>] ? __down_read+0xa5/0xb7
[    7.060741]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060741]  [<ffffffff8049fe57>] ? down_read+0x37/0x40
[    7.060741]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060741]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060741]  [<ffffffff8023f4ad>] ? do_exit+0x18d/0xa10
[    7.060741]  [<ffffffff803c8019>] ? do_unblank_screen+0x19/0x130
[    7.060741]  [<ffffffff804a1d17>] ? oops_end+0x87/0x90
[    7.060741]  [<ffffffff804a3fe3>] ? do_page_fault+0x663/0x800
[    7.060741]  [<ffffffff804a18ed>] ? error_exit+0x0/0x9a
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffff8025e512>] ? debug_mutex_add_waiter+0x32/0x80
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffff8049f856>] ? mutex_lock_nested+0xa6/0x250
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffff80363884>] ? idr_pre_get+0x44/0x90
[    7.060741]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060741]  [<ffffffffa008fe43>] ? thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    7.060741]  [<ffffffffa019b2a3>] ? acpi_processor_start+0x64b/0x774 [processor]
[    7.060741]  [<ffffffff8031ac0b>] ? __sysfs_add_one+0x6b/0xa0
[    7.060741]  [<ffffffff8031bcfc>] ? sysfs_do_create_link+0xbc/0x150
[    7.060741]  [<ffffffff803a821e>] ? acpi_start_single_object+0x2d/0x52
[    7.060741]  [<ffffffff803a9816>] ? acpi_device_probe+0x7e/0x92
[    7.060741]  [<ffffffff803dd6ab>] ? driver_probe_device+0x9b/0x1a0
[    7.060741]  [<ffffffff803dd836>] ? __driver_attach+0x86/0x90
[    7.060741]  [<ffffffff803dd7b0>] ? __driver_attach+0x0/0x90
[    7.060741]  [<ffffffff803dcbfd>] ? bus_for_each_dev+0x5d/0x90
[    7.060741]  [<ffffffff803dd4ec>] ? driver_attach+0x1c/0x20
[    7.060741]  [<ffffffff803dd239>] ? bus_add_driver+0x1e9/0x260
[    7.060741]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.060741]  [<ffffffff803dda0f>] ? driver_register+0x5f/0x140
[    7.060741]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.060741]  [<ffffffff803a9b26>] ? acpi_bus_register_driver+0x3e/0x40
[    7.060741]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor]
[    7.060741]  [<ffffffff80209040>] ? _stext+0x40/0x180
[    7.060741]  [<ffffffff802a8bd1>] ? __vunmap+0xa1/0x110
[    7.060741]  [<ffffffff802678d2>] ? sys_init_module+0x142/0x1dc0
[    7.060741]  [<ffffffff80367dd6>] ? __up_read+0x46/0xb0
[    7.060741]  [<ffffffff8048e830>] ? cpu_down+0x0/0x70
[    7.060741]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b
[    7.060741]
[    7.060741]
[    7.060741] Code: 8b 47 08 8b 50 1c 65 8b 04 25 24 00 00 00 39 c2 74 0d 0f ae f0 48 8b 47 08 f6 40 18 04 74 02 c9 c3 89 d7 ff 15 0f 79 3c 00 c
[    7.060741] RIP  [<ffffffff8022ce3b>] resched_task+0x6b/0x70
[    7.060741]  RSP <ffff88022f12bce0>
[    7.060741] ---[ end trace 62c38812ae35bad0 ]---
[    7.060741] Kernel panic - not syncing: Aiee, killing interrupt handler!
[    7.060741] ------------[ cut here ]------------
[    7.060741] WARNING: at kernel/smp.c:328 smp_call_function_mask+0x25a/0x260()
[    7.060741] Modules linked in: processor(+) fan thermal_sys fuse
[    7.060741] Pid: 1259, comm: modprobe Tainted: G      D W 2.6.27-rc3 #30
[    7.060741]
[    7.060741] Call Trace:
[    7.060741]  <IRQ>  [<ffffffff8023bcff>] warn_on_slowpath+0x5f/0x80
[    7.060741]  [<ffffffff8026535a>] smp_call_function_mask+0x25a/0x260
[    7.060741]  [<ffffffff8036987d>] ? string+0x3d/0xd0
[    7.060741]  [<ffffffff80369d4b>] ? vsnprintf+0x43b/0x720
[    7.060741]  [<ffffffff8036987d>] ? string+0x3d/0xd0
[    7.060741]  [<ffffffff80369d4b>] ? vsnprintf+0x43b/0x720
[    7.060741]  [<ffffffff8036987d>] ? string+0x3d/0xd0
[    7.060741]  [<ffffffff8036987d>] ? string+0x3d/0xd0
[    7.060741]  [<ffffffff80369d4b>] ? vsnprintf+0x43b/0x720
[    7.060741]  [<ffffffff8036901e>] ? number+0x2ae/0x2d0
[    7.060741]  [<ffffffff8036901e>] ? number+0x2ae/0x2d0
[    7.060741]  [<ffffffff8026a0dd>] ? kallsyms_lookup+0x5d/0xa0
[    7.060741]  [<ffffffff8036901e>] ? number+0x2ae/0x2d0
[    7.060741]  [<ffffffff80369d4b>] ? vsnprintf+0x43b/0x720
[    7.060741]  [<ffffffff8036a098>] ? sprintf+0x68/0x70
[    7.060741]  [<ffffffff8036987d>] ? string+0x3d/0xd0
[    7.060741]  [<ffffffff804a4273>] ? __atomic_notifier_call_chain+0x83/0xa0
[    7.060741]  [<ffffffff804a41f0>] ? __atomic_notifier_call_chain+0x0/0xa0
[    7.060741]  [<ffffffff804a11b6>] ? _spin_unlock+0x26/0x30
[    7.060741]  [<ffffffff8021c470>] ? stop_this_cpu+0x0/0x30
[    7.060741]  [<ffffffff802653a0>] smp_call_function+0x40/0x50
[    7.060741]  [<ffffffff8021c4f3>] native_smp_send_stop+0x23/0x40
[    7.060741]  [<ffffffff8023c04f>] panic+0xaf/0x190
[    7.060741]  [<ffffffff8023cea7>] ? printk+0x67/0x70
[    7.060741]  [<ffffffff8049f7a9>] ? mutex_unlock+0x9/0x10
[    7.060741]  [<ffffffff80256f21>] ? blocking_notifier_call_chain+0x11/0x20
[    7.060741]  [<ffffffff8023fb89>] do_exit+0x869/0xa10
[    7.060741]  [<ffffffff803c8019>] ? do_unblank_screen+0x19/0x130
[    7.060741]  [<ffffffff804a1d17>] oops_end+0x87/0x90
[    7.060741]  [<ffffffff8020e08e>] die+0x5e/0x90
[    7.060741]  [<ffffffff804a2230>] do_trap+0x130/0x150
[    7.060741]  [<ffffffff8020e662>] do_invalid_op+0x92/0xb0
[    7.060741]  [<ffffffff8022ce3b>] ? resched_task+0x6b/0x70
[    7.060741]  [<ffffffff804a18ed>] error_exit+0x0/0x9a
[    7.060741]  [<ffffffff8022ce3b>] ? resched_task+0x6b/0x70
[    7.060741]  [<ffffffff802389c3>] check_preempt_wakeup+0x133/0x1c0
[    7.060741]  [<ffffffff802316cf>] try_to_wake_up+0xbf/0x280
[    7.060741]  [<ffffffff8023189d>] default_wake_function+0xd/0x10
[    7.060741]  [<ffffffff802523e1>] autoremove_wake_function+0x11/0x40
[    7.060741]  [<ffffffff8022bf7a>] __wake_up_common+0x5a/0x90
[    7.060741]  [<ffffffff8022d583>] __wake_up+0x43/0x70
[    7.060741]  [<ffffffff8024eb20>] ? delayed_work_timer_fn+0x0/0x40
[    7.060741]  [<ffffffff8024e178>] insert_work+0x48/0x50
[    7.060741]  [<ffffffff8024eb01>] __queue_work+0x31/0x50
[    7.060741]  [<ffffffff8024eb52>] delayed_work_timer_fn+0x32/0x40
[    7.060741]  [<ffffffff8024606b>] run_timer_softirq+0x1bb/0x230
[    7.060741]  [<ffffffff80255d0a>] ? ktime_get_ts+0x4a/0x60
[    7.060741]  [<ffffffff8024178a>] __do_softirq+0x7a/0xf0
[    7.060741]  [<ffffffff8025cf9e>] ? tick_program_event+0x3e/0x70
[    7.060741]  [<ffffffff8020d69c>] call_softirq+0x1c/0x30
[    7.060741]  [<ffffffff8020f28d>] do_softirq+0x3d/0x80
[    7.060741]  [<ffffffff80241705>] irq_exit+0x85/0x90
[    7.060741]  [<ffffffff8021d648>] smp_apic_timer_interrupt+0x88/0xc0
[    7.060741]  [<ffffffff8020d0e6>] apic_timer_interrupt+0x66/0x70
[    7.060741]  <EOI>  [<ffffffff804a15eb>] ? _spin_unlock_irq+0x2b/0x30
[    7.060741]  [<ffffffff804a0e75>] ? __down_read+0xa5/0xb7
[    7.060741]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060742]  [<ffffffff8049fe57>] ? down_read+0x37/0x40
[    7.060742]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060742]  [<ffffffff8026fdf5>] ? acct_collect+0x45/0x1d0
[    7.060742]  [<ffffffff8023f4ad>] ? do_exit+0x18d/0xa10
[    7.060742]  [<ffffffff803c8019>] ? do_unblank_screen+0x19/0x130
[    7.060742]  [<ffffffff804a1d17>] ? oops_end+0x87/0x90
[    7.060742]  [<ffffffff804a3fe3>] ? do_page_fault+0x663/0x800
[    7.060742]  [<ffffffff804a18ed>] ? error_exit+0x0/0x9a
[    7.060742]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060742]  [<ffffffff8025e512>] ? debug_mutex_add_waiter+0x32/0x80
[    7.060742]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060742]  [<ffffffff8049f856>] ? mutex_lock_nested+0xa6/0x250
[    7.060742]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060742]  [<ffffffff80363884>] ? idr_pre_get+0x44/0x90
[    7.060742]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.060742]  [<ffffffffa008fe43>] ? thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    7.060742]  [<ffffffffa019b2a3>] ? acpi_processor_start+0x64b/0x774 [processor]
[    7.060742]  [<ffffffff8031ac0b>] ? __sysfs_add_one+0x6b/0xa0
[    7.060742]  [<ffffffff8031bcfc>] ? sysfs_do_create_link+0xbc/0x150
[    7.060742]  [<ffffffff803a821e>] ? acpi_start_single_object+0x2d/0x52
[    7.060742]  [<ffffffff803a9816>] ? acpi_device_probe+0x7e/0x92
[    7.060742]  [<ffffffff803dd6ab>] ? driver_probe_device+0x9b/0x1a0
[    7.060742]  [<ffffffff803dd836>] ? __driver_attach+0x86/0x90
[    7.060742]  [<ffffffff803dd7b0>] ? __driver_attach+0x0/0x90
[    7.060742]  [<ffffffff803dcbfd>] ? bus_for_each_dev+0x5d/0x90
[    7.060742]  [<ffffffff803dd4ec>] ? driver_attach+0x1c/0x20
[    7.060742]  [<ffffffff803dd239>] ? bus_add_driver+0x1e9/0x260
[    7.060742]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.060742]  [<ffffffff803dda0f>] ? driver_register+0x5f/0x140
[    7.060742]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.060742]  [<ffffffff803a9b26>] ? acpi_bus_register_driver+0x3e/0x40
[    7.060742]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor]
[    7.060742]  [<ffffffff80209040>] ? _stext+0x40/0x180
[    7.060742]  [<ffffffff802a8bd1>] ? __vunmap+0xa1/0x110
[    7.060742]  [<ffffffff802678d2>] ? sys_init_module+0x142/0x1dc0
[    7.060742]  [<ffffffff80367dd6>] ? __up_read+0x46/0xb0
[    7.060742]  [<ffffffff8048e830>] ? cpu_down+0x0/0x70
[    7.060742]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b
[    7.060742]
[    7.060742] ---[ end trace 62c38812ae35bad0 ]---

--------------030100080109070101040806--
