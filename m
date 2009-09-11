Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZIKJ1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZIKJ1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZIKJ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:27:09 -0400
Received: from mail.atmel.fr ([81.80.104.162]:41451 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZIKJ1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:27:08 -0400
Message-ID: <4AAA17CD.4020107@atmel.com>
Date: Fri, 11 Sep 2009 11:26:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at_hdmac: implement a private tx_list
References: <20090905193355.18821.45429.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090905193355.18821.45429.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams :
> Drop at_hdmac's use of tx_list from struct dma_async_tx_descriptor in
> preparation for removal of this field.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
> One more tx_list push down patch for 2.6.32.
> 
> Thanks,
> Dan
> 
>  drivers/dma/at_hdmac.c      |   17 +++++++++--------
>  drivers/dma/at_hdmac_regs.h |    1 +
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 9a1e5fb..da4e8b7 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -87,6 +87,7 @@ static struct at_desc *atc_alloc_descriptor(struct dma_chan *chan,
>  	desc = dma_pool_alloc(atdma->dma_desc_pool, gfp_flags, &phys);
>  	if (desc) {
>  		memset(desc, 0, sizeof(struct at_desc));
> +		INIT_LIST_HEAD(&desc->tx_list);
>  		dma_async_tx_descriptor_init(&desc->txd, chan);
>  		/* txd.flags will be overwritten in prep functions */
>  		desc->txd.flags = DMA_CTRL_ACK;
> @@ -150,11 +151,11 @@ static void atc_desc_put(struct at_dma_chan *atchan, struct at_desc *desc)
>  		struct at_desc *child;
>  
>  		spin_lock_bh(&atchan->lock);
> -		list_for_each_entry(child, &desc->txd.tx_list, desc_node)
> +		list_for_each_entry(child, &desc->tx_list, desc_node)
>  			dev_vdbg(chan2dev(&atchan->chan_common),
>  					"moving child desc %p to freelist\n",
>  					child);
> -		list_splice_init(&desc->txd.tx_list, &atchan->free_list);
> +		list_splice_init(&desc->tx_list, &atchan->free_list);
>  		dev_vdbg(chan2dev(&atchan->chan_common),
>  			 "moving desc %p to freelist\n", desc);
>  		list_add(&desc->desc_node, &atchan->free_list);
> @@ -247,7 +248,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
>  	param = txd->callback_param;
>  
>  	/* move children to free_list */
> -	list_splice_init(&txd->tx_list, &atchan->free_list);
> +	list_splice_init(&desc->tx_list, &atchan->free_list);
>  	/* move myself to free_list */
>  	list_move(&desc->desc_node, &atchan->free_list);
>  
> @@ -334,7 +335,7 @@ static void atc_cleanup_descriptors(struct at_dma_chan *atchan)
>  			/* This one is currently in progress */
>  			return;
>  
> -		list_for_each_entry(child, &desc->txd.tx_list, desc_node)
> +		list_for_each_entry(child, &desc->tx_list, desc_node)
>  			if (!(child->lli.ctrla & ATC_DONE))
>  				/* Currently in progress */
>  				return;
> @@ -407,7 +408,7 @@ static void atc_handle_error(struct at_dma_chan *atchan)
>  	dev_crit(chan2dev(&atchan->chan_common),
>  			"  cookie: %d\n", bad_desc->txd.cookie);
>  	atc_dump_lli(atchan, &bad_desc->lli);
> -	list_for_each_entry(child, &bad_desc->txd.tx_list, desc_node)
> +	list_for_each_entry(child, &bad_desc->tx_list, desc_node)
>  		atc_dump_lli(atchan, &child->lli);
>  
>  	/* Pretend the descriptor completed successfully */
> @@ -587,7 +588,7 @@ atc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>  			prev->lli.dscr = desc->txd.phys;
>  			/* insert the link descriptor to the LD ring */
>  			list_add_tail(&desc->desc_node,
> -					&first->txd.tx_list);
> +					&first->tx_list);
>  		}
>  		prev = desc;
>  	}
> @@ -687,7 +688,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  				prev->lli.dscr = desc->txd.phys;
>  				/* insert the link descriptor to the LD ring */
>  				list_add_tail(&desc->desc_node,
> -						&first->txd.tx_list);
> +						&first->tx_list);
>  			}
>  			prev = desc;
>  			total_len += len;
> @@ -729,7 +730,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  				prev->lli.dscr = desc->txd.phys;
>  				/* insert the link descriptor to the LD ring */
>  				list_add_tail(&desc->desc_node,
> -						&first->txd.tx_list);
> +						&first->tx_list);
>  			}
>  			prev = desc;
>  			total_len += len;
> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> index 4c972af..495457e 100644
> --- a/drivers/dma/at_hdmac_regs.h
> +++ b/drivers/dma/at_hdmac_regs.h
> @@ -165,6 +165,7 @@ struct at_desc {
>  	struct at_lli			lli;
>  
>  	/* THEN values for driver housekeeping */
> +	struct list_head		tx_list;
>  	struct dma_async_tx_descriptor	txd;
>  	struct list_head		desc_node;
>  	size_t				len;
> 
> 


-- 
Nicolas Ferre

