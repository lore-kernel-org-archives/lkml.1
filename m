Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbYB2Vli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbYB2Vli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760079AbYB2Vl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:41:29 -0500
Received: from waste.org ([66.93.16.53]:49445 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760050AbYB2Vl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:41:28 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>
In-Reply-To: <1204246151.23269.3.camel@nimitz.home.sr71.net>
References: <20080220135743.GA10127@escobedo.amd.com>
	 <1203733096.14838.154.camel@cinder.waste.org>
	 <1203791461.11305.135.camel@nimitz.home.sr71.net>
	 <20080225120951.GA5963@escobedo.amd.com>
	 <1203964750.28196.7.camel@nimitz.home.sr71.net>
	 <20080226202533.GD5963@escobedo.amd.com>
	 <1204134244.5207.28.camel@nimitz.home.sr71.net>
	 <20080228120055.GF5963@escobedo.amd.com>
	 <1204246151.23269.3.camel@nimitz.home.sr71.net>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:15:45 -0800
Message-Id: <1204247745.4021.41.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I've been mostly just reading along with this thread, as I haven't
spent much time investigating huge page handling in general)

On Thu, 2008-02-28 at 16:49 -0800, Dave Hansen wrote:
> On Thu, 2008-02-28 at 13:00 +0100, Hans Rosenfeld wrote: 
> > On Wed, Feb 27, 2008 at 09:44:04AM -0800, Dave Hansen wrote:
> > > On Tue, 2008-02-26 at 21:25 +0100, Hans Rosenfeld wrote:
> > > I'm just worried that once we establish the format, we can't really
> > > change it.  We have enough room in the pseudo-pte now, but what happens
> > > when the next group of people pop up that want something else from this
> > > interface.  Right now we have normal memory, swap, and hugetlb pages.
> > > 
> > > What if people want migration ptes marked next?  I'm not sure those fit
> > > into what you have here.
> > > 
> > > It all fits today, I'm just worried about tomorrow. :(
> > 
> > We could change the interface to return just a pfn (which is aligned to
> > the pshift returned), as it was before. That would free up some bits
> > that we could reserve for future use.
> 
> Yeah, I think we should do that.  No reason to zero-pad it.

Indeed.

> > > > @@ -574,7 +581,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
> > > >  u64 swap_pte_to_pagemap_entry(pte_t pte)
> > > >  {
> > > >  	swp_entry_t e = pte_to_swp_entry(pte);
> > > > -	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> > > > +	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> > > >  }
> > > 
> > > Is there any way to do unions of bitfields?  It seems a bit silly that
> > > we have this bitfield, and then subdivide the bitfield for the swap
> > > entries.  
> > 
> > Having a union of bitfields is allowed, but having a union in a
> > struct of bitfields or vice-versa will probably cause the compiler not
> > to put all of this together in a single 64 bit entity.
> > 
> > This whole swap thing still needs some thought. The swap file offset
> > can take 59 bits, so there is a possibilty that this will break once
> > someone uses a really huge swap file. I doubt that this will happen, but
> > that doesn't mean it can't happen. Maybe there should be some completely
> > different interface for the swap stuff, like /proc/pid/swapmap or
> > something like that.
> 
> I wouldn't worry about overflowing it.  I think there are plenty of
> block layer things that will break, first. :)

I expect the trend for swap is that it'll be a rather small multiple of
total memory size for the foreseeable future.

