Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYLIO1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYLIO1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbYLIOR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:17:29 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:40708 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYLIOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:43 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4ZA-03-KKZ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/21] AMD IOMMU: add domain map function for IOMMU API
Date: Tue, 9 Dec 2008 15:16:15 +0100
Message-ID: <1228832178-13429-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832178-13429-18-git-send-email-joerg.roedel@amd.com>
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
X-OriginalArrivalTime: 09 Dec 2008 14:16:19.0317 (UTC) FILETIME=[B49C9A50:01C95A08]
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
index 97eb60d..511f782 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1635,3 +1635,31 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
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


