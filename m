Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbYBSLNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbYBSLNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbYBSLNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:13:32 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55037 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbYBSLNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:13:30 -0500
Date: Tue, 19 Feb 2008 03:15:08 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 4/8] x86_64: use bus conf in NB conf fun1 to get bus range on
 node
In-reply-to: <200802190311.44404.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802190315.08218.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802190311.44404.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So we use the same code with Quad core cpu as old opteron.
this patch is usful when acpi=off or _PXM is not there in DSDT

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/k8-bus_64.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/k8-bus_64.c
+++ linux-2.6/arch/x86/pci/k8-bus_64.c
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
 
@@ -62,12 +65,19 @@ early_fill_mp_bus_to_node(void)
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
 
 	for (i = 0; i < BUS_NR; i++)
@@ -76,38 +86,36 @@ early_fill_mp_bus_to_node(void)
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
 		if (node >= 0)
 			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
 	}