> > > >  static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > > > @@ -584,16 +591,23 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > > >  	pte_t *pte;
> > > >  	int err = 0;
> > > > 
> > > > -	for (; addr != end; addr += PAGE_SIZE) {
> > > > -		u64 pfn = PM_NOT_PRESENT;
> > > > +	if (pmd_huge(*pmd))
> > > > +		add_huge_to_pagemap(addr, end, pmd_to_ppte(pmd), pm);
> > > 
> > > Could you make this work with other architectures' large pages as well?
> > > I'd hate to leave ia64, MIPS and powerpc out in the cold.  powerpc at
> > > least has large pmds, it just doesn't really expose them to generic
> > > code.  
> > 
> > Well, if some powerpc guy would implement pmd_huge() and pmd_pfn() for
> > powerpc, the x86 specific pmd_to_ppte() won't be that x86 specific no
> > more. I didn't know there were huge pmds on powerpc, as pmd_huge() is
> > defined as zero for everything but x86.
> 
> OK, I'm now convinced that doing this with pmds is actually completely
> wrong. :(
> 
> Take a look at this code from mm/hugetlb.c:
> 
>         for (address = start; address < end; address += HPAGE_SIZE) {
>                 ptep = huge_pte_offset(mm, address);
>                 if (!ptep)
>                         continue;
> 
>                 if (huge_pmd_unshare(mm, &address, ptep))
>                         continue;
> 
>                 pte = huge_ptep_get_and_clear(mm, address, ptep);
>                 if (pte_none(pte))
>                         continue;
> 
>                 page = pte_page(pte);
>                 if (pte_dirty(pte))
>                         set_page_dirty(page);
>                 list_add(&page->lru, &page_list);
>         }
> 
> The arch code is completely responsible for taking the mm and address
> and giving you back a pte that you can do pte_page() on.  This is a
> nice, arch-abstracted interface that everybody can use regardless of how
> their arch actually does it internally. 
> 
> The only issue is that this is *after* the code has decided that a
> particular virtual area is for huge pages.  The best arch-generic
> interface I know for that is: is_vm_hugetlb_page(), but that is
> VMA-based.  Perhaps we should change the pagemap walk to pass the VMA
> around. 

I'd rather avoid that. Requiring a VMA to poke at these things shouldn't
-really- be necessary.

> We should probably use a similar approach in the pagemap code.  Or, if
> we're really smart, we can actually share that code with the hugetlb
> code. 
> 
> > Does it have huge puds as well? Once we support 1G pages for x86 a new
> > function has to be added to this file to handle that special case, too.
> 
> Yes, it does (or will soon have) huge puds.  But, they're nicely wrapped
> up in that pte_t interface I showed above like the rest of the large
> pages.
> 
> > > >  		pte = pte_offset_map(pmd, addr);
> > > > -		if (is_swap_pte(*pte))
> > > > -			pfn = swap_pte_to_pagemap_entry(*pte);
> > > > -		else if (pte_present(*pte))
> > > > -			pfn = pte_pfn(*pte);
> > > > +		if (is_swap_pte(*pte)) {
> > > > +			ppte.swap = 1;
> > > > +			ppte.paddr = swap_pte_to_pagemap_entry(*pte);
> > > > +		} else if (pte_present(*pte)) {
> > > > +			ppte.present = 1;
> > > > +			ppte.pshift = PAGE_SHIFT;
> > > > +			ppte.paddr = pte_pfn(*pte) << PAGE_SHIFT;
> > > > +		}
> > 
> > This is the place where those architectures that define the page size in
> > the pte should test for a huge page and put the correct page size in the
> > pshift field. I looked at some of them and did not find a function or a
> > macro to do this test, no generic one and no arch-dependent one.
> 
> To test a pte for its huge page size?  Well, for now, we only support
> one huge page size at a time, and that's HPAGE_SIZE.
> 
> > > The bitfields are nice, and I do see they've spread to generic code.
> > > So, I won't object to them, but please do double-check that they don't
> > > cause any problems, especially with compilers that you might not be
> > > using.
> > 
> > The standard says the ordering of bitfields is "implementation defined".
> > I'm currently unsure whether this means the implementation of a machine
> > or of the compiler. In the latter case, using a different compiler for
> > a user space program than the one that was used to compile the kernel
> > could create problems.
> 
> I'd hate to be the first ones to depend on a bitfield for a
> user<->kernel interface.  Can you look around for precedent in this
> area, or convert them back?
> 
> -- Dave
-- 
Mathematics is the supreme nostalgia of our time.

