Return-Path: <linux-kernel-owner+w=401wt.eu-S932278Ab0A1Liv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0A1Liv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080Ab0A1Lio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:38:44 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58116
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754843Ab0A1Lig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:36 -0500
X-SpamScore: 5
X-BigFish: VPS5(z2d9bozab9bh936eMzz1202hzzz32i87h6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBZ-01-FXW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/11] x86/amd-iommu: Implement ->{un}map callbacks for iommu-api
Date: Thu, 28 Jan 2010 12:38:01 +0100
Message-ID: <1264678682-30655-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0992 (UTC) FILETIME=[64853C00:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the new callbacks for the IOMMU-API
with functions that can handle different page sizes in the
IOMMU page table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 52e44af..0e068c9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2552,6 +2552,33 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 	iommu_flush_tlb_pde(domain);
 }
 
+static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
+			 phys_addr_t paddr, int gfp_order, int iommu_prot)
+{
+	unsigned long page_size = 0x1000UL << gfp_order;
+	struct protection_domain *domain = dom->priv;
+	int prot = 0;
+
+	if (iommu_prot & IOMMU_READ)
+		prot |= IOMMU_PROT_IR;
+	if (iommu_prot & IOMMU_WRITE)
+		prot |= IOMMU_PROT_IW;
+
+	return iommu_map_page(domain, iova, paddr, prot, page_size);
+}
+
+static int amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
+			   int gfp_order)
+{
+	struct protection_domain *domain = dom->priv;
+	unsigned long page_size, unmap_size;
+
+	page_size  = 0x1000UL << gfp_order;
+	unmap_size = iommu_unmap_page(domain, iova, page_size);
+
+	return get_order(unmap_size);
+}
+
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 					  unsigned long iova)
 {
@@ -2587,6 +2614,8 @@ static struct iommu_ops amd_iommu_ops = {
 	.domain_destroy = amd_iommu_domain_destroy,
 	.attach_dev = amd_iommu_attach_device,
 	.detach_dev = amd_iommu_detach_device,
+	.map = amd_iommu_map,
+	.unmap = amd_iommu_unmap,
 	.map_range = amd_iommu_map_range,
 	.unmap_range = amd_iommu_unmap_range,
 	.iova_to_phys = amd_iommu_iova_to_phys,
-- 
1.6.6


