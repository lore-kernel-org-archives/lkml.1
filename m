Return-Path: <linux-kernel-owner+w=401wt.eu-S933508AbZIDJnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbZIDJnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933510AbZIDJm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:56 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53953
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933462AbZIDJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:22 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KPFXLR-03-O1H-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/14] x86/amd-iommu: Use fetch_pte in iommu_unmap_page
Date: Fri, 4 Sep 2009 11:40:40 +0200
Message-ID: <1252057252-32074-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0236 (UTC) FILETIME=[CC9CB040:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reimplementing existing logic use fetch_pte to
walk the page table in iommu_unmap_page.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 29bcd35..5e52798 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -546,23 +546,10 @@ static int iommu_map_page(struct protection_domain *dom,
 static void iommu_unmap_page(struct protection_domain *dom,
 			     unsigned long bus_addr)
 {
-	u64 *pte;
-
-	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(bus_addr)];
-
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
-
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
+	u64 *pte = fetch_pte(dom, bus_addr);
 
-	*pte = 0;
+	if (pte)
+		*pte = 0;
 }
 
 /*
-- 
1.6.3.3


