Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbYLDRmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbYLDRmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYLDRcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:32:55 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:16150 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbYLDRcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:32:35 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBD4PC-03-CXF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/19] AMD IOMMU: add domain map function for IOMMU API
Date: Thu, 4 Dec 2008 18:31:53 +0100
Message-ID: <1228411916-22668-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:31:57.0417 (UTC) FILETIME=[34FFC590:01C95636]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add a generic function to map pages into protection domains

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d3fee3e..8391b09 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1615,3 +1615,31 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	return 0;
 }
 
+static int amd_iommu_map_range(struct iommu_domain *dom,
+			       unsigned long iova, phys_addr_t paddr,
+			       size_t size, int iommu_prot)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long i,  npages = iommu_num_pages(paddr, size, PAGE_SIZE);
+	int prot = 0;
+	int ret;
+
+	if (iommu_prot & IOMMU_READ)
+		prot |= IOMMU_PROT_IR;
+	if (iommu_prot & IOMMU_WRITE)
+		prot |= IOMMU_PROT_IW;
+
+	iova  &= PAGE_MASK;
+	paddr &= PAGE_MASK;
+
+	for (i = 0; i < npages; ++i) {
+		ret = iommu_map_page(domain, iova, paddr, prot);
+		if (ret)
+			return ret;
+
+		iova  += PAGE_SIZE;
+		paddr += PAGE_SIZE;
+	}
+
+	return 0;
+}
-- 
1.5.6.4


