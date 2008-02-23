Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbYBWSb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbYBWSb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbYBWSbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:31:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33842 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbYBWSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:31:45 -0500
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and
	return page size
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>
In-Reply-To: <1203733096.14838.154.camel@cinder.waste.org>
References: <20080220135743.GA10127@escobedo.amd.com>
	 <1203733096.14838.154.camel@cinder.waste.org>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 10:31:01 -0800
Message-Id: <1203791461.11305.135.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-23 at 10:18 +0800, Matt Mackall wrote:
> Another
> > problem is that there is no way to get information about the page size a
> > specific mapping uses.

Is this true generically, or just with pagemap?  It seems like we should
have a way to tell that a particular mapping is of large pages.  I'm
cc'ing a few folks who might know.

> > Also, the current way the "not present" and "swap" bits are encoded in
> > the returned pfn isn't very clean, especially not if this interface is
> > going to be extended.
> 
> Fair.

Yup.

> > I propose to change /proc/pid/pagemap to return a pseudo-pte instead of
> > just a raw pfn. The pseudo-pte will contain:
> > 
> > - 58 bits for the physical address of the first byte in the page, even
> >   less bits would probably be sufficient for quite a while

Well, whether we use a physical address of the first byte of the page or
a pfn doesn't really matter.  It just boils down to whether we use low
or high bits for the magic. :)

> > - 4 bits for the page size, with 0 meaning native page size (4k on x86,
> >   8k on alpha, ...) and values 1-15 being specific to the architecture
> >   (I used 1 for 2M, 2 for 4M and 3 for 1G for x86)

"Native page size" probably a bad idea.  ppc64 can use 64k or 4k for its
"native" page size and has 16MB large pages (as well as some others).
To make it even more confusing, you can have a 64k kernel page size with
4k mmu mappings!

That said, this is a decent idea as long as we know that nobody will
ever have more than 16 page sizes.  

> > - a "swap" bit indicating that a not present page is paged out, with the
> >   physical address field containing page file number and block number
> >   just like before
> > 
> > - a "present" bit just like in a real pte
> 
> This is ok-ish, but I can't say I like it much. Especially the page size
> field.
> 
> But I don't really have many ideas here. Perhaps having a bit saying
> "this entry is really a continuation of the previous one". Then any page
> size can be trivially represented. This might also make the code on both
> sides simpler?

Yeah, it could just be a special flag plus a mask or offset showing how
many entries to back up to find the actual mapping.  If each huge page
entry just had something along the lines of:

	PAGEMAP_HUGE_PAGE_BIT | HPAGE_MASK

You can see its a huge mapping from the bit, and you can go find the
physical page by applying HPAGE_MASK to your current position in the
pagemap.

> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 49958cf..58af588 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -527,16 +527,23 @@ struct pagemapread {
> >  	char __user *out, *end;
> >  };
> >  
> > -#define PM_ENTRY_BYTES sizeof(u64)
> > -#define PM_RESERVED_BITS    3
> > -#define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
> > -#define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
> > -#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
> > -#define PM_NOT_PRESENT      PM_SPECIAL(1LL)
> > -#define PM_SWAP             PM_SPECIAL(2LL)
> > -#define PM_END_OF_BUFFER    1
> > -
> > -static int add_to_pagemap(unsigned long addr, u64 pfn,
> > +struct ppte {
> > +	uint64_t paddr:58;
> > +	uint64_t psize:4;
> > +	uint64_t swap:1;
> > +	uint64_t present:1;
> > +};

It'd be nice to keep the current convention, which is to stay away from
bitfields.

> > +#ifdef CONFIG_X86
> > +#define PM_PSIZE_1G      3
> > +#define PM_PSIZE_4M      2
> > +#define PM_PSIZE_2M      1
> > +#endif

I do think this may get goofy in the future, especially for those
architectures which don't have page sizes tied to Linux pagetables.
Tomorrow, you might end up with:

> > +#ifdef CONFIG_FUNNYARCH
> > +#define PM_PSIZE_64M     4 
> > +#define PM_PSIZE_1G      3
> > +#define PM_PSIZE_4M      2
> > +#define PM_PSIZE_2M      1
> > +#endif

> > +#define PM_ENTRY_BYTES   sizeof(struct ppte)
> > +#define PM_END_OF_BUFFER 1
> > +
> > +static int add_to_pagemap(unsigned long addr, struct ppte ppte,
> >  			  struct pagemapread *pm)
> >  {
> >  	/*
> > @@ -545,13 +552,13 @@ static int add_to_pagemap(unsigned long addr, u64 pfn,
> >  	 * the pfn.
> >  	 */
> >  	if (pm->out + PM_ENTRY_BYTES >= pm->end) {
> > -		if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
> > +		if (copy_to_user(pm->out, &ppte, pm->end - pm->out))
> >  			return -EFAULT;
> >  		pm->out = pm->end;
> >  		return PM_END_OF_BUFFER;
> >  	}
> >  
> > -	if (put_user(pfn, pm->out))
> > +	if (copy_to_user(pm->out, &ppte, sizeof(ppte)))
> >  		return -EFAULT;
> >  	pm->out += PM_ENTRY_BYTES;
> >  	return 0;
> > @@ -564,7 +571,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
> >  	unsigned long addr;
> >  	int err = 0;
> >  	for (addr = start; addr < end; addr += PAGE_SIZE) {
> > -		err = add_to_pagemap(addr, PM_NOT_PRESENT, pm);
> > +		err = add_to_pagemap(addr, (struct ppte) {0, 0, 0, 0}, pm);
> >  		if (err)
> >  			break;
> >  	}
> > @@ -574,7 +581,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
> >  u64 swap_pte_to_pagemap_entry(pte_t pte)
> >  {
> >  	swp_entry_t e = pte_to_swp_entry(pte);
> > -	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> > +	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
> >  }
> >  
> >  static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> > @@ -584,16 +591,37 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >  	pte_t *pte;
> >  	int err = 0;
> >  
> > +#ifdef CONFIG_X86
> > +	if (pmd_huge(*pmd)) {
> > +		struct ppte ppte = { 
> > +			.paddr = pmd_pfn(*pmd) << PAGE_SHIFT,
> > +			.psize = (HPAGE_SHIFT == 22 ?
> > +				  PM_PSIZE_4M : PM_PSIZE_2M),
> > +			.swap  = 0,
> > +			.present = 1,
> > +		};
> > +
> > +		for(; addr != end; addr += PAGE_SIZE) {
> > +			err = add_to_pagemap(addr, ppte, pm);
> > +			if (err)
> > +				return err;
> > +		}
> > +	} else
> > +#endif

It's great to make this support huge pages, but things like this
probably need their own function.  Putting an #ifdef in the middle of
here makes it a lot harder to read.  Just think of when powerpc, ia64
and x86_64 get their grubby mitts in here. ;)

-- Dave

