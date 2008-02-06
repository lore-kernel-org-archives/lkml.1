Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYBFTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYBFTBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbYBFTB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:01:26 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50213 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753070AbYBFTBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:01:25 -0500
Date: Wed, 6 Feb 2008 11:01:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: Support for statistics to help analyze allocator behavior
In-Reply-To: <20080206001948.6f749aa8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802061059110.25173@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
 <20080206001948.6f749aa8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Andrew Morton wrote:

> > @@ -1357,17 +1366,22 @@ static struct page *get_partial(struct k
> >  static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
> >  {
> >  	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
> > +	struct kmem_cache_cpu *c = get_cpu_slab(s, smp_processor_id());
> 
> So we're never running preemptibly here.

Correct.

> > +			if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
> >  			add_full(n, page);
> 
> missing a tab

Ack.

> 
> > +#ifdef CONFIG_SLUB_STATS
> > +
> > +#define STAT_ATTR(si, text) 					\
> > +static ssize_t text##_show(struct kmem_cache *s, char *buf)	\
> > +{								\
> > +	unsigned long sum  = 0;					\
> > +	int cpu;						\
> > +								\
> > +	for_each_online_cpu(cpu)				\
> > +		sum += get_cpu_slab(s, cpu)->stat[si];		\
> 
> maybe cache the get_cpu_slab() result in a local?

Every iteration must perform a different lookup. The cpu variable is 
passed to get_cpu_slab().

> 
> > +	return sprintf(buf, "%lu\n", sum);			\
> > +}								\
> > +SLAB_ATTR_RO(text);						\
> 
> this is pretty broken after cpu hot-unplug, isn't it?

No it still gives all the events on the processors that are up which is 
consistent in some way (and its only stats). There is really no clean 
solution. Same situation as with the event counters in the VM. We could 
fold them into some other processor when it goes down. Yuck.

