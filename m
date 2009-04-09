Return-Path: <linux-kernel-owner+w=401wt.eu-S936362AbZDIU0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936362AbZDIU0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935371AbZDIU0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:26:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:48177 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934742AbZDIU0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:26:43 -0400
Date: Thu, 9 Apr 2009 15:25:00 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: jeremy@goop.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
In-Reply-To: <F46E8277-0165-4C4F-9DFE-7697881536C0@kernel.crashing.org>
Message-ID: <Pine.LNX.4.64.0904091524001.14308@localhost.localdomain>
References: <49DD270A.6060506@goop.org> <20090409080143C.fujita.tomonori@lab.ntt.co.jp>
 <4D1571C8-53B8-4A4E-BCE8-7267ED262189@kernel.crashing.org>
 <20090410035037U.fujita.tomonori@lab.ntt.co.jp>
 <F46E8277-0165-4C4F-9DFE-7697881536C0@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the WIP patch for the PPC changes to give some sense of what we
need out of swiotlb for PPC.

- k

---
 arch/powerpc/include/asm/dma-mapping.h     |   18 ++++
 arch/powerpc/include/asm/scatterlist.h     |    6 +-
 arch/powerpc/include/asm/swiotlb.h         |   15 +++
 arch/powerpc/kernel/Makefile               |    1 +
 arch/powerpc/kernel/dma-swiotlb.c          |  154 ++++++++++++++++++++++++++++
 arch/powerpc/kernel/dma.c                  |    2 +-
 arch/powerpc/kernel/pci-common.c           |    2 +
 arch/powerpc/kernel/setup_32.c             |    4 +
 10 files changed, 211 insertions(+), 7 deletions(-)
 create mode 100644 arch/powerpc/include/asm/swiotlb.h
 create mode 100644 arch/powerpc/kernel/dma-swiotlb.c

diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index c69f2b5..db6edfe 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -16,8 +16,18 @@
 #include <linux/dma-attrs.h>
 #include <asm/io.h>

+#ifdef CONFIG_SWIOTLB
+#include <asm/swiotlb.h>
+#endif
+
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)

+/* Some dma direct funcs must be visible for use in other dma_ops */
+extern void *dma_direct_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag);
+extern void dma_direct_free_coherent(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t dma_handle);
+
 #ifdef CONFIG_NOT_COHERENT_CACHE
 /*
  * DMA-consistent mapping functions for PowerPCs that don't support
@@ -112,11 +122,19 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 	if (unlikely(dev == NULL))
 		return NULL;

+	/* BGILL - temp code to look for problems */
+	if(dev->archdata.dma_ops == NULL)
+		printk(KERN_EMERG "dev %s has null dma_ops\n", dev->bus->name);
+
 	return dev->archdata.dma_ops;
 }

 static inline void set_dma_ops(struct device *dev, struct dma_mapping_ops *ops)
 {
+	printk(KERN_EMERG "Setting dma_ops to %s\n",
+	       (ops == &dma_direct_ops) ? "dma_direct_ops" :
+	       ((ops == &swiotlb_dma_ops) ? "swiotlb_dma_ops" : "unknown"));
+
 	dev->archdata.dma_ops = ops;
 }

diff --git a/arch/powerpc/include/asm/scatterlist.h b/arch/powerpc/include/asm/scatterlist.h
index fcf7d55..912bf59 100644
--- a/arch/powerpc/include/asm/scatterlist.h
+++ b/arch/powerpc/include/asm/scatterlist.h
@@ -21,7 +21,7 @@ struct scatterlist {
 	unsigned int offset;
 	unsigned int length;

-	/* For TCE support */
+	/* For TCE or SWIOTLB support */
 	dma_addr_t dma_address;
 	u32 dma_length;
 };
