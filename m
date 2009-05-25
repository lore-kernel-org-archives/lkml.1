Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZEYFQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZEYFQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZEYFQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:16:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43255 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZEYFQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:16:40 -0400
Date: Mon, 25 May 2009 07:15:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090525051521.GC23032@elte.hu>
References: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu> <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain> <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A2261.1000504@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Pekka J Enberg wrote:
> >>> On Mon, 18 May 2009, Linus Torvalds wrote:
> >>>>>> I hate that stupid bootmem allocator. I suspect we seriously 
> >>>>>> over-use it, and that we _should_ be able to do the SL*B init 
> >>>>>> earlier.
> >>>>> Hm, tempting thought - not sure how to pull it off though.
> >>>> As far as I can recall, one of the things that historically made us want 
> >>>> to use the bootmem allocator even relatively late was that the real SLAB 
> >>>> allocator had to wait until all the node information etc was initialized. 
> >>>>
> >>>> That's pretty damn late. And I wonder if SLUB (and SLOB) might not need a 
> >>>> lot less initialization, and work much earlier. Something like that might 
> >>>> be the final nail in the coffin for SLAB, and convince me to just say 
> >>>> 'we don't support it any more".
> >>> Ingo, here's a patch that boots UMA+SMP+SLUB x86-64 kernel on qemu all 
> >>> the way to userspace. It probably breaks bunch of things for now but 
> >>> something for you to play with if you want.
> >>>
> >> updated with tip/master. also add change to cpupri_init
> >> otherwise will get 
> >> [    0.000000] Memory: 523096612k/537526272k available (10461k kernel code, 656156k absent, 13773504k reserved, 7186k data, 2548k init)
> >> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=8
> >> [    0.000000] ------------[ cut here ]------------
> >> [    0.000000] WARNING: at kernel/lockdep.c:2282 lockdep_trace_alloc+0xaf/0xee()
> >> [    0.000000] Hardware name: Sun Fire X4600 M2
> >> [    0.000000] Modules linked in:
> >> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-rc6-tip-01778-g0afdd0f-dirty #259
> >> [    0.000000] Call Trace:
> >> [    0.000000]  [<ffffffff810a0274>] ? lockdep_trace_alloc+0xaf/0xee
> >> [    0.000000]  [<ffffffff81075ab0>] warn_slowpath_common+0x88/0xcb
> >> [    0.000000]  [<ffffffff81075b15>] warn_slowpath_null+0x22/0x38
> >> [    0.000000]  [<ffffffff810a0274>] lockdep_trace_alloc+0xaf/0xee
> >> [    0.000000]  [<ffffffff8110301b>] kmem_cache_alloc_node+0x38/0x14d
> >> [    0.000000]  [<ffffffff813ec548>] ? alloc_cpumask_var_node+0x4a/0x10a
> >> [    0.000000]  [<ffffffff8109eb61>] ? lockdep_init_map+0xb9/0x564
> >> [    0.000000]  [<ffffffff813ec548>] alloc_cpumask_var_node+0x4a/0x10a
> >> [    0.000000]  [<ffffffff813ec62c>] alloc_cpumask_var+0x24/0x3a
> >> [    0.000000]  [<ffffffff819e6306>] cpupri_init+0x7f/0x112
> >> [    0.000000]  [<ffffffff819e5a30>] init_rootdomain+0x72/0xb7
> >> [    0.000000]  [<ffffffff821facce>] sched_init+0x109/0x660
> >> [    0.000000]  [<ffffffff82203082>] ? kmem_cache_init+0x193/0x1b2
> >> [    0.000000]  [<ffffffff821dfd7a>] start_kernel+0x218/0x3f3
> >> [    0.000000]  [<ffffffff821df2a9>] x86_64_start_reservations+0xb9/0xd4
> >> [    0.000000]  [<ffffffff821df3b2>] x86_64_start_kernel+0xee/0x109
> >> [    0.000000] ---[ end trace a7919e7f17c0a725 ]---
> >>
> >> works with 8 sockets numa amd64 box.
> >>
> >> YH
> >>
> >> ---
> >>  init/main.c           |   28 ++++++++++++++++------------
> >>  kernel/irq/handle.c   |   23 ++++++++---------------
> >>  kernel/sched.c        |   34 +++++++++++++---------------------
> >>  kernel/sched_cpupri.c |    9 ++++++---
> >>  mm/slub.c             |   17 ++++++++++-------
> >>  5 files changed, 53 insertions(+), 58 deletions(-)
> > 
> > Very nice!
> > 
> > Would it be possible to restructure things to move kmalloc init to 
> > before IRQ init as well? We have a couple of uglinesses there too.
> > 
> > Conceptually, memory should be the first thing set up in general, in 
> > a kernel. It does not need IRQs, timers, the scheduler or any of the 
> > IO facilities and abstractions. All of them need memory though - and 
> > as Linux scales to more and more hardware via the same single image, 
> > so will we get more and more dynamic concepts like cpumask_var_t and 
> > sparse-irqs, which want to allocate very early.
> 
> Pekka's patch already made kmalloc before early_irq_init()/init_IRQ...
> 
> we can clean up alloc_desc_masks and
> alloc_cpumask_var_node could be much simplified too.

That's nice!

Ok, i think this all looks pretty realistic - but there's quite a 
bit of layering on top of pending changes in the x86 and irq trees. 
We could do this on top of those topic branches in -tip, and rebase 
in the merge window. Or delay it to .32.

... plus i think we are _very_ close to being able to remove all of 
bootmem on x86 (with some compatibility/migration mechanism in 
place). Which bootmem calls do we have before kmalloc init with 
Pekka's patch applied? I think it's mostly the page table init code.
 
( beyond the page allocator internal use - where we could use 
  straight e820 based APIs that clip memory off from the beginning 
  of existing e820 RAM ranges - enriched with NUMA/SRAT locality 
  info. )

	Ingo
