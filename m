Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZFKTjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZFKTjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZFKTjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:39:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZFKTjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:39:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yfvKq5RXcKIte5hXMotWCJO2ItL6c5f6EvQ+PoVWd+g0kjb8V8zcqg3tyGqRDNniU
	aw7SXJeoQwbIUpCX5W/Gg==
Date: Thu, 11 Jun 2009 12:39:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mel@csn.ul.ie,
       Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/2] SLUB: Out-of-memory diagnostics
In-Reply-To: <Pine.LNX.4.64.0906111142350.6132@melkki.cs.Helsinki.FI>
Message-ID: <alpine.DEB.2.00.0906111231290.26482@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0906111142350.6132@melkki.cs.Helsinki.FI>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Pekka J Enberg wrote:

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

This won't compile unless CONFIG_SLUB_DEBUG is enabled.

Perhaps slab_out_of_memory()'s partial list scan should only be declared 
for CONFIG_SLUB_DEBUG?  Otherwise, nr_slabs and nr_objs will always be 0 
since we don't increment them and nr_free will appear out of sync.  I 
suspect debuggers will be asking if CONFIG_SLUB_DEBUG is enabled often in 
such scenarios.

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

I assume this is being added to __slab_alloc() and not new_slab() because 
you need to reenable irqs before using count_partial()?

Do you really need to move count_partial() and count_free() out from under 
CONFIG_SLUB_DEBUG?  Couldn't you just add this to new_slab():

	out:
		if (!page)
			slab_out_of_memory(s, flags, node);
		return page;

and then add your own partial list scanner in slab_out_of_memory():

	nr_free = 0;
	spin_lock(&n->list_lock);
	list_for_each_entry(page, &n->partial, lru)
		nr_free += page->objects - page->inuse;
	spin_unlock(&n->list_lock);
