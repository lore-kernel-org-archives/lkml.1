Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZDAFLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZDAFLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 01:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZDAFLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 01:11:00 -0400
Received: from relay.atmel.no ([80.232.32.139]:54537 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZDAFLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 01:11:00 -0400
Date: Wed, 1 Apr 2009 07:10:53 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] dw_dmac: add cyclic API to DW DMA driver
Message-ID: <20090401071053.5ab0fb94@hcegtvedt>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D790F8C3F0@irsmsx504.ger.corp.intel.com>
References: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<1237894506-11622-2-git-send-email-hans-christian.egtvedt@atmel.com>
	<129600E5E5FB004392DDC3FB599660D790F8C3F0@irsmsx504.ger.corp.intel.com>
Organization: Atmel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 15:03:07 +0100
"Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:

> Hans-Christian Egtvedt wrote:
> > This patch adds a cyclic DMA interface to the DW DMA driver. This is
> > very useful if you want to use the DMA controller in combination
> > with a sound device which uses cyclic buffers.
> > 
> > Using a DMA channel for cyclic DMA will disable the possibility to
> > use it as a normal DMA engine until the user calls the cyclic free
> > function on the DMA channel. Also a cyclic DMA list can not be
> > prepared if the channel is already active.
> > 
> > Signed-off-by: Hans-Christian Egtvedt
> > <hans-christian.egtvedt@atmel.com> ---
> >  drivers/dma/dw_dmac.c      |  303
> > +++++++++++++++++++++++++++++++++++++++++++-
> > drivers/dma/dw_dmac_regs.h |    7 +- include/linux/dw_dmac.h
> > |    19 +++ 3 files changed, 327 insertions(+), 2 deletions(-)
> >
> 
> The patch looks good to me.
>

Thanks

> Just a few remarks below:
> 
> > +		for (i = 0; i < dwc->cdesc->periods; i++)
> > +			dwc_dump_lli(dwc,
> > &dwc->cdesc->desc[i]->lli); +
> > +		return;
> > +	}
> > +}
> 
> This return is not needed
> 

Agreed, will fixup.

> > +void dw_dma_cyclic_stop(struct dma_chan *chan)
> > +{
> > +	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
> > +	struct dw_dma		*dw =
> > to_dw_dma(dwc->chan.device); +
> > +	channel_clear_bit(dw, CH_EN, dwc->mask);
> > +	while (dma_readl(dw, CH_EN) & dwc->mask)
> > +		cpu_relax();
> > +}
> 
> Don't you need locks in dw_dma_cyclic_stop?
> 

Hmmm, I'll look into this.

> > +	was_cyclic = test_and_set_bit(DW_DMA_IS_CYCLIC,
> > &dwc->flags);
> > +	if (was_cyclic) {
> > +		spin_unlock_bh(&dwc->lock);
> > +		dev_dbg(chan2dev(&dwc->chan),
> > +				"channel already prepared for
> > cyclic DMA\n");
> > +		return ERR_PTR(-EBUSY);
> > +	}
> > +	spin_unlock_bh(&dwc->lock);
> 
> In this case both spin_unlock_bh() could be replaced by single one
> called before "if (was_cyclic)":
> 

Ah yes, will fixup.

> +	was_cyclic = test_and_set_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
> +	spin_unlock_bh(&dwc->lock);
> +	if (was_cyclic) {
> +		dev_dbg(chan2dev(&dwc->chan),
> +				"channel already prepared for cyclic
> DMA\n");
> +		return ERR_PTR(-EBUSY);
> +	} 
> 

-- 
Best regards,
Hans-Christian Egtvedt
