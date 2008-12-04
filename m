Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbYLDRky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbYLDRky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbYLDRcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:48 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:38011 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbYLDRcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:20 -0500
X-BigFish: VPS8(zzzzzz92fbmz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4P9-03-CX9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/19] AMD IOMMU: add domain unmap function for IOMMU API
Date: Thu, 4 Dec 2008 18:31:54 +0100
Message-ID: <1228411916-22668-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0400 (UTC) FILETIME=[34FD2D80:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function to unmap pages into protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8391b09..6898d10 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -437,6 +437,28 @@ static int iommu_map_page(struct protection_domain *dom,
 	return 0;
 }
 
+static void iommu_unmap_page(struct protection_domain *dom,
+			     unsigned long bus_addr)
+{
+	u64 *pte;
+
+	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(bus_addr)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
+
+	*pte = 0;
+}
+
 /*
  * This function checks if a specific unity mapping entry is needed for
  * this specific IOMMU.
@@ -1643,3 +1665,20 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 
 	return 0;
 }
+
+static void amd_iommu_unmap_range(struct iommu_domain *dom,
+				  unsigned long iova, size_t size)
+{
+
+	struct protection_domain *domain = dom->priv;
+	unsigned long i,  npages = iommu_num_pages(iova, size, PAGE_SIZE);
+
+	iova  &= PAGE_MASK;
+
+	for (i = 0; i < npages; ++i) {
+		iommu_unmap_page(domain, iova);
+		iova  += PAGE_SIZE;
+	}
+
+	iommu_flush_domain(domain->id);
+}
-- 
1.5.6.4


