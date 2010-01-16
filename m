Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0APLIx (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282Ab0APLIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:08:49 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38774 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0APLIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:08:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sat, 16 Jan 2010 03:07:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/11] pci: add pci_bridge_release_unused_res and
 pci_bus_release_unused_bridge_res
In-reply-to: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263640037-24134-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so later we could use it to release small resource before pci assign unassign res

-v2: change name to release_child_resources according to Jesse
-v3: according to Linus, move release_child_resources to resource.c
     also need to put the lock around them all to avoid recursive deep.
     (my test case only have one level that need to be released)
-v4: seperate release_child_resources to another patch
     according to Bjorn, change hard code 3 to PCI_BRIDGE_RESOURCE_END
-v5: remove unused in the name, and also use enum for release type according
     to Jesse
-v6: use pci_is_root_bus instead acording to ALex.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 52fbd42..7a18428 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -604,6 +604,101 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
+static void pci_bridge_release_resources(struct pci_bus *bus,
+					  unsigned long type)
+{
+	int idx;
+	bool changed = false;
+	struct pci_dev *dev;
+	struct resource *r;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	dev = bus->self;
+	for (idx = PCI_BRIDGE_RESOURCES; idx <= PCI_BRIDGE_RESOURCE_END;
+	     idx++) {
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
+enum release_type {
+	leaf_only,
+	whole_subtree,
+};
+/*
+ * try to release pci bridge resources that is from leaf bridge,
+ * so we can allocate big new one later
+ */
+static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
+						   unsigned long type,
+						   enum release_type rel_type)
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
+			if (rel_type == whole_subtree)
+				pci_bus_release_bridge_resources(b, type,
+							 whole_subtree);
+			break;
+		}
+	}
+
+	/* The root bus? */
+	if (pci_is_root_bus(bus))
+		return;
+
+	switch (bus->self->class >> 8) {
+	case PCI_CLASS_BRIDGE_CARDBUS:
+		break;
+
+	case PCI_CLASS_BRIDGE_PCI:
+	default:
+		if (((rel_type == leaf_only) && is_leaf_bridge) ||
+		    (rel_type == whole_subtree))
+			pci_bridge_release_resources(bus, type);
+		break;
+	}
+}
+
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
         int i;
-- 
1.6.4.2

