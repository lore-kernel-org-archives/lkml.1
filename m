Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbXKIBfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbXKIBfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXKIBfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:35:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:63712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbXKIBfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:35:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,392,1188802800"; 
   d="scan'208";a="375306260"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Patch] Allocate sparse vmemmap block above 4G
Date: Fri, 9 Nov 2007 09:28:42 +0800
Message-ID: <10EA09EFD8728347A513008B6B0DA77A01751532@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <20071108140705.GA2591@skynet.ie>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch] Allocate sparse vmemmap block above 4G
Thread-Index: AcgiELBgURlLtJXaTJeyszJCUlq5EgAWYMmw
References: <1194483127.3046.1471.camel@linux-znh> <20071108140705.GA2591@skynet.ie>
From: "Zou, Nanhai" <nanhai.zou@intel.com>
To: "Mel Gorman" <mel@skynet.ie>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "Dave Jones" <davej@redhat.com>,
       "Martin Ebourne" <fedora@ebourne.me.uk>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andy Whitcroft" <apw@shadowen.org>
X-OriginalArrivalTime: 09 Nov 2007 01:28:45.0154 (UTC) FILETIME=[DE9C0420:01C8226F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Mel Gorman [mailto:mel@skynet.ie]
> Sent: 2007Äê11ÔÂ8ÈÕ 22:07
> To: Zou, Nanhai
> Cc: LKML; Linus Torvalds; Greg KH; Dave Jones; Martin Ebourne; Siddha, Suresh
> B; Andi Kleen; Andrew Morton; Christoph Lameter; Andy Whitcroft
> Subject: Re: [Patch] Allocate sparse vmemmap block above 4G
> 
> On (08/11/07 08:52), Zou Nan hai didst pronounce:
> > Resend the patch for more people to review
> >
> > On some single node x64 system with huge amount of physical memory e.g >
> > 64G. the memmap size maybe very big.
> >
> > If the memmap is allocated from low pages, it may occupies too much
> > memory below 4G.
> > then swiotlb could fail to reserve bounce buffer under 4G which will
> > lead to boot failure.
> >
> > This patch will first try to allocate memmap memory above 4G in sparse
> > vmemmap code.
> > If it failed, it will allocate memmap above MAX_DMA_ADDRESS.
> > This patch is against 2.6.24-rc1-git14
> >
> 
> You never state that you depend on the strict_goal patch either here or in
> a leader mail. The usual way of getting peoples attention is to have three
> mails. In your case it would be
> 
> [PATCH 0/2] Allocate vmemmap from highmem where possible
> [PATCH 1/2] Strictly place bootmem allocations when requested
> [PATCH 2/2] Allocate sparse vmemmap block above 4G on x86_64
> 
> Maybe you have gone through all this already and I'm coming so late that I
> missed it all. If that is the case, sorry for the noise.
Hi Mel,
 Thanks for reviewing.

> 
> > Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >
> > diff -Nraup a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > --- a/arch/x86/mm/init_64.c	2007-11-06 15:16:12.000000000 +0800
> > +++ b/arch/x86/mm/init_64.c	2007-11-06 15:55:50.000000000 +0800
> > @@ -448,6 +448,13 @@ void online_page(struct page *page)
> >  	num_physpages++;
> >  }
> >
> > +void * __meminit alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long
> size,
> > +        unsigned long align)
> > +{
> 
> Wrong markup there I believe. The __meminit markup is for functions
> that are needed at runtime when memory is hot-added or hot-removed.
> Bootmem functions do not qualify. __init is sufficient.
> 
__meminit here is to avoid section link warning here.
this function is called by vmemmap_alloc_block which is a __meminit function,
so if I mark it as __meminit, there were be warning about section mismatch, 
although this function will not be called during memory hotplug time.

> The name is confusing as well. I don't know what a high node is, but I
> think you mean alloc_bootmem_highmem  or alloc_bootmem_highmem_zone.
> That in *itself* is confusing on x86_64 because the memory above 4GiB is
> ZONE_NORMAL, not ZONE_HIGHMEM. Calling it alloc_bootmem_nondma() makes
> it worse.
> 
> I think you need to rework this to have an arch-specific function
> like arch_alloc_vmemmap_block() that by default allocates with
> ____alloc_bootmem_node() and otherwise uses an arch-specific function.
> In this case, it would know to call __alloc_bootmem_core() with the proper
> addressing limits.
> 
> > +        return __alloc_bootmem_core(pgdat->bdata, size,
> > +                        align, (4UL*1024*1024*1024), 0, 1);
> > +}
> 
> More magic values, both the 4GiB address here and the magic "1" at the
> end are problems.
> 
Yes, the 4UL*1024*1024*1024 could be a define here.

