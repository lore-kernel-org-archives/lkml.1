Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbZCaP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbZCaP1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762292AbZCaPYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:24:06 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15170 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762340AbZCaPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:24:03 -0400
Subject: [PATCH 11/15] PCI Hotplug: cpqphp: clean up accesses to
	pcibios_get_irq_routing_table()
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:24:02 -0600
Message-ID: <20090331152402.26622.2233.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of making multiple calls to pcibios_get_irq_routing_table, let's
just do it once and save the answer.

The reason we were making multiple calls is because we liked to calculate
its length and perform some loop over it. Instead of open-coding the length
calculation every time, provide it in an inline helper function.

Finally, since pci_print_IRQ_route() is used only for debug, let's only
do it when cpqhp_debug is set.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp.h      |    9 +++++
 drivers/pci/hotplug/cpqphp_core.c |   72 ++++++++++++++++---------------------
 drivers/pci/hotplug/cpqphp_pci.c  |   36 ++++---------------
 3 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index 308f82b..1d5561c 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -455,6 +455,7 @@ extern int cpqhp_debug;
 extern int cpqhp_legacy_mode;
 extern struct controller *cpqhp_ctrl_list;
 extern struct pci_func *cpqhp_slot_list[256];
+extern struct irq_routing_table *cpqhp_routing_table;
 
 /* these can be gotten rid of, but for debugging they are purty */
 extern u8 cpqhp_nic_irq;
@@ -733,4 +734,12 @@ static inline int wait_for_ctrl_irq(struct controller *ctrl)
 	return retval;
 }
 
+#include <asm/pci_x86.h>
+static inline int cpqhp_routing_table_length(void)
+{
+	BUG_ON(cpqhp_routing_table == NULL);
+	return ((cpqhp_routing_table->size - sizeof(struct irq_routing_table)) /
+		sizeof(struct irq_info));
+}
+
 #endif
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 857e466..7888b37 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -44,7 +44,6 @@
 
 #include "cpqphp.h"
 #include "cpqphp_nvram.h"
-#include <asm/pci_x86.h>
 
 
 /* Global variables */
@@ -52,6 +51,7 @@ int cpqhp_debug;
 int cpqhp_legacy_mode;
 struct controller *cpqhp_ctrl_list;	/* = NULL */
 struct pci_func *cpqhp_slot_list[256];
+struct irq_routing_table *cpqhp_routing_table;
 
 /* local variables */
 static void __iomem *smbios_table;
@@ -154,40 +154,42 @@ static int init_SERR(struct controller * ctrl)
 	return 0;
 }
 
-/* nice debugging output */
-static int pci_print_IRQ_route (void)
+static int init_cpqhp_routing_table(void)
 {
-	struct irq_routing_table *routing_table;
 	int len;
-	int loop;
-
-	u8 tbus, tdevice, tslot;
 
-	routing_table = pcibios_get_irq_routing_table();
-	if (routing_table == NULL) {
-		err("No BIOS Routing Table??? Not good\n");
+	cpqhp_routing_table = pcibios_get_irq_routing_table();
+	if (cpqhp_routing_table == NULL)
 		return -ENOMEM;
-	}
 
-	len = (routing_table->size - sizeof(struct irq_routing_table)) /
-			sizeof(struct irq_info);
-	/* Make sure I got at least one entry */
+	len = cpqhp_routing_table_length();
 	if (len == 0) {
-		kfree(routing_table);
+		kfree(cpqhp_routing_table);
+		cpqhp_routing_table = NULL;
 		return -1;
 	}
 
-	dbg("bus dev func slot\n");
+	return 0;
+}
+
+/* nice debugging output */
+static void pci_print_IRQ_route(void)
+{
+	int len;
+	int loop;
+	u8 tbus, tdevice, tslot;
+
+	len = cpqhp_routing_table_length();
 
+	dbg("bus dev func slot\n");
 	for (loop = 0; loop < len; ++loop) {
-		tbus = routing_table->slots[loop].bus;
-		tdevice = routing_table->slots[loop].devfn;
-		tslot = routing_table->slots[loop].slot;
+		tbus = cpqhp_routing_table->slots[loop].bus;
+		tdevice = cpqhp_routing_table->slots[loop].devfn;
+		tslot = cpqhp_routing_table->slots[loop].slot;
 		dbg("%d %d %d %d\n", tbus, tdevice >> 3, tdevice & 0x7, tslot);
 
 	}
-	kfree(routing_table);
-	return 0;
+	return;
 }
 
 
