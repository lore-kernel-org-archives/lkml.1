Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbXKIOnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbXKIOnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 09:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbXKIOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 09:43:05 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40366 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760130AbXKIOnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 09:43:02 -0500
Date: Fri, 9 Nov 2007 14:42:59 +0000
To: "Zou, Nanhai" <nanhai.zou@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [Patch] Allocate sparse vmemmap block above 4G
Message-ID: <20071109144259.GA23553@skynet.ie>
References: <1194483127.3046.1471.camel@linux-znh> <20071108140705.GA2591@skynet.ie> <10EA09EFD8728347A513008B6B0DA77A01751532@pdsmsx411.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <10EA09EFD8728347A513008B6B0DA77A01751532@pdsmsx411.ccr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/11/07 09:28), Zou, Nanhai didst pronounce:

> > Wrong markup there I believe. The __meminit markup is for functions
> > that are needed at runtime when memory is hot-added or hot-removed.
> > Bootmem functions do not qualify. __init is sufficient.
> > 
> __meminit here is to avoid section link warning here.
> this function is called by vmemmap_alloc_block which is a __meminit function,
> so if I mark it as __meminit, there were be warning about section mismatch, 
> although this function will not be called during memory hotplug time.
> 

Ok, that is fair enough and good enough reason to mark it __meminit.
It's a pity in one sense because a dead function remains in the loaded
kernel image but I can't think of a nice way around it right now.

> > The name is confusing as well. I don't know what a high node is, but I
> > think you mean alloc_bootmem_highmem  or alloc_bootmem_highmem_zone.
> > That in *itself* is confusing on x86_64 because the memory above 4GiB is
> > ZONE_NORMAL, not ZONE_HIGHMEM. Calling it alloc_bootmem_nondma() makes
> > it worse.
> > 
> > I think you need to rework this to have an arch-specific function
> > like arch_alloc_vmemmap_block() that by default allocates with
> > ____alloc_bootmem_node() and otherwise uses an arch-specific function.
> > In this case, it would know to call __alloc_bootmem_core() with the proper
> > addressing limits.
> > 
> > > +        return __alloc_bootmem_core(pgdat->bdata, size,
> > > +                        align, (4UL*1024*1024*1024), 0, 1);
> > > +}
> > 
> > More magic values, both the 4GiB address here and the magic "1" at the
> > end are problems.
> > 
> Yes, the 4UL*1024*1024*1024 could be a define here.
> 
> However I think define constant for a boolean parameter is overkilling. Look at kernel code, 
> e.g.
> the force parameter in get_user_pages
> and 
> the sync parameter in try_to_wake_up 
> we don't do things like
> #define TRY_TO_WAKEUP_SYNC 1
> #define TRY_TO_WAKEUP_NOSYNC 0 
> 
> There are other examples in kernel code. I believe it is a common practice not to define constant for a Boolean parameter.
> How do you think?
> 

I guess it's a question of personal taste. I am not a fan of magic numbers
because it's not clear from the call-site what "1" means. It could be a
value of 1 or a boolean true requiring that I double check the function
being called. I would have used either a #define or defined

__something() - internal to a C file
something()   - non-strict version
something_strict() - the strict version

so it's obvious from the call-site what the intention is. However, I
imagine there are people puking at that notion too.

Fix up the 4GB magic number at least so it reflects that it is DMA32 you
are talking about.

> > > +
> > >  #ifdef CONFIG_MEMORY_HOTPLUG
> > >  /*
> > >   * Memory is added always to NORMAL zone. This means you will never get
> > > diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
> > > --- a/include/linux/bootmem.h	2007-11-06 16:06:31.000000000 +0800
> > > +++ b/include/linux/bootmem.h	2007-11-06 15:50:36.000000000 +0800
> > > @@ -61,6 +61,10 @@ extern void *__alloc_bootmem_core(struct
> > >  				  unsigned long limit,
> > >  				  int strict_goal);
> > >
> > > +extern void *alloc_bootmem_high_node(pg_data_t *pgdat,
> > > +                unsigned long size,
> > > +                unsigned long align);
> > > +
> > 
> > Confusing. Your declaration here makes it look like a bootmem API
> > function but it is an arch-specific function that only exists for
> > x86-64. I know it gets overridden later when a weak symbol but the more
> > common approach is to have Kconfig define something like
> > ARCH_HIGHMEM_VMEMMAP and
> > 
> > #ifdef CONFIG_ARCH_HIGHMEM_VMEMMAP
> > extern void *alloc_bootmem_high_node(pg_data_t *pgdat,
> >                 unsigned long size,
> >                 unsigned long align);
> > #else
> > static inline void *alloc_bootmem_high_node(pg_data_t *pgdat,
> > 		unsigned long size,
> > 		unsigned long align) {
> I was told by Andrew that 
> > 	return NULL;
> > }
> > #endif /* CONFIG_ARCH_HIGHMEM_VMEMMAP
> > 
> > It's be similar if you have an arch-specific callback for vmalloc block
> > allocations instead of extending the bootmem API.
> > 
> I was told by Andrew that ARCH_HAS_XXX is not preferred half a year before in
> http://lkml.org/lkml/2007/5/17/287
> So I reworked that patch to the preferred __attribute__ ((weak)))
> .....
> 

Ok, my bad. I wasn't aware of that.

> 
> > >
> > >  #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
> > >  extern void reserve_bootmem(unsigned long addr, unsigned long size);
> > >  #define alloc_bootmem(x) \
> > > diff -Nraup a/mm/bootmem.c b/mm/bootmem.c
> > > --- a/mm/bootmem.c	2007-11-06 16:06:31.000000000 +0800
> > > +++ b/mm/bootmem.c	2007-11-06 15:49:20.000000000 +0800
> > > @@ -492,3 +492,11 @@ void * __init __alloc_bootmem_low_node(p
> > >  	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
> > >  				    ARCH_LOW_ADDRESS_LIMIT, 0);
> > >  }
> > > +
> > > +__attribute__((weak)) __meminit
> > 
> > __meminit vs _init again
> > 
> > > +void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size,
> > > +        unsigned long align)
> > > +{
> > > +        return NULL;
> > > +}
> > > +
> > > diff -Nraup a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> > > --- a/mm/sparse-vmemmap.c	2007-11-06 15:16:12.000000000 +0800
> > > +++ b/mm/sparse-vmemmap.c	2007-11-06 16:08:52.000000000 +0800
> > > @@ -43,9 +43,13 @@ void * __meminit vmemmap_alloc_block(uns
> > >  		if (page)
> > >  			return page_address(page);
> > >  		return NULL;
> > > -	} else
> > > +	} else {
> > > +		void *p = alloc_bootmem_high_node(NODE_DATA(node), size, size);
> > > +		if (p)
> > > +			return p;
> > >  		return __alloc_bootmem_node(NODE_DATA(node), size, size,
> > >  				__pa(MAX_DMA_ADDRESS));
> > 
> > If you had an arch-specific function, I guess this would turn into
> > 
> > 	} else {
> > 		return arch_vmemmap_alloc_block(...);
> > 	}
> > 
> > > +	}
> > >  }
> > >
> > >  void __meminit vmemmap_verify(pte_t *pte, int node,
> > >
> > >
> > >
> > >
> > 
> > --
> > --
> > Mel Gorman
> > Part-time Phd Student                          Linux Technology Center
> > University of Limerick                         IBM Dublin Software Lab
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
