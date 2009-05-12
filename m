Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZEMDLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZEMDLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZEMDGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:17 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36226
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753723AbZEMDGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:07 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/10] xen: make sure swiotlb allocation is physically contigious
Date: Tue, 12 May 2009 14:50:42 -0700
Message-Id: <1242165051-6636-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating the swiotlb buffer under Xen, make sure the memory is
physically contiguous so that its really suitable for DMA.

Do this by allocating the memory as usual, but then call a Xen
function to rearrange the underlying pages to be physically
contiguous.

[ Impact: make swiotlb allocation suitable for Xen ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb.c |   10 ----------
 arch/x86/xen/Makefile         |    1 +
 arch/x86/xen/pci-swiotlb.c    |   27 +++++++++++++++++++++++++++
 drivers/pci/xen-iommu.c       |   16 ++++++++++++++++
 include/xen/swiotlb.h         |    6 ++++++
 5 files changed, 50 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/xen/pci-swiotlb.c
 create mode 100644 include/xen/swiotlb.h

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 221a385..880b7bc 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -13,16 +13,6 @@
 
 int swiotlb __read_mostly;
 
-void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
-{
-	return alloc_bootmem_low_pages(size);
-}
-
-void *swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-}
-
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index c4cda96..caede49 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -12,3 +12,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= vga.o
+obj-$(CONFIG_PCI_XEN)		+= pci-swiotlb.o
\ No newline at end of file
diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
new file mode 100644
index 0000000..7665d3b
--- /dev/null
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -0,0 +1,27 @@
+#include <linux/bootmem.h>
+#include <linux/gfp.h>
+
+#include <xen/swiotlb.h>
+#include <asm/xen/hypervisor.h>
+
+/* 
+ * This file defines overrides for weak functions with default
+ * implementations in lib/swiotlb.c.
+ */
+
+void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	void *ret = alloc_bootmem_low_pages(size);
+
+	if (ret && xen_pv_domain())
+		xen_swiotlb_fixup(ret, size, nslabs);
+
+	return ret;
+}
+
+void *swiotlb_alloc(unsigned order, unsigned long nslabs)
+{
+	/* Never called on x86.  Warn, just in case it ever is. */
+	WARN_ON(1);
+	return NULL;
+}
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index ac6bcdb..8c034b8 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -12,6 +12,7 @@
 #include <xen/grant_table.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
+#include <xen/swiotlb.h>
 
 #include <asm/iommu.h>
 #include <asm/swiotlb.h>
@@ -34,6 +35,21 @@ do {							\
 	(unsigned long long)addr + size);		\
 } while (0)
 
+
+void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
+{
+	unsigned order = get_order(size);
+
+	printk(KERN_DEBUG "xen_swiotlb_fixup: buf=%p size=%zu order=%u\n",
+		buf, size, order);
+
+	if (WARN_ON(size != (PAGE_SIZE << order)))
+		return;
+
+	if (xen_create_contiguous_region((unsigned long)buf,
+					 order, DMA_BIT_MASK(32)))
+		printk(KERN_ERR "xen_create_contiguous_region failed\n");
+}
 static inline int address_needs_mapping(struct device *hwdev,
 						dma_addr_t addr)
 {
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
new file mode 100644
index 0000000..67b7b42
--- /dev/null
+++ b/include/xen/swiotlb.h
@@ -0,0 +1,6 @@
+#ifndef _XEN_SWIOTLB_H
+#define _XEN_SWIOTLB_H
+
+extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
+
+#endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

