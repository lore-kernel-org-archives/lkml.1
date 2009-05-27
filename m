Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZE0BYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZE0BYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZE0BYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:24:36 -0400
Received: from sh.osrg.net ([192.16.179.4]:52959 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZE0BYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:24:35 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip 2/3] dma-debug: use sg_dma_len accessor
Date: Wed, 27 May 2009 09:43:02 +0900
Message-Id: <1243384983-3863-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 May 2009 10:24:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debug_dma_map_sg() and debug_dma_unmap_sg() use length in struct
scatterlist while debug_dma_sync_sg_for_cpu() and
debug_dma_sync_sg_for_device() use dma_length. This causes bugs
warnings on some IOMMU implementations since these values are not
same; the length doesn't represent the dma length.

We always need to use sg_dma_len() accessor to get the dma length of a
scatterlist entry.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/dma-debug.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 64aaa96..df9e475 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -783,7 +783,7 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->type           = dma_debug_sg;
 		entry->dev            = dev;
 		entry->paddr          = sg_phys(s);
-		entry->size           = s->length;
+		entry->size           = sg_dma_len(s);
 		entry->dev_addr       = sg_dma_address(s);
 		entry->direction      = direction;
 		entry->sg_call_ents   = nents;
@@ -791,7 +791,7 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 
 		if (!PageHighMem(sg_page(s))) {
 			check_for_stack(dev, sg_virt(s));
-			check_for_illegal_area(dev, sg_virt(s), s->length);
+			check_for_illegal_area(dev, sg_virt(s), sg_dma_len(s));
 		}
 
 		add_dma_entry(entry);
@@ -817,7 +817,7 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			.dev            = dev,
 			.paddr          = sg_phys(s),
 			.dev_addr       = sg_dma_address(s),
-			.size           = s->length,
+			.size           = sg_dma_len(s),
 			.direction      = dir,
 			.sg_call_ents   = 0,
 		};
@@ -940,7 +940,7 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
-		check_sync(dev, sg_dma_address(s), s->dma_length, 0,
+		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
 			   direction, true);
 	}
 }
@@ -956,7 +956,7 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
-		check_sync(dev, sg_dma_address(s), s->dma_length, 0,
+		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
 			   direction, false);
 	}
 }
-- 
1.6.0.6

