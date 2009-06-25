Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZFYV2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZFYV2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFYV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:28:08 -0400
Received: from waste.org ([66.93.16.53]:32940 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZFYV2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:28:07 -0400
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem
 in sl[aou]b
From: Matt Mackall <mpm@selenic.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org,
       penberg@cs.helsinki.fi, jdb@comx.dk, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090625193137.GA16861@linux.vnet.ibm.com>
References: <20090625193137.GA16861@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 16:27:19 -0500
Message-Id: <1245965239.21085.393.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 12:31 -0700, Paul E. McKenney wrote:
> Hello!
> 
> Jesper noted that kmem_cache_destroy() invokes synchronize_rcu() rather
> than rcu_barrier() in the SLAB_DESTROY_BY_RCU case, which could result
> in RCU callbacks accessing a kmem_cache after it had been destroyed.
> 
> The following untested (might not even compile) patch proposes a fix.

Acked-by: Matt Mackall <mpm@selenic.com>

Nick, you'll want to make sure you get this in SLQB.

> Reported-by: Jesper Dangaard Brouer <jdb@comx.dk>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  slab.c |    2 +-
>  slob.c |    2 ++
>  slub.c |    2 ++
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index e74a16e..5241b65 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2547,7 +2547,7 @@ void kmem_cache_destroy(struct kmem_cache *cachep)
>  	}
>  
>  	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU))
> -		synchronize_rcu();
> +		rcu_barrier();
>  
>  	__kmem_cache_destroy(cachep);
>  	mutex_unlock(&cache_chain_mutex);
> diff --git a/mm/slob.c b/mm/slob.c
> index c78742d..9641da3 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -595,6 +595,8 @@ EXPORT_SYMBOL(kmem_cache_create);
>  void kmem_cache_destroy(struct kmem_cache *c)
>  {
>  	kmemleak_free(c);
> +	if (c->flags & SLAB_DESTROY_BY_RCU)
> +		rcu_barrier();
>  	slob_free(c, sizeof(struct kmem_cache));
>  }
>  EXPORT_SYMBOL(kmem_cache_destroy);
> diff --git a/mm/slub.c b/mm/slub.c
> index 819f056..a9201d8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2595,6 +2595,8 @@ static inline int kmem_cache_close(struct kmem_cache *s)
>   */
>  void kmem_cache_destroy(struct kmem_cache *s)
>  {
> +	if (s->flags & SLAB_DESTROY_BY_RCU)
> +		rcu_barrier();
>  	down_write(&slub_lock);
>  	s->refcount--;
>  	if (!s->refcount) {

-- 
http://selenic.com : development and support for Mercurial and Linux


