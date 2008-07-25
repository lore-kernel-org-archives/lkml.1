Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYGYM6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYGYM6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGYM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:58:20 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:43593 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYGYM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:58:19 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K4KC0N-03-IBO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] AMD IOMMU: replace to_pages macro with iommu_num_pages
Date: Fri, 25 Jul 2008 14:57:59 +0200
Message-ID: <1216990680-1227-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
References: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jul 2008 12:58:00.0329 (UTC) FILETIME=[11342F90:01C8EE56]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the to_pages macro from AMD IOMMU code and calls the generic
iommu_num_pages function instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 7469740..22d7d05 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -29,9 +29,6 @@
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
-#define to_pages(addr, size) \
-	 (round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)
-
 #define EXIT_LOOP_COUNT 10000000
 
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
@@ -185,7 +182,7 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = to_pages(address, size);
+	unsigned pages = iommu_num_pages(address, size);
 
 	address &= PAGE_MASK;
 
@@ -557,8 +554,8 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = to_pages(iommu->exclusion_start,
-				iommu->exclusion_length);
+		int pages = iommu_num_pages(iommu->exclusion_start,
+					    iommu->exclusion_length);
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
 
@@ -767,7 +764,7 @@ static dma_addr_t __map_single(struct device *dev,
 	unsigned int pages;
 	int i;
 
-	pages = to_pages(paddr, size);
+	pages = iommu_num_pages(paddr, size);
 	paddr &= PAGE_MASK;
 
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
@@ -802,7 +799,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = to_pages(dma_addr, size);
+	pages = iommu_num_pages(dma_addr, size);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
-- 
1.5.3.7


