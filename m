Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbYLDRn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbYLDRn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbYLDRc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:58 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:16833 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756AbYLDRcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:45 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4PD-03-CXG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/19] AMD IOMMU: add domain address lookup function for IOMMU API
Date: Thu, 4 Dec 2008 18:31:55 +0100
Message-ID: <1228411916-22668-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0480 (UTC) FILETIME=[35096280:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function to lockup addresses in protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6898d10..57e636e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1682,3 +1682,34 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 
 	iommu_flush_domain(domain->id);
 }
+
+static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
+					  unsigned long iova)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long offset = iova & ~PAGE_MASK;
+	phys_addr_t paddr;
+	u64 *pte;
+
+	pte = &domain->pt_root[IOMMU_PTE_L2_INDEX(iova)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return 0;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(iova)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return 0;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L0_INDEX(iova)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return 0;
+
+	paddr  = *pte & IOMMU_PAGE_MASK;
+	paddr |= offset;
+
+	return paddr;
+}
-- 
1.5.6.4


