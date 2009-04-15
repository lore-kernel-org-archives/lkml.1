Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZDOU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZDOU7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZDOU73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:59:29 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58731 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZDOU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:59:28 -0400
Date: Wed, 15 Apr 2009 21:59:26 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: linux-kernel@vger.kernel.org
Subject: BUG: using rootfstype=ext4 causes oops
Message-ID: <20090415205926.GA28246@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using rootfstype=ext4 with today's linux-2.6.git causes a panic on my
two amd64 machines (haven't tested it on any others). The steps to
reproduce go something like:

- add rootfstype=ext4 kernel param
- boot
- do some I/O

My root fs is actually ext3 (if that's relevant).  Booting without
rootfstype=ext4 seems stable. Let me know if you need more info or patch
testing. This trace was obtained over netconsole:

[  281.714039] ------------[ cut here ]------------
[  281.714207] kernel BUG at mm/slub.c:2802!
[  281.714366] invalid opcode: 0000 [#1] PREEMPT SMP 
[  281.714709] last sysfs file: /sys/class/net/lo/operstate
[  281.714865] CPU 0 
[  281.715017] Modules linked in:
[  281.715017] Pid: 0, comm: swapper Not tainted 2.6.30-rc2-diogenes7 #1 System Product Name
[  281.715017] RIP: 0010:[<ffffffff802b3d4e>]  [<ffffffff802b3d4e>] kfree+0x12e/0x140
[  281.715017] RSP: 0018:ffff88000100ddf8  EFLAGS: 00010246
[  281.715017] RAX: 0100000000080000 RBX: ffff88003e828908 RCX: 0000000000000000
[  281.715017] RDX: ffffe20000000000 RSI: ffffe20000dac8c0 RDI: ffff88003e828908
[  281.715017] RBP: ffffffff8041f885 R08: 0000000002202000 R09: 0000000000000001
[  281.715017] R10: 0000000000000016 R11: ffffffff80224b60 R12: ffff88003e828908
[  281.715017] R13: 00000000000000e7 R14: 0000000000000000 R15: ffff88003e828908
[  281.715017] FS:  00007ffe72c136f0(0000) GS:ffff88000100a000(0000) knlGS:0000000000000000
[  281.715017] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  281.715017] CR2: 00007ffe725c48f0 CR3: 000000003f2ac000 CR4: 00000000000006e0
[  281.715017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  281.715017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  281.715017] Process swapper (pid: 0, threadinfo ffffffff806e2000, task ffffffff80688360)
[  281.715017] Stack:
[  281.715017]  ffff88003e828908 ffff88003fb8a800 0000000000000000 ffffffff8041f885
[  281.715017]  0000000000000050 ffff88003fb8a800 ffff88003e804d88 0000000000000000
[  281.715017]  0000000000000050 ffff88003fb8a800 ffff88003e804d88 ffffffff80423801
[  281.715017] Call Trace:
[  281.715017]  <IRQ> <0> [<ffffffff8041f885>] ? ide_complete_cmd+0x75/0x100
[  281.715017]  [<ffffffff80423801>] ? ide_finish_cmd+0x51/0xa0
[  281.715017]  [<ffffffff80424101>] ? task_no_data_intr+0xf1/0x170
[  281.715017]  [<ffffffff80424010>] ? task_no_data_intr+0x0/0x170
[  281.715017]  [<ffffffff8041f4ec>] ? ide_intr+0x1ec/0x250
[  281.715017]  [<ffffffff8026c3dd>] ? handle_IRQ_event+0xad/0x220
[  281.715017]  [<ffffffff8026e081>] ? handle_edge_irq+0xc1/0x160
[  281.715017]  [<ffffffff8020e167>] ? handle_irq+0x17/0x20
[  281.715017]  [<ffffffff8020d8d5>] ? do_IRQ+0x65/0xf0
[  281.715017]  [<ffffffff8020bd53>] ? ret_from_intr+0x0/0xa
[  281.715017]  <EOI> <0> [<ffffffff8021321b>] ? default_idle+0x9b/0x150
[  281.715017]  [<ffffffff802590f7>] ? notifier_call_chain+0x37/0x70
[  281.715017]  [<ffffffff8020a64a>] ? cpu_idle+0x5a/0xc0
[  281.715017]  [<ffffffff806ebc55>] ? start_kernel+0x342/0x408
[  281.715017]  [<ffffffff806eb378>] ? x86_64_start_kernel+0xe1/0xf2
[  281.715017] Code: 14 49 8b 00 49 89 04 d4 4d 89 20 eb cc e8 3b 1f 2c 00 e9 57 ff ff ff 66 a9 00 c0 66 90 74 48 89 f7 fd ff <0f> 0b eb fe 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 81 ef 
[  281.715017] RIP  [<ffffffff802b3d4e>] kfree+0x12e/0x140
[  281.715017]  RSP <ffff88000100ddf8>
[  281.715017] ---[ end trace 0e7df544696dff6e ]---
[  281.715017] Kernel panic - not syncing: Fatal exception in interrupt
[  281.715017] Pid: 0, comm: swapper Tainted: G      D    2.6.30-rc2-diogenes7 #1
[  281.715017] Call Trace:
[  281.715017]  <IRQ>  [<ffffffff80574c4a>] ? panic+0x95/0x152
[  281.715017]  [<ffffffff8020e371>] ? show_registers+0x91/0x2f0
[  281.715017]  [<ffffffff802596f9>] ? __atomic_notifier_call_chain+0x19/0x50
[  281.715017]  [<ffffffff80258f16>] ? up+0x16/0x50
[  281.715017]  [<ffffffff8023e195>] ? release_console_sem+0x1a5/0x1f0
[  281.715017]  [<ffffffff8020f77d>] ? oops_end+0x8d/0xa0
[  281.715017]  [<ffffffff8020d1c4>] ? do_invalid_op+0x84/0xa0
[  281.715017]  [<ffffffff802b3d4e>] ? kfree+0x12e/0x140
[  281.715017]  [<ffffffff80231350>] ? activate_task+0x40/0x70
[  281.715017]  [<ffffffff80239506>] ? try_to_wake_up+0x116/0x250
[  281.715017]  [<ffffffff8041f885>] ? ide_complete_cmd+0x75/0x100
[  281.715017]  [<ffffffff8020c145>] ? invalid_op+0x15/0x20
[  281.715017]  [<ffffffff8041f885>] ? ide_complete_cmd+0x75/0x100
[  281.715017]  [<ffffffff80224b60>] ? native_apic_mem_write+0x0/0x10
[  281.715017]  [<ffffffff802b3d4e>] ? kfree+0x12e/0x140
[  281.715017]  [<ffffffff802b3c9f>] ? kfree+0x7f/0x140
[  281.715017]  [<ffffffff8041f885>] ? ide_complete_cmd+0x75/0x100
[  281.715017]  [<ffffffff80423801>] ? ide_finish_cmd+0x51/0xa0
[  281.715017]  [<ffffffff80424101>] ? task_no_data_intr+0xf1/0x170
[  281.715017]  [<ffffffff80424010>] ? task_no_data_intr+0x0/0x170
[  281.715017]  [<ffffffff8041f4ec>] ? ide_intr+0x1ec/0x250
[  281.715017]  [<ffffffff8026c3dd>] ? handle_IRQ_event+0xad/0x220
[  281.715017]  [<ffffffff8026e081>] ? handle_edge_irq+0xc1/0x160
[  281.715017]  [<ffffffff8020e167>] ? handle_irq+0x17/0x20
[  281.715017]  [<ffffffff8020d8d5>] ? do_IRQ+0x65/0xf0
[  281.715017]  [<ffffffff8020bd53>] ? ret_from_intr+0x0/0xa
[  281.715017]  <EOI>  [<ffffffff8021321b>] ? default_idle+0x9b/0x150
[  281.715017]  [<ffffffff802590f7>] ? notifier_call_chain+0x37/0x70
[  281.715017]  [<ffffffff8020a64a>] ? cpu_idle+0x5a/0xc0
[  281.715017]  [<ffffffff806ebc55>] ? start_kernel+0x342/0x408
[  281.715017]  [<ffffffff806eb378>] ? x86_64_start_kernel+0xe1/0xf2

--
Andrew Price
