Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbXENPth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbXENPth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXENPta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:49:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34285 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752403AbXENPta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:49:30 -0400
Date: Mon, 14 May 2007 08:49:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/5] mm: slub allocation fairness
In-Reply-To: <20070514133212.581041171@chello.nl>
Message-ID: <Pine.LNX.4.64.0705140847330.10442@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> <20070514133212.581041171@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Peter Zijlstra wrote:

> Index: linux-2.6-git/include/linux/slub_def.h
> ===================================================================
> --- linux-2.6-git.orig/include/linux/slub_def.h
> +++ linux-2.6-git/include/linux/slub_def.h
> @@ -52,6 +52,7 @@ struct kmem_cache {
>  	struct kmem_cache_node *node[MAX_NUMNODES];
>  #endif
>  	struct page *cpu_slab[NR_CPUS];
> +	int rank;
>  };

Ranks as part of the kmem_cache structure? I thought this is a temporary 
thing?

>   * Lock order:
> @@ -961,6 +962,8 @@ static struct page *allocate_slab(struct
>  	if (!page)
>  		return NULL;
>  
> +	s->rank = page->index;
> +

Argh.... Setting a cache structure field from a page struct field? What 
about concurrency?

> @@ -1371,8 +1376,12 @@ static void *__slab_alloc(struct kmem_ca
>  		gfp_t gfpflags, int node, void *addr, struct page *page)
>  {
>  	void **object;
> -	int cpu = smp_processor_id();
> +	int cpu;
> +
> +	if (page == FORCE_PAGE)
> +		goto force_new;
>  
> +	cpu = smp_processor_id();
>  	if (!page)
>  		goto new_slab;
>  
> @@ -1405,6 +1414,7 @@ have_slab:
>  		goto load_freelist;
>  	}
>  
> +force_new:
>  	page = new_slab(s, gfpflags, node);
>  	if (page) {
>  		cpu = smp_processor_id();
> @@ -1465,15 +1475,22 @@ static void __always_inline *slab_alloc(
>  	struct page *page;
>  	void **object;
>  	unsigned long flags;
> +	int rank = slab_alloc_rank(gfpflags);
>  
>  	local_irq_save(flags);
> +	if (slab_insufficient_rank(s, rank)) {
> +		page = FORCE_PAGE;
> +		goto force_alloc;
> +	}
> +
>  	page = s->cpu_slab[smp_processor_id()];
>  	if (unlikely(!page || !page->lockless_freelist ||
> -			(node != -1 && page_to_nid(page) != node)))
> +			(node != -1 && page_to_nid(page) != node))) {
>  
> +force_alloc:
>  		object = __slab_alloc(s, gfpflags, node, addr, page);
>  
> -	else {
> +	} else {
>  		object = page->lockless_freelist;
>  		page->lockless_freelist = object[page->offset];
>  	}

This is the hot path. No modifications please.


