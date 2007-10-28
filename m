Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbXJ1R1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbXJ1R1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXJ1R1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:27:02 -0400
Received: from outbound.mse10.exchange.ms ([216.52.164.190]:20088 "EHLO
	outbound.mse10.exchange.ms" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXJ1R1A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:27:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Align PCI memory regions to page size (4K) - Fix
Date: Sun, 28 Oct 2007 13:27:27 -0400
Message-ID: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Align PCI memory regions to page size (4K) - Fix
Thread-Index: AcgZh3iv/F1Iu1LlTpmihw/J4FvvKAAAA1Ag
From: "Barak Fargoun" <barak@neocleus.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>
Cc: <gregkh@suse.de>, "Barak Fargoun" <barak@neocleus.com>,
       "Guy Zana" <guy@neocleus.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, my mail client corrupted the previous mail containing the patch... it should be ok now...

Add a boot parameter (‘pci-mem-align’) which forces PCI memory regions to be aligned to 4K. 

This is very useful when developing an hypervisor, since in case we want to let native domains direct access to specific hardware, we don’t want PCI devices to share their memory region page with other devices. In Xen for example, PCI devices mmio resources are mapped by remapping complete pages (by Intel VT-d & the Neocleus pass-through patch for Xen).

Signed-off-by: Barak Fargoun     (barak@neocleus.com)
---
Kernel version: 2.6.18	(since this is the kernel version used in Xen for Dom-0)
---
diff -r 840b9df48b6a drivers/pci/bus.c
--- a/drivers/pci/bus.c	Tue Aug 07 09:37:41 2007 +0100
+++ b/drivers/pci/bus.c	Sun Oct 28 08:40:52 2007 -0400
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 
 #include "pci.h"
+
+extern int pci_mem_align;
 
 /**
  * pci_bus_alloc_resource - allocate a resource from a parent bus
@@ -43,6 +45,15 @@ pci_bus_alloc_resource(struct pci_bus *b
 	int i, ret = -ENOMEM;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
+
+	/* if the boot parameter 'pci-mem-align' was specified, then we need to 
+		align the memory addresses, at page size alignment  */
+	if (pci_mem_align)
+	{
+		/* we change only alignments which are smaller than page size */
+		if (align < (PAGE_SIZE-1))
+			align = PAGE_SIZE - 1;
+	}
 
 	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
 		struct resource *r = bus->resource[i];
diff -r 840b9df48b6a drivers/pci/quirks.c
--- a/drivers/pci/quirks.c	Tue Aug 07 09:37:41 2007 +0100
+++ b/drivers/pci/quirks.c	Sun Oct 28 08:40:52 2007 -0400
@@ -22,6 +22,54 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include "pci.h"
+
+/* a global flag, which signals if we should align PCI mem windows to 4K */
+int pci_mem_align = 0;
+
+/* this function is called, if the 'pci-mem-align' was specified as a boot
+		parameter. Used to force the kernel to align PCI mem windows to 4k */
+static int __init set_pci_mem_align(char *str)
+{
+	pci_mem_align = 1;
+	return 1;
+}
+__setup("pci-mem-align", set_pci_mem_align);
+
+/*	
+	This quirk function enables us to force all memory resources which are 
+		assigned to PCI devices, to be aligned at a page size. This 
+		fetaurs helps us in xen when running native domains
+*/
+static void __devinit quirk_xen_align_mem_resources(struct pci_dev *dev)
+{
+	int i;
+	struct resource *r;
+
+	/* if the boot parameter 'pci-mem-align' wasn't specified, then no need
+		to align the memory addresses */
+	if (pci_mem_align == 0)
+		return;
+
+	for (i=0; i < DEVICE_COUNT_RESOURCE; ++i) {
+		r = &dev->resource[i];
+
+		if (r == NULL)
+			continue;
+
+		/* we need to adjust only memory resources */
+		if (r->flags & IORESOURCE_MEM) {
+			/* align the start address in page size alignment alignment (round up) */
+			resource_size_t old_start = r->start;
+			r->start = (r->start + (PAGE_SIZE-1))  & (~(PAGE_SIZE-1));
+
+			/* update the end address, so that the region size will not be 
+				affected */
+			r->end = r->end - (old_start - r->start);
+		}
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, quirk_xen_align_mem_resources);
+
 
 /* The Mellanox Tavor device gives false positive parity errors
  * Mark this device with a broken_parity_status, to allow
