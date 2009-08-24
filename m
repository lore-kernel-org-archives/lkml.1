Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbZHXOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbZHXOg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZHXOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:36:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbZHXOgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:36:54 -0400
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
From: Eric Paris <eparis@redhat.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com, vegard.nossum@gmail.com
In-Reply-To: <4A8F1081.3020803@suse.de>
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
	 <4A8EFFB2.4040100@suse.de>
	 <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
	 <4A8F1081.3020803@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Aug 2009 10:36:49 -0400
Message-Id: <1251124609.2359.25.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-22 at 01:24 +0400, Alexey Starikovskiy wrote:
> Eric Paris пишет:
> > On Sat, 2009-08-22 at 00:12 +0400, Alexey Starikovskiy wrote:
> >> Hi,
> >> This should be handled by abe1dfab60e1839d115930286cb421f5a5b193f3.
> > 
> > And yet I'm getting it from linux-next today.
> > 
> > So you are apparently failing the in_atomic_preempt_off() test but
> > succeeding in your !irqs_disabled() test.
> > 
> > Something isn't right since I'm hitting it hundreds of times on boot.
> > 
> > -Eric
> > 
> Ok, let's see if replacing irqs_disabled() to 
> in_atomic_preempt_off() helps... 

It does stop my slew of warnings.  Not sure it completely fixes my
problems though....

[    1.897021] ... counter mask:            0000000700000003^M
[    1.906821] ACPI: Core revision 20090625^M
[   10.000008] INFO: RCU detected CPU 0 stall (t=10000 jiffies)^M
[   10.000008] sending NMI to all CPUs:^M
[   21.907580] Setting APIC routing to flat^M
[   21.973314] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1^M
[   21.985260] CPU0: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07^M
[   21.992017] kmemcheck: Limiting number of CPUs to 1.^M
[   21.993065] kmemcheck: Initialized^M
[   22.750118] Brought up 1 CPUs^M
[   22.751069] Total of 1 processors activated (5333.45 BogoMIPS).^M
[   23.493639] khelper used greatest stack depth: 4848 bytes left^M
[   24.999193] Booting paravirtualized kernel on bare hardware^M
[   25.265364] Time: 17:50:52  Date: 08/21/09^M
[   25.616191] NET: Registered protocol family 16^M
[   27.765113] ACPI: bus type pci registered^M
[   28.795307] PCI: Using configuration type 1 for base access^M
[   61.793279] bio: create slab <bio-0> at 0^M
[   95.285367] ACPI: BIOS _OSI(Linux) query ignored^M
[  102.628227] ACPI: Interpreter enabled^M
[  102.630134] ACPI: (supports S0 S1 S5)^M
[  102.823225] ACPI: Using IOAPIC for interrupt routing^M
[  142.365090] ACPI: No dock devices found.^M
[  156.864036] ACPI: PCI Root Bridge [PCI0] (0000:00)^M
[  157.460654] pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI^M
[  157.463937] pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB^M
[  157.644036] pci 0000:00:11.0: transparent bridge^M
[  193.009036] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.^M
[  193.938036] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 14 15)^M
[  194.864036] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 14 15)^M
[  195.780036] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.^M

Something took 20 seconds between "ACPI: Core revision 20090625" and
"Setting APIC routing to flat"

This is a linux-next kernel, on vmware-server, with kmemcheck enabled.
Disabling kmemcheck seems to make all of this go away.  If not the ACPI
guys who should I be talking to?

A little bit later I finally see backtraces from NMIs because of RCU
stalls.  Anyone have ideas here?

