Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbZFKJrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbZFKJrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZFKJr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:47:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41139 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbZFKJr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:47:28 -0400
Date: Thu, 11 Jun 2009 10:47:28 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/2] SLUB: Out-of-memory diagnostics
Message-ID: <20090611094728.GA7302@csn.ul.ie>
References: <Pine.LNX.4.64.0906111142350.6132@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906111142350.6132@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:43:46AM +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> As suggested by Mel Gorman, add out-of-memory diagnostics to the SLUB allocator
> to make debugging OOM conditions easier.

Picky - make debugging page allocation failures easier. OOM in this
context might be conflated with the OOM-killer.

> This patch helped hunt down a nasty
> OOM issue that popped up every now that was caused by SLUB debugging code which
> forced 4096 byte allocations to use order 1 pages even in the fallback case.
> 
> An example print out looks like this:
> 
>   <snip page allocator out-of-memory message>
>   SLUB: Unable to allocate memory on node -1 (gfp=20)

node -1 is an implementation detail. Can it print "current" instead? No
biggie, I know what it means and I suppose anyone debugging an allocation
failure will know too.

gfp is in hex right so gfp=0x20? gfp=20 might have someone thinking it's
the decimal value.

>     cache: kmalloc-4096, object size: 4096, buffer size: 4168, default order: 3, min order: 1
>     node 0: slabs: 95, objs: 665, free: 0
> 

That looks grand

Thanks

> Cc: Christoph Lameter <cl@linux-foundation.org>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slub.c |   70 ++++++++++++++++++++++++++++++++++++++++++++----------------
>  1 files changed, 51 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 65ffda5..2bbacfc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1484,6 +1484,56 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
>  	return 1;
>  }
>  
> +static int count_free(struct page *page)
> +{
> +	return page->objects - page->inuse;
> +}
> +
> +static unsigned long count_partial(struct kmem_cache_node *n,
> +					int (*get_count)(struct page *))
> +{
> +	unsigned long flags;
> +	unsigned long x = 0;
> +	struct page *page;
> +
> +	spin_lock_irqsave(&n->list_lock, flags);
> +	list_for_each_entry(page, &n->partial, lru)
> +		x += get_count(page);
> +	spin_unlock_irqrestore(&n->list_lock, flags);
> +	return x;
> +}
> +
> +static noinline void
> +slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
> +{
> +	int node;
> +
> +	printk(KERN_WARNING
> +		"SLUB: Unable to allocate memory on node %d (gfp=%x)\n",
> +		nid, gfpflags);
> +	printk(KERN_WARNING "  cache: %s, object size: %d, buffer size: %d, "
> +		"default order: %d, min order: %d\n", s->name, s->objsize,
> +		s->size, oo_order(s->oo), oo_order(s->min));
> +
> +	for_each_online_node(node) {
> +		struct kmem_cache_node *n = get_node(s, node);
> +		unsigned long nr_slabs;
> +		unsigned long nr_objs;
> +		unsigned long nr_free;
> +
> +		if (!n)
> +			continue;
> +
> +		nr_slabs = atomic_long_read(&n->nr_slabs);
> +		nr_objs = atomic_long_read(&n->total_objects);
> +		nr_free = count_partial(n, count_free);
> +
> +		printk(KERN_WARNING
> +			"  node %d: slabs: %ld, objs: %ld, free: %ld\n",
> +			node, nr_slabs, nr_objs, nr_free);
> +	}
> +}
> +
>  /*
>   * Slow path. The lockless freelist is empty or we need to perform
>   * debugging duties.
> @@ -1565,6 +1615,7 @@ new_slab:
>  		c->page = new;
>  		goto load_freelist;
>  	}
> +	slab_out_of_memory(s, gfpflags, node);
>  	return NULL;
>  debug:
>  	if (!alloc_debug_processing(s, c->page, object, addr))
> @@ -3318,20 +3369,6 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
>  }
>  
>  #ifdef CONFIG_SLUB_DEBUG
> -static unsigned long count_partial(struct kmem_cache_node *n,
> -					int (*get_count)(struct page *))
> -{
> -	unsigned long flags;
> -	unsigned long x = 0;
> -	struct page *page;
> -
> -	spin_lock_irqsave(&n->list_lock, flags);
> -	list_for_each_entry(page, &n->partial, lru)
> -		x += get_count(page);
> -	spin_unlock_irqrestore(&n->list_lock, flags);
> -	return x;
> -}
> -
>  static int count_inuse(struct page *page)
>  {
>  	return page->inuse;
> @@ -3342,11 +3379,6 @@ static int count_total(struct page *page)
>  	return page->objects;
>  }
>  
> -static int count_free(struct page *page)
> -{
> -	return page->objects - page->inuse;
> -}
> -
>  static int validate_slab(struct kmem_cache *s, struct page *page,
>  						unsigned long *map)
>  {
> -- 
> 1.6.0.4
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
