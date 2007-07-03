Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXGCQTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXGCQTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXGCQTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:19:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351AbXGCQTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:19:24 -0400
Date: Tue, 3 Jul 2007 09:17:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andre Noll <maan@systemlinux.org>, Christoph Lameter <clameter@sgi.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.22-rc7
In-Reply-To: <20070703155519.GY22589@skl-net.de>
Message-ID: <alpine.LFD.0.98.0707030908390.9434@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org>
 <20070703155519.GY22589@skl-net.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jul 2007, Andre Noll wrote:
>
> On 14:32, Linus Torvalds wrote:
> > 
> > Ok, Linux-2.6.22-rc7 is out there.
> > 
> > Final testing always appreciated, of course,
> 
> There seems to be a locking problem:

Ok, I _think_ this is actually ok, and the lock validator is unhappy just 
because we don't disable irq's when initializing the slab, so the fact 
that we take the list_lock with interrupts enabled looks scary.

But the reason it seems to be ok is that it doesn't matter if interrupts 
are enabled or not, because nobody can *get* to the list_lock, since the 
thing hasn't been fully set up yet. So no interrupts will try to take the 
lock (and cause any deadlocks) anyway.

However, it might be worth avoiding the warning, even if it seems bogus in 
this case. Christoph? Do you agree with the analysis? And the patch might 
be as simple as changing early_kmem_cache_node_alloc() to enable 
interrupts at the _end_ of the function, rather than immediately after 
calling new_slab().

Andre, does that simple change fix it for you (move the 
"local_irq_enable()" to the end of early_kmem_cache_node_alloc)?

		Linus

---
> [   89.772943] =================================
> [   89.773194] [ INFO: inconsistent lock state ]
> [   89.773325] 2.6.22-rc7 #44
> [   89.773459] ---------------------------------
> [   89.773591] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> [   89.773730] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [   89.773862]  (&n->list_lock){+-..}, at: [<ffffffff8028cd7c>] add_partial+0x1c/0x60
> [   89.774314] {hardirq-on-W} state was registered at:
> [   89.774468]   [<ffffffff8024c542>] __lock_acquire+0x152/0x1070
> [   89.774798]   [<ffffffff8024dc61>] debug_check_no_locks_freed+0x101/0x1c0
> [   89.775139]   [<ffffffff8028cd7c>] add_partial+0x1c/0x60
> [   89.775471]   [<ffffffff8024d82b>] lock_acquire+0x8b/0xc0
> [   89.775797]   [<ffffffff8028cd7c>] add_partial+0x1c/0x60
> [   89.776125]   [<ffffffff805364f5>] _spin_lock+0x25/0x40
> [   89.776453]   [<ffffffff8028cd7c>] add_partial+0x1c/0x60
> [   89.776778]   [<ffffffff80290dab>] kmem_cache_open+0x1db/0x300
> [   89.777108]   [<ffffffff802912ea>] create_kmalloc_cache+0x6a/0xe0
> [   89.777459]   [<ffffffff806f848c>] kmem_cache_init+0x3c/0x170
> [   89.777791]   [<ffffffff806de7da>] start_kernel+0x21a/0x330
> [   89.778120]   [<ffffffff806de124>] _sinittext+0x124/0x160
> [   89.778450]   [<ffffffffffffffff>] 0xffffffffffffffff
> [   89.778772] irq event stamp: 4974
> [   89.778898] hardirqs last  enabled at (4973): [<ffffffff80208257>] default_idle+0x37/0x60
> [   89.779220] hardirqs last disabled at (4974): [<ffffffff805360a1>] trace_hardirqs_off_thunk+0x35/0x67
> [   89.779549] softirqs last  enabled at (4966): [<ffffffff80233753>] __do_softirq+0xf3/0x110
> [   89.779868] softirqs last disabled at (4959): [<ffffffff8020adcc>] call_softirq+0x1c/0x30
> [   89.780189] 
> [   89.780190] other info that might help us debug this:
> [   89.780455] no locks held by swapper/0.
> [   89.780584] 
> [   89.780584] stack backtrace:
> [   89.780814] 
> [   89.780815] Call Trace:
> [   89.781046]  <IRQ>  [<ffffffff8024ae36>] print_usage_bug+0x186/0x1a0
> [   89.781256]  [<ffffffff8024c26c>] mark_lock+0x49c/0x620
> [   89.781401]  [<ffffffff8024ce47>] __lock_acquire+0xa57/0x1070
> [   89.781542]  [<ffffffff8022804d>] run_rebalance_domains+0x3bd/0x4e0
> [   89.781684]  [<ffffffff8028cd7c>] add_partial+0x1c/0x60
> [   89.781819]  [<ffffffff8024d82b>] lock_acquire+0x8b/0xc0
> [   89.781956]  [<ffffffff8028cd7c>] add_partial+0x1c/0x60
> [   89.782093]  [<ffffffff805364f5>] _spin_lock+0x25/0x40
> [   89.782230]  [<ffffffff80232f91>] _local_bh_enable+0x61/0xf0
> [   89.782371]  [<ffffffff8028cd7c>] add_partial+0x1c/0x60
> [   89.782508]  [<ffffffff8028f8a0>] deactivate_slab+0x60/0x150
> [   89.782646]  [<ffffffff8028f9e0>] flush_cpu_slab+0x0/0x20
> [   89.782786]  [<ffffffff8028f9b2>] flush_slab+0x22/0x30
> [   89.782921]  [<ffffffff8028f9db>] __flush_cpu_slab+0x1b/0x20
> [   89.783061]  [<ffffffff8028f9f1>] flush_cpu_slab+0x11/0x20
> [   89.783198]  [<ffffffff802146df>] smp_call_function_interrupt+0x4f/0x80
> [   89.783341]  [<ffffffff80208220>] default_idle+0x0/0x60
> [   89.783478]  [<ffffffff8020a79b>] call_function_interrupt+0x6b/0x70
> [   89.783618]  <EOI>  [<ffffffff80208259>] default_idle+0x39/0x60
> [   89.783824]  [<ffffffff80208257>] default_idle+0x37/0x60
> [   89.783962]  [<ffffffff802082e1>] cpu_idle+0x61/0x90
> [   89.784098]  [<ffffffff806eb10b>] start_secondary+0x25b/0x3c0
