Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbYLVHSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbYLVHSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYLVHSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:18:03 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:27744 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYLVHSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:18:01 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [Patch 2/3] via-sdmmc: via-sdmmc.c
Date: Mon, 22 Dec 2008 15:17:56 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8085A6ED6@exchtp03.taipei.via.com.tw>
In-Reply-To: <200812181349.55601.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 2/3] via-sdmmc: via-sdmmc.c
Thread-Index: AclhDz2atBic/CX1S42EU9UJmVJXAwC9Am+Q
From: <JosephChan@via.com.tw>
To: <arnd@arndb.de>, <ben-linux@fluff.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Dec 2008 07:17:57.0980 (UTC) FILETIME=[6A6B49C0:01C96405]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBM7IMki014576

> On Wednesday 17 December 2008, JosephChan@via.com.tw wrote:
> 
> > > struct pcictrlreg __iomem *pcr =
> > > vcrdr_chip->pcictrl_mmiobase; pm_pcictrl_reg->pcisdclk_reg = 
> > > readb(&pcr->pcisdclk_reg);
> > > 
> > > Of course, your code is doing the same things effectively and 
> > > entirely ok here.
> > 
> > We'll modify the code according to your suggestions..
> 
> Ben Dooks didn't like that suggestion, and I don't care that 
> much, so you may want to leave this one alone.

OK, I see that. 

>  
> > We'll try to modify the code like below, but need more tests.
> > 
> > In via_sdc_preparedata() function:
> > 
> >     int sg_cnt;
> > 
> >     sg_cnt = dma_map_sg(mmc_dev(host->mmc), data->sg, 
> data->sg_len, (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE 
> : DMA_TO_DEVICE);
> >     WARN_ON(sg_cnt != 1);
> 
> AFAICT, it would be perfectly fine for sg_cnt to be larger 
> than 1, just not smaller. I don't understand yet how your 
> hardware would deal with this though.
> 
> >     via_set_ddma(host->chip, sg_dma_address(data->sg), 
> > sg_dma_len(data->sg), (data->flags & MMC_DATA_READ) ? 
> DMA_FROM_DEVICE 
> > : DMA_TO_DEVICE );
> 
> Ideally, the via_set_ddma function would be able to program 
> the scatterlist into the hardware registers directly. If this 
> doesn't work, you may be able to look over all elements in 
> the list manually. If this doesn't work either, you will have 
> to go back to your original code, and replace the 
> virt_to_phys conversion with dma_map_single()/dma_unmap_single().

We've checked the mmc_core as follows, that's way we thought in that way before.
        brq.data.sg = mq->sg;
        brq.data.sg_len = mmc_queue_map_sg(mq);

        mmc_queue_bounce_pre(mq);

        if (brq.data.blocks !=
            (req->nr_sectors >> (md->block_bits - 9))) {
            data_size = brq.data.blocks * brq.data.blksz;
            for (sg_pos = 0; sg_pos < brq.data.sg_len; sg_pos++) {
                data_size -= mq->sg[sg_pos].length;
                if (data_size <= 0) {
                    mq->sg[sg_pos].length += data_size;
                    sg_pos++;
                    break;
                }
            }
            brq.data.sg_len = sg_pos;
        }

       mmc_wait_for_req(card->host, &brq.mrq);
       mmc_queue_bounce_post(mq);

Also, we are trying to use the dma_map_single()/dma_unmap_single() functions. We think it's easiler to implement.


> > > What are your criteria for deciding which events to handle in 
> > > interrupt context or in tasklet context? Are some of them 
> extremely 
> > > performance critical?
> > 
> > The criteria are: 
> > 1. Because the SD card detect operations need delay about 1 
> ms, so it should not be implemented in interrupt context. So 
> we implement it by via_sdc_tasklet_card.
> 
> I would argue that 1ms is too long for tasklet (softirq) 
> context as well, and this should better be moved to a work queue.
> 
> > 2. The STSTATUS_REG register must be reset quickly, so it 
> should be implemented in interrupt context.
> > 3. In order to finish one â€œrequestâ€ from the mmc_block 
> layer quickly, all operations (that can finished quickly) 
> before the end of the â€œrequestâ€ should be implemented in 
> interrupt context.
> 
> It's still hard to tell what 'quickly' means here. There is a 
> latency for entering work queues or tasklets, but if the 
> system is idle, that should not be noticable. OTOH, if the 
> system is busy, it may be worthwhile doing something more 
> important before working on the MMC workqueue.
> 
> It's probably something you should measure. If you don't find 
> a significant slowdown by moving to a work queue 
> implementation, I would recommend doing that in order to 
> simplify the driver.
> 

We're checking and hope to provide a significant way for this in next patch.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