@@ -34,11 +34,7 @@ struct scatterlist {
  * is 0.
  */
 #define sg_dma_address(sg)	((sg)->dma_address)
-#ifdef __powerpc64__
 #define sg_dma_len(sg)		((sg)->dma_length)
-#else
-#define sg_dma_len(sg)		((sg)->length)
-#endif

 #ifdef __powerpc64__
 #define ISA_DMA_THRESHOLD	(~0UL)
diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/include/asm/swiotlb.h
new file mode 100644
index 0000000..cbfce6c
--- /dev/null
+++ b/arch/powerpc/include/asm/swiotlb.h
@@ -0,0 +1,15 @@
+#ifndef __ASM_SWIOTLB_H
+#define __ASM_SWIOTLB_H
+
+#include <linux/swiotlb.h>
+
+extern int swiotlb_force;
+extern int swiotlb;
+extern struct dma_mapping_ops swiotlb_dma_ops;
+
+int swiotlb_arch_address_needs_mapping(struct device *, dma_addr_t,
+				       size_t size);
+
+static inline void dma_mark_clean(void *addr, size_t size) {}
+
+#endif /* __ASM_SWIOTLB_H */
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 71901fb..34c0a95 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_PPC_UDBG_16550)	+= legacy_serial.o udbg_16550.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
+obj-$(CONFIG_SWIOTLB)		+= dma-swiotlb.o

 pci64-$(CONFIG_PPC64)		+= pci_dn.o isa-bridge.o
 obj-$(CONFIG_PCI)		+= pci_$(CONFIG_WORD_SIZE).o $(pci64-y) \
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
new file mode 100644
index 0000000..639f3bc
--- /dev/null
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -0,0 +1,154 @@
+/*
+ * Copyright (C) 2009 Becky Bruce, Freescale Semiconductor
+ *
+ * swiotlb dma ops and functions required by the swiotlb code.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/pfn.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include <asm/machdep.h>
+#include <asm/swiotlb.h>
+#include <asm/dma.h>
+#include <asm/abs_addr.h>
+
+int swiotlb __read_mostly;
+
+unsigned long get_dma_direct_offset(struct device *dev);
+
+void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t addr)
+{
+	unsigned long pfn = PFN_DOWN(swiotlb_bus_to_phys(hwdev, addr));
+	void *pageaddr = page_address(pfn_to_page(pfn));
+
+	if(pageaddr != NULL)
+		return pageaddr + (addr % PAGE_SIZE);
+	return NULL;
+}
+
+#if 0 /* BGILL - don't need */
+/* This can only be called on pages with a kernel mapping */
+dma_addr_t swiotlb_virt_to_bus(struct device *hwdev, void *addr)
+{
+	return swiotlb_phys_to_bus(hwdev, virt_to_abs((unsigned long)addr));
+}
+#endif
+
+dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
+{
+	return (paddr + get_dma_direct_offset(hwdev));
+}
+
+phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
+
+{
+	return (baddr - get_dma_direct_offset(hwdev));
+}
+
+/*
+ * Eventually, we should really be looking at some per-device
+ * quantity stored in archdata, and not a global value, since this is
+ * only needed for devices like PCI that use part of their 32 bit address
+ * space for something other than mapping memory.
+ *
+ * For now, require swiotlb mapping above MAX_32B_DIRECT_DMA_ADDR for devs
+ * that are not 64-bit capable.  This should be determined using the PCI mem
+ * allocations in the devtree. -beckyb
+ */
+#define MAX_32B_DIRECT_DMA_ADDR 0x80000000
+
+/* determine if an address needs bounce buffering via swiotlb. */
+int
+swiotlb_arch_address_needs_mapping(struct device *hwdev, dma_addr_t addr,
+				   size_t size)
+{
+	dma_addr_t mask = DMA_BIT_MASK(32);
+
+	/* Max dma_address we can access without bounce buffering */
+	dma_addr_t max = swiotlb_phys_to_bus(hwdev, MAX_32B_DIRECT_DMA_ADDR);
+
+	/* BGILL - can we get rid of this? */
+	if (hwdev && hwdev->dma_mask)
+		mask = *hwdev->dma_mask;
+
+	if ((mask <= DMA_BIT_MASK(36)) && (addr + size > max))
+		return 1;
+
+	return !is_buffer_dma_capable(mask, addr, size);
+}
+
+/*
+ * At the moment, all platforms that use this code only require
+ * swiotlb to be used if we're operating on HIGHMEM.  Since
+ * we don't ever call anything other than map_sg, unmap_sg,
+ * map_page, and unmap_page on highmem, use normal dma_ops
+ * for everything else.
+ */
+struct dma_mapping_ops swiotlb_dma_ops = {
+#if 0
+	.alloc_coherent = dma_direct_alloc_coherent,
+	.free_coherent = dma_direct_free_coherent,
+#else
+	.alloc_coherent = swiotlb_alloc_coherent,
+	.free_coherent = swiotlb_free_coherent,
+#endif
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
+	.dma_supported = swiotlb_dma_supported,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
+	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
+	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
+	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = swiotlb_sync_sg_for_device
+};
+
+static int ppc_swiotlb_bus_notify(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct device *dev = data;
+
+	/* We are only intereted in device addition */
+	if (action != BUS_NOTIFY_ADD_DEVICE)
+		return 0;
+
+#if 0 /* BGILL - should look like this; use other form for debug */
+	if(dma_get_mask(dev) < DMA_BIT_MASK(36))
+		set_dma_ops(dev, &swiotlb_dma_ops);
+#else
+	if(!dev->dma_mask) {
+		printk(KERN_EMERG "ERROR: no dma_mask set for dev\n");
+		set_dma_ops(dev, &swiotlb_dma_ops);
+	}
+	else if(*dev->dma_mask < DMA_BIT_MASK(36)) {
+		set_dma_ops(dev, &swiotlb_dma_ops);
+	}
+	else
+		printk(KERN_EMERG "ERROR; fall thru with direct_ops\n");
+#endif
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ppc_swiotlb_plat_bus_notifier = {
+	.notifier_call = ppc_swiotlb_bus_notify,
+	.priority = 0,
+};
+
+static struct notifier_block ppc_swiotlb_of_bus_notifier = {
+	.notifier_call = ppc_swiotlb_bus_notify,
+	.priority = 0,
+};
+
+static int __init setup_bus_notifier(void)
+{
+	bus_register_notifier(&platform_bus_type, &ppc_swiotlb_plat_bus_notifier);
+	bus_register_notifier(&of_platform_bus_type, &ppc_swiotlb_of_bus_notifier);
+
+	return 0;
+}
+
+machine_arch_initcall(mpc86xx_hpcn, setup_bus_notifier);
+
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 53c7788..62d80c4 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -19,7 +19,7 @@
  * default the offset is PCI_DRAM_OFFSET.
  */

-static unsigned long get_dma_direct_offset(struct device *dev)
+unsigned long get_dma_direct_offset(struct device *dev)
 {
 	if (dev)
 		return (unsigned long)dev->archdata.dma_data;
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 9e1ca74..f038b13 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -332,6 +332,10 @@ void __init setup_arch(char **cmdline_p)
 		ppc_md.setup_arch();
 	if ( ppc_md.progress ) ppc_md.progress("arch: exit", 0x3eab);

+	/* Allow iotlb to do it's setup */
+#ifdef CONFIG_SWIOTLB
+	swiotlb_init();
+#endif
 	paging_init();

 	/* Initialize the MMU context management stuff */
