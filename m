Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYKUQ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYKUQ6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYKUQ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:58:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34113 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860AbYKUQ6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:58:17 -0500
Subject: [PATCH 2/2] intel-iommu: trivially inline DMA PTE macros
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, x86@kernel.org
In-Reply-To: <1227286486.3693.103.camel@blaa>
References: <1227191861.4901.24.camel@macbook.infradead.org>
	 <1227196190-488-1-git-send-email-markmc@redhat.com>
	 <1227196190-488-2-git-send-email-markmc@redhat.com>
	 <1227196190-488-3-git-send-email-markmc@redhat.com>
	 <20081120191135.GB3955@elte.hu>  <1227286258.3693.101.camel@blaa>
	 <1227286486.3693.103.camel@blaa>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 16:56:53 +0000
Message-Id: <1227286613.3693.105.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c |   71 ++++++++++++++++++++++++++++++--------------
 1 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 884291b..b9cf713 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -164,16 +164,41 @@ static inline void context_clear_entry(struct context_entry *context)
 struct dma_pte {
 	u64 val;
 };
-#define dma_clear_pte(p)	do {(p).val = 0;} while (0)
 
-#define dma_set_pte_readable(p) do {(p).val |= DMA_PTE_READ;} while (0)
-#define dma_set_pte_writable(p) do {(p).val |= DMA_PTE_WRITE;} while (0)
-#define dma_set_pte_prot(p, prot) \
-		do {(p).val = ((p).val & ~3) | ((prot) & 3); } while (0)
-#define dma_pte_addr(p) ((p).val & VTD_PAGE_MASK)
-#define dma_set_pte_addr(p, addr) do {\
-		(p).val |= ((addr) & VTD_PAGE_MASK); } while (0)
-#define dma_pte_present(p) (((p).val & 3) != 0)
+static inline void dma_clear_pte(struct dma_pte *pte)
+{
+	pte->val = 0;
+}
+
+static inline void dma_set_pte_readable(struct dma_pte *pte)
+{
+	pte->val |= DMA_PTE_READ;
+}
+
+static inline void dma_set_pte_writable(struct dma_pte *pte)
+{
+	pte->val |= DMA_PTE_WRITE;
+}
+
+static inline void dma_set_pte_prot(struct dma_pte *pte, unsigned long prot)
+{
+	pte->val = (pte->val & ~3) | (prot & 3);
+}
+
+static inline u64 dma_pte_addr(struct dma_pte *pte)
+{
+	return (pte->val & VTD_PAGE_MASK);
+}
+
+static inline void dma_set_pte_addr(struct dma_pte *pte, u64 addr)
+{
+	pte->val |= (addr & VTD_PAGE_MASK);
+}
+
+static inline bool dma_pte_present(struct dma_pte *pte)
+{
+	return (pte->val & 3) != 0;
+}
 
 struct dmar_domain {
 	int	id;			/* domain id */
@@ -487,7 +512,7 @@ static struct dma_pte * addr_to_dma_pte(struct dmar_domain *domain, u64 addr)
 		if (level == 1)
 			break;
 
-		if (!dma_pte_present(*pte)) {
+		if (!dma_pte_present(pte)) {
 			tmp_page = alloc_pgtable_page();
 
 			if (!tmp_page) {
@@ -497,16 +522,16 @@ static struct dma_pte * addr_to_dma_pte(struct dmar_domain *domain, u64 addr)
 			}
 			__iommu_flush_cache(domain->iommu, tmp_page,
 					PAGE_SIZE);
-			dma_set_pte_addr(*pte, virt_to_phys(tmp_page));
+			dma_set_pte_addr(pte, virt_to_phys(tmp_page));
 			/*
 			 * high level table always sets r/w, last level page
 			 * table control read/write
 			 */
-			dma_set_pte_readable(*pte);
-			dma_set_pte_writable(*pte);
+			dma_set_pte_readable(pte);
+			dma_set_pte_writable(pte);
 			__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
 		}
-		parent = phys_to_virt(dma_pte_addr(*pte));
+		parent = phys_to_virt(dma_pte_addr(pte));
 		level--;
 	}
 
@@ -529,9 +554,9 @@ static struct dma_pte *dma_addr_level_pte(struct dmar_domain *domain, u64 addr,
 		if (level == total)
 			return pte;
 
-		if (!dma_pte_present(*pte))
+		if (!dma_pte_present(pte))
 			break;
-		parent = phys_to_virt(dma_pte_addr(*pte));
+		parent = phys_to_virt(dma_pte_addr(pte));
 		total--;
 	}
 	return NULL;
@@ -546,7 +571,7 @@ static void dma_pte_clear_one(struct dmar_domain *domain, u64 addr)
 	pte = dma_addr_level_pte(domain, addr, 1);
 
 	if (pte) {
-		dma_clear_pte(*pte);
+		dma_clear_pte(pte);
 		__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
 	}
 }
@@ -593,8 +618,8 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
 			pte = dma_addr_level_pte(domain, tmp, level);
 			if (pte) {
 				free_pgtable_page(
-					phys_to_virt(dma_pte_addr(*pte)));
-				dma_clear_pte(*pte);
+					phys_to_virt(dma_pte_addr(pte)));
+				dma_clear_pte(pte);
 				__iommu_flush_cache(domain->iommu,
 						pte, sizeof(*pte));
 			}
@@ -1421,9 +1446,9 @@ domain_page_mapping(struct dmar_domain *domain, dma_addr_t iova,
 		/* We don't need lock here, nobody else
 		 * touches the iova range
 		 */
-		BUG_ON(dma_pte_addr(*pte));
-		dma_set_pte_addr(*pte, start_pfn << VTD_PAGE_SHIFT);
-		dma_set_pte_prot(*pte, prot);
+		BUG_ON(dma_pte_addr(pte));
+		dma_set_pte_addr(pte, start_pfn << VTD_PAGE_SHIFT);
+		dma_set_pte_prot(pte, prot);
 		__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
 		start_pfn++;
 		index++;
@@ -2582,7 +2607,7 @@ u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova)
 	pte = addr_to_dma_pte(domain, iova);
 
 	if (pte)
-		pfn = dma_pte_addr(*pte);
+		pfn = dma_pte_addr(pte);
 
 	return pfn >> VTD_PAGE_SHIFT;
 }
-- 
1.6.0.3

