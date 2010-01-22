Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770Ab0AVJEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0AVJEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675Ab0AVJDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:03:21 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53460 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0AVJDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:03:09 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 01:02:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/9] pci: add pci_bridge_release_resources and
 pci_bus_release__bridge_resources
In-reply-to: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264150948-9052-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
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
-v6: use pci_is_root_bus instead according to Alex.
-v7: remove the switch case in pci_bus_release_resources accord to Alex
-v8: change some comments and style according to Alex again

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/setup-bus.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 52fbd42..7371a54 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -604,6 +604,88 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
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
+		/* avoiding touch the one without PREF */
+		if (type & IORESOURCE_PREFETCH)
+			type = IORESOURCE_PREFETCH;
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
+		is_leaf_bridge = false;
+
+		if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+			continue;
+
+		if (rel_type == whole_subtree)
+			pci_bus_release_bridge_resources(b, type,
+						 whole_subtree);
+	}
+
+	if (pci_is_root_bus(bus))
+		return;
+
+	if ((bus->self->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return;
+
+	if ((rel_type == whole_subtree) || is_leaf_bridge)
+		pci_bridge_release_resources(bus, type);
+}
+
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
         int i;
-- 
1.6.4.2

