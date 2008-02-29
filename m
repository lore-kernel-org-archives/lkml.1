Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYB2B4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYB2B4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYB2B4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:56:25 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:33609 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbYB2B4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:56:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAB/1xkdMQWRV/2dsb2JhbACBVqxt
Date: Thu, 28 Feb 2008 20:56:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Implement slub fastpath in terms of freebase and
	freeoffset
Message-ID: <20080229015621.GB32200@Krystal>
References: <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com> <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com> <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com> <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:50:20 up 17 days, 21:50,  4 users,  load average: 0.19, 0.54,
	1.16
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> 
> > Index: linux-2.6-lttng/mm/slub.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/mm/slub.c	2008-02-27 20:41:14.000000000 -0500
> > +++ linux-2.6-lttng/mm/slub.c	2008-02-28 18:22:14.000000000 -0500
> > @@ -138,6 +138,22 @@ static inline void ClearSlabDebug(struct
> >  	page->flags &= ~SLABDEBUG;
> >  }
> >  
> > +static inline void **get_freelist_ptr(struct kmem_cache_cpu *c)
> > +{
> > +	return (void **)((unsigned long)page_address(c->page)
> > +		| (c->freeoffset & c->off_mask));
> > +}
> 
> Hmmmm... page_address() is an expensive operation.
> 

Hrm, this is why I kept a separate "freebase", as a sort of
page_address() cache.

> > @@ -1779,21 +1815,21 @@ static __always_inline void slab_free(st
> >  	struct kmem_cache_cpu *c;
> >  
> >  #ifdef SLUB_FASTPATH
> > -	void **freelist;
> > +	unsigned long freeoffset, newoffset;
> >  
> >  	c = get_cpu_slab(s, raw_smp_processor_id());
> >  	debug_check_no_locks_freed(object, s->objsize);
> >  	do {
> > -		freelist = c->freelist;
> > +		freeoffset = c->freeoffset;
> >  		barrier();
> >  		/*
> >  		 * If the compiler would reorder the retrieval of c->page to
> > -		 * come before c->freelist then an interrupt could
> > -		 * change the cpu slab before we retrieve c->freelist. We
> > -		 * could be matching on a page no longer active and put the
> > -		 * object onto the freelist of the wrong slab.
> > +		 * come before c->freeoffset then an interrupt could change the
> > +		 * cpu slab before we retrieve c->freelist. We could be matching
> > +		 * on a page no longer active and put the object onto the
> > +		 * freelist of the wrong slab.
> >  		 *
> > -		 * On the other hand: If we already have the freelist pointer
> > +		 * On the other hand: If we already have the freeoffset
> >  		 * then any change of cpu_slab will cause the cmpxchg to fail
> >  		 * since the freelist pointers are unique per slab.
> >  		 */
> > @@ -1801,9 +1837,15 @@ static __always_inline void slab_free(st
> >  			__slab_free(s, page, x, addr, c->offset);
> >  			break;
> >  		}
> > -		object[c->offset] = freelist;
> > +		object[c->offset] =
> > +			(void **)((unsigned long)page_address(c->page) |
> > +					(freeoffset & c->off_mask));
> >  		stat(c, FREE_FASTPATH);
> > -	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
> > +		newoffset = freeoffset + PAGE_SIZE;
> > +		newoffset &= ~c->off_mask;
> > +		newoffset |= (unsigned long)object & c->off_mask;
> > +	} while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
> > +			!= freeoffset);
> 
> Hmmm.. The cmpxchg_local was intended to check for a change of slab too 
> (addresses from different slabs are disjunct). 
> That is no longer possible since the upper bits are used by the 
> versioning? (Same issue in slab_alloc).
> 

Here is the trick : if, on top of the cmpxchg_local, we have an
interrupt that calls slab_alloc or slab_free which causes a change of
slab, this interrupt will have to go through the slow path.

These slow paths use set_freelist_ptr() to update the c->freeoffset,
which also increments the sequence number. When we return from
interrupt, the cmpxchg_local loop will fail because the sequence number
has changed.

In short, the we also use the versioning to check for change of slab.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
