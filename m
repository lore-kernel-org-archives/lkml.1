Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbYCGJ0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbYCGJ0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763649AbYCGJNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:43 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:63359 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbYCGJNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:38 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071013.837692778@firstfloor.org>
In-Reply-To: <200803071013.837692778@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/7] Allow swiotlb to move block data bouncing to the block layer
Message-Id: <20080307091328.138F61B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:13:28 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:57.0783 (UTC) FILETIME=[98A68870:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The block layer is generally in a better position to bounce
than swiotlb because it is allowed to sleep at
the right places. swiotlb cannot do that and is thus more prone
to panic and failing on overflow.

With the mask allocator pool block layer bouncing and swiotlb
allocate from the same pool, so it's quite possible to shift
some of the bounce burden to the block layer.

This patch adds a new variable to set the bounce threshold
for 64bit hosts and sets it to zero for swiotlb. This has
the effect to always doing the data bounces in the block layer 
for swiotlb, assuming the block driver set the correct
bounce pfn. If it forgets that only sets its dma mask
swiotlb will still take the burden.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/pci-swiotlb_64.c |    3 +++
 block/blk-settings.c             |    4 +++-
 include/linux/blkdev.h           |    2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

Index: linux/block/blk-settings.c
===================================================================
--- linux.orig/block/blk-settings.c
+++ linux/block/blk-settings.c
@@ -16,6 +16,8 @@ EXPORT_SYMBOL(blk_max_low_pfn);
 unsigned long blk_max_pfn;
 EXPORT_SYMBOL(blk_max_pfn);
 
+unsigned long blk_min_iommu = 0xffffffff;
+
 /**
  * blk_queue_prep_rq - set a prepare_request function for queue
  * @q:		queue
@@ -139,7 +141,7 @@ void blk_queue_bounce_limit(struct reque
 	/* Assume anything <= 4GB can be handled by IOMMU.
 	   Actually some IOMMUs can handle everything, but I don't
 	   know of a way to test this here. */
-	if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
+	if (b_pfn <= (min_t(u64, blk_min_iommu, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
 	q->bounce_pfn = max_low_pfn;
 #else
Index: linux/arch/x86/kernel/pci-swiotlb_64.c
===================================================================
--- linux.orig/arch/x86/kernel/pci-swiotlb_64.c
+++ linux/arch/x86/kernel/pci-swiotlb_64.c
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/bootmem.h>
 #include <linux/hardirq.h>
+#include <linux/blkdev.h>
 
 #include <asm/gart.h>
 #include <asm/swiotlb.h>
@@ -411,6 +412,8 @@ void __init pci_swiotlb_init(void)
 
 		dma_ops = &dmatlb_dma_ops;
 	}
+
+	blk_min_iommu = BLK_BOUNCE_HIGH;
 }
 
 #define COMPAT_IO_TLB_SHIFT 11
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h
+++ linux/include/linux/blkdev.h
@@ -523,7 +523,7 @@ static inline void blk_clear_queue_full(
 #define BLKPREP_KILL		1	/* fatal error, kill */
 #define BLKPREP_DEFER		2	/* leave on queue */
 
-extern unsigned long blk_max_low_pfn, blk_max_pfn;
+extern unsigned long blk_max_low_pfn, blk_max_pfn, blk_min_iommu;
 
 /*
  * standard bounce addresses:
