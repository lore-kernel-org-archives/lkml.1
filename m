Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396Ab0A1Lis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0A1Lis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841Ab0A1Liq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:38:46 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:52148
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754767Ab0A1Lig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:36 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zzab9bh936eMzz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBZ-01-FXU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/11] x86/amd-iommu: Make iommu_map_page and alloc_pte aware of page sizes
Date: Thu, 28 Jan 2010 12:37:58 +0100
Message-ID: <1264678682-30655-8-git-send-email-joerg.roedel@amd.com>
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

This patch changes the old map_size parameter of alloc_pte
to a page_size parameter which can be used more easily to
alloc a pte for intermediate page sizes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   28 +++++++++++++++++
 arch/x86/kernel/amd_iommu.c            |   53 ++++++++++++++++++++------------
 2 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ba19ad4..5e8da56 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -172,6 +172,34 @@
 				(~((1ULL << (12 + ((lvl) * 9))) - 1)))
 #define PM_ALIGNED(lvl, addr)	((PM_MAP_MASK(lvl) & (addr)) == (addr))
 
+/*
+ * Returns the page table level to use for a given page size
+ * Pagesize is expected to be a power-of-two
+ */
+#define PAGE_SIZE_LEVEL(pagesize) \
+		((__ffs(pagesize) - 12) / 9)
+/*
+ * Returns the number of ptes to use for a given page size
+ * Pagesize is expected to be a power-of-two
+ */
+#define PAGE_SIZE_PTE_COUNT(pagesize) \
+		(1ULL << ((__ffs(pagesize) - 12) % 9))
+
+/*
+ * Aligns a given io-virtual address to a given page size
+ * Pagesize is expected to be a power-of-two
+ */
+#define PAGE_SIZE_ALIGN(address, pagesize) \
+		((address) & ~((pagesize) - 1))
+/*
+ * Creates an IOMMU PTE for an address an a given pagesize
+ * The PTE has no permission bits set
+ * Pagesize is expected to be a power-of-two larger than 4096
+ */
+#define PAGE_SIZE_PTE(address, pagesize)		\
+		(((address) | ((pagesize) - 1)) &	\
+		 (~(pagesize >> 1)) & PM_ADDR_MASK)
+
 #define IOMMU_PTE_P  (1ULL << 0)
 #define IOMMU_PTE_TV (1ULL << 1)
 #define IOMMU_PTE_U  (1ULL << 59)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 59cae7c..4170031 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -730,18 +730,22 @@ static bool increase_address_space(struct protection_domain *domain,
 
 static u64 *alloc_pte(struct protection_domain *domain,
 		      unsigned long address,
-		      int end_lvl,
+		      unsigned long page_size,
 		      u64 **pte_page,
 		      gfp_t gfp)
 {
+	int level, end_lvl;
 	u64 *pte, *page;
-	int level;
+
+	BUG_ON(!is_power_of_2(page_size));
 
 	while (address > PM_LEVEL_SIZE(domain->mode))
 		increase_address_space(domain, gfp);
 
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	level   = domain->mode - 1;
+	pte     = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	address = PAGE_SIZE_ALIGN(address, page_size);
+	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
 	while (level > end_lvl) {
 		if (!IOMMU_PTE_PRESENT(*pte)) {
@@ -751,6 +755,10 @@ static u64 *alloc_pte(struct protection_domain *domain,
 			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
 		}
 
+		/* No level skipping support yet */
+		if (PM_PTE_LEVEL(*pte) != level)
+			return NULL;
+
 		level -= 1;
 
 		pte = IOMMU_PTE_PAGE(*pte);
@@ -806,31 +814,36 @@ static int iommu_map_page(struct protection_domain *dom,
 			  unsigned long bus_addr,
 			  unsigned long phys_addr,
 			  int prot,
-			  int map_size)
+			  unsigned long page_size)
 {
 	u64 __pte, *pte;
-
-	bus_addr  = PAGE_ALIGN(bus_addr);
-	phys_addr = PAGE_ALIGN(phys_addr);
-
-	BUG_ON(!PM_ALIGNED(map_size, bus_addr));
-	BUG_ON(!PM_ALIGNED(map_size, phys_addr));
+	int i, count;
 
 	if (!(prot & IOMMU_PROT_MASK))
 		return -EINVAL;
 
-	pte = alloc_pte(dom, bus_addr, map_size, NULL, GFP_KERNEL);
+	bus_addr  = PAGE_ALIGN(bus_addr);
+	phys_addr = PAGE_ALIGN(phys_addr);
+	count     = PAGE_SIZE_PTE_COUNT(page_size);
+	pte       = alloc_pte(dom, bus_addr, page_size, NULL, GFP_KERNEL);
+
+	for (i = 0; i < count; ++i)
+		if (IOMMU_PTE_PRESENT(pte[i]))
+			return -EBUSY;
 
-	if (IOMMU_PTE_PRESENT(*pte))
-		return -EBUSY;
+	if (page_size > PAGE_SIZE) {
+		__pte = PAGE_SIZE_PTE(phys_addr, page_size);
+		__pte |= PM_LEVEL_ENC(7) | IOMMU_PTE_P | IOMMU_PTE_FC;
+	} else
+		__pte = phys_addr | IOMMU_PTE_P | IOMMU_PTE_FC;
 
-	__pte = phys_addr | IOMMU_PTE_P;
 	if (prot & IOMMU_PROT_IR)
 		__pte |= IOMMU_PTE_IR;
 	if (prot & IOMMU_PROT_IW)
 		__pte |= IOMMU_PTE_IW;
 
-	*pte = __pte;
+	for (i = 0; i < count; ++i)
+		pte[i] = __pte;
 
 	update_domain(dom);
 
@@ -877,7 +890,7 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 	for (addr = e->address_start; addr < e->address_end;
 	     addr += PAGE_SIZE) {
 		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot,
-				     PM_MAP_4k);
+				     PAGE_SIZE);
 		if (ret)
 			return ret;
 		/*
@@ -1005,7 +1018,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 		u64 *pte, *pte_page;
 
 		for (i = 0; i < num_ptes; ++i) {
-			pte = alloc_pte(&dma_dom->domain, address, PM_MAP_4k,
+			pte = alloc_pte(&dma_dom->domain, address, PAGE_SIZE,
 					&pte_page, gfp);
 			if (!pte)
 				goto out_free;
@@ -1711,7 +1724,7 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 
 	pte = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
 	if (!pte) {
-		pte = alloc_pte(&dom->domain, address, PM_MAP_4k, &pte_page,
+		pte = alloc_pte(&dom->domain, address, PAGE_SIZE, &pte_page,
 				GFP_ATOMIC);
 		aperture->pte_pages[APERTURE_PAGE_INDEX(address)] = pte_page;
 	} else
@@ -2457,7 +2470,7 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	paddr &= PAGE_MASK;
 
 	for (i = 0; i < npages; ++i) {
-		ret = iommu_map_page(domain, iova, paddr, prot, PM_MAP_4k);
+		ret = iommu_map_page(domain, iova, paddr, prot, PAGE_SIZE);
 		if (ret)
 			return ret;
 
-- 
1.6.6


