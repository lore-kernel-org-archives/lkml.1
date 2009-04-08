Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbZDHP06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbZDHP06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbZDHP0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:26:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765260AbZDHP0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:26:17 -0400
Date: Wed, 8 Apr 2009 15:25:29 GMT
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       galak@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <1239199761-22886-7-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-7-git-send-email-galak@kernel.crashing.org>
Subject: [tip:core/iommu] swiotlb: use swiotlb_sync_single instead of duplicating code
Message-ID: <tip-380d687833aee098c4a2c3b35beaefe1c1f48d01@git.kernel.org>
Git-Commit-ID: 380d687833aee098c4a2c3b35beaefe1c1f48d01
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:25:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  380d687833aee098c4a2c3b35beaefe1c1f48d01
Gitweb:     http://git.kernel.org/tip/380d687833aee098c4a2c3b35beaefe1c1f48d01
Author:     Becky Bruce <beckyb@kernel.crashing.org>
AuthorDate: Wed, 8 Apr 2009 09:09:20 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 16:18:37 +0200

swiotlb: use swiotlb_sync_single instead of duplicating code

Right now both swiotlb_sync_single_range and swiotlb_sync_sg
were duplicating the code in swiotlb_sync_single.  Just call it
instead.  Also rearrange the sync_single code for readability.

Note that the swiotlb_sync_sg code was previously doing
a complicated comparison to determine if an addresses needed
to be unmapped where a simple is_swiotlb_buffer() call
would have sufficed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: jeremy@goop.org
Cc: ian.campbell@citrix.com
LKML-Reference: <1239199761-22886-7-git-send-email-galak@kernel.crashing.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/swiotlb.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 2bde54a..d912f06 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -731,10 +731,16 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
+
+	if (is_swiotlb_buffer(dma_addr)) {
 		sync_single(hwdev, dma_addr, size, dir, target);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(dma_addr, size);
 }
 
 void
@@ -761,13 +767,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
-
-	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
-		sync_single(hwdev, dma_addr, size, dir, target);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
 
 void
@@ -890,15 +890,9 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	struct scatterlist *sg;
 	int i;
 
-	BUG_ON(dir == DMA_NONE);
-
-	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
+	for_each_sg(sgl, sg, nelems, i)
+		swiotlb_sync_single(hwdev, sg->dma_address,
 				    sg->dma_length, dir, target);
-		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
-	}
 }
 
 void
