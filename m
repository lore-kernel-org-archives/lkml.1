Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYJVSFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYJVSFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYJVSEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:04:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47464 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYJVSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:04:49 -0400
Message-ID: <48FF6A5D.5060905@cs.helsinki.fi>
Date: Wed, 22 Oct 2008 21:01:01 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com> <48FF6800.20705@cs.helsinki.fi> <20081022175827.GL9639@localhost>
In-Reply-To: <20081022175827.GL9639@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Something like that?
> 
> 		- Cyrill -
> ---
> 
>  mm/slub.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6.git/mm/slub.c
> ===================================================================
> --- linux-2.6.git.orig/mm/slub.c	2008-10-22 21:11:26.000000000 +0400
> +++ linux-2.6.git/mm/slub.c	2008-10-22 21:57:11.000000000 +0400
> @@ -153,6 +153,10 @@
>  #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>  #endif
>  
> +#define OO_SHIFT	16
> +#define OO_MASK		((1 << OO_SHIFT) - 1)
> +#define MAX_OBJS_PER_PAGE	65535 /* see struct page.objects */
> +
>  /* Internal SLUB flags */
>  #define __OBJECT_POISON		0x80000000 /* Poison object */
>  #define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
> @@ -290,7 +294,7 @@ static inline struct kmem_cache_order_ob
>  						unsigned long size)
>  {
>  	struct kmem_cache_order_objects x = {
> -		(order << 16) + (PAGE_SIZE << order) / size
> +		(order << OO_SHIFT) + (PAGE_SIZE << order) / size
>  	};
>  
>  	return x;
> @@ -298,12 +302,12 @@ static inline struct kmem_cache_order_ob
>  
>  static inline int oo_order(struct kmem_cache_order_objects x)
>  {
> -	return x.x >> 16;
> +	return x.x >> OO_SHIFT;
>  }
>  
>  static inline int oo_objects(struct kmem_cache_order_objects x)
>  {
> -	return x.x & ((1 << 16) - 1);
> +	return x.x & OO_MASK;
>  }
>  
>  #ifdef CONFIG_SLUB_DEBUG
> @@ -764,8 +768,8 @@ static int on_freelist(struct kmem_cache
>  	}
>  
>  	max_objects = (PAGE_SIZE << compound_order(page)) / s->size;
> -	if (max_objects > 65535)
> -		max_objects = 65535;
> +	if (max_objects > MAX_OBJS_PER_PAGE)
> +		max_objects = MAX_OBJS_PER_PAGE;
>  
>  	if (page->objects != max_objects) {
>  		slab_err(s, page, "Wrong number of objects. Found %d but "
> @@ -1819,8 +1823,8 @@ static inline int slab_order(int size, i
>  	int rem;
>  	int min_order = slub_min_order;
>  
> -	if ((PAGE_SIZE << min_order) / size > 65535)
> -		return get_order(size * 65535) - 1;
> +	if ((PAGE_SIZE << min_order) / size > MAX_OBJS_PER_PAGE)
> +		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
>  
>  	for (order = max(min_order,
>  				fls(min_objects * size - 1) - PAGE_SHIFT);

Looks good to me. If Christoph ACKs this, please send me a proper patch 
with your sign-off and I'll merge it to slab.git.

		Pekka
