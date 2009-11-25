Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZKYL1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZKYL1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZKYL1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:27:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53841 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZKYL1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:27:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0D148C.6020302@jp.fujitsu.com>
Date: Wed, 25 Nov 2009 20:27:08 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 2/2] pciehp: add support for bridge resource reallocation
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel.org> <4B0D13EB.9010403@jp.fujitsu.com>
In-Reply-To: <4B0D13EB.9010403@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform BIOS doesn't assign PCI bridge resources (IO base/limit,
Mem base/limit and Prefechable Mem base/limit) to root port or switch
downstream port with hotplug slots. On such platform, PCIe hotplug
doesn't work due to the resource allocation failure. This patch is to
improbe this situation.

With this patch, pciehp driver try to assign PCI bridge resources to
parent bridge (root port or switch downstream port) of the slot in
addition to assign resources to the hot-added device.

With this patch, pciehp driver try to release PCI bridge resources so
that we can reassign those resources to another root port on the same
PCI bus segment, or to another downstream port on the same swith.

This feature is enabled when 'pciehp_realloc' option is specified.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/pciehp.h      |    1 
 drivers/pci/hotplug/pciehp_core.c |    9 ++++
 drivers/pci/hotplug/pciehp_pci.c  |    9 +++-
 drivers/pci/setup-bus.c           |   84 +++++++++++++++++++++++++++++---------
 include/linux/pci.h               |    2 
 5 files changed, 85 insertions(+), 20 deletions(-)

Index: 20091125/drivers/pci/setup-bus.c
===================================================================
--- 20091125.orig/drivers/pci/setup-bus.c
+++ 20091125/drivers/pci/setup-bus.c
@@ -27,13 +27,31 @@
 #include <linux/slab.h>
 #include "pci.h"
 
