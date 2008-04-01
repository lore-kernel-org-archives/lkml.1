Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYDAKxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYDAKxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 06:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbYDAKxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 06:53:34 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44150
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYDAKxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 06:53:33 -0400
Date: Tue, 1 Apr 2008 12:53:31 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@osdl.org>, Yang Shi <yang.shi@windriver.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: regression breaks lowmem reserved RAM
Message-ID: <20080401105331.GH12427@duo.random>
References: <20080328194909.GA10617@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328194909.GA10617@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking a bit closer into this regression the reason this can't be
right is that dma_addr common default is BLK_BOUNCE_HIGH and most
machines have less than 4G. So if you do:

    if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
	dma = 1

that will translate to:

     if (BLK_BOUNCE_HIGH <= BLK_BOUNCE_HIGH)
     	dma = 1

So for 99% of hardware this will trigger unnecessary GFP_DMA
allocations and isa pooling operations.

Also note how the 32bit code still does b_pfn < blk_max_low_pfn.

I guess this is what you were looking after. I didn't verify but as
far as I can tell, this will stop the regression with isa dma
operations at boot for 99% of blkdev/memory combinations out there and
I guess this fixes the setups with >4G of ram and 32bit pci cards as
well (this also retains symmetry with the 32bit code).

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 1344a0e..5713f7e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -140,7 +140,7 @@ void blk_queue_bounce_limit(struct request_queue *q, u64 dma_addr)
 	/* Assume anything <= 4GB can be handled by IOMMU.
 	   Actually some IOMMUs can handle everything, but I don't
 	   know of a way to test this here. */
-	if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
+	if (b_pfn < (min_t(u64, 0x100000000UL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
 	q->bounce_pfn = max_low_pfn;
 #else
