Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbXFDXKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbXFDXKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXFDXK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:10:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:41838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347AbXFDXK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:10:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="250793984"
Date: Mon, 4 Jun 2007 16:06:49 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routines for handling pre-allocated pool of objects
Message-ID: <20070604230649.GB9948@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com> <20070604210644.156875000@askeshav-devel.jf.intel.com> <20070604225714.GM20299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604225714.GM20299@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 06:57:14PM -0400, Jeff Garzik wrote:
> On Mon, Jun 04, 2007 at 02:02:44PM -0700, anil.s.keshavamurthy@intel.com wrote:
> > 	This patch provides a common interface for pre allocating and 
> > managing pool of objects.
> > 
> > Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > ---
> >  include/linux/respool.h |   43 +++++++++++
> >  lib/Makefile            |    1 
> >  lib/respool.c           |  176 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 220 insertions(+)
> > 
> > Index: linux-2.6.22-rc3/include/linux/respool.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6.22-rc3/include/linux/respool.h	2007-06-04 12:36:17.000000000 -0700
> > @@ -0,0 +1,43 @@
> > +/*
> > + * respool.c - library routines for handling generic pre-allocated pool of objects
> > + *
> > + * Copyright (c) 2006, Intel Corporation.
> > + *
> > + * This file is released under the GPLv2.
> > + *
> > + * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > + *
> > + */
> > +
> > +#ifndef _RESPOOL_H_
> > +#define _RESPOOL_H_
> > +
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +#include <linux/workqueue.h>
> > +
> > +typedef void *(*rpool_alloc_t)(unsigned int, gfp_t);
> > +typedef void (*rpool_free_t)(void *, unsigned int);
> > +
> > +struct resource_pool {
> > +	struct work_struct work;
> > +	spinlock_t	pool_lock;	/* pool lock to walk the pool_head */
> > +	struct list_head pool_head;	/* pool objects list head	*/
> > +	unsigned int	min_count;	/* min count to maintain	*/
> > +	unsigned int	grow_count;	/* grow by count when time to grow */
> > +	unsigned int	curr_count;	/* count of current free objects */
> > +	unsigned int	alloc_size;	/* objects size			*/
> > +	rpool_alloc_t 	alloc_mem;	/* pool mem alloc function pointer */
> > +	rpool_free_t 	free_mem;	/* pool mem free function pointer */
> > +};
> > +
> > +void *get_resource_pool_obj(struct resource_pool *ppool);
> > +void put_resource_pool_obj(void * vaddr, struct resource_pool *ppool);
> > +void destroy_resource_pool(struct resource_pool *ppool);
> > +int init_resource_pool(struct resource_pool *res,
> > +	unsigned int min_count, unsigned int alloc_size,
> > +	unsigned int grow_count, rpool_alloc_t alloc_fn,
> > +	rpool_free_t free_fn);
> > +
> > +#endif
> > Index: linux-2.6.22-rc3/lib/Makefile
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/lib/Makefile	2007-06-04 12:28:10.000000000 -0700
> > +++ linux-2.6.22-rc3/lib/Makefile	2007-06-04 12:36:17.000000000 -0700
> > @@ -58,6 +58,7 @@
> >  obj-$(CONFIG_AUDIT_GENERIC) += audit.o
> >  
> >  obj-$(CONFIG_SWIOTLB) += swiotlb.o
> > +obj-$(CONFIG_DMAR) += respool.o
> >  obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
> >  
> >  lib-$(CONFIG_GENERIC_BUG) += bug.o
> > Index: linux-2.6.22-rc3/lib/respool.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6.22-rc3/lib/respool.c	2007-06-04 12:36:17.000000000 -0700
> > @@ -0,0 +1,176 @@
> > +/*
> > + * respool.c - library routines for handling generic pre-allocated pool of objects
> > + *
> > + * Copyright (c) 2006, Intel Corporation.
> > + *
> > + * This file is released under the GPLv2.
> > + *
> > + * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> > + */
> > +
> > +#include <linux/respool.h>
> > +
> > +/**
> > + * get_resource_pool_obj - gets an object from the pool
> > + * @ppool - resource pool in question
> > + * This function gets an object from the pool and
> > + * if the pool count drops below min_count, this
> > + * function schedules work to grow the pool. If
> > + * no elements are fount in the pool then this function
> > + * tries to get memory from kernel.
> > + */
> > +void * get_resource_pool_obj(struct resource_pool *ppool)
> > +{
> > +	unsigned long	flags;
> > +	struct list_head *plist;
> > +	bool queue_work = 0;
> > +
> > +	spin_lock_irqsave(&ppool->pool_lock, flags);
> > +	if (!list_empty(&ppool->pool_head)) {
> > +		plist = ppool->pool_head.next;
> > +		list_del(plist);
> > +		ppool->curr_count--;
> > +	} else {
> > +		/*Making sure that curr_count is 0 when list is empty */
> > +		plist = NULL;
> > +		BUG_ON(ppool->curr_count != 0);
> > +	}
> > +
> > +	/* Check if pool needs to grow */
> > +	if (ppool->curr_count <= ppool->min_count)
> > +		queue_work = 1;
> > +	spin_unlock_irqrestore(&ppool->pool_lock, flags);
> > +
> > +	if (queue_work)
> > +		schedule_work(&ppool->work); /* queue work to grow the pool */
> > +
> > +
> > +	if (plist) {
> > +		memset(plist, 0, ppool->alloc_size); /* Zero out memory */
> > +		return plist;
> > +	}
> > +
> > +	/* Out of luck, try to get memory from kernel */
> > +	plist = (struct list_head *)ppool->alloc_mem(ppool->alloc_size,
> > +			GFP_ATOMIC);
> 
> Since you are outside the lock, you should pass in gfp_flags, to enhance
> the chance of being able to use GFP_KERNEL in certain contexts.

No, you got it wrong. This above function get_resource_pool_obj() itself
is called from interrrupt time so the logic is to get an object
from the pre-allocated pool if available else get it from kernel
without blocking which is to pass GFP_ATOMIC flag.

> 
> 
> > +	return plist;
> > +}
> > +
> > +/**
> > + * put_resource_pool_obj - puts an object back to the pool
> > + * @vaddr - object's address
> > + * @ppool - resource pool in question.
> > + * This function puts an object back to the pool.
> > + */
> > +void put_resource_pool_obj(void * vaddr, struct resource_pool *ppool)
> > +{
> > +	unsigned long	flags;
> > +	struct list_head *plist = (struct list_head *)vaddr;
> > +
> > +	BUG_ON(!vaddr);
> > +	BUG_ON(!ppool);
> > +
> > +	spin_lock_irqsave(&ppool->pool_lock, flags);
> > +	list_add(plist, &ppool->pool_head);
> > +	ppool->curr_count++;
> > +	spin_unlock_irqrestore(&ppool->pool_lock, flags);
> 
> you should add logic to free resources here (or queue_work to free the
> resources), if the pool grows beyond a certain size.

Can be added as an add on, testing showed that pool 
grows to a certain size and will not grow beyond that 
as we tend to reuse the elements.
