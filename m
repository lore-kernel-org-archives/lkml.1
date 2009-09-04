Return-Path: <linux-kernel-owner+w=401wt.eu-S933412AbZIDJmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbZIDJmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933306AbZIDJl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:41:58 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26719 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337AbZIDJl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:41:57 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KPFXLT-04-HX6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/14] x86/amd-iommu: Use fetch_pte in amd_iommu_iova_to_phys
Date: Fri, 4 Sep 2009 11:40:41 +0200
Message-ID: <1252057252-32074-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0267 (UTC) FILETIME=[CCA16B30:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't reimplement the page table walker in this function.
Use the generic one.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5e52798..4a54366 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2140,21 +2140,9 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 	phys_addr_t paddr;
 	u64 *pte;
 
-	pte = &domain->pt_root[IOMMU_PTE_L2_INDEX(iova)];
+	pte = fetch_pte(domain, iova);
 
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return 0;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(iova)];
-
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return 0;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L0_INDEX(iova)];
-
-	if (!IOMMU_PTE_PRESENT(*pte))
+	if (!pte || !IOMMU_PTE_PRESENT(*pte))
 		return 0;
 
 	paddr  = *pte & IOMMU_PAGE_MASK;
-- 
1.6.3.3


