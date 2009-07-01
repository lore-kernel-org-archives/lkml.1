Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZGAN7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZGAN7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZGAN7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:59:03 -0400
Received: from mail.atmel.fr ([81.80.104.162]:52140 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZGAN7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:59:03 -0400
Message-ID: <4A4B6B90.90006@atmel.com>
Date: Wed, 01 Jul 2009 15:58:40 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: dan.j.williams@intel.com, maciej.sosnowski@intel.com
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel
 AHB DMA Controller
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just one question Dan (see below).

Nicolas Ferre :
> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
> at91sam9rl chip. It will be used on other products in the future.

[..]

> +/**
> + * atc_chain_complete - finish work for one transaction chain
> + * @atchan: channel we work on
> + * @desc: descriptor at the head of the chain we want do complete
> + *
> + * Called with atchan->lock held and bh disabled */
> +static void
> +atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
> +{
> +	dma_async_tx_callback		callback;
> +	void				*param;
> +	struct dma_async_tx_descriptor	*txd = &desc->txd;
> +
> +	dev_vdbg(chan2dev(&atchan->chan_common),
> +		"descriptor %u complete\n", txd->cookie);
> +
> +	atchan->completed_cookie = txd->cookie;
> +	callback = txd->callback;
> +	param = txd->callback_param;
> +
> +	/* move children to free_list */
> +	list_splice_init(&txd->tx_list, &atchan->free_list);
> +	/* move myself to free_list */
> +	list_move(&desc->desc_node, &atchan->free_list);
> +
> +	/*
> +	 * We use dma_unmap_page() regardless of how the buffers were
> +	 * mapped before they were submitted...
> +	 */
> +	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP))
> +		dma_unmap_page(chan2parent(&atchan->chan_common), desc->lli.daddr,
> +				desc->len, DMA_FROM_DEVICE);
> +	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
> +		dma_unmap_page(chan2parent(&atchan->chan_common), desc->lli.saddr,
> +				desc->len, DMA_TO_DEVICE);
> +
> +	/*
> +	 * The API requires that no submissions are done from a
> +	 * callback, so we don't need to drop the lock here
> +	 */
> +	if (callback)
> +		callback(param);

Even if our dma controller does not seems to take advantage of
dependency requests...

...should I add the
dma_run_dependencies(txd);
call here to improve conformance to dmaengine standards ?

As you advice Atsushi Nemoto to do so, I was wondering if I have to do
the same.

Thanks for your help.
-- 
Nicolas Ferre

