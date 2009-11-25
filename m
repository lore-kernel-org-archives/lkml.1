Return-Path: <linux-kernel-owner+w=401wt.eu-S934934AbZKYUBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934AbZKYUBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbZKYUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:01:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:56942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759733AbZKYUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:01:00 -0500
Message-ID: <4B0D8CAF.7040007@kernel.org>
Date: Wed, 25 Nov 2009 11:59:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 7/9] pci: introduce pci_assign_unassigned_bridge_resources
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B0D88A4.5050904@kerne!
 l.org>
In-Reply-To: <4B0D88A4.5050904@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for pciehp to use it later

pci_setup_bridge() will not check enabled for the slot bridge, otherwise
update res is not updated to bridge BAR. that is bridge is enabled already for
port service.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   94 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/pci.h     |    1 
 2 files changed, 91 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -68,6 +68,51 @@ static void free_failed_list(struct reso
 	head->next = NULL;
 }
 
+static void pdev_assign_resources_sorted(struct pci_dev *dev,
+				 struct resource_list *fail_head)
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
+			} else {
+				res->start = 0;
+				res->end = 0;
+				res->flags = 0;
+			}
+		}
+		tmp = list;
+		list = list->next;
+		kfree(tmp);
+	}
+}
 static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 					 struct resource_list *fail_head)
 {
@@ -281,9 +326,6 @@ static void __pci_setup_bridge(struct pc
 {
 	struct pci_dev *bridge = bus->self;
 
-	if (pci_is_enabled(bridge))
-		return;
-
 	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
 		 bus->secondary, bus->subordinate);
 
@@ -646,7 +688,8 @@ static void __ref __pci_bus_assign_resou
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
-			pci_setup_bridge(b);
+			if (!pci_is_enabled(dev))
+				pci_setup_bridge(b);
 			break;
 
 		case PCI_CLASS_BRIDGE_CARDBUS:
@@ -667,6 +710,34 @@ void __ref pci_bus_assign_resources(cons
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
+static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
+					 struct resource_list *fail_head)
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
 static void release_children_resource(struct resource *r)
 {
 	struct resource *p;
@@ -894,3 +965,18 @@ enable_and_dump:
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
+	pci_clear_master(bridge);
+	__pci_bridge_assign_resources(bridge, NULL);
+	retval = pci_reenable_device(bridge);
+	pci_set_master(bridge);
+	pci_enable_bridges(parent);
+}
+EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -768,6 +768,7 @@ void pci_bus_assign_resources(const stru
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
+void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);
 void pdev_sort_resources(struct pci_dev *, struct resource_list *);
 int pci_enable_resources(struct pci_dev *, int mask);

