Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZHYQRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZHYQRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZHYQRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:17:54 -0400
Received: from mail.atmel.fr ([81.80.104.162]:50318 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZHYQRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:17:53 -0400
Message-ID: <4A940E9A.8010807@atmel.com>
Date: Tue, 25 Aug 2009 18:17:30 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] dmaengine: Move all map_sg/unmap_sg for slave channel
 to its client
References: <1249012788-965-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1249012788-965-1-git-send-email-anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Atsushi Nemoto :
> Dan Williams wrote:
> ... DMA-slave clients request specific channels and know the hardware
> details at a low level, so it should not be too high an expectation to
> push dma mapping responsibility to the client.
> 
> Also this patch includes DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE support for
> dw_dmac driver.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

I have tested it and it is ok.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> This patch is against next branch of async_tx tree.
> This patch is not tested.  I appreciate if someone test this patch with those
> devices.
> 
>  drivers/dma/at_hdmac.c       |   43 +++++++++++++++++++++--------------------
>  drivers/dma/dw_dmac.c        |   31 ++++++++++++++++++-----------
>  drivers/mmc/host/atmel-mci.c |    9 +++++++-
>  3 files changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 9a1e5fb..3d10525 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -252,25 +252,28 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
>  	list_move(&desc->desc_node, &atchan->free_list);
>  
>  	/* unmap dma addresses */
> -	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> -		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> -			dma_unmap_single(chan2parent(&atchan->chan_common),
> -					desc->lli.daddr,
> -					desc->len, DMA_FROM_DEVICE);
> -		else
> -			dma_unmap_page(chan2parent(&atchan->chan_common),
> -					desc->lli.daddr,
> -					desc->len, DMA_FROM_DEVICE);
> -	}
> -	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> -		if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> -			dma_unmap_single(chan2parent(&atchan->chan_common),
> -					desc->lli.saddr,
> -					desc->len, DMA_TO_DEVICE);
> -		else
> -			dma_unmap_page(chan2parent(&atchan->chan_common),
> -					desc->lli.saddr,
> -					desc->len, DMA_TO_DEVICE);
> +	if (!atchan->chan_common.private) {
> +		struct device *parent = chan2parent(&atchan->chan_common);
> +		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> +			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> +				dma_unmap_single(parent,
> +						desc->lli.daddr,
> +						desc->len, DMA_FROM_DEVICE);
> +			else
> +				dma_unmap_page(parent,
> +						desc->lli.daddr,
> +						desc->len, DMA_FROM_DEVICE);
> +		}
> +		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> +			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> +				dma_unmap_single(parent,
> +						desc->lli.saddr,
> +						desc->len, DMA_TO_DEVICE);
> +			else
> +				dma_unmap_page(parent,
> +						desc->lli.saddr,
> +						desc->len, DMA_TO_DEVICE);
> +		}
>  	}
>  
>  	/*
> @@ -646,8 +649,6 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  
>  	reg_width = atslave->reg_width;
>  
> -	sg_len = dma_map_sg(chan2parent(chan), sgl, sg_len, direction);
> -
>  	ctrla = ATC_DEFAULT_CTRLA | atslave->ctrla;
>  	ctrlb = ATC_DEFAULT_CTRLB | ATC_IEN;
>  
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 98c9a84..a5a5050 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -212,16 +212,25 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
>  	list_splice_init(&txd->tx_list, &dwc->free_list);
>  	list_move(&desc->desc_node, &dwc->free_list);
>  
> -	/*
> -	 * We use dma_unmap_page() regardless of how the buffers were
> -	 * mapped before they were submitted...
> -	 */
> -	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP))
> -		dma_unmap_page(chan2parent(&dwc->chan), desc->lli.dar,
> -			       desc->len, DMA_FROM_DEVICE);
> -	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
> -		dma_unmap_page(chan2parent(&dwc->chan), desc->lli.sar,
> -			       desc->len, DMA_TO_DEVICE);
> +	if (!dwc->chan.private) {
> +		struct device *parent = chan2parent(&dwc->chan);
> +		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> +			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> +				dma_unmap_single(parent, desc->lli.dar,
> +						desc->len, DMA_FROM_DEVICE);
> +			else
> +				dma_unmap_page(parent, desc->lli.dar,
> +						desc->len, DMA_FROM_DEVICE);
> +		}
> +		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> +			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> +				dma_unmap_single(parent, desc->lli.sar,
> +						desc->len, DMA_TO_DEVICE);
> +			else
> +				dma_unmap_page(parent, desc->lli.sar,
> +						desc->len, DMA_TO_DEVICE);
> +		}
> +	}
>  
>  	/*
>  	 * The API requires that no submissions are done from a
> @@ -658,8 +667,6 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  	reg_width = dws->reg_width;
>  	prev = first = NULL;
>  
> -	sg_len = dma_map_sg(chan2parent(chan), sgl, sg_len, direction);
> -
>  	switch (direction) {
>  	case DMA_TO_DEVICE:
>  		ctllo = (DWC_DEFAULT_CTLLO
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index cf6a100..2ec3803 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -574,6 +574,7 @@ atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
>  	struct scatterlist		*sg;
>  	unsigned int			i;
>  	enum dma_data_direction		direction;
> +	unsigned int			sglen;
>  
>  	/*
>  	 * We don't do DMA on "complex" transfers, i.e. with
> @@ -603,11 +604,14 @@ atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
>  	else
>  		direction = DMA_TO_DEVICE;
>  
> +	sglen = dma_map_sg(&host->pdev->dev, data->sg, data->sg_len, direction);
> +	if (sglen != data->sg_len)
> +		goto unmap_exit;
>  	desc = chan->device->device_prep_slave_sg(chan,
>  			data->sg, data->sg_len, direction,
>  			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>  	if (!desc)
> -		return -ENOMEM;
> +		goto unmap_exit;
>  
>  	host->dma.data_desc = desc;
>  	desc->callback = atmci_dma_complete;
> @@ -618,6 +622,9 @@ atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
>  	chan->device->device_issue_pending(chan);
>  
>  	return 0;
> +unmap_exit:
> +	dma_unmap_sg(&host->pdev->dev, data->sg, sglen, direction);
> +	return -ENOMEM;
>  }
>  
>  #else /* CONFIG_MMC_ATMELMCI_DMA */


-- 
Nicolas Ferre

