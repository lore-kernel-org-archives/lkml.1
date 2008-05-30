Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYE3IYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYE3IYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbYE3IY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:24:29 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34663 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYE3IY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:24:27 -0400
Date: Fri, 30 May 2008 01:24:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, lnxninja@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 6/9] Make idr_find rcu-safe
Message-ID: <20080530082421.GI4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080507113553.395937000@bull.net> <20080507113737.158241000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507113737.158241000@bull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:35:59PM +0200, Nadia.Derbey@bull.net wrote:
> [PATCH 06/09]
> 
> This is a patch that makes idr_find rcu-safe: it can now be called inside an
> rcu_read critical section.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> ---
>  include/linux/idr.h |   16 ++++++++++++++++
>  lib/idr.c           |   11 ++++++-----
>  2 files changed, 22 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.25-mm1/lib/idr.c
> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 18:06:58.000000000 +0200
> +++ linux-2.6.25-mm1/lib/idr.c	2008-05-07 10:38:15.000000000 +0200
> @@ -459,7 +459,8 @@ EXPORT_SYMBOL(idr_destroy);
>   * return indicates that @id is not valid or you passed %NULL in
>   * idr_get_new().
>   *
> - * The caller must serialize idr_find() vs idr_get_new() and idr_remove().
> + * This function can be called under rcu_read_lock(), given that the leaf
> + * pointers lifetimes are correctly managed.
>   */
>  void *idr_find(struct idr *idp, int id)
>  {
> @@ -467,7 +468,7 @@ void *idr_find(struct idr *idp, int id)
>  	struct idr_layer *p;
> 
>  	n = idp->layers * IDR_BITS;
> -	p = idp->top;
> +	p = rcu_dereference(idp->top);
> 
>  	/* Mask off upper bits we don't use for the search. */
>  	id &= MAX_ID_MASK;
> @@ -477,7 +478,7 @@ void *idr_find(struct idr *idp, int id)
> 
>  	while (n > 0 && p) {
>  		n -= IDR_BITS;
> -		p = p->ary[(id >> n) & IDR_MASK];
> +		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
>  	}
>  	return((void *)p);
>  }
> @@ -510,7 +511,7 @@ int idr_for_each(struct idr *idp,
>  	struct idr_layer **paa = &pa[0];
> 
>  	n = idp->layers * IDR_BITS;
> -	p = idp->top;
> +	p = rcu_dereference(idp->top);
>  	max = 1 << n;
> 
>  	id = 0;
> @@ -518,7 +519,7 @@ int idr_for_each(struct idr *idp,
>  		while (n > 0 && p) {
>  			n -= IDR_BITS;
>  			*paa++ = p;
> -			p = p->ary[(id >> n) & IDR_MASK];
> +			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
>  		}
> 
>  		if (p) {
> Index: linux-2.6.25-mm1/include/linux/idr.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-05-06 17:38:42.000000000 +0200
> +++ linux-2.6.25-mm1/include/linux/idr.h	2008-05-07 10:41:22.000000000 +0200
> @@ -79,6 +79,22 @@ struct idr {
> 
>  #define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
> 
> +/**
> + * idr synchronization (stolen from radix-tree.h)
> + *
> + * idr_find() is able to be called locklessly, using RCU. The caller must
> + * ensure calls to this function are made within rcu_read_lock() regions.
> + * Other readers (lock-free or otherwise) and modifications may be running
> + * concurrently.
> + *
> + * It is still required that the caller manage the synchronization and
> + * lifetimes of the items. So if RCU lock-free lookups are used, typically
> + * this would mean that the items have their own locks, or are amenable to
> + * lock-free access; and that the items are freed by RCU (or only freed after
> + * having been deleted from the idr tree *and* a synchronize_rcu() grace
> + * period).
> + */
> +
>  /*
>   * This is what we export.
>   */
> 
> --
