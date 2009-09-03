Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZICSV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZICSV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZICSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:21:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbZICSVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:21:55 -0400
Date: Thu, 3 Sep 2009 20:21:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:timers/core] clocksource: Resolve cpu
	hotplug dead lock with TSC unstable
Message-ID: <20090903182140.GA27441@elte.hu>
References: <tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org> <20090831101928.4c00c797@skybase> <alpine.LFD.2.00.0908311754590.19335@localhost.localdomain> <20090903181743.GA22431@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903181743.GA22431@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> -tip testing found the following boot crash on a 64-bit x86 system:
> 
> [    0.405247] initcall spawn_softlockup_task+0x0/0xa5 returned 0 after 0 usecs
> [    0.410004] calling  relay_init+0x0/0x40 @ 1
> [    0.420005] initcall relay_init+0x0/0x40 returned 0 after 0 usecs
> [    0.426355] lockdep: fixing up alternatives.
> [    0.430110] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.030000] Initializing CPU#1
> [    0.030000] masked ExtINT on CPU#1
> [    0.520060] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> [    0.530000] IP: [<ffffffff81071317>] queue_work_on+0x27/0x70
> [    0.530000] PGD 0 
> [    0.530000] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [    0.530000] last sysfs file: 
> [    0.530000] CPU 0 
> [    0.530000] Modules linked in:
> [    0.530000] Pid: 1, comm: swapper Not tainted 2.6.31-rc8-tip #1613         
> [    0.530000] RIP: 0010:[<ffffffff81071317>]  [<ffffffff81071317>] queue_work_on+0x27/0x70
> [    0.530000] RSP: 0018:ffff880009007d40  EFLAGS: 00010246
> [    0.530000] RAX: 0000000000000000 RBX: ffffffff81e1d0c0 RCX: 0000000000000000
> [    0.530000] RDX: ffffffff824a1fa0 RSI: 0000000000000000 RDI: 0000000000000000
> [    0.530000] RBP: ffff880009007d50 R08: 0000000000000000 R09: 0000000000000000
> [    0.530000] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000025cb39a8
> [    0.530000] R13: ffffffff824a0c40 R14: ffff880009007e50 R15: 0000000000000100
> [    0.530000] FS:  0000000000000000(0000) GS:ffff880009004000(0000) knlGS:0000000000000000
> [    0.530000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    0.530000] CR2: 0000000000000020 CR3: 0000000001001000 CR4: 00000000000006b0
> [    0.530000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.530000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.530000] Process swapper (pid: 1, threadinfo ffff88003f0da000, task ffff88003f0e0000)
> [    0.530000] Stack:
> [    0.530000]  ffffffff824a0c40 00000000b4b7426a ffff880009007d70 ffffffff8107157d
> [    0.530000] <0> ffffffff81083846 00000000b4b7426a ffff880009007d90 ffffffff810715c9
> [    0.530000] <0> 0000000000000000 00000000b4b7426a ffff880009007dc0 ffffffff81083927
> [    0.530000] Call Trace:
> [    0.530000]  <IRQ> 
> [    0.530000]  [<ffffffff8107157d>] queue_work+0x2d/0x50
> [    0.530000]  [<ffffffff81083846>] ? clocksource_watchdog+0x26/0x240
> [    0.530000]  [<ffffffff810715c9>] schedule_work+0x29/0x50
> [    0.530000]  [<ffffffff81083927>] clocksource_watchdog+0x107/0x240
> [    0.530000]  [<ffffffff81065eee>] run_timer_softirq+0x21e/0x380
> [    0.530000]  [<ffffffff81065e29>] ? run_timer_softirq+0x159/0x380
> [    0.530000]  [<ffffffff81083820>] ? clocksource_watchdog+0x0/0x240
> [    0.530000]  [<ffffffff810600aa>] __do_softirq+0x10a/0x200
> [    0.530000]  [<ffffffff8100cb1c>] call_softirq+0x1c/0x90
> [    0.530000]  [<ffffffff8100e955>] do_softirq+0x95/0xc0
> [    0.530000]  [<ffffffff8105f4c5>] irq_exit+0x75/0x90
> [    0.530000]  [<ffffffff81029c20>] smp_apic_timer_interrupt+0x80/0xd0
> [    0.530000]  [<ffffffff8100c4f3>] apic_timer_interrupt+0x13/0x20
> [    0.530000]  <EOI> 
> [    0.530000]  [<ffffffff812ff997>] ? delay_tsc+0x47/0x80
> [    0.530000]  [<ffffffff812ffab4>] ? __const_udelay+0x64/0x80
> [    0.530000]  [<ffffffff818b3fff>] ? do_boot_cpu+0x498/0x6b3
> [    0.530000]  [<ffffffff818b4567>] ? do_fork_idle+0x0/0x56
> [    0.530000]  [<ffffffff810468d2>] ? complete+0x32/0x80
> [    0.530000]  [<ffffffff818b4375>] ? native_cpu_up+0x15b/0x208
> [    0.530000]  [<ffffffff818b69d8>] ? _cpu_up+0xf3/0x1a4
> [    0.530000]  [<ffffffff818b6b4d>] ? cpu_up+0xc4/0xd7
> [    0.530000]  [<ffffffff821d3f97>] ? smp_init+0x118/0x126
> [    0.530000]  [<ffffffff821d40c7>] ? kernel_init+0x82/0xec
> [    0.530000]  [<ffffffff8100ca1a>] ? child_rip+0xa/0x20

btw., the crash itself seems to happen because we got a timer IRQ on 
CPU#0, which tries to queue work to CPU#1 but CPU#1 is not fully 
initialized yet?

	Ingo
