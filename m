Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbXENQPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbXENQPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXENQOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:14:55 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:8976 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751722AbXENQOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:14:54 -0400
Subject: Re: [PATCH 3/5] mm: slub allocation fairness
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
In-Reply-To: <Pine.LNX.4.64.0705140847330.10442@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
	 <20070514133212.581041171@chello.nl>
	 <Pine.LNX.4.64.0705140847330.10442@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 18:14:45 +0200
Message-Id: <1179159285.2942.20.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 08:49 -0700, Christoph Lameter wrote:
> On Mon, 14 May 2007, Peter Zijlstra wrote:
> 
> > Index: linux-2.6-git/include/linux/slub_def.h
> > ===================================================================
> > --- linux-2.6-git.orig/include/linux/slub_def.h
> > +++ linux-2.6-git/include/linux/slub_def.h
> > @@ -52,6 +52,7 @@ struct kmem_cache {
> >  	struct kmem_cache_node *node[MAX_NUMNODES];
> >  #endif
> >  	struct page *cpu_slab[NR_CPUS];
> > +	int rank;
> >  };
> 
> Ranks as part of the kmem_cache structure? I thought this is a temporary 
> thing?

No it needs to store the current state to verity subsequent allocations
their gfp flags against.

> >   * Lock order:
> > @@ -961,6 +962,8 @@ static struct page *allocate_slab(struct
> >  	if (!page)
> >  		return NULL;
> >  
> > +	s->rank = page->index;
> > +
> 
> Argh.... Setting a cache structure field from a page struct field? What 
> about concurrency?

Oh, right; allocate_slab is not serialized itself.

> > @@ -1371,8 +1376,12 @@ static void *__slab_alloc(struct kmem_ca
> >  		gfp_t gfpflags, int node, void *addr, struct page *page)
> >  {
> >  	void **object;
> > -	int cpu = smp_processor_id();
> > +	int cpu;
> > +
> > +	if (page == FORCE_PAGE)
> > +		goto force_new;
> >  
> > +	cpu = smp_processor_id();
> >  	if (!page)
> >  		goto new_slab;
> >  
> > @@ -1405,6 +1414,7 @@ have_slab:
> >  		goto load_freelist;
> >  	}
> >  
> > +force_new:
> >  	page = new_slab(s, gfpflags, node);
> >  	if (page) {
> >  		cpu = smp_processor_id();
> > @@ -1465,15 +1475,22 @@ static void __always_inline *slab_alloc(
> >  	struct page *page;
> >  	void **object;
> >  	unsigned long flags;
> > +	int rank = slab_alloc_rank(gfpflags);
> >  
> >  	local_irq_save(flags);
> > +	if (slab_insufficient_rank(s, rank)) {
> > +		page = FORCE_PAGE;
> > +		goto force_alloc;
> > +	}
> > +
> >  	page = s->cpu_slab[smp_processor_id()];
> >  	if (unlikely(!page || !page->lockless_freelist ||
> > -			(node != -1 && page_to_nid(page) != node)))
> > +			(node != -1 && page_to_nid(page) != node))) {
> >  
> > +force_alloc:
> >  		object = __slab_alloc(s, gfpflags, node, addr, page);
> >  
> > -	else {
> > +	} else {
> >  		object = page->lockless_freelist;
> >  		page->lockless_freelist = object[page->offset];
> >  	}
> 
> This is the hot path. No modifications please.

Yes it is, but sorry, I have to. I really need to validate each slab
alloc its GFP flags. Thats what the whole thing is about, I thought you
understood that.



