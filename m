Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbYDVJ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbYDVJ23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYDVJ2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:28:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbYDVJ2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:28:20 -0400
Date: Tue, 22 Apr 2008 11:27:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: Re: linux-next: Intel iommu: new warning
Message-ID: <20080422092757.GA16374@elte.hu>
References: <20080422144258.9564e2fa.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422144258.9564e2fa.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Ingo,
> 
> Commit 2be621498d461b63ca6124f86e3b9582e1a8e722 ("x86: dma-ops on 
> highmem fix") in Linus' tree introduced a new warning (noticed in the 
> x86_64 allmodconfig build of linux-next):
> 
> drivers/pci/intel-iommu.c:2240: warning: initialization from 
> incompatible pointer type
> 
> Which I think points at an instance of map_single that needs updating.

good catch! The patch below should fix it.

	Ingo

---------------------------------->
Subject: intel-iommu.c: dma ops fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 22 11:09:04 CEST 2008

Stephen Rothwell noticed that:

Commit 2be621498d461b63ca6124f86e3b9582e1a8e722 ("x86: dma-ops on highmem
fix") in Linus' tree introduced a new warning (noticed in the x86_64
allmodconfig build of linux-next):

drivers/pci/intel-iommu.c:2240: warning: initialization from incompatible pointer type

Which points at an instance of map_single that needs updating.

Fix it to the new prototype.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/intel-iommu.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

Index: linux-x86.q/drivers/pci/intel-iommu.c
===================================================================
--- linux-x86.q.orig/drivers/pci/intel-iommu.c
+++ linux-x86.q/drivers/pci/intel-iommu.c
@@ -1905,32 +1905,31 @@ get_valid_domain_for_dev(struct pci_dev 
 	return domain;
 }
 
-static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
-	size_t size, int dir)
+static dma_addr_t
+intel_map_single(struct device *hwdev, phys_addr_t paddr, size_t size, int dir)
 {
 	struct pci_dev *pdev = to_pci_dev(hwdev);
-	int ret;
 	struct dmar_domain *domain;
-	unsigned long start_addr;
+	unsigned long start_paddr;
 	struct iova *iova;
 	int prot = 0;
+	int ret;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
-		return virt_to_bus(addr);
+		return paddr;
 
 	domain = get_valid_domain_for_dev(pdev);
 	if (!domain)
 		return 0;
 
-	addr = (void *)virt_to_phys(addr);
-	size = aligned_size((u64)addr, size);
+	size = aligned_size((u64)paddr, size);
 
 	iova = __intel_alloc_iova(hwdev, domain, size);
 	if (!iova)
 		goto error;
 
-	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	start_paddr = iova->pfn_lo << PAGE_SHIFT_4K;
 
 	/*
 	 * Check if DMAR supports zero-length reads on write only
@@ -1942,33 +1941,33 @@ static dma_addr_t intel_map_single(struc
 	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
 		prot |= DMA_PTE_WRITE;
 	/*
-	 * addr - (addr + size) might be partial page, we should map the whole
+	 * paddr - (paddr + size) might be partial page, we should map the whole
 	 * page.  Note: if two part of one page are separately mapped, we
-	 * might have two guest_addr mapping to the same host addr, but this
+	 * might have two guest_addr mapping to the same host paddr, but this
 	 * is not a big problem
 	 */
-	ret = domain_page_mapping(domain, start_addr,
-		((u64)addr) & PAGE_MASK_4K, size, prot);
+	ret = domain_page_mapping(domain, start_paddr,
+		((u64)paddr) & PAGE_MASK_4K, size, prot);
 	if (ret)
 		goto error;
 
 	pr_debug("Device %s request: %lx@%llx mapping: %lx@%llx, dir %d\n",
-		pci_name(pdev), size, (u64)addr,
-		size, (u64)start_addr, dir);
+		pci_name(pdev), size, (u64)paddr,
+		size, (u64)start_paddr, dir);
 
 	/* it's a non-present to present mapping */
 	ret = iommu_flush_iotlb_psi(domain->iommu, domain->id,
-			start_addr, size >> PAGE_SHIFT_4K, 1);
+			start_paddr, size >> PAGE_SHIFT_4K, 1);
 	if (ret)
 		iommu_flush_write_buffer(domain->iommu);
 
-	return (start_addr + ((u64)addr & (~PAGE_MASK_4K)));
+	return (start_paddr + ((u64)paddr & (~PAGE_MASK_4K)));
 
 error:
 	if (iova)
 		__free_iova(&domain->iovad, iova);
 	printk(KERN_ERR"Device %s request: %lx@%llx dir %d --- failed\n",
-		pci_name(pdev), size, (u64)addr, dir);
+		pci_name(pdev), size, (u64)paddr, dir);
 	return 0;
 }
 
@@ -2082,7 +2081,7 @@ static void * intel_alloc_coherent(struc
 		return NULL;
 	memset(vaddr, 0, size);
 
-	*dma_handle = intel_map_single(hwdev, vaddr, size, DMA_BIDIRECTIONAL);
+	*dma_handle = intel_map_single(hwdev, virt_to_bus(vaddr), size, DMA_BIDIRECTIONAL);
 	if (*dma_handle)
 		return vaddr;
 	free_pages((unsigned long)vaddr, order);
