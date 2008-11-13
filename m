Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYKMRd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYKMRd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYKMRdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:33:13 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38221 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYKMRdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:33:12 -0500
Date: Thu, 13 Nov 2008 09:32:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, hugh <hugh@veritas.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
Message-ID: <20081113173249.GB6788@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1226586509.7685.4929.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226586509.7685.4929.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 03:28:29PM +0100, Peter Zijlstra wrote:
> Subject: slab: document SLAB_DESTROY_BY_RCU
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed, 02 Apr 2008 14:13:42 +0200
> 
> Explain this SLAB_DESTROY_BY_RCU thing...

With Hugh's suggested change,

Re-acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/slab.h |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> Index: linux-2.6/include/linux/slab.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slab.h
> +++ linux-2.6/include/linux/slab.h
> @@ -23,6 +23,32 @@
>  #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
>  #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
>  #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
> +/*
> + * SLAB_DESTROY_BY_RCU - **WARNING** READ THIS!
> + *
> + * This delays freeing the SLAB page by a grace period, it does _NOT_
> + * delay object freeing. This means that if you do kmem_cache_free()
> + * that memory location is free to be reused at any time. Thus it may
> + * be possible to see another object there in the same RCU grace period.
> + *
> + * This feature only ensures the memory location backing the object
> + * stays valid, the trick to using this is relying on an independent
> + * object validation pass. Something like:
> + *
> + *  rcu_read_lock()
> + * again:
> + *  obj = lockless_lookup(key);
> + *  if (obj) {
> + *    if (!try_get_ref(obj)) // might fail for free objects
> + *      goto again;
> + *
> + *    if (obj->key != key) { // not the object we expected
> + *      put_ref(obj);
> + *      goto again;
> + *    }
> + *  }
> + *  rcu_read_unlock();
> + */
>  #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
>  #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
>  #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
> 
