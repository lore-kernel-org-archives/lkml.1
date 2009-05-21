Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZEUQRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZEUQRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZEUQPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZEUQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:46 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100802"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb: make swiotlb phys<->bus translations architecture-specific
Date: Thu, 21 May 2009 17:15:27 +0100
Message-Id: <1242922528-5982-7-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:47.0843 (UTC) FILETIME=[66B81D30:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves swiotlb_bus_to_phys() and swiotlb_phys_to_bus() from
lib/swiotlb.c to arch/*/include/asm/dma-mapping.h. On x86 gart_to_phys
and phys_to_gart translations need an exported function for use from
drivers so introduce common x86_ variants to implement the interface
required by both.

The __weak swiotlb_bus_to_virt is not currently overriden by any
architecture therefore it can be made static again. I imagine the
ability to override phys<->bus translations will be sufficient for any
potential users anyhow, otherwise we can revisit this aspect.

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
 arch/ia64/include/asm/dma-mapping.h |   13 +++++++++++++
 arch/x86/include/asm/agp.h          |    4 ++--
 arch/x86/include/asm/dma-mapping.h  |   15 +++++++++++++++
 arch/x86/kernel/pci-swiotlb.c       |   18 ++++++++++++++++++
 arch/x86/xen/pci-swiotlb.c          |   15 ---------------
 include/linux/swiotlb.h             |    5 -----
 lib/swiotlb.c                       |   14 +-------------
 7 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 9f9994d..667d04e 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -190,4 +190,17 @@ static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
 extern void *swiotlb_alloc_boot(size_t size, unsigned long nslabs);
 extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
+static inline dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
+					     phys_addr_t paddr)
+{
+	return paddr;
+}
+
+static inline phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
+					      dma_addr_t baddr)
+{
+	return baddr;
+}
+
+
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/x86/include/asm/agp.h b/arch/x86/include/asm/agp.h
index d972b14..085de80 100644
--- a/arch/x86/include/asm/agp.h
+++ b/arch/x86/include/asm/agp.h
@@ -26,8 +26,8 @@
 #define flush_agp_cache() wbinvd()
 
 /* Convert a physical address to an address suitable for the GART. */
-#define phys_to_gart(x) swiotlb_phys_to_bus(NULL, (x))
-#define gart_to_phys(x) swiotlb_bus_to_phys(NULL, (x))
+#define phys_to_gart(x) x86_phys_to_bus(NULL, (x))
+#define gart_to_phys(x) x86_bus_to_phys(NULL, (x))
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
 #define alloc_gatt_pages(order)	({                                          \
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 5a3180d..bccf196 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -328,4 +328,19 @@ extern void (*x86_swiotlb_alloc_fixup)(void *buf, size_t size,
 				       unsigned long nslabs);
 extern void *swiotlb_alloc_boot(size_t size, unsigned long nslabs);
 
+extern dma_addr_t (*x86_phys_to_bus)(struct device *hwdev, phys_addr_t paddr);
+extern phys_addr_t (*x86_bus_to_phys)(struct device *hwdev, dma_addr_t baddr);
+
+static inline dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
+					     phys_addr_t paddr)
+{
+	return x86_phys_to_bus(hwdev, paddr);
+}
+
+static inline phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
+					      dma_addr_t baddr)
+{
+	return x86_bus_to_phys(hwdev, baddr);
+}
+
 #endif
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 7de9fdd..6cc1020 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -29,6 +29,24 @@ void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 	return ret;
 }
 
+static dma_addr_t __x86_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
+{
+	return paddr;
+}
+
+static phys_addr_t __x86_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
+{
+	return baddr;
+}
+
+dma_addr_t (*x86_phys_to_bus)(struct device *hwdev,
+			      phys_addr_t paddr) = __x86_phys_to_bus;
+EXPORT_SYMBOL_GPL(x86_phys_to_bus);
+
+phys_addr_t (*x86_bus_to_phys)(struct device *hwdev,
+			       dma_addr_t baddr) = __x86_bus_to_phys;
+EXPORT_SYMBOL_GPL(x86_bus_to_phys);
+
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
index dcf2ef8..92f04a3 100644
--- a/arch/x86/xen/pci-swiotlb.c
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -11,18 +11,3 @@
  * implementations in lib/swiotlb.c.
  */
 
-dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	if (xen_pv_domain())
-		return xen_phys_to_bus(paddr);
-
-	return paddr;
-}
-
-phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-{
-	if (xen_pv_domain())
-		return xen_bus_to_phys(baddr);
-
-	return baddr;
-}
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index be8b77d..b5b2245 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,11 +24,6 @@ struct scatterlist;
 extern void
 swiotlb_init(void);
 
-extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
-				      phys_addr_t address);
-extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
-				       dma_addr_t address);
-
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 640c2f1..b5dcb68 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -114,25 +114,13 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr;
-}
-EXPORT_SYMBOL_GPL(swiotlb_phys_to_bus);
-
-phys_addr_t __weak swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-{
-	return baddr;
-}
-EXPORT_SYMBOL_GPL(swiotlb_bus_to_phys);
-
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
 {
 	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
-void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
+static void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 {
 	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
 }
-- 
1.5.6.5

