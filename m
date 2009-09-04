Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbZIDJoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbZIDJoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbZIDJmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:07 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:48750 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbZIDJmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:02 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXLV-03-O1L-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/14] x86/amd-iommu: Change alloc_pte to support 64 bit address space
Date: Fri, 4 Sep 2009 11:40:46 +0200
Message-ID: <1252057252-32074-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0533 (UTC) FILETIME=[CCCA01D0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the alloc_pte function to be able to map
pages into the whole 64 bit address space supported by AMD
IOMMU hardware from the old limit of 2**39 bytes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   44 +++++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fc97b51..3be2b61 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -55,7 +55,7 @@ struct iommu_cmd {
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
 static struct dma_ops_domain *find_protection_domain(u16 devid);
-static u64* alloc_pte(struct protection_domain *dom,
+static u64 *alloc_pte(struct protection_domain *domain,
 		      unsigned long address, u64
 		      **pte_page, gfp_t gfp);
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
@@ -1351,39 +1351,35 @@ static bool increase_address_space(struct protection_domain *domain,
 	return true;
 }
 
-/*
- * If the pte_page is not yet allocated this function is called
- */
-static u64* alloc_pte(struct protection_domain *dom,
+static u64 *alloc_pte(struct protection_domain *domain,
 		      unsigned long address, u64 **pte_page, gfp_t gfp)
 {
 	u64 *pte, *page;
+	int level;
 
-	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(address)];
+	while (address > PM_LEVEL_SIZE(domain->mode))
+		increase_address_space(domain, gfp);
 
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(gfp);
-		if (!page)
-			return NULL;
-		*pte = IOMMU_L2_PDE(virt_to_phys(page));
-	}
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+	while (level > 0) {
+		if (!IOMMU_PTE_PRESENT(*pte)) {
+			page = (u64 *)get_zeroed_page(gfp);
+			if (!page)
+				return NULL;
+			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
+		}
 
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(gfp);
-		if (!page)
-			return NULL;
-		*pte = IOMMU_L1_PDE(virt_to_phys(page));
-	}
+		level -= 1;
 
-	pte = IOMMU_PTE_PAGE(*pte);
+		pte = IOMMU_PTE_PAGE(*pte);
 
-	if (pte_page)
-		*pte_page = pte;
+		if (pte_page && level == 0)
+			*pte_page = pte;
 
-	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
+	}
 
 	return pte;
 }
-- 
1.6.3.3


