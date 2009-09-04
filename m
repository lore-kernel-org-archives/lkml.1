Return-Path: <linux-kernel-owner+w=401wt.eu-S933526AbZIDJm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbZIDJm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933458AbZIDJmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:24 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:44705 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbZIDJmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:06 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXM0-03-O1P-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/14] x86/amd-iommu: Support higher level PTEs in iommu_page_unmap
Date: Fri, 4 Sep 2009 11:40:51 +0200
Message-ID: <1252057252-32074-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0642 (UTC) FILETIME=[CCDAA3A0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes fetch_pte and iommu_page_unmap to support
different page sizes too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   21 +++++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index d66430d..351ca39 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -158,6 +158,7 @@
 #define PM_LEVEL_ENC(x)		(((x) << 9) & 0xe00ULL)
 #define PM_LEVEL_PDE(x, a)	((a) | PM_LEVEL_ENC((x)) | \
 				 IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
+#define PM_PTE_LEVEL(pte)	(((pte) >> 9) & 0x7ULL)
 
 #define IOMMU_PTE_P  (1ULL << 0)
 #define IOMMU_PTE_TV (1ULL << 1)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index addf658..002cf9c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -62,7 +62,7 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages);
 static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address);
+		      unsigned long address, int map_size);
 static void update_domain(struct protection_domain *domain);
 
 #ifndef BUS_NOTIFY_UNBOUND_DRIVER
@@ -552,9 +552,9 @@ static int iommu_map_page(struct protection_domain *dom,
 }
 
 static void iommu_unmap_page(struct protection_domain *dom,
-			     unsigned long bus_addr)
+			     unsigned long bus_addr, int map_size)
 {
-	u64 *pte = fetch_pte(dom, bus_addr);
+	u64 *pte = fetch_pte(dom, bus_addr, map_size);
 
 	if (pte)
 		*pte = 0;
@@ -668,7 +668,7 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  * there is one, it returns the pointer to it.
  */
 static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address)
+		      unsigned long address, int map_size)
 {
 	int level;
 	u64 *pte;
@@ -676,7 +676,7 @@ static u64 *fetch_pte(struct protection_domain *domain,
 	level =  domain->mode - 1;
 	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	while (level > 0) {
+	while (level > map_size) {
 		if (!IOMMU_PTE_PRESENT(*pte))
 			return NULL;
 
@@ -684,6 +684,11 @@ static u64 *fetch_pte(struct protection_domain *domain,
 
 		pte = IOMMU_PTE_PAGE(*pte);
 		pte = &pte[PM_LEVEL_INDEX(level, address)];
+
+		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
+			pte = NULL;
+			break;
+		}
 	}
 
 	return pte;
@@ -757,7 +762,7 @@ static int alloc_new_range(struct amd_iommu *iommu,
 	for (i = dma_dom->aperture[index]->offset;
 	     i < dma_dom->aperture_size;
 	     i += PAGE_SIZE) {
-		u64 *pte = fetch_pte(&dma_dom->domain, i);
+		u64 *pte = fetch_pte(&dma_dom->domain, i, PM_MAP_4k);
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
@@ -2192,7 +2197,7 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 	iova  &= PAGE_MASK;
 
 	for (i = 0; i < npages; ++i) {
-		iommu_unmap_page(domain, iova);
+		iommu_unmap_page(domain, iova, PM_MAP_4k);
 		iova  += PAGE_SIZE;
 	}
 
@@ -2207,7 +2212,7 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 	phys_addr_t paddr;
 	u64 *pte;
 
-	pte = fetch_pte(domain, iova);
+	pte = fetch_pte(domain, iova, PM_MAP_4k);
 
 	if (!pte || !IOMMU_PTE_PRESENT(*pte))
 		return 0;
-- 
1.6.3.3


