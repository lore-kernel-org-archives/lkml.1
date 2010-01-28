Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192Ab0A1Lkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0A1Lkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818Ab0A1Lku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:40:50 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:37076
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754786Ab0A1Lie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:34 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zzab9bh936eMzz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBZ-01-FXV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/11] x86/amd-iommu: Make iommu_unmap_page and fetch_pte aware of page sizes
Date: Thu, 28 Jan 2010 12:37:59 +0100
Message-ID: <1264678682-30655-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0961 (UTC) FILETIME=[64808110:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the functionality of iommu_unmap_page
and fetch_pte to support arbitrary page sizes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    6 ++
 arch/x86/kernel/amd_iommu.c            |   90 +++++++++++++++++++++++++------
 2 files changed, 78 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 5e8da56..b150c74 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -200,6 +200,12 @@
 		(((address) | ((pagesize) - 1)) &	\
 		 (~(pagesize >> 1)) & PM_ADDR_MASK)
 
+/*
+ * Takes a PTE value with mode=0x07 and returns the page size it maps
+ */
+#define PTE_PAGE_SIZE(pte) \
+	(1ULL << (1 + ffz(((pte) | 0xfffULL))))
+
 #define IOMMU_PTE_P  (1ULL << 0)
 #define IOMMU_PTE_TV (1ULL << 1)
 #define IOMMU_PTE_U  (1ULL << 59)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4170031..503d312 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -776,28 +776,47 @@ static u64 *alloc_pte(struct protection_domain *domain,
  * This function checks if there is a PTE for a given dma address. If
  * there is one, it returns the pointer to it.
  */
-static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address, int map_size)
+static u64 *fetch_pte(struct protection_domain *domain, unsigned long address)
 {
 	int level;
 	u64 *pte;
 
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	if (address > PM_LEVEL_SIZE(domain->mode))
+		return NULL;
+
+	level   =  domain->mode - 1;
+	pte     = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	while (level > map_size) {
+	while (level > 0) {
+
+		/* Not Present */
 		if (!IOMMU_PTE_PRESENT(*pte))
 			return NULL;
 
+		/* Large PTE */
+		if (PM_PTE_LEVEL(*pte) == 0x07) {
+			unsigned long pte_mask, __pte;
+
+			/*
+			 * If we have a series of large PTEs, make
+			 * sure to return a pointer to the first one.
+			 */
+			pte_mask = PTE_PAGE_SIZE(*pte);
+			pte_mask = ~((PAGE_SIZE_PTE_COUNT(pte_mask) << 3) - 1);
+			__pte    = ((unsigned long)pte) & pte_mask;
+
+			return (u64 *)__pte;
+		}
+
+		/* No level skipping support yet */
+		if (PM_PTE_LEVEL(*pte) != level)
+			return NULL;
+
 		level -= 1;
 
+		/* Walk to the next level */
 		pte = IOMMU_PTE_PAGE(*pte);
 		pte = &pte[PM_LEVEL_INDEX(level, address)];
-
-		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
-			pte = NULL;
-			break;
-		}
 	}
 
 	return pte;
@@ -850,13 +869,48 @@ static int iommu_map_page(struct protection_domain *dom,
 	return 0;
 }
 
-static void iommu_unmap_page(struct protection_domain *dom,
-			     unsigned long bus_addr, int map_size)
+static unsigned long iommu_unmap_page(struct protection_domain *dom,
+				      unsigned long bus_addr,
+				      unsigned long page_size)
 {
-	u64 *pte = fetch_pte(dom, bus_addr, map_size);
+	unsigned long long unmap_size, unmapped;
+	u64 *pte;
+
+	BUG_ON(!is_power_of_2(page_size));
+
+	unmapped = 0;
+
+	while (unmapped < page_size) {
+
+		pte = fetch_pte(dom, bus_addr);
+
+		if (!pte) {
+			/*
+			 * No PTE for this address
+			 * move forward in 4kb steps
+			 */
+			unmap_size = PAGE_SIZE;
+		} else if (PM_PTE_LEVEL(*pte) == 0) {
+			/* 4kb PTE found for this address */
+			unmap_size = PAGE_SIZE;
+			*pte       = 0ULL;
+		} else {
+			int count, i;
+
+			/* Large PTE found which maps this address */
+			unmap_size = PTE_PAGE_SIZE(*pte);
+			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
+			for (i = 0; i < count; i++)
+				pte[i] = 0ULL;
+		}
+
+		bus_addr  = (bus_addr & ~(unmap_size - 1)) + unmap_size;
+		unmapped += unmap_size;
+	}
+
+	BUG_ON(!is_power_of_2(unmapped));
 
-	if (pte)
-		*pte = 0;
+	return unmapped;
 }
 
 /*
@@ -1054,7 +1108,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 	for (i = dma_dom->aperture[index]->offset;
 	     i < dma_dom->aperture_size;
 	     i += PAGE_SIZE) {
-		u64 *pte = fetch_pte(&dma_dom->domain, i, PM_MAP_4k);
+		u64 *pte = fetch_pte(&dma_dom->domain, i);
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
@@ -2491,7 +2545,7 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 	iova  &= PAGE_MASK;
 
 	for (i = 0; i < npages; ++i) {
-		iommu_unmap_page(domain, iova, PM_MAP_4k);
+		iommu_unmap_page(domain, iova, PAGE_SIZE);
 		iova  += PAGE_SIZE;
 	}
 
@@ -2506,7 +2560,7 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 	phys_addr_t paddr;
 	u64 *pte;
 
-	pte = fetch_pte(domain, iova, PM_MAP_4k);
+	pte = fetch_pte(domain, iova);
 
 	if (!pte || !IOMMU_PTE_PRESENT(*pte))
 		return 0;
-- 
1.6.6


