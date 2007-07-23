Return-Path: <linux-kernel-owner+w=401wt.eu-S936149AbXGWUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936149AbXGWUqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935958AbXGWUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:45:35 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44069 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935507AbXGWUpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:45:33 -0400
Date: Mon, 23 Jul 2007 13:48:06 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/10] x86_64: use bus conf in NB conf fun1 to get bus range on
 node
To: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707231348.07302.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/10] x86_64: use bus conf in NB conf fun1 to get bus range on node

So we use the same code with Quad core cpu as old opteron.
this patch is usfull when acpi=off or _PXM is not there in DSDT

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

--- a/arch/x86_64/pci/k8-bus.c	2007-07-23 10:35:58.000000000 -0700
+++ b/arch/x86_64/pci/k8-bus.c	2007-07-23 10:38:41.000000000 -0700
@@ -12,15 +12,18 @@
  * RED-PEN empty cpus get reported wrong
  */
 
-#define NODE_ID_REGISTER 0x60
-#define NODE_ID(dword) (dword & 0x07)
-#define LDT_BUS_NUMBER_REGISTER_0 0x94
-#define LDT_BUS_NUMBER_REGISTER_1 0xB4
-#define LDT_BUS_NUMBER_REGISTER_2 0xD4
-#define NR_LDT_BUS_NUMBER_REGISTERS 3
-#define SECONDARY_LDT_BUS_NUMBER(dword) ((dword >> 8) & 0xFF)
-#define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
+#define NODE_ID(dword) ((dword>>4) & 0x07)
+#define LDT_BUS_NUMBER_REGISTER_0 0xE0
+#define LDT_BUS_NUMBER_REGISTER_1 0xE4
+#define LDT_BUS_NUMBER_REGISTER_2 0xE8
+#define LDT_BUS_NUMBER_REGISTER_3 0xEC
+#define NR_LDT_BUS_NUMBER_REGISTERS 4
+#define SECONDARY_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
+#define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 24) & 0xFF)
+
 #define PCI_DEVICE_ID_K8HTCONFIG 0x1100
+#define PCI_DEVICE_ID_K8_10H_HTCONFIG 0x1200
+#define PCI_DEVICE_ID_K8_11H_HTCONFIG 0x1300
 
 #define BUS_NR 256
 
@@ -60,12 +63,19 @@
 {
 	int i, j;
 	unsigned slot;
-	u32 ldtbus, nid;
+	u32 ldtbus;
 	u32 id;
-	static int lbnr[3] = {
+	int node;
+	u16 deviceid;
+	u16 vendorid;
+	int min_bus;
+	int max_bus;
+
+	static int lbnr[NR_LDT_BUS_NUMBER_REGISTERS] = {
 		LDT_BUS_NUMBER_REGISTER_0,
 		LDT_BUS_NUMBER_REGISTER_1,
-		LDT_BUS_NUMBER_REGISTER_2
+		LDT_BUS_NUMBER_REGISTER_2,
+		LDT_BUS_NUMBER_REGISTER_3
 	};
 
 	memset(mp_bus_to_node, 0, BUS_NR);
@@ -73,38 +83,36 @@
 	if (!early_pci_allowed())
 		return -1;
 
-	for (slot = 0x18; slot < 0x20; slot++) {
-		id = read_pci_config(0, slot, 0, PCI_VENDOR_ID);
-		if (id != (PCI_VENDOR_ID_AMD | (PCI_DEVICE_ID_K8HTCONFIG<<16)))
-			break;
-		nid = read_pci_config(0, slot, 0, NODE_ID_REGISTER);
-
-		for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
-			ldtbus = read_pci_config(0, slot, 0, lbnr[i]);
-			/*
-			 * if there are no busses hanging off of the current
-			 * ldt link then both the secondary and subordinate
-			 * bus number fields are set to 0.
-			 *
-			 * RED-PEN
-			 * This is slightly broken because it assumes
-			 * HT node IDs == Linux node ids, which is not always
-			 * true. However it is probably mostly true.
-			 */
-			if (!(SECONDARY_LDT_BUS_NUMBER(ldtbus) == 0
-				&& SUBORDINATE_LDT_BUS_NUMBER(ldtbus) == 0)) {
-				for (j = SECONDARY_LDT_BUS_NUMBER(ldtbus);
-				     j <= SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
-				     j++) {
-					int node = NODE_ID(nid);
-					mp_bus_to_node[j] = (unsigned char)node;
-				}
-			}
-		}
+	slot = 0x18;
+	id = read_pci_config(0, slot, 0, PCI_VENDOR_ID);
+
+	vendorid = id & 0xffff;
+	if (vendorid != PCI_VENDOR_ID_AMD)
+		goto out;
+
+	deviceid = (id>>16) & 0xffff;
+	if ((deviceid != PCI_DEVICE_ID_K8HTCONFIG) &&
+	    (deviceid != PCI_DEVICE_ID_K8_10H_HTCONFIG) &&
+	    (deviceid != PCI_DEVICE_ID_K8_11H_HTCONFIG))
+		goto out;
+
+	for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
+		ldtbus = read_pci_config(0, slot, 1, lbnr[i]);
+
+		/* Check if that register is enabled for bus range */
+		if ((ldtbus & 7) != 3)
+			continue;
+
+		min_bus = SECONDARY_LDT_BUS_NUMBER(ldtbus);
+		max_bus = SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
+		node = NODE_ID(ldtbus);
+		for (j = min_bus; j <= max_bus; j++)
+			mp_bus_to_node[j] = (unsigned char) node;
 	}
 
+out:
 	for (i = 0; i < BUS_NR; i++) {
-		int node = mp_bus_to_node[i];
+		node = mp_bus_to_node[i];
 		if (node)
 			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
 	}