However I think define constant for a boolean parameter is overkilling. Look at kernel code, 
e.g.
the force parameter in get_user_pages
and 
the sync parameter in try_to_wake_up 
we don't do things like
#define TRY_TO_WAKEUP_SYNC 1
#define TRY_TO_WAKEUP_NOSYNC 0 

There are other examples in kernel code. I believe it is a common practice not to define constant for a Boolean parameter.
How do you think?

> > +
> >  #ifdef CONFIG_MEMORY_HOTPLUG
> >  /*
> >   * Memory is added always to NORMAL zone. This means you will never get
> > diff -Nraup a/include/linux/bootmem.h b/include/linux/bootmem.h
> > --- a/include/linux/bootmem.h	2007-11-06 16:06:31.000000000 +0800
> > +++ b/include/linux/bootmem.h	2007-11-06 15:50:36.000000000 +0800
> > @@ -61,6 +61,10 @@ extern void *__alloc_bootmem_core(struct
> >  				  unsigned long limit,
> >  				  int strict_goal);
> >
> > +extern void *alloc_bootmem_high_node(pg_data_t *pgdat,
> > +                unsigned long size,
> > +                unsigned long align);
> > +
> 
> Confusing. Your declaration here makes it look like a bootmem API
> function but it is an arch-specific function that only exists for
> x86-64. I know it gets overridden later when a weak symbol but the more
> common approach is to have Kconfig define something like
> ARCH_HIGHMEM_VMEMMAP and
> 
> #ifdef CONFIG_ARCH_HIGHMEM_VMEMMAP
> extern void *alloc_bootmem_high_node(pg_data_t *pgdat,
>                 unsigned long size,
>                 unsigned long align);
> #else
> static inline void *alloc_bootmem_high_node(pg_data_t *pgdat,
> 		unsigned long size,
> 		unsigned long align) {
I was told by Andrew that 
> 	return NULL;
> }
> #endif /* CONFIG_ARCH_HIGHMEM_VMEMMAP
> 
> It's be similar if you have an arch-specific callback for vmalloc block
> allocations instead of extending the bootmem API.
> 
I was told by Andrew that ARCH_HAS_XXX is not preferred half a year before in
http://lkml.org/lkml/2007/5/17/287
So I reworked that patch to the preferred __attribute__ ((weak)))
.....


> >
> >  #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
> >  extern void reserve_bootmem(unsigned long addr, unsigned long size);
> >  #define alloc_bootmem(x) \
> > diff -Nraup a/mm/bootmem.c b/mm/bootmem.c
> > --- a/mm/bootmem.c	2007-11-06 16:06:31.000000000 +0800
> > +++ b/mm/bootmem.c	2007-11-06 15:49:20.000000000 +0800
> > @@ -492,3 +492,11 @@ void * __init __alloc_bootmem_low_node(p
> >  	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
> >  				    ARCH_LOW_ADDRESS_LIMIT, 0);
> >  }
> > +
> > +__attribute__((weak)) __meminit
> 
> __meminit vs _init again
> 
> > +void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size,
> > +        unsigned long align)
> > +{
> > +        return NULL;
> > +}
> > +
> > diff -Nraup a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> > --- a/mm/sparse-vmemmap.c	2007-11-06 15:16:12.000000000 +0800
> > +++ b/mm/sparse-vmemmap.c	2007-11-06 16:08:52.000000000 +0800
> > @@ -43,9 +43,13 @@ void * __meminit vmemmap_alloc_block(uns
> >  		if (page)
> >  			return page_address(page);
> >  		return NULL;
> > -	} else
> > +	} else {
> > +		void *p = alloc_bootmem_high_node(NODE_DATA(node), size, size);
> > +		if (p)
> > +			return p;
> >  		return __alloc_bootmem_node(NODE_DATA(node), size, size,
> >  				__pa(MAX_DMA_ADDRESS));
> 
> If you had an arch-specific function, I guess this would turn into
> 
> 	} else {
> 		return arch_vmemmap_alloc_block(...);
> 	}
> 
> > +	}
> >  }
> >
> >  void __meminit vmemmap_verify(pte_t *pte, int node,
> >
> >
> >
> >
> 
> --
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
