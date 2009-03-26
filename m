Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbZCZWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbZCZWEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbZCZWEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:04:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:42724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbZCZWEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:04:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,428,1233561600"; 
   d="scan'208";a="501154274"
Date: Thu, 26 Mar 2009 15:04:11 -0700
From: Chris Leech <christopher.leech@intel.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29 bug with SPARSE_IRQ + NUMA_MIGRATE_IRQ_DESC
Message-ID: <20090326220411.GA16286@cleech-lnx.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I traced down panics in 2.6.29 to these configuration settings.  It
looks to me like an irq_desc is being freed while handle_edge_irq is
running?

This is on x86_64, 2.6.29 running on a Fedora 10 system, irqbalance is
running.  It's pretty easy for me to reproduce with slab and spinlock
debugging turned on.  It catches an irq_desc that has been cleared to
POISON_FREE.  All I have to do is load ixgbe on a 2 port NIC, which
allocates 34 MSI-X vectors, and wait.

With sparse irqs disabled I don't see any problems.

- Chris

BUG: spinlock bad magic on CPU#2, swapper/0
general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:03:00.1/irq
CPU 2 
Modules linked in: ixgbe dca netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath uinput i2c_i801 pcspkr i2c_core e1000 iTCO_wdt iTCO_vendor_support [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.29-cdl-debug #13 
RIP: 0010:[<ffffffff811a4c34>]  [<ffffffff811a4c34>] spin_bug+0x77/0xab
RSP: 0018:ffff88003e59fee8  EFLAGS: 00010002
RAX: 00000000ffffffff RBX: 6b6b6b6b6b6b6b6b RCX: ffffffff814e7779
RDX: 0000000029c429c3 RSI: 0000000000000001 RDI: 0000000000000046
RBP: ffff88003e59ff08 R08: 0000000000000002 R09: 000000006b6b6b6b
R10: ffffffff814d82ee R11: 000000000000000a R12: ffff8800355282b8
R13: ffffffff814d82c0 R14: ffff8800355282b8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88003fe72708(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fc2dfe20000 CR3: 000000007c057000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88007d196000, task ffff88003e5a0000)
Stack:
 ffff88003e59ff28 ffff8800355282b8 0000000000000050 ffff88007d1b5b58
 ffff88003e59ff28 ffffffff811a4c89 ffff8800355282b8 ffff8800355282b8
 ffff88003e59ff48 ffffffff81394529 ffff880035528248 ffff880035528248
Call Trace:
 <IRQ> <0> [<ffffffff811a4c89>] _raw_spin_unlock+0x21/0x94
 [<ffffffff81394529>] _spin_unlock+0x2b/0x2f
 [<ffffffff8109a14b>] handle_edge_irq+0xd1/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI> <0> [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813979b7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8138db39>] ? start_secondary+0x1b0/0x1b5
Code: 00 48 8d 88 e8 04 00 00 31 c0 65 8b 14 25 24 00 00 00 e8 f9 ca 1e 00 83 c8 ff 48 85 db 45 8b 4c 24 08 48 c7 c1 79 77 4e 81 74 0d <8b> 83 98 02 00 00 48 8d 8b e8 04 00 00 41 8b 54 24 04 41 89 c0 
RIP  [<ffffffff811a4c34>] spin_bug+0x77/0xab
 RSP <ffff88003e59fee8>
---[ end trace 95ba74f6171957f6 ]---
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------
WARNING: at /home/cleech/linux-2.6/kernel/smp.c:329 smp_call_function_many+0x46/0x259()
Modules linked in: ixgbe dca netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath uinput i2c_i801 pcspkr i2c_core e1000 iTCO_wdt iTCO_vendor_support [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G      D    2.6.29-cdl-debug #13
Call Trace:
 <IRQ>  [<ffffffff8104d176>] warn_slowpath+0xb6/0xf2
 [<ffffffff811a1365>] ? delay_tsc+0x2b/0x5d
 [<ffffffff811a4cf6>] ? _raw_spin_unlock+0x8e/0x94
 [<ffffffff81066044>] ? down_trylock+0x14/0x39
 [<ffffffff8108326d>] ? crash_kexec+0x20/0xf4
 [<ffffffff81392a04>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff81070772>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff81070820>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81392a04>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff810788d3>] smp_call_function_many+0x46/0x259
 [<ffffffff810183bb>] ? stop_this_cpu+0x0/0x36
 [<ffffffff81070772>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff81070820>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff813944e7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81078b0b>] smp_call_function+0x25/0x29
 [<ffffffff81022e59>] native_smp_send_stop+0x27/0x6f
 [<ffffffff8139166a>] panic+0x89/0x138
 [<ffffffff81066062>] ? down_trylock+0x32/0x39
 [<ffffffff81395b82>] oops_end+0xb9/0xc9
 [<ffffffff81014ca9>] die+0x5a/0x63
 [<ffffffff8139576b>] do_general_protection+0x11e/0x127
 [<ffffffff81394e65>] general_protection+0x25/0x30
 [<ffffffff811a4c34>] ? spin_bug+0x77/0xab
 [<ffffffff811a4c20>] ? spin_bug+0x63/0xab
 [<ffffffff811a4c89>] _raw_spin_unlock+0x21/0x94
 [<ffffffff81394529>] _spin_unlock+0x2b/0x2f
 [<ffffffff8109a14b>] handle_edge_irq+0xd1/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813979b7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8138db39>] ? start_secondary+0x1b0/0x1b5
---[ end trace 95ba74f6171957f7 ]---
 [<ffffffff8109a16c>] handle_edge_irq+0xf2/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813979b7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8138db39>] ? start_secondary+0x1b0/0x1b5
