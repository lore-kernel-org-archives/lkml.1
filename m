Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbXITQly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbXITQly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbXITQlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:41:47 -0400
Received: from sa2.bezeqint.net ([192.115.104.16]:41561 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbXITQlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:41:45 -0400
X-Greylist: delayed 1778 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 12:41:45 EDT
Message-ID: <46F29A0A.4000407@compulab.co.il>
Date: Thu, 20 Sep 2007 18:04:26 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.6 (X11/20070822)
MIME-Version: 1.0
To: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/03] CM-x270: ITE 8152 PCI bridge support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides driver for ITE 8152 PCI bridge.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

 arch/arm/common/Makefile          |    1 +
 arch/arm/common/it8152.c          |  387 +++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/bios32.c          |   28 +++-
 include/asm-arm/hardware/it8152.h |   99 ++++++++++
 include/asm-arm/pci.h             |    7 +
 include/linux/pci_ids.h           |    1 +
 6 files changed, 520 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index e1289a2..3d0b9fa 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_SHARPSL_PM)	+= sharpsl_pm.o
 obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
 obj-$(CONFIG_ARCH_IXP2000)	+= uengine.o
 obj-$(CONFIG_ARCH_IXP23XX)	+= uengine.o
+obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
new file mode 100644
index 0000000..c03de9b
--- /dev/null
+++ b/arch/arm/common/it8152.c
@@ -0,0 +1,387 @@
+/*
+ * linux/arch/arm/common/it8152.c
+ *
+ * Copyright Compulab Ltd, 2002-2007
+ * Mike Rapoport <mike@compulab.co.il>
+ *
+ * The DMA bouncing part is taken from arch/arm/mach-ixp4xx/common-pci.c
+ * (see this file for respective copyrights)
+ *
+ * Thanks to Guennadi Liakhovetski <gl@dsa-ac.de> for IRQ enumberation
+ * and demux code.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/ptrace.h>
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+
+#include <asm/mach/pci.h>
+#include <asm/hardware/it8152.h>
+
+#define MAX_SLOTS		21
+
+static void it8152_mask_irq(unsigned int irq)
+{
+       if (irq >= IT8152_LD_IRQ(0)) {
+	       __raw_writel((__raw_readl(IT8152_INTC_LDCNIMR) |
+			    (1 << (irq - IT8152_LD_IRQ(0)))),
+			    IT8152_INTC_LDCNIMR);
+       } else if (irq >= IT8152_LP_IRQ(0)) {
+	       __raw_writel((__raw_readl(IT8152_INTC_LPCNIMR) |
+			    (1 << (irq - IT8152_LP_IRQ(0)))),
+			    IT8152_INTC_LPCNIMR);
+       } else if (irq >= IT8152_PD_IRQ(0)) {
+	       __raw_writel((__raw_readl(IT8152_INTC_PDCNIMR) |
+			    (1 << (irq - IT8152_PD_IRQ(0)))),
+			    IT8152_INTC_PDCNIMR);
+       }
+}
+
+static void it8152_unmask_irq(unsigned int irq)
+{
+       if (irq >= IT8152_LD_IRQ(0)) {
+	       __raw_writel((__raw_readl(IT8152_INTC_LDCNIMR) &
+			     ~(1 << (irq - IT8152_LD_IRQ(0)))),
+			    IT8152_INTC_LDCNIMR);
+       } else if (irq >= IT8152_LP_IRQ(0)) {
+	       __raw_writel((__raw_readl(IT8152_INTC_LPCNIMR) &
+			     ~(1 << (irq - IT8152_LP_IRQ(0)))),
+			    IT8152_INTC_LPCNIMR);
+       } else if (irq >= IT8152_PD_IRQ(0)) {
+	       __raw_writel((__raw_readl(IT8152_INTC_PDCNIMR) &
+			     ~(1 << (irq - IT8152_PD_IRQ(0)))),
+			    IT8152_INTC_PDCNIMR);
+       }
+}
+
+static inline void it8152_irq(int irq)
+{
+	struct irq_desc *desc;
+
+	printk(KERN_DEBUG "===> %s: irq=%d\n", __FUNCTION__, irq);
+
+	desc = irq_desc + irq;
+	desc_handle_irq(irq, desc);
+}
+
+static struct irq_chip it8152_irq_chip = {
+	.name		= "it8152",
+	.ack		= it8152_mask_irq,
+	.mask		= it8152_mask_irq,
+	.unmask		= it8152_unmask_irq,
+};
+
+void it8152_init_irq(void)
+{
+	int irq;
+
+	__raw_writel((0xffff), IT8152_INTC_PDCNIMR);
+	__raw_writel((0), IT8152_INTC_PDCNIRR);
+	__raw_writel((0xffff), IT8152_INTC_LPCNIMR);
+	__raw_writel((0), IT8152_INTC_LPCNIRR);
+	__raw_writel((0xffff), IT8152_INTC_LDCNIMR);
+	__raw_writel((0), IT8152_INTC_LDCNIRR);
+
+	for (irq = IT8152_IRQ(0); irq <= IT8152_LAST_IRQ; irq++) {
+		set_irq_chip(irq, &it8152_irq_chip);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+}
+
+void it8152_irq_demux(unsigned int irq, struct irq_desc *desc)
+{
+       int bits_pd, bits_lp, bits_ld;
+       int i;
+
+       printk(KERN_DEBUG "=> %s: irq = %d\n", __FUNCTION__, irq);
+
+       while (1) {
+	       /* Read all */
+	       bits_pd = __raw_readl(IT8152_INTC_PDCNIRR);
+	       bits_lp = __raw_readl(IT8152_INTC_LPCNIRR);
+	       bits_ld = __raw_readl(IT8152_INTC_LDCNIRR);
+
+	       /* Ack */
+	       __raw_writel((~bits_pd), IT8152_INTC_PDCNIRR);
+	       __raw_writel((~bits_lp), IT8152_INTC_LPCNIRR);
+	       __raw_writel((~bits_ld), IT8152_INTC_LDCNIRR);
+
+	       if (!(bits_ld | bits_lp | bits_pd)) {
+		       /* Re-read to guarantee, that there was a moment of
+			  time, when they all three were 0. */
+		       bits_pd = __raw_readl(IT8152_INTC_PDCNIRR);
+		       bits_lp = __raw_readl(IT8152_INTC_LPCNIRR);
+		       if (!(bits_ld | bits_lp | bits_pd))
+			       return;
+	       }
+
+	       bits_pd &= ((1 << IT8152_PD_IRQ_COUNT) - 1);
+	       while (bits_pd) {
+		       i = __ffs(bits_pd);
+		       it8152_irq(IT8152_PD_IRQ(i));
+		       bits_pd &= ~(1 << i);
+	       }
+
+	       bits_lp &= ((1 << IT8152_LP_IRQ_COUNT) - 1);
+	       while (bits_lp) {
+		       i = __ffs(bits_pd);
+		       it8152_irq(IT8152_LP_IRQ(i));
+		       bits_lp &= ~(1 << i);
+	       }
+
+	       bits_ld &= ((1 << IT8152_LD_IRQ_COUNT) - 1);
+	       while (bits_ld) {
+		       i = __ffs(bits_pd);
+		       it8152_irq(IT8152_LD_IRQ(i));
+		       bits_ld &= ~(1 << i);
+	       }
+       }
+}
+
+/* mapping for on-chip devices */
+int __init it8152_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+{
+	if ((dev->vendor == PCI_VENDOR_ID_ITE) &&
+	    (dev->device == PCI_DEVICE_ID_ITE_8152)) {
+		if ((dev->class >> 8) == PCI_CLASS_MULTIMEDIA_AUDIO)
+			return IT8152_AUDIO_INT;
+		if ((dev->class >> 8) == PCI_CLASS_SERIAL_USB)
+			return IT8152_USB_INT;
+		if ((dev->class >> 8) == PCI_CLASS_SYSTEM_DMA)
+			return IT8152_CDMA_INT;
+	}
+
+	return 0;
+}
+
+static unsigned long it8152_pci_dev_base_address(struct pci_bus *bus,
+						 unsigned int devfn)
+{
+	unsigned long addr = 0;
+
+	if (bus->number == 0) {
+			if (devfn < PCI_DEVFN(MAX_SLOTS, 0))
+				addr = (devfn << 8);
+	} else
+		addr = (bus->number << 16) | (devfn << 8);
+
+	return addr;
+}
+
+static int it8152_pci_read_config(struct pci_bus *bus,
+				  unsigned int devfn, int where,
+				  int size, u32 *value)
+{
+	unsigned long addr = it8152_pci_dev_base_address(bus, devfn);
+	u32 v;
+	int shift;
+
+	shift = (where & 3);
+
+	__raw_writel((addr + where), IT8152_PCI_CFG_ADDR);
+	v = (__raw_readl(IT8152_PCI_CFG_DATA)  >> (8 * (shift)));
+
+	*value = v;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int it8152_pci_write_config(struct pci_bus *bus,
+				   unsigned int devfn, int where,
+				   int size, u32 value)
+{
+	unsigned long addr = it8152_pci_dev_base_address(bus, devfn);
+	u32 v, vtemp, mask = 0;
+	int shift;
+
+	if (size == 1)
+		mask = 0xff;
+	if (size == 2)
+		mask = 0xffff;
+
+	shift = (where & 3);
+
+	__raw_writel((addr + where), IT8152_PCI_CFG_ADDR);
+	vtemp = __raw_readl(IT8152_PCI_CFG_DATA);
+
+	if (mask)
+		vtemp &= ~(mask << (8 * shift));
+	else
+		vtemp = 0;
+
+	v = (value << (8 * shift));
+	__raw_writel((addr + where), IT8152_PCI_CFG_ADDR);
+	__raw_writel((v | vtemp), IT8152_PCI_CFG_DATA);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static struct pci_ops it8152_ops = {
+	.read = it8152_pci_read_config,
+	.write = it8152_pci_write_config,
+};
+
+static struct resource it8152_io = {
+	.name	= "IT8152 PCI I/O region",
+	.flags	= IORESOURCE_IO,
+};
+
+static struct resource it8152_mem = {
+	.name	= "IT8152 PCI memory region",
+	.start	= 0x10000000,
+	.end	= 0x13e00000,
+	.flags	= IORESOURCE_MEM,
+};
+
+/*
+ * The following functions are needed for DMA bouncing.
+ * ITE8152 chip can addrees up to 64MByte, so all the devices
+ * connected to ITE8152 (PCI and USB) should have limited DMA window
+ */
+
+/*
+ * Setup DMA mask to 64MB on devices connected to ITE8152. Ignore all
+ * other devices.
+ */
+static int it8152_pci_platform_notify(struct device *dev)
+{
+	if (dev->bus == &pci_bus_type) {
+		if (dev->dma_mask)
+			*dev->dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
+		dev->coherent_dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
+		dmabounce_register_dev(dev, 2048, 4096);
+	}
+	return 0;
+}
+
+static int it8152_pci_platform_notify_remove(struct device *dev)
+{
+	if (dev->bus == &pci_bus_type)
+		dmabounce_unregister_dev(dev);
+
+	return 0;
+}
+
+int dma_needs_bounce(struct device *dev, dma_addr_t dma_addr, size_t size)
+{
+	dev_dbg(dev, "%s: dma_addr %08x, size %08x\n",
+		__FUNCTION__, dma_addr, size);
+	return (dev->bus == &pci_bus_type) &&
+		((dma_addr + size - PHYS_OFFSET) >= SZ_64M);
+}
+
+/*
+ * We override these so we properly do dmabounce otherwise drivers
+ * are able to set the dma_mask to 0xffffffff and we can no longer
+ * trap bounces. :(
+ *
+ * We just return true on everyhing except for < 64MB in which case
+ * we will fail miseralby and die since we can't handle that case.
+ */
+int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	printk(KERN_DEBUG "%s: %s %llx\n",
+	       __FUNCTION__, dev->dev.bus_id, mask);
+	if (mask >= PHYS_OFFSET + SZ_64M - 1)
+		return 0;
+
+	return -EIO;
+}
+
+int
+pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
+{
+	printk(KERN_DEBUG "%s: %s %llx\n",
+	       __FUNCTION__, dev->dev.bus_id, mask);
+	if (mask >= PHYS_OFFSET + SZ_64M - 1)
+		return 0;
+
+	return -EIO;
+}
+
+int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
+{
+	it8152_io.start = IT8152_IO_BASE + 0x12000;
+	it8152_io.end	= IT8152_IO_BASE + 0x12000 + 0x100000;
+
+	sys->mem_offset = 0x10000000;
+	sys->io_offset  = IT8152_IO_BASE;
+
+	if (request_resource(&ioport_resource, &it8152_io)) {
+		printk(KERN_ERR "PCI: unable to allocate IO region\n");
+		goto err0;
+	}
+	if (request_resource(&iomem_resource, &it8152_mem)) {
+		printk(KERN_ERR "PCI: unable to allocate memory region\n");
+		goto err1;
+	}
+
+	sys->resource[0] = &it8152_io;
+	sys->resource[1] = &it8152_mem;
+
+	if (platform_notify || platform_notify_remove) {
+		printk(KERN_ERR "PCI: Can't use platform_notify\n");
+		goto err2;
+	}
+
+	platform_notify = it8152_pci_platform_notify;
+	platform_notify_remove = it8152_pci_platform_notify_remove;
+
+	return 1;
+
+err2:
+	release_resource(&it8152_io);
+err1:
+	release_resource(&it8152_mem);
+err0:
+	return -EBUSY;
+}
+
+/*
+ * If we set up a device for bus mastering, we need to check the latency
+ * timer as we don't have even crappy BIOSes to set it properly.
+ * The implementation is from arch/i386/pci/i386.c
+ */
+unsigned int pcibios_max_latency = 255;
+
+void pcibios_set_master(struct pci_dev *dev)
+{
+	u8 lat;
+
+	/* no need to update on-chip OHCI controller */
+	if ((dev->vendor == PCI_VENDOR_ID_ITE) &&
+	    (dev->device == PCI_DEVICE_ID_ITE_8152) &&
+	    ((dev->class >> 8) == PCI_CLASS_SERIAL_USB))
+		return;
+
+	pci_read_config_byte(dev, PCI_LATENCY_TIMER, &lat);
+	if (lat < 16)
+		lat = (64 <= pcibios_max_latency) ? 64 : pcibios_max_latency;
+	else if (lat > pcibios_max_latency)
+		lat = pcibios_max_latency;
+	else
+		return;
+	printk(KERN_DEBUG "PCI: Setting latency timer of device %s to %d\n",
+	       pci_name(dev), lat);
+	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
+}
+
+
+struct pci_bus * __init it8152_pci_scan_bus(int nr, struct pci_sys_data *sys)
+{
+	return pci_scan_bus(nr, &it8152_ops, sys);
+}
+
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 240c448..cba32ee 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -279,6 +279,25 @@ static void __devinit pci_fixup_cy82c693(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693, pci_fixup_cy82c693);

+static void __init pci_fixup_it8152(struct pci_dev *dev)
+{
+	int i;
+	/* fixup for ITE 8152 devices */
+	/* FIXME: add defines for class 0x68000 and 0x80103 */
+	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
+	    dev->class == 0x68000 ||
+	    dev->class == 0x80103) {
+		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+			dev->resource[i].start = 0;
+			dev->resource[i].end   = 0;
+			dev->resource[i].flags = 0;
+		}
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8152, pci_fixup_it8152);
+
+
+
 void __devinit pcibios_update_irq(struct pci_dev *dev, int irq)
 {
 	if (debug_pci)
@@ -292,9 +311,12 @@ void __devinit pcibios_update_irq(struct pci_dev *dev, int irq)
  */
 static inline int pdev_bad_for_parity(struct pci_dev *dev)
 {
-	return (dev->vendor == PCI_VENDOR_ID_INTERG &&
-		(dev->device == PCI_DEVICE_ID_INTERG_2000 ||
-		 dev->device == PCI_DEVICE_ID_INTERG_2010));
+	return ((dev->vendor == PCI_VENDOR_ID_INTERG &&
+		 (dev->device == PCI_DEVICE_ID_INTERG_2000 ||
+		  dev->device == PCI_DEVICE_ID_INTERG_2010)) ||
+		(dev->vendor == PCI_VENDOR_ID_ITE &&
+		 dev->device == PCI_DEVICE_ID_ITE_8152));
+
 }

 /*
diff --git a/include/asm-arm/hardware/it8152.h b/include/asm-arm/hardware/it8152.h
new file mode 100644
index 0000000..aaebb61
--- /dev/null
+++ b/include/asm-arm/hardware/it8152.h
@@ -0,0 +1,99 @@
+/*
+ * linux/include/arm/hardware/it8152.h
+ *
+ * Copyright Compulab Ltd., 2006,2007
+ * Mike Rapoport <mike@compulab.co.il>
+ *
+ * ITE 8152 companion chip register definitions
+ */
+
+#ifndef __ASM_HARDWARE_IT8152_H
+#define __ASM_HARDWARE_IT8152_H
+extern unsigned long it8152_base_address;
+
+#define IT8152_IO_BASE			(it8152_base_address + 0x03e00000)
+#define IT8152_CFGREG_BASE		(it8152_base_address + 0x03f00000)
+
+#define __REG_IT8152(x)			(it8152_base_address + (x))
+
+#define IT8152_PCI_CFG_ADDR		__REG_IT8152(0x3f00800)
+#define IT8152_PCI_CFG_DATA		__REG_IT8152(0x3f00804)
+
+#define IT8152_INTC_LDCNIRR		__REG_IT8152(0x3f00300)
+#define IT8152_INTC_LDPNIRR		__REG_IT8152(0x3f00304)
+#define IT8152_INTC_LDCNIMR		__REG_IT8152(0x3f00308)
+#define IT8152_INTC_LDPNIMR		__REG_IT8152(0x3f0030C)
+#define IT8152_INTC_LDNITR		__REG_IT8152(0x3f00310)
+#define IT8152_INTC_LDNIAR		__REG_IT8152(0x3f00314)
+#define IT8152_INTC_LPCNIRR		__REG_IT8152(0x3f00320)
+#define IT8152_INTC_LPPNIRR		__REG_IT8152(0x3f00324)
+#define IT8152_INTC_LPCNIMR		__REG_IT8152(0x3f00328)
+#define IT8152_INTC_LPPNIMR		__REG_IT8152(0x3f0032C)
+#define IT8152_INTC_LPNITR		__REG_IT8152(0x3f00330)
+#define IT8152_INTC_LPNIAR		__REG_IT8152(0x3f00334)
+#define IT8152_INTC_PDCNIRR		__REG_IT8152(0x3f00340)
+#define IT8152_INTC_PDPNIRR		__REG_IT8152(0x3f00344)
+#define IT8152_INTC_PDCNIMR		__REG_IT8152(0x3f00348)
+#define IT8152_INTC_PDPNIMR		__REG_IT8152(0x3f0034C)
+#define IT8152_INTC_PDNITR		__REG_IT8152(0x3f00350)
+#define IT8152_INTC_PDNIAR		__REG_IT8152(0x3f00354)
+#define IT8152_INTC_INTC_TYPER		__REG_IT8152(0x3f003FC)
+
+#define IT8152_GPIO_GPDR		__REG_IT8152(0x3f00500)
+
+/*
+  Interrup contoler per register summary:
+  ---------------------------------------
+  LCDNIRR:
+  IT8152_LD_IRQ(8) PCICLK stop
+  IT8152_LD_IRQ(7) MCLK ready
+  IT8152_LD_IRQ(6) s/w
+  IT8152_LD_IRQ(5) UART
+  IT8152_LD_IRQ(4) GPIO
+  IT8152_LD_IRQ(3) TIMER 4
+  IT8152_LD_IRQ(2) TIMER 3
+  IT8152_LD_IRQ(1) TIMER 2
+  IT8152_LD_IRQ(0) TIMER 1
+
+  LPCNIRR:
+  IT8152_LP_IRQ(x) serial IRQ x
+
+  PCIDNIRR:
+  IT8152_PD_IRQ(14) PCISERR
+  IT8152_PD_IRQ(13) CPU/PCI bridge target abort (h2pTADR)
+  IT8152_PD_IRQ(12) CPU/PCI bridge master abort (h2pMADR)
+  IT8152_PD_IRQ(11) PCI INTD
+  IT8152_PD_IRQ(10) PCI INTC
+  IT8152_PD_IRQ(9)  PCI INTB
+  IT8152_PD_IRQ(8)  PCI INTA
+  IT8152_PD_IRQ(7)  serial INTD
+  IT8152_PD_IRQ(6)  serial INTC
+  IT8152_PD_IRQ(5)  serial INTB
+  IT8152_PD_IRQ(4)  serial INTA
+  IT8152_PD_IRQ(3)  serial IRQ IOCHK (IOCHKR)
+  IT8152_PD_IRQ(2)  chaining DMA (CDMAR)
+  IT8152_PD_IRQ(1)  USB (USBR)
+  IT8152_PD_IRQ(0)  Audio controller (ACR)
+ */
+/* frequently used interrupts */
+#define IT8152_PCISERR		IT8152_PD_IRQ(14)
+#define IT8152_H2PTADR		IT8152_PD_IRQ(13)
+#define IT8152_H2PMAR		IT8152_PD_IRQ(12)
+#define IT8152_PCI_INTD		IT8152_PD_IRQ(11)
+#define IT8152_PCI_INTC		IT8152_PD_IRQ(10)
+#define IT8152_PCI_INTB		IT8152_PD_IRQ(9)
+#define IT8152_PCI_INTA		IT8152_PD_IRQ(8)
+#define IT8152_CDMA_INT		IT8152_PD_IRQ(2)
+#define IT8152_USB_INT		IT8152_PD_IRQ(1)
+#define IT8152_AUDIO_INT	IT8152_PD_IRQ(0)
+
+struct pci_dev;
+struct pci_sys_data;
+
+extern void it8152_irq_demux(unsigned int irq, struct irq_desc *desc);
+extern void it8152_init_irq(void);
+extern int it8152_pci_map_irq(struct pci_dev *dev, u8 slot, u8 pin);
+extern int it8152_pci_setup(int nr, struct pci_sys_data *sys);
+extern struct pci_bus *it8152_pci_scan_bus(int nr, struct pci_sys_data *sys);
+
+#endif /* __ASM_HARDWARE_IT8152_H */
diff --git a/include/asm-arm/pci.h b/include/asm-arm/pci.h
index ed3f898..75feb15 100644
--- a/include/asm-arm/pci.h
+++ b/include/asm-arm/pci.h
@@ -8,10 +8,17 @@

 #define pcibios_scan_all_fns(a, b)	0

+#ifdef CONFIG_PCI_HOST_ITE8152
+/* ITE bridge requires setting latency timer to avoid early bus access
+   termination by PIC bus mater devices
+*/
+extern void pcibios_set_master(struct pci_dev *dev);
+#else
 static inline void pcibios_set_master(struct pci_dev *dev)
 {
 	/* No special bus mastering setup handling */
 }
+#endif

 static inline void pcibios_penalize_isa_irq(int irq, int active)
 {
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 55f307f..357390d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1629,6 +1629,7 @@
 #define PCI_DEVICE_ID_ITE_8211		0x8211
 #define PCI_DEVICE_ID_ITE_8212		0x8212
 #define PCI_DEVICE_ID_ITE_8213		0x8213
+#define PCI_DEVICE_ID_ITE_8152		0x8152
 #define PCI_DEVICE_ID_ITE_8872		0x8872
 #define PCI_DEVICE_ID_ITE_IT8330G_0	0xe886



