Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYJ3UNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYJ3UNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJ3UNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:13:14 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58596 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbYJ3UNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:13:13 -0400
Subject: [PATCH] x86 separate PCI out from DMA operations
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Glauber Costa <gcosta@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20081029081347.63048b8d@infradead.org>
References: <1225228943.3251.17.camel@localhost.localdomain>
	 <20081029073629.GB17992@elte.hu>
	 <1225288906.3257.4.camel@localhost.localdomain>
	 <20081029070824.10c19a57@infradead.org>
	 <1225289883.3257.9.camel@localhost.localdomain>
	 <20081029081347.63048b8d@infradead.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 15:13:07 -0500
Message-Id: <1225397587.3250.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This splits pci-dma.c into two pieces (a PCI specific pci-dma.c and a
generic dma.c) and conditions the compile of the PCI specific piece on
CONFIG_PCI.

This has the benefit of sweeping all the IOMMU glue into PCI specific
files.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

Note: it's possible to merge pci-nommu into this if desired, since that
file really has nothing to do with PCI and everything to do with generic
dma operations.

Also, I used the CONFIG_PCI conditioning dma_supported() rather than
weak symbol trickery because of the EXPORT_SYMBOL() requirements.

James

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 58814cc..be44178 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -34,7 +34,8 @@ obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
-obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
+obj-$(CONFIG_PCI)	+= pci-dma.o
+obj-y			+= dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-y			+= tsc.o io_delay.o rtc.o
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1926248..8cbf10c 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -11,9 +11,6 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_mapping_ops *dma_ops;
-EXPORT_SYMBOL(dma_ops);
-
 static int iommu_sac_force __read_mostly;
 
 #ifdef CONFIG_IOMMU_DEBUG
@@ -35,30 +32,6 @@ int iommu_detected __read_mostly = 0;
 int iommu_bio_merge __read_mostly = 0;
 EXPORT_SYMBOL(iommu_bio_merge);
 
-dma_addr_t bad_dma_address __read_mostly = 0;
-EXPORT_SYMBOL(bad_dma_address);
-
-/* Dummy device used for NULL arguments (normally ISA). Better would
-   be probably a smaller DMA mask, but this is bug-to-bug compatible
-   to older i386. */
-struct device x86_dma_fallback_dev = {
-	.bus_id = "fallback device",
-	.coherent_dma_mask = DMA_32BIT_MASK,
-	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
-};
-EXPORT_SYMBOL(x86_dma_fallback_dev);
-
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
 #ifdef CONFIG_X86_64
 static __initdata void *dma32_bootmem_ptr;
 static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
@@ -134,37 +107,6 @@ unsigned long iommu_nr_pages(unsigned long addr, unsigned long len)
 EXPORT_SYMBOL(iommu_nr_pages);
 #endif
 
-void *dma_generic_alloc_coherent(struct device *dev, size_t size,
-				 dma_addr_t *dma_addr, gfp_t flag)
-{
-	unsigned long dma_mask;
-	struct page *page;
-	dma_addr_t addr;
-
-	dma_mask = dma_alloc_coherent_mask(dev, flag);
-
-	flag |= __GFP_ZERO;
-again:
-	page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
-	if (!page)
-		return NULL;
-
-	addr = page_to_phys(page);
-	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
-		__free_pages(page, get_order(size));
-
-		if (dma_mask < DMA_32BIT_MASK && !(flag & GFP_DMA)) {
-			flag = (flag & ~GFP_DMA32) | GFP_DMA;
-			goto again;
-		}
-
-		return NULL;
-	}
-
-	*dma_addr = addr;
-	return page_address(page);
-}
-
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
@@ -232,16 +174,15 @@ static __init int iommu_setup(char *p)
 }
 early_param("iommu", iommu_setup);
 
+/* the non PCI version of this file is in dma.c */
 int dma_supported(struct device *dev, u64 mask)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
-#ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
 		dev_info(dev, "PCI: Disallowing DAC for device\n");
 		return 0;
 	}
