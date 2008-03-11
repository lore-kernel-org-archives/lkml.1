Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYCKVZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYCKVZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYCKVZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:25:01 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:17875 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYCKVY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:24:57 -0400
Message-Id: <20080311212740.802052655@ldl.fc.hp.com>
References: <20080311212439.293001409@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Mar 2008 15:24:41 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-acpi@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Matthew Hall <mhall@mhcomputing.net>
Cc: Willem Riede <wriede@riede.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Karl Bellve <karl.bellve@umassmed.edu>
Cc: Avuton Olrich <avuton@gmail.com>
Subject: [patch 2/2] PNP: disable PNP motherboard resources that overlap PCI BARs
Content-Disposition: inline; filename=pnp-system-quirk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSes have PNP motherboard devices with resources that
partially overlap PCI BARs.  The PNP system driver claims these
motherboard resources, which prevents the normal PCI driver from
requesting them later.

This patch disables the PNP resources that conflict with PCI BARs
so they won't be claimed by the PNP system driver.

Of course, this only works if PCI devices have already been enumerated.
Currently this is the case because PCI devices are discovered before
any PNP init via this path:

    acpi_pci_root_init() -> acpi_pci_root_add() -> pci_acpi_scan_root() ->
	pci_scan_bus_parented() -> pci_scan_child_bus() -> ...

Avuton Olrich tested this and confirmed that it fixes his ALSA sound
card (see http://lkml.org/lkml/2008/1/27/168).

References:
    https://bugzilla.redhat.com/show_bug.cgi?id=280641
    https://bugzilla.redhat.com/show_bug.cgi?id=313491
    http://lkml.org/lkml/2008/1/9/449
    http://thread.gmane.org/gmane.linux.acpi.devel/27312
    http://lkml.org/lkml/2008/1/27/168

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/quirks.c
===================================================================
--- work7.orig/drivers/pnp/quirks.c	2008-03-06 15:40:51.000000000 -0700
+++ work7/drivers/pnp/quirks.c	2008-03-06 15:40:52.000000000 -0700
@@ -108,6 +108,77 @@
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
+
+#include <linux/pci.h>
+
+static void quirk_system_pci_resources(struct pnp_dev *dev)
+{
+	struct pci_dev *pdev = NULL;
+	resource_size_t pnp_start, pnp_end, pci_start, pci_end;
+	int i, j;
+
+	/*
+	 * Some BIOSes have PNP motherboard devices with resources that
+	 * partially overlap PCI BARs.  The PNP system driver claims these
+	 * motherboard resources, which prevents the normal PCI driver from
+	 * requesting them later.
+	 *
+	 * This patch disables the PNP resources that conflict with PCI BARs
+	 * so they won't be claimed by the PNP system driver.
+	 */
+	for_each_pci_dev(pdev) {
+		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM) ||
+			    pci_resource_len(pdev, i) == 0)
+				continue;
+
+			pci_start = pci_resource_start(pdev, i);
+			pci_end = pci_resource_end(pdev, i);
+			for (j = 0; j < PNP_MAX_MEM; j++) {
+				if (!pnp_mem_valid(dev, j) ||
+				    pnp_mem_len(dev, j) == 0)
+					continue;
+
+				pnp_start = pnp_mem_start(dev, j);
+				pnp_end = pnp_mem_end(dev, j);
+
+				/*
+				 * If the PNP region doesn't overlap the PCI
+				 * region at all, there's no problem.
+				 */
+				if (pnp_end < pci_start || pnp_start > pci_end)
+					continue;
+
+				/*
+				 * If the PNP region completely encloses (or is
+				 * at least as large as) the PCI region, that's
+				 * also OK.  For example, this happens when the
+				 * PNP device describes a bridge with PCI
+				 * behind it.
+				 */
+				if (pnp_start <= pci_start &&
+				    pnp_end >= pci_end)
+					continue;
+
+				/*
+				 * Otherwise, the PNP region overlaps *part* of
+				 * the PCI region, and that might prevent a PCI
+				 * driver from requesting its resources.
+				 */
+				dev_warn(&dev->dev, "mem resource "
+					"(0x%llx-0x%llx) overlaps %s BAR %d "
+					"(0x%llx-0x%llx), disabling\n",
+					(unsigned long long) pnp_start,
+					(unsigned long long) pnp_end,
+					pci_name(pdev), i,
+					(unsigned long long) pci_start,
+					(unsigned long long) pci_end);
+				pnp_mem_flags(dev, j) = 0;
+			}
+		}
+	}
+}
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -128,6 +199,8 @@
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
+	{"PNP0c01", quirk_system_pci_resources},
+	{"PNP0c02", quirk_system_pci_resources},
 	{""}
 };
 

-- 
