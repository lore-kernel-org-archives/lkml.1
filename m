Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZCaODm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZCaODm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbZCaODb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:03:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:38703 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146AbZCaODa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:03:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="502288785"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Date: Tue, 31 Mar 2009 15:03:07 +0100
Subject: RE: [PATCH 2/2] dw_dmac: add cyclic API to DW DMA driver
Thread-Topic: [PATCH 2/2] dw_dmac: add cyclic API to DW DMA driver
Thread-Index: AcmsdJkqnssauheQRtCfFw/FqsjpDAFit0UA
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8C3F0@irsmsx504.ger.corp.intel.com>
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
>  drivers/dma/dw_dmac.c      |  303  +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/dma/dw_dmac_regs.h |    7 +- include/linux/dw_dmac.h    |    19 +++
>  3 files changed, 327 insertions(+), 2 deletions(-)
>

The patch looks good to me.
Just a few remarks below:

> +		for (i = 0; i < dwc->cdesc->periods; i++)
> +			dwc_dump_lli(dwc, &dwc->cdesc->desc[i]->lli);
> +
> +		return;
> +	}
> +}

This return is not needed

> +void dw_dma_cyclic_stop(struct dma_chan *chan)
> +{
> +	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
> +	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
> +
> +	channel_clear_bit(dw, CH_EN, dwc->mask);
> +	while (dma_readl(dw, CH_EN) & dwc->mask)
> +		cpu_relax();
> +}

Don't you need locks in dw_dma_cyclic_stop?

> +	was_cyclic = test_and_set_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
> +	if (was_cyclic) {
> +		spin_unlock_bh(&dwc->lock);
> +		dev_dbg(chan2dev(&dwc->chan),
> +				"channel already prepared for cyclic DMA\n");
> +		return ERR_PTR(-EBUSY);
> +	}
> +	spin_unlock_bh(&dwc->lock);

In this case both spin_unlock_bh() could be replaced by single one called before "if (was_cyclic)":

+	was_cyclic = test_and_set_bit(DW_DMA_IS_CYCLIC, &dwc->flags);
+	spin_unlock_bh(&dwc->lock);
+	if (was_cyclic) {
+		dev_dbg(chan2dev(&dwc->chan),
+				"channel already prepared for cyclic DMA\n");
+		return ERR_PTR(-EBUSY);
+	} 

Regards,
Maciej