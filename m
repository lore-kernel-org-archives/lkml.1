Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYGaXnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYGaXnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbYGaXnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:43:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58228 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYGaXnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:43:31 -0400
Date: Fri, 1 Aug 2008 09:43:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>,
       ppc-dev <linuxppc-dev@ozlabs.org>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] Revert
 "Merge branch 'x86/iommu' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip into for-linus"
Message-Id: <20080801094323.9601d87b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 29111f579f4f3f2a07385f931854ab0527ae7ea5.

This undoes the hasty addition of a global version of iommu_num_pages()
that broke both the powerpc and sparc builds.  This function can be
revisited later.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/amd_iommu.c   |   13 ++++++++-----
 arch/x86/kernel/pci-gart_64.c |   11 +++++++----
 include/linux/iommu-helper.h  |    1 -
 lib/iommu-helper.c            |    8 --------
 4 files changed, 15 insertions(+), 18 deletions(-)

This patch comes from
git revert -m 1 29111f579f4f3f2a07385f931854ab0527ae7ea5

I have test built powerpc ppc64_defconfig and sparc64 defconfig.  The only
references to iommu_num_pages() after this is applied are in the powerpc
and sparc code.

Linus, please apply.  This is impacting on both powerpc and sparc
development and even the author of the patches said that those patches
were not urgent.

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 22d7d05..7469740 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -29,6 +29,9 @@
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
+#define to_pages(addr, size) \
+	 (round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)
+
 #define EXIT_LOOP_COUNT 10000000
 
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
@@ -182,7 +185,7 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = iommu_num_pages(address, size);
+	unsigned pages = to_pages(address, size);
 
 	address &= PAGE_MASK;
 
@@ -554,8 +557,8 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
-					    iommu->exclusion_length);
+		int pages = to_pages(iommu->exclusion_start,
+				iommu->exclusion_length);
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
 
@@ -764,7 +767,7 @@ static dma_addr_t __map_single(struct device *dev,
 	unsigned int pages;
 	int i;
 
-	pages = iommu_num_pages(paddr, size);
+	pages = to_pages(paddr, size);
 	paddr &= PAGE_MASK;
 
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
@@ -799,7 +802,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = iommu_num_pages(dma_addr, size);
+	pages = to_pages(dma_addr, size);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 49285f8..744126e 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -67,6 +67,9 @@ static u32 gart_unmapped_entry;
 	(((x) & 0xfffff000) | (((x) >> 32) << 4) | GPTE_VALID | GPTE_COHERENT)
 #define GPTE_DECODE(x) (((x) & 0xfffff000) | (((u64)(x) & 0xff0) << 28))
 
+#define to_pages(addr, size) \
+	(round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)
+
 #define EMERGENCY_PAGES 32 /* = 128KB */
 
 #ifdef CONFIG_AGP
@@ -238,7 +241,7 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir)
 {
-	unsigned long npages = iommu_num_pages(phys_mem, size);
+	unsigned long npages = to_pages(phys_mem, size);
 	unsigned long iommu_page = alloc_iommu(dev, npages);
 	int i;
 
@@ -301,7 +304,7 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = iommu_num_pages(dma_addr, size);
+	npages = to_pages(dma_addr, size);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -384,7 +387,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 		}
 
 		addr = phys_addr;
-		pages = iommu_num_pages(s->offset, s->length);
+		pages = to_pages(s->offset, s->length);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -467,7 +470,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 		seg_size += s->length;
 		need = nextneed;
-		pages += iommu_num_pages(s->offset, s->length);
+		pages += to_pages(s->offset, s->length);
 		ps = s;
 	}
 	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index f8598f5..c975caf 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -8,4 +8,3 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index 889ddce..a3b8d4c 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -80,11 +80,3 @@ void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
 	}
 }
 EXPORT_SYMBOL(iommu_area_free);
-
-unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
-{
-	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
-
-	return size >> PAGE_SHIFT;
-}
-EXPORT_SYMBOL(iommu_num_pages);
-- 
1.5.6.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
