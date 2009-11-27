Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZK0N7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZK0N7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZK0N7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:59:39 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:19343 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZK0Nz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:59 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD8-01-6S0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 24/34] x86/amd-iommu: Move some pte allocation functions in the right section
Date: Fri, 27 Nov 2009 14:55:35 +0100
Message-ID: <1259330145-14865-25-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0607 (UTC) FILETIME=[52DEE8F0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves alloc_pte() and fetch_pte() into the page
table handling code section so that the forward declarations
for them could be removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  193 +++++++++++++++++++++----------------------
 1 files changed, 94 insertions(+), 99 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 17e83ec..90b3650 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -59,15 +59,10 @@ struct iommu_cmd {
 
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
-static u64 *alloc_pte(struct protection_domain *domain,
-		      unsigned long address, int end_lvl,
-		      u64 **pte_page, gfp_t gfp);
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages);
 static void reset_iommu_command_buffer(struct amd_iommu *iommu);
-static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address, int map_size);
 static void update_domain(struct protection_domain *domain);
 
 /****************************************************************************
@@ -665,6 +660,100 @@ void amd_iommu_flush_all_devices(void)
  ****************************************************************************/
 
 /*
+ * This function is used to add another level to an IO page table. Adding
+ * another level increases the size of the address space by 9 bits to a size up
+ * to 64 bits.
+ */
+static bool increase_address_space(struct protection_domain *domain,
+				   gfp_t gfp)
+{
+	u64 *pte;
+
+	if (domain->mode == PAGE_MODE_6_LEVEL)
+		/* address space already 64 bit large */
+		return false;
+
+	pte = (void *)get_zeroed_page(gfp);
+	if (!pte)
+		return false;
+
+	*pte             = PM_LEVEL_PDE(domain->mode,
+					virt_to_phys(domain->pt_root));
+	domain->pt_root  = pte;
+	domain->mode    += 1;
+	domain->updated  = true;
+
+	return true;
+}
+
+static u64 *alloc_pte(struct protection_domain *domain,
+		      unsigned long address,
+		      int end_lvl,
+		      u64 **pte_page,
+		      gfp_t gfp)
+{
+	u64 *pte, *page;
+	int level;
+
+	while (address > PM_LEVEL_SIZE(domain->mode))
+		increase_address_space(domain, gfp);
+
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+
+	while (level > end_lvl) {
+		if (!IOMMU_PTE_PRESENT(*pte)) {
+			page = (u64 *)get_zeroed_page(gfp);
+			if (!page)
+				return NULL;
+			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
+		}
+
+		level -= 1;
+
+		pte = IOMMU_PTE_PAGE(*pte);
+
+		if (pte_page && level == end_lvl)
+			*pte_page = pte;
+
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
+	}
+
+	return pte;
+}
+
+/*
+ * This function checks if there is a PTE for a given dma address. If
+ * there is one, it returns the pointer to it.
+ */
+static u64 *fetch_pte(struct protection_domain *domain,
+		      unsigned long address, int map_size)
+{
+	int level;
+	u64 *pte;
+
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+
+	while (level > map_size) {
+		if (!IOMMU_PTE_PRESENT(*pte))
+			return NULL;
+
+		level -= 1;
+
+		pte = IOMMU_PTE_PAGE(*pte);
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
+
+		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
+			pte = NULL;
+			break;
+		}
+	}
+
+	return pte;
+}
+
+/*
  * Generic mapping functions. It maps a physical address into a DMA
  * address space. It allocates the page table pages if necessary.
  * In the future it can be extended to a generic mapping function
@@ -820,37 +909,6 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  */
 
 /*
- * This function checks if there is a PTE for a given dma address. If
- * there is one, it returns the pointer to it.
- */
-static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address, int map_size)
-{
-	int level;
-	u64 *pte;
-
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
-
-	while (level > map_size) {
-		if (!IOMMU_PTE_PRESENT(*pte))
-			return NULL;
-
-		level -= 1;
-
-		pte = IOMMU_PTE_PAGE(*pte);
-		pte = &pte[PM_LEVEL_INDEX(level, address)];
-
-		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
-			pte = NULL;
-			break;
-		}
-	}
-
-	return pte;
-}
-
-/*
  * This function is used to add a new aperture range to an existing
  * aperture in case of dma_ops domain allocation or address allocation
  * failure.
@@ -1535,69 +1593,6 @@ static void update_domain(struct protection_domain *domain)
 }
 
 /*
- * This function is used to add another level to an IO page table. Adding
- * another level increases the size of the address space by 9 bits to a size up
- * to 64 bits.
- */
-static bool increase_address_space(struct protection_domain *domain,
-				   gfp_t gfp)
-{
-	u64 *pte;
-
-	if (domain->mode == PAGE_MODE_6_LEVEL)
-		/* address space already 64 bit large */
-		return false;
-
-	pte = (void *)get_zeroed_page(gfp);
-	if (!pte)
-		return false;
-
-	*pte             = PM_LEVEL_PDE(domain->mode,
-					virt_to_phys(domain->pt_root));
-	domain->pt_root  = pte;
-	domain->mode    += 1;
-	domain->updated  = true;
-
-	return true;
-}
-
-static u64 *alloc_pte(struct protection_domain *domain,
-		      unsigned long address,
-		      int end_lvl,
-		      u64 **pte_page,
-		      gfp_t gfp)
-{
-	u64 *pte, *page;
-	int level;
-
-	while (address > PM_LEVEL_SIZE(domain->mode))
-		increase_address_space(domain, gfp);
-
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
-
-	while (level > end_lvl) {
-		if (!IOMMU_PTE_PRESENT(*pte)) {
-			page = (u64 *)get_zeroed_page(gfp);
-			if (!page)
-				return NULL;
-			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
-		}
-
-		level -= 1;
-
-		pte = IOMMU_PTE_PAGE(*pte);
-
-		if (pte_page && level == end_lvl)
-			*pte_page = pte;
-
-		pte = &pte[PM_LEVEL_INDEX(level, address)];
-	}
-
-	return pte;
-}
-
-/*
  * This function fetches the PTE for a given address in the aperture
  */
 static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
-- 
1.6.5.3


