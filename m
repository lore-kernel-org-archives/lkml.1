Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbZCSGTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbZCSGTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZCSGTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:19:11 -0400
Received: from mail.renesas.com ([202.234.163.13]:39012 "EHLO
	mail04.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754698AbZCSGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:19:10 -0400
X-AuditID: ac140387-00000009000005fd-f4-49c1e3d944bf
Date: Thu, 19 Mar 2009 15:19:04 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA of
 SuperH
In-reply-to: <129600E5E5FB004392DDC3FB599660D786B0DFC2@irsmsx504.ger.corp.intel.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       Paul Mundt <lethal@linux-sh.org>, Linux-sh <linux-sh@vger.kernel.org>
Message-id: <49C1E3D8.6070102@renesas.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
References: <49B8AF67.8080309@renesas.com>
 <129600E5E5FB004392DDC3FB599660D786B0DFC2@irsmsx504.ger.corp.intel.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Maciej.

Thank you for your check.

2009/3/18 Sosnowski, Maciej <maciej.sosnowski@intel.com>:
 > > iwamatsu.nobuhiro@renesas.com wrote:
 >> >> This supports DMA-Engine driver for DMA of SuperH.
 >> >> This supported all DMA channels, and it was tested in SH7722/SH7780.
 >> >> This can not use with SH DMA API and can control this in Kconfig.
 >> >>
 >> >> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
 >> >> Cc: Paul Mundt <lethal@linux-sh.org>
 >> >> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
 >> >> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
 >> >> Cc: Dan Williams <dan.j.williams@intel.com>
 >> >> ---
 >> >>  arch/sh/drivers/dma/Kconfig  |   12 +-
 >> >>  arch/sh/drivers/dma/Makefile |    3 +-
 >> >>  arch/sh/include/asm/dma-sh.h |   11 +
 >> >>  drivers/dma/Kconfig          |    9 +
 >> >>  drivers/dma/Makefile         |    2 +
 >> >>  drivers/dma/shdma.c          |  743  ++++++++++++++++++++++++++++++++++++++++++
 >> >>  drivers/dma/shdma.h        |   65 ++++
 >> >>  7 files changed, 840 insertions(+), 5 deletions(-)
 >> >>  create mode 100644 drivers/dma/shdma.c
 >> >>  create mode 100644 drivers/dma/shdma.h
 > >
 > > Hi,
 > >
 > > My comments/questions below inline.
 > >
 > > Regards,
 > > Maciej
 > >
 >> >>
 >> >> +config SH_DMAE
 >> >> +     tristate "Renesas SuperH DMAC support"
 >> >> +     depends on SUPERH && SH_DMA
 >> >> +     depends on !SH_DMA_API
 >> >> +     select DMA_ENGINE
 >> >> +     help
 >> >> +       There is SH_DMA_API which is another DMA implementation in SuperH.
 >> >> +       When you want to use this, please enable SH_DMA_API.
 >> >> +
 > >
 > > This help comment may be confusing. It is not quite clear if "this" refers to SH_DMA_API or SH_DMAE.
 > > I suggest rephrasing it.
OK, I rewrite this help.

 > >
 >> >> +static void dmae_start(struct sh_dmae_chan *sh_chan)
 >> >> +{
 >> >> +    u32 chcr = sh_dmae_readl(sh_chan, CHCR);
 >> >> +
 >> >> +    chcr |= (CHCR_DE|CHCR_IE);
 >> >> +     sh_dmae_writel(sh_chan, chcr, CHCR);
 >> >> +}
 > >
 > > Whitespace issues to be cleaned.
 > >
 >> >> +static void dmae_halt(struct sh_dmae_chan *sh_chan)
 >> >> +{
 >> >> +    u32 chcr = sh_dmae_readl(sh_chan, CHCR);
 >> >> +    chcr &= ~(CHCR_DE | CHCR_TE | CHCR_IE);
 >> >> +     sh_dmae_writel(sh_chan, chcr, CHCR);
 >> >> +}
 > >
 > > Again whitespace issues.
I will fix these.

 > >
 >> >> +     sh_chan->set_chcr = dmae_set_chcr;
 >> >> +     sh_chan->set_dmars = dmae_set_dmars;
 >> >> +
 >> >> +     return first ? &first->async_tx : NULL;
 >> >> +}
 > >
 > > Why both set_chcr and set_dmars are set in prep_memcpy?
 > > I guess it would be more efficient to set them in a per channel call, like sh_dmae_chan_probe.
