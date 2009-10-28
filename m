Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbZJ1Dpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbZJ1Dpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbZJ1Dpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:45:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694AbZJ1Dpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:45:47 -0400
Message-ID: <4AE7BE4D.7080605@kernel.org>
Date: Tue, 27 Oct 2009 20:45:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: only release that resource index is less than 3
References: <4AE2C827.8040905@kernel.org> <1256601476.25492.47.camel@dc7800.home> <4AE63CCC.3050203@kernel.org> <200910271009.05805.bjorn.helgaas@hp.com>
In-Reply-To: <200910271009.05805.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/4] pci: only release that resource index is less than 3 -v4

after

| commit 308cf8e13f42f476dfd6552aeff58fdc0788e566
|
|    PCI: get larger bridge ranges when space is available

found one of resource of peer root bus (0x00) get released from root
resource. later one hotplug device can not get big range anymore.
other peer root buses is ok.

it turns out it is from transparent path.

those resources will be used for pci bridge BAR updated.
so need to limit it to 3.

v2: Jesse doesn't like it is in find_free_bus_resource...
    try to move out of pci_bus_size_bridges loop.
need to apply after:
	[PATCH] pci: pciehp update the slot bridge res to get big range for pcie devices - v4
v3: add pci_setup_bridge calling after pci_bridge_release_not_used_res.
    only clear release those res for x86.
v4: Bjorn want to release use dev instead of bus.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/i386.c              |    6 +++
 drivers/pci/hotplug/pciehp_pci.c |    2 +
 drivers/pci/setup-bus.c          |   75 ++++++++++++++++++++++++++++++++++++++-
 include/linux/pci.h              |    2 +
 4 files changed, 84 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -319,6 +319,42 @@ static void pci_bridge_check_ranges(stru
 	}
 }
 
+void pci_bridge_release_not_used_res(struct pci_bus *bus)
+{
+	int idx;
+	bool changed = false;
+	struct pci_dev *dev;
+	struct resource *r;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	/* for pci bridges res only */
+	dev = bus->self;
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
+	    idx++) {
+		r = &dev->resource[idx];
+		if (r->flags & type_mask) {
+			if (!r->parent)
+				continue;
+			/*
+			 * if there is no child under that, we should release
+			 * and use it.
+			 */
+			if (!r->child && !release_resource(r)) {
+				dev_info(&dev->dev,
+					 "resource %d %pRt released\n",
+					 idx, r);
+				r->flags = 0;
+				changed = true;
+			}
+		}
+	}
+
+	if (changed)
+		pci_setup_bridge(bus);
+}
+EXPORT_SYMBOL(pci_bridge_release_not_used_res);
+
 /* Helper function for sizing routines: find first available
    bus resource of a given type. Note: we intentionally skip
    the bus resources which have already been assigned (that is,
@@ -576,6 +612,42 @@ void __ref pci_bus_size_bridges(struct p
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
+void __ref pci_bus_release_bridges_not_used_res(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		struct pci_bus *b = dev->subordinate;
+		if (!b)
+			continue;
+
+		switch (dev->class >> 8) {
+		case PCI_CLASS_BRIDGE_CARDBUS:
+			break;
+
+		case PCI_CLASS_BRIDGE_PCI:
+		default:
+			pci_bus_release_bridges_not_used_res(b);
+			break;
+		}
+	}
+
+	/* The root bus? */
+	if (!bus->self)
+		return;
+
+	switch (bus->self->class >> 8) {
+	case PCI_CLASS_BRIDGE_CARDBUS:
+		break;
+
+	case PCI_CLASS_BRIDGE_PCI:
+	default:
+		pci_bridge_release_not_used_res(bus);
+		break;
+	}
+}
+EXPORT_SYMBOL(pci_bus_release_bridges_not_used_res);
+
 void __ref pci_bridge_assign_resources(const struct pci_dev *bridge)
 {
 	struct pci_bus *b;
@@ -644,7 +716,8 @@ static void pci_bus_dump_res(struct pci_
 
         for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
                 struct resource *res = bus->resource[i];
-                if (!res || !res->end)
+
+		if (!res || !res->end || !res->flags)
                         continue;
 
 		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pRt\n", i, res);
Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
@@ -98,6 +98,7 @@ int pciehp_configure_device(struct slot
 		pci_dev_put(dev);
 	}
 
+	pci_bridge_release_not_used_res(parent);
 	pci_bus_size_bridges(parent);
 	pci_clear_master(bridge);
 	pci_bridge_assign_resources(bridge);
@@ -171,6 +172,7 @@ int pciehp_unconfigure_device(struct slo
 		}
 		pci_dev_put(temp);
 	}
+	pci_bridge_release_not_used_res(parent);
 
 	return rc;
 }
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -759,6 +759,8 @@ int pci_vpd_truncate(struct pci_dev *dev
 void pci_bridge_assign_resources(const struct pci_dev *bridge);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
+void pci_bus_release_bridges_not_used_res(struct pci_bus *bus);
+void pci_bridge_release_not_used_res(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
 void pdev_enable_device(struct pci_dev *);
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -194,6 +194,7 @@ static void __init pcibios_allocate_reso
 static int __init pcibios_assign_resources(void)
 {
 	struct pci_dev *dev = NULL;
+	struct pci_bus *bus;
 	struct resource *r;
 
 	if (!(pci_probe & PCI_ASSIGN_ROMS)) {
@@ -213,6 +214,11 @@ static int __init pcibios_assign_resourc
 		}
 	}
 
+	/* Try to release bridge resources, that there is not child under it */
+	list_for_each_entry(bus, &pci_root_buses, node) {
+		pci_bus_release_bridges_not_used_res(bus);
+	}
+
 	pci_assign_unassigned_resources();
 
 	return 0;
