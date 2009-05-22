Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZEVMVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZEVMVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZEVMVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:21:43 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:5562 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751258AbZEVMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:21:42 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KK1OZX-03-97P-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/12] amd-iommu: move page table allocation code to seperate function
Date: Fri, 22 May 2009 14:21:23 +0200
Message-ID: <1242994893-28902-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:32.0720 (UTC) FILETIME=[D7A04B00:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: make page table allocation usable for dma_ops code ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   86 ++++++++++++++++++++++++++++++------------
 1 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 62acd09..ded79f7 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -55,7 +55,9 @@ struct iommu_cmd {
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
 static struct dma_ops_domain *find_protection_domain(u16 devid);
-
+static u64* alloc_pte(struct protection_domain *dom,
+		      unsigned long address, u64
+		      **pte_page, gfp_t gfp);
 
 #ifdef CONFIG_AMD_IOMMU_STATS
 
@@ -468,7 +470,7 @@ static int iommu_map_page(struct protection_domain *dom,
 			  unsigned long phys_addr,
 			  int prot)
 {
-	u64 __pte, *pte, *page;
+	u64 __pte, *pte;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
 	phys_addr = PAGE_ALIGN(phys_addr);
@@ -477,27 +479,7 @@ static int iommu_map_page(struct protection_domain *dom,
 	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
 		return -EINVAL;
 
-	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(bus_addr)];
-
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(GFP_KERNEL);
-		if (!page)
-			return -ENOMEM;
-		*pte = IOMMU_L2_PDE(virt_to_phys(page));
-	}
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
-
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(GFP_KERNEL);
-		if (!page)
-			return -ENOMEM;
-		*pte = IOMMU_L1_PDE(virt_to_phys(page));
-	}
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L0_INDEX(bus_addr)];
+	pte = alloc_pte(dom, bus_addr, NULL, GFP_KERNEL);
 
 	if (IOMMU_PTE_PRESENT(*pte))
 		return -EBUSY;
@@ -1140,6 +1122,61 @@ static int get_device_resources(struct device *dev,
 }
 
 /*
+ * If the pte_page is not yet allocated this function is called
+ */
+static u64* alloc_pte(struct protection_domain *dom,
+		      unsigned long address, u64 **pte_page, gfp_t gfp)
+{
+	u64 *pte, *page;
+
+	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte)) {
+		page = (u64 *)get_zeroed_page(gfp);
+		if (!page)
+			return NULL;
+		*pte = IOMMU_L2_PDE(virt_to_phys(page));
+	}
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte)) {
+		page = (u64 *)get_zeroed_page(gfp);
+		if (!page)
+			return NULL;
+		*pte = IOMMU_L1_PDE(virt_to_phys(page));
+	}
+
+	pte = IOMMU_PTE_PAGE(*pte);
+
+	if (pte_page)
+		*pte_page = pte;
+
+	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+
+	return pte;
+}
+
+/*
+ * This function fetches the PTE for a given address in the aperture
+ */
+static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
+			    unsigned long address)
+{
+	struct aperture_range *aperture = &dom->aperture;
+	u64 *pte, *pte_page;
+
+	pte = aperture->pte_pages[IOMMU_PTE_L1_INDEX(address)];
+	if (!pte) {
+		pte = alloc_pte(&dom->domain, address, &pte_page, GFP_ATOMIC);
+		aperture->pte_pages[IOMMU_PTE_L1_INDEX(address)] = pte_page;
+	}
+
+	return pte;
+}
+
+/*
  * This is the generic map function. It maps one 4kb page at paddr to
  * the given address in the DMA address space for the domain.
  */
@@ -1155,8 +1192,7 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 
 	paddr &= PAGE_MASK;
 
-	pte  = dom->aperture.pte_pages[IOMMU_PTE_L1_INDEX(address)];
-	pte += IOMMU_PTE_L0_INDEX(address);
+	pte  = dma_ops_get_pte(dom, address);
 
 	__pte = paddr | IOMMU_PTE_P | IOMMU_PTE_FC;
 
-- 
1.6.3.1


