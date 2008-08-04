Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYHDQHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYHDQHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYHDQFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:15 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53968 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbYHDQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:12 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K533C4-03-PIX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/10] x86, AMD IOMMU: convert driver to generic iommu_num_pages function
Date: Mon, 4 Aug 2008 18:04:46 +0200
Message-ID: <1217865890-3593-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0683 (UTC) FILETIME=[D3D28B30:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f211341..108e003 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -182,7 +182,7 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = iommu_nr_pages(address, size);
+	unsigned pages = iommu_num_pages(address, size, PAGE_SIZE);
 
 	address &= PAGE_MASK;
 
@@ -554,8 +554,9 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_nr_pages(iommu->exclusion_start,
-					    iommu->exclusion_length);
+		int pages = iommu_num_pages(iommu->exclusion_start,
+					    iommu->exclusion_length,
+					    PAGE_SIZE);
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
 
@@ -764,7 +765,7 @@ static dma_addr_t __map_single(struct device *dev,
 	unsigned int pages;
 	int i;
 
-	pages = iommu_nr_pages(paddr, size);
+	pages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	paddr &= PAGE_MASK;
 
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
@@ -799,7 +800,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = iommu_nr_pages(dma_addr, size);
+	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
-- 
1.5.3.7


