Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbYG3OOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbYG3OOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYG3OOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:14:06 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:53218 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752754AbYG3OOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:14:05 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH 04/30] mm: slub: trivial cleanups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Neil Brown <neilb@suse.de>
In-Reply-To: <489073CD.1040108@linux-foundation.org>
References: <20080724140042.408642539@chello.nl>
	 <20080724141529.560025894@chello.nl>
	 <1217238223.7813.16.camel@penberg-laptop> <1217240353.6331.34.camel@twins>
	 <489073CD.1040108@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 16:13:46 +0200
Message-Id: <1217427226.8157.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 08:59 -0500, Christoph Lameter wrote:
> Peter Zijlstra wrote:
> 
> >> Christoph?
> 
> Sorry for the delay but this moving stuff is unending....
> 
> 
> >>> Index: linux-2.6/mm/slub.c
> >>> ===================================================================
> >>> --- linux-2.6.orig/mm/slub.c
> >>> +++ linux-2.6/mm/slub.c
> >>> @@ -27,7 +27,7 @@
> >>>  /*
> >>>   * Lock order:
> >>>   *   1. slab_lock(page)
> >>> - *   2. slab->list_lock
> >>> + *   2. node->list_lock
> >>>   *
> >>>   *   The slab_lock protects operations on the object of a particular
> >>>   *   slab and its metadata in the page struct. If the slab lock
> 
> Hmmm..... node? Maybe use the struct name? kmem_cache_node?
> 
> >>> @@ -163,11 +163,11 @@ static struct notifier_block slab_notifi
> >>>  #endif
> >>>  
> >>>  static enum {
> >>> -	DOWN,		/* No slab functionality available */
> >>> +	DOWN = 0,	/* No slab functionality available */
> >>>  	PARTIAL,	/* kmem_cache_open() works but kmalloc does not */
> >>>  	UP,		/* Everything works but does not show up in sysfs */
> >>>  	SYSFS		/* Sysfs up */
> >>> -} slab_state = DOWN;
> >>> +} slab_state;
> >>>  
> >>>  /* A list of all slab caches on the system */
> >>>  static DECLARE_RWSEM(slub_lock);
> 
> It defaults to the first enum value. We also do not initialize statics with zero.

I seem to recall differently, I thought we explicitly init global stuff
to 0.

> >>> @@ -288,21 +288,22 @@ static inline int slab_index(void *p, st
> >>>  static inline struct kmem_cache_order_objects oo_make(int order,
> >>>  						unsigned long size)
> >>>  {
> >>> -	struct kmem_cache_order_objects x = {
> >>> -		(order << 16) + (PAGE_SIZE << order) / size
> >>> -	};
> >>> +	struct kmem_cache_order_objects x;
> >>> +
> >>> +	x.order = order;
> >>> +	x.objects = (PAGE_SIZE << order) / size;
> >>>  
> >>>  	return x;
> >>>  }
> >>>  
> 
> Another width limitation that will limit the number of objects in a slab to 64k.
> Also gcc does not get the fields, wont be able to optimize this as well and it will emit conversion from 16 bit loads.

Well, it was already 16 by virtue of the old code.

GCC emmiting rubbish code due to the union would be sad - I can respin
without this.

> >>> @@ -1076,8 +1077,7 @@ static struct page *allocate_slab(struct
> >>>  
> >>>  	flags |= s->allocflags;
> >>>  
> >>> -	page = alloc_slab_page(flags | __GFP_NOWARN | __GFP_NORETRY, node,
> >>> -									oo);
> >>> +	page = alloc_slab_page(flags | __GFP_NOWARN | __GFP_NORETRY, node, oo);
> >>>  	if (unlikely(!page)) {
> >>>  		oo = s->min;
> >>>  		/*
> 
> ok.
> 
> >>> @@ -1099,8 +1099,7 @@ static struct page *allocate_slab(struct
> >>>  	return page;
> >>>  }
> >>>  
> >>> -static void setup_object(struct kmem_cache *s, struct page *page,
> >>> -				void *object)
> >>> +static void setup_object(struct kmem_cache *s, struct page *page, void *object)
> >>>  {
> >>>  	setup_object_debug(s, page, object);
> >>>  	if (unlikely(s->ctor))
> 
> Hmmm. You are moving it back on one line and Andrew will cut it up again later? This seems to be oscillating...

Gah, somehow I got convinced the result was <= 80..

> >>> @@ -1799,11 +1796,11 @@ static int slub_nomerge;
> >>>   * slub_max_order specifies the order where we begin to stop considering the
> >>>   * number of objects in a slab as critical. If we reach slub_max_order then
> >>>   * we try to keep the page order as low as possible. So we accept more waste
> >>> - * of space in favor of a small page order.
> >>> + * of space in favour of a small page order.
> >>>   *
> >>>   * Higher order allocations also allow the placement of more objects in a
> >>>   * slab and thereby reduce object handling overhead. If the user has
> >>> - * requested a higher mininum order then we start with that one instead of
> >>> + * requested a higher minimum order then we start with that one instead of
> >>>   * the smallest order which will fit the object.
> >>>   */
> >>>  static inline int slab_order(int size, int min_objects,
> 
> Ack.

OK, will send a new one without the bad bits..

