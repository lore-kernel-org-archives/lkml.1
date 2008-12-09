Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYLIO15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYLIO15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYLIORc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:32 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:52879 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbYLIOQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:30 -0500
X-BigFish: VPS8(zzzzzz92fbmz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4ZA-03-KL0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/21] AMD IOMMU: add domain unmap function for IOMMU API
Date: Tue, 9 Dec 2008 15:16:16 +0100
Message-ID: <1228832178-13429-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-19-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832178-13429-1-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-2-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-3-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-4-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-5-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-6-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-7-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-8-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-9-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-10-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-11-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-12-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-13-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-14-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-15-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-16-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-17-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-18-git-send-email-joerg.roedel@amd.com>
 <1228832178-13429-19-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0349 (UTC) FILETIME=[B4A17C50:01C95A08]
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
index 511f782..6ee9377 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -438,6 +438,28 @@ static int iommu_map_page(struct protection_domain *dom,
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
@@ -1663,3 +1685,20 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 
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


