Return-Path: <linux-kernel-owner+w=401wt.eu-S966129AbXFGX1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129AbXFGX1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765929AbXFGX1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:27:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765426AbXFGX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:27:41 -0400
Date: Thu, 7 Jun 2007 16:27:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool
 handling
Message-Id: <20070607162726.2236a296.akpm@linux-foundation.org>
In-Reply-To: <20070606190042.510643000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<20070606190042.510643000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 11:57:00 -0700
anil.s.keshavamurthy@intel.com wrote:

> Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

That was a terse changelog.

Obvious question: how does this differ from mempools, and would it be
better to fill in any gaps in mempool functionality instead of
implementing something similar-looking?

The changelog very much should describe all this, as well as explaining
what the dynamic behaviour of this new thing is, and what applications are
envisaged, what problems it solves, etc, etc.


> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.22-rc3/lib/respool.c	2007-06-06 11:34:46.000000000 -0700

There are a number of coding-style glitches in here, but
scripts/checkpatch.pl catches most of them.  Please run it, and fix.

> @@ -0,0 +1,222 @@
> +/*
> + * respool.c - library routines for handling generic pre-allocated pool of objects
> + *
> + * Copyright (c) 2006, Intel Corporation.
> + *
> + * This file is released under the GPLv2.
> + *
> + * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> + */
> +
> +#include <linux/respool.h>
> +
> +/**
> + * get_resource_pool_obj - gets an object from the pool
> + * @ppool - resource pool in question
> + * This function gets an object from the pool and
> + * if the pool count drops below min_count, this
> + * function schedules work to grow the pool. If
> + * no elements are fount in the pool then this function
> + * tries to get memory from kernel.
> + */
> +void * get_resource_pool_obj(struct resource_pool *ppool)
> +{
> +	unsigned long	flags;
> +	struct list_head *plist;
> +	bool queue_work = 0;
> +
> +	spin_lock_irqsave(&ppool->pool_lock, flags);
> +	if (!list_empty(&ppool->pool_head)) {
> +		plist = ppool->pool_head.next;
> +		list_del(plist);
> +		ppool->curr_count--;
> +	} else {
> +		/*Making sure that curr_count is 0 when list is empty */
> +		plist = NULL;
> +		BUG_ON(ppool->curr_count != 0);
> +	}
> +
> +	/* Check if pool needs to grow */
> +	if (ppool->curr_count <= ppool->min_count)
> +		queue_work = 1;
> +	spin_unlock_irqrestore(&ppool->pool_lock, flags);
> +
> +	if (queue_work)
> +		schedule_work(&ppool->work); /* queue work to grow the pool */
> +
> +
> +	if (plist) {
> +		memset(plist, 0, ppool->alloc_size); /* Zero out memory */
> +		return plist;
> +	}
> +
> +	/* Out of luck, try to get memory from kernel */
> +	plist = (struct list_head *)ppool->alloc_mem(ppool->alloc_size,
> +			GFP_ATOMIC);
> +
> +	return plist;
> +}

A function like this should take a gfp_t from the caller, and pass it on.

> +/**
> + * put_resource_pool_obj - puts an object back to the pool
> + * @vaddr - object's address
> + * @ppool - resource pool in question.
> + * This function puts an object back to the pool.
> + */
> +void put_resource_pool_obj(void * vaddr, struct resource_pool *ppool)
> +{
> +	unsigned long	flags;
> +	struct list_head *plist = (struct list_head *)vaddr;
> +	bool queue_work = 0;
> +
> +	BUG_ON(!vaddr);
> +	BUG_ON(!ppool);
> +
> +	spin_lock_irqsave(&ppool->pool_lock, flags);
> +	list_add(plist, &ppool->pool_head);
> +	ppool->curr_count++;
> +	if (ppool->curr_count > (ppool->min_count +
> +		ppool->grow_count * 2))
> +		queue_work = 1;

Some of the indenting is a bit funny-looking in here.

> +	spin_unlock_irqrestore(&ppool->pool_lock, flags);
> +
> +	if (queue_work)
> +		schedule_work(&ppool->work); /* queue work to shrink the pool */
> +}
> +
> +void
> +__grow_resource_pool(struct resource_pool *ppool,
> +	unsigned int grow_count)
> +{
> +	unsigned long	flags;
> +	struct list_head *plist;
> +
> +	while(grow_count) {
> +		plist = (struct list_head *)ppool->alloc_mem(ppool->alloc_size,
> +			GFP_KERNEL);

resource_pool.alloc_mem() already returns void *, so there is never a need
to cast its return value.

> +		if (!plist)
> +			break;
> +
> +		/* Add the element to the list */
> +		spin_lock_irqsave(&ppool->pool_lock, flags);
> +		list_add(plist, &ppool->pool_head);
> +		ppool->curr_count++;
> +		spin_unlock_irqrestore(&ppool->pool_lock, flags);
> +		grow_count--;
> +	}
> +}
> +

