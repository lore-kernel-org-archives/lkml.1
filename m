Return-Path: <linux-kernel-owner+w=401wt.eu-S937272AbXLQXC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937272AbXLQXC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762357AbXLQXBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:01:30 -0500
Received: from ozlabs.org ([203.10.76.45]:55681 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761387AbXLQXB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:01:28 -0500
To: linux-pci@atrey.karlin.mff.cuni.cz
CC: Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
       <jgarzik@pobox.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       <wingel@nano-system.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       <james.smart@emulex.com>, <linux-driver@qlogic.com>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 18 Dec 2007 10:01:15 +1100
Subject: [RFC/PATCH 4/4] [POWERPC] pci: Disable IO/Mem on a device when resources can't be allocated
In-Reply-To: <1197932473.576079.142524077033.qpush@grosgo>
Message-Id: <20071217230127.46B3BDDE38@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the PowerPC PCI code to disable IO and/or Memory
decoding on a PCI device when a resource of that type failed to be
allocated. This is done to avoid having unallocated dangling BARs enabled
that might try to decode on top of other devices.

If a proper resource is assigned later on, then pci_enable_device{,_io,_mem}
will take care of re-enabling decoding.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

NOTE: This patch doesn't apply on current upstream, but rather on top
of a serie that merges 32 and 64 bits PowerPC PCI resource handling, and
which will be in 2.6.25. I post it here mostly to show what I think should
be done. A similar patch will have to be done for other architectures.

 arch/powerpc/kernel/pci-common.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- linux-work.orig/arch/powerpc/kernel/pci-common.c	2007-12-18 09:37:52.000000000 +1100
+++ linux-work/arch/powerpc/kernel/pci-common.c	2007-12-18 09:39:27.000000000 +1100
@@ -1016,7 +1016,7 @@ static void __init pcibios_allocate_bus_
 	}
 }
 
-static inline void __devinit alloc_resource(struct pci_dev *dev, int idx)
+static inline int __devinit alloc_resource(struct pci_dev *dev, int idx)
 {
 	struct resource *pr, *r = &dev->resource[idx];
 
@@ -1040,7 +1040,10 @@ static inline void __devinit alloc_resou
 		r->flags |= IORESOURCE_UNSET;
 		r->end -= r->start;
 		r->start = 0;
+
+		return -EBUSY;
 	}
+	return 0;
 }
 
 static void __init pcibios_allocate_resources(int pass)
@@ -1062,8 +1065,12 @@ static void __init pcibios_allocate_reso
 				disabled = !(command & PCI_COMMAND_IO);
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
-			if (pass == disabled)
-				alloc_resource(dev, idx);
+			if (pass == disabled && alloc_resource(dev, idx)) {
+				command &= ~(r->flags & (IORESOURCE_IO |
+							 IORESOURCE_MEM));
+				pci_write_config_word(dev,
+						      PCI_COMMAND, command);
+			}
 		}
 		if (pass)
 			continue;
