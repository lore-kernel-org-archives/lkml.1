Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZCRMI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZCRMI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbZCRMIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:08:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:6403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905AbZCRMIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,384,1233561600"; 
   d="scan'208";a="121515501"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "iwamatsu.nobuhiro@renesas.com" <iwamatsu.nobuhiro@renesas.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       Paul Mundt <lethal@linux-sh.org>, Linux-sh <linux-sh@vger.kernel.org>
Date: Wed, 18 Mar 2009 12:08:33 +0000
Subject: RE: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA of
 SuperH
Thread-Topic: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA
 of SuperH
Thread-Index: Acmi3iT9sH1jd/PpRH+7IzdMRReOJwE1Nf2Q
Message-ID: <129600E5E5FB004392DDC3FB599660D786B0DFC2@irsmsx504.ger.corp.intel.com>
References: <49B8AF67.8080309@renesas.com>
In-Reply-To: <49B8AF67.8080309@renesas.com>
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

iwamatsu.nobuhiro@renesas.com wrote:
> This supports DMA-Engine driver for DMA of SuperH.
> This supported all DMA channels, and it was tested in SH7722/SH7780.
> This can not use with SH DMA API and can control this in Kconfig.
> 
> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/sh/drivers/dma/Kconfig  |   12 +-
>  arch/sh/drivers/dma/Makefile |    3 +-
>  arch/sh/include/asm/dma-sh.h |   11 +
>  drivers/dma/Kconfig          |    9 +
>  drivers/dma/Makefile         |    2 +
>  drivers/dma/shdma.c          |  743  ++++++++++++++++++++++++++++++++++++++++++ 
>  drivers/dma/shdma.h        |   65 ++++
>  7 files changed, 840 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/dma/shdma.c
>  create mode 100644 drivers/dma/shdma.h

Hi,

My comments/questions below inline.

Regards,
Maciej

> 
> +config SH_DMAE
> +	tristate "Renesas SuperH DMAC support"
> +	depends on SUPERH && SH_DMA
> +	depends on !SH_DMA_API
> +	select DMA_ENGINE
> +	help
> +	  There is SH_DMA_API which is another DMA implementation in SuperH.
> +	  When you want to use this, please enable SH_DMA_API.
> +

This help comment may be confusing. It is not quite clear if "this" refers to SH_DMA_API or SH_DMAE.
I suggest rephrasing it.

> +static void dmae_start(struct sh_dmae_chan *sh_chan)
> +{
> +    u32 chcr = sh_dmae_readl(sh_chan, CHCR);
> +
> +    chcr |= (CHCR_DE|CHCR_IE);
> +	sh_dmae_writel(sh_chan, chcr, CHCR);
> +}

Whitespace issues to be cleaned.

> +static void dmae_halt(struct sh_dmae_chan *sh_chan)
> +{
> +    u32 chcr = sh_dmae_readl(sh_chan, CHCR);
> +    chcr &= ~(CHCR_DE | CHCR_TE | CHCR_IE);
> +	sh_dmae_writel(sh_chan, chcr, CHCR);
> +}

Again whitespace issues.

> +	sh_chan->set_chcr = dmae_set_chcr;
> +	sh_chan->set_dmars = dmae_set_dmars;
> +
> +	return first ? &first->async_tx : NULL;
> +}

Why both set_chcr and set_dmars are set in prep_memcpy?
I guess it would be more efficient to set them in a per channel call, like sh_dmae_chan_probe.
BTW, I do not see any of these two calls used anywhere.
Are they really needed here?

> +	spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
> +
> +	if (ld_node != &sh_chan->ld_queue) {
> +		/* Get the ld start address from ld_queue */
> +		hw = to_sh_desc(ld_node)->hw;
> +		dmae_set_reg(sh_chan, hw);
> +		dmae_start(sh_chan);
> +	}
> +}

Shouldn't this part be kept locked?

> +static irqreturn_t sh_dmae_interrupt(int irq, void *data)
> +{
> +	irqreturn_t ret = IRQ_NONE;
> +	struct sh_dmae_chan *sh_chan = (struct sh_dmae_chan *)data;
> +	u32 chcr = sh_dmae_readl(sh_chan, CHCR);
> +
> +	if (chcr & CHCR_TE) {
> +		struct sh_desc *desc, *cur_desc = NULL;
> +		u32 sar_buf = sh_dmae_readl(sh_chan, SAR);
> +
> +		list_for_each_entry(desc, &sh_chan->ld_queue, node) {
> +			if ((desc->hw.sar + desc->hw.tcr) == sar_buf) {
> +				cur_desc = desc;
> +				break;
> +			}
> +		}

Again, don't you need to lock list_for... to protect ld_queue?

> +	shdev->dev = &pdev->dev;
> +	INIT_LIST_HEAD(&shdev->common.channels);
> +
> +	dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
> +	shdev->common.device_alloc_chan_resources
> +		= sh_dmae_alloc_chan_resources;
> +	shdev->common.device_free_chan_resources = sh_dmae_free_chan_resources;
> +	shdev->common.device_prep_dma_memcpy = sh_dmae_prep_memcpy;
> +	shdev->common.device_is_tx_complete = sh_dmae_is_complete;
> +	shdev->common.device_issue_pending = sh_dmae_memcpy_issue_pending;
> +	shdev->common.dev = &pdev->dev;

shdev->dev seems redundant as you already keep the device in shdev->common.dev.

> +	for (ecnt = 0 ; ecnt < ARRAY_SIZE(eirq); ecnt++) {
> +		err = request_irq(eirq[ecnt], sh_dmae_err,
> +			irqflags, "DMAC Address Error", shdev);
> +		if (err) {
> +			dev_err(&pdev->dev, "DMA device request_irq"
> +				"erro (irq %d) with return %d\n",
> +				eirq[ecnt], err);
> +			goto eirq_err;
> +		}
> +	}

Don't you need to keep it in 
#if defined(CONFIG_CPU_SH4)
as sh_dmae_err definition is?


