Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZEVMWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZEVMWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZEVMVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:21:54 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:6084 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757485AbZEVMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:21:53 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KK1OZX-04-A1R-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/12] amd-iommu: change dma_dom->next_bit to dma_dom->next_address
Date: Fri, 22 May 2009 14:21:26 +0200
Message-ID: <1242994893-28902-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0048 (UTC) FILETIME=[D7D25780:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: code simplification ]

Simplify the code a little bit by using the same unit for all address
space related state in the dma_ops domain structure.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |   17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index eca9129..4ff4cf1 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -249,7 +249,7 @@ struct dma_ops_domain {
 	unsigned long aperture_size;
 
 	/* address we start to search for free addresses */
-	unsigned long next_bit;
+	unsigned long next_address;
 
 	/* address space relevant data */
 	struct aperture_range *aperture[APERTURE_MAX_RANGES];
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 794163a..c1a08b9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -627,13 +627,15 @@ static unsigned long dma_ops_area_alloc(struct device *dev,
 					u64 dma_mask,
 					unsigned long start)
 {
-	unsigned long next_bit = dom->next_bit % APERTURE_RANGE_PAGES;
+	unsigned long next_bit = dom->next_address % APERTURE_RANGE_SIZE;
 	int max_index = dom->aperture_size >> APERTURE_RANGE_SHIFT;
 	int i = start >> APERTURE_RANGE_SHIFT;
 	unsigned long boundary_size;
 	unsigned long address = -1;
 	unsigned long limit;
 
+	next_bit >>= PAGE_SHIFT;
+
 	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
 			PAGE_SIZE) >> PAGE_SHIFT;
 
@@ -652,7 +654,7 @@ static unsigned long dma_ops_area_alloc(struct device *dev,
 		if (address != -1) {
 			address = dom->aperture[i]->offset +
 				  (address << PAGE_SHIFT);
-			dom->next_bit = (address >> PAGE_SHIFT) + pages;
+			dom->next_address = address + (pages << PAGE_SHIFT);
 			break;
 		}
 
@@ -669,14 +671,12 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 					     u64 dma_mask)
 {
 	unsigned long address;
-	unsigned long start = dom->next_bit << PAGE_SHIFT;
-
 
 	address = dma_ops_area_alloc(dev, dom, pages, align_mask,
-				     dma_mask, start);
+				     dma_mask, dom->next_address);
 
 	if (address == -1) {
-		dom->next_bit = 0;
+		dom->next_address = 0;
 		address = dma_ops_area_alloc(dev, dom, pages, align_mask,
 					     dma_mask, 0);
 		dom->need_flush = true;
@@ -704,10 +704,11 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 
 	BUG_ON(i >= APERTURE_MAX_RANGES || range == NULL);
 
-	if ((address >> PAGE_SHIFT) >= dom->next_bit)
+	if (address >= dom->next_address)
 		dom->need_flush = true;
 
 	address = (address % APERTURE_RANGE_SIZE) >> PAGE_SHIFT;
+
 	iommu_area_free(range->bitmap, address, pages);
 
 }
@@ -870,7 +871,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	 * a valid dma-address. So we can use 0 as error value
 	 */
 	dma_dom->aperture[0]->bitmap[0] = 1;
-	dma_dom->next_bit = 0;
+	dma_dom->next_address = 0;
 
 	dma_dom->need_flush = false;
 	dma_dom->target_dev = 0xffff;
-- 
1.6.3.1


