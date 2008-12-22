Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYLVKUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYLVKUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYLVKTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:19:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:49167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYLVKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:19:54 -0500
Message-ID: <494F69C4.2060708@kernel.org>
Date: Mon, 22 Dec 2008 19:19:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_sil: add Large Block Transfer support
References: <4945BDED.7050205@shaw.ca>
In-Reply-To: <4945BDED.7050205@shaw.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Dec 2008 10:19:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert Hancock wrote:
> Obviously not 2.6.28 material, but could potentially head into .29.
> I've done some testing with a DVD drive connected to this controller
> and verified that reading off an entire DVD returns correct data
> (and that the controller is actually getting requests that cross
> 64K boundaries). More testing would certainly be useful..

Ah... nice.  It would be great to have this in -next for some time.

> +static void sil_bmdma_stop(struct ata_queued_cmd *qc)
> +{
> +    struct ata_port *ap = qc->ap;
> +    void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
> +    void __iomem *bmdma2 = mmio_base + sil_port[ap->port_no].bmdma2;
> +
> +    /* clear start/stop bit - can safely always write 0 */
> +    writeb(0, bmdma2);

ioread/iowrite?

> +    /* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
> +    ata_sff_dma_pause(ap);
> +}
> +
> +static void sil_bmdma_setup(struct ata_queued_cmd *qc)
> +{
> +    struct ata_port *ap = qc->ap;
> +    void __iomem *bmdma = ap->ioaddr.bmdma_addr;
> +
> +    /* load PRD table addr. */
> +    mb();    /* make sure PRD table writes are visible to controller */

I know it's not specific to this change but does mb() really make
sense here?  I don't think we need any barrier here.

> +    writel(ap->prd_dma, bmdma + ATA_DMA_TABLE_OFS);
> +
> +    /* issue r/w command */
> +    ap->ops->sff_exec_command(ap, &qc->tf);
> +}

Thanks.

-- 
tejun
