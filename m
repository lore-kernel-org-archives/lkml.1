Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZERUVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZERUVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZERUU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:20:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60623 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZERUU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:20:57 -0400
Date: Mon, 18 May 2009 22:20:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Yinghai Lu <yinghai@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090518202031.GA26549@elte.hu>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu> <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 18 May 2009, Ingo Molnar wrote:
> > 
> > Something like the patch below. It also fixes ->span[] which has 
> > a similar problem.
> 
> Patch looks good to me.

ok. I've queued it up for .31, with your Acked-by. (which i assume 
your reply implies?)

> > But ... i think this needs further clean-ups really. Either go 
> > fully static, or go fully dynamic.
> 
> I do agree that it would probably be good to try to avoid this 
> static allocation, and allocate these data structures dynamically. 
> However, if we end up having to use two different allocators 
> anyway (one for bootup, and one for regular uptimes), then I think 
> that would be an overall loss (compared to just the simplicity of 
> statically doing this in a couple of places), rather than an 
> overall win.
> 
> > Would be nice if bootmem_alloc() was extended with such 
> > properties - if SLAB is up (and bootmem is down) it would return 
> > kmalloc(GFP_KERNEL) memory buffers.
> 
> I would rather say the other way around: no "bootmem_alloc()" at 
> all, but just have a regular alloc() that ends up working like the 
> "SMP alternatives" code, but instead of being about SMP, it would 
> be about how early in the boot sequence it is.
> 
> That said, if there are just a couple of places like this that 
> care, I don't think it's worth it. The static allocation isn't 
> that horrible. I'd rather have a few ugly static allocations with 
> comments about _why_ they look the way they do, than try to 
> over-design things to look "clean".
> 
> Simplicity is a good thing - even if it can then end up meaning 
> special cases like this.
> 
> That said, if we could move the kmalloc initialization up some 
> more (and get at least the "boot node" data structures set up, and 
> avoid any bootmem alloc issues _entirely_, then that would be 
> good.
> 
> I hate that stupid bootmem allocator. I suspect we seriously 
> over-use it, and that we _should_ be able to do the SL*B init 
> earlier.

Hm, tempting thought - not sure how to pull it off though.

One of the biggest user of bootmem is the mem_map[] hierarchies and 
the page allocator bitmaps. Not sure we can get rid of bootmem there 
- those areas are really large, physical memory is often fragmented 
and we need a good NUMA sense for them as well.

We might also have a 22-architectures-to-fix problem as well, before 
we can get rid of bootmem:

  $ git grep alloc_bootmem arch/ | wc -l
  168

On x86 we recently switched some (but not all) early-pagetable 
allocations to the 'early brk' method (which is an utterly simple 
early linear allocator, for limited early dynamic allocations), but 
even with that we still have ugly bootmem use - for example see the 
after_bootmem hacks in arch/x86/mm/init_64.c.

So we have these increasingly more complete layers of allocators, 
which bootstrap each other gradually:

  - static, build-time allocations

  - early-brk (see extend_brk(), RESERVE_BRK and direct use of 
    _brk_end in assembly code)

  - e820 based early allocator (reserve_early()) to bootstrap bootmem

  - bootmem - to bootstrap the page allocator [NUMA aware]

  - page allocator - to bootstrap SLAB

  - SLAB

that's 5 layers until we get to SLAB. Each layer has to be aware of 
its own limits, has to interact with pagetable setup and has to end 
up with a NUMA-aware dynamic allocations as early as possible.

And all this complexity definitely _feels_ utterly wrong, as we 
really know it pretty early on what kind of memory we have, how it's 
laid out amongst nodes. In the end we really just want to have the 
page allocator and SL[AOQU]B.

Looks daunting.

	Ingo
