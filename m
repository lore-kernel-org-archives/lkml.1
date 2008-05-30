Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYE3IZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYE3IZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYE3IY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:24:57 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46012 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbYE3IYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:24:54 -0400
Date: Fri, 30 May 2008 01:24:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, lnxninja@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/9] Make idr_remove rcu-safe
Message-ID: <20080530082449.GJ4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080507113553.395937000@bull.net> <20080507113737.562143000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507113737.562143000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:36:00PM +0200, Nadia.Derbey@bull.net wrote:
> [PATCH 07/09]
> 
> This patch introduces the free_layer() routine: it is the one that actually
> frees memory after a grace period has elapsed.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  lib/idr.c |   59 ++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 44 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6.25-mm1/lib/idr.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 18:06:43.000000000 +0200
> +++ linux-2.6.25-mm1/lib/idr.c	2008-05-07 09:07:31.000000000 +0200
> @@ -52,6 +52,19 @@ static struct idr_layer *get_from_free_l
>  	return(p);
>  }
> 
> +static void idr_layer_rcu_free(struct rcu_head *head)
> +{
> +	struct idr_layer *layer;
> +
> +	layer = container_of(head, struct idr_layer, rcu_head);
> +	kmem_cache_free(idr_layer_cache, layer);
> +}
> +
> +static inline void free_layer(struct idr_layer *p)
> +{
> +	call_rcu(&p->rcu_head, idr_layer_rcu_free);
> +}
> +
>  /* only called when idp->lock is held */
>  static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
>  {
> @@ -334,6 +347,7 @@ static void sub_remove(struct idr *idp, 
>  	struct idr_layer *p = idp->top;
>  	struct idr_layer **pa[MAX_LEVEL];
>  	struct idr_layer ***paa = &pa[0];
> +	struct idr_layer *to_free;
>  	int n;
> 
>  	*paa = NULL;
> @@ -349,13 +363,18 @@ static void sub_remove(struct idr *idp, 
>  	n = id & IDR_MASK;
>  	if (likely(p != NULL && test_bit(n, &p->bitmap))){
>  		__clear_bit(n, &p->bitmap);
> -		p->ary[n] = NULL;
> +		rcu_assign_pointer(p->ary[n], NULL);
> +		to_free = NULL;
>  		while(*paa && ! --((**paa)->count)){
> -			move_to_free_list(idp, **paa);
> +			if (to_free)
> +				free_layer(to_free);
> +			to_free = **paa;
>  			**paa-- = NULL;
>  		}
>  		if (!*paa)
>  			idp->layers = 0;
> +		if (to_free)
> +			free_layer(to_free);
>  	} else
>  		idr_remove_warning(id);
>  }
> @@ -368,25 +387,37 @@ static void sub_remove(struct idr *idp, 
>  void idr_remove(struct idr *idp, int id)
>  {
>  	struct idr_layer *p;
> +	struct idr_layer *to_free;
> 
>  	/* Mask off upper bits we don't use for the search. */
>  	id &= MAX_ID_MASK;
> 
>  	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
>  	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
> -	    idp->top->ary[0]) {  // We can drop a layer
> -
> +	    idp->top->ary[0]) {
> +		/*
> +		 * Single child at leftmost slot: we can shrink the tree.
> +		 * This level is not needed anymore since when layers are
> +		 * inserted, they are inserted at the top of the existing
> +		 * tree.
> +		 */
> +		to_free = idp->top;
>  		p = idp->top->ary[0];
> -		idp->top->bitmap = idp->top->count = 0;
> -		move_to_free_list(idp, idp->top);
> -		idp->top = p;
> +		rcu_assign_pointer(idp->top, p);
>  		--idp->layers;
> +		to_free->bitmap = to_free->count = 0;
> +		free_layer(to_free);
>  	}
>  	while (idp->id_free_cnt >= IDR_FREE_MAX) {
>  		p = get_from_free_list(idp);
> +		/*
> +		 * Note: we don't call the rcu callback here, since the only
> +		 * layers that fall into the freelist are those that have been
> +		 * preallocated.
> +		 */
>  		kmem_cache_free(idr_layer_cache, p);
> -		return;
>  	}
> +	return;
>  }
>  EXPORT_SYMBOL(idr_remove);
> 
> @@ -424,15 +455,13 @@ void idr_remove_all(struct idr *idp)
> 
>  		id += 1 << n;
>  		while (n < fls(id)) {
> -			if (p) {
> -				memset(p, 0, sizeof *p);
> -				move_to_free_list(idp, p);
> -			}
> +			if (p)
> +				free_layer(p);
>  			n += IDR_BITS;
>  			p = *--paa;
>  		}
>  	}
> -	idp->top = NULL;
> +	rcu_assign_pointer(idp->top, NULL);
>  	idp->layers = 0;
>  }
>  EXPORT_SYMBOL(idr_remove_all);
> @@ -549,7 +578,7 @@ EXPORT_SYMBOL(idr_for_each);
>   * A -ENOENT return indicates that @id was not found.
>   * A -EINVAL return indicates that @id was not within valid constraints.
>   *
> - * The caller must serialize vs idr_find(), idr_get_new(), and idr_remove().
> + * The caller must serialize with writers.
>   */
>  void *idr_replace(struct idr *idp, void *ptr, int id)
>  {
> @@ -575,7 +604,7 @@ void *idr_replace(struct idr *idp, void 
>  		return ERR_PTR(-ENOENT);
> 
>  	old_p = p->ary[n];
> -	p->ary[n] = ptr;
> +	rcu_assign_pointer(p->ary[n], ptr);
> 
>  	return old_p;
>  }
> 
> --