handlers:
general protection fault: 0000 [#2] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:03:00.1/irq
CPU 6 
Modules linked in: ixgbe dca netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath uinput i2c_i801 pcspkr i2c_core e1000 iTCO_wdt iTCO_vendor_support [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G      D W  2.6.29-cdl-debug #13 
RIP: 0010:[<ffffffff81099a4b>]  [<ffffffff81099a4b>] __report_bad_irq+0x51/0x8c
RSP: 0018:ffff88007d22bef8  EFLAGS: 00010002
RAX: 000000000000000d RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000001
RDX: 0000000030af30ae RSI: ffffffff813944e7 RDI: 0000000000000046
RBP: ffff88007d22bf08 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000096 R11: 0000000000000000 R12: ffff8800355286d8
R13: ffff88007b478190 R14: 0000000000000001 R15: 0000000000000052
FS:  0000000000000000(0000) GS:ffff88003fe73388(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fc2e366b000 CR3: 000000007c057000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88003e67c000, task ffff88003e682340)
Stack:
 0000000000000000 ffff8800355286d8 ffff88007d22bf48 ffffffff81099ba3
 ffff88007d22bf48 ffff8800355286d8 0000000000000052 ffff88007b478190
 ffff880035528748 0000000000000000 ffff88007d22bf78 ffffffff8109a16c
Call Trace:
 <IRQ> <0> [<ffffffff81099ba3>] note_interrupt+0x11d/0x186
 [<ffffffff8109a16c>] handle_edge_irq+0xf2/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI> <0> [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813979b7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8138db39>] ? start_secondary+0x1b0/0x1b5
Code: eb 10 89 fe 31 c0 48 c7 c7 18 2d 4c 81 e8 e7 7c 2f 00 e8 2a 7b 2f 00 48 c7 c7 59 2d 4c 81 31 c0 e8 d4 7c 2f 00 48 8b 5b 48 eb 32 <48> 8b 33 48 c7 c7 67 2d 4c 81 31 c0 e8 bd 7c 2f 00 48 8b 33 48 
RIP  [<ffffffff81099a4b>] __report_bad_irq+0x51/0x8c
 RSP <ffff88007d22bef8>
---[ end trace 95ba74f6171957f8 ]---
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------
WARNING: at /home/cleech/linux-2.6/kernel/smp.c:329 smp_call_function_many+0x46/0x259()
Modules linked in: ixgbe dca netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath uinput i2c_i801 pcspkr i2c_core e1000 iTCO_wdt iTCO_vendor_support [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G      D W  2.6.29-cdl-debug #13
Call Trace:
 <IRQ>  [<ffffffff8104d176>] warn_slowpath+0xb6/0xf2
 [<ffffffff81072cf9>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff8108326d>] ? crash_kexec+0x20/0xf4
 [<ffffffff81392a04>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff81070772>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff81070820>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81392a04>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff810788d3>] smp_call_function_many+0x46/0x259
 [<ffffffff81070772>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810183bb>] ? stop_this_cpu+0x0/0x36
 [<ffffffff81070820>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff813944e7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8104d997>] ? release_console_sem+0x1ca/0x1ff
 [<ffffffff81078b0b>] smp_call_function+0x25/0x29
 [<ffffffff81022e59>] native_smp_send_stop+0x27/0x6f
 [<ffffffff8139166a>] panic+0x89/0x138
 [<ffffffff813944e7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81395b82>] oops_end+0xb9/0xc9
 [<ffffffff81014ca9>] die+0x5a/0x63
 [<ffffffff8139576b>] do_general_protection+0x11e/0x127
 [<ffffffff81394e65>] general_protection+0x25/0x30
 [<ffffffff813944e7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81099a4b>] ? __report_bad_irq+0x51/0x8c
 [<ffffffff81099a45>] ? __report_bad_irq+0x4b/0x8c
 [<ffffffff81099ba3>] note_interrupt+0x11d/0x186
 [<ffffffff8109a16c>] handle_edge_irq+0xf2/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813979b7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8138db39>] ? start_secondary+0x1b0/0x1b5
---[ end trace 95ba74f6171957f9 ]---
------------[ cut here ]------------
WARNING: at /home/cleech/linux-2.6/kernel/smp.c:226 smp_call_function_single+0x4c/0x143()
Modules linked in: ixgbe dca netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath uinput i2c_i801 pcspkr i2c_core e1000 iTCO_wdt iTCO_vendor_support [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G      D W  2.6.29-cdl-debug #13
Call Trace:
 <IRQ>  [<ffffffff8104d176>] warn_slowpath+0xb6/0xf2
 [<ffffffff813915d8>] ? dump_stack+0x77/0x80
 [<ffffffff8104d190>] ? warn_slowpath+0xd0/0xf2
 [<ffffffff81072cf9>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff81078796>] smp_call_function_single+0x4c/0x143
 [<ffffffff81070820>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81392a04>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff81078956>] smp_call_function_many+0xc9/0x259
 [<ffffffff81070772>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810183bb>] ? stop_this_cpu+0x0/0x36
 [<ffffffff81070820>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff813944e7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff8104d997>] ? release_console_sem+0x1ca/0x1ff
 [<ffffffff81078b0b>] smp_call_function+0x25/0x29
 [<ffffffff81022e59>] native_smp_send_stop+0x27/0x6f
 [<ffffffff8139166a>] panic+0x89/0x138
 [<ffffffff813944e7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81395b82>] oops_end+0xb9/0xc9
 [<ffffffff81014ca9>] die+0x5a/0x63
 [<ffffffff8139576b>] do_general_protection+0x11e/0x127
 [<ffffffff81394e65>] general_protection+0x25/0x30
 [<ffffffff813944e7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81099a4b>] ? __report_bad_irq+0x51/0x8c
 [<ffffffff81099a45>] ? __report_bad_irq+0x4b/0x8c
 [<ffffffff81099ba3>] note_interrupt+0x11d/0x186
 [<ffffffff8109a16c>] handle_edge_irq+0xf2/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813979b7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8138db39>] ? start_secondary+0x1b0/0x1b5
---[ end trace 95ba74f6171957fa ]---
