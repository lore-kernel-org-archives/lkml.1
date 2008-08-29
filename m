Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYH2ASS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYH2ASS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYH2ASA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:18:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbYH2AR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:17:59 -0400
Date: Thu, 28 Aug 2008 17:17:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: mingo@elte.hu, daniel.blueman@gmail.com, tglx@linutronix.de,
       clameter@sgi.com, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, bunk@kernel.org, protasnb@gmail.com,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH] debugobjects: fix lockdep warning #2
Message-Id: <20080828171706.6080accf.akpm@linux-foundation.org>
In-Reply-To: <20080828153214.GA27653@localhost.localdomain>
References: <20080828153214.GA27653@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 17:32:14 +0200
Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Thu, Aug 28, 2008 at 3:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > could you resend the final patch please? It's a candidate for .27, if it
> > works out fine.
> 
> Here is the combined patch. I've tested it only briefly, and I am
> unsure of whether it still produces lockdep warnings for Daniel or
> not. I wish it would not be applied anywhere unless it was
> officially Reviewed-by: someone. In particular, I'm not quite
> steady with the irq-safe locking (Thomas might want to have a look).
> 

It all looks good to me.

> 
> 
> >From 977cf583b79be7308d5e310711fe6038c8af96a4 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 28 Aug 2008 17:09:57 +0200
> Subject: [PATCH] debugobjects: fix lockdep warning #2
> 
> Daniel J. Blueman reported:
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.27-rc4-224c #1
> > -------------------------------------------------------
> > hald/4680 is trying to acquire lock:
> >  (&n->list_lock){++..}, at: [<ffffffff802bfa26>] add_partial+0x26/0x80
> >
> > but task is already holding lock:
> >  (&obj_hash[i].lock){++..}, at: [<ffffffff8041cfdc>]
> > debug_object_free+0x5c/0x120
> 
> We fix it by moving the actual freeing to outside the lock (the lock
> now only protects the list).
> 
> The lock is also promoted to irq-safe (suggested by Dan).

What was the reason for this other change?  I'm sure Dan is a fine chap,
but we usually prefer a little more justification for changes ;)

> Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  lib/debugobjects.c |   38 +++++++++++++++++++++++++++++---------
>  1 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index 19acf8c..acf9ed8 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -115,9 +115,10 @@ static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
>  static struct debug_obj *
>  alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
>  {
> +	unsigned long flags;
>  	struct debug_obj *obj = NULL;
>  
> -	spin_lock(&pool_lock);
> +	spin_lock_irqsave(&pool_lock, flags);
>  	if (obj_pool.first) {
>  		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
>  
> @@ -136,7 +137,7 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
>  		if (obj_pool_free < obj_pool_min_free)
>  			obj_pool_min_free = obj_pool_free;
>  	}
> -	spin_unlock(&pool_lock);
> +	spin_unlock_irqrestore(&pool_lock, flags);
>  
>  	return obj;
>  }
> @@ -146,18 +147,19 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
>   */
>  static void free_object(struct debug_obj *obj)
>  {
> +	unsigned long flags;
>  	unsigned long idx = (unsigned long)(obj - obj_static_pool);
>  
>  	if (obj_pool_free < ODEBUG_POOL_SIZE || idx < ODEBUG_POOL_SIZE) {
> -		spin_lock(&pool_lock);
> +		spin_lock_irqsave(&pool_lock, flags);
>  		hlist_add_head(&obj->node, &obj_pool);
>  		obj_pool_free++;
>  		obj_pool_used--;
> -		spin_unlock(&pool_lock);
> +		spin_unlock_irqrestore(&pool_lock, flags);
>  	} else {
> -		spin_lock(&pool_lock);
> +		spin_lock_irqsave(&pool_lock, flags);
>  		obj_pool_used--;
> -		spin_unlock(&pool_lock);
> +		spin_unlock_irqrestore(&pool_lock, flags);
>  		kmem_cache_free(obj_cache, obj);
>  	}
>  }
> @@ -170,19 +172,28 @@ static void debug_objects_oom(void)
>  {
>  	struct debug_bucket *db = obj_hash;
>  	struct hlist_node *node, *tmp;
> +	HLIST_HEAD(freelist);
>  	struct debug_obj *obj;
>  	unsigned long flags;
>  	int i;
>  
>  	printk(KERN_WARNING "ODEBUG: Out of memory. ODEBUG disabled\n");
>  
> +	/* XXX: Could probably be optimized by transplantation of more than
> +	 * one entry at a time. */
>  	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
>  		spin_lock_irqsave(&db->lock, flags);
>  		hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
>  			hlist_del(&obj->node);
> -			free_object(obj);
> +			hlist_add_head(&obj->node, &freelist);
>  		}
>  		spin_unlock_irqrestore(&db->lock, flags);
> +
> +		/* Now free them */
> +		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
> +			hlist_del(&obj->node);
> +			free_object(obj);

I suspect that we can avoid the hlist_del() here, perhaps with a little
effort.

> +
> +		/* Now free them */
> +		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
> +			hlist_del(&obj->node);
> +			free_object(obj);
> +		}
> +

and the other one.

But I'm not sure that it's worth putting effort into - leaving dead
objects strung onto a partially-live list is a little bit smelly IMO.

