Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYLOXmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYLOXmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYLOXmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:42:15 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:47064 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYLOXmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mU0hYCKyIqcSoohDMluWQ+zrM/uzhXgmZFmfXgbTXKDVo+tpZiaf7zmek31gik4Bkf
         zWpgXaK3sqLHqsFVldxfIVa2LTfiSX8aQ/jLXHCTylPoAjdOWBhLpsVavgBQSYEXqPb/
         H5kr77hBdZdCdUZNqTfKjAU3pr4Dd5NFRHsrw=
Message-ID: <28c262360812151542g2ac032fay6c5b03d846d05a77@mail.gmail.com>
Date: Tue, 16 Dec 2008 08:42:12 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc][patch] SLQB slab allocator
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>
In-Reply-To: <20081212002518.GH8294@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212002518.GH8294@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Nick.
I am interested in SLQB.
So I tested slqb, slub, slab by kernel compile time.

make all -j 8

slqb and slub not DEBUG.
my test environment is as follows.

cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping	: 11
cpu MHz		: 1600.000
cache size	: 4096 KB

Below is average for ten time test.

slab :
user : 2376.484, system : 192.616 elapsed : 12:22.0
slub :
user : 2378.439, system : 194.989 elapsed : 12:22.4
slqb :
user : 2380.556, system : 194.801 elapsed : 12:23.0

so, slqb is rather slow although it is a big difference.
Interestingly, slqb consumes less time than slub in system.

And I found some trivial bug. :)

<snip>

> +static struct slqb_page *new_slab_page(struct kmem_cache *s, gfp_t flags, int node)
> +{
> +       struct slqb_page *page;
> +       void *start;
> +       void *last;
> +       void *p;
> +
> +       BUG_ON(flags & GFP_SLAB_BUG_MASK);
> +
> +       page = allocate_slab(s,
> +               flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
> +       if (!page)
> +               goto out;
> +
> +       page->flags |= 1 << PG_slab;

PG_slab set is redundant.
It's already set in alloc_slqb_pags_node.

> +       start = page_address(&page->page);
> +
> +       if (unlikely(slab_poison(s)))
> +               memset(start, POISON_INUSE, PAGE_SIZE << s->order);

<snip>

> +void kfree(const void *object)
> +{
> +       struct kmem_cache *s;
> +       struct page *p;
> +       struct slqb_page *page;
> +       unsigned long flags;
> +
> +       if (unlikely(ZERO_OR_NULL_PTR(object)))
> +               return;
> +
> +       p = virt_to_page(object);
> +       prefetch(p);
> +       prefetchw(object);
> +
> +#ifdef CONFIG_SLQB_DEBUG
> +       page = (struct slqb_page *)compound_head(p);
> +       s = page->list->cache;
> +       debug_check_no_locks_freed(object, s->objsize);
> +       if (likely(object) && unlikely(slab_debug(s))) {
> +               if (unlikely(!free_debug_processing(s, object, __builtin_return_address(0))))
> +                       return;
> +       }
> +#endif
> +
> +       local_irq_save(flags);
> +#ifndef CONFIG_SLQB_DEBUG
> +       page = (struct slqb_page *)compound_head(p);
> +       s = page->list->cache;
> +#endif

If it is not defined CONFIG_SLQB_DEBUG, page is garbage.

> +       __slab_free(s, page, object);
> +       local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL(kfree);
> +


-- 
Kinds regards,
MinChan Kim
