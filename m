Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZEUQQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZEUQQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZEUQPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZEUQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:37 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100769"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] swiotlb: make range_needs_mapping architecture-specific
Date: Thu, 21 May 2009 17:15:23 +0100
Message-Id: <1242922528-5982-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:38.0624 (UTC) FILETIME=[61396800:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves range_needs_mapping() from lib/swiotlb.c to
arch/*/include/asm/dma-mapping.h and renames it
swiotlb_arch_force_mapping() to more acurately reflect its usage.

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
 arch/ia64/include/asm/dma-mapping.h    |    5 +++++
 arch/powerpc/include/asm/dma-mapping.h |    5 +++++
 arch/x86/include/asm/dma-mapping.h     |    9 +++++++++
 arch/x86/kernel/pci-swiotlb.c          |    2 ++
 include/linux/swiotlb.h                |    2 --
 lib/swiotlb.c                          |   13 ++++---------
 6 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index a091648..3e8fb31 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -180,4 +180,9 @@ static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
 	return addr + size <= mask;
 }
 
+static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
+{
+       return 0;
+}
+
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index c69f2b5..7e3510d 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -429,5 +429,10 @@ static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	__dma_sync(vaddr, size, (int)direction);
 }
 
+static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
+{
+	return 0;
+}
+
 #endif /* __KERNEL__ */
 #endif	/* _ASM_DMA_MAPPING_H */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 52b8d36..aa9639f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -315,4 +315,13 @@ static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
 	return addr + size <= mask;
 }
 
+extern int (*x86_swiotlb_force_mapping)(phys_addr_t paddr, size_t size);
+
+static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
+{
+	if (x86_swiotlb_force_mapping)
+		return x86_swiotlb_force_mapping(paddr, size);
+	return 0;
+}
+
 #endif
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 7267376..d48912c 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -15,6 +15,8 @@
 
 int swiotlb __read_mostly;
 
+int (*x86_swiotlb_force_mapping)(phys_addr_t paddr, size_t size);
+
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cb1a663..32f4fa4 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -32,8 +32,6 @@ extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
 				       dma_addr_t address);
 
-extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
-
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 98726a2..d311654 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -147,11 +147,6 @@ void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
 }
 
-int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	return 0;
-}
-
 static void swiotlb_print_info(unsigned long bytes)
 {
 	phys_addr_t pstart, pend;
@@ -312,9 +307,9 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
+static inline int force_mapping(phys_addr_t paddr, size_t size)
 {
-	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr, size);
+	return swiotlb_force || swiotlb_force_mapping(paddr, size);
 }
 
 static int is_swiotlb_buffer(char *addr)
@@ -647,7 +642,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * buffering it.
 	 */
 	if (is_buffer_dma_capable(dev, dma_get_mask(dev), dev_addr, size) &&
-	    !range_needs_mapping(phys, size))
+	    !force_mapping(phys, size))
 		return dev_addr;
 
 	/*
@@ -810,7 +805,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		phys_addr_t paddr = sg_phys(sg);
 		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
-		if (range_needs_mapping(paddr, sg->length) ||
+		if (force_mapping(paddr, sg->length) ||
 		    !is_buffer_dma_capable(hwdev, dma_get_mask(hwdev),
 					   dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
-- 
1.5.6.5

