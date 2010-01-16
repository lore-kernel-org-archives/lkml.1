Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0APLJB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405Ab0APLI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:08:57 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63405 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0APLIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:08:55 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sat, 16 Jan 2010 03:07:15 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/11] pci: pci_bridge_release_res
In-reply-to: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263640037-24134-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare for pciehp_realloc

it will clear the resource size for bridge

-v2: patrick Keller pointed out need to export it...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   77 ++++++++++++++++++++++++++++++++++++++--------
 include/linux/pci.h     |    1 +
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 1966b5e..61f128b 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -721,8 +721,9 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
 		break;
 	}
 }
-static void pci_bridge_release_resources(struct pci_bus *bus,
-					  unsigned long type)
+
+static void __pci_bridge_release_res(struct pci_bus *bus, bool rel_child,
+					 unsigned long type)
 {
 	int idx;
 	bool changed = false;
@@ -731,32 +732,57 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
+	/* The root bus? */
+	if (!bus->self)
+		return;
+
+	/* for pci bridges res only */
 	dev = bus->self;
-	for (idx = PCI_BRIDGE_RESOURCES; idx <= PCI_BRIDGE_RESOURCE_END;
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return;
+
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
 	     idx++) {
 		r = &dev->resource[idx];
-		if ((r->flags & type_mask) != type)
-			continue;
 		if (!r->parent)
 			continue;
-		/*
-		 * if there are children under that, we should release them
-		 *  all
-		 */
-		release_child_resources(r);
+
+		if (type != type_mask && (r->flags & type_mask) != type)
+			continue;
+
+		if (rel_child) {
+			/*
+			 * if there are children under that, we should release
+			 *  them all
+			 */
+			release_child_resources(r);
+		} else {
+			/*
+			 * if there are children under that, we should not
+			 * release it
+			 */
+			if (r->child)
+				continue;
+		}
+
 		if (!release_resource(r)) {
 			dev_printk(KERN_DEBUG, &dev->dev,
 				 "resource %d %pR released\n", idx, r);
-			/* keep the old size */
-			r->end = resource_size(r) - 1;
-			r->start = 0;
+			if (rel_child) {
+				/* keep the old size */
+				r->end = resource_size(r) - 1;
+			} else {
+				/* old size is not kept */
+				r->start = 0;
+			}
+			r->end   = 0;
 			r->flags = 0;
 			changed = true;
 		}
 	}
 
 	if (changed) {
-		if (type & IORESOURCE_PREFETCH) {
+		if (type != type_mask && (type & IORESOURCE_PREFETCH)) {
 			/* avoiding touch the one without PREF */
 			type = IORESOURCE_PREFETCH;
 		}
@@ -764,6 +790,29 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
 	}
 }
 
+/*
+ * pci_bridge_release_res will not release the resource that have children
+ *  and apply all resources type under that devices
+ */
+void pci_bridge_release_res(struct pci_bus *bus)
+{
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	__pci_bridge_release_res(bus, false, type_mask);
+}
+EXPORT_SYMBOL_GPL(pci_bridge_release_res);
+
+/*
+ * this one will release children resource, but only to specifed resource type
+ * and also will keep old resource size
+ */
+static void pci_bridge_release_resources(struct pci_bus *bus,
+					  unsigned long type)
+{
+	__pci_bridge_release_res(bus, true, type);
+}
+
 enum release_type {
 	leaf_only,
 	whole_subtree,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0e240ed..b8c7e45 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -805,6 +805,7 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
+void pci_bridge_release_res(struct pci_bus *bus);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);
-- 
1.6.4.2

