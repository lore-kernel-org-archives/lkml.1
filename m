Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672Ab0AVJFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0AVJFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640Ab0AVJDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:03:13 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45880 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0AVJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:03:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 01:02:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/9] pci: introduce pci_assign_unassigned_bridge_resources
In-reply-to: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264150948-9052-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for pciehp to use it later

pci_setup_bridge() will not check enabled for the slot bridge, otherwise
update res is not updated to bridge BAR. that is bridge is enabled already for
port service.

-v2: update it with resource_list_x
-v3: remove the clear busmaster. according to Kenji
-v4: make pdev_assign_resources_sorted and pbus_assign_resources_sorted share two small functions
     according to Alex.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/setup-bus.c |  116 ++++++++++++++++++++++++++++++++++++-----------
 include/linux/pci.h     |    1 +
 2 files changed, 90 insertions(+), 27 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f76f6e9..b19a56b 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -71,35 +71,34 @@ static void free_failed_list(struct resource_list_x *head)
 	head->next = NULL;
 }
 
-static void pbus_assign_resources_sorted(const struct pci_bus *bus,
-					 struct resource_list_x *fail_head)
+static void __dev_sort_resources(struct pci_dev *dev,
+				 struct resource_list *head)
 {
-	struct pci_dev *dev;
-	struct resource *res;
-	struct resource_list head, *list, *tmp;
-	int idx;
+	u16 class = dev->class >> 8;
 
-	head.next = NULL;
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		u16 class = dev->class >> 8;
+	/* Don't touch classless devices or host bridges or ioapics.  */
+	if (class == PCI_CLASS_NOT_DEFINED || class == PCI_CLASS_BRIDGE_HOST)
+		return;
 
-		/* Don't touch classless devices or host bridges or ioapics.  */
-		if (class == PCI_CLASS_NOT_DEFINED ||
-		    class == PCI_CLASS_BRIDGE_HOST)
-			continue;
+	/* Don't touch ioapic devices already enabled by firmware */
+	if (class == PCI_CLASS_SYSTEM_PIC) {
+		u16 command;
+		pci_read_config_word(dev, PCI_COMMAND, &command);
+		if (command & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY))
+			return;
+	}
 
-		/* Don't touch ioapic devices already enabled by firmware */
-		if (class == PCI_CLASS_SYSTEM_PIC) {
-			u16 command;
-			pci_read_config_word(dev, PCI_COMMAND, &command);
-			if (command & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY))
-				continue;
-		}
+	pdev_sort_resources(dev, head);
+}
 
-		pdev_sort_resources(dev, &head);
-	}
+static void __assign_resources_sorted(struct resource_list *head,
+				 struct resource_list_x *fail_head)
+{
+	struct resource *res;
+	struct resource_list *list, *tmp;
+	int idx;
 
-	for (list = head.next; list;) {
+	for (list = head->next; list;) {
 		res = list->res;
 		idx = res - &list->dev->resource[0];
 		if (pci_assign_resource(list->dev, idx)) {
@@ -115,6 +114,30 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 	}
 }
 
+static void pdev_assign_resources_sorted(struct pci_dev *dev,
+				 struct resource_list_x *fail_head)
+{
+	struct resource_list head;
+
+	head.next = NULL;
+	__dev_sort_resources(dev, &head);
+	__assign_resources_sorted(&head, fail_head);
+
+}
+
+static void pbus_assign_resources_sorted(const struct pci_bus *bus,
+					 struct resource_list_x *fail_head)
+{
+	struct pci_dev *dev;
+	struct resource_list head;
+
+	head.next = NULL;
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		__dev_sort_resources(dev, &head);
+
+	__assign_resources_sorted(&head, fail_head);
+}
+
 void pci_setup_cardbus(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
@@ -273,9 +296,6 @@ static void __pci_setup_bridge(struct pci_bus *bus, unsigned long type)
 {
 	struct pci_dev *bridge = bus->self;
 
-	if (pci_is_enabled(bridge))
-		return;
-
 	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
 		 bus->secondary, bus->subordinate);
 
@@ -646,7 +666,8 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
-			pci_setup_bridge(b);
+			if (!pci_is_enabled(dev))
+				pci_setup_bridge(b);
 			break;
 
 		case PCI_CLASS_BRIDGE_CARDBUS:
@@ -667,6 +688,34 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
+static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
+					 struct resource_list_x *fail_head)
+{
+	struct pci_bus *b;
+
+	pdev_assign_resources_sorted((struct pci_dev *)bridge, fail_head);
+
+	b = bridge->subordinate;
+	if (!b)
+		return;
+
+	__pci_bus_assign_resources(b, fail_head);
+
+	switch (bridge->class >> 8) {
+	case PCI_CLASS_BRIDGE_PCI:
+		pci_setup_bridge(b);
+		break;
+
+	case PCI_CLASS_BRIDGE_CARDBUS:
+		pci_setup_cardbus(b);
+		break;
+
+	default:
+		dev_info(&bridge->dev, "not setting up bridge for bus "
+			 "%04x:%02x\n", pci_domain_nr(b), b->number);
+		break;
+	}
+}
 static void pci_bridge_release_resources(struct pci_bus *bus,
 					  unsigned long type)
 {
@@ -911,3 +960,16 @@ enable_and_dump:
 		pci_bus_dump_resources(bus);
 	}
 }
+
+void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
+{
+	struct pci_bus *parent = bridge->subordinate;
+	int retval;
+
+	pci_bus_size_bridges(parent);
+	__pci_bridge_assign_resources(bridge, NULL);
+	retval = pci_reenable_device(bridge);
+	pci_set_master(bridge);
+	pci_enable_bridges(parent);
+}
+EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6b2949c..0e240ed 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -806,6 +806,7 @@ void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
+void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);
 void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 int pci_enable_resources(struct pci_dev *, int mask);
-- 
1.6.4.2