[  213.168161] INFO: RCU detected CPU 0 stall (t=10004 jiffies)^M
[  213.168161] sending NMI to all CPUs:^M
[  213.168161] NMI backtrace for cpu 0^M
[  213.168161] CPU 0:^M
[  213.168161] Modules linked in:^M
[  213.168161] Pid: 1, comm: swapper Not tainted 2.6.31-rc6-next-20090821 #46 VMware Virtual Platform^M
[  213.168161] RIP: 0010:[<ffffffff81036ff1>]  [<ffffffff81036ff1>] flat_send_IPI_mask+0x81/0xe0^M
[  213.168161] RSP: 0018:ffff880006403d48  EFLAGS: 00000046^M
[  213.168161] RAX: 0000000000000c00 RBX: 0000000000000c00 RCX: 0000000000000001^M
[  213.168161] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000300^M
[  213.168161] RBP: ffff880006403d78 R08: 0000000000000002 R09: 0000000000010002^M
[  213.168161] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002^M
[  213.168161] R13: 0000000000000046 R14: 0000000000000001 R15: ffffffff8173e140^M
[  213.168161] FS:  0000000000000000(0000) GS:ffff880006400000(0000) knlGS:0000000000000000^M
[  213.168161] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b^M
[  213.168161] CR2: ffff88007f80605c CR3: 0000000001001000 CR4: 00000000000006f0^M
[  213.168161] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
[  213.168161] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400^M
[  213.168161] Call Trace:^M
[  213.168161]  <#DB[1]>  <<EOE>> Pid: 1, comm: swapper Not tainted 2.6.31-rc6-next-20090821 #46^M
[  213.168161] Call Trace:^M
[  213.168161]  <NMI>  [<ffffffff815353f1>] nmi_watchdog_tick+0x1a1/0x2f0^M
[  213.168161]  [<ffffffff81097f4d>] ? notify_die+0x3d/0x60^M
[  213.168161]  [<ffffffff81534338>] do_nmi+0xb8/0x2f0^M
[  213.168161]  [<ffffffff81533f40>] nmi+0x20/0x39^M
[  213.168161]  [<ffffffff81036ff1>] ? flat_send_IPI_mask+0x81/0xe0^M
[  213.168161]  <<EOE>>  <IRQ>  [<ffffffff810370ce>] flat_send_IPI_all+0x7e/0x90^M
[  213.168161]  [<ffffffff8103268c>] arch_trigger_all_cpu_backtrace+0x5c/0xb0^M
[  213.168161]  [<ffffffff810de45d>] __rcu_pending+0x8d/0x320^M
[  213.168161]  [<ffffffff810de726>] rcu_pending+0x36/0x80^M
[  213.168161]  [<ffffffff8107f62b>] ? run_local_timers+0x2b/0x50^M
[  213.168161]  [<ffffffff8107fa9d>] update_process_times+0x4d/0x90^M
[  213.168161]  [<ffffffff810a3393>] ? tick_do_update_jiffies64+0x83/0xf0^M
[  213.168161]  [<ffffffff810a36cb>] tick_sched_timer+0x6b/0xe0^M
[  213.168161]  [<ffffffff815337d5>] ? _spin_unlock+0x75/0x80^M
[  213.168161]  [<ffffffff810a3660>] ? tick_sched_timer+0x0/0xe0^M
[  213.168161]  [<ffffffff810957b6>] __run_hrtimer+0x76/0x100^M
[  213.168161]  [<ffffffff810958f1>] ? hrtimer_interrupt+0xb1/0x1b0^M
[  213.168161]  [<ffffffff8109592b>] hrtimer_interrupt+0xeb/0x1b0^M
[  213.168161]  [<ffffffff81031538>] smp_apic_timer_interrupt+0x78/0xd0^M
[  213.168161]  [<ffffffff81014e63>] apic_timer_interrupt+0x13/0x20^M
[  213.168161]  <EOI>  [<ffffffff81533270>] ? _write_unlock_irqrestore+0x90/0xb0^M
[  213.168161]  [<ffffffff81153eae>] ? create_object+0x1fe/0x2e0^M
[  213.168161]  [<ffffffff8104c684>] ? mark_shadow+0x74/0xf0^M
[  213.168161]  [<ffffffff8151843e>] ? kmemleak_alloc+0x6e/0xf0^M
[  213.168161]  [<ffffffff8114cc44>] ? __kmalloc_track_caller+0x164/0x2e0^M
[  213.168161]  [<ffffffff810f66e2>] ? trace_define_field+0x92/0x180^M
[  213.168161]  [<ffffffff8111ec26>] ? kstrdup+0x46/0x90^M
[  213.168161]  [<ffffffff810f66e2>] ? trace_define_field+0x92/0x180^M
[  213.168161]  [<ffffffff81057744>] ? ftrace_define_fields_sched_wait_task+0x1a4/0x1b0^M
[  213.168161]  [<ffffffff810f7342>] ? event_create_dir+0x1e2/0x440^M
[  213.168161]  [<ffffffff8182c15d>] ? event_trace_init+0x15d/0x260^M
[  213.168161]  [<ffffffff8182c000>] ? event_trace_init+0x0/0x260^M
[  213.168161]  [<ffffffff8100a07b>] ? do_one_initcall+0x4b/0x1b0^M
[  213.168161]  [<ffffffff810d84c0>] ? irq_to_desc+0x40/0x50^M
[  213.168161]  [<ffffffff81804140>] ? early_idt_handler+0x0/0x71^M
[  213.168161]  [<ffffffff81805280>] ? kernel_init+0x210/0x2e0^M
[  213.168161]  [<ffffffff8101539a>] ? child_rip+0xa/0x20^M
[  213.168161]  [<ffffffff81014cd4>] ? restore_args+0x0/0x30^M
[  213.168161]  [<ffffffff81805070>] ? kernel_init+0x0/0x2e0^M
[  213.168161]  [<ffffffff81015390>] ? child_rip+0x0/0x20^M

