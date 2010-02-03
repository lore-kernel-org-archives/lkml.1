Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab0BCXBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:01:44 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:52590 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0BCXBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:01:43 -0500
MIME-Version: 1.0
In-Reply-To: <4B6762CE.1050001@cs.ucr.edu>
References: <4B6762CE.1050001@cs.ucr.edu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Feb 2010 16:01:22 -0700
X-Google-Sender-Auth: 316da51fc20f9946
Message-ID: <fa686aa41002031501q14e8ab54s6713edc58d0fddc1@mail.gmail.com>
Subject: Re: PATCH: Add non-Virtex 5 support for LL TEMAC driver
To: John Tyner <jtyner@cs.ucr.edu>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 4:25 PM, John Tyner <jtyner@cs.ucr.edu> wrote:
> This patch adds support for using the LL TEMAC Ethernet driver on non-Virtex
> 5 platforms by adding support for accessing the Soft DMA registers as if
> they were memory mapped instead of solely through the DCR's (available on
> the Virtex 5).
>
> Signed-off-by: John Tyner <jtyner@cs.ucr.edu>

Hi John, thanks for doing this work.  A couple of comments below.

>
> --- /tmp/tmp.5198.41	2010-02-01 15:04:45.000000000 -0800
> +++ ./linux-2.6.32.3/drivers/net/ll_temac.h	2010-01-28 15:06:17.000000000 -0800
> @@ -338,6 +338,7 @@
>  	/* IO registers and IRQs */
>  	void __iomem *regs;
>  	dcr_host_t sdma_dcrs;
> +	u32 __iomem *sdma_regs;
>  	int tx_irq;
>  	int rx_irq;
>  	int emac_num;
> --- /tmp/tmp.5198.53	2010-02-01 15:04:45.000000000 -0800
> +++ ./linux-2.6.32.3/drivers/net/ll_temac_main.c	2010-02-01 15:04:01.000000000 -0800
> @@ -20,9 +20,6 @@
>   *   or rx, so this should be okay.
>   *
>   * TODO:
> - * - Fix driver to work on more than just Virtex5.  Right now the driver
> - *   assumes that the locallink DMA registers are accessed via DCR
> - *   instructions.
>   * - Factor out locallink DMA code into separate driver
>   * - Fix multicast assignment.
>   * - Fix support for hardware checksumming.
> @@ -117,12 +114,20 @@
>
>  static u32 temac_dma_in32(struct temac_local *lp, int reg)
>  {
> -	return dcr_read(lp->sdma_dcrs, reg);
> +	if (lp->sdma_regs) {
> +		return __raw_readl(lp->sdma_regs + reg);
> +	} else {
> +		return dcr_read(lp->sdma_dcrs, reg);
> +	}

Rather than taking the ugliness an if/else block on every register
access, why not create an ops structure and populate it with the
correct access routines at runtime?

>  }
>
>  static void temac_dma_out32(struct temac_local *lp, int reg, u32 value)
>  {
> -	dcr_write(lp->sdma_dcrs, reg, value);
> +	if (lp->sdma_regs) {
> +		__raw_writel(value, lp->sdma_regs + reg);
> +	} else {
> +		dcr_write(lp->sdma_dcrs, reg, value);
> +	}
>  }
>
>  /**
> @@ -862,13 +867,17 @@
>  		goto nodev;
>  	}
>
> -	dcrs = dcr_resource_start(np, 0);
> -	if (dcrs == 0) {
> -		dev_err(&op->dev, "could not get DMA register address\n");
> +	lp->sdma_regs = NULL;
> +
> +	if ((dcrs = dcr_resource_start(np, 0)) != 0) {
> +		lp->sdma_dcrs = dcr_map(np, dcrs, dcr_resource_len(np, 0));
> +		dev_dbg(&op->dev, "DCR base: %x\n", dcrs);
> +	} else if ((lp->sdma_regs = of_iomap(np, 0))) {
> +		dev_dbg(&op->dev, "MEM base: %p\n", lp->sdma_regs);
> +	} else {
> +		dev_err(&op->dev, "unable to map DMA registers\n");
>  		goto nodev;
>  	}
> -	lp->sdma_dcrs = dcr_map(np, dcrs, dcr_resource_len(np, 0));
> -	dev_dbg(&op->dev, "DCR base: %x\n", dcrs);
>
>  	lp->rx_irq = irq_of_parse_and_map(np, 0);
>  	lp->tx_irq = irq_of_parse_and_map(np, 1);
> @@ -895,7 +904,7 @@
>
>  	lp->phy_node = of_parse_phandle(op->node, "phy-handle", 0);
>  	if (lp->phy_node)
> -		dev_dbg(lp->dev, "using PHY node %s (%p)\n", np->full_name, np);
> +		dev_dbg(lp->dev, "using PHY node %s (%p)\n", lp->phy_node->full_name, lp->phy_node);

This looks like an unrelated bug fix.  Please put into a separate
patch and post separately.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
