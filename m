Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXJWT4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXJWT4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXJWT4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:56:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbXJWT4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:56:17 -0400
Date: Tue, 23 Oct 2007 12:56:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: [PATCH] I/OAT: Add support for version 2 of ioatdma device
Message-Id: <20071023125613.4e90b764.akpm@linux-foundation.org>
In-Reply-To: <20071019072024.5057.3665.stgit@localhost.localdomain>
References: <20071019072024.5057.3665.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 00:20:25 -0700
Shannon Nelson <shannon.nelson@intel.com> wrote:

> Add support for version 2 of the ioatdma device.  This device handles
> the descriptor chain and DCA services slightly differently:
>  - Instead of moving the dma descriptors between a busy and an idle chain,
>    this new version uses a single circular chain so that we don't have
>    rewrite the next_descriptor pointers as we add new requests, and the
>    device doesn't need to re-read the last descriptor.
>  - The new device has the DCA tags defined internally instead of needing
>    them defined statically.
> 
> ...
>
> +static inline void __ioat1_dma_memcpy_issue_pending(
> +					       struct ioat_dma_chan *ioat_chan);
> +static inline void __ioat2_dma_memcpy_issue_pending(
> +					       struct ioat_dma_chan *ioat_chan);

It's somewhat unusual to forward-declare an inline like this.  My version
of gcc does do the right thing with it, but for the sake of
conventionality, readability and cleanliness, please consider just moving
the implementations higher up the file sometime, thanks.


