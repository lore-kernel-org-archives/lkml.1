Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZJIIaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZJIIaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbZJIIaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:30:16 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:53482 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170AbZJIIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U5KsJHHXTDllQllz9uBaTK1N/jCMIJngfpcfi4kj61BfQYQTnl6U2VB5KCLnxJ2ffG
         ypyMOlv1f8eiLK8BNX62j6+jRtSCWJ26+A/p8y0sxDmtxAXnaHz5yuJSpS7Av2DoU/lI
         s5aAiBVSn6CKLJ60Okvcg7FYi4dEqRLUxqXls=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/8] iommu-helper: Use bitmap library
Date: Fri,  9 Oct 2009 17:29:16 +0900
Message-Id: <1255076961-21325-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com>
References: <>
 <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap library and kill some unused iommu helper functions.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/powerpc/kernel/iommu.c      |    4 +-
 arch/sparc/kernel/iommu.c        |    3 +-
 arch/x86/kernel/amd_iommu.c      |    4 +-
 arch/x86/kernel/pci-calgary_64.c |    6 ++--
 arch/x86/kernel/pci-gart_64.c    |    6 ++--
 include/linux/iommu-helper.h     |    3 --
 lib/iommu-helper.c               |   55 ++++---------------------------------
 7 files changed, 18 insertions(+), 63 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index fd51578..5547ae6 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -30,7 +30,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/iommu-helper.h>
 #include <linux/crash_dump.h>
 #include <asm/io.h>
@@ -251,7 +251,7 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	}
 
 	ppc_md.tce_free(tbl, entry, npages);
-	iommu_area_free(tbl->it_map, free_entry, npages);
+	bitmap_clear(tbl->it_map, free_entry, npages);
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 7690cc2..5fad949 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -11,6 +11,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/iommu-helper.h>
+#include <linux/bitmap.h>
 
 #ifdef CONFIG_PCI
 #include <linux/pci.h>
@@ -169,7 +170,7 @@ void iommu_range_free(struct iommu *iommu, dma_addr_t dma_addr, unsigned long np
 
 	entry = (dma_addr - iommu->page_table_map_base) >> IO_PAGE_SHIFT;
 
-	iommu_area_free(arena->map, entry, npages);
+	bitmap_clear(arena->map, entry, npages);
 }
 
 int iommu_table_init(struct iommu *iommu, int tsbsize,
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 98f230f..08b1d20 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -19,7 +19,7 @@
 
 #include <linux/pci.h>
 #include <linux/gfp.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
@@ -959,7 +959,7 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 
 	address = (address % APERTURE_RANGE_SIZE) >> PAGE_SHIFT;
 
-	iommu_area_free(range->bitmap, address, pages);
+	bitmap_clear(range->bitmap, address, pages);
 
 }
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 971a3be..c87bb20 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -31,7 +31,7 @@
 #include <linux/string.h>
 #include <linux/crash_dump.h>
 #include <linux/dma-mapping.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
@@ -211,7 +211,7 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	iommu_area_reserve(tbl->it_map, index, npages);
+	bitmap_set(tbl->it_map, index, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
@@ -305,7 +305,7 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	iommu_area_free(tbl->it_map, entry, npages);
+	bitmap_clear(tbl->it_map, entry, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 98a827e..3010cd1 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -22,7 +22,7 @@
 #include <linux/module.h>
 #include <linux/topology.h>
 #include <linux/interrupt.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
@@ -122,7 +122,7 @@ static void free_iommu(unsigned long offset, int size)
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
-	iommu_area_free(iommu_gart_bitmap, offset, size);
+	bitmap_clear(iommu_gart_bitmap, offset, size);
 	if (offset >= next_bit)
 		next_bit = offset + size;
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
@@ -781,7 +781,7 @@ void __init gart_iommu_init(void)
 	 * Out of IOMMU space handling.
 	 * Reserve some invalid pages at the beginning of the GART.
 	 */
-	iommu_area_reserve(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
+	bitmap_set(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
 	agp_memory_reserved = iommu_size;
 	printk(KERN_INFO
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index 3b068e5..64d1b63 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -14,14 +14,11 @@ static inline unsigned long iommu_device_max_index(unsigned long size,
 extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 				  unsigned long shift,
 				  unsigned long boundary_size);
-extern void iommu_area_reserve(unsigned long *map, unsigned long i, int len);
 extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long start, unsigned int nr,
 				      unsigned long shift,
 				      unsigned long boundary_size,
 				      unsigned long align_mask);
-extern void iommu_area_free(unsigned long *map, unsigned long start,
-			    unsigned int nr);
 
 extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
 				     unsigned long io_page_size);
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index dddbf22..51b53d3 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -3,40 +3,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/bitops.h>
-
-static unsigned long find_next_zero_area(unsigned long *map,
-					 unsigned long size,
-					 unsigned long start,
-					 unsigned int nr,
-					 unsigned long align_mask)
-{
-	unsigned long index, end, i;
-again:
-	index = find_next_zero_bit(map, size, start);
-
-	/* Align allocation */
-	index = (index + align_mask) & ~align_mask;
-
-	end = index + nr;
-	if (end >= size)
-		return -1;
-	i = find_next_bit(map, end, index);
-	if (i < end) {
-		start = i + 1;
-		goto again;
-	}
-	return index;
-}
-
-void iommu_area_reserve(unsigned long *map, unsigned long i, int len)
-{
-	unsigned long end = i + len;
-	while (i < end) {
-		__set_bit(i, map);
-		i++;
-	}
-}
+#include <linux/bitmap.h>
 
 int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 			   unsigned long shift,
@@ -55,30 +22,20 @@ unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 {
 	unsigned long index;
 again:
-	index = find_next_zero_area(map, size, start, nr, align_mask);
-	if (index != -1) {
+	index = bitmap_find_next_zero_area(map, size, start, nr, align_mask);
+	if (index < size) {
 		if (iommu_is_span_boundary(index, nr, shift, boundary_size)) {
 			/* we could do more effectively */
 			start = index + 1;
 			goto again;
 		}
-		iommu_area_reserve(map, index, nr);
+		bitmap_set(map, index, nr);
+		return index;
 	}
-	return index;
+	return -1;
 }
 EXPORT_SYMBOL(iommu_area_alloc);
 
-void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
-{
-	unsigned long end = start + nr;
-
-	while (start < end) {
-		__clear_bit(start, map);
-		start++;
-	}
-}
-EXPORT_SYMBOL(iommu_area_free);
-
 unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
 			      unsigned long io_page_size)
 {
-- 
1.5.4.3

