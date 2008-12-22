Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYLVSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYLVSar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYLVS24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:56 -0500
Received: from gw.goop.org ([64.81.55.164]:44726 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751784AbYLVS2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:54 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 9] swiotlb: Drop SG_ENT_VIRT_ADDRESS macro
X-Mercurial-Node: ef67a6ee4b9de9c721a4120c9283c18af985c493
Message-Id: <ef67a6ee4b9de9c721a4.1229970366@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

All SG_ENT_VIRT_ADDRESS does is call sg_virt(), get rid of
this needless layer of complexity.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -38,8 +38,7 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
-#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
+#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(sg_virt(sg))
 
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
@@ -768,9 +767,9 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		addr = SG_ENT_VIRT_ADDRESS(sg);
+		addr = sg_virt(sg);
 		dev_addr = swiotlb_virt_to_bus(hwdev, addr);
-		if (range_needs_mapping(sg_virt(sg), sg->length) ||
+		if (range_needs_mapping(addr, sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
 			if (!map) {
@@ -816,7 +815,7 @@
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(sg_virt(sg), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -849,7 +848,7 @@
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(sg_virt(sg), sg->dma_length);
 	}
 }
 


