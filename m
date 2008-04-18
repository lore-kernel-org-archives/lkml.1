Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYDRWNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYDRWNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYDRWM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:12:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33635 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbYDRWMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:12:55 -0400
Date: Fri, 18 Apr 2008 15:12:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slub: add hooks for kmemcheck
In-Reply-To: <20080418220339.GC16586@damson.getinternet.no>
Message-ID: <Pine.LNX.4.64.0804181507130.31394@schroedinger.engr.sgi.com>
References: <20080418220339.GC16586@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008, Vegard Nossum wrote:

> index f62caaa..d5505b1 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -29,6 +29,13 @@
>  #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
>  #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
>  
> +#ifdef CONFIG_KMEMCHECK
> +/* Don't track use of uninitialized memory */
> +# define SLAB_NOTRACK		0x00400000UL
> +#else
> +# define SLAB_NOTRACK		0
> +#endif
> +

It maybe easier to just avoid the #ifdef. The other debug flags also only 
have a function if certain kernel config options are set.

> +#ifdef CONFIG_KMEMCHECK
> +struct page *kmemcheck_allocate_slab(struct kmem_cache *s,
> +	gfp_t flags, int node, int pages);
> +void kmemcheck_free_slab(struct kmem_cache *s, struct page *page, int pages);
> +
> +void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object);
> +void kmemcheck_slab_free(struct kmem_cache *s, void *object);
> +#else
> +static inline struct page *kmemcheck_allocate_slab(struct kmem_cache *s,
> +	gfp_t flags, int node, int pages) { return NULL; }
> +static inline void kmemcheck_free_slab(struct kmem_cache *s,
> +	struct page *page, int pages) { }
> +static inline void kmemcheck_slab_alloc(struct kmem_cache *s,
> +	gfp_t gfpflags, void *object) { }
> +static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object) { }
> +#endif /* CONFIG_KMEMCHECK */
> +

Should this not go into some kmemcheck.h file?

>  	}
>  
> +	if (kmemcheck_page_is_tracked(page) && !(s->flags & SLAB_NOTRACK)) {
> +		kmemcheck_free_slab(s, page, pages);
> +		return;
> +	}
> +
> +	__ClearPageSlab(page);
> +

Why is __ClearPageSlab moved?

> @@ -2449,12 +2462,10 @@ static int __init setup_slub_nomerge(char *str)
>  __setup("slub_nomerge", setup_slub_nomerge);
>  
>  static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
> -		const char *name, int size, gfp_t gfp_flags)
> +	const char *name, int size, gfp_t gfp_flags, unsigned int flags)

The second flags parameter is always 0?

