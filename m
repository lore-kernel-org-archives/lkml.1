Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbZE0BZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbZE0BZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbZE0BYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:24:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:52963 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbZE0BYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:24:36 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip 1/3] dma-debug: use sg_dma_address accessor instead of using dma_address directly
Date: Wed, 27 May 2009 09:43:01 +0900
Message-Id: <1243384983-3863-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 May 2009 10:24:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures might not have dma_address in struct scatterlist (PARISC
doesn't). Directly accessing to dma_address in struct scatterlist is
wrong; we need to use sg_dma_address() accesssor instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/dma-debug.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index cdd205d..64aaa96 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -784,7 +784,7 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->dev            = dev;
 		entry->paddr          = sg_phys(s);
 		entry->size           = s->length;
-		entry->dev_addr       = s->dma_address;
+		entry->dev_addr       = sg_dma_address(s);
 		entry->direction      = direction;
 		entry->sg_call_ents   = nents;
 		entry->sg_mapped_ents = mapped_ents;
@@ -816,7 +816,7 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			.type           = dma_debug_sg,
 			.dev            = dev,
 			.paddr          = sg_phys(s),
-			.dev_addr       = s->dma_address,
+			.dev_addr       = sg_dma_address(s),
 			.size           = s->length,
 			.direction      = dir,
 			.sg_call_ents   = 0,
@@ -940,8 +940,8 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
-		check_sync(dev, s->dma_address, s->dma_length, 0,
-				direction, true);
+		check_sync(dev, sg_dma_address(s), s->dma_length, 0,
+			   direction, true);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_cpu);
@@ -956,8 +956,8 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
-		check_sync(dev, s->dma_address, s->dma_length, 0,
-				direction, false);
+		check_sync(dev, sg_dma_address(s), s->dma_length, 0,
+			   direction, false);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
-- 
1.6.0.6

