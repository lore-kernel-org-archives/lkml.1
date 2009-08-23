Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbZHWPAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbZHWPAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 11:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933613AbZHWPAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 11:00:09 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62539 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933665AbZHWPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 11:00:08 -0400
Subject: Re: [PATCH] kmemleak: Fix scheduling-while-atomic bug
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <d82e647a0908221948q380c3365v827c93c549d5f084@mail.gmail.com>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1247059996.6595.36.camel@pc1117.cambridge.arm.com>
	 <d82e647a0908221948q380c3365v827c93c549d5f084@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Sun, 23 Aug 2009 15:59:50 +0100
Message-Id: <1251039590.27032.8.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2009 14:59:51.0920 (UTC) FILETIME=[5E01EF00:01CA2402]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2009-08-23 at 10:48 +0800, Ming Lei wrote:
> 2009/7/8 Catalin Marinas <catalin.marinas@arm.com>:
> > kmemleak: Add more cond_resched() calls in the scanning thread
> >
> > From: Catalin Marinas <catalin.marinas@arm.com>
> >
> > Following recent fix to no longer reschedule in the scan_block()
> > function, the system may become unresponsive with !PREEMPT. This patch
> > re-adds the cond_resched() call to scan_block() but conditioned by the
> > allow_resched parameter.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
[...]
> This still exits in 2.6.31-rc7 if kmemcheck is enabled, and isn't  the patch
> merged into mainline?

Is this kmemcheck or kmemleak (two different things with similar names)?

> [    0.006569] ACPI: Core revision 20090521
> [    0.011476] BUG: scheduling while atomic: swapper/0/0x10000002
> [    0.011558] no locks held by swapper/0.
> [    0.011561] Modules linked in:
> [    0.011566] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
> [    0.011569] Call Trace:
> [    0.011577]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
> [    0.011584]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
> [    0.011590]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
> [    0.011596]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
> [    0.011600]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
> [    0.011604]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
> [    0.011609]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
> [    0.011614]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
> [    0.011620]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
> [    0.011625]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
> [    0.011630]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
> [    0.011635]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
> [    0.011640]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
> [    0.011645]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
> [    0.011650]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
> [    0.011656]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
> [    0.011661]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
> [    0.011666]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
> [    0.011670]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
> [    0.011675]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106

I looked at the traces and there are no kmemleak calls. It's either that
kmemleak is disabled or the error is not on a kmemleak path. It looks
more like an ACPI bug to me.

Can you try only with slab debugging enabled (without kmemleak or
kmemcheck)? IIRC someone else reported a similar issue a few weeks ago.

-- 
Catalin

