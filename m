Return-Path: <linux-kernel-owner+w=401wt.eu-S932972AbZLRU7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbZLRU7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbZLRU7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:59:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:52640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764AbZLRU4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:56:10 -0500
Message-ID: <4B2BEC1B.9090104@kernel.org>
Date: Fri, 18 Dec 2009 12:54:51 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 2/12] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res
 -v2
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so later we could use it to release small resource before pci assign unassign res

-v2: change name to release_child_resources

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -209,7 +209,6 @@ static void pci_setup_bridge_mmio_pref(s
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (res->flags & IORESOURCE_MEM_64) {
-			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
 		}
@@ -608,6 +607,118 @@ void __ref pci_bus_assign_resources(cons
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
+static void release_child_resources(struct resource *r)
+{
+	struct resource *p;
+	resource_size_t size;
+
+	p = r->child;
+	while (p) {
+		release_child_resources(p);
+		release_resource(p);
+		printk(KERN_DEBUG "PCI: release child resource %pR\n", p);
+		/* need to restore size, and keep flags */
+		size = resource_size(p);
+		p->start = 0;
+		p->end = size - 1;
+		p = r->child;
+	}
+}
+
+static void pci_bridge_release_unused_res(struct pci_bus *bus,
+					  unsigned long type)
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
+		if ((r->flags & type_mask) != type)
+			continue;
+		if (!r->parent)
+			continue;
+		/*
+		 * if there are children under that, we should release them
+		 *  all
+		 */
+		release_child_resources(r);
+		if (!release_resource(r)) {
+			dev_printk(KERN_DEBUG, &dev->dev,
+				 "resource %d %pR released\n", idx, r);
+			/* keep the old size */
+			r->end = resource_size(r) - 1;
+			r->start = 0;
+			r->flags = 0;
+			changed = true;
+		}
+	}
+
+	if (changed) {
+		if (type & IORESOURCE_PREFETCH) {
+			/* avoiding touch the one without PREF */
+			type = IORESOURCE_PREFETCH;
+		}
+		__pci_setup_bridge(bus, type);
+	}
+}
+
+/*
+ * try to release pci bridge resources that is from leaf bridge,
+ * so we can allocate big new one later
+ * check:
+ *    0: only release the bridge and only the bridge is leaf
+ *    1: release all down side bridge for third shoot
+ */
+static void __ref pci_bus_release_unused_bridge_res(struct pci_bus *bus,
+						    unsigned long type,
+						    int check_leaf)
+{
+	struct pci_dev *dev;
+	bool is_leaf_bridge = true;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		struct pci_bus *b = dev->subordinate;
+		if (!b)
+			continue;
+
+		switch (dev->class >> 8) {
+		case PCI_CLASS_BRIDGE_CARDBUS:
+			is_leaf_bridge = false;
+			break;
+
+		case PCI_CLASS_BRIDGE_PCI:
+		default:
+			is_leaf_bridge = false;
+			if (!check_leaf)
+				pci_bus_release_unused_bridge_res(b, type,
+							 check_leaf);
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
+		if ((check_leaf && is_leaf_bridge) || !check_leaf)
+			pci_bridge_release_unused_res(bus, type);
+		break;
+	}
+}
+
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
         int i;


