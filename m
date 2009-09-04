Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbZIDJnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbZIDJnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933465AbZIDJnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:43:24 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:49106 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933493AbZIDJmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:17 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXM1-04-HXB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/14] x86/amd-iommu: Change iommu_map_page to support multiple page sizes
Date: Fri, 4 Sep 2009 11:40:52 +0200
Message-ID: <1252057252-32074-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0627 (UTC) FILETIME=[CCD859B0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a map_size parameter to the iommu_map_page
function which makes it generic enough to handle multiple
page sizes. This also requires a change to alloc_pte which
is also done in this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    6 ++++++
 arch/x86/kernel/amd_iommu.c            |   31 ++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 351ca39..9e8bb97 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -160,6 +160,12 @@
 				 IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
 #define PM_PTE_LEVEL(pte)	(((pte) >> 9) & 0x7ULL)
 
+#define PM_MAP_4k		0
+#define PM_ADDR_MASK		0x000ffffffffff000ULL
+#define PM_MAP_MASK(lvl)	(PM_ADDR_MASK & \
+				(~((1ULL << (12 + ((lvl) * 9))) - 1)))
+#define PM_ALIGNED(lvl, addr)	((PM_MAP_MASK(lvl) & (addr)) == (addr))
+
 #define IOMMU_PTE_P  (1ULL << 0)
 #define IOMMU_PTE_TV (1ULL << 1)
 #define IOMMU_PTE_U  (1ULL << 59)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 002cf9c..45be949 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -56,8 +56,8 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
 static struct dma_ops_domain *find_protection_domain(u16 devid);
 static u64 *alloc_pte(struct protection_domain *domain,
-		      unsigned long address, u64
-		      **pte_page, gfp_t gfp);
+		      unsigned long address, int end_lvl,
+		      u64 **pte_page, gfp_t gfp);
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages);
@@ -523,17 +523,21 @@ void amd_iommu_flush_all_devices(void)
 static int iommu_map_page(struct protection_domain *dom,
 			  unsigned long bus_addr,
 			  unsigned long phys_addr,
-			  int prot)
+			  int prot,
+			  int map_size)
 {
 	u64 __pte, *pte;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
 	phys_addr = PAGE_ALIGN(phys_addr);
 
+	BUG_ON(!PM_ALIGNED(map_size, bus_addr));
+	BUG_ON(!PM_ALIGNED(map_size, phys_addr));
+
 	if (!(prot & IOMMU_PROT_MASK))
 		return -EINVAL;
 
-	pte = alloc_pte(dom, bus_addr, NULL, GFP_KERNEL);
+	pte = alloc_pte(dom, bus_addr, map_size, NULL, GFP_KERNEL);
 
 	if (IOMMU_PTE_PRESENT(*pte))
 		return -EBUSY;
@@ -612,7 +616,8 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 
 	for (addr = e->address_start; addr < e->address_end;
 	     addr += PAGE_SIZE) {
-		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot);
+		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot,
+				     PM_MAP_4k);
 		if (ret)
 			return ret;
 		/*
@@ -729,7 +734,7 @@ static int alloc_new_range(struct amd_iommu *iommu,
 		u64 *pte, *pte_page;
 
 		for (i = 0; i < num_ptes; ++i) {
-			pte = alloc_pte(&dma_dom->domain, address,
+			pte = alloc_pte(&dma_dom->domain, address, PM_MAP_4k,
 					&pte_page, gfp);
 			if (!pte)
 				goto out_free;
@@ -1356,7 +1361,10 @@ static bool increase_address_space(struct protection_domain *domain,
 }
 
 static u64 *alloc_pte(struct protection_domain *domain,
-		      unsigned long address, u64 **pte_page, gfp_t gfp)
+		      unsigned long address,
+		      int end_lvl,
+		      u64 **pte_page,
+		      gfp_t gfp)
 {
 	u64 *pte, *page;
 	int level;
@@ -1367,7 +1375,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 	level =  domain->mode - 1;
 	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	while (level > 0) {
+	while (level > end_lvl) {
 		if (!IOMMU_PTE_PRESENT(*pte)) {
 			page = (u64 *)get_zeroed_page(gfp);
 			if (!page)
@@ -1379,7 +1387,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 
 		pte = IOMMU_PTE_PAGE(*pte);
 
-		if (pte_page && level == 0)
+		if (pte_page && level == end_lvl)
 			*pte_page = pte;
 
 		pte = &pte[PM_LEVEL_INDEX(level, address)];
@@ -1403,7 +1411,8 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 
 	pte = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
 	if (!pte) {
-		pte = alloc_pte(&dom->domain, address, &pte_page, GFP_ATOMIC);
+		pte = alloc_pte(&dom->domain, address, PM_MAP_4k, &pte_page,
+				GFP_ATOMIC);
 		aperture->pte_pages[APERTURE_PAGE_INDEX(address)] = pte_page;
 	} else
 		pte += PM_LEVEL_INDEX(0, address);
@@ -2176,7 +2185,7 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	paddr &= PAGE_MASK;
 
 	for (i = 0; i < npages; ++i) {
-		ret = iommu_map_page(domain, iova, paddr, prot);
+		ret = iommu_map_page(domain, iova, paddr, prot, PM_MAP_4k);
 		if (ret)
 			return ret;
 
-- 
1.6.3.3


