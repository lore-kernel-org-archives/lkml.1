Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbXENQfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbXENQfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXENQf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:35:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56781 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754519AbXENQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:35:26 -0400
Date: Mon, 14 May 2007 09:35:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/5] mm: slub allocation fairness
In-Reply-To: <1179159285.2942.20.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705140929200.10801@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>  <20070514133212.581041171@chello.nl>
  <Pine.LNX.4.64.0705140847330.10442@schroedinger.engr.sgi.com>
 <1179159285.2942.20.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Peter Zijlstra wrote:

> On Mon, 2007-05-14 at 08:49 -0700, Christoph Lameter wrote:
> > On Mon, 14 May 2007, Peter Zijlstra wrote:
> > 
> > > Index: linux-2.6-git/include/linux/slub_def.h
> > > ===================================================================
> > > --- linux-2.6-git.orig/include/linux/slub_def.h
> > > +++ linux-2.6-git/include/linux/slub_def.h
> > > @@ -52,6 +52,7 @@ struct kmem_cache {
> > >  	struct kmem_cache_node *node[MAX_NUMNODES];
> > >  #endif
> > >  	struct page *cpu_slab[NR_CPUS];
> > > +	int rank;
> > >  };
> > 
> > Ranks as part of the kmem_cache structure? I thought this is a temporary 
> > thing?
> 
> No it needs to store the current state to verity subsequent allocations
> their gfp flags against.

What state? This is a global state? The kmem_cache struct is rarely
written to after setting up the slab. Any writes could create a serious 
performance problem on large scale systems.

 
> > >   * Lock order:
> > > @@ -961,6 +962,8 @@ static struct page *allocate_slab(struct
> > >  	if (!page)
> > >  		return NULL;
> > >  
> > > +	s->rank = page->index;
> > > +
> > 
> > Argh.... Setting a cache structure field from a page struct field? What 
> > about concurrency?
> 
> Oh, right; allocate_slab is not serialized itself.

Nor should you ever write to the kmem_cache structure concurrently at all.

> > >  
> > > -	else {
> > > +	} else {
> > >  		object = page->lockless_freelist;
> > >  		page->lockless_freelist = object[page->offset];
> > >  	}
> > 
> > This is the hot path. No modifications please.
> 
> Yes it is, but sorry, I have to. I really need to validate each slab
> alloc its GFP flags. Thats what the whole thing is about, I thought you
> understood that.

You are accessing a kmem_cache structure field in the hot path. That 
cacheline is never used in the hot path. Sorry this is way to intrusive 
for the problem you are trying to solve.
