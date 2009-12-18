Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZLRJuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZLRJuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZLRJuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:50:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:55127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZLRJuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:50:01 -0500
Message-ID: <4B2B4FEC.8040304@kernel.org>
Date: Fri, 18 Dec 2009 01:48:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
References: <4B2B4C19.6010402@kernel.org>
In-Reply-To: <4B2B4C19.6010402@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64bit NUMA already make enough space under 4G with new early_node_mem

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/pci.h    |    2 ++
 arch/x86/include/asm/pci_64.h |    2 --
 arch/x86/kernel/pci-dma.c     |   13 ++++++++++---
 arch/x86/kernel/setup.c       |    7 -------
 4 files changed, 12 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -65,7 +65,7 @@ int dma_set_mask(struct device *dev, u64
 }
 EXPORT_SYMBOL(dma_set_mask);
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_NUMA)
 static __initdata void *dma32_bootmem_ptr;
 static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
 
@@ -116,14 +116,21 @@ static void __init dma32_free_bootmem(vo
 	dma32_bootmem_ptr = NULL;
 	dma32_bootmem_size = 0;
 }
+#else
+void __init dma32_reserve_bootmem(void)
+{
+}
+static void __init dma32_free_bootmem(void)
+{
+}
+
 #endif
 
 void __init pci_iommu_alloc(void)
 {
-#ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
-#endif
+
 	if (pci_swiotlb_detect())
 		goto out;
 
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -944,14 +944,7 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init(0, max_pfn, acpi, k8);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 
-#ifdef CONFIG_X86_64
-	/*
-	 * dma32_reserve_bootmem() allocates bootmem which may conflict
-	 * with the crashkernel command line, so do that after
-	 * reserve_crashkernel()
-	 */
 	dma32_reserve_bootmem();
-#endif
 
 	reserve_ibft_region();
 
Index: linux-2.6/arch/x86/include/asm/pci.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pci.h
+++ linux-2.6/arch/x86/include/asm/pci.h
@@ -124,6 +124,8 @@ extern void pci_iommu_alloc(void);
 #include "pci_64.h"
 #endif
 
+void dma32_reserve_bootmem(void);
+
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
 #include <asm-generic/pci-dma-compat.h>
 
Index: linux-2.6/arch/x86/include/asm/pci_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pci_64.h
+++ linux-2.6/arch/x86/include/asm/pci_64.h
@@ -22,8 +22,6 @@ extern int (*pci_config_read)(int seg, i
 extern int (*pci_config_write)(int seg, int bus, int dev, int fn,
 			       int reg, int len, u32 value);
 
-extern void dma32_reserve_bootmem(void);
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PCI_64_H */

