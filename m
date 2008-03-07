Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYCGKzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYCGKzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbYCGKy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:54:58 -0500
Received: from saeurebad.de ([85.214.36.134]:56645 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbYCGKy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:54:57 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
References: <200803071007.493903088@firstfloor.org>
	<20080307090716.9D3E91B419C@basil.firstfloor.org>
Date: Fri, 07 Mar 2008 11:53:30 +0100
In-Reply-To: <20080307090716.9D3E91B419C@basil.firstfloor.org> (Andi Kleen's
	message of "Fri, 7 Mar 2008 10:07:16 +0100 (CET)")
Message-ID: <871w6m955h.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Andi Kleen <andi@firstfloor.org> writes:

> Index: linux/mm/mask-alloc.c
> ===================================================================
> --- /dev/null
> +++ linux/mm/mask-alloc.c
> @@ -0,0 +1,504 @@
> +/*
> + * Generic management of low memory zone to allocate memory with a address mask.
> + *
> + * The maskable pool is reserved inside another zone, but managed by a
> + * specialized bitmap allocator. The allocator is not O(1) (searches
> + * the bitmap with a last use hint) but should be fast enough for
> + * normal purposes.  The advantage of the allocator is that it can
> + * allocate based on a mask.
> + *
> + * The allocator could be improved, but it's better to keep
> + * things simple for now and there are relatively few users
> + * which are usually not that speed critical. Also for simple
> + * repetive allocation patterns it should be approximately usually
> + * O(1) anyways due to the rotating cursor in the bitmap.
> + *
> + * This allocator should be only used by architectures with reasonably
> + * continuous physical memory at least for the low normal zone.
> + *
> + * Note book:
> + * Right now there are no high priority reservations (__GFP_HIGH). Iff
> + * they are needed it would be possible to reserve some very low memory
> + * for those.
> + *
> + * Copyright 2007, 2008 Andi Kleen, SUSE Labs.
> + * Subject to the GNU Public License v.2 only.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/gfp.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/bitops.h>
> +#include <linux/string.h>
> +#include <linux/wait.h>
> +#include <linux/bootmem.h>
> +#include <linux/module.h>
> +#include <linux/fault-inject.h>
> +#include <linux/ctype.h>
> +#include <linux/kallsyms.h>
> +#include "internal.h"
> +
> +#define BITS_PER_PAGE (PAGE_SIZE * 8)
> +
> +#define MASK_ZONE_LIMIT (2U<<30) /* 2GB max for now */
> +
> +#define Mprintk(x...)
> +#define Mprint_symbol(x...)
> +
> +static int force_mask __read_mostly;
> +static DECLARE_WAIT_QUEUE_HEAD(mask_zone_wait);
> +unsigned long mask_timeout __read_mostly = 5*HZ;
> +
> +/*
> + * The mask_bitmap maintains all the pages in the mask pool.
> + * It is reversed (lowest pfn has the highest index)
> + * to make reverse search easier.
> + * All accesses are protected by the mask_bitmap_lock
> + */
> +static DEFINE_SPINLOCK(mask_bitmap_lock);
> +static unsigned long *mask_bitmap;
> +static unsigned long mask_max_pfn;
> +
> +static inline unsigned pfn_to_maskbm_index(unsigned long pfn)
> +{
> +	return mask_max_pfn - pfn;
> +}
> +
> +static inline unsigned maskbm_index_to_pfn(unsigned index)
> +{
> +	return mask_max_pfn - index;
> +}
> +
> +static unsigned wait_for_mask_free(unsigned left)
> +{
> +	DEFINE_WAIT(wait);
> +	prepare_to_wait(&mask_zone_wait, &wait, TASK_UNINTERRUPTIBLE);
> +	left = schedule_timeout(left);
> +	finish_wait(&mask_zone_wait, &wait);
> +	return left;
> +}
> +

If ...

> +/* First try normal zones if possible. */
> +static struct page *
> +alloc_higher_pages(gfp_t gfp_mask, unsigned order, unsigned long pfn)
> +{
> +	struct page *p = NULL;
> +	if (pfn > mask_max_pfn) {
> +#ifdef CONFIG_ZONE_DMA32
> +		if (pfn <= (0xffffffff >> PAGE_SHIFT)) {
> +			p = alloc_pages(gfp_mask|GFP_DMA32|__GFP_NOWARN,
> +						order);

... this succeeds and allocated pages, and ...

> +			if (p && page_to_pfn(p) >= pfn) {
> +				__free_pages(p, order);
> +				p = NULL;
> +			}

... p is and it's pfn is lower than pfn ...

> +		}
> +#endif
> +		p = alloc_pages(gfp_mask|__GFP_NOWARN, order);

... isn't this a leak here?

> +		if (p && page_to_pfn(p) >= pfn) {
> +			__free_pages(p, order);
> +			p = NULL;
> +		}
> +	}
> +	return p;
> +}
> +
> +static unsigned long alloc_mask(int pages, unsigned long max)
> +{
> +	static unsigned long next_bit;
> +	unsigned long offset, flags, start, pfn;
> +	int k;
> +
> +	if (max >= mask_max_pfn)
> +		max = mask_max_pfn;

Can omit the assignment when max == mask_max_pfn.

> +	start = mask_max_pfn - max;
> +
> +	spin_lock_irqsave(&mask_bitmap_lock, flags);
> +	offset = -1L;
> +
> +	if (next_bit >= start && next_bit + pages < (mask_max_pfn - (max>>1))) {
> +		offset = find_next_zero_string(mask_bitmap, next_bit,
> +					       mask_max_pfn, pages);
> +		if (offset != -1L)
> +			count_vm_events(MASK_BITMAP_SKIP, offset - next_bit);
> +	}
> +	if (offset == -1L) {
> +		offset = find_next_zero_string(mask_bitmap, start,
> +					mask_max_pfn, pages);
> +		if (offset != -1L)
> +			count_vm_events(MASK_BITMAP_SKIP, offset - start);
> +	}
> +	if (offset != -1L) {
> +		for (k = 0; k < pages; k++) {
> +			BUG_ON(test_bit(offset + k, mask_bitmap));
> +			set_bit(offset + k, mask_bitmap);
> +		}
> +		next_bit = offset + pages;
> +		if (next_bit >= mask_max_pfn)
> +			next_bit = start;
> +	}
> +	spin_unlock_irqrestore(&mask_bitmap_lock, flags);
> +	if (offset == -1L)
> +		return -1L;
> +
> +	offset += pages - 1;
> +	pfn = maskbm_index_to_pfn(offset);
> +
> +	BUG_ON(maskbm_index_to_pfn(offset) != pfn);
> +	return pfn;
> +}

	Hannes
