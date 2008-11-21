Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbYKUQ5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbYKUQ5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYKUQ4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:56:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYKUQ4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:56:52 -0500
Date: Fri, 21 Nov 2008 17:56:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/10] x86: add initialization code for DMA-API
	debugging
Message-ID: <20081121165628.GD733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> +extern
> +void dma_debug_init(void);

this can be on a single line.

> +
> +#else /* CONFIG_DMA_API_DEBUG */
> +
> +static inline
> +void dma_debug_init(void)

this too. (when something fits on a single line, we prefer it so)

> +#include <linux/types.h>
> +#include <linux/scatterlist.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/module.h>
> +#include <linux/hardirq.h>
> +#include <linux/dma-mapping.h>
> +#include <asm/bug.h>
> +#include <asm/dma-mapping.h>
> +#include <asm/dma_debug.h>

to reduce the chances of commit conflicts in the future, we 
generally sort include lines in x86 files the following way:

> +#include <linux/scatterlist.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/spinlock.h>
> +#include <linux/hardirq.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
>
> +#include <asm/bug.h>
> +#include <asm/dma-mapping.h>
> +#include <asm/dma_debug.h>

[ note the extra newline too between the linux/ and asm/ portions. ]

> +#define HASH_SIZE 256
> +#define HASH_FN_SHIFT 20
> +#define HASH_FN_MASK 0xffULL

please align the values vertically.

> +/* Hash list to save the allocated dma addresses */
> +static struct list_head dma_entry_hash[HASH_SIZE];

Should be cacheline-aligned i guess - if this feature is enabled this 
is a hot area.

> +/* A slab cache to allocate dma_map_entries fast */
> +static struct kmem_cache *dma_entry_cache;

__read_mostly - to isolate it from the above hot area.

> +/* lock to protect the data structures */
> +static DEFINE_SPINLOCK(dma_lock);

should have a separate cacheline too i guess.

> +static int hash_fn(struct dma_debug_entry *entry)
> +{
> +	/*
> +	 * Hash function is based on the dma address.
> +	 * We use bits 20-27 here as the index into the hash
> +	 */
> +	BUG_ON(entry->dev_addr == bad_dma_address);

please use WARN_ON_ONCE() instead of crashing the box in possibly hard 
to debug spots.

> +	return (entry->dev_addr >> HASH_FN_SHIFT) & HASH_FN_MASK;
> +}
> +
> +static struct dma_debug_entry *dma_entry_alloc(void)
> +{
> +	gfp_t gfp = GFP_KERNEL | __GFP_ZERO;
> +
> +	if (in_atomic())
> +		gfp |= GFP_ATOMIC;
> +
> +	return kmem_cache_alloc(dma_entry_cache, gfp);

hm. that slab allocation in the middle of DMA mapping ops makes me a 
bit nervous. the DMA mapping ops are generally rather atomic.

and in_atomic() check there is a bug on !PREEMPT kernels, so it wont 
fly.

We dont have a gfp flag passed in as all the DMA mapping APIs really 
expect all allocations having been done in advance already.

Any chance to attach the debug entry to the iotlb entries themselves - 
either during build time (for swiotlb) or during iommu init time (for 
the hw iommu's) ?

	Ingo
