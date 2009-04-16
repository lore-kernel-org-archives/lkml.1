Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbZDPRFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbZDPRFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZDPRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:05:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53573 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbZDPRFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:05:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Insert PCI root bus resources for the MB93090 devel
	motherboard
To: torvalds@osdl.org, akpm@linux-foundation.org, matthew@wil.cx
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 16 Apr 2009 18:04:20 +0100
Message-ID: <20090416170420.22108.34374.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Insert PCI root bus resources for the FRV-based MB93090 development kit
motherboard.  This is required because the CPU's window onto the PCI bus
address space is considerably smaller than the CPU's full address space and
non-PCI devices lie outside of the PCI window that we might want to access.

Without this patch, the PCI root bus uses the platform-level bus resources, and
these are then confined to the PCI window, thus making platform_device_add()
reject devices outside of this window.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mb93090-mb00/pci-vdk.c |   63 +++++++++++++++++++++++++++++++--------
 1 files changed, 50 insertions(+), 13 deletions(-)


diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index 0f41c3a..c0dcec6 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -31,6 +31,29 @@ struct pci_bus *__nongpreldata pci_root_bus;
 struct pci_ops *__nongpreldata pci_root_ops;
 
 /*
+ * The accessible PCI window does not cover the entire CPU address space, but
+ * there are devices we want to access outside of that window, so we need to
+ * insert specific PCI bus resources instead of using the platform-level bus
+ * resources directly for the PCI root bus.
+ *
+ * These are configured and inserted by pcibios_init() and are attached to the
+ * root bus by pcibios_fixup_bus().
+ */
+static struct resource pci_ioport_resource = {
+	.name	= "PCI IO",
+	.start	= 0,
+	.end	= IO_SPACE_LIMIT,
+	.flags	= IORESOURCE_IO,
+};
+
+static struct resource pci_iomem_resource = {
+	.name	= "PCI mem",
+	.start	= 0,
+	.end	= -1,
+	.flags	= IORESOURCE_MEM,
+};
+
+/*
  * Functions for accessing PCI configuration space
  */
 
@@ -304,6 +327,12 @@ void __init pcibios_fixup_bus(struct pci_bus *bus)
 #if 0
 	printk("### PCIBIOS_FIXUP_BUS(%d)\n",bus->number);
 #endif
+
+	if (bus->number == 0) {
+		bus->resource[0] = &pci_ioport_resource;
+		bus->resource[1] = &pci_iomem_resource;
+	}
+
 	pci_read_bridge_bases(bus);
 
 	if (bus->number == 0) {
@@ -350,28 +379,36 @@ int __init pcibios_init(void)
 	/* enable PCI arbitration */
 	__reg_MB86943_pci_arbiter	= MB86943_PCIARB_EN;
 
-	ioport_resource.start	= (__reg_MB86943_sl_pci_io_base << 9) & 0xfffffc00;
-	ioport_resource.end	= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
-	ioport_resource.end	+= ioport_resource.start;
+	pci_ioport_resource.start	= (__reg_MB86943_sl_pci_io_base << 9) & 0xfffffc00;
+	pci_ioport_resource.end		= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
+	pci_ioport_resource.end		+= pci_ioport_resource.start;
 
 	printk("PCI IO window:  %08llx-%08llx\n",
-	       (unsigned long long) ioport_resource.start,
-	       (unsigned long long) ioport_resource.end);
+	       (unsigned long long) pci_ioport_resource.start,
+	       (unsigned long long) pci_ioport_resource.end);
 
-	iomem_resource.start	= (__reg_MB86943_sl_pci_mem_base << 9) & 0xfffffc00;
+	pci_iomem_resource.start	= (__reg_MB86943_sl_pci_mem_base << 9) & 0xfffffc00;
+	pci_iomem_resource.end		= (__reg_MB86943_sl_pci_mem_range << 9) | 0x3ff;
+	pci_iomem_resource.end		+= pci_iomem_resource.start;
 
-	/* Reserve somewhere to write to flush posted writes. */
-	iomem_resource.start += 0x400;
-
-	iomem_resource.end	= (__reg_MB86943_sl_pci_mem_range << 9) | 0x3ff;
-	iomem_resource.end	+= iomem_resource.start;
+	/* Reserve somewhere to write to flush posted writes.  This is used by
+	 * __flush_PCI_writes() from asm/io.h to force the write FIFO in the
+	 * CPU-PCI bridge to flush as this doesn't happen automatically when a
+	 * read is performed on the MB93090 development kit motherboard.
+	 */
+	pci_iomem_resource.start	+= 0x400;
 
 	printk("PCI MEM window: %08llx-%08llx\n",
-	       (unsigned long long) iomem_resource.start,
-	       (unsigned long long) iomem_resource.end);
+	       (unsigned long long) pci_iomem_resource.start,
+	       (unsigned long long) pci_iomem_resource.end);
 	printk("PCI DMA memory: %08lx-%08lx\n",
 	       dma_coherent_mem_start, dma_coherent_mem_end);
 
+	if (insert_resource(&iomem_resource, &pci_iomem_resource) < 0)
+		panic("Unable to insert PCI IOMEM resource\n");
+	if (insert_resource(&ioport_resource, &pci_ioport_resource) < 0)
+		panic("Unable to insert PCI IOPORT resource\n");
+
 	if (!pci_probe)
 		return -ENXIO;
 

