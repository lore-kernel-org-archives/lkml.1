Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbZDCNuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbZDCNuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbZDCNuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:50:00 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31824 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753060AbZDCNt6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:49:58 -0400
X-BigFish: VPS-21(z21eWz936eQzz1202hzzz32i6bh43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KHJ2EQ-02-RHD-01
Date: Fri, 3 Apr 2009 15:50:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: [git pull] dma-debug fixes for 2.6.30-rc
Message-ID: <20090403135014.GG22472@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 03 Apr 2009 13:49:34.0537 (UTC) FILETIME=[0597DB90:01C9B463]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 8fe74cf053de7ad2124a894996f84fa890a81093:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-debug

Joerg Roedel (1):
      x86/dma: unify definition of pci_unmap_addr* and pci_unmap_len macros

 arch/x86/include/asm/pci.h    |   36 ++++++++++++++++++++++++++++++++----
 arch/x86/include/asm/pci_32.h |   34 ----------------------------------
 arch/x86/include/asm/pci_64.h |   22 ----------------------
 3 files changed, 32 insertions(+), 60 deletions(-)
 delete mode 100644 arch/x86/include/asm/pci_32.h

This unification fixes dma-debug false positives on i386 reporting that a dma
mapping was freed with another length than it was allocated. The full diff is
also attached. This patch is against linus/master since your HEAD of latest
tip/core/iommu branch is currently 2.6.29 final. Please pull.

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index a0301bf..e545ea0 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -89,12 +89,40 @@ extern void pci_iommu_alloc(void);
 /* MSI arch hook */
 #define arch_setup_msi_irqs arch_setup_msi_irqs
 
-#endif  /* __KERNEL__ */
+#define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_DMA_API_DEBUG)
+
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       \
+	        dma_addr_t ADDR_NAME;
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)         \
+	        __u32 LEN_NAME;
+#define pci_unmap_addr(PTR, ADDR_NAME)                  \
+	        ((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)         \
+	        (((PTR)->ADDR_NAME) = (VAL))
+#define pci_unmap_len(PTR, LEN_NAME)                    \
+	        ((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)           \
+	        (((PTR)->LEN_NAME) = (VAL))
 
-#ifdef CONFIG_X86_32
-# include "pci_32.h"
 #else
-# include "pci_64.h"
+
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       dma_addr_t ADDR_NAME[0];
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME) unsigned LEN_NAME[0];
+#define pci_unmap_addr(PTR, ADDR_NAME)  sizeof((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
+	        do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
+#define pci_unmap_len(PTR, LEN_NAME)            sizeof((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
+	        do { break; } while (pci_unmap_len(PTR, LEN_NAME))
+
+#endif
+
+#endif  /* __KERNEL__ */
+
+#ifdef CONFIG_X86_64
+#include "pci_64.h"
 #endif
 
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
diff --git a/arch/x86/include/asm/pci_32.h b/arch/x86/include/asm/pci_32.h
deleted file mode 100644
index 6f1213a..0000000
--- a/arch/x86/include/asm/pci_32.h
+++ /dev/null
@@ -1,34 +0,0 @@
-#ifndef _ASM_X86_PCI_32_H
-#define _ASM_X86_PCI_32_H
-
-
-#ifdef __KERNEL__
-
-
-/* Dynamic DMA mapping stuff.
- * i386 has everything mapped statically.
- */
-
-struct pci_dev;
-
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME[0];
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)	unsigned LEN_NAME[0];
-#define pci_unmap_addr(PTR, ADDR_NAME)	sizeof((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
-	do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
-#define pci_unmap_len(PTR, LEN_NAME)		sizeof((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
-	do { break; } while (pci_unmap_len(PTR, LEN_NAME))
-
-
-#endif /* __KERNEL__ */
-
-
-#endif /* _ASM_X86_PCI_32_H */
diff --git a/arch/x86/include/asm/pci_64.h b/arch/x86/include/asm/pci_64.h
index 4da2079..ae5e40f 100644
--- a/arch/x86/include/asm/pci_64.h
+++ b/arch/x86/include/asm/pci_64.h
@@ -24,28 +24,6 @@ extern int (*pci_config_write)(int seg, int bus, int dev, int fn,
 
 extern void dma32_reserve_bootmem(void);
 
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions
- *
- * On AMD64 it mostly equals, but we set it to zero if a hardware
- * IOMMU (gart) of sotware IOMMU (swiotlb) is available.
- */
-#define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
-	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
-	__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)			\
-	((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)		\
-	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)			\
-	((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
-	(((PTR)->LEN_NAME) = (VAL))
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PCI_64_H */
-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

