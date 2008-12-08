Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYLHOh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYLHOh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYLHOhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:37:16 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:60009 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYLHOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:37:14 -0500
X-BigFish: VPS-14(z21eW5edJzzzzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KBKB9F-04-XMZ-01
Date: Mon, 8 Dec 2008 15:36:53 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD IOMMU updates for 2.6.28-rc8
Message-ID: <20081208143653.GQ12816@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 08 Dec 2008 14:36:54.0088 (UTC) FILETIME=[6A2DF480:01C95942]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 218d11a8b071b23b76c484fd5f72a4fe3306801e:
  Jonathan Corbet (1):
        Fix a race condition in FASYNC handling

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28

Joerg Roedel (5):
      AMD IOMMU: fix iommu_map_page function
      AMD IOMMU: fix loop counter in free_pagetable function
      AMD IOMMU: fix typo in comment
      AMD IOMMU: fix WARN_ON in dma_ops unmap path
      AMD IOMMU: __unmap_single: check for bad_dma_address instead of 0

 arch/x86/kernel/amd_iommu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

This are some small bugfixes which were found during the implementation
of the KVM support and further code review. Please pull.

Joerg

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5662e22..a7b6dec 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -344,7 +344,7 @@ static int iommu_map(struct protection_domain *dom,
 	u64 __pte, *pte, *page;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
-	phys_addr = PAGE_ALIGN(bus_addr);
+	phys_addr = PAGE_ALIGN(phys_addr);
 
 	/* only support 512GB address spaces for now */
 	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
@@ -600,7 +600,7 @@ static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
 			continue;
 
 		p2 = IOMMU_PTE_PAGE(p1[i]);
-		for (j = 0; j < 512; ++i) {
+		for (j = 0; j < 512; ++j) {
 			if (!IOMMU_PTE_PRESENT(p2[j]))
 				continue;
 			p3 = IOMMU_PTE_PAGE(p2[j]);
@@ -910,7 +910,7 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 	if (address >= dom->aperture_size)
 		return;
 
-	WARN_ON(address & 0xfffULL || address > dom->aperture_size);
+	WARN_ON(address & ~PAGE_MASK || address >= dom->aperture_size);
 
 	pte  = dom->pte_pages[IOMMU_PTE_L1_INDEX(address)];
 	pte += IOMMU_PTE_L0_INDEX(address);
@@ -922,8 +922,8 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 
 /*
  * This function contains common code for mapping of a physically
- * contiguous memory region into DMA address space. It is uses by all
- * mapping functions provided by this IOMMU driver.
+ * contiguous memory region into DMA address space. It is used by all
+ * mapping functions provided with this IOMMU driver.
  * Must be called with the domain lock held.
  */
 static dma_addr_t __map_single(struct device *dev,
@@ -983,7 +983,8 @@ static void __unmap_single(struct amd_iommu *iommu,
 	dma_addr_t i, start;
 	unsigned int pages;
 
-	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
+	if ((dma_addr == bad_dma_address) ||
+	    (dma_addr + size > dma_dom->aperture_size))
 		return;
 
 	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

