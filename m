Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZANRqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZANRqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZANRpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:45:55 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:48069 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZANRpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:45:54 -0500
Date: Wed, 14 Jan 2009 11:45:37 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: Use WARN_ON instead of BUG_ON where appropriate
In-Reply-To: <Pine.LNX.4.64.0901141719560.12990@melkki.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0901141117070.26507@quilx.com>
References: <Pine.LNX.4.64.0901141719560.12990@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Pekka J Enberg wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> It's better to WARN_ON and let the kernel limp along to increase the likelihood
> of an user detecting the error and reporting it to us.

That only works if a error condition can be signaled and be handled
appropriately.

> diff --git a/mm/slub.c b/mm/slub.c
> index 6392ae5..e4404a1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1119,7 +1119,8 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>  	void *last;
>  	void *p;
>
> -	BUG_ON(flags & GFP_SLAB_BUG_MASK);
> +	if (WARN_ON(flags & GFP_SLAB_BUG_MASK))
> +		return NULL;
>
>  	page = allocate_slab(s,
>  		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);

Ok. this relies on kmalloc returning NULL to the app.

> @@ -4285,7 +4287,8 @@ static char *create_unique_id(struct kmem_cache *s)
>  	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
>  	char *p = name;
>
> -	BUG_ON(!name);
> +	if (WARN_ON(!name))
> +		return NULL;
>
>  	*p++ = ':';
>  	/*
> @@ -4304,7 +4307,8 @@ static char *create_unique_id(struct kmem_cache *s)
>  	if (p != name + 1)
>  		*p++ = '-';
>  	p += sprintf(p, "%07d", s->size);
> -	BUG_ON(p > name + ID_STR_LENGTH - 1);
> +	if (WARN_ON(p > name + ID_STR_LENGTH - 1))
> +		return NULL;
>  	return name;
>  }
>

NULL name? Guess the kfree will just be a nop but what does
kobject_init_and_add do with a NULL name?


> @@ -4333,6 +4337,8 @@ static int sysfs_slab_add(struct kmem_cache *s)
>  		 * for the symlinks.
>  		 */
>  		name = create_unique_id(s);
> +		if (!name)
> +			return -EINVAL;
>  	}
>
>  	s->kobj.kset = slab_kset;
>

-EINVAL may cause a panic anyways if called from create_kmalloc_cache.

