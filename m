Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYDHQ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYDHQ3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbYDHQ1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbYDHQ1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:46 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 10/28] x86: unify pci-nommu
Date: Tue,  8 Apr 2008 13:20:52 -0300
Message-Id: <12076717383759-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merge pci-base_32.c and pci-nommu_64.c into pci-nommu.c
Their code were made the same, so now they can be merged.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile       |    5 +-
 arch/x86/kernel/pci-base_32.c  |   60 ------------------------
 arch/x86/kernel/pci-dma.c      |    8 +++
 arch/x86/kernel/pci-dma_64.c   |    8 ---
 arch/x86/kernel/pci-nommu.c    |  100 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-nommu_64.c |  100 ----------------------------------------
 6 files changed, 110 insertions(+), 171 deletions(-)
 delete mode 100644 arch/x86/kernel/pci-base_32.c
 create mode 100644 arch/x86/kernel/pci-nommu.c
 delete mode 100644 arch/x86/kernel/pci-nommu_64.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index befe901..b2a1358 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -25,9 +25,8 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
 obj-y			+= pci-dma_$(BITS).o  bootflag.o e820_$(BITS).o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
-obj-y			+= alternative.o i8253.o
-obj-$(CONFIG_X86_64)	+= pci-nommu_64.o bugs_64.o
-obj-$(CONFIG_X86_32)	+= pci-base_32.o
+obj-y			+= alternative.o i8253.o pci-nommu.o
+obj-$(CONFIG_X86_64)	+= bugs_64.o
 obj-y			+= tsc_$(BITS).o io_delay.o rtc.o
 
 obj-y				+= process.o
diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
deleted file mode 100644
index b44ea51..0000000
--- a/arch/x86/kernel/pci-base_32.c
+++ /dev/null
@@ -1,60 +0,0 @@
-#include <linux/mm.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/dma-mapping.h>
-#include <asm/dma-mapping.h>
-
-static dma_addr_t pci32_map_single(struct device *dev, phys_addr_t ptr,
-				   size_t size, int direction)
-{
-	WARN_ON(size == 0);
-	flush_write_buffers();
-	return ptr;
-}
-
-static int pci32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
-			    int nents, int direction)
-{
-	struct scatterlist *sg;
-	int i;
-
-	WARN_ON(nents == 0 || sglist[0].length == 0);
-
-	for_each_sg(sglist, sg, nents, i) {
-		BUG_ON(!sg_page(sg));
-
-		sg->dma_address = sg_phys(sg);
-		sg->dma_length = sg->length;
-	}
-
-	flush_write_buffers();
-	return nents;
-}
-
-/* Make sure we keep the same behaviour */
-static int pci32_map_error(dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-const struct dma_mapping_ops pci32_dma_ops = {
-	.map_single = pci32_map_single,
-	.unmap_single = NULL,
-	.map_sg = pci32_dma_map_sg,
-	.unmap_sg = NULL,
-	.sync_single_for_cpu = NULL,
-	.sync_single_for_device = NULL,
-	.sync_single_range_for_cpu = NULL,
-	.sync_single_range_for_device = NULL,
-	.sync_sg_for_cpu = NULL,
-	.sync_sg_for_device = NULL,
-	.mapping_error = pci32_map_error,
-};
-
-/* this is temporary */
-int __init no_iommu_init(void)
-{
-	dma_ops = &pci32_dma_ops;
-	return 0;
-}
-fs_initcall(no_iommu_init);
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d30634b..6b77fd8 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -7,6 +7,14 @@
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
+#ifdef CONFIG_IOMMU_DEBUG
+int panic_on_overflow __read_mostly = 1;
+int force_iommu __read_mostly = 1;
+#else
+int panic_on_overflow __read_mostly = 0;
+int force_iommu __read_mostly = 0;
+#endif
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index e95f671..4202130 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -27,14 +27,6 @@ EXPORT_SYMBOL(iommu_bio_merge);
 static int iommu_sac_force __read_mostly = 0;
 
 int no_iommu __read_mostly;
-#ifdef CONFIG_IOMMU_DEBUG
-int panic_on_overflow __read_mostly = 1;
-int force_iommu __read_mostly = 1;
-#else
-int panic_on_overflow __read_mostly = 0;
-int force_iommu __read_mostly= 0;
-#endif
-
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
new file mode 100644
index 0000000..aec43d5
--- /dev/null
+++ b/arch/x86/kernel/pci-nommu.c
@@ -0,0 +1,100 @@
+/* Fallback functions when the main IOMMU code is not compiled in. This
+   code is roughly equivalent to i386. */
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+
+#include <asm/gart.h>
+#include <asm/processor.h>
+#include <asm/dma.h>
+
+static int
+check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
+{
+	if (hwdev && bus + size > *hwdev->dma_mask) {
+		if (*hwdev->dma_mask >= DMA_32BIT_MASK)
+			printk(KERN_ERR
+			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
+				name, (long long)bus, size,
+				(long long)*hwdev->dma_mask);
+		return 0;
+	}
+	return 1;
+}
+
+static dma_addr_t
+nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
+	       int direction)
+{
+	dma_addr_t bus = paddr;
+	WARN_ON(size == 0);
+	if (!check_addr("map_single", hwdev, bus, size))
+				return bad_dma_address;
+	flush_write_buffers();
+	return bus;
+}
+
+
+/* Map a set of buffers described by scatterlist in streaming
+ * mode for DMA.  This is the scatter-gather version of the
+ * above pci_map_single interface.  Here the scatter gather list
+ * elements are each tagged with the appropriate dma address
+ * and length.  They are obtained via sg_dma_{address,length}(SG).
+ *
+ * NOTE: An implementation may be able to use a smaller number of
+ *       DMA address/length pairs than there are SG table elements.
+ *       (for example via virtual mapping capabilities)
+ *       The routine returns the number of addr/length pairs actually
+ *       used, at most nents.
+ *
+ * Device ownership issues as mentioned above for pci_map_single are
+ * the same here.
+ */
+static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
+	       int nents, int direction)
+{
+	struct scatterlist *s;
+	int i;
+
+	WARN_ON(nents == 0 || sg[0].length == 0);
+
+	for_each_sg(sg, s, nents, i) {
+		BUG_ON(!sg_page(s));
+		s->dma_address = sg_phys(s);
+		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
+			return 0;
+		s->dma_length = s->length;
+	}
+	flush_write_buffers();
+	return nents;
+}
+
+/* Make sure we keep the same behaviour */
+static int nommu_mapping_error(dma_addr_t dma_addr)
+{
+#ifdef CONFIG_X86_32
+	return 0;
+#else
+	return (dma_addr == bad_dma_address);
+#endif
+}
+
+
+const struct dma_mapping_ops nommu_dma_ops = {
+	.map_single = nommu_map_single,
+	.map_sg = nommu_map_sg,
+	.mapping_error = nommu_mapping_error,
+	.is_phys = 1,
+};
+
+void __init no_iommu_init(void)
+{
+	if (dma_ops)
+		return;
+
+	force_iommu = 0; /* no HW IOMMU */
+	dma_ops = &nommu_dma_ops;
+}
diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
deleted file mode 100644
index 8d036ae..0000000
--- a/arch/x86/kernel/pci-nommu_64.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/* Fallback functions when the main IOMMU code is not compiled in. This
-   code is roughly equivalent to i386. */
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/string.h>
-#include <linux/dma-mapping.h>
-#include <linux/scatterlist.h>
-
-#include <asm/gart.h>
-#include <asm/processor.h>
-#include <asm/dma.h>
-
-static int
-check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
-{
-        if (hwdev && bus + size > *hwdev->dma_mask) {
-		if (*hwdev->dma_mask >= DMA_32BIT_MASK)
-			printk(KERN_ERR
-			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
-				name, (long long)bus, size,
-				(long long)*hwdev->dma_mask);
-		return 0;
-	}
-	return 1;
-}
-
-static dma_addr_t
-nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
-	       int direction)
-{
-	dma_addr_t bus = paddr;
-	WARN_ON(size == 0);
-	if (!check_addr("map_single", hwdev, bus, size))
-				return bad_dma_address;
-	flush_write_buffers();
-	return bus;
-}
-
-
-/* Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scatter-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are
- * the same here.
- */
-static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
-	       int nents, int direction)
-{
-	struct scatterlist *s;
-	int i;
-
-	WARN_ON(nents == 0 || sg[0].length == 0);
-
-	for_each_sg(sg, s, nents, i) {
-		BUG_ON(!sg_page(s));
-		s->dma_address = sg_phys(s);
-		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
-			return 0;
-		s->dma_length = s->length;
-	}
-	flush_write_buffers();
-	return nents;
-}
-
-/* Make sure we keep the same behaviour */
-static int nommu_mapping_error(dma_addr_t dma_addr)
-{
-#ifdef CONFIG_X86_32
-	return 0;
-#else
-	return (dma_addr == bad_dma_address);
-#endif
-}
-
-
-const struct dma_mapping_ops nommu_dma_ops = {
-	.map_single = nommu_map_single,
-	.map_sg = nommu_map_sg,
-	.mapping_error = nommu_mapping_error,
-	.is_phys = 1,
-};
-
-void __init no_iommu_init(void)
-{
-	if (dma_ops)
-		return;
-
-	force_iommu = 0; /* no HW IOMMU */
-	dma_ops = &nommu_dma_ops;
-}
-- 
1.5.0.6

