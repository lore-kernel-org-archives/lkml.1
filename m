Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYKMO5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYKMO5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYKMO5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:57:42 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:3261 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYKMO5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:57:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qL3JWkbND1NMiobFtPEnFKYWZcTnMyJ4t4Z7ToM5lmRD2LpKpNx0fmmq58POLWo2dw
         1VoT1n5eegh5hStyzOhapFKscOFheMYKOsJirbL6Wr6ZyNbm9Y7dgyb4Mg2mxcjft3TA
         w3d0wIrNIGY95HBQUhW01WsTSAWTTg82JELz4=
Message-ID: <84144f020811130657u6a8d62f6q619f25f53828141c@mail.gmail.com>
Date: Thu, 13 Nov 2008 16:57:40 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] slab: document SLAB_DESTROY_BY_RCU
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, hugh <hugh@veritas.com>,
       "Paul E McKenney" <paulmck@linux.vnet.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <1226586509.7685.4929.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226586509.7685.4929.camel@twins>
X-Google-Sender-Auth: eddd7ffaa1fccc2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 4:28 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Subject: slab: document SLAB_DESTROY_BY_RCU
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed, 02 Apr 2008 14:13:42 +0200
>
> Explain this SLAB_DESTROY_BY_RCU thing...
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  include/linux/slab.h |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> Index: linux-2.6/include/linux/slab.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slab.h
> +++ linux-2.6/include/linux/slab.h
> @@ -23,6 +23,32 @@
>  #define SLAB_CACHE_DMA         0x00004000UL    /* Use GFP_DMA memory */
>  #define SLAB_STORE_USER                0x00010000UL    /* DEBUG: Store the last owner for bug hunting */
>  #define SLAB_PANIC             0x00040000UL    /* Panic if kmem_cache_create() fails */
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
>  #define SLAB_DESTROY_BY_RCU    0x00080000UL    /* Defer freeing slabs to RCU */
>  #define SLAB_MEM_SPREAD                0x00100000UL    /* Spread some memory over cpuset */
>  #define SLAB_TRACE             0x00200000UL    /* Trace allocations and frees */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
