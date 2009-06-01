Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZFAPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZFAPeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZFAPdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:33:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54264 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZFAPdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:33:09 -0400
X-IronPort-AV: E=Sophos;i="4.41,284,1241409600"; 
   d="scan'208";a="4484692"
From: Ian Campbell <ian.campbell@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Ian Campbell <ian.campbell@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, <x86@kernel.org>
Subject: [PATCH 04/11] x86: use dma_map_range when allocating PCI DMA memory with no IOMMU
Date: Mon, 1 Jun 2009 16:32:56 +0100
Message-ID: <1243870383-12954-5-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces use of is_buffer_dma_capable which is going away.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org
---
 arch/x86/kernel/pci-nommu.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 71d412a..b6b75a0 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -12,13 +12,15 @@
 #include <asm/dma.h>
 
 static int
-check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
+check_addr(char *name, struct device *hwdev, phys_addr_t phys,
+	   size_t size, dma_addr_t *bus)
 {
-	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
+	if (hwdev &&
+	    !dma_map_range(hwdev, *hwdev->dma_mask, phys, size, bus)) {
 		if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
 			printk(KERN_ERR
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
-				name, (long long)bus, size,
+				name, (long long)phys, size,
 				(long long)*hwdev->dma_mask);
 		return 0;
 	}
@@ -30,9 +32,10 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 				 enum dma_data_direction dir,
 				 struct dma_attrs *attrs)
 {
-	dma_addr_t bus = page_to_phys(page) + offset;
+	phys_addr_t phys = page_to_phys(page) + offset;
+	dma_addr_t bus;
 	WARN_ON(size == 0);
-	if (!check_addr("map_single", dev, bus, size))
+	if (!check_addr("map_single", dev, phys, size, &bus))
 		return bad_dma_address;
 	flush_write_buffers();
 	return bus;
@@ -64,8 +67,8 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 
 	for_each_sg(sg, s, nents, i) {
 		BUG_ON(!sg_page(s));
-		s->dma_address = sg_phys(s);
-		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
+		if (!check_addr("map_sg", hwdev, sg_phys(s), s->length,
+				&s->dma_address))
 			return 0;
 		s->dma_length = s->length;
 	}
-- 
1.5.6.5

