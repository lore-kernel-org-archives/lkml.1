Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbXFZHWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbXFZHWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbXFZHWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 03:22:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbXFZHWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 03:22:35 -0400
Date: Tue, 26 Jun 2007 00:21:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: poor man's NUMA support.
Message-Id: <20070626002131.ff3518d4.akpm@linux-foundation.org>
In-Reply-To: <20070619090616.GA23697@linux-sh.org>
References: <20070619090616.GA23697@linux-sh.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 18:06:16 +0900 Paul Mundt <lethal@linux-sh.org> wrote:

> This adds preliminary NUMA support to SLOB, primarily aimed at systems
> with small nodes (tested all the way down to a 128kB SRAM block), whether
> asymmetric or otherwise.
> 
> We follow the same conventions as SLAB/SLUB, preferring current node
> placement for new pages, or with explicit placement, if a node has been
> specified. Presently on UP NUMA this has the side-effect of preferring
> node#0 allocations (since numa_node_id() == 0, though this could be
> reworked if we could hand off a pfn to determine node placement), so
> single-CPU NUMA systems will want to place smaller nodes further out in
> terms of node id. Once a page has been bound to a node (via explicit
> node id typing), we only do block allocations from partial free pages
> that have a matching node id in the page flags.
> 
> The current implementation does have some scalability problems, in that
> all partial free pages are tracked in the global freelist (with
> contention due to the single spinlock). However, these are things that
> are being reworked for SMP scalability first, while things like per-node
> freelists can easily be built on top of this sort of functionality once
> it's been added.
> 
> More background can be found in:
> 
> 	http://marc.info/?l=linux-mm&m=118117916022379&w=2
> 	http://marc.info/?l=linux-mm&m=118170446306199&w=2
> 	http://marc.info/?l=linux-mm&m=118187859420048&w=2
> 
> and subsequent threads.
> 
> ...
>  
> +static void *slob_new_page(gfp_t gfp, int order, int node)
> +{
> +	void *page;
> +
> +#ifdef CONFIG_NUMA
> +	if (node != -1)
> +		page = alloc_pages_node(node, gfp, order);
> +	else
> +#endif
> +		page = alloc_pages(gfp, order);

Isn't the above equivalent to a bare

	page = alloc_pages_node(node, gfp, order);

?

> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
> +}
> +
>  /*
>   * Allocate a slob block within a given slob_page sp.
>   */
> @@ -258,7 +290,7 @@ static void *slob_page_alloc(struct slob_page *sp, size_t size, int align)
>  /*
>   * slob_alloc: entry point into the slob allocator.
>   */
> -static void *slob_alloc(size_t size, gfp_t gfp, int align)
> +static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
>  {
>  	struct slob_page *sp;
>  	slob_t *b = NULL;
> @@ -267,6 +299,15 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align)
>  	spin_lock_irqsave(&slob_lock, flags);
>  	/* Iterate through each partially free page, try to find room */
>  	list_for_each_entry(sp, &free_slob_pages, list) {
> +#ifdef CONFIG_NUMA
> +		/*
> +		 * If there's a node specification, search for a partial
> +		 * page with a matching node id in the freelist.
> +		 */
> +		if (node != -1 && page_to_nid(&sp->page) != node)

Other code does

	if (node < 0

rather than comparing with -1 exactly.

On many CPUs it'll save a few bytes of code.


