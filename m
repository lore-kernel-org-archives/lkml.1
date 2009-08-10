Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZHJSqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZHJSqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZHJSp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:45:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZHJSp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:45:58 -0400
Date: Mon, 10 Aug 2009 20:45:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
Message-ID: <20090810184527.GA9601@elte.hu>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com> <20090802111453.GA24927@elte.hu> <1249919718.10848.55.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249919718.10848.55.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> Hi Ingo,
> 
> On Sun, 2009-08-02 at 13:14 +0200, Ingo Molnar wrote:
> > hm, some recent kmemleak patch is causing frequent hard and 
> > soft lockups in -tip testing (-rc5 based).
> 
> Thanks for reporting this. It shouldn't be caused by the patch 
> mentioned in the subject as this only deals with reading the seq 
> file which doesn't seem to be the case here.

Since i turned off kmemleak in -tip completely via the patch below i 
havent had a single such lockup.

Have you tried the config i sent - does it work fine for you? For me 
it locks up on various boxes within a couple of minutes - without 
doing anything particular beyond building a kernel or so.

	Ingo

------------->
>From da0ce636e98cc3aababc0cb93c2dc5b6e9421a22 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 2 Aug 2009 12:59:58 +0200
Subject: [PATCH] kmemleak: Disable it for now

kmemleak causes various lockups on 64-bit x86 kernels:

Kernel 2.6.31-rc5-tip-00864-ged6f5fe-dirty on an x86_64

mercury login:

