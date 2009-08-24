Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZHXKDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZHXKDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 06:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZHXKDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 06:03:31 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38762 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZHXKDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 06:03:30 -0400
Subject: ACPI scheduling while atomic (was: Re: [PATCH] kmemleak: Fix
	scheduling-while-atomic bug)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org
In-Reply-To: <d82e647a0908231710h35feb992q8ee503187faac02d@mail.gmail.com>
References: <200907010300.n6130rRf026194@hera.kernel.org>
	 <20090701075332.GA17252@elte.hu>
	 <1246439937.8492.18.camel@pc1117.cambridge.arm.com>
	 <20090701093015.GA6862@elte.hu>
	 <1247059996.6595.36.camel@pc1117.cambridge.arm.com>
	 <d82e647a0908221948q380c3365v827c93c549d5f084@mail.gmail.com>
	 <1251039590.27032.8.camel@pc1117.cambridge.arm.com>
	 <d82e647a0908231710h35feb992q8ee503187faac02d@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 24 Aug 2009 11:02:33 +0100
Message-Id: <1251108153.28030.21.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Aug 2009 10:02:34.0816 (UTC) FILETIME=[00AD9C00:01CA24A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 08:10 +0800, Ming Lei wrote:
> 2009/8/23 Catalin Marinas <catalin.marinas@arm.com>:
> > On Sun, 2009-08-23 at 10:48 +0800, Ming Lei wrote:
> >> [    0.006569] ACPI: Core revision 20090521
> >> [    0.011476] BUG: scheduling while atomic: swapper/0/0x10000002
> >> [    0.011558] no locks held by swapper/0.
> >> [    0.011561] Modules linked in:
> >> [    0.011566] Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #141
> >> [    0.011569] Call Trace:
> >> [    0.011577]  [<ffffffff81070bb7>] ? __debug_show_held_locks+0x22/0x24
> >> [    0.011584]  [<ffffffff8103d4ba>] __schedule_bug+0x77/0x7c
> >> [    0.011590]  [<ffffffff812da32f>] schedule+0xd6/0xa3f
> >> [    0.011596]  [<ffffffff810e4b9b>] ? kmem_cache_free+0xe2/0x158
> >> [    0.011600]  [<ffffffff810717e2>] ? trace_hardirqs_on_caller+0x12d/0x158
> >> [    0.011604]  [<ffffffff8107181a>] ? trace_hardirqs_on+0xd/0xf
> >> [    0.011609]  [<ffffffff8103e3f0>] __cond_resched+0x29/0x47
> >> [    0.011614]  [<ffffffff812dae24>] _cond_resched+0x29/0x34
> >> [    0.011620]  [<ffffffff811da90a>] acpi_ps_complete_op+0x246/0x25c
> >> [    0.011625]  [<ffffffff811db024>] acpi_ps_parse_loop+0x704/0x860
> >> [    0.011630]  [<ffffffff811da200>] acpi_ps_parse_aml+0x9f/0x2de
> >> [    0.011635]  [<ffffffff811d9181>] acpi_ns_one_complete_parse+0x101/0x11c
> >> [    0.011640]  [<ffffffff811d91bd>] acpi_ns_parse_table+0x21/0x3c
> >> [    0.011645]  [<ffffffff811d67e3>] acpi_ns_load_table+0x4f/0x94
> >> [    0.011650]  [<ffffffff811dd14a>] acpi_load_tables+0x72/0x133
> >> [    0.011656]  [<ffffffff8153c592>] acpi_early_init+0x60/0xf5
> >> [    0.011661]  [<ffffffff81519cb0>] start_kernel+0x38b/0x3a0
> >> [    0.011666]  [<ffffffff81519140>] ? early_idt_handler+0x0/0x71
> >> [    0.011670]  [<ffffffff815192a3>] x86_64_start_reservations+0xaa/0xae
> >> [    0.011675]  [<ffffffff8151939e>] x86_64_start_kernel+0xf7/0x106
> >
> > I looked at the traces and there are no kmemleak calls. It's either that
> > kmemleak is disabled or the error is not on a kmemleak path. It looks
> > more like an ACPI bug to me.
> >
> > Can you try only with slab debugging enabled (without kmemleak or
> > kmemcheck)? IIRC someone else reported a similar issue a few weeks ago.
> 
> If I only disabled kmemleak, the kernel does not print the warning, so I suppose
> it is related with kmemleak.

I can't really see how kmemleak gets involved in here. Maybe you could
just enable some of the features turned on by kmemleak like STACKTRACE
and see if you still get the error.

For x86-64 you may need this patch - http://lkml.org/lkml/2009/8/16/269

> Attachment is the .config,  hope it is usable to help to fix the warning.

Thanks but I don't have such hardware to test and I don't get this error
on x86-32.

Looking at the code, the acpi_ps_complete_op() function calls the
ACPI_PREEMPTION_POINT() macro which expands to a cond_resched() call if
IRQs aren't disabled. The IRQs are probably enabled at that point but it
seems that the context is atomic.

I cc'ed the ACPI people, maybe they can help with some suggestions 

Thanks.

-- 
Catalin

