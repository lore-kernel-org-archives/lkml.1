Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbZDBObg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbZDBObg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZDBObX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:31:23 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:28244
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749AbZDBObW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:31:22 -0400
X-BigFish: VPS-31(z34a4jz146fK1418M1432R98dR1805M936fK10d1I4cd6kzz1202hzzz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KHH9NT-01-556-01
Date: Thu, 2 Apr 2009 16:31:42 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: shemminger@vyatta.com, davej@redhat.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
	frees DMA memory with different size
Message-ID: <20090402143142.GA4776@amd.com>
References: <20090402105415.GD21083@amd.com> <20090402200634I.fujita.tomonori@lab.ntt.co.jp> <20090402111839.GE21083@amd.com> <20090402230346B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090402230346B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Apr 2009 14:31:09.0154 (UTC) FILETIME=[AA167420:01C9B39F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 11:03:58PM +0900, FUJITA Tomonori wrote:
> On Thu, 2 Apr 2009 13:18:39 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Thu, Apr 02, 2009 at 08:06:26PM +0900, FUJITA Tomonori wrote:
> > > On Thu, 2 Apr 2009 12:54:15 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > On Wed, Apr 01, 2009 at 11:02:45AM -0700, Stephen Hemminger wrote:
> > > > > 
> > > > > The sky2 driver uses pci_unmap_len and pci_unmap_len_set which on 32 bit
> > > > > platforms are meaningless so they are stubbed out. 
> > > > > Basically, DMA-API checks are wrong/bogus to enforce on 32bit x86 as is.
> > > > 
> > > > As far as I know the VT-d driver is available on 32 bit x86 too. So this should
> > > > not always be a nop.
> > > 
> > > VT-d is available on only x86_64.
> > 
> > At least there was a patch to enable it on 32 bit too. See
> > 
> > https://lists.linux-foundation.org/pipermail/iommu/2009-February/001080.html
> > 
> > It seems not to be upstream yet.
> 
> It's not in upstream.
> 
> 
> Anyway, about the original problem, I think that the best fix is not
> to stub out the dma API; using the dma API properly is always a good
> thing.

True.

For the real fix I prepared this fix. We still should find a better #ifdef
condition but that should not be a seperate patch. Does that look ok to
everyone? If yes, I send it to Ingo.

commit e8cdd3b8d2fc3ec2a1dd337cba94feb7a7442751
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Apr 2 15:55:55 2009 +0200

    x86/dma: unify definition of pci_unmap_addr* and pci_unmap_len macros
    
    Impact: unification of pci-dma macros and pci_32h removal
    
    This patch unifies the definition of the pci_unmap_addr*, pci_unmap_len*
    and DECLARE_PCI_UNMAP* macros. This makes sense because the pci_unmap
    functions are no longer no-ops anymore when the kernel runs with
    CONFIG_DMA_API_DEBUG. This also simplifies the port of x86_64 iommu
    drivers to 32 bit x86 and let us get rid of pci_32.h.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index a977de2..ad8f991 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -86,12 +86,40 @@ static inline void early_quirks(void) { }
 
 extern void pci_iommu_alloc(void);
 
-#endif  /* __KERNEL__ */
+#define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
+
+#if defined(CONFIG_X86_64) || defined CONFIG_DMA_API_DEBUG
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