[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff82d2b560>]  [<ffffffff82d2b560>] page_fault+0x0/0x30
[  177.093253] RSP: 0018:ffff880036043db0  EFLAGS: 00000046
[  177.093253] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  177.093253] RDX: ffff88003f84a000 RSI: ffff880024000000 RDI: ffff880020000000
[  177.093253] RBP: ffff880036043e20 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: 0000000000000000 R14: ffff88003f84a000 R15: ffff880023fffff9
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff82d2b560>] ? page_fault+0x0/0x30
[  177.093253]  <<EOE>>  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff8112ba4f>]  [<ffffffff8112ba4f>] time_hardirqs_off+0x3e/0x47
[  181.588015] RSP: 0018:ffff880005392c38  EFLAGS: 00000046
[  181.588015] RAX: 0000000000000000 RBX: ffffffff83c1a020 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062f09 RDI: ffffffff810d666d
[  181.588015] RBP: ffff880005392c48 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: ffffffff81062f09
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff810d666d>] ? trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff8112ba4f>] ? time_hardirqs_off+0x3e/0x47
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff810d659a>] trace_hardirqs_off_caller+0x32/0xe5
[  181.588015]  [<ffffffff810d666d>] trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff81062f09>] _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b
[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff8118bd42>]  [<ffffffff8118bd42>] scan_block+0x40/0x123
[  177.093253] RSP: 0018:ffff880036043de0  EFLAGS: 00010046
[  177.093253] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  177.093253] RDX: ffff88003f84a000 RSI: ffff880024000000 RDI: ffff880020000000
[  177.093253] RBP: ffff880036043e20 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: 0000000000000000 R14: ffff88003f84a000 R15: ffff880023fffff9
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  <<EOE>>  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff8112ba4f>]  [<ffffffff8112ba4f>] time_hardirqs_off+0x3e/0x47
[  181.588015] RSP: 0018:ffff880005392c38  EFLAGS: 00000046
[  181.588015] RAX: 0000000000000000 RBX: ffffffff83c1a020 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062f09 RDI: ffffffff810d666d
[  181.588015] RBP: ffff880005392c48 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: ffffffff81062f09
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff810d666d>] ? trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff8112ba4f>] ? time_hardirqs_off+0x3e/0x47
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff810d659a>] trace_hardirqs_off_caller+0x32/0xe5
[  181.588015]  [<ffffffff810d666d>] trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff81062f09>] _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b
[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff8118bd42>]  [<ffffffff8118bd42>] scan_block+0x40/0x123
[  177.093253] RSP: 0018:ffff880036043de0  EFLAGS: 00010046
[  177.093253] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  177.093253] RDX: ffff88003f84a000 RSI: ffff880024000000 RDI: ffff880020000000
[  177.093253] RBP: ffff880036043e20 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: 0000000000000000 R14: ffff88003f84a000 R15: ffff880023fffff9
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  <<EOE>>  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff8112ba46>]  [<ffffffff8112ba46>] time_hardirqs_off+0x35/0x47
[  181.588015] RSP: 0018:ffff880005392c38  EFLAGS: 00000096
[  181.588015] RAX: 3d2eef9f2ecb6a80 RBX: ffffffff83c1a020 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062f09 RDI: ffffffff810d666d
[  181.588015] RBP: ffff880005392c48 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: ffffffff81062f09
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff810d666d>] ? trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff8112ba46>] ? time_hardirqs_off+0x35/0x47
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff810d659a>] trace_hardirqs_off_caller+0x32/0xe5
[  181.588015]  [<ffffffff810d666d>] trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff81062f09>] _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b
[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff8118bd42>]  [<ffffffff8118bd42>] scan_block+0x40/0x123
[  177.093253] RSP: 0018:ffff880036043de0  EFLAGS: 00010046
[  177.093253] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  177.093253] RDX: ffff88003f84a000 RSI: ffff880024000000 RDI: ffff880020000000
[  177.093253] RBP: ffff880036043e20 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: 0000000000000000 R14: ffff88003f84a000 R15: ffff880023fffff9
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  <<EOE>>  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff8112ba4f>]  [<ffffffff8112ba4f>] time_hardirqs_off+0x3e/0x47
[  181.588015] RSP: 0018:ffff880005392c38  EFLAGS: 00000046
[  181.588015] RAX: 0000000000000000 RBX: ffffffff83c1a020 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062f09 RDI: ffffffff810d666d
[  181.588015] RBP: ffff880005392c48 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: ffffffff81062f09
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff810d666d>] ? trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff8112ba4f>] ? time_hardirqs_off+0x3e/0x47
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff810d659a>] trace_hardirqs_off_caller+0x32/0xe5
[  181.588015]  [<ffffffff810d666d>] trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff81062f09>] _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b
[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff8118bd42>]  [<ffffffff8118bd42>] scan_block+0x40/0x123
[  177.093253] RSP: 0018:ffff880036043de0  EFLAGS: 00010046
[  177.093253] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  177.093253] RDX: ffff88003f84a000 RSI: ffff880024000000 RDI: ffff880020000000
[  177.093253] RBP: ffff880036043e20 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: 0000000000000000 R14: ffff88003f84a000 R15: ffff880023fffff9
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  <<EOE>>  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff8112ba46>]  [<ffffffff8112ba46>] time_hardirqs_off+0x35/0x47
[  181.588015] RSP: 0018:ffff880005392c38  EFLAGS: 00000096
[  181.588015] RAX: 3d2eef9f2ecb6a80 RBX: ffffffff83c1a020 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062f09 RDI: ffffffff810d666d
[  181.588015] RBP: ffff880005392c48 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: ffffffff81062f09
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff810d666d>] ? trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff8112ba46>] ? time_hardirqs_off+0x35/0x47
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff810d659a>] trace_hardirqs_off_caller+0x32/0xe5
[  181.588015]  [<ffffffff810d666d>] trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff81062f09>] _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b
[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff82d2b560>]  [<ffffffff82d2b560>] page_fault+0x0/0x30
[  177.093253] RSP: 0018:ffff880036043db0  EFLAGS: 00000046
[  177.093253] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  177.093253] RDX: ffff88003f84a000 RSI: ffff880024000000 RDI: ffff880020000000
[  177.093253] RBP: ffff880036043e20 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: 0000000000000000 R14: ffff88003f84a000 R15: ffff880023fffff9
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff82d2b560>] ? page_fault+0x0/0x30
[  177.093253]  <<EOE>>  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff81062f02>]  [<ffffffff81062f02>] _flat_send_IPI_mask+0x99/0xd2
[  181.588015] RSP: 0018:ffff880005392ca8  EFLAGS: 00000046
[  181.588015] RAX: 0000000000000c00 RBX: 0000000000000c00 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062ea8 RDI: 0000000000000046
[  181.588015] RBP: ffff880005392cd8 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: 0000000000000002
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062ea8>] ? _flat_send_IPI_mask+0x3f/0xd2
[  181.588015]  [<ffffffff81062f02>] ? _flat_send_IPI_mask+0x99/0xd2
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b
[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff82d2dec8>]  [<ffffffff82d2dec8>] do_page_fault+0x68/0x359
[  177.093253] RSP: 0018:ffff880036043cd8  EFLAGS: 00000046
[  177.093253] RAX: 0000000000000060 RBX: 0000000000000001 RCX: 000000008103cf40
[  177.093253] RDX: ffff88003f84a000 RSI: 0000000000000000 RDI: ffff880036043d38
[  177.093253] RBP: ffff880036043d28 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: ffff880036043d38 R14: 0000000000000000 R15: ffff880035c33000
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff82d2dec8>] ? do_page_fault+0x68/0x359
[  177.093253]  <<EOE>>  [<ffffffff82d2a187>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  177.093253]  [<ffffffff82d2b585>] page_fault+0x25/0x30
[  177.093253]  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff8112ba4f>]  [<ffffffff8112ba4f>] time_hardirqs_off+0x3e/0x47
[  181.588015] RSP: 0018:ffff880005392c38  EFLAGS: 00000046
[  181.588015] RAX: 0000000000000000 RBX: ffffffff83c1a020 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062f09 RDI: ffffffff810d666d
[  181.588015] RBP: ffff880005392c48 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: ffffffff81062f09
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff810d666d>] ? trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff8112ba4f>] ? time_hardirqs_off+0x3e/0x47
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff810d659a>] trace_hardirqs_off_caller+0x32/0xe5
[  181.588015]  [<ffffffff810d666d>] trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff81062f09>] _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b
[  181.588015] SysRq : Show backtrace of all active CPUs
[  181.588015] sending NMI to all CPUs:
[  177.093253] NMI backtrace for cpu 1
[  177.093253] CPU 1:
[  177.093253] Modules linked in:
[  177.093253] Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  177.093253] RIP: 0010:[<ffffffff82d2dec8>]  [<ffffffff82d2dec8>] do_page_fault+0x68/0x359
[  177.093253] RSP: 0018:ffff880036043cd8  EFLAGS: 00000046
[  177.093253] RAX: 0000000000000060 RBX: 0000000000000001 RCX: 000000008103cf40
[  177.093253] RDX: ffff88003f84a000 RSI: 0000000000000000 RDI: ffff880036043d38
[  177.093253] RBP: ffff880036043d28 R08: 0000000000000002 R09: 0000000000000000
[  177.093253] R10: 00000000000001cd R11: 000000002ef9ac36 R12: ffff880020000000
[  177.093253] R13: ffff880036043d38 R14: 0000000000000000 R15: ffff880035c33000
[  177.093253] FS:  00007f7900741780(0000) GS:ffff880005572000(0000) knlGS:00000000f7edf6c0
[  177.093253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  177.093253] CR2: ffff880020000000 CR3: 000000002c06f000 CR4: 00000000000006e0
[  177.093253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.093253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.093253] Call Trace:
[  177.093253]  <#DB[1]>  <<EOE>> Pid: 6446, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  177.093253] Call Trace:
[  177.093253]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  177.093253]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  177.093253]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  177.093253]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  177.093253]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  177.093253]  [<ffffffff82d2dec8>] ? do_page_fault+0x68/0x359
[  177.093253]  <<EOE>>  [<ffffffff82d2a187>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  177.093253]  [<ffffffff82d2b585>] page_fault+0x25/0x30
[  177.093253]  [<ffffffff8118bd42>] ? scan_block+0x40/0x123
[  177.093253]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  177.093253]  [<ffffffff8118c17e>] kmemleak_scan+0x359/0x61e
[  177.093253]  [<ffffffff8118be25>] ? kmemleak_scan+0x0/0x61e
[  177.093253]  [<ffffffff8118cbed>] ? kmemleak_scan_thread+0x0/0xd0
[  177.093253]  [<ffffffff8118cc62>] kmemleak_scan_thread+0x75/0xd0
[  177.093253]  [<ffffffff810c157c>] kthread+0xa8/0xb0
[  177.093253]  [<ffffffff8103d5ca>] child_rip+0xa/0x20
[  177.093253]  [<ffffffff8103cf10>] ? restore_args+0x0/0x30
[  177.093253]  [<ffffffff810c14b3>] ? kthreadd+0x12e/0x14f
[  177.093253]  [<ffffffff810c14d4>] ? kthread+0x0/0xb0
[  177.093253]  [<ffffffff8103d5c0>] ? child_rip+0x0/0x20
[  181.588015] NMI backtrace for cpu 0
[  181.588015] CPU 0:
[  181.588015] Modules linked in:
[  181.588015] Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81 System Product Name
[  181.588015] RIP: 0010:[<ffffffff8112ba46>]  [<ffffffff8112ba46>] time_hardirqs_off+0x35/0x47
[  181.588015] RSP: 0018:ffff880005392c38  EFLAGS: 00000096
[  181.588015] RAX: 3d2eef9f2ecb6a80 RBX: ffffffff83c1a020 RCX: 0000000000000000
[  181.588015] RDX: 0000000000000000 RSI: ffffffff81062f09 RDI: ffffffff810d666d
[  181.588015] RBP: ffff880005392c48 R08: 3d2eef9f2ecb6a80 R09: 0000000000000000
[  181.588015] R10: 0000000000000000 R11: 0000000000018600 R12: ffffffff81062f09
[  181.588015] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000003
[  181.588015] FS:  00007fcfa49ab780(0000) GS:ffff88000538f000(0000) knlGS:00000000f7edf6c0
[  181.588015] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  181.588015] CR2: 00007fcfa3d7212f CR3: 000000002cd34000 CR4: 00000000000006f0
[  181.588015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.588015] DR3: ffffffff84fa69ac DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.588015] Call Trace:
[  181.588015]  <#DB[1]>  <<EOE>> Pid: 0, comm: swapper Tainted: G        W  2.6.31-rc5-tip-00864-ged6f5fe-dirty #81
[  181.588015] Call Trace:
[  181.588015]  <NMI>  [<ffffffff82d2cc90>] nmi_watchdog_tick+0xe8/0x200
[  181.588015]  [<ffffffff810c76c8>] ? notify_die+0x3d/0x53
[  181.588015]  [<ffffffff82d2bf4a>] default_do_nmi+0x84/0x22b
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff82d2c164>] do_nmi+0x73/0xcc
[  181.588015]  [<ffffffff82d2b8a0>] nmi+0x20/0x39
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81062f09>] ? _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff810d666d>] ? trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff8112ba46>] ? time_hardirqs_off+0x35/0x47
[  181.588015]  <<EOE>>  <IRQ>  [<ffffffff810d659a>] trace_hardirqs_off_caller+0x32/0xe5
[  181.588015]  [<ffffffff810d666d>] trace_hardirqs_off+0x20/0x36
[  181.588015]  [<ffffffff81062f09>] _flat_send_IPI_mask+0xa0/0xd2
[  181.588015]  [<ffffffff81063002>] flat_send_IPI_all+0x35/0x83
[  181.588015]  [<ffffffff8105e888>] __trigger_all_cpu_backtrace+0x60/0xa5
[  181.588015]  [<ffffffff8181a2ff>] sysrq_handle_showallcpus+0x21/0x37
[  181.588015]  [<ffffffff81819f5f>] __handle_sysrq+0xcf/0x185
[  181.588015]  [<ffffffff8181a0bf>] handle_sysrq+0x38/0x4e
[  181.588015]  [<ffffffff81909fcb>] receive_chars+0x14c/0x29f
[  181.588015]  [<ffffffff82d2ac48>] ? _spin_lock_irqsave+0x8a/0xac
[  181.588015]  [<ffffffff8190a166>] serial8250_handle_port+0x48/0x84
[  181.588015]  [<ffffffff8190a216>] serial8250_interrupt+0x74/0x11d
[  181.588015]  [<ffffffff8110ca28>] ? handle_edge_irq+0xd5/0x13c
[  181.588015]  [<ffffffff8110a68f>] handle_IRQ_event+0x6b/0x181
[  181.588015]  [<ffffffff8110ca33>] handle_edge_irq+0xe0/0x13c
[  181.588015]  [<ffffffff8103f53e>] handle_irq+0x9d/0xbf
[  181.588015]  [<ffffffff8103b28c>] ? exit_idle+0x51/0x67
[  181.588015]  [<ffffffff82d304ba>] do_IRQ+0x72/0xe8
[  181.588015]  [<ffffffff8103ce53>] ret_from_intr+0x0/0x16
[  181.588015]  <EOI>  [<ffffffff8106ae95>] ? native_safe_halt+0xb/0xd
[  181.588015]  [<ffffffff8104516a>] ? default_idle+0x6c/0xab
[  181.588015]  [<ffffffff8112bdbd>] ? stop_critical_timings+0x3d/0x54
[  181.588015]  [<ffffffff8103b3e1>] ? cpu_idle+0xf1/0x13e
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff82c1db4a>] ? rest_init+0x7e/0x94
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84122190>] ? start_kernel+0x3af/0x3cc
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff84121140>] ? early_idt_handler+0x0/0x71
[  181.588015]  [<ffffffff841212ce>] ? x86_64_start_reservations+0xb9/0xd4
[  181.588015]  [<ffffffff84121000>] ? __init_begin+0x0/0x140
[  181.588015]  [<ffffffff84121441>] ? x86_64_start_kernel+0x158/0x17b

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b9c3be4..ea7c4ac 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -342,6 +342,7 @@ config DEBUG_KMEMLEAK
 	select DEBUG_FS if SYSFS
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
+	depends on 0
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
