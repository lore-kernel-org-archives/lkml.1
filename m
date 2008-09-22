Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYIVNhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYIVNhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYIVNhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:37:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:47875 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbYIVNhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:37:10 -0400
Date: Mon, 22 Sep 2008 22:35:07 +0900
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] export iommu_area_reserve helper funciton
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080922223353K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against tip/x86/iommu

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] export iommu_area_reserve helper funciton

x86 has set_bit_string() that does the exact same thing that
set_bit_area() in lib/iommu-helper.c does.

This patch exports set_bit_area() in lib/iommu-helper.c as
iommu_area_reserve(), converts GART, Calgary, and AMD IOMMU to use it.

x86's set_bit_string() is used by only the above IOMMUs so this patch
also removes set_bit_string. We can put it back easily when it
necessary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/amd_iommu.c      |    2 +-
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 arch/x86/kernel/pci-gart_64.c    |    2 +-
 include/asm-x86/bitops.h         |   10 ----------
 include/linux/iommu-helper.h     |    1 +
 lib/iommu-helper.c               |    5 ++---
 6 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 853b614..0ad59b0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -582,7 +582,7 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 	if (start_page + pages > last_page)
 		pages = last_page - start_page;
 
-	set_bit_string(dom->bitmap, start_page, pages);
+	iommu_area_reserve(dom->bitmap, start_page, pages);
 }
 
 static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index fe7695e..080d1d2 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -261,7 +261,7 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 			       badbit, tbl, start_addr, npages);
 	}
 
-	set_bit_string(tbl->it_map, index, npages);
+	iommu_area_reserve(tbl->it_map, index, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 508ef47..3dcb1ad 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -827,7 +827,7 @@ void __init gart_iommu_init(void)
 	 * Out of IOMMU space handling.
 	 * Reserve some invalid pages at the beginning of the GART.
 	 */
-	set_bit_string(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
+	iommu_area_reserve(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
 	agp_memory_reserved = iommu_size;
 	printk(KERN_INFO
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 61989b9..451a747 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -424,16 +424,6 @@ static inline int fls(int x)
 
 #undef ADDR
 
-static inline void set_bit_string(unsigned long *bitmap,
-		unsigned long i, int len)
-{
-	unsigned long end = i + len;
-	while (i < end) {
-		__set_bit(i, bitmap);
-		i++;
-	}
-}
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index 58f4110..786539e 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -11,6 +11,7 @@ static inline unsigned long iommu_device_max_index(unsigned long size,
 extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 				  unsigned long shift,
 				  unsigned long boundary_size);
+extern void iommu_area_reserve(unsigned long *map, unsigned long i, int len);
 extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long start, unsigned int nr,
 				      unsigned long shift,
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index a3b8d4c..5d90074 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -30,8 +30,7 @@ again:
 	return index;
 }
 
-static inline void set_bit_area(unsigned long *map, unsigned long i,
-				int len)
+void iommu_area_reserve(unsigned long *map, unsigned long i, int len)
 {
 	unsigned long end = i + len;
 	while (i < end) {
@@ -64,7 +63,7 @@ again:
 			start = index + 1;
 			goto again;
 		}
-		set_bit_area(map, index, nr);
+		iommu_area_reserve(map, index, nr);
 	}
 	return index;
 }
-- 
1.5.4.2