> +static dma_cookie_t ioat2_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
> +	struct ioat_desc_sw *first = tx_to_ioat_desc(tx);
> +	struct ioat_desc_sw *new;
> +	struct ioat_dma_descriptor *hw;
> +	dma_cookie_t cookie;
> +	u32 copy;
> +	size_t len;
> +	dma_addr_t src, dst;
> +	int orig_ack;
> +	unsigned int desc_count = 0;
> +
> +	/* src and dest and len are stored in the initial descriptor */
> +	len = first->len;
> +	src = first->src;
> +	dst = first->dst;
> +	orig_ack = first->async_tx.ack;
> +	new = first;
> +
> +	/* ioat_chan->desc_lock is still in force in version 2 path */
> +
> +	do {
> +		copy = min((u32) len, ioat_chan->xfercap);

min_t is the preferred tool for this.

> +		new->async_tx.ack = 1;
> +
> +		hw = new->hw;
> +		hw->size = copy;
> +		hw->ctl = 0;
> +		hw->src_addr = src;
> +		hw->dst_addr = dst;
> +
> +		len -= copy;
> +		dst += copy;
> +		src += copy;
> +		desc_count++;
> +	} while (len && (new = ioat2_dma_get_next_descriptor(ioat_chan)));
> +
> +	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
> +	if (new->async_tx.callback) {
> +		hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
> +		if (first != new) {
> +			/* move callback into to last desc */
> +			new->async_tx.callback = first->async_tx.callback;
> +			new->async_tx.callback_param
> +					= first->async_tx.callback_param;
> +			first->async_tx.callback = NULL;
> +			first->async_tx.callback_param = NULL;
> +		}
> +	}
> +
> +	new->tx_cnt = desc_count;
> +	new->async_tx.ack = orig_ack; /* client is in control of this ack */
> +
> +	/* store the original values for use in later cleanup */
> +	if (new != first) {
> +		new->src = first->src;
> +		new->dst = first->dst;
> +		new->len = first->len;
> +	}
> +
> +	/* cookie incr and addition to used_list must be atomic */
> +	cookie = ioat_chan->common.cookie;
> +	cookie++;
> +	if (cookie < 0)
> +		cookie = 1;
> +	ioat_chan->common.cookie = new->async_tx.cookie = cookie;
> +
> +	ioat_chan->dmacount += desc_count;
> +	ioat_chan->pending += desc_count;
> +	if (ioat_chan->pending >= ioat_pending_level)
> +		__ioat2_dma_memcpy_issue_pending(ioat_chan);
> +	spin_unlock_bh(&ioat_chan->desc_lock);
>  
>  	return cookie;
>  }
>  
> +{
> +	struct ioat_desc_sw *new = NULL;
> +
> +	/*
> +	 * used.prev points to where to start processing
> +	 * used.next points to next free descriptor
> +	 * if used.prev == NULL, there are none waiting to be processed
> +	 * if used.next == used.prev.prev, there is only one free descriptor,
> +	 *      and we need to use it to as a noop descriptor before
> +	 *      linking in a new set of descriptors, since the device
> +	 *      has probably already read the pointer to it
> +	 */
> +	if (ioat_chan->used_desc.prev &&
> +	    ioat_chan->used_desc.next == ioat_chan->used_desc.prev->prev) {
> +
> +		struct ioat_desc_sw *desc = NULL;
> +		struct ioat_desc_sw *noop_desc = NULL;

The noop_desc initialisation is unneeded and so too is the initialisation
of `desc', I suspect.

The compiler should avoid any additional code generation, but unneeded
initialisations like this can cause useful warnings to be suppressed and
they're a bit misleading to the reader of the code.


> +		int i;
> +
> +		/* set up the noop descriptor */
> +		noop_desc = to_ioat_desc(ioat_chan->used_desc.next);
> +		noop_desc->hw->size = 0;
> +		noop_desc->hw->ctl = IOAT_DMA_DESCRIPTOR_NUL;
> +		noop_desc->hw->src_addr = 0;
> +		noop_desc->hw->dst_addr = 0;
> +
> +		ioat_chan->used_desc.next = ioat_chan->used_desc.next->next;
> +		ioat_chan->pending++;
> +		ioat_chan->dmacount++;
> +
> +		/* get a few more descriptors */
> +		for (i = 16; i; i--) {
> +			desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
> +			BUG_ON(!desc);

You can't do that!

GFP_ATOMIC allocations can and do fail under regular (albeit heavy) use. 
Code _must_ be able to recover from an allocation failure.  Taking out the
whole machine is not acceptable.

An exception to this is when the GFP_ATOMIC allocation is happening at
initial boot time (ie: in __init in code which cannot be loaded as a
module).


> +			list_add_tail(&desc->node, ioat_chan->used_desc.next);
> +
> +			desc->hw->next
> +				= to_ioat_desc(desc->node.next)->async_tx.phys;
> +			to_ioat_desc(desc->node.prev)->hw->next
> +				= desc->async_tx.phys;
> +			ioat_chan->desccount++;
> +		}
> +
> +		ioat_chan->used_desc.next = noop_desc->node.next;
> +	}
> +	new = to_ioat_desc(ioat_chan->used_desc.next);
> +	prefetch(new);
> +	ioat_chan->used_desc.next = new->node.next;
> +
> +	if (ioat_chan->used_desc.prev == NULL)
> +		ioat_chan->used_desc.prev = &new->node;
> +
> +	prefetch(new->hw);
> +	return new;
> +}
> +
>  
> +static struct dma_async_tx_descriptor *ioat2_dma_prep_memcpy(
> +						struct dma_chan *chan,
> +						size_t len,
> +						int int_en)
> +{
> +	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
> +	struct ioat_desc_sw *new;
> +
> +	spin_lock_bh(&ioat_chan->desc_lock);
> +	new = ioat2_dma_get_next_descriptor(ioat_chan);
> +	new->len = len;
> +
> +	/* leave ioat_chan->desc_lock set in version 2 path */
> +	return new ? &new->async_tx : NULL;
> +}

I assume that there's a spin_unlock_bh() somewhere..

> +static void ioat2_dma_memcpy_issue_pending(struct dma_chan *chan)
> +{
> +	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
> +
> +	if (ioat_chan->pending != 0) {
> +		spin_lock_bh(&ioat_chan->desc_lock);
> +		__ioat2_dma_memcpy_issue_pending(ioat_chan);
> +		spin_unlock_bh(&ioat_chan->desc_lock);
>  	}
>  }

Is it non-racy to test ->pending outside the lock?

>  
>  #define IOAT_LOW_COMPLETION_MASK	0xffffffc0
> +#define IOAT_DMA_DCA_ANY_CPU		~0
> +

The code is refreshingly free from usable comments.  A reader might wonder what
things like IOAT_DMA_DCA_ANY_CPU actually represent.  I can't work it out
from the bare C implementation.

>  void ioat_dma_remove(struct ioatdma_device *device);
> -struct dca_provider *ioat_dca_init(struct pci_dev *pdev,
> -				   void __iomem *iobase);
> +struct dca_provider *ioat_dca_init(struct pci_dev *pdev, void __iomem *iobase);
> +struct dca_provider *ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase);
>  #else
>  #define ioat_dma_probe(pdev, iobase)    NULL
>  #define ioat_dma_remove(device)         do { } while (0)
>  #define ioat_dca_init(pdev, iobase)	NULL
> +#define ioat2_dca_init(pdev, iobase)	NULL
>  #endif

grumble.  All these could be implemented as inlines.  Please only use
macros when the code cannot be implemented in C.

Reasons:

- we get typechecking even when CONFIG_YOUR_STUFF=n

- can still take the address of the functions (dubious)

- looks nicer


