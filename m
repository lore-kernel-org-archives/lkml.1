Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXBVIkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXBVIkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbXBVIj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:39:59 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:22305 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751510AbXBVIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:39:58 -0500
Subject: Re: SLUB: The unqueued Slab allocator
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:34:34 +0100
Message-Id: <1172133274.6374.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 23:00 -0800, Christoph Lameter wrote:

> +/*
> + * Lock order:
> + *   1. slab_lock(page)
> + *   2. slab->list_lock
> + *

That seems to contradict this:

> +/*
> + * Lock page and remove it from the partial list
> + *
> + * Must hold list_lock
> + */
> +static __always_inline int lock_and_del_slab(struct kmem_cache *s,
> +						struct page *page)
> +{
> +	if (slab_trylock(page)) {
> +		list_del(&page->lru);
> +		s->nr_partial--;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Get a partial page, lock it and return it.
> + */
> +#ifdef CONFIG_NUMA
> +static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
> +{
> +	struct page *page;
> +	int searchnode = (node == -1) ? numa_node_id() : node;
> +
> +	if (!s->nr_partial)
> +		return NULL;
> +
> +	spin_lock(&s->list_lock);
> +	/*
> +	 * Search for slab on the right node
> +	 */
> +	list_for_each_entry(page, &s->partial, lru)
> +		if (likely(page_to_nid(page) == searchnode) &&
> +			lock_and_del_slab(s, page))
> +				goto out;
> +
> +	if (likely(!(flags & __GFP_THISNODE))) {
> +		/*
> +		 * We can fall back to any other node in order to
> +		 * reduce the size of the partial list.
> +		 */
> +		list_for_each_entry(page, &s->partial, lru)
> +			if (likely(lock_and_del_slab(s, page)))
> +				goto out;
> +	}
> +
> +	/* Nothing found */
> +	page = NULL;
> +out:
> +	spin_unlock(&s->list_lock);
> +	return page;
> +}
> +#else
> +static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
> +{
> +	struct page *page;
> +
> +	/*
> +	 * Racy check. If we mistakenly see no partial slabs then we
> +	 * just allocate an empty slab.
> +	 */
> +	if (!s->nr_partial)
> +		return NULL;
> +
> +	spin_lock(&s->list_lock);
> +	list_for_each_entry(page, &s->partial, lru)
> +		if (likely(lock_and_del_slab(s, page)))
> +			goto out;
> +
> +	/* No slab or all slabs busy */
> +	page = NULL;
> +out:
> +	spin_unlock(&s->list_lock);
> +	return page;
> +}
> +#endif

