Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYB1MCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYB1MCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbYB1MCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:02:43 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:17534 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694AbYB1MCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:02:42 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWY6Q8-04-NUC-01
Date: Thu, 28 Feb 2008 13:00:55 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and return page size
Message-ID: <20080228120055.GF5963@escobedo.amd.com>
References: <20080220135743.GA10127@escobedo.amd.com> <1203733096.14838.154.camel@cinder.waste.org> <1203791461.11305.135.camel@nimitz.home.sr71.net> <20080225120951.GA5963@escobedo.amd.com> <1203964750.28196.7.camel@nimitz.home.sr71.net> <20080226202533.GD5963@escobedo.amd.com> <1204134244.5207.28.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204134244.5207.28.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 28 Feb 2008 12:00:02.0058 (UTC) FILETIME=[72DB26A0:01C87A01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 09:44:04AM -0800, Dave Hansen wrote:
> On Tue, 2008-02-26 at 21:25 +0100, Hans Rosenfeld wrote:
> I'm just worried that once we establish the format, we can't really
> change it.  We have enough room in the pseudo-pte now, but what happens
> when the next group of people pop up that want something else from this
> interface.  Right now we have normal memory, swap, and hugetlb pages.
> 
> What if people want migration ptes marked next?  I'm not sure those fit
> into what you have here.
> 
> It all fits today, I'm just worried about tomorrow. :(

We could change the interface to return just a pfn (which is aligned to
the pshift returned), as it was before. That would free up some bits
that we could reserve for future use.

> > @@ -574,7 +581,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
> >  u64 swap_pte_to_pagemap_entry(pte_t pte)
> >  {
> >  	swp_entry_t e = pte_to_swp_entry(pte);
> > -	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> > +	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> >  }
> 
> Is there any way to do unions of bitfields?  It seems a bit silly that
> we have this bitfield, and then subdivide the bitfield for the swap
> entries.  

Having a union of bitfields is allowed, but having a union in a
struct of bitfields or vice-versa will probably cause the compiler not
to put all of this together in a single 64 bit entity.

This whole swap thing still needs some thought. The swap file offset
can take 59 bits, so there is a possibilty that this will break once
someone uses a really huge swap file. I doubt that this will happen, but
that doesn't mean it can't happen. Maybe there should be some completely
different interface for the swap stuff, like /proc/pid/swapmap or
something like that.

> >  static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > @@ -584,16 +591,23 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >  	pte_t *pte;
> >  	int err = 0;
> > 
> > -	for (; addr != end; addr += PAGE_SIZE) {
> > -		u64 pfn = PM_NOT_PRESENT;
> > +	if (pmd_huge(*pmd))
> > +		add_huge_to_pagemap(addr, end, pmd_to_ppte(pmd), pm);
> 
> Could you make this work with other architectures' large pages as well?
> I'd hate to leave ia64, MIPS and powerpc out in the cold.  powerpc at
> least has large pmds, it just doesn't really expose them to generic
> code.  

Well, if some powerpc guy would implement pmd_huge() and pmd_pfn() for
powerpc, the x86 specific pmd_to_ppte() won't be that x86 specific no
more. I didn't know there were huge pmds on powerpc, as pmd_huge() is
defined as zero for everything but x86.

Does it have huge puds as well? Once we support 1G pages for x86 a new
function has to be added to this file to handle that special case, too.

> > +	else	for (; addr != end; addr += PAGE_SIZE) {
> > +		struct pagemap_ppte ppte = { 0, 0, 0, 0};
> 
> Didn't you define a macro for this above?  Can you re-use it?

Good point.

> >  		pte = pte_offset_map(pmd, addr);
> > -		if (is_swap_pte(*pte))
> > -			pfn = swap_pte_to_pagemap_entry(*pte);
> > -		else if (pte_present(*pte))
> > -			pfn = pte_pfn(*pte);
> > +		if (is_swap_pte(*pte)) {
> > +			ppte.swap = 1;
> > +			ppte.paddr = swap_pte_to_pagemap_entry(*pte);
> > +		} else if (pte_present(*pte)) {
> > +			ppte.present = 1;
> > +			ppte.pshift = PAGE_SHIFT;
> > +			ppte.paddr = pte_pfn(*pte) << PAGE_SHIFT;
> > +		}

This is the place where those architectures that define the page size in
the pte should test for a huge page and put the correct page size in the
pshift field. I looked at some of them and did not find a function or a
macro to do this test, no generic one and no arch-dependent one.

> Why do we bother wasting space in paddr by shifting up the physical
> address?  We know the bottom PAGE_SHIFT bits are empty, so doesn't this
> just waste them?

As I said above, we could just use a raw pfn as the interface did
before.

> The bitfields are nice, and I do see they've spread to generic code.
> So, I won't object to them, but please do double-check that they don't
> cause any problems, especially with compilers that you might not be
> using.

The standard says the ordering of bitfields is "implementation defined".
I'm currently unsure whether this means the implementation of a machine
or of the compiler. In the latter case, using a different compiler for
a user space program than the one that was used to compile the kernel
could create problems.

> > diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> > index 44ef329..d7df89d 100644
> > --- a/include/asm-generic/pgtable.h
> > +++ b/include/asm-generic/pgtable.h
> > @@ -195,6 +195,12 @@ static inline int pmd_none_or_clear_bad(pmd_t *pmd)
> >  	}
> >  	return 0;
> >  }
> > +
> > +/* dummy for !x86 */
> > +#ifndef pmd_to_ppte
> > +#define pmd_to_ppte(x) ((struct pagemap_ppte) {0, 0, 0, 0})
> > +#endif
> 
> I'm really not a fan of the #ifndef style for these headers.  I think it
> makes it really hard to figure out where definitions come from.  
> 
> I do think it would be best to keep al the ppte stuff isolated to the
> pagemap files as much as humanly possible.  There's not much of a reason
> to pollute these generic (and already full) headers with our /proc
> crap. :)

If you got an idea where to put it, speak up. I thought asm/pgtable.h
would be the right place, but maybe we should put all this in
linux/pagemap_ppte.h (or whatever it will eventually be called, or
wherever this stuff will eventually end up) and put a nasty #ifdef
CONFIG_X86 around it.

> > +#include <linux/pagemap_ppte.h>
> > +
> > +static inline struct pagemap_ppte pmd_to_ppte(pmd_t *pmd)
> > +{
> > +	struct pagemap_ppte ppte = {
> > +		.paddr   = pmd_pfn(*pmd) << PAGE_SHIFT,
> > +		.pshift  = HPAGE_SHIFT,
> > +		.swap    = 0,
> > +		.present = 1,
> > +	};
> > +
> > +	return ppte;
> > +}
> 
> Could you investigate this a bit on the other architectures and perhaps
> code up something that will at least compile on the others and not just
> punt?  I just want to make sure that this approach can be extended to
> them easily and we don't have to rewrite it. :)

AFAIK this pmd stuff is a special case for x86, at least for huge pages
that are used by user programs. Other architectures encode the page size
in the pte, but I don't have the time to learn how exactly this is done
there and write up code that will work for another 4 or 5 platforms.
Those who are responsible for the memory management on the other archs
should come up with a mechanism to find out whether a pte is for a huge
page or not. Adding code to use that would be fairly trivial, then.

> My only other concern is that we're still wobbling on this interface and
> it's about to get mainline-released.  Should we turn it off in mainline
> so that we don't establish an ABI that we know we're going to change
> shortly anyway?

That might be good idea.

Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

