Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0BKOfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:35:13 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:44801
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754036Ab0BKOdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:37 -0500
X-SpamScore: 6
X-BigFish: VPS6(z1857rzab9bh936eMzz1202hzzz32i87h6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRP-02-7LM-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] x86/amd-iommu: Reimplement iommu_flush_tlb_pde using iommu_update_domain_tlb
Date: Thu, 11 Feb 2010 15:33:17 +0100
Message-ID: <1265898797-32183-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0759 (UTC) FILETIME=[293F9EF0:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets rid of the __iommu_flush_pages function by
reimplementing iommu_flush_tlb_pde using the new
iommu_update_domain_tlb function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   51 ++++++-------------------------------------
 1 files changed, 7 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a645756..a5a1c74 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -610,50 +610,6 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	return ret;
 }
 
-/*
- * TLB invalidation function which is called from the mapping functions.
- * It invalidates a single PTE if the range to flush is within a single
- * page. Otherwise it flushes the whole TLB of the IOMMU.
- */
-static void __iommu_flush_pages(struct protection_domain *domain,
-				u64 address, size_t size, int pde)
-{
-	int s = 0, i;
-	unsigned long pages = iommu_num_pages(address, size, PAGE_SIZE);
-
-	address &= PAGE_MASK;
-
-	if (pages > 1) {
-		/*
-		 * If we have to flush more than one page, flush all
-		 * TLB entries for this domain
-		 */
-		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-		s = 1;
-	}
-
-
-	for (i = 0; i < amd_iommus_present; ++i) {
-		if (!domain->dev_iommu[i])
-			continue;
-
-		/*
-		 * Devices of this domain are behind this IOMMU
-		 * We need a TLB flush
-		 */
-		iommu_queue_inv_iommu_pages(amd_iommus[i], address,
-					    domain->id, pde, s);
-	}
-
-	return;
-}
-
-/* Flush the whole IO/TLB for a given protection domain - including PDE */
-static void iommu_flush_tlb_pde(struct protection_domain *domain)
-{
-	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
-}
-
 /* Flush a range of pages in the domain */
 static void iommu_update_domain_tlb(struct protection_domain *domain, bool pde)
 {
@@ -678,6 +634,13 @@ static void iommu_update_domain_tlb(struct protection_domain *domain, bool pde)
 	domain->flush.tlb = false;
 }
 
+/* Flush the whole IO/TLB for a given protection domain - including PDE */
+static void iommu_flush_tlb_pde(struct protection_domain *domain)
+{
+	update_flush_info_tlb(domain, 0, ~0);
+	iommu_update_domain_tlb(domain, true);
+}
+
 /*
  * This function flushes the DTEs for all devices in domain
  */
-- 
1.6.6


