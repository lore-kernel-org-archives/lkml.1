Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZEUQQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZEUQQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZEUQPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbZEUQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:42 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100790"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb: make swiotlb allocation functions architecture-specific
Date: Thu, 21 May 2009 17:15:25 +0100
Message-Id: <1242922528-5982-5-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:43.0077 (UTC) FILETIME=[63E0E150:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures need to allocate memory to be used as a swiotlb in
a special manner.

Also make the swiotlb_late_init_with_default_size() function only
available on architectures which require it.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>
Cc: xen-devel <xendevel@lists.xensource.com>
Cc: x86 maintainers <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
---
 arch/ia64/include/asm/dma-mapping.h |    5 +++++
 arch/ia64/kernel/pci-swiotlb.c      |   11 +++++++++++
 arch/x86/include/asm/dma-mapping.h  |    4 ++++
 arch/x86/kernel/pci-swiotlb.c       |   12 ++++++++++++
 arch/x86/xen/pci-swiotlb.c          |   17 -----------------
 include/linux/swiotlb.h             |    3 ---
 lib/swiotlb.c                       |   12 ++----------
 7 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 3e8fb31..9f9994d 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -185,4 +185,9 @@ static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
        return 0;
 }
 
+#define SWIOTLB_WANT_LATE_INIT 1
+
+extern void *swiotlb_alloc_boot(size_t size, unsigned long nslabs);
+extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
+
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 285aae8..1b42f21 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -4,6 +4,7 @@
 #include <linux/cache.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/bootmem.h>
 
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
@@ -13,6 +14,16 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
+void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	return alloc_bootmem_low_pages(size);
+}
+
+void *swiotlb_alloc(unsigned order, unsigned long nslabs)
+{
+	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+}
+
 static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t gfp)
 {
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index aa9639f..5a3180d 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -324,4 +324,8 @@ static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
 	return 0;
 }
 
+extern void (*x86_swiotlb_alloc_fixup)(void *buf, size_t size,
+				       unsigned long nslabs);
+extern void *swiotlb_alloc_boot(size_t size, unsigned long nslabs);
+
 #endif
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index d48912c..7de9fdd 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -6,6 +6,7 @@
 #include <linux/swiotlb.h>
 #include <linux/bootmem.h>
 #include <linux/dma-mapping.h>
+#include <linux/bootmem.h>
 
 #include <asm/iommu.h>
 #include <asm/swiotlb.h>
@@ -16,6 +17,17 @@
 int swiotlb __read_mostly;
 
 int (*x86_swiotlb_force_mapping)(phys_addr_t paddr, size_t size);
+void __initdata (*x86_swiotlb_alloc_fixup)(void *buf, size_t size, unsigned long nslabs);
+
+void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	void *ret = alloc_bootmem_low_pages(size);
+
+	if (ret && x86_swiotlb_alloc_fixup)
+		x86_swiotlb_alloc_fixup(ret, size, nslabs);
+
+	return ret;
+}
 
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
index e23b00b..dcf2ef8 100644
--- a/arch/x86/xen/pci-swiotlb.c
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -11,23 +11,6 @@
  * implementations in lib/swiotlb.c.
  */
 
-void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
-{
-	void *ret = alloc_bootmem_low_pages(size);
-
-	if (ret && xen_pv_domain())
-		xen_swiotlb_fixup(ret, size, nslabs);
-
-	return ret;
-}
-
-void *swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	/* Never called on x86.  Warn, just in case. */
-	WARN_ON(1);
-	return NULL;
-}
-
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	if (xen_pv_domain())
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 32f4fa4..be8b77d 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,9 +24,6 @@ struct scatterlist;
 extern void
 swiotlb_init(void);
 
-extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
-extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
-
 extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 				      phys_addr_t address);
 extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d311654..640c2f1 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -114,16 +114,6 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-void * __weak __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
-{
-	return alloc_bootmem_low_pages(size);
-}
-
-void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-}
-
 dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
@@ -213,6 +203,7 @@ swiotlb_init(void)
 	swiotlb_init_with_default_size(64 * (1<<20));	/* default to 64MB */
 }
 
+#ifdef SWIOTLB_WANT_LATE_INIT
 /*
  * Systems with larger DMA zones (those that don't support ISA) can
  * initialize the swiotlb later using the slab allocator if needed.
@@ -306,6 +297,7 @@ cleanup1:
 	io_tlb_nslabs = req_nslabs;
 	return -ENOMEM;
 }
+#endif
 
 static inline int force_mapping(phys_addr_t paddr, size_t size)
 {
-- 
1.5.6.5

