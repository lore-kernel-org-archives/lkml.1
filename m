Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbYFSW6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbYFSW6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYFSW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:58:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37884 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbYFSW6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:58:08 -0400
Subject: [PATCH 2/2] acpi based pci gap caluculation
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Brown, Len" <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 19 Jun 2008 15:58:06 -0700
Message-Id: <1213916286.27983.37.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evaluates the _CRS object under PCI0 looking for producer resources.
Then searches the e820 memory space for a gap within these producer resources.

Allows us to find a gap for the unclaimed pci resources or MMIO resources
for hotplug devices within the BIOS allowed pci regions.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c	2008-06-13 13:58:53.000000000 -0700
+++ linux-2.6/arch/x86/pci/acpi.c	2008-06-13 14:10:05.000000000 -0700
@@ -4,6 +4,7 @@
 #include <linux/irq.h>
 #include <linux/dmi.h>
 #include <asm/numa.h>
+#include <asm/e820.h>
 #include "pci.h"
 
 struct pci_root_info {
@@ -14,6 +15,11 @@
 	int busnum;
 };
 
+struct gap_info {
+	unsigned long gapstart;
+	unsigned long gapsize;
+};
+
 static acpi_status
 resource_to_addr(struct acpi_resource *resource,
 			struct acpi_resource_address64 *addr)
@@ -110,6 +116,70 @@
 	}
 }
 
+static acpi_status search_gap(struct acpi_resource *resource, void *data)
+{
+	struct acpi_resource_address64 addr;
+	acpi_status status;
+	struct gap_info *gap = data;
+
+	status = resource_to_addr(resource, &addr);
+	if (ACPI_SUCCESS(status) &&
+	    addr.resource_type == ACPI_MEMORY_RANGE &&
+	    addr.address_length > gap->gapsize) {
+		e820_search_gap(&gap->gapstart, &gap->gapsize,
+				(addr.minimum + addr.translation_offset));
+	}
+
+	return AE_OK;
+}
+
+/*
+ * Search for a hole in the 32 bit address space for PCI to assign MMIO
+ * resources for hotplug or unconfigured resources.
+ * We query the CRS object of the PCI root device to look for possible producer
+ * resources in the tree and consider these while calulating the start address
+ * for this hole.
+ */
+static void pci_setup_gap(acpi_handle *handle)
+{
+	struct gap_info gap;
+	acpi_status status;
+
+	gap.gapstart = 0;
+	gap.gapsize = 0x400000;
+
+	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
+				     search_gap, &gap);
+
+	if (ACPI_SUCCESS(status)) {
+		unsigned long round;
+
+		if (!gap.gapstart) {
+			printk(KERN_ERR "ACPI_PCI: Warning: Cannot find a gap "
+					"in the 32bit address range\n"
+					"ACPI_PCI: May collide with the "
+					"hotpluggable memory address range\n");
+		}
+		/*
+		 * Round the gapstart, uses the same logic as in
+		 * e820_gap_setup
+		 */
+		round = 0x100000;
+		while ((gap.gapsize >> 4) > round)
+			round += round;
+		/* Fun with two's complement */
+		pci_mem_start = (gap.gapstart + round) & -round;
+
+		printk(KERN_INFO "ACPI_PCI: PCI resources should "
+				"start at %lx (gap: %lx:%lx)\n",
+				pci_mem_start, gap.gapstart, gap.gapsize);
+	} else {
+		printk(KERN_ERR "ACPI_PCI: Error while searching for gap in "
+				"the 32bit address range for PCI\n");
+	}
+}
+
+
 static void
 get_current_resources(struct acpi_device *device, int busnum,
 			int domain, struct pci_bus *bus)
@@ -215,6 +285,8 @@
 
 	if (bus && (pci_probe & PCI_USE__CRS))
 		get_current_resources(device, busnum, domain, bus);
+
+	pci_setup_gap(device->handle);
 	return bus;
 }
 


