Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751824AbYLRMu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbYLRMu5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLRMue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:50:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYLRMud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:50:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: JosephChan@via.com.tw, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [Patch 2/3] via-sdmmc: via-sdmmc.c
Date: Thu, 18 Dec 2008 13:49:55 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808521780@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB808521780@exchtp03.taipei.via.com.tw>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812181349.55601.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18m+gVK311cX2CKosxU0idolQjc1wgmazbjkAX
 RFY4iixgzcL+kz9hR0KLmIlwdpLf9VCK7kcdwQo8/2wgWNGAW3
 6R4ET+yOEJtOUCWpSgQEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2008, JosephChan@via.com.tw wrote:

> > struct pcictrlreg __iomem *pcr = 
> > vcrdr_chip->pcictrl_mmiobase; pm_pcictrl_reg->pcisdclk_reg = 
> > readb(&pcr->pcisdclk_reg);
> > 
> > Of course, your code is doing the same things effectively and 
> > entirely ok here.
> 
> We'll modify the code according to your suggestions..

Ben Dooks didn't like that suggestion, and I don't care that
much, so you may want to leave this one alone.
 
> We'll try to modify the code like below, but need more tests.
> 
> In via_sdc_preparedata() function:
> 
>     int sg_cnt;
> 
>     sg_cnt = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
>     WARN_ON(sg_cnt != 1);

AFAICT, it would be perfectly fine for sg_cnt to be larger than 1,
just not smaller. I don't understand yet how your hardware would
deal with this though.

>     via_set_ddma(host->chip, sg_dma_address(data->sg), sg_dma_len(data->sg), (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE );

Ideally, the via_set_ddma function would be able to program the scatterlist
into the hardware registers directly. If this doesn't work, you may
be able to look over all elements in the list manually. If this doesn't
work either, you will have to go back to your original code, and replace
the virt_to_phys conversion with dma_map_single()/dma_unmap_single().

> > What are your criteria for deciding which events to handle in 
> > interrupt context or in tasklet context? Are some of them 
> > extremely performance critical?
> 
> The criteria are: 
> 1. Because the SD card detect operations need delay about 1 ms, so it should not be implemented in interrupt context. So we implement it by via_sdc_tasklet_card.

I would argue that 1ms is too long for tasklet (softirq) context as well,
and this should better be moved to a work queue.

> 2. The STSTATUS_REG register must be reset quickly, so it should be implemented in interrupt context.
> 3. In order to finish one “request” from the mmc_block layer quickly, all operations (that can finished quickly) before the end of the “request” should be implemented in interrupt context.

It's still hard to tell what 'quickly' means here. There is a latency for
entering work queues or tasklets, but if the system is idle, that should
not be noticable. OTOH, if the system is busy, it may be worthwhile doing
something more important before working on the MMC workqueue.

It's probably something you should measure. If you don't find a significant
slowdown by moving to a work queue implementation, I would recommend doing
that in order to simplify the driver.

	Arnd <><
