Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760122AbYLQJqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYLQJqX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYLQJpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:45:51 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:60262 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbYLQJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:45:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [Patch 2/3] via-sdmmc: via-sdmmc.c
Date: Wed, 17 Dec 2008 17:45:42 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808521780@exchtp03.taipei.via.com.tw>
In-Reply-To: <200812161431.42387.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 2/3] via-sdmmc: via-sdmmc.c
Thread-Index: AclfgqoB3VMvk8TwSAeWra6CzjKLSgApsPLg
From: <JosephChan@via.com.tw>
To: <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Dec 2008 09:45:44.0105 (UTC) FILETIME=[3AF9D990:01C9602C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by imap1.linux-foundation.org id mBH9mOCf027328

Thanks, Arnd.

> > +	pm_pcictrl_reg->pcitmoctrl_reg = readb(addrbase + 
> PCITMOCTRL_REG); }
> 
> Since you already define the data structure for the save 
> area, how about using it for the register accesses as well? 
> You could drop all the PCI*_REG macro definitions and do
> 
> struct pcictrlreg __iomem *pcr = 
> vcrdr_chip->pcictrl_mmiobase; pm_pcictrl_reg->pcisdclk_reg = 
> readb(&pcr->pcisdclk_reg);
> 
> Of course, your code is doing the same things effectively and 
> entirely ok here.

We'll modify the code according to your suggestions..

> > +	}
> > +
> > +	via_set_ddma(host->chip, virt_to_phys(host->ddmabuf), 
> count, dir, 
> > +0);
> 
> You can't use virt_to_phys here, since the physical address 
> might not be the same as the bus address, in case you are 
> using an IOMMU. The correct way to do it would be to drop the 
> memcpy to the internal buffer, and do a
> dma_map_sg() to get the bus address.
> 

We'll try to modify the code like below, but need more tests.

In via_sdc_preparedata() function:

    int sg_cnt;

    sg_cnt = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
    WARN_ON(sg_cnt != 1);
    via_set_ddma(host->chip, sg_dma_address(data->sg), sg_dma_len(data->sg), (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE );

In via_sdc_finish_data() function:

    dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE);



> > +
> > +	sd_status &= ~(SD_STS_CMD_MASK | SD_STS_DATA_MASK);
> > +	if (sd_status) {
> > +		pr_err("%s: Unexpected interrupt 0x%x\n",
> > +		       mmc_hostname(sdhost->mmc), sd_status);
> > +		writew(sd_status, addrbase + SDSTATUS_REG);
> > +	}
> 
> What are your criteria for deciding which events to handle in 
> interrupt context or in tasklet context? Are some of them 
> extremely performance critical?

The criteria are: 
1. Because the SD card detect operations need delay about 1 ms, so it should not be implemented in interrupt context. So we implement it by via_sdc_tasklet_card.
2. The STSTATUS_REG register must be reset quickly, so it should be implemented in interrupt context.
3. In order to finish one â€œrequestâ€ from the mmc_block layer quickly, all operations (that can finished quickly) before the end of the â€œrequestâ€ should be implemented in interrupt context.


> If you can do all of them in a single tasklet function that 
> you simply schedule every time without the spinlock, you 
> don't need to disable interrupts every time you access a 
> register but can instead use spin_lock_bh.
> 
> To go even further, you could use a work queue instead of the 
> tasklet and use a mutex instead of the spinlock.

We will try to optimize the ISR function. 

> > +	writel(0x0, addrbase + SDINTMASK_REG);
> > +	mdelay(1);
> 
> Since this function runs in task context, you should use 
> msleep() here, not mdelay().

OK, we will replae it. Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
