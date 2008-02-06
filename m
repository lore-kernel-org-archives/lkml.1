Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbYBFITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbYBFITy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYBFITp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:19:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbYBFITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:19:44 -0500
Date: Wed, 6 Feb 2008 00:19:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
Message-Id: <20080206001948.6f749aa8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 22:20:04 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> The statistics provided here allow the monitoring of allocator behavior
> at the cost of some (minimal) loss of performance. Counters are placed in
> SLUB's per cpu data structure that is already written to by other code.

Seems sane.

> The per cpu structure may be extended by the statistics to be more than
> one cacheline which will increase the cache footprint of SLUB.
>
> That is why there is a compile option to enable/disable the inclusion of
> the statistics module. 

The compile-time optionality is really sad.  But no obvious solution
suggests itself.

> @@ -1357,17 +1366,22 @@ static struct page *get_partial(struct k
>  static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
>  {
>  	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
> +	struct kmem_cache_cpu *c = get_cpu_slab(s, smp_processor_id());

So we're never running preemptibly here.

>  	ClearSlabFrozen(page);
>  	if (page->inuse) {
>  
> -		if (page->freelist != page->end)
> +		if (page->freelist != page->end) {
>  			add_partial(n, page, tail);
> -		else if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
> +			stat(c, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
> +		} else {
> +			stat(c, DEACTIVATE_FULL);
> +			if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
>  			add_full(n, page);

missing a tab

> +#ifdef CONFIG_SLUB_STATS
> +
> +#define STAT_ATTR(si, text) 					\
> +static ssize_t text##_show(struct kmem_cache *s, char *buf)	\
> +{								\
> +	unsigned long sum  = 0;					\
> +	int cpu;						\
> +								\
> +	for_each_online_cpu(cpu)				\
> +		sum += get_cpu_slab(s, cpu)->stat[si];		\

maybe cache the get_cpu_slab() result in a local?

> +	return sprintf(buf, "%lu\n", sum);			\
> +}								\
> +SLAB_ATTR_RO(text);						\

this is pretty broken after cpu hot-unplug, isn't it?