It is not surely necessary to set these in prep_memcpy.
I fix this.

 > > BTW, I do not see any of these two calls used anywhere.
 > > Are they really needed here?
DMAC of superH has register that control DMA transfer size and other.
I use these to initialize DMAC.
For example, it is DMA data size or a transfer method.

For example, driver uses it as follows.
----
struct dma_chan *chan = dma_request_channel();
....
sh_chan = to_sh_chan(chan);
sh_chan->set_dmars();
----

I made it such an implementation to operate a function peculiar to DMAC,
but is there the method that, besides, is good?
Please teach it if there is it.

 > >
 >> >> +     spin_unlock_irqrestore(&sh_chan->desc_lock, flags);
 >> >> +
 >> >> +     if (ld_node != &sh_chan->ld_queue) {
 >> >> +             /* Get the ld start address from ld_queue */
 >> >> +             hw = to_sh_desc(ld_node)->hw;
 >> >> +             dmae_set_reg(sh_chan, hw);
 >> >> +             dmae_start(sh_chan);
 >> >> +     }
 >> >> +}
 > >
 > > Shouldn't this part be kept locked?
Oops, It mistake.
I fix this.

 > >
 >> >> +static irqreturn_t sh_dmae_interrupt(int irq, void *data)
 >> >> +{
 >> >> +     irqreturn_t ret = IRQ_NONE;
 >> >> +     struct sh_dmae_chan *sh_chan = (struct sh_dmae_chan *)data;
 >> >> +     u32 chcr = sh_dmae_readl(sh_chan, CHCR);
 >> >> +
 >> >> +     if (chcr & CHCR_TE) {
 >> >> +             struct sh_desc *desc, *cur_desc = NULL;
 >> >> +             u32 sar_buf = sh_dmae_readl(sh_chan, SAR);
 >> >> +
 >> >> +             list_for_each_entry(desc, &sh_chan->ld_queue, node) {
 >> >> +                     if ((desc->hw.sar + desc->hw.tcr) == sar_buf) {
 >> >> +                             cur_desc = desc;
 >> >> +                             break;
 >> >> +                     }
 >> >> +             }
 > >
 > > Again, don't you need to lock list_for... to protect ld_queue?
 > >
 >> >> +     shdev->dev = &pdev->dev;
 >> >> +     INIT_LIST_HEAD(&shdev->common.channels);
 >> >> +
 >> >> +     dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
 >> >> +     shdev->common.device_alloc_chan_resources
 >> >> +             = sh_dmae_alloc_chan_resources;
 >> >> +     shdev->common.device_free_chan_resources = sh_dmae_free_chan_resources;
 >> >> +     shdev->common.device_prep_dma_memcpy = sh_dmae_prep_memcpy;
 >> >> +     shdev->common.device_is_tx_complete = sh_dmae_is_complete;
 >> >> +     shdev->common.device_issue_pending = sh_dmae_memcpy_issue_pending;
 >> >> +     shdev->common.dev = &pdev->dev;
 > >
 > > shdev->dev seems redundant as you already keep the device in shdev->common.dev.
 > >
 >> >> +     for (ecnt = 0 ; ecnt < ARRAY_SIZE(eirq); ecnt++) {
 >> >> +             err = request_irq(eirq[ecnt], sh_dmae_err,
 >> >> +                     irqflags, "DMAC Address Error", shdev);
 >> >> +             if (err) {
 >> >> +                     dev_err(&pdev->dev, "DMA device request_irq"
 >> >> +                             "erro (irq %d) with return %d\n",
 >> >> +                             eirq[ecnt], err);
 >> >> +                     goto eirq_err;
 >> >> +             }
 >> >> +     }
 > >
 > > Don't you need to keep it in
 > > #if defined(CONFIG_CPU_SH4)
 > > as sh_dmae_err definition is?

Your indication is right.
I fix this.

I fix your point, I resend.

Best regards,
  Nobuhiro

-- Nobuhiro Iwamatsu
