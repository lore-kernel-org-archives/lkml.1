Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZCTPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZCTPAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZCTPAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:00:25 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:44677 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZCTPAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:00:25 -0400
Date: Fri, 20 Mar 2009 10:57:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
In-Reply-To: <49C3A435.7060703@vflare.org>
Message-ID: <alpine.DEB.1.10.0903201042570.3740@qirst.com>
References: <49C3A31D.6070208@vflare.org> <49C3A435.7060703@vflare.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Nitin Gupta wrote:

> xvmalloc is a memory allocator designed specifically for compcache project.

Its an allocator that is highmem capable? Looks like an entirely new
animal to me.

> * Features:
>  - Low metadata overhead (just 4 bytes per object)

SLUB has 0 byte overhead. SLOB has 2 bytes.

>  - O(1) Alloc/Free - except when we have to call system page allocator to
>     get additional memory.

SLOB is not O(1) okay but the others are.

>  - Very low fragmentation: In all tests, xvMalloc memory usage is within 12%
>     of "Ideal".

Maybe try a fair test instead of relying on kmalloc rounding up to
the next power of 2 size?

> One of the main highlights is that it maps pages only when required.
> So, it does not hog vmalloc area which is very small on 32-bit systems.

Got some difficulty understanding what is going on here. So this allocator
is highmem capable? Doesnt that mean that you must make function calls to
ensure that an object is mapped before accessing it.

> +#include "xvmalloc_int.h"
> +
> +static void stat_inc(u64 *value)
> +{
> +	*value = *value + 1;
> +}

(*value) += 1?

atomic_inc?

local_inc?

> +static void bitmap_set(u32 *map, u32 idx)
> +{
> +	*map |= (u32)(1 << idx);
> +}

We have bitops for that purpose. Please use those.

> +/*
> + * Get index of free list having blocks of size greater than
> + * or equal to requested size.
> + */
> +static u32 get_index(u32 size)
> +{
> +	size = (size + FL_DELTA_MASK) & ~FL_DELTA_MASK;

See the ALIGN macro.

> +/*
> + * Allocate a memory page. Called when a pool needs to grow.
> + */
> +static u32 xv_alloc_page(void)
> +{
> +	struct page *page;
> +
> +	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);

Yes a highmem based allocator!!!!

> +
> +	if (unlikely(!page))
> +		return INVALID_PGNUM;

Return NULL?

> +#define INVALID_PGNUM	((u32)(-1))

NULL

> +#define ROUNDUP(x, y)	(((x) + (y) - 1) / (y) * (y))

There is a global macro available for that purpose

> +/* Each individual bitmap is 32-bit */
> +#define BITMAP_BITS	32

Use kernel constants please BITS_PER_LONG here.

> +#define ROUNDUP_ALIGN(x)	(((x) + XV_ALIGN_MASK) & ~XV_ALIGN_MASK)

== ALIGN?

Well I think this allocator is pretty useful for systems that depend to a
large degree on highmem. This is basically x86 32 bit configuration swith
more than 1G memmory.
