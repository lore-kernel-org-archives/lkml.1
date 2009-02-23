Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZBWOyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZBWOyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZBWOyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:54:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZBWOyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:54:21 -0500
Date: Mon, 23 Feb 2009 15:53:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [patch] x86: optimize __pa() to be linear again on 64-bit x86
Message-ID: <20090223145358.GB3377@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <20090223101741.GP9582@elte.hu> <20090223133804.GA20468@elte.hu> <200902240108.54892.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902240108.54892.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 24 February 2009 00:38:04 Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > Are __pa()/__va() that hot paths?  Or am I over-estimating
> > > > the cost of 2MB dTLB?
> > >
> > > yes, __pa()/__va() is a very hot path - in a defconfig they
> > > are used in about a thousand different places.
> > >
> > > In fact it would be nice to get rid of the __phys_addr()
> > > redirection on the 64-bit side (which is non-linear and a
> > > function there, and all __pa()s go through it) and make it a
> > > constant offset again.
> > >
> > > This isnt trivial/possible to do though as .data/.bss is in
> > > the high alias. (high .text aliases alone wouldnt be a big
> > > issue to fix, but the data aliases are an issue.)
> > >
> > > Moving .data/.bss into the linear space isnt feasible as we'd
> > > lose RIP-relative addressing shortcuts.
> > >
> > > Maybe we could figure out the places that do __pa() on a high
> > > alias and gradually eliminate them. __pa() on .data/.bss is a
> > > rare and unusal thing to do, and CONFIG_DEBUG_VIRTUAL could
> > > warn about them without crashing the kernel.
> > >
> > > Later on we could make this check unconditional, and then
> > > switch over __pa() to addr-PAGE_OFFSET in the
> > > !CONFIG_DEBUG_VIRTUAL case (which is the default).
> >
> > Ok, i couldnt resist and using ftrace_printk() (regular printk
> > in __pa() would hang during bootup) and came up with the patch
> > below - which allows the second patch below that does:
> >
> >  -#define __pa(x)		__phys_addr((unsigned long)(x))
> >  +#define __pa(x)		((unsigned long)(x)-PAGE_OFFSET)
> >
> > It cuts a nice (and hotly executed) ~650 bytes chunk out of the
> > x86 64-bit defconfig kernel text:
> >
> >     text	   data	    bss	    dec	    hex	filename
> >  7999071	1137780	 843672	9980523	 984a6b	vmlinux.before
> >  7998414	1137780	 843672	9979866	 9847da	vmlinux.after
> >
> > And it even boots.
> >
> > (the load_cr3() hack needs to be changed, by setting the init
> > pgdir from init_level4_pgt to __va(__pa_symbol(init_level4_pgt).)
> >
> > (32-bit is untested and likely wont even build.)
> >
> > It's not even that bad and looks quite maintainable as a
> > concept.
> >
> > This also means that __va() and __pa() will be one and the same
> > thing simple arithmetics again on both 32-bit and 64-bit
> > kernels.
> >
> > 	Ingo
> >
> > ---
> >  arch/x86/include/asm/page.h          |    4 +++-
> >  arch/x86/include/asm/page_64_types.h |    1 +
> >  arch/x86/include/asm/pgalloc.h       |    4 ++--
> >  arch/x86/include/asm/pgtable.h       |    2 +-
> >  arch/x86/include/asm/processor.h     |    7 ++++++-
> >  arch/x86/kernel/setup.c              |   12 ++++++------
> >  arch/x86/mm/init_64.c                |    6 +++---
> >  arch/x86/mm/ioremap.c                |   12 +++++++++++-
> >  arch/x86/mm/pageattr.c               |   28 ++++++++++++++--------------
> >  arch/x86/mm/pgtable.c                |    2 +-
> >  10 files changed, 48 insertions(+), 30 deletions(-)
> >
> > Index: linux/arch/x86/include/asm/page.h
> > ===================================================================
> > --- linux.orig/arch/x86/include/asm/page.h
> > +++ linux/arch/x86/include/asm/page.h
> > @@ -34,10 +34,11 @@ static inline void copy_user_page(void *
> >  #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
> >
> >  #define __pa(x)		__phys_addr((unsigned long)(x))
> > +#define __pa_slow(x)		__phys_addr_slow((unsigned long)(x))
> >  #define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
> >  /* __pa_symbol should be used for C visible symbols.
> >     This seems to be the official gcc blessed way to do such arithmetic. */
> > -#define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
> > +#define __pa_symbol(x)	__pa_slow(__phys_reloc_hide((unsigned long)(x)))
> >
> >  #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
> >
> > @@ -49,6 +50,7 @@ static inline void copy_user_page(void *
> >   * virt_addr_valid(kaddr) returns true.
> >   */
> >  #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
> > +#define virt_to_page_slow(kaddr) pfn_to_page(__pa_slow(kaddr) >>
> 
> Heh. I have almost the exact opposite patch which adds a 
> virt_to_page_fast and uses it in critical places (in the slab 
> allocator).
> 
> But if you can do this more complete conversion, cool. Yes, 
> __pa is very performance critical (not just code size). Time 
> to alloc+free an object in the slab allocator is on the order 
> of 100 cycles, so saving a few cycles here == saving a few %. 
> (although saying that, you hardly ever see a workload where 
> the slab allocator is too prominent)

Yeah, we can do this complete conversion.

I'll clean it up some more. I think the best representation of 
this will be via a virt_to_sym() and sym_to_virt() space. That 
makes it really clear when we are moving from the symbol space 
to the linear space and back.

That way we wont need the _slow() methods at all - we'll always 
know whether an address is pure linear or in the symbol space.

In other words, it will be even faster and even nicer ;-)

	Ingo