-static void pbus_assign_resources_sorted(const struct pci_bus *bus)
+static void pbus_assign_resources_list(struct resource_list *head)
 {
-	struct pci_dev *dev;
 	struct resource *res;
-	struct resource_list head, *list, *tmp;
+	struct resource_list *list, *tmp;
 	int idx;
 
+	for (list = head->next; list;) {
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
+static void pbus_assign_resources_sorted(const struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+	struct resource_list head;
+
 	head.next = NULL;
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		u16 class = dev->class >> 8;
@@ -54,18 +72,7 @@ static void pbus_assign_resources_sorted
 		pdev_sort_resources(dev, &head);
 	}
 
-	for (list = head.next; list;) {
-		res = list->res;
-		idx = res - &list->dev->resource[0];
-		if (pci_assign_resource(list->dev, idx)) {
-			res->start = 0;
-			res->end = 0;
-			res->flags = 0;
-		}
-		tmp = list;
-		list = list->next;
-		kfree(tmp);
-	}
+	pbus_assign_resources_list(&head);
 }
 
 void pci_setup_cardbus(struct pci_bus *bus)
@@ -142,9 +149,6 @@ static void pci_setup_bridge(struct pci_
 	u32 l, bu, lu, io_upper16;
 	int pref_mem64;
 
-	if (pci_is_enabled(bridge))
-		return;
-
 	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
 		 bus->secondary, bus->subordinate);
 
@@ -559,7 +563,8 @@ void __ref pci_bus_assign_resources(cons
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
-			pci_setup_bridge(b);
+			if (!pci_is_enabled(dev))
+				pci_setup_bridge(b);
 			break;
 
 		case PCI_CLASS_BRIDGE_CARDBUS:
@@ -575,6 +580,47 @@ void __ref pci_bus_assign_resources(cons
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
+void __ref pci_bridge_assign_resources(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	struct resource_list head;
+
+	if (pci_is_root_bus(bus) ||
+	    (bridge->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return;
+
+	head.next = NULL;
+	pdev_sort_resources(bridge, &head);
+	pbus_assign_resources_list(&head);
+	pci_bus_assign_resources(bus);
+	pci_setup_bridge(bus);
+}
+EXPORT_SYMBOL(pci_bridge_assign_resources);
+
+void __ref pci_bridge_release_window(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	int i;
+
+	if (pci_is_root_bus(bus) ||
+	    (bridge->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return;
+
+	for (i = 0; i < 3; i++)
+		if (bus->resource[i]->child)
+			return;
+
+	for (i = 0; i < 3; i++)
+		bus->resource[i]->flags = 0;
+
+	pci_setup_bridge(bus);
+
+	for (i = 0; i < 3; i++)
+		if (bus->resource[i]->parent)
+			release_resource(bus->resource[i]);
+}
+EXPORT_SYMBOL(pci_bridge_release_window);
+
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
         int i;
Index: 20091125/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- 20091125.orig/drivers/pci/hotplug/pciehp_core.c
+++ 20091125/drivers/pci/hotplug/pciehp_core.c
@@ -41,6 +41,7 @@ int pciehp_debug;
 int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
+int pciehp_realloc;
 struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
@@ -55,10 +56,13 @@ module_param(pciehp_debug, bool, 0644);
 module_param(pciehp_poll_mode, bool, 0644);
 module_param(pciehp_poll_time, int, 0644);
 module_param(pciehp_force, bool, 0644);
+module_param(pciehp_realloc, bool, 0644);
+
 MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
 MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
+MODULE_PARM_DESC(pciehp_realloc, "Realloc resources for slot's parent bridge");
 
 #define PCIE_MODULE_NAME "pciehp"
 
@@ -293,10 +297,15 @@ static int pciehp_probe(struct pcie_devi
 	pciehp_get_power_status(slot, &poweron);
 	if (occupied && pciehp_force)
 		pciehp_enable_slot(slot);
+
 	/* If empty slot's power status is on, turn power off */
 	if (!occupied && poweron && POWER_CTRL(ctrl))
 		pciehp_power_off_slot(slot);
 
+	/* If no device is running on the slot, release bridge's I/O window */
+	if (pciehp_realloc && !poweron)
+		pci_bridge_release_window(dev->port->subordinate);
+
 	return 0;
 
 err_out_free_ctrl_slot:
Index: 20091125/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- 20091125.orig/drivers/pci/hotplug/pciehp_pci.c
+++ 20091125/drivers/pci/hotplug/pciehp_pci.c
@@ -97,7 +97,10 @@ int pciehp_configure_device(struct slot 
 	}
 
 	pci_bus_size_bridges(parent);
-	pci_bus_assign_resources(parent);
+	if (pciehp_realloc)
+		pci_bridge_assign_resources(parent);
+	else
+		pci_bus_assign_resources(parent);
 	pci_enable_bridges(parent);
 	pci_bus_add_devices(parent);
 	return 0;
@@ -153,5 +156,9 @@ int pciehp_unconfigure_device(struct slo
 		pci_dev_put(temp);
 	}
 
+	/* Release I/O window of the slots's parent bridge */
+	if (pciehp_realloc)
+		pci_bridge_release_window(parent);
+
 	return rc;
 }
Index: 20091125/include/linux/pci.h
===================================================================
--- 20091125.orig/include/linux/pci.h
+++ 20091125/include/linux/pci.h
@@ -764,6 +764,8 @@ int pci_vpd_truncate(struct pci_dev *dev
 
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 void pci_bus_assign_resources(const struct pci_bus *bus);
+void pci_bridge_assign_resources(struct pci_bus *bus);
+void pci_bridge_release_window(struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
 void pci_assign_unassigned_resources(void);
Index: 20091125/drivers/pci/hotplug/pciehp.h
===================================================================
--- 20091125.orig/drivers/pci/hotplug/pciehp.h
+++ 20091125/drivers/pci/hotplug/pciehp.h
@@ -43,6 +43,7 @@ extern int pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern int pciehp_debug;
 extern int pciehp_force;
+extern int pciehp_realloc;
 extern struct workqueue_struct *pciehp_wq;
 
 #define dbg(format, arg...)						\

