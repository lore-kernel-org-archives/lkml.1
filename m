Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbXHTW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbXHTW3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbXHTW30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:29:26 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:41979 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbXHTW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:29:25 -0400
Date: Mon, 20 Aug 2007 18:29:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
Message-ID: <20070820222922.GA29814@Krystal>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:28:16 up 21 days, 22:47,  3 users,  load average: 0.29, 0.28, 0.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> @@ -1638,18 +1668,26 @@ static void __always_inline slab_free(st
>  			struct page *page, void *x, void *addr)
>  {
>  	void **object = (void *)x;
> -	unsigned long flags;
> +	void **freelist;
>  	struct kmem_cache_cpu *c;
>  
> -	local_irq_save(flags);
> -	c = get_cpu_slab(s, smp_processor_id());
> -	if (likely(page == c->page && c->node >= 0)) {
> -		object[c->offset] = c->freelist;
> -		c->freelist = object;
> -	} else
> -		__slab_free(s, page, x, addr, c->offset);
> +	c = get_cpu_slab(s, raw_smp_processor_id());
> +	if (unlikely(c->node >= 0))
> +		goto slow;
> +
> +redo:
> +	freelist = c->freelist;
> +	smp_rmb();
> +	if (unlikely(page != c->page))
> +		goto slow;
>  
> -	local_irq_restore(flags);
> +	object[c->offset] = freelist;
> +
> +	if (unlikely(cmpxchg_local(&c->freelist, freelist, object) != freelist))

If you don't plan to disable preemption here, cmpxchg_local should
probably not be used.

> +		goto redo;
> +	return;
> +slow:
> +	__slab_free(s, page, x, addr, c->offset);
>  }
>  
>  void kmem_cache_free(struct kmem_cache *s, void *x)
> Index: linux-2.6.23-rc1/include/linux/slub_def.h
> ===================================================================
> --- linux-2.6.23-rc1.orig/include/linux/slub_def.h	2007-07-27 19:30:03.000000000 -0700
> +++ linux-2.6.23-rc1/include/linux/slub_def.h	2007-07-27 21:15:27.000000000 -0700
> @@ -12,11 +12,11 @@
>  #include <linux/kobject.h>
>  
>  struct kmem_cache_cpu {
> -	void **freelist;
> -	struct page *page;
> -	int node;
> -	unsigned int offset;
> -	unsigned int objsize;
> +	void **freelist;	/* Updated through atomic ops */
> +	struct page *page;	/* Updated with interrupts disabled */
> +	int node;		/* Updated with interrupts disabled */
> +	unsigned int offset;	/* Set up on kmem_cache_create() */
> +	unsigned int objsize;	/* Set up on kmem_cache_create() */
>  };
>  
>  struct kmem_cache_node {

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