-#endif
 
 	if (ops->dma_supported)
 		return ops->dma_supported(dev, mask);
@@ -273,7 +214,7 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-static int __init pci_iommu_init(void)
+void __init pci_iommu_init(void)
 {
 	calgary_iommu_init();
 
@@ -283,18 +224,15 @@ static int __init pci_iommu_init(void)
 
 	gart_iommu_init();
 
-	no_iommu_init();
-	return 0;
+	if (!dma_ops)
+		force_iommu = 0;
 }
 
 void pci_iommu_shutdown(void)
 {
 	gart_iommu_shutdown();
 }
-/* Must execute after PCI subsystem */
-fs_initcall(pci_iommu_init);
 
-#ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
 static __devinit void via_no_dac(struct pci_dev *dev)
@@ -306,4 +244,3 @@ static __devinit void via_no_dac(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
-#endif
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index c70ab5a..5e7dd85 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -90,7 +90,5 @@ void __init no_iommu_init(void)
 {
 	if (dma_ops)
 		return;
-
-	force_iommu = 0; /* no HW IOMMU */
 	dma_ops = &nommu_dma_ops;
 }
diff --git a/dev/null b/arch/x86/kernel/dma.c
new file mode 100644
index 0000000..0896152
--- /dev/null
+++ b/arch/x86/kernel/dma.c
@@ -0,0 +1,104 @@
+#include <linux/dma-mapping.h>
+#include <linux/dmar.h>
+#include <linux/bootmem.h>
+
+#include <asm/proto.h>
+#include <asm/dma.h>
+#include <asm/iommu.h>
+
+struct dma_mapping_ops *dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
+dma_addr_t bad_dma_address __read_mostly = 0;
+EXPORT_SYMBOL(bad_dma_address);
+
+/* Dummy device used for NULL arguments (normally ISA). Better would
+   be probably a smaller DMA mask, but this is bug-to-bug compatible
+   to older i386. */
+struct device x86_dma_fallback_dev = {
+	.bus_id = "fallback device",
+	.coherent_dma_mask = DMA_32BIT_MASK,
+	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
+};
+EXPORT_SYMBOL(x86_dma_fallback_dev);
+
+int dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_set_mask);
+
+void *dma_generic_alloc_coherent(struct device *dev, size_t size,
+				 dma_addr_t *dma_addr, gfp_t flag)
+{
+	unsigned long dma_mask;
+	struct page *page;
+	dma_addr_t addr;
+
+	dma_mask = dma_alloc_coherent_mask(dev, flag);
+
+	flag |= __GFP_ZERO;
+again:
+	page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
+	if (!page)
+		return NULL;
+
+	addr = page_to_phys(page);
+	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
+		__free_pages(page, get_order(size));
+
+		if (dma_mask < DMA_32BIT_MASK && !(flag & GFP_DMA)) {
+			flag = (flag & ~GFP_DMA32) | GFP_DMA;
+			goto again;
+		}
+
+		return NULL;
+	}
+
+	*dma_addr = addr;
+	return page_address(page);
+}
+
+#ifndef CONFIG_PCI
+int dma_supported(struct device *dev, u64 mask)
+{
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
+	if (ops->dma_supported)
+		return ops->dma_supported(dev, mask);
+
+	/* Copied from i386. Doesn't make much sense, because it will
+	   only work for pci_alloc_coherent.
+	   The caller just has to use GFP_DMA in this case. */
+	if (mask < DMA_24BIT_MASK)
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL(dma_supported);
+#endif
+
+/* dummy weak initialisation function.  If CONFIG_PCI is selected
+ * pci-dma.c has a strong version of this which gets called instead */
+void __init __weak pci_iommu_init(void)
+{
+}
+
+static __init int dma_init(void)
+{
+	pci_iommu_init();
+
+	no_iommu_init();
+
+	return 0;
+}
+
+/* Must execute after PCI subsystem */
+fs_initcall(dma_init);
+
+


