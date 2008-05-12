Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbYELU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbYELU57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYELU5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:57:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53022 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbYELU5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:57:49 -0400
Date: Mon, 12 May 2008 13:57:46 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Cc: garyhade@us.ibm.com
Subject: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Message-ID: <20080512205746.GB7401@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gary Hade <garyhade@us.ibm.com>

Contention for scarce PCI memory resources has been growing
due to an increasing number of PCI slots in large multi-node
systems.  The kernel currently attempts by default to
allocate memory for all PCI expansion ROMs so there has
also been an increasing number of PCI memory allocation
failures seen on these systems.  This occurs because the
BIOS either (1) provides insufficient PCI memory resource
for all the expansion ROMs or (2) provides adequate PCI
memory resource for expansion ROMs but provides the
space in kernel unexpected BIOS assigned P2P non-prefetch
windows.

The resulting PCI memory allocation failures may be benign
when related to memory requests for expansion ROMs themselves
but in some cases they can occur when attempting to allocate
space for more critical BARs.  This can happen when a successful
expansion ROM allocation request consumes memory resource
that was intended for a non-ROM BAR.  We have seen this
happen during PCI hotplug of an adapter that contains a
P2P bridge where successful memory allocation for an
expansion ROM BAR on device behind the bridge consumed
memory that was intended for a non-ROM BAR on the P2P bridge.
In all cases the allocation failure messages can be very
confusing for users.

This patch provides a new 'pci=norom' kernel boot parameter
that can be used to disable the default PCI expansion ROM memory
resource allocation.  This provides a way to avoid the above
described issues on systems that do not contain PCI devices
for which drivers or user-level applications depend on the 
default PCI expansion ROM memory resource allocation behavior.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
---

--- linux-2.6.26-rc2/arch/x86/pci/pci.h.orig	2008-05-12 10:53:04.000000000 -0700
+++ linux-2.6.26-rc2/arch/x86/pci/pci.h	2008-05-12 10:54:39.000000000 -0700
@@ -27,6 +27,7 @@
 #define PCI_CAN_SKIP_ISA_ALIGN	0x8000
 #define PCI_USE__CRS		0x10000
 #define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
+#define PCI_NOASSIGN_ROMS	0x40000
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
--- linux-2.6.26-rc2/Documentation/kernel-parameters.txt.orig	2008-05-12 10:55:30.000000000 -0700
+++ linux-2.6.26-rc2/Documentation/kernel-parameters.txt	2008-05-12 10:57:49.000000000 -0700
@@ -1493,6 +1493,9 @@ and is between 256 and 4096 characters. 
 				Use with caution as certain devices share
 				address decoders between ROMs and other
 				resources.
+		norom		[X86-32,X86_64] Do not assign address space to
+				expansion ROMs that do not already have
+				BIOS assigned address ranges.
 		irqmask=0xMMMM	[X86-32] Set a bit mask of IRQs allowed to be
 				assigned automatically to PCI devices. You can
 				make the kernel exclude IRQs of your ISA cards
--- linux-2.6.26-rc2/arch/x86/pci/common.c.orig	2008-05-12 10:59:58.000000000 -0700
+++ linux-2.6.26-rc2/arch/x86/pci/common.c	2008-05-12 11:22:05.000000000 -0700
@@ -121,6 +121,21 @@ void __init dmi_check_skip_isa_align(voi
 	dmi_check_system(can_skip_pciprobe_dmi_table);
 }
 
+static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
+{
+	struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
+
+	if (pci_probe & PCI_NOASSIGN_ROMS) {
+		if (rom_r->parent)
+			return;
+		if (rom_r->start) {
+			/* we deal with BIOS assigned ROM later */
+			return;
+		}
+		rom_r->start = rom_r->end = rom_r->flags = 0;
+	}
+}
+
 /*
  *  Called after each bus is probed, but before its children
  *  are examined.
@@ -128,7 +143,11 @@ void __init dmi_check_skip_isa_align(voi
 
 void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
+	struct pci_dev *dev;
+
 	pci_read_bridge_bases(b);
+	list_for_each_entry(dev, &b->devices, bus_list)
+		pcibios_fixup_device_resources(dev);
 }
 
 /*
@@ -483,6 +502,9 @@ char * __devinit  pcibios_setup(char *st
 	else if (!strcmp(str, "rom")) {
 		pci_probe |= PCI_ASSIGN_ROMS;
 		return NULL;
+	} else if (!strcmp(str, "norom")) {
+		pci_probe |= PCI_NOASSIGN_ROMS;
+		return NULL;
 	} else if (!strcmp(str, "assign-busses")) {
 		pci_probe |= PCI_ASSIGN_ALL_BUSSES;
 		return NULL;
