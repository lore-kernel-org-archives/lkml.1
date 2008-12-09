Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYLIOXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYLIOXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYLIORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:00 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40590 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYLIOQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:34 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBM4ZB-03-KL2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/21] AMD IOMMU: add domain address lookup function for IOMMU API
Date: Tue, 9 Dec 2008 15:16:17 +0100
Message-ID: <1228832178-13429-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-20-git-send-email-joerg.roedel@amd.com>
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
 <1228832178-13429-20-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0380 (UTC) FILETIME=[B4A63740:01C95A08]
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
index 6ee9377..b42578b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1702,3 +1702,34 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 
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


