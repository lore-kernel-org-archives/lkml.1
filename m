Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZEAJIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZEAJIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZEAJId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:08:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756083AbZEAJIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:08:31 -0400
Date: Fri, 1 May 2009 01:59:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
Message-Id: <20090501015956.ef663e9b.akpm@linux-foundation.org>
In-Reply-To: <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 13:26:38 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> The lru_cache is a fixed size cache of equal sized objects. It allows its
> users to do arbitrary transactions in case an element in the cache needs to
> be replaced. Its replacement policy is LRU.
> 

None of this really looks drbd-specific.

Would it not be better to present this as a general library function? 
lib/lru_cache.c?

I think I might have asked this before.  If I did, then thwap-to-you
for not permanently answering it in the changelog ;)

>
> ...
>
> +#define lc_e_base(lc)  ((char *)((lc)->slot + (lc)->nr_elements))
> +#define lc_entry(lc, i) ((struct lc_element *) \
> +		       (lc_e_base(lc) + (i)*(lc)->element_size))
> +#define lc_index_of(lc, e) (((char *)(e) - lc_e_base(lc))/(lc)->element_size)

The macros reference their arguments multiple times and hence are
inefficient and/or buggy and/or unpredictable when passed an expression
with side-effects.

If possible this should be fixed by turning them into regular C
functions.  Inlined C functions if that makes sense (it frequently
doesn't).

A pleasing side-effect of this conversion is that for some reason
developers are more likely to document C functions than they are macros
(hint).

I don't understand what these macros are doing and can't be bothered
reverse-engineering the code to work that out.  But all the typecasting
looks fishy.

>
> ...
>
> +static inline void lc_init(struct lru_cache *lc,
> +		const size_t bytes, const char *name,
> +		const unsigned int e_count, const size_t e_size,
> +		void *private_p)
> +{
> +	struct lc_element *e;
> +	unsigned int i;
> +
> +	BUG_ON(!e_count);
> +
> +	memset(lc, 0, bytes);
> +	INIT_LIST_HEAD(&lc->in_use);
> +	INIT_LIST_HEAD(&lc->lru);
> +	INIT_LIST_HEAD(&lc->free);
> +	lc->element_size = e_size;
> +	lc->nr_elements  = e_count;
> +	lc->new_number	 = -1;
> +	lc->lc_private   = private_p;
> +	lc->name         = name;
> +	for (i = 0; i < e_count; i++) {
> +		e = lc_entry(lc, i);
> +		e->lc_number = LC_FREE;
> +		list_add(&e->list, &lc->free);
> +		/* memset(,0,) did the rest of init for us */
> +	}
> +}

How's about you remove all `inline' keywords from the whole patchset
and then go back and inline the functions where there is a demonstrable
benefit?  This function won't be one of them!

>
> ...
>
> +/**
> + * lc_free: Frees memory allocated by lc_alloc.
> + * @lc: The lru_cache object
> + */
> +void lc_free(struct lru_cache *lc)
> +{
> +	vfree(lc);
> +}

vmalloc() is a last-resort thing.  It generates slower-to-access memory
and can cause internal fragmentation of the vmalloc arena, leading to
total machine failure.

Can it be avoided?  Often it _can_ be avoided, and the code falls back
to vmalloc() if the more robust memory allocation schemes failed.

> +/**
> + * lc_reset: does a full reset for @lc and the hash table slots.
> + * It is roughly the equivalent of re-allocating a fresh lru_cache object,
> + * basically a short cut to lc_free(lc); lc = lc_alloc(...);
> + */

Comment purports to be kerneldoc but doesn't document the formal argument.

> +void lc_reset(struct lru_cache *lc)
> +{
> +	lc_init(lc, size_of_lc(lc->nr_elements, lc->element_size), lc->name,
> +			lc->nr_elements, lc->element_size, lc->lc_private);
> +}
> +
> +size_t	lc_printf_stats(struct seq_file *seq, struct lru_cache *lc)
> +{
> +	/* NOTE:
> +	 * total calls to lc_get are
> +	 * (starving + hits + misses)
> +	 * misses include "dirty" count (update from an other thread in
> +	 * progress) and "changed", when this in fact lead to an successful
> +	 * update of the cache.
> +	 */
> +	return seq_printf(seq, "\t%s: used:%u/%u "
> +		"hits:%lu misses:%lu starving:%lu dirty:%lu changed:%lu\n",
> +		lc->name, lc->used, lc->nr_elements,
> +		lc->hits, lc->misses, lc->starving, lc->dirty, lc->changed);
> +}
> +
> +static unsigned int lc_hash_fn(struct lru_cache *lc, unsigned int enr)
> +{
> +	return enr % lc->nr_elements;
> +}
> +
> +
> +/**
> + * lc_find: Returns the pointer to an element, if the element is present
> + * in the hash table. In case it is not this function returns NULL.

Unfortunately the above must be done in a single 140 column line -
kerneldoc doesn't understand leading lines which have a newline in the
middle.

Please review all kerneldoc comments in the patchset - I won't commeent
on them further.

> + * @lc: The lru_cache object
> + * @enr: element number
> + */
> +struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr)
> +{
> +	struct hlist_node *n;
> +	struct lc_element *e;
> +
> +	BUG_ON(!lc);
> +	hlist_for_each_entry(e, n, lc->slot + lc_hash_fn(lc, enr), colision) {
> +		if (e->lc_number == enr)
> +			return e;
> +	}
> +	return NULL;
> +}
> +
>
> ...
>


So I assume that the caller of this facility must provide the locking
for its internals.  Is that documented somewhere?