@@ -331,7 +333,6 @@ static int ctrl_slot_cleanup (struct controller * ctrl)
 static int
 get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 {
-	struct irq_routing_table *PCIIRQRoutingInfoLength;
 	u32 work;
 	long len;
 	long loop;
@@ -342,26 +343,14 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 
 	bridgeSlot = 0xFF;
 
-	PCIIRQRoutingInfoLength = pcibios_get_irq_routing_table();
-	if (!PCIIRQRoutingInfoLength)
-		return -1;
-
-	len = (PCIIRQRoutingInfoLength->size -
-	       sizeof(struct irq_routing_table)) / sizeof(struct irq_info);
-	/* Make sure I got at least one entry */
-	if (len == 0) {
-		kfree(PCIIRQRoutingInfoLength);
-		return -1;
-	}
-
+	len = cpqhp_routing_table_length();
 	for (loop = 0; loop < len; ++loop) {
-		tbus = PCIIRQRoutingInfoLength->slots[loop].bus;
-		tdevice = PCIIRQRoutingInfoLength->slots[loop].devfn >> 3;
-		tslot = PCIIRQRoutingInfoLength->slots[loop].slot;
+		tbus = cpqhp_routing_table->slots[loop].bus;
+		tdevice = cpqhp_routing_table->slots[loop].devfn >> 3;
+		tslot = cpqhp_routing_table->slots[loop].slot;
 
 		if ((tbus == bus_num) && (tdevice == dev_num)) {
 			*slot = tslot;
-			kfree(PCIIRQRoutingInfoLength);
 			return 0;
 		} else {
 			/* Did not get a match on the target PCI device. Check
@@ -396,10 +385,8 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 	 */
 	if (bridgeSlot != 0xFF) {
 		*slot = bridgeSlot;
-		kfree(PCIIRQRoutingInfoLength);
 		return 0;
 	}
-	kfree(PCIIRQRoutingInfoLength);
 	/* Couldn't find an entry in the routing table for this PCI device */
 	return -1;
 }
@@ -782,10 +769,13 @@ static int one_time_init(void)
 
 	power_mode = 0;
 
-	retval = pci_print_IRQ_route();
+	retval = init_cpqhp_routing_table();
 	if (retval)
 		goto error;
 
+	if (cpqhp_debug)
+		pci_print_IRQ_route();
+
 	dbg("Initialize + Start the notification mechanism \n");
 
 	retval = cpqhp_event_start_thread();
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 2909e3f..6201281 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -37,7 +37,6 @@
 #include "../pci.h"
 #include "cpqphp.h"
 #include "cpqphp_nvram.h"
-#include <asm/pci_x86.h>
 
 
 u8 cpqhp_nic_irq;
@@ -244,39 +243,23 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 * dev
 
 static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num, u8 slot, u8 nobridge)
 {
-	struct irq_routing_table *PCIIRQRoutingInfoLength;
-	long len;
-	long loop;
+	int loop, len;
 	u32 work;
-
 	u8 tbus, tdevice, tslot;
 
-	PCIIRQRoutingInfoLength = pcibios_get_irq_routing_table();
-	if (!PCIIRQRoutingInfoLength)
-		return -1;
-
-	len = (PCIIRQRoutingInfoLength->size -
-	       sizeof(struct irq_routing_table)) / sizeof(struct irq_info);
-	/* Make sure I got at least one entry */
-	if (len == 0) {
-		kfree(PCIIRQRoutingInfoLength );
-		return -1;
-	}
-
+	len = cpqhp_routing_table_length();
 	for (loop = 0; loop < len; ++loop) {
-		tbus = PCIIRQRoutingInfoLength->slots[loop].bus;
-		tdevice = PCIIRQRoutingInfoLength->slots[loop].devfn;
-		tslot = PCIIRQRoutingInfoLength->slots[loop].slot;
+		tbus = cpqhp_routing_table->slots[loop].bus;
+		tdevice = cpqhp_routing_table->slots[loop].devfn;
+		tslot = cpqhp_routing_table->slots[loop].slot;
 
 		if (tslot == slot) {
 			*bus_num = tbus;
 			*dev_num = tdevice;
 			ctrl->pci_bus->number = tbus;
 			pci_bus_read_config_dword (ctrl->pci_bus, *dev_num, PCI_VENDOR_ID, &work);
-			if (!nobridge || (work == 0xffffffff)) {
-				kfree(PCIIRQRoutingInfoLength );
+			if (!nobridge || (work == 0xffffffff))
 				return 0;
-			}
 
 			dbg("bus_num %d devfn %d\n", *bus_num, *dev_num);
 			pci_bus_read_config_dword (ctrl->pci_bus, *dev_num, PCI_CLASS_REVISION, &work);
@@ -287,17 +270,12 @@ static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num
 				dbg("Scan bus for Non Bridge: bus %d\n", tbus);
 				if (PCI_ScanBusForNonBridge(ctrl, tbus, dev_num) == 0) {
 					*bus_num = tbus;
-					kfree(PCIIRQRoutingInfoLength );
 					return 0;
 				}
-			} else {
-				kfree(PCIIRQRoutingInfoLength );
+			} else
 				return 0;
-			}
-
 		}
 	}
-	kfree(PCIIRQRoutingInfoLength );
 	return -1;
 }
 

