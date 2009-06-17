Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbZFQT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbZFQT7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZFQT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:59:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:60707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZFQT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:59:10 -0400
Message-ID: <4A394AD6.5030007@kernel.org>
Date: Wed, 17 Jun 2009 12:58:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] x86/pci: get root CRS before scan child bues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so we could remove adjust_transparent_bridge_resources..

and give x86_pci_root_bus_res_quirks chance when _CRS is not used or
not there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c    |   32 +++++++++-----------------------
 arch/x86/pci/amd_bus.c |    5 +++--
 2 files changed, 12 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -115,23 +115,6 @@ setup_resource(struct acpi_resource *acp
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
@@ -158,8 +141,6 @@ get_current_resources(struct acpi_device
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
 				&info);
-	if (info.res_num)
-		adjust_transparent_bridge_resources(bus);
 
 	return;
 
@@ -222,8 +203,15 @@ struct pci_bus * __devinit pci_acpi_scan
 		 */
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(sd);
-	} else
-		bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	} else {
+		bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd);
+		if (bus) {
+			if (!(pci_probe & PCI_NO_ROOT_CRS))
+				get_current_resources(device, busnum, domain,
+							bus);
+			bus->subordinate = pci_scan_child_bus(bus);
+		}
+	}
 
 	if (!bus)
 		kfree(sd);
@@ -238,8 +226,6 @@ struct pci_bus * __devinit pci_acpi_scan
 #endif
 	}
 
-	if (bus && !(pci_probe & PCI_NO_ROOT_CRS))
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
-	if (!(pci_probe & PCI_NO_ROOT_CRS))
+       /* don't go for it if _CRS is used already */
+	if (b->resource[0] != &ioport_resource ||
+	    b->resource[1] != &iomem_resource)
 		return;
 
 	/* if only one root bus, don't need to anything */
