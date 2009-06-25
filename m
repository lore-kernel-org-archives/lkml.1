Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZFYCCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZFYCCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFYCCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:02:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:43567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZFYCCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:02:40 -0400
Message-ID: <4A42DAA1.7020704@kernel.org>
Date: Wed, 24 Jun 2009 19:02:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86/pci: get root CRS before scan childs -v3
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A42DA6F.2030305@kernel.org>
In-Reply-To: <4A42DA6F.2030305@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we could remove adjust_transparent_bridge_resources..

and give x86_pci_root_bus_res_quirks chance when _CRS is not used or
not there.

v2: add print out if pci conf reading for res is used for root
v3: update after revert PCI_NO_ROOT_CRS

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c    |   32 +++++++++-----------------------
 arch/x86/pci/amd_bus.c |    8 ++++++--
 2 files changed, 15 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -118,23 +118,6 @@ setup_resource(struct acpi_resource *acp
 }
 
 static void
-adjust_transparent_bridge_resources(struct pci_bus *bus)
-{
-	struct pci_dev *dev;
-
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		int i;
-		u16 class = dev->class >> 8;
-
-		if (class == PCI_CLASS_BRIDGE_PCI && dev->transparent) {
-			for(i = 3; i < PCI_BUS_NUM_RESOURCES; i++)
-				dev->subordinate->resource[i] =
-						dev->bus->resource[i - 3];
-		}
-	}
-}
-
-static void
 get_current_resources(struct acpi_device *device, int busnum,
 			int domain, struct pci_bus *bus)
 {
@@ -161,8 +144,6 @@ get_current_resources(struct acpi_device
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				&info);
-	if (info.res_num)
-		adjust_transparent_bridge_resources(bus);
 
 	return;
 
@@ -225,8 +206,15 @@ struct pci_bus * __devinit pci_acpi_scan
 		 */
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
-	} else
-		bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	} else {
+		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd);
+		if (bus) {
+			if (pci_probe & PCI_USE_CRS)
+				get_current_resources(device, busnum, domain,
+							bus);
+			bus->subordinate = pci_scan_child_bus(bus);
+		}
+	}
 
 	if (!bus)
 		kfree(sd);
@@ -241,8 +229,6 @@ struct pci_bus * __devinit pci_acpi_scan
 #endif
 	}
 
-	if (bus && (pci_probe & PCI_USE__CRS))
-		get_current_resources(device, busnum, domain, bus);
 	return bus;
 }
 
Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -100,8 +100,9 @@ void x86_pci_root_bus_res_quirks(struct
 	int j;
 	struct pci_root_info *info;
 
-	/* don't go for it if _CRS is used */
-	if (pci_probe & PCI_USE__CRS)
+	/* don't go for it if _CRS is used already */
+	if (b->resource[0] != &ioport_resource ||
+	    b->resource[1] != &iomem_resource)
 		return;
 
 	/* if only one root bus, don't need to anything */
@@ -116,6 +117,9 @@ void x86_pci_root_bus_res_quirks(struct
 	if (i == pci_root_num)
 		return;
 
+	printk(KERN_DEBUG "PCI: peer root bus %02x res updated from pci conf\n",
+			b->number);
+
 	info = &pci_root_info[i];
 	for (j = 0; j < info->res_num; j++) {
 		struct resource *res;
