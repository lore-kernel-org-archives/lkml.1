Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbXEOEEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbXEOEEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 00:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXEOEEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 00:04:22 -0400
Received: from ozlabs.org ([203.10.76.45]:45154 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbXEOEEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 00:04:21 -0400
To: Paul Mackerras <paulus@samba.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd.bergmann@de.ibm.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 15 May 2007 14:03:50 +1000
Subject: [PATCH 2/2] powerpc: Fix IO space on PCI busses created from of_platform
Message-Id: <20070515040420.5FD59DDEBB@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the way of_platform_pci creates PCI host bridges such
that it uses request_phb_iospace() for mapping the IO ports, instead
of using the dynamic hotplug stuff. That guarantees the IO space
stays within the 2GB limit and thus doesn't break half of the legacy
drivers around.

Fixes a couple of warnings due to missing IO space while at it.

This patch is a temporary workaround for 2.6.22 before a more complete
rewrite of IO mappings is merged in 2.6.23

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

 arch/powerpc/kernel/of_platform.c |   10 ++++++----
 arch/powerpc/kernel/pci_64.c      |   23 ++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 5 deletions(-)

Index: linux-cell/arch/powerpc/kernel/of_platform.c
===================================================================
--- linux-cell.orig/arch/powerpc/kernel/of_platform.c	2007-05-15 13:19:43.000000000 +1000
+++ linux-cell/arch/powerpc/kernel/of_platform.c	2007-05-15 13:24:03.000000000 +1000
@@ -427,11 +427,13 @@ static int __devinit of_pci_phb_probe(st
 	/* Process "ranges" property */
 	pci_process_bridge_OF_ranges(phb, dev->node, 0);
 
-	/* Setup IO space.
-	 * This will not work properly for ISA IOs, something needs to be done
-	 * about it if we ever generalize that way of probing PCI brigdes
+	/* Setup IO space. We use the non-dynamic version of that code here,
+	 * which doesn't quite support unplugging. Next kernel release will
+	 * have a better fix for this.
+	 * Note also that we don't do ISA, this will also be fixed with a
+	 * more massive rework.
 	 */
-	pci_setup_phb_io_dynamic(phb, 0);
+	pci_setup_phb_io(phb, 0);
 
 	/* Init pci_dn data structures */
 	pci_devs_phb_init_dynamic(phb);
Index: linux-cell/arch/powerpc/kernel/pci_64.c
===================================================================
--- linux-cell.orig/arch/powerpc/kernel/pci_64.c	2007-05-15 13:23:30.000000000 +1000
+++ linux-cell/arch/powerpc/kernel/pci_64.c	2007-05-15 13:53:02.000000000 +1000
@@ -41,6 +41,7 @@
 
 unsigned long pci_probe_only = 1;
 int pci_assign_all_buses = 0;
+static int pci_initial_scan;
 
 static void fixup_resource(struct resource *res, struct pci_dev *dev);
 static void do_bus_setup(struct pci_bus *bus);
@@ -604,6 +605,8 @@ static int __init pcibios_init(void)
 		/* map in PCI I/O space */
 		phbs_remap_io();
 
+	pci_initial_scan = 1;
+
 	printk(KERN_DEBUG "PCI: Probing PCI hardware done\n");
 
 	return 0;
@@ -1042,13 +1045,16 @@ void __devinit pci_process_bridge_OF_ran
 	}
 }
 
-void __init pci_setup_phb_io(struct pci_controller *hose, int primary)
+void __devinit pci_setup_phb_io(struct pci_controller *hose, int primary)
 {
 	unsigned long size = hose->pci_io_size;
 	unsigned long io_virt_offset;
 	struct resource *res;
 	struct device_node *isa_dn;
 
+	if (size == 0)
+		return;
+
 	hose->io_base_virt = reserve_phb_iospace(size);
 	DBG("phb%d io_base_phys 0x%lx io_base_virt 0x%lx\n",
 		hose->global_number, hose->io_base_phys,
@@ -1069,6 +1075,15 @@ void __init pci_setup_phb_io(struct pci_
 	res = &hose->io_resource;
 	res->start += io_virt_offset;
 	res->end += io_virt_offset;
+
+	/* If this is called after the initial PCI scan, then we need to
+	 * proceed to IO mappings now
+	 */
+	if (pci_initial_scan)
+		__ioremap_explicit(hose->io_base_phys,
+				   (unsigned long)hose->io_base_virt,
+				   hose->pci_io_size,
+				   _PAGE_NO_CACHE | _PAGE_GUARDED);
 }
 
 void __devinit pci_setup_phb_io_dynamic(struct pci_controller *hose,
@@ -1078,6 +1093,9 @@ void __devinit pci_setup_phb_io_dynamic(
 	unsigned long io_virt_offset;
 	struct resource *res;
 
+	if (size == 0)
+		return;
+
 	hose->io_base_virt = __ioremap(hose->io_base_phys, size,
 					_PAGE_NO_CACHE | _PAGE_GUARDED);
 	DBG("phb%d io_base_phys 0x%lx io_base_virt 0x%lx\n",
@@ -1106,6 +1124,9 @@ static int get_bus_io_range(struct pci_b
 		/* Root Bus */
 		res = &hose->io_resource;
 
+	if (res->end == 0 && res->start == 0)
+		return 1;
+
 	*start_virt = pci_io_base + res->start;
 	*start_phys = *start_virt + hose->io_base_phys
 		- (unsigned long) hose->io_base_virt;
