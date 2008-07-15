Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYGOTAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYGOTAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762243AbYGOS7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:59:45 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:35035 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761971AbYGOS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:59:43 -0400
Subject: acpi based pci gap calculation  - v3
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: ak@linux.intel.com, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 15 Jul 2008 11:59:42 -0700
Message-Id: <1216148382.6135.21.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andi,

I don't see this patch being applied in any of the tree yet.
Resending this incase you guys might have missed it. 
I assume this will go through the ACPI tree. 

The need for this patch was explained in 
http://marc.info/?l=linux-kernel&m=121441818818598&w=2

The v2 patch was discussed in 
http://marc.info/?l=linux-acpi&m=121433339619175&w=2

I then sent a incremental patch on top of v2 to fix some conditions and
handle the change in the e820_search_gap interface. 

In this v3 patch, i have folded the incremental fix into the v2 patch.
Please apply this.

Thanks,
Alok

--
acpi based pci gap calculation - v3

From: Alok N Kataria <akataria@vmware.com>

Evaluates the _CRS object under PCI0 looking for producer resources.
Then searches the e820 memory space for a gap within these producer resources.

Allows us to find a gap for the unclaimed pci resources or MMIO resources
for hotplug devices within the BIOS allowed pci regions.

v1->v2: Some changes in the print strings.
    	Also note the prototype for e820_search_gap has changed in this
    	iteration, but the return value is ignored while calling it over here.
v2->v3: Pass the pci producer resources end_addr (got from _CRS) to the
	e820_search_gap function.
	We limit the search only within the producer region's address space.
	Also add a condition to check if the resource lies in the 32bit
	address range.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/pci/acpi.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 80 insertions(+), 0 deletions(-)


diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 19af069..fff2c42 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -4,6 +4,7 @@
 #include <linux/irq.h>
 #include <linux/dmi.h>
 #include <asm/numa.h>
+#include <asm/e820.h>
 #include "pci.h"
 
 struct pci_root_info {
@@ -14,6 +15,11 @@ struct pci_root_info {
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
@@ -110,6 +116,78 @@ adjust_transparent_bridge_resources(struct pci_bus *bus)
 	}
 }
 
+static acpi_status search_gap(struct acpi_resource *resource, void *data)
+{
+	struct acpi_resource_address64 addr;
+	acpi_status status;
+	struct gap_info *gap = data;
+	unsigned long long start_addr, end_addr;
+
+	status = resource_to_addr(resource, &addr);
+	if (ACPI_SUCCESS(status) &&
+	    addr.resource_type == ACPI_MEMORY_RANGE &&
+	    addr.address_length > gap->gapsize) {
+		start_addr = addr.minimum + addr.translation_offset;
+		/*
+		 * We want space only in the 32bit address range
+		 */
+		if (start_addr < UINT_MAX) {
+			end_addr = start_addr + addr.address_length;
+			e820_search_gap(&gap->gapstart, &gap->gapsize,
+					start_addr, end_addr);
+		}
+	}
+
+	return AE_OK;
+}
+
+/*
+ * Search for a hole in the 32 bit address space for PCI to assign MMIO
+ * resources, for hotplug or unconfigured resources.
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
+			printk(KERN_ERR "ACPI: Warning: Cannot find a gap "
+					"in the 32bit address range for PCI\n"
+					"ACPI: PCI devices may collide with "
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
+		printk(KERN_INFO "ACPI: PCI resources should "
+				"start at %lx (gap: %lx:%lx)\n",
+				pci_mem_start, gap.gapstart, gap.gapsize);
+	} else {
+		printk(KERN_ERR "ACPI: Error while searching for gap in "
+				"the 32bit address range for PCI\n");
+	}
+}
+
+
 static void
 get_current_resources(struct acpi_device *device, int busnum,
 			int domain, struct pci_bus *bus)
@@ -220,6 +298,8 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 
 	if (bus && (pci_probe & PCI_USE__CRS))
 		get_current_resources(device, busnum, domain, bus);
+
+	pci_setup_gap(device->handle);
 	return bus;
 }
 


