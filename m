Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZKEOHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZKEOHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbZKEOHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:07:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:61020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbZKEOHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:07:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,686,1249282800"; 
   d="scan'208";a="744134427"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 5 Nov 2009 14:06:37 +0000
Subject: RE: [PATCH 1/2] Add COH 901 318 DMA block driver v3
Thread-Topic: [PATCH 1/2] Add COH 901 318 DMA block driver v3
Thread-Index: AcpX4gUUArv4bb+ZTui1MR+jgFLwkgGOlNnA
Message-ID: <129600E5E5FB004392DDC3FB599660D7B7B992A0@irsmsx504.ger.corp.intel.com>
References: <1256743137-16987-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1256743137-16987-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
> found in the U300 series platforms. It registers a DMA slave for
> device I/O and also a memcpy slave for memcpy.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---

Few more things I have noticed:

> +static void dma_tasklet(unsigned long data)
> +{
> +	struct coh901318_chan *cohc = (struct coh901318_chan *) data;
> +	struct coh901318_desc *cohd_fin;
> +	unsigned long flags;
> +	dma_async_tx_callback callback;
> +	void *callback_param;
> +
> +	spin_lock_irqsave(&cohc->lock, flags);
> +
> +	/* get first active entry from list */
> +	cohd_fin = coh901318_first_active_get(cohc);
> +
> +	BUG_ON(cohd_fin->pending_irqs == 0);
> +
> +	cohd_fin->pending_irqs--;
> +
> +	BUG_ON(cohc->nbr_active_done && cohd_fin == NULL);
> +
> +	if (cohc->nbr_active_done == 0)
> +		return;
> +
> +	if (cohd_fin == NULL)
> +		goto err;

Checking cohd_fin against NULL should be moved up right after coh901318_first_active_get()

> +
> +	if (cohd_fin->sg != NULL) {
> +		dma_unmap_sg(cohc->chan.dev->device.parent,
> +			     cohd_fin->sg, cohd_fin->sg_len, cohd_fin->dir);
> +	}
[...]
> +coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
> +			unsigned int nents, enum dma_data_direction direction,
> +			unsigned long flags)
[...]
> +	sg_len = dma_map_sg(chan->dev->device.parent,
> +			    sgl, nents, direction);
[...]
> + err_dma_alloc:
> +	if ((direction == DMA_TO_DEVICE &&
> +	     !(flags & DMA_COMPL_SKIP_SRC_UNMAP)) ||
> +	    (direction == DMA_FROM_DEVICE &&
> +	     !(flags & DMA_COMPL_SKIP_DEST_UNMAP)))
> +		dma_unmap_sg(cohc->chan.dev->device.parent,
> +			     cohd->sg, cohd->sg_len, direction);

Since the following change all dma mapping/unmapping for slave channels should be client's responsibility:

commit 657a77fa7284d8ae28dfa48f1dc5d919bf5b2843
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Tue Sep 8 17:53:05 2009 -0700

    dmaengine: Move all map_sg/unmap_sg for slave channel to its client

> +static int __init coh901318_probe(struct platform_device *pdev)
[...]
> +	return err;
> +
> +	dma_async_device_unregister(&base->dma_memcpy);

This one would never be called

> +coh901318_lli_fill_sg(struct coh901318_pool *pool,
> +		      struct coh901318_lli *lli,
> +		      struct scatterlist *sgl, unsigned int nents,
> +		      dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl,
> +		      u32 ctrl_last,
> +		      enum dma_data_direction dir, u32 ctrl_irq_mask)
> +{
> +	int i;
> +	struct scatterlist *sg;
> +	u32 ctrl_sg;
> +	dma_addr_t src = 0;
> +	dma_addr_t dst = 0;
> +	int nbr_of_irq = 0;
> +	u32 bytes_to_transfer;
> +	u32 elem_size;
> +
> +	if (lli == NULL)
> +		goto err;
> +
> +	spin_lock(&pool->lock);
> +
> +	if (dir == DMA_TO_DEVICE)
> +		dst = dev_addr;
> +	else if (dir == DMA_FROM_DEVICE)
> +		src = dev_addr;
> +	else
> +		goto err;
> +
> +	for_each_sg(sgl, sg, nents, i) {

spin_unlock(&pool->lock) should be added when goto err;
Or better I guess: spin_lock moved down, right before the loop.

Regards,
Maciej

