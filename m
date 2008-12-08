Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbYLHS0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbYLHS0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYLHS0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:26:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36407 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYLHS0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:26:34 -0500
Date: Mon, 8 Dec 2008 19:26:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081208182623.GA32621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: fix default_spin_lock_flags() prototype

Joerg Roedel (5):
      AMD IOMMU: fix iommu_map_page function
      AMD IOMMU: fix loop counter in free_pagetable function
      AMD IOMMU: fix typo in comment
      AMD IOMMU: fix WARN_ON in dma_ops unmap path
      AMD IOMMU: __unmap_single: check for bad_dma_address instead of 0


 arch/x86/kernel/amd_iommu.c          |   13 +++++++------
 arch/x86/kernel/paravirt-spinlocks.c |    3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

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
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 0e9f198..95777b0 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,7 +7,8 @@
 
 #include <asm/paravirt.h>
 
-static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+static inline void
+default_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
