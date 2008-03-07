Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbYCGJYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbYCGJYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763599AbYCGJNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:38 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:48552 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762603AbYCGJNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:33 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071013.837692778@firstfloor.org>
In-Reply-To: <200803071013.837692778@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/7] Remove bounce_gfp
Message-Id: <20080307091327.0EA141B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:13:27 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:56.0767 (UTC) FILETIME=[980B80F0:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert mm/bounce.c to use a mask allocator mempool for ISA DMA 
memory and then remove bounce_gfp. All bouncing is controlled
by bounce_pfn now.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 block/blk-settings.c   |    2 --
 include/linux/blkdev.h |    1 -
 mm/bounce.c            |   16 ++++------------
 3 files changed, 4 insertions(+), 15 deletions(-)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -324,7 +324,6 @@ struct request_queue
 	 * queue needs bounce pages for pages above this limit
 	 */
 	unsigned long		bounce_pfn;
-	gfp_t			bounce_gfp;
 
 	/*
 	 * various queue flags, see QUEUE_* below
Index: linux/block/blk-settings.c
===================================================================
--- linux.orig/block/blk-settings.c
+++ linux/block/blk-settings.c
@@ -135,7 +135,6 @@ void blk_queue_bounce_limit(struct reque
 	unsigned long b_pfn = dma_addr >> PAGE_SHIFT;
 	int dma = 0;
 
-	q->bounce_gfp = GFP_NOIO;
 #if BITS_PER_LONG == 64
 	/* Assume anything <= 4GB can be handled by IOMMU.
 	   Actually some IOMMUs can handle everything, but I don't
@@ -150,7 +149,6 @@ void blk_queue_bounce_limit(struct reque
 #endif
 	if (dma) {
 		init_emergency_isa_pool();
-		q->bounce_gfp = GFP_NOIO | GFP_DMA;
 		q->bounce_pfn = b_pfn;
 	}
 }
Index: linux/mm/bounce.c
===================================================================
--- linux.orig/mm/bounce.c
+++ linux/mm/bounce.c
@@ -63,14 +63,6 @@ static void bounce_copy_vec(struct bio_v
 #endif /* CONFIG_HIGHMEM */
 
 /*
- * allocate pages in the DMA region for the ISA pool
- */
-static void *mempool_alloc_pages_isa(gfp_t gfp_mask, void *data)
-{
-	return mempool_alloc_pages(gfp_mask | GFP_DMA, data);
-}
-
-/*
  * gets called "every" time someone init's a queue with BLK_BOUNCE_ISA
  * as the max address, so check if the pool has already been created.
  */
@@ -79,8 +71,8 @@ int init_emergency_isa_pool(void)
 	if (isa_page_pool)
 		return 0;
 
-	isa_page_pool = mempool_create(ISA_POOL_SIZE, mempool_alloc_pages_isa,
-				       mempool_free_pages, (void *) 0);
+	isa_page_pool = mempool_create_pool_pmask(ISA_POOL_SIZE, PAGE_SIZE,
+					ISA_DMA_THRESHOLD);
 	BUG_ON(!isa_page_pool);
 
 	printk("isa bounce pool size: %d pages\n", ISA_POOL_SIZE);
@@ -200,7 +192,7 @@ static void __blk_queue_bounce(struct re
 
 		to = bio->bi_io_vec + i;
 
-		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
+		to->bv_page = mempool_alloc(pool, GFP_NOIO);
 		to->bv_len = from->bv_len;
 		to->bv_offset = from->bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
@@ -275,7 +267,7 @@ void blk_queue_bounce(struct request_que
 	 * to or bigger than the highest pfn in the system -- in that case,
 	 * don't waste time iterating over bio segments
 	 */
-	if (!(q->bounce_gfp & GFP_DMA)) {
+	if (q->bounce_pfn >= BLK_BOUNCE_ISA) {
 		if (q->bounce_pfn >= blk_max_pfn)
 			return;
 		pool = page_pool;
