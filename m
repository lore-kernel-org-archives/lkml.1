Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0APCqH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749Ab0APCpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:45:55 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57730 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab0APCnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:43:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 18:41:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/11] pci: introduce pci_assign_unassigned_bridge_resources
In-reply-to: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263609721-3921-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for pciehp to use it later

pci_setup_bridge() will not check enabled for the slot bridge, otherwise
update res is not updated to bridge BAR. that is bridge is enabled already for
port service.

-v2: update it with resource_list_x
-v3: remove the clear busmaster. according to Kenji

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   92 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h     |    1 +
 2 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8ad515e..c348882 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -71,6 +71,50 @@ static void free_failed_list(struct resource_list_x *head)
 	head->next = NULL;
 }
 
+static void pdev_assign_resources_sorted(struct pci_dev *dev,
+				 struct resource_list_x *fail_head)
+{
+	struct resource *res;
+	struct resource_list head, *list, *tmp;
+	int idx;
+	u16 class = dev->class >> 8;
+
+	head.next = NULL;
+
+	/* Don't touch classless devices or host bridges or ioapics.  */
+	if (class == PCI_CLASS_NOT_DEFINED || class == PCI_CLASS_BRIDGE_HOST)
+		return;
+
+	/* Don't touch ioapic devices already enabled by firmware */
+	if (class == PCI_CLASS_SYSTEM_PIC) {
+		u16 command;
+		pci_read_config_word(dev, PCI_COMMAND, &command);
+		if (command & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY))
+			return;
+	}
+
+	pdev_sort_resources(dev, &head);
+
+	for (list = head.next; list;) {
+		res = list->res;
+		idx = res - &list->dev->resource[0];
+		if (pci_assign_resource(list->dev, idx)) {
+			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
+				/*
+				 * device need to keep flags and size
+				 * for second try
+				 */
+				add_to_failed_list(fail_head, list->dev, res);
+			}
+			res->start = 0;
+			res->end = 0;
+			res->flags = 0;
+		}
+		tmp = list;
+		list = list->next;
+		kfree(tmp);
+	}
+}
 static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 					 struct resource_list_x *fail_head)
 {
@@ -278,9 +322,6 @@ static void __pci_setup_bridge(struct pci_bus *bus, unsigned long type)
 {
 	struct pci_dev *bridge = bus->self;
 
-	if (pci_is_enabled(bridge))
-		return;
-
 	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
 		 bus->secondary, bus->subordinate);
 
@@ -651,7 +692,8 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
-			pci_setup_bridge(b);
+			if (!pci_is_enabled(dev))
+				pci_setup_bridge(b);
 			break;
 
 		case PCI_CLASS_BRIDGE_CARDBUS:
@@ -672,6 +714,34 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
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
@@ -934,3 +1004,17 @@ enable_and_dump:
 		pci_bus_dump_resources(bus);
 	}
 }
+
+void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
+{
+	struct pci_bus *bus;
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

