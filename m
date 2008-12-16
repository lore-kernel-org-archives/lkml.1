Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758449AbYLPXTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbYLPXTd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbYLPXTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:19:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:47988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYLPXTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:19:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,233,1228118400"; 
   d="scan'208";a="371475862"
Date: Tue, 16 Dec 2008 15:19:16 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "npiggin@suse.de" <npiggin@suse.de>,
        "hugh@veritas.com" <hugh@veritas.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 5/8] x86 PAT: Implement track/untrack of pfnmap regions for x86
Message-ID: <20081216231916.GA1992@linux-os.sc.intel.com>
References: <20081112212647.259698000@intel.com> <20081112212900.578371000@intel.com> <20081216120759.ef11cde8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216120759.ef11cde8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 12:07:59PM -0800, Andrew Morton wrote:
> Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> >  2 files changed, 211 insertions(+)
> > 
> > Index: tip/arch/x86/mm/pat.c
> > ===================================================================
> > --- tip.orig/arch/x86/mm/pat.c	2008-11-12 09:55:55.000000000 -0800
> > +++ tip/arch/x86/mm/pat.c	2008-11-12 12:06:50.000000000 -0800
> > @@ -596,6 +596,207 @@ void unmap_devmem(unsigned long pfn, uns
> >  	free_memtype(addr, addr + size);
> >  }
> >  
> > +int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t vma_prot)
> 
> I don't think the kernel is improved by leaving all these things
> undocumented.
> 
> These are interfaces which other architectures might choose to
> implement, so a few words explaining why they exist, what they are
> supposed to do, etc wouldn't hurt.
> 
> It would certainly help code reviewers.

Agreed. Will add documentation to the new functions here and update the patch.

> 
> > +{
> > +	unsigned long flags;
> > +	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
> > +
> > +	int is_ram = 0;
> > +	int id_sz, ret;
> 
> The newline in the middle of the definition of locals makes no sense.

Will change.

> > +	is_ram = pagerange_is_ram(paddr, paddr + size);
> > +
> > +	if (is_ram != 0) {
> > +		/*
> > +		 * For mapping RAM pages, drivers need to call
> > +		 * set_memory_[uc|wc|wb] directly, for reserve and free, before
> > +		 * setting up the PTE.
> > +		 */
> > +		WARN_ON_ONCE(1);
> > +		return 0;
> > +	}
> > +
> > +	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (flags != want_flags) {
> > +		free_memtype(paddr, paddr + size);
> > +		printk(KERN_INFO
> 
> Would KERN_ERR be more appropriate?

OK.

> 
> > +		"%s:%d map pfn expected mapping type %s for %Lx-%Lx, got %s\n",
> > +			current->comm, current->pid,
> 
> get_task_comm() is more reliable, but it hardly matters here.

current->comm was used at other places in this file. I should probably change
all of them as a separate cleanup patch.

> 
> > +			cattr_name(want_flags),
> > +			paddr, (unsigned long long)(paddr + size),
> 
> Printing the u64 paddr without a cast is OK in arch code (we know that
> u64 is implemented as unsigned long long).  But one might choose to
> cast it anyway, to set a good example.
> 
> Or one could not bother.  But this code does it both ways!
> 

Will change.

> > +			cattr_name(flags));
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Need to keep identity mapping in sync */
> > +	if (paddr >= __pa(high_memory))
> > +		return 0;
> > +
> > +	id_sz = (__pa(high_memory) < paddr + size) ?
> > +				__pa(high_memory) - paddr :
> > +				size;
> > +
> > +	if (ioremap_change_attr((unsigned long)__va(paddr), id_sz, flags) < 0) {
> > +		free_memtype(paddr, paddr + size);
> > +		printk(KERN_INFO
> 
> KERN_ERR?

OK.

> 
> > +			"%s:%d reserve_pfn_range ioremap_change_attr failed %s "
> > +			"for %Lx-%Lx\n",
> > +			current->comm, current->pid,
> > +			cattr_name(flags),
> > +			paddr, (unsigned long long)(paddr + size));
> 
> ditto

Will do.

> 
> > +		return -EINVAL;
> > +	}
> > +	return 0;
> > +}
> > +
> > +void free_pfn_range(u64 paddr, unsigned long size)
> > +{
> > +	int is_ram;
> > +
> > +	is_ram = pagerange_is_ram(paddr, paddr + size);
> > +	if (is_ram == 0)
> > +		free_memtype(paddr, paddr + size);
> > +}
> >
> > ...
> >
> > +int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
> > +			unsigned long pfn, unsigned long size)
> > +{
> > +	int retval = 0;
> > +	unsigned long i, j;
> > +	u64 base_paddr;
> > +	u64 paddr;
> > +	unsigned long vma_start = vma->vm_start;
> > +	unsigned long vma_end = vma->vm_end;
> > +	unsigned long vma_size = vma_end - vma_start;
> > +
> > +	if (!pat_enabled)
> > +		return 0;
> > +
> > +	if (is_linear_pfn_mapping(vma)) {
> > +		/* reserve the whole chunk starting from vm_pgoff */
> > +		paddr = (u64)vma->vm_pgoff << PAGE_SHIFT;
> > +		return reserve_pfn_range(paddr, vma_size, prot);
> > +	}
> > +
> > +	/* reserve page by page using pfn and size */
> > +	base_paddr = (u64)pfn << PAGE_SHIFT;
> > +	for (i = 0; i < size; i += PAGE_SIZE) {
> > +		paddr = base_paddr + i;
> > +		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
> > +		if (retval)
> > +			goto cleanup_ret;
> > +	}
> > +	return 0;
> > +
> > +cleanup_ret:
> > +	/* Reserve error: Cleanup partial reservation and return error */
> > +	for (j = 0; j < i; j += PAGE_SIZE) {
> > +		paddr = base_paddr + j;
> > +		free_pfn_range(paddr, PAGE_SIZE);
> 
> Could we simply do
> 
> 	free_pfn_range(base_paddr, i * PAGE_SIZE);
> 
> here?
> 
> If not, then perhaps add a helper function to do this, because that
> loop gets repeated in several places.
> 	

 	free_pfn_range(base_paddr, i * PAGE_SIZE);

will not work as free should correspond to reserve granularity. I agree making
this a function should make this cleaner. Will do that in the refresh of this
patch.

Thanks,
Venki

