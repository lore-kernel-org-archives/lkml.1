Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbZJ0IKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbZJ0IKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbZJ0IKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:10:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:37976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbZJ0IKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:10:40 -0400
Message-ID: <4AE6AAE3.6000509@kernel.org>
Date: Tue, 27 Oct 2009 01:10:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/4] pci: only release that resource index is less than 3
 -v3
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com> <4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com> <4AE55D72.7080202@kernel.org> <4AE6A9CA.4060106@kernel.org>
In-Reply-To: <4AE6A9CA.4060106@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/i386.c              |    6 +++
 drivers/pci/hotplug/pciehp_pci.c |    1 
 drivers/pci/setup-bus.c          |   69 ++++++++++++++++++++++++++++++++++++++-
 include/linux/pci.h              |    2 +
 4 files changed, 77 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -319,6 +319,37 @@ static void pci_bridge_check_ranges(stru
 	}
 }
 
+void pci_bridge_release_not_used_res(struct pci_bus *bus)
+{
+	int i;
+	struct resource *r;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	/* for pci bridges res only */
+	for (i = 0; i < 3; i++) {
+		r = bus->resource[i];
+		if (r && (r->flags & type_mask)) {
+			if (!r->parent)
+				continue;
+			/*
+			 * if there is no child under that, we should release
+			 * and use it. don't need to reset it, pbus_size_* will
+			 * set it again
+			 */
+			if (!r->child && !release_resource(r)) {
+				r->flags = 0;
+				dev_printk(KERN_DEBUG, &bus->dev,
+					   "resource %d %pRt released\n",
+					   i, r);
+			}
+		}
+	}
+
+	pci_setup_bridge(bus);
+}
+EXPORT_SYMBOL(pci_bridge_release_not_used_res);
+
 /* Helper function for sizing routines: find first available
    bus resource of a given type. Note: we intentionally skip
    the bus resources which have already been assigned (that is,
@@ -576,6 +607,42 @@ void __ref pci_bus_size_bridges(struct p
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
@@ -644,7 +711,7 @@ static void pci_bus_dump_res(struct pci_
 
         for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
                 struct resource *res = bus->resource[i];
-                if (!res || !res->end)
+                if (!res || !res->end || !res->flags)
                         continue;
 
 		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pRt\n", i, res);
Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
@@ -171,6 +171,7 @@ int pciehp_unconfigure_device(struct slo
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