[  243.172246] INFO: RCU detected CPU 0 stall (t=40007 jiffies)^M
[  243.172246] sending NMI to all CPUs:^M
[  243.172246] NMI backtrace for cpu 0^M
[  243.172246] CPU 0:^M
[  243.172246] Modules linked in:^M
[  243.172246] Pid: 1, comm: swapper Not tainted 2.6.31-rc6-next-20090821 #46 VMware Virtual Platform^M
[  243.172246] RIP: 0010:[<ffffffff81036ff1>]  [<ffffffff81036ff1>] flat_send_IPI_mask+0x81/0xe0^M
[  243.172246] RSP: 0018:ffff880006403d48  EFLAGS: 00000046^M
[  243.172246] RAX: 0000000000000c00 RBX: 0000000000000c00 RCX: 0000000000000001^M
[  243.172246] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000300^M
[  243.172246] RBP: ffff880006403d78 R08: 0000000000000002 R09: 0000000000010002^M
[  243.172246] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002^M
[  243.172246] R13: 0000000000000046 R14: 0000000000000001 R15: ffffffff8173e140^M
[  243.172246] FS:  0000000000000000(0000) GS:ffff880006400000(0000) knlGS:0000000000000000^M
[  243.172246] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b^M
[  243.172246] CR2: ffff88007f80605c CR3: 0000000001001000 CR4: 00000000000006f0^M
[  243.172246] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
[  243.172246] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400^M
[  243.172246] Call Trace:^M
[  243.172246]  <#DB[1]>  <<EOE>> Pid: 1, comm: swapper Not tainted 2.6.31-rc6-next-20090821 #46^M
[  243.172246] Call Trace:^M
[  243.172246]  <NMI>  [<ffffffff815353f1>] nmi_watchdog_tick+0x1a1/0x2f0^M
[  243.172246]  [<ffffffff81097f4d>] ? notify_die+0x3d/0x60^M
[  243.172246]  [<ffffffff81534338>] do_nmi+0xb8/0x2f0^M
[  243.172246]  [<ffffffff81533f40>] nmi+0x20/0x39^M
[  243.172246]  [<ffffffff81036ff1>] ? flat_send_IPI_mask+0x81/0xe0^M
[  243.172246]  <<EOE>>  <IRQ>  [<ffffffff810370ce>] flat_send_IPI_all+0x7e/0x90^M
[  243.172246]  [<ffffffff8103268c>] arch_trigger_all_cpu_backtrace+0x5c/0xb0^M
[  243.172246]  [<ffffffff810de45d>] __rcu_pending+0x8d/0x320^M
[  243.172246]  [<ffffffff810de726>] rcu_pending+0x36/0x80^M
[  243.172246]  [<ffffffff8107f62b>] ? run_local_timers+0x2b/0x50^M
[  243.172246]  [<ffffffff8107fa9d>] update_process_times+0x4d/0x90^M
[  243.172246]  [<ffffffff810a3393>] ? tick_do_update_jiffies64+0x83/0xf0^M
[  243.172246]  [<ffffffff810a36cb>] tick_sched_timer+0x6b/0xe0^M
[  243.172246]  [<ffffffff815337d5>] ? _spin_unlock+0x75/0x80^M
[  243.172246]  [<ffffffff810a3660>] ? tick_sched_timer+0x0/0xe0^M
[  243.172246]  [<ffffffff810957b6>] __run_hrtimer+0x76/0x100^M
[  243.172246]  [<ffffffff810958f1>] ? hrtimer_interrupt+0xb1/0x1b0^M
[  243.172246]  [<ffffffff8109592b>] hrtimer_interrupt+0xeb/0x1b0^M
[  243.172246]  [<ffffffff81031538>] smp_apic_timer_interrupt+0x78/0xd0^M
[  243.172246]  [<ffffffff81014e63>] apic_timer_interrupt+0x13/0x20^M
[  243.172246]  <EOI>  [<ffffffff81533270>] ? _write_unlock_irqrestore+0x90/0xb0^M
[  243.172246]  [<ffffffff81153eae>] ? create_object+0x1fe/0x2e0^M
[  243.172246]  [<ffffffff8151843e>] ? kmemleak_alloc+0x6e/0xf0^M
[  243.172246]  [<ffffffff8114c5a3>] ? kmem_cache_alloc+0x153/0x200^M
[  243.172246]  [<ffffffff810fd08f>] ? init_preds+0xdf/0x280^M
[  243.172246]  [<ffffffff810f25de>] ? register_ftrace_event+0x7e/0x230^M
[  243.172246]  [<ffffffff8126b5e4>] ? ftrace_raw_init_event_block_remap+0x54/0x70^M
[  243.172246]  [<ffffffff8182c182>] ? event_trace_init+0x182/0x260^M
[  243.172246]  [<ffffffff8182c000>] ? event_trace_init+0x0/0x260^M
[  243.172246]  [<ffffffff8100a07b>] ? do_one_initcall+0x4b/0x1b0^M
[  243.172246]  [<ffffffff810d84c0>] ? irq_to_desc+0x40/0x50^M
[  243.172246]  [<ffffffff81804140>] ? early_idt_handler+0x0/0x71^M
[  243.172246]  [<ffffffff81805280>] ? kernel_init+0x210/0x2e0^M
[  243.172246]  [<ffffffff8101539a>] ? child_rip+0xa/0x20^M
[  243.172246]  [<ffffffff81014cd4>] ? restore_args+0x0/0x30^M
[  243.172246]  [<ffffffff81805070>] ? kernel_init+0x0/0x2e0^M
[  243.172246]  [<ffffffff81015390>] ? child_rip+0x0/0x20^M

