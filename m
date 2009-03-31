Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbZCaOCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbZCaOCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbZCaOC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:02:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:42597 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbZCaOCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="126110930"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Date: Tue, 31 Mar 2009 15:02:14 +0100
Subject: RE: [PATCH 2/2] dw_dmac: add cyclic API to DW DMA driver
Thread-Topic: [PATCH 2/2] dw_dmac: add cyclic API to DW DMA driver
Thread-Index: AcmsdJkqnssauheQRtCfFw/FqsjpDAFjYvvg
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8C3EE@irsmsx504.ger.corp.intel.com>
References: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
 <1237894506-11622-2-git-send-email-hans-christian.egtvedt@atmel.com>
In-Reply-To: <1237894506-11622-2-git-send-email-hans-christian.egtvedt@atmel.com>
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

Hans-Christian Egtvedt wrote:
> This patch adds a cyclic DMA interface to the DW DMA driver. This is
> very useful if you want to use the DMA controller in combination with a
> sound device which uses cyclic buffers.
> 
> Using a DMA channel for cyclic DMA will disable the possibility to use
> it as a normal DMA engine until the user calls the cyclic free function
> on the DMA channel. Also a cyclic DMA list can not be prepared if the
> channel is already active.
> 
> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> ---
>  drivers/dma/dw_dmac.c      |  303 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/dma/dw_dmac_regs.h |    7 +-
>  include/linux/dw_dmac.h    |   19 +++
>  3 files changed, 327 insertions(+), 2 deletions(-)
> 

