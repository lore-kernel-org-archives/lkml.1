Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZJUHUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZJUHUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 03:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZJUHUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 03:20:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:58353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbZJUHUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 03:20:03 -0400
Message-ID: <4ADEB601.8020200@kernel.org>
Date: Wed, 21 Oct 2009 00:19:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH] pci: pciehp update the slot bridge res to get big range for
 pcie devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move out bus_size_bridges and assign resources out of pciehp_add_bridge()
and at last do them all together one time including slot bridge, to avoid to call
assign resources several times, when there are several bridges under the slot bridge.

need to introduce pci_bridge_assign_resources there.

handle the case the first bridge that doesn't get pre-allocated big enough res from FW.
for example pcie devices need 256M, but the bridge only get preallocated 2M...

pci_is_enabled must be removed in pci_setup_bridge(), otherwise update res is not
updated to bridge BAR. and we are safe to do that, because only have one bus_size
and assigned resources are called.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/hotplug/pciehp_pci.c |   29 ++++++++++++----
 drivers/pci/setup-bus.c          |   70 +++++++++++++++++++++++++++++++++++++--
 include/linux/pci.h              |    1 
 3 files changed, 90 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
@@ -53,19 +53,18 @@ static int __ref pciehp_add_bridge(struc
 		busnr = pci_scan_bridge(parent, dev, busnr, pass);
 	if (!dev->subordinate)
 		return -1;
-	pci_bus_size_bridges(dev->subordinate);
-	pci_bus_assign_resources(parent);
-	pci_enable_bridges(parent);
-	pci_bus_add_devices(parent);
+
 	return 0;
 }
 
 int pciehp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
-	struct pci_bus *parent = p_slot->ctrl->pcie->port->subordinate;
+	struct pci_dev *bridge = p_slot->ctrl->pcie->port;
+	struct pci_bus *parent = bridge->subordinate;
 	int num, fn;
 	struct controller *ctrl = p_slot->ctrl;
+	int retval;
 
 	dev = pci_get_slot(parent, PCI_DEVFN(0, 0));
 	if (dev) {
@@ -96,12 +95,28 @@ int pciehp_configure_device(struct slot
 				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
 			pciehp_add_bridge(dev);
 		}
-		pci_configure_slot(dev);
 		pci_dev_put(dev);
 	}
 
-	pci_bus_assign_resources(parent);
+	pci_bus_size_bridges(parent);
+	pci_bridge_assign_resources(bridge);
+	retval = pci_reenable_device(bridge);
+	pci_set_master(bridge);
+	pci_enable_bridges(parent);
 	pci_bus_add_devices(parent);
+
+	for (fn = 0; fn < 8; fn++) {
+		dev = pci_get_slot(parent, PCI_DEVFN(0, fn));
+		if (!dev)
+			continue;
+		if ((dev->class >> 16) == PCI_BASE_CLASS_DISPLAY) {
+			pci_dev_put(dev);
+			continue;
+		}
+		pci_configure_slot(dev);
+		pci_dev_put(dev);
+	}
+
 	return 0;
 }
 
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -27,6 +27,44 @@
 #include <linux/slab.h>
 #include "pci.h"
 
+static void pdev_assign_resources_sorted(struct pci_dev *dev)
+{
+	struct resource *res;
+	struct resource_list head, *list, *tmp;
+	int idx;
+	u16 class = dev->class >> 8;
+
+	head.next = NULL;
+
+	/* Don't touch classless devices or host bridges or ioapics.  */
+	if (class == PCI_CLASS_NOT_DEFINED ||
+	    class == PCI_CLASS_BRIDGE_HOST)
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
+			res->start = 0;
+			res->end = 0;
+			res->flags = 0;
+		}
+		tmp = list;
+		list = list->next;
+		kfree(tmp);
+	}
+}
+
 static void pbus_assign_resources_sorted(const struct pci_bus *bus)
 {
 	struct pci_dev *dev;
@@ -144,9 +182,6 @@ static void pci_setup_bridge(struct pci_
 	u32 l, bu, lu, io_upper16;
 	int pref_mem64;
 
-	if (pci_is_enabled(bridge))
-		return;
-
 	dev_info(&bridge->dev, "PCI bridge, secondary bus %04x:%02x\n",
 		 pci_domain_nr(bus), bus->number);
 
@@ -550,6 +585,35 @@ void __ref pci_bus_size_bridges(struct p
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
+void __ref pci_bridge_assign_resources(const struct pci_dev *bridge)
+{
+	struct pci_bus *b;
+
+	pdev_assign_resources_sorted((struct pci_dev *)bridge);
+
+	b = bridge->subordinate;
+	if (!b)
+		return;
+
+	pci_bus_assign_resources(b);
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
+EXPORT_SYMBOL(pci_bridge_assign_resources);
+
 void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 {
 	struct pci_bus *b;
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -756,6 +756,7 @@ ssize_t pci_write_vpd(struct pci_dev *de
 int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
+void pci_bridge_assign_resources(const struct pci_dev *bridge);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);

