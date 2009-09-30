Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZI3PjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZI3PjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZI3PjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:39:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:8228 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZI3PjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:39:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,480,1249282800"; 
   d="scan'208";a="498480044"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2009 16:38:59 +0100
Subject: RE: [PATCH 1/2] Add COH 901 318 DMA block driver
Thread-Topic: [PATCH 1/2] Add COH 901 318 DMA block driver
Thread-Index: Aco7kmalL4HbLrYiTLe3oTi8gwrDLwGT5/fw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B78C93C0@irsmsx504.ger.corp.intel.com>
References: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
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

[...]

> +static struct coh901318_desc *
> +coh901318_desc_get(struct coh901318_chan *cohc)
> +{
> +	struct coh901318_desc *desc;
> +
> +	if (list_empty(&cohc->free)) {
> +		/* alloc new desc because we'r out of used ones

we'r -> we're

> +int coh901318_stop(struct dma_chan *chan)
> +{
> +	u32 val;
> +	unsigned long flags;
> +	struct coh901318_chan *cohc = to_coh901318_chan(chan);
> +	int channel = cohc->id;
> +	void *virtbase = cohc->base->virtbase;
> +
> +	if (cohc->id >= cohc->base->platform->max_channels) {
> +		dev_dbg(COHC_2_DEV(cohc),
> +			"%s: trying to suspend non-existing channel %d\n",
> +			__func__, cohc->id);
> +		return -1;
> +	}
> +
> +	spin_lock_irqsave(&cohc->lock, flags);
> +
> +	/* Disable channel in HW */
> +	val = readl(virtbase + COH901318_CX_CFG +
> +		    COH901318_CX_CFG_SPACING * channel);
> +
> +	/* Stopping infinit transfer */
> +	if ((val & COH901318_CX_CTRL_TC_ENABLE) == 0 &&
> +	    (val & COH901318_CX_CFG_CH_ENABLE))
> +		cohc->stopped = 1;
> +
> +
> +	val &= ~COH901318_CX_CFG_CH_ENABLE;
> +	writel(val, virtbase + COH901318_CX_CFG +
> +	       COH901318_CX_CFG_SPACING * channel);
> +
> +	writel(val, virtbase + COH901318_CX_CFG +
> +	       COH901318_CX_CFG_SPACING * channel);

The same writel repeated.

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
> +
> +	if (cohd_fin->sg != NULL) {
> +		dma_unmap_sg(cohc->chan.dev->device.parent,
> +			     cohd_fin->sg, cohd_fin->sg_len, cohd_fin->dir);
> +	}
> +
> +	if (!cohd_fin->pending_irqs) {
> +		/* release the lli allocation*/
> +		coh901318_lli_free(&cohc->base->pool, &cohd_fin->data);
> +	}
> +
> +	dev_vdbg(COHC_2_DEV(cohc), "[%s] chan_id %d pending_irqs %d"
> +		 " nbr_active_done %ld\n", __func__,
> +		 cohc->id, cohc->pending_irqs, cohc->nbr_active_done);
> +
> +	/* callback to client */
> +	callback = cohd_fin->desc.callback;
> +	callback_param = cohd_fin->desc.callback_param;
> +
> +	if (!cohd_fin->pending_irqs) {
> +		coh901318_desc_remove(cohd_fin);
> +
> +		/* return desc to free-list */
> +		coh901318_desc_free(cohc, cohd_fin);
> +	}
> +
> +	if (cohc->nbr_active_done)
> +		cohc->nbr_active_done--;
> +
> +	if (cohc->nbr_active_done) {
> +		if (cohc_chan_conf(cohc)->priority_high)
> +			tasklet_hi_schedule(&cohc->tasklet);
> +		else
> +			tasklet_schedule(&cohc->tasklet);
> +	}
> +	spin_unlock_irqrestore(&cohc->lock, flags);
> +
> +	if (callback)
> +		callback(callback_param);
> +
> +	return;
> +
> + err:
> +	dev_err(COHC_2_DEV(cohc), "[%s] No active dma desc\n", __func__);
> +}

spin_unlock_irqrestore needed in case of err.

> +struct dma_async_tx_descriptor *
> +coh901318_prep_single(struct dma_chan *chan, dma_addr_t buf,
> +		      unsigned int size, enum dma_data_direction dir,
> +		      unsigned long flags)
> +{
> +	struct coh901318_lli *data;
> +	struct coh901318_desc *cohd;
> +	unsigned long flg;
> +	struct coh901318_chan *cohc = to_coh901318_chan(chan);
> +	int lli_len;
> +
> +	spin_lock_irqsave(&cohc->lock, flg);
> +
> +	dev_vdbg(COHC_2_DEV(cohc), "[%s] channel %d\n",
> +		 __func__, cohc->id);
> +
> +	lli_len = size >> MAX_DMA_PACKET_SIZE_SHIFT;
> +	if ((lli_len << MAX_DMA_PACKET_SIZE_SHIFT) < size)
> +		lli_len++;
> +
> +	data = coh901318_lli_alloc(&cohc->base->pool, lli_len);
> +
> +	if (data == NULL)
> +		goto err;
> +
> +	cohd = coh901318_desc_get(cohc);
> +	cohd->sg = NULL;
> +	cohd->sg_len = 0;
> +	cohd->dir = dir;
> +	cohd->data = data;
> +
> +	cohd->pending_irqs =
> +		coh901318_lli_fill_single(
> +					  &cohc->base->pool, data, buf, size,
> +					  cohc_dev_addr(cohc),
> +					  cohc_chan_param(cohc)->ctrl_lli_chained,
> +					  cohc_chan_param(cohc)->ctrl_lli_last,
> +					  dir);
> +	cohd->flags = flags;
> +
> +	coh901318_list_print(cohc, data);
> +
> +	dma_async_tx_descriptor_init(&cohd->desc, chan);
> +
> +	cohd->desc.tx_submit = coh901318_tx_submit;
> +
> +	spin_unlock_irqrestore(&cohc->lock, flg);
> +
> +	return &cohd->desc;
> + err:
> +	spin_lock_irqsave(&cohc->lock, flg);

I guess it meant to be unlock not lock.

> +static struct dma_async_tx_descriptor *
> +coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> +		      size_t size, unsigned long flags)
> +{
> +	struct coh901318_lli *data;
> +	struct coh901318_desc *cohd;
> +	unsigned long flg;
> +	struct coh901318_chan *cohc = to_coh901318_chan(chan);
> +	int lli_len;
> +
> +	spin_lock_irqsave(&cohc->lock, flg);
> +
> +	dev_vdbg(COHC_2_DEV(cohc),
> +		 "[%s] channel %d src 0x%x dest 0x%x size %d\n",
> +		 __func__, cohc->id, src, dest, size);
> +
> +	lli_len = size >> MAX_DMA_PACKET_SIZE_SHIFT;
> +	if ((lli_len << MAX_DMA_PACKET_SIZE_SHIFT) < size)
> +		lli_len++;
> +
> +	data = coh901318_lli_alloc(&cohc->base->pool, lli_len);
> +
> +	if (data == NULL)
> +		goto err;
> +
> +	cohd = coh901318_desc_get(cohc);
> +	cohd->sg = NULL;
> +	cohd->sg_len = 0;
> +	cohd->data = data;
> +
> +	cohd->pending_irqs =
> +		coh901318_lli_fill_memcpy(
> +					  &cohc->base->pool, data, src, size, dest,
> +					  cohc_chan_param(cohc)->ctrl_lli_chained,
> +					  cohc_chan_param(cohc)->ctrl_lli_last);
> +	cohd->flags = flags;
> +
> +	coh901318_list_print(cohc, data);
> +
> +	dma_async_tx_descriptor_init(&cohd->desc, chan);
> +
> +	cohd->desc.tx_submit = coh901318_tx_submit;
> +
> +	spin_unlock_irqrestore(&cohc->lock, flg);
> +
> +	return &cohd->desc;
> + err:
> +	spin_lock_irqsave(&cohc->lock, flg);

The same here: lock -> unlock

> +static void
> +coh901318_terminate_all(struct dma_chan *chan)
> +{
> +	unsigned long flags;
> +	struct coh901318_chan *cohc = to_coh901318_chan(chan);
> +	struct coh901318_desc *cohd;
> +	void *virtbase = cohc->base->virtbase;
> +
> +	coh901318_stop(chan);

Shouldn't you check what coh901318_stop() returns and quit if it's -1?

> +
> +	spin_lock_irqsave(&cohc->lock, flags);
> +
> +	/* Clear any pending BE or TC interrupt */
> +	if (cohc->id < 32) {
> +		writel(1 << cohc->id, virtbase + COH901318_BE_INT_CLEAR1);
> +		writel(1 << cohc->id, virtbase + COH901318_TC_INT_CLEAR1);
> +	} else {
> +		writel(1 << (cohc->id - 32), virtbase +
> +		       COH901318_BE_INT_CLEAR2);
> +		writel(1 << (cohc->id - 32), virtbase +
> +		       COH901318_TC_INT_CLEAR2);
> +	}
> +
> +	enable_powersave(cohc);

enable_powersave() has been called in coh901318_stop() already

Regards,
Maciej