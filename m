Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0BITlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:41:11 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54623 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/35] x86: only call dma32_reserve_bootmem 64bit !CONFIG_NUMA
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
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

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index ada8c20..b4a00dd 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -124,6 +124,8 @@ extern void pci_iommu_alloc(void);
 #include "pci_64.h"
 #endif
 
+void dma32_reserve_bootmem(void);
+
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
 #include <asm-generic/pci-dma-compat.h>
 
diff --git a/arch/x86/include/asm/pci_64.h b/arch/x86/include/asm/pci_64.h
index ae5e40f..fe15cfb 100644
--- a/arch/x86/include/asm/pci_64.h
+++ b/arch/x86/include/asm/pci_64.h
@@ -22,8 +22,6 @@ extern int (*pci_config_read)(int seg, int bus, int dev, int fn,
 extern int (*pci_config_write)(int seg, int bus, int dev, int fn,
 			       int reg, int len, u32 value);
 
-extern void dma32_reserve_bootmem(void);
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PCI_64_H */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 75e14e2..1aa966c 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -65,7 +65,7 @@ int dma_set_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_mask);
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_NUMA)
 static __initdata void *dma32_bootmem_ptr;
 static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
 
@@ -116,14 +116,21 @@ static void __init dma32_free_bootmem(void)
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
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 48cadbb..ea4141b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -969,14 +969,7 @@ void __init setup_arch(char **cmdline_p)
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
 
-- 
1.6.4.2

