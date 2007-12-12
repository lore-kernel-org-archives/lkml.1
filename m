Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbXLLBJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbXLLBJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXLLBJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:09:35 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35880 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605AbXLLBJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:09:33 -0500
Date: Tue, 11 Dec 2007 17:09:25 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Cc: jbeulich@novell.com, linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       lcm@us.ibm.com
Subject: [PATCH] PCI: Remove default PCI expansion ROM memory allocation
Message-ID: <20071212010925.GD6755@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove default PCI expansion ROM memory allocation

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

This patch addresses the issue by changing the kernel default
behavior so that expansion ROM memory allocations are no
longer attempted by default when the BIOS has not assigned
a specific address range to the expansion ROM BAR.  This was
done by changing the 'pci=rom' boot option behavior for BIOS
unassigned expansion ROMs to actually match it's current
kernel-parameters.txt description which already implies "off"
by default.  Behavior for BIOS assigned expansion ROMs
implemented in pcibios_assign_resources() [arch/x86/pci/i386.c]
is unchanged.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
---

--- linux-2.6.24-rc5/arch/x86/pci/common.c.orig	2007-12-11 09:59:13.000000000 -0800
+++ linux-2.6.24-rc5/arch/x86/pci/common.c	2007-12-11 11:27:35.000000000 -0800
@@ -109,6 +109,19 @@ static void __devinit pcibios_fixup_ghos
 	}
 }
 
+static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
+{
+	struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
+
+	if (rom_r->parent)
+		return;
+	if (rom_r->start)
+		/* we deal with BIOS assigned ROM later */
+		return;
+	if (!(pci_probe & PCI_ASSIGN_ROMS))
+		rom_r->start = rom_r->end = rom_r->flags = 0;
+}
+
 /*
  *  Called after each bus is probed, but before its children
  *  are examined.
@@ -116,8 +129,12 @@ static void __devinit pcibios_fixup_ghos
 
 void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
+	struct pci_dev *dev;
+
 	pcibios_fixup_ghosts(b);
 	pci_read_bridge_bases(b);
+	list_for_each_entry(dev, &b->devices, bus_list)
+		pcibios_fixup_device_resources(dev);
 }
 
 /*
