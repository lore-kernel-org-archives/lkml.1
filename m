Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZCaWxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZCaWxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763769AbZCaWwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:21 -0400
Received: from gw.goop.org ([64.81.55.164]:53468 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758402AbZCaWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/9] xen: make sure swiotlb allocation is physically contigious
Date: Tue, 31 Mar 2009 15:52:07 -0700
Message-Id: <1238539935-4295-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make swiotlb allocation suitable for Xen

When allocating the swiotlb buffer under Xen, make sure the memory is
physically contiguous so that its really suitable for DMA.

Do this by allocating the memory as usual, but then call a Xen
function to rearrange the underlying pages to be physically
contiguous.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |   17 +++++++++++++++--
 drivers/pci/xen-iommu.c          |   16 ++++++++++++++++
 include/xen/swiotlb.h            |   12 ++++++++++++
 3 files changed, 43 insertions(+), 2 deletions(-)
 create mode 100644 include/xen/swiotlb.h

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 0f03b06..be379af 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -11,16 +11,29 @@
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
+#include <xen/swiotlb.h>
+#include <asm/xen/hypervisor.h>
+
 int swiotlb __read_mostly;
 
 void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 {
-	return alloc_bootmem_low_pages(size);
+	void *ret = alloc_bootmem_low_pages(size);
+
+	if (ret && xen_pv_domain())
+		xen_swiotlb_fixup(ret, size, nslabs);
+
+	return ret;
 }
 
 void *swiotlb_alloc(unsigned order, unsigned long nslabs)
 {
-	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+	void *ret = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+
+	if (ret && xen_pv_domain())
+		xen_swiotlb_fixup(ret, 1u << order, nslabs);
+
+	return ret;
 }
 
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 32a8b49..c593058 100644
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
+					 order, 0xffffffff))
+		printk(KERN_ERR "xen_create_contiguous_region failed\n");
+}
 static inline int address_needs_mapping(struct device *hwdev,
 						dma_addr_t addr)
 {
diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
new file mode 100644
index 0000000..8d59439
--- /dev/null
+++ b/include/xen/swiotlb.h
@@ -0,0 +1,12 @@
+#ifndef _XEN_SWIOTLB_H
+#define _XEN_SWIOTLB_H
+
+#ifdef CONFIG_PCI_XEN
+extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
+#else
+static inline void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
+{
+}
+#endif
+
+#endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

