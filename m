Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbXKPRgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbXKPRgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXKPRgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:36:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbXKPRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:36:03 -0500
Date: Fri, 16 Nov 2007 09:35:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
In-Reply-To: <473DCF73.4070401@goop.org>
Message-ID: <alpine.LFD.0.9999.0711160921510.4260@woody.linux-foundation.org>
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473DCF73.4070401@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Nov 2007, Jeremy Fitzhardinge wrote:
> >
> > IIRC, the present bit is ignored in the magic 4-entry PGD.  All entries 
> > have to be present.
> 
> Hm, do you recall what processors that might affect?  As far as I know,
> current processors will ignore non-present top-level entries.

Are you sure?

Anyway, this is not worth making a distinction for. Just pre-allocate all 
of them. There really is just 4 PGD entries, and it really *is* different 
from having a full three-level page table, and of the four PGD entries:

 - one is used for the kernel mapping (assuming the regular 1:3 layout)
 - AT LEAST two are required by user space anyway

so pre-allocating is never going to waste more than one page.

And you may feel that pre-allocating is a special case, but it's an 
*easier* special case than the one that you are apparently thinking about 
(which is to special-case according to CPU version).

So don't do it. Just preallocate for the magic 4-entry PGD. You can make 
the special case just be something like

	/* Preallocate for small PGD's */
	#if PTRS_PER_PGD == 4
		for (i = 0; i < USER_PTRS_PER_PGD; i++) {
			pmd_t *pmd = pmd_alloc();
			set_pgd(pgd+i, __pgd(PAGE_PRESENT | __pa(pmd));
		}	
	#endif

or similar. 

There is absolutely *zero* reason not to do this, and there is also zero 
reason to make this be a "32-bit vs 64-bit" issue. The code can be there 
in both, and the #if could even be all in C code (ie there may be reasons 
to prefer writing it as

	/* The old-style PAE PGD needs to be preallocated */
	if (USER_PTRS_PER_PGD <= 4) {
		...
	}

and the compiler should even compile it away entirely for all practical 
cases even without using the preprocessor.

> Anyway, we can point them not present to empty_zero_page, so testing the 
> present bit will still be sufficient to tell if we need to allocate a 
> new pmd, but if the hardware decides to follow the page reference 
> there's no harm done.  (Hm, unless the hardware decides it wants to set 
> A or D bits in empty_zero_page for some reason...)

x86 page table walking never sets A/D bits on non-present entries.

That said, there's still a huge difference. 

For "real" page table walking, you can always just insert entries without 
flushing the cache if those entries weren't there before (because the TLB 
is supposed to not cache negative entries). 

Again, because of the way the mahic 4-entry PGD works, that isn't true for 
it. It caches the entries regardless, so if you change it from non-present 
to present, you have to flush the TLB (well, "reload %cr3", which is the 
same thing in practice, although it's for a different *reason*).

> That just means we need to reload cr3 after populating the pgd with a
> new pmd, right?

BUT ONLY FOR THIS CASE!

And if you preallocate it, you make *that* special case go away. 

So you're going to have special cases regardless. Do the simple and 
really straightforward one, please! Nothing subtle.

		Linus
