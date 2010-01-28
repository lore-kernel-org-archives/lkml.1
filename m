Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146Ab0A1LkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0A1LkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878Ab0A1Lij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:38:39 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31709 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0A1Lif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:35 -0500
X-SpamScore: 6
X-BigFish: VPS6(z1857rzab9bh936eMzz1202hzzz32i87h6bh63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGC2-01-FXZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/11] x86/amd-iommu: Make amd_iommu_iova_to_phys aware of multiple page sizes
Date: Thu, 28 Jan 2010 12:38:00 +0100
Message-ID: <1264678682-30655-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0992 (UTC) FILETIME=[64853C00:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the amd_iommu_iova_to_phys() function to
handle different page sizes correctly. It doesn't use
fetch_pte() anymore because we don't know (or care about)
the page_size used for mapping the given iova.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 503d312..52e44af 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2556,17 +2556,22 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 					  unsigned long iova)
 {
 	struct protection_domain *domain = dom->priv;
-	unsigned long offset = iova & ~PAGE_MASK;
+	unsigned long offset_mask;
 	phys_addr_t paddr;
-	u64 *pte;
+	u64 *pte, __pte;
 
 	pte = fetch_pte(domain, iova);
 
 	if (!pte || !IOMMU_PTE_PRESENT(*pte))
 		return 0;
 
-	paddr  = *pte & IOMMU_PAGE_MASK;
-	paddr |= offset;
+	if (PM_PTE_LEVEL(*pte) == 0)
+		offset_mask = PAGE_SIZE - 1;
+	else
+		offset_mask = PTE_PAGE_SIZE(*pte) - 1;
+
+	__pte = *pte & PM_ADDR_MASK;
+	paddr = (__pte & ~offset_mask) | (iova & offset_mask);
 
 	return paddr;
 }
-- 
1.6.6


