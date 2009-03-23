Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbZCWQn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbZCWQn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbZCWQnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:43:47 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49119 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425AbZCWQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:43:46 -0400
Date: Mon, 23 Mar 2009 12:40:14 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/6] slab: introduce __kfree_rcu
In-Reply-To: <20090323155938.GA27151@elte.hu>
Message-ID: <alpine.DEB.1.10.0903231234110.11796@qirst.com>
References: <49AD3433.9000001@cn.fujitsu.com> <1237794502.6313.21.camel@penberg-laptop> <alpine.DEB.1.10.0903230931570.4095@qirst.com> <20090323155938.GA27151@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Ingo Molnar wrote:

>
> * Christoph Lameter <cl@linux-foundation.org> wrote:
>
> > On Mon, 23 Mar 2009, Pekka Enberg wrote:
> >
> > > > +static inline void *portion_to_obj(void *portion)
> > > > +{
> > > > +	struct page *page = virt_to_head_page(portion);
> > > > +	struct slab *slab = page_get_slab(page);
> > > > +	struct kmem_cache *cache = page_get_cache(page);
> > > > +	unsigned int offset = portion - slab->s_mem;
> > > > +	unsigned int index = offset / cache->buffer_size;
> > > > +
> > > > +	return index_to_obj(cache, slab, index);
> > > > +}
> > >
> > > A minor nit: I think this would be more readable if you separated
> > > variable declarations from the initializations. Also, you can probably
> > > drop the inline from the function declaration and let GCC decide what to
> > > do.
> >
> > Thats debatable. I find the setting up a number of variables that
> > are all dependend in the above manner very readable. They are
> > usually repetitive. Multiple functions use similar
> > initializations.
>
> I agree with Pekka, it's clearly more readable when separated out
> nicely:
>
> 	struct kmem_cache *cache;
> 	unsigned int offset;
> 	unsigned int index;
> 	struct page *page;
> 	struct slab *slab;
>
> 	page	= virt_to_head_page(portion);
> 	slab	= page_get_slab(page);
> 	cache	= page_get_cache(page);
>
> 	offset	= portion - slab->s_mem;
> 	index	= offset / cache->buffer_size;
>
> The original form is hard to read due to lack of structure.

Structure can also be established differently:

static inline void *portion_to_obj(void *portion)
{
	struct page *page = virt_to_head_page(portion);
	struct slab *slab = page_get_slab(page);
	struct kmem_cache *cache = page_get_cache(page);

	unsigned int offset = portion - slab->s_mem;
	unsigned int index = offset / cache->buffer_size;

	return index_to_obj(cache, slab, index);
}

It would be good if the whole series of actions that need to be taken in
order for the function to "get to know" the slab the object parms would be
simpler. Like its done in ruby

	(page, slab, cache) = get_slab_info(portion)

	(offset, index) = get_position_info(slab, portion)

But how can this be done in C without weird pointer passing?

