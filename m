Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYDRW1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYDRW1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYDRW1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:27:47 -0400
Received: from po-out-1718.google.com ([72.14.252.157]:51970 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYDRW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hz1TtRnunZrIkrWSiMRhjeu0bYvZnViudYrUBHYUj4w5BEpQGn2iGwUWkllStroT7p3XGETmxqTdbGbQRi1nARJmd3nOBbnoIzRpHkccEkggVT4yMvraC19DTDCx4jPx5UReVds/5gjyRw928tcKuHl+fliSbDTQORXW+p+3AMc=
Message-ID: <19f34abd0804181527i3b65e82bk2a5d8b3c2b196f9e@mail.gmail.com>
Date: Sat, 19 Apr 2008 00:27:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 3/3] slub: add hooks for kmemcheck
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804181507130.31394@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080418220339.GC16586@damson.getinternet.no>
	 <Pine.LNX.4.64.0804181507130.31394@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments.

On Sat, Apr 19, 2008 at 12:12 AM, Christoph Lameter <clameter@sgi.com> wrote:
> On Sat, 19 Apr 2008, Vegard Nossum wrote:
>
>  > index f62caaa..d5505b1 100644
>  > --- a/include/linux/slab.h
>  > +++ b/include/linux/slab.h
>  > @@ -29,6 +29,13 @@
>  >  #define SLAB_MEM_SPREAD              0x00100000UL    /* Spread some memory over cpuset */
>  >  #define SLAB_TRACE           0x00200000UL    /* Trace allocations and frees */
>  >
>  > +#ifdef CONFIG_KMEMCHECK
>  > +/* Don't track use of uninitialized memory */
>  > +# define SLAB_NOTRACK                0x00400000UL
>  > +#else
>  > +# define SLAB_NOTRACK                0
>  > +#endif
>  > +
>
>  It maybe easier to just avoid the #ifdef. The other debug flags also only
>  have a function if certain kernel config options are set.

We set it to zero to allow the compiler to optimize out code if
CONFIG_KMEMCHECK=n. For instance

        if (kmemcheck_page_is_tracked(page) && !(s->flags & SLAB_NOTRACK)) {

Will be turned into if(0 && !(s->flags & 0)), which can be completely
optimized away. On the other hand, if SLAB_NOTRACK is non-zero, this
is not the case, since the flag must be tested.

>  > +#ifdef CONFIG_KMEMCHECK
>  > +struct page *kmemcheck_allocate_slab(struct kmem_cache *s,
>  > +     gfp_t flags, int node, int pages);
>  > +void kmemcheck_free_slab(struct kmem_cache *s, struct page *page, int pages);
>  > +
>  > +void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object);
>  > +void kmemcheck_slab_free(struct kmem_cache *s, void *object);
>  > +#else
>  > +static inline struct page *kmemcheck_allocate_slab(struct kmem_cache *s,
>  > +     gfp_t flags, int node, int pages) { return NULL; }
>  > +static inline void kmemcheck_free_slab(struct kmem_cache *s,
>  > +     struct page *page, int pages) { }
>  > +static inline void kmemcheck_slab_alloc(struct kmem_cache *s,
>  > +     gfp_t gfpflags, void *object) { }
>  > +static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object) { }
>  > +#endif /* CONFIG_KMEMCHECK */
>  > +
>
>  Should this not go into some kmemcheck.h file?

The implementations of these prototypes are in mm/slub_kmemcheck.c.
They are only ever called from slub.c since they represent the
interface between SLUB and kmemcheck.

Would you rather have it in include/linux/slub_kmemcheck.h?

>  >       }
>  >
>  > +     if (kmemcheck_page_is_tracked(page) && !(s->flags & SLAB_NOTRACK)) {
>  > +             kmemcheck_free_slab(s, page, pages);
>  > +             return;
>  > +     }
>  > +
>  > +     __ClearPageSlab(page);
>  > +
>
>  Why is __ClearPageSlab moved?

It has been moved because the flag should only be cleared just before
it is returned to the page allocator.

Currently, with SLAB/SLUB debugging enabled, the page flag will be
cleared, then accessed in check_object(), thus generating a few
accesses to the page. It is safer to delay the clearing of the page
flag until no more accesses can be generated for the page.

>  > @@ -2449,12 +2462,10 @@ static int __init setup_slub_nomerge(char *str)
>  >  __setup("slub_nomerge", setup_slub_nomerge);
>  >
>  >  static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
>  > -             const char *name, int size, gfp_t gfp_flags)
>  > +     const char *name, int size, gfp_t gfp_flags, unsigned int flags)
>
>  The second flags parameter is always 0?

Hm, let's see... Yep, you are correct. This is an artifact from
previous versions, where this flag was actually used, and should now
be removed!

Thanks!

Vegard


-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
