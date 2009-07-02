Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZGBKky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZGBKky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZGBKkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:40:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51938 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZGBKkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:40:41 -0400
Date: Thu, 2 Jul 2009 11:40:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix virt_to_phys() warnings
Message-ID: <20090702104027.GB14804@linux-mips.org>
References: <910ba280decc9ee53d9971ba04f73fab@localhost> <20090701224627.0b2704df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701224627.0b2704df.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 10:46:27PM -0700, Andrew Morton wrote:

> > mm/page_alloc.c: In function 'alloc_pages_exact':
> > mm/page_alloc.c:1986: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
> > 
> > drivers/usb/mon/mon_bin.c: In function 'mon_alloc_buff':
> > drivers/usb/mon/mon_bin.c:1264: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
> > 
> > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> > ---
> > diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
> > index f8d9045..0f7a30b 100644
> > --- a/drivers/usb/mon/mon_bin.c
> > +++ b/drivers/usb/mon/mon_bin.c
> > @@ -1261,7 +1261,7 @@ static int mon_alloc_buff(struct mon_pgmap *map, int npages)
> >  			return -ENOMEM;
> >  		}
> >  		map[n].ptr = (unsigned char *) vaddr;
> > -		map[n].pg = virt_to_page(vaddr);
> > +		map[n].pg = virt_to_page((void *) vaddr);
> >  	}
> >  	return 0;
> >  }
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 5d714f8..f6180db 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1983,7 +1983,7 @@ void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
> >  		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> >  		unsigned long used = addr + PAGE_ALIGN(size);
> >  
> > -		split_page(virt_to_page(addr), order);
> > +		split_page(virt_to_page((void *)addr), order);
> >  		while (used < alloc_end) {
> >  			free_page(used);
> >  			used += PAGE_SIZE;
> 
> The virt_to_foo() functions were written back in the Linux dark ages and
> they're horrid.  A byzantine mixture of macros and typecasts which make
> it really hard to work out what type their argument actually should be.

No disagreement there.

> virt_to_page() takes an argument of type `unsigned long'.  (except for
> the include/asm-generic/page.h version which takes any damn type at
> all).

You meant it takes a pointer argument, for example:

mm/page_alloc.c:
	__free_pages(virt_to_page((void *)addr), order);
mm/slob.c:
static inline struct slob_page *slob_page(const void *addr)
{
        return (struct slob_page *)virt_to_page(addr);
}


> virt_to_phys() takes an argument of `const void *' (weird, huh?)

volatile void * seems to be the most common type.  MIPS is the only arch
that accepts volatile const void *; Alpha uses a plain void *.

I don't recall why MIPS uses volatile const - probably to silence warnings
about discarding qualifiers from pointer target type.

> But arch/mips/include/asm/page.h does
> 
> #define virt_to_page(kaddr)        pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
> 
> thereby passing an `unsigned long' where a void* was expected.
> 
> 
> So perhaps something along these lines:
> 
> 
> --- a/arch/mips/include/asm/page.h~a
> +++ a/arch/mips/include/asm/page.h
> @@ -184,7 +184,11 @@ typedef struct { unsigned long pgprot; }
>  
>  #endif
>  
> -#define virt_to_page(kaddr)	pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
> +static inline struct page *virt_to_page(unsigned long kaddr)
> +{
> +	return pfn_to_page(PFN_DOWN(virt_to_phys((void *)kaddr)));
> +}
> +

Doesn't compile because pfn_to_page is defined in <asm-generic/memory_model.h>
which will only be included further down and moving the order of the order
of things around to get this to build is getting ugly, so I gave up on it.

Anyway, since virt_to_page and virt_to_phys (imho :-) take the same
argument times I'm in favor of Kevin's patch.

  Ralf