Adding Dan...

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 1c5e31d..9e7160d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -363,6 +363,84 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
>  	dwc_descriptor_complete(dwc, bad_desc);
>  }
> 
> +/* --------------------- Cyclic DMA API extensions -------------------- */
> +
> +inline dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan)
> +{
> +	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
> +	return channel_readl(dwc, SAR);
> +}
> +EXPORT_SYMBOL(dw_dma_get_src_addr);
> +
> +inline dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan)
> +{
> +	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
> +	return channel_readl(dwc, DAR);
> +}
> +EXPORT_SYMBOL(dw_dma_get_dst_addr);
> +
> +/* called with dwc->lock held and all interrupts disabled */
> +static void dwc_handle_cyclic(struct dw_dma *dw, struct dw_dma_chan *dwc,
> +		u32 status_block, u32 status_err, u32 status_xfer)
> +{
> +	if (status_block & dwc->mask) {
> +		void (*callback)(void *param);
> +		void *callback_param;
> +
> +		dev_vdbg(chan2dev(&dwc->chan), "new cyclic period llp 0x%08x\n",
> +				channel_readl(dwc, LLP));
> +		dma_writel(dw, CLEAR.BLOCK, dwc->mask);
> +
> +		callback = dwc->cdesc->period_callback;
> +		callback_param = dwc->cdesc->period_callback_param;
> +		if (callback) {
> +			spin_unlock(&dwc->lock);
> +			callback(callback_param);
> +			spin_lock(&dwc->lock);
> +		}
> +	}
> +
> +	/*
> +	 * Error and transfer complete are highly unlikely, and will most
> +	 * likely be due to a configuration error by the user.
> +	 */
> +	if (unlikely(status_err & dwc->mask) ||
> +			unlikely(status_xfer & dwc->mask)) {
> +		int i;
> +
> +		dev_err(chan2dev(&dwc->chan), "cyclic DMA unexpected %s "
> +				"interrupt, stopping DMA transfer\n",
> +				status_xfer ? "xfer" : "error");
> +		dev_err(chan2dev(&dwc->chan),
> +			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
> +			channel_readl(dwc, SAR),
> +			channel_readl(dwc, DAR),
> +			channel_readl(dwc, LLP),
> +			channel_readl(dwc, CTL_HI),
> +			channel_readl(dwc, CTL_LO));
> +
> +		channel_clear_bit(dw, CH_EN, dwc->mask);
> +		while (dma_readl(dw, CH_EN) & dwc->mask)
> +			cpu_relax();
> +
> +		/* make sure DMA does not restart by loading a new list */
> +		channel_writel(dwc, LLP, 0);
> +		channel_writel(dwc, CTL_LO, 0);
> +		channel_writel(dwc, CTL_HI, 0);
> +
> +		dma_writel(dw, CLEAR.BLOCK, dwc->mask);
> +		dma_writel(dw, CLEAR.ERROR, dwc->mask);
> +		dma_writel(dw, CLEAR.XFER, dwc->mask);
> +
> +		for (i = 0; i < dwc->cdesc->periods; i++)
> +			dwc_dump_lli(dwc, &dwc->cdesc->desc[i]->lli);
> +
> +		return;
> +	}
> +}
> +
> +/* ------------------------------------------------------------------------- */
> +
>  static void dw_dma_tasklet(unsigned long data)
>  {
>  	struct dw_dma *dw = (struct dw_dma *)data;
> @@ -382,7 +460,10 @@ static void dw_dma_tasklet(unsigned long data)
>  	for (i = 0; i < dw->dma.chancnt; i++) {
>  		dwc = &dw->chan[i];
>  		spin_lock(&dwc->lock);
> -		if (status_err & (1 << i))
> +		if (test_bit(DW_DMA_IS_CYCLIC, &dwc->flags))
> +			dwc_handle_cyclic(dw, dwc, status_block, status_err,
> +					status_xfer);
> +		else if (status_err & (1 << i))
>  			dwc_handle_error(dw, dwc);
>  		else if ((status_block | status_xfer) & (1 << i))
>  			dwc_scan_descriptors(dw, dwc);
> @@ -884,6 +965,226 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
>  	dev_vdbg(chan2dev(chan), "free_chan_resources done\n");
>  }
> 
> +/* --------------------- Cyclic DMA API extensions -------------------- */
> +
> +int dw_dma_cyclic_start(struct dma_chan *chan)
> +{
> +	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
> +	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
> +
> +	if (!test_bit(DW_DMA_IS_CYCLIC, &dwc->flags)) {
> +		dev_err(chan2dev(&dwc->chan), "missing prep for cyclic DMA\n");
> +		return -ENODEV;
> +	}
> +
> +	spin_lock(&dwc->lock);
> +
> +	/* assert channel is idle */
> +	if (dma_readl(dw, CH_EN) & dwc->mask) {
> +		dev_err(chan2dev(&dwc->chan),
> +			"BUG: Attempted to start non-idle channel\n");
> +		dev_err(chan2dev(&dwc->chan),
> +			"  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",
> +			channel_readl(dwc, SAR),
> +			channel_readl(dwc, DAR),
> +			channel_readl(dwc, LLP),
> +			channel_readl(dwc, CTL_HI),
> +			channel_readl(dwc, CTL_LO));
> +		spin_unlock(&dwc->lock);
> +		return -EBUSY;
> +	}
> +
> +	dma_writel(dw, CLEAR.BLOCK, dwc->mask);
> +	dma_writel(dw, CLEAR.ERROR, dwc->mask);
> +	dma_writel(dw, CLEAR.XFER, dwc->mask);
> +
> +	/* setup DMAC channel registers */
> +	channel_writel(dwc, LLP, dwc->cdesc->desc[0]->txd.phys);
> +	channel_writel(dwc, CTL_LO, DWC_CTLL_LLP_D_EN | DWC_CTLL_LLP_S_EN);
> +	channel_writel(dwc, CTL_HI, 0);
> +
> +	channel_set_bit(dw, CH_EN, dwc->mask);
> +
> +	spin_unlock(&dwc->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(dw_dma_cyclic_start);
> +
> +void dw_dma_cyclic_stop(struct dma_chan *chan)
> +{
> +	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
> +	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
> +
> +	channel_clear_bit(dw, CH_EN, dwc->mask);
> +	while (dma_readl(dw, CH_EN) & dwc->mask)
> +		cpu_relax();
> +}
> +EXPORT_SYMBOL(dw_dma_cyclic_stop);
> +
> +struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
> +		dma_addr_t buf_addr, size_t buf_len, size_t period_len,
> +		enum dma_data_direction direction)
> +{
> +	struct dw_dma_chan		*dwc = to_dw_dma_chan(chan);
> +	struct dw_cyclic_desc		*cdesc;
> +	struct dw_cyclic_desc		*retval = NULL;
> +	struct dw_desc			*desc;
> +	struct dw_desc			*last = NULL;
> +	struct dw_dma_slave		*dws = chan->private;
> +	unsigned long			was_cyclic;
> +	unsigned int			reg_width;
> +	unsigned int			periods;
> +	unsigned int			i;
> +
> +	spin_lock_bh(&dwc->lock);
> +	if (!list_empty(&dwc->queue) || !list_empty(&dwc->active_list)) {
> +		spin_unlock_bh(&dwc->lock);
> +		dev_dbg(chan2dev(&dwc->chan),
> +				"queue and/or active list are not empty\n");
> +		return ERR_PTR(-EBUSY);
> +	}
> +
> +	was_cyclic = test_and_set_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
> +	if (was_cyclic) {
> +		spin_unlock_bh(&dwc->lock);
> +		dev_dbg(chan2dev(&dwc->chan),
> +				"channel already prepared for cyclic DMA\n");
> +		return ERR_PTR(-EBUSY);
> +	}
> +	spin_unlock_bh(&dwc->lock);
> +
> +	retval = ERR_PTR(-EINVAL);
> +	reg_width = dws->reg_width;
> +	periods = buf_len / period_len;
> +
> +	/* Check for too big/unaligned periods and unaligned DMA buffer. */
> +	if (period_len > (DWC_MAX_COUNT << reg_width))
> +		goto out_err;
> +	if (unlikely(period_len & ((1 << reg_width) - 1)))
> +		goto out_err;
> +	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
> +		goto out_err;
> +	if (unlikely(!(direction & (DMA_TO_DEVICE | DMA_FROM_DEVICE))))
> +		goto out_err;
> +
> +	retval = ERR_PTR(-ENOMEM);
> +
> +	if (periods > NR_DESCS_PER_CHANNEL)
> +		goto out_err;
> +
> +	cdesc = kzalloc(sizeof(struct dw_cyclic_desc), GFP_KERNEL);
> +	if (!cdesc)
> +		goto out_err;
> +
> +	cdesc->desc = kzalloc(sizeof(struct dw_desc *) * periods, GFP_KERNEL);
> +	if (!cdesc->desc)
> +		goto out_err_alloc;
> +
> +	for (i = 0; i < periods; i++) {
> +		desc = dwc_desc_get(dwc);
> +		if (!desc)
> +			goto out_err_desc_get;
> +
> +		switch (direction) {
> +		case DMA_TO_DEVICE:
> +			desc->lli.dar = dws->tx_reg;
> +			desc->lli.sar = buf_addr + (period_len * i);
> +			desc->lli.ctllo = (DWC_DEFAULT_CTLLO
> +					| DWC_CTLL_DST_WIDTH(reg_width)
> +					| DWC_CTLL_SRC_WIDTH(reg_width)
> +					| DWC_CTLL_DST_FIX
> +					| DWC_CTLL_SRC_INC
> +					| DWC_CTLL_FC_M2P
> +					| DWC_CTLL_INT_EN);
> +			break;
> +		case DMA_FROM_DEVICE:
> +			desc->lli.dar = buf_addr + (period_len * i);
> +			desc->lli.sar = dws->rx_reg;
> +			desc->lli.ctllo = (DWC_DEFAULT_CTLLO
> +					| DWC_CTLL_SRC_WIDTH(reg_width)
> +					| DWC_CTLL_DST_WIDTH(reg_width)
> +					| DWC_CTLL_DST_INC
> +					| DWC_CTLL_SRC_FIX
> +					| DWC_CTLL_FC_P2M
> +					| DWC_CTLL_INT_EN);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		desc->lli.ctlhi = (period_len >> reg_width);
> +		cdesc->desc[i] = desc;
> +
> +		if (last) {
> +			last->lli.llp = desc->txd.phys;
> +			dma_sync_single_for_device(chan2parent(chan),
> +					last->txd.phys, sizeof(last->lli),
> +					DMA_TO_DEVICE);
> +		}
> +
> +		last = desc;
> +	}
> +
> +	/* lets make a cyclic list */
> +	last->lli.llp = cdesc->desc[0]->txd.phys;
> +	dma_sync_single_for_device(chan2parent(chan), last->txd.phys,
> +			sizeof(last->lli), DMA_TO_DEVICE);
> +
> +	dev_dbg(chan2dev(&dwc->chan), "cyclic prepared buf 0x%08x len %zu "
> +			"period %zu periods %d\n", buf_addr, buf_len,
> +			period_len, periods);
> +
> +	cdesc->periods = periods;
> +	dwc->cdesc = cdesc;
> +
> +	return cdesc;
> +
> +out_err_desc_get:
> +	while (i--)
> +		dwc_desc_put(dwc, cdesc->desc[i]);
> +out_err_alloc:
> +	kfree(cdesc);
> +out_err:
> +	clear_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
> +	return (struct dw_cyclic_desc *)retval;
> +}
> +EXPORT_SYMBOL(dw_dma_cyclic_prep);
> +
> +void dw_dma_cyclic_free(struct dma_chan *chan)
> +{
> +	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
> +	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
> +	struct dw_cyclic_desc	*cdesc = dwc->cdesc;
> +	int			i;
> +
> +	dev_dbg(chan2dev(&dwc->chan), "cyclic free\n");
> +
> +	if (!cdesc)
> +		return;
> +
> +	spin_lock_bh(&dwc->lock);
> +
> +	channel_clear_bit(dw, CH_EN, dwc->mask);
> +	while (dma_readl(dw, CH_EN) & dwc->mask)
> +		cpu_relax();
> +
> +	dma_writel(dw, CLEAR.BLOCK, dwc->mask);
> +	dma_writel(dw, CLEAR.ERROR, dwc->mask);
> +	dma_writel(dw, CLEAR.XFER, dwc->mask);
> +
> +	spin_unlock_bh(&dwc->lock);
> +
> +	for (i = 0; i < cdesc->periods; i++)
> +		dwc_desc_put(dwc, cdesc->desc[i]);
> +
> +	kfree(cdesc->desc);
> +	kfree(cdesc);
> +
> +	clear_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
> +}
> +EXPORT_SYMBOL(dw_dma_cyclic_free);
> +
>  /*----------------------------------------------------------------------*/
> 
>  static void dw_dma_off(struct dw_dma *dw)
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index b252b20..13a5807 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -126,6 +126,10 @@ struct dw_dma_regs {
> 
>  #define DW_REGLEN		0x400
> 
> +enum dw_dmac_flags {
> +	DW_DMA_IS_CYCLIC = 0,
> +};
> +
>  struct dw_dma_chan {
>  	struct dma_chan		chan;
>  	void __iomem		*ch_regs;
> @@ -134,10 +138,12 @@ struct dw_dma_chan {
>  	spinlock_t		lock;
> 
>  	/* these other elements are all protected by lock */
> +	unsigned long		flags;
>  	dma_cookie_t		completed;
>  	struct list_head	active_list;
>  	struct list_head	queue;
>  	struct list_head	free_list;
> +	struct dw_cyclic_desc	*cdesc;
> 
>  	unsigned int		descs_allocated;
>  };
> @@ -158,7 +164,6 @@ static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
>  	return container_of(chan, struct dw_dma_chan, chan);
>  }
> 
> -
>  struct dw_dma {
>  	struct dma_device	dma;
>  	void __iomem		*regs;
> diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
> index d797dde..c8aad71 100644
> --- a/include/linux/dw_dmac.h
> +++ b/include/linux/dw_dmac.h
> @@ -74,4 +74,23 @@ struct dw_dma_slave {
>  #define DWC_CFGL_HS_DST_POL	(1 << 18)	/* dst handshake active low */
>  #define DWC_CFGL_HS_SRC_POL	(1 << 19)	/* src handshake active low */
> 
> +/* DMA API extensions */
> +struct dw_cyclic_desc {
> +	struct dw_desc	**desc;
> +	unsigned long	periods;
> +	void		(*period_callback)(void *param);
> +	void		*period_callback_param;
> +};
> +
> +struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
> +		dma_addr_t buf_addr, size_t buf_len, size_t period_len,
> +		enum dma_data_direction direction);
> +void dw_dma_cyclic_free(struct dma_chan *chan);
> +int dw_dma_cyclic_start(struct dma_chan *chan);
> +void dw_dma_cyclic_stop(struct dma_chan *chan);
> +
> +dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan);
> +
> +dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan);
> +
>  #endif /* DW_DMAC_H */


