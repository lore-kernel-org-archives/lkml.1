Return-Path: <linux-kernel-owner+w=401wt.eu-S1763070AbYBSLOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763070AbYBSLOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbYBSLNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:13:37 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55049 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254AbYBSLNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:13:31 -0500
Date: Tue, 19 Feb 2008 03:20:09 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/8] x86_64: get mp_bus_to_node as early v4
In-reply-to: <200802190311.44404.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802190320.09833.yinghai.lu@sun.com>
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


current on amd k8 system with multi ht chain, the numa_node of pci devices under
/sys/devices/pci0000:80/* always 0, even that chain is on node 1 or 2 or 3.

workaround: pcibus_to_node(bus) is used when we want to get node that pci_device is on.

In struct device, we already have numa_node member. and we could use dev_to_node()
/set_dev_node() to get and set numa_node in the device.
set_dev_node is called in pci_device_add() with pcibus_to_node(bus). and
pcibus_to_node use bus->sysdata for nodeid.

the problem is when pci_add_device is called, bus->sysdata is not assigned
correct nodeid yet. the result will be numa_node always is 0.

pcibios_scan_root and pci_scan_root could take sysdata. So we need to get
mp_bus_to_node mapping before these two are called. and get_mp_bus_to_node
could get correct node for sysdata in root bus.

in scanning of root bus, all child bus will take parent bus sysdata. So all
pci_device->dev.numa_node will be assigned correctly automatically.

later we could use dev_to_node(&pci_dev->dev) to get numa_node, and we could also
could make other bus specific device get the correct numa_node too.

this is one update version to pci_sysdata and jeff's pci_domain patch.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

 arch/i386/pci/Makefile         |    1
 arch/i386/pci/Makefile         |    1
 arch/i386/pci/acpi.c           |   40 +++++--------------
 arch/i386/pci/common.c         |   17 ++++++--
 arch/i386/pci/irq.c            |    4 +
 arch/i386/pci/legacy.c         |    6 ++
 arch/i386/pci/mp_bus_to_node.c |   24 +++++++++++
 arch/x86_64/pci/k8-bus.c       |   83 ++++++++++++++++++++++++++++-------------
 include/asm-i386/pci.h         |    1
 include/asm-i386/topology.h    |   10 ++++
 include/asm-x86_64/pci.h       |    1
 include/asm-x86_64/topology.h  |   13 ++++++
 11 files changed, 138 insertions(+), 62 deletions(-)

Index: linux-2.6/arch/x86/pci/Makefile_32
===================================================================
--- linux-2.6.orig/arch/x86/pci/Makefile_32
+++ linux-2.6/arch/x86/pci/Makefile_32
@@ -10,5 +10,6 @@ pci-y				+= legacy.o irq.o
 
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
 pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -191,7 +191,10 @@ struct pci_bus * __devinit pci_acpi_scan
 {
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
+	int node;
+#ifdef CONFIG_ACPI_NUMA
 	int pxm;
+#endif
 
 	dmi_check_system(acpi_pciprobe_dmi_table);
 
@@ -201,6 +204,17 @@ struct pci_bus * __devinit pci_acpi_scan
 		return NULL;
 	}
 
+	node = -1;
+#ifdef CONFIG_ACPI_NUMA
+	pxm = acpi_get_pxm(device->handle);
+	if (pxm >= 0)
+		node = pxm_to_node(pxm);
+	if (node != -1)
+		set_mp_bus_to_node(busnum, node);
+	else
+		node = get_mp_bus_to_node(busnum);
+#endif
+
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
 	 * It's arguable whether it's worth the trouble to care.
@@ -212,22 +226,16 @@ struct pci_bus * __devinit pci_acpi_scan
 	}
 
 	sd->domain = domain;
-	sd->node = -1;
-
-	pxm = acpi_get_pxm(device->handle);
-#ifdef CONFIG_ACPI_NUMA
-	if (pxm >= 0)
-		sd->node = pxm_to_node(pxm);
-#endif
+	sd->node = node;
 
 	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
 	if (!bus)
 		kfree(sd);
 
 #ifdef CONFIG_ACPI_NUMA
-	if (bus != NULL) {
+	if (bus) {
 		if (pxm >= 0) {
-			printk("bus %d -> pxm %d -> node %d\n",
+			printk(KERN_DEBUG "bus %02x -> pxm %d -> node %d\n",
 				busnum, pxm, sd->node);
 		}
 	}
@@ -235,7 +243,6 @@ struct pci_bus * __devinit pci_acpi_scan
 
 	if (bus && (pci_probe & PCI_USE__CRS))
 		get_current_resources(device, busnum, bus);
-	
 	return bus;
 }
 
Index: linux-2.6/arch/x86/pci/common.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/common.c
+++ linux-2.6/arch/x86/pci/common.c
@@ -396,9 +396,14 @@ struct pci_bus * __devinit pcibios_scan_
 		return NULL;
 	}
 
+	sd->node = get_mp_bus_to_node(busnum);
+
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
+	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	if (!bus)
+		kfree(sd);
 
-	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	return bus;
 }
 
 extern u8 pci_cache_line_size;
@@ -541,7 +546,7 @@ void pcibios_disable_device (struct pci_
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
+struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
@@ -556,10 +561,15 @@ struct pci_bus *__devinit pci_scan_bus_w
 		printk(KERN_ERR "PCI: OOM, skipping PCI bus %02x\n", busno);
 		return NULL;
 	}
-	sd->node = -1;
-	bus = pci_scan_bus(busno, &pci_root_ops, sd);
+	sd->node = node;
+	bus = pci_scan_bus(busno, ops, sd);
 	if (!bus)
 		kfree(sd);
 
 	return bus;
 }
+
+struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+{
+	return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
+}
Index: linux-2.6/arch/x86/pci/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/irq.c
+++ linux-2.6/arch/x86/pci/irq.c
@@ -136,9 +136,11 @@ static void __init pirq_peer_trick(void)
 		busmap[e->bus] = 1;
 	}
 	for(i = 1; i < 256; i++) {
+		int node;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pci_scan_bus_with_sysdata(i))
+		node = get_mp_bus_to_node(i);
+		if (pci_scan_bus_on_node(i, &pci_root_ops, node))
 			printk(KERN_INFO "PCI: Discovered primary peer "
 			       "bus %02x [IRQ]\n", i);
 	}
Index: linux-2.6/arch/x86/pci/legacy.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/legacy.c
+++ linux-2.6/arch/x86/pci/legacy.c
@@ -12,6 +12,7 @@
 static void __devinit pcibios_fixup_peer_bridges(void)
 {
 	int n, devfn;
+	long node;
 
 	if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
 		return;
@@ -21,12 +22,13 @@ static void __devinit pcibios_fixup_peer
 		u32 l;
 		if (pci_find_bus(0, n))
 			continue;
+		node = get_mp_bus_to_node(n);
 		for (devfn = 0; devfn < 256; devfn += 8) {
 			if (!raw_pci_read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus_with_sysdata(n);
+				pci_scan_bus_on_node(n, &pci_root_ops, node);
 				break;
 			}
 		}
Index: linux-2.6/arch/x86/pci/mp_bus_to_node.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/pci/mp_bus_to_node.c
@@ -0,0 +1,23 @@
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/topology.h>
+
+#define BUS_NR 256
+
+static unsigned char mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+	mp_bus_to_node[busnum] = (unsigned char) node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1))
+		return 0;
+	node = mp_bus_to_node[busnum];
+	return node;
+}
Index: linux-2.6/arch/x86/pci/k8-bus_64.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/k8-bus_64.c
+++ linux-2.6/arch/x86/pci/k8-bus_64.c
@@ -1,7 +1,9 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <asm/mpspec.h>
 #include <linux/cpumask.h>
+#include <linux/topology.h>
 
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
@@ -20,64 +22,96 @@
 #define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
 #define PCI_DEVICE_ID_K8HTCONFIG 0x1100
 
+#define BUS_NR 256
+
+static int mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+		mp_bus_to_node[busnum] = node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node = -1;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1))
+		return node;
+
+	node = mp_bus_to_node[busnum];
+
+	/*
+	 * let numa_node_id to decide it later in dma_alloc_pages
+	 * if there is no ram on that node
+	 */
+	if (node != -1 && !node_online(node))
+		node = -1;
+
+	return node;
+}
+
 /**
- * fill_mp_bus_to_cpumask()
+ * early_fill_mp_bus_to_node()
+ * called before pcibios_scan_root and pci_scan_bus
  * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
  * Registers found in the K8 northbridge
  */
 __init static int
-fill_mp_bus_to_cpumask(void)
+early_fill_mp_bus_to_node(void)
 {
-	struct pci_dev *nb_dev = NULL;
 	int i, j;
+	unsigned slot;
 	u32 ldtbus, nid;
+	u32 id;
 	static int lbnr[3] = {
 		LDT_BUS_NUMBER_REGISTER_0,
 		LDT_BUS_NUMBER_REGISTER_1,
 		LDT_BUS_NUMBER_REGISTER_2
 	};
 
-	while ((nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-			PCI_DEVICE_ID_K8HTCONFIG, nb_dev))) {
-		pci_read_config_dword(nb_dev, NODE_ID_REGISTER, &nid);
+	for (i = 0; i < BUS_NR; i++)
+		mp_bus_to_node[i] = -1;
+
+	if (!early_pci_allowed())
+		return -1;
+
+	for (slot = 0x18; slot < 0x20; slot++) {
+		id = read_pci_config(0, slot, 0, PCI_VENDOR_ID);
+		if (id != (PCI_VENDOR_ID_AMD | (PCI_DEVICE_ID_K8HTCONFIG<<16)))
+			break;
+		nid = read_pci_config(0, slot, 0, NODE_ID_REGISTER);
 
 		for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
-			pci_read_config_dword(nb_dev, lbnr[i], &ldtbus);
+			ldtbus = read_pci_config(0, slot, 0, lbnr[i]);
 			/*
 			 * if there are no busses hanging off of the current
 			 * ldt link then both the secondary and subordinate
 			 * bus number fields are set to 0.
-			 * 
+			 *
 			 * RED-PEN
 			 * This is slightly broken because it assumes
- 			 * HT node IDs == Linux node ids, which is not always
+			 * HT node IDs == Linux node ids, which is not always
 			 * true. However it is probably mostly true.
 			 */
 			if (!(SECONDARY_LDT_BUS_NUMBER(ldtbus) == 0
 				&& SUBORDINATE_LDT_BUS_NUMBER(ldtbus) == 0)) {
 				for (j = SECONDARY_LDT_BUS_NUMBER(ldtbus);
 				     j <= SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
-				     j++) { 
-					struct pci_bus *bus;
-					struct pci_sysdata *sd;
-
-					long node = NODE_ID(nid);
-					/* Algorithm a bit dumb, but
- 					   it shouldn't matter here */
-					bus = pci_find_bus(0, j);
-					if (!bus)
-						continue;
-					if (!node_online(node))
-						node = 0;
-
-					sd = bus->sysdata;
-					sd->node = node;
-				}		
+				     j++) {
+					int node = NODE_ID(nid);
+					mp_bus_to_node[j] = (unsigned char)node;
+				}
 			}
 		}
 	}
 
+	for (i = 0; i < BUS_NR; i++) {
+		int node = mp_bus_to_node[i];
+		if (node >= 0)
+			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
+	}
 	return 0;
 }
 
-fs_initcall(fill_mp_bus_to_cpumask);
+postcore_initcall(early_fill_mp_bus_to_node);
Index: linux-2.6/include/asm-x86/pci.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pci.h
+++ linux-2.6/include/asm-x86/pci.h
@@ -20,6 +20,8 @@ struct pci_sysdata {
 };
 
 /* scan a bus after allocating a pci_sysdata for it */
+extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
+					    int node);
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
 static inline int pci_domain_nr(struct pci_bus *bus)
Index: linux-2.6/include/asm-x86/topology.h
===================================================================
--- linux-2.6.orig/include/asm-x86/topology.h
+++ linux-2.6/include/asm-x86/topology.h
@@ -165,8 +165,19 @@ extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
 
+int get_mp_bus_to_node(int busnum);
+void set_mp_bus_to_node(int busnum, int node);
+
 #else /* CONFIG_NUMA */
 
+static inline int get_mp_bus_to_node(int busnum)
+{
+	return 0;
+}
+static inline void set_mp_bus_to_node(int busnum, int node)
+{
+}
+
 #include <asm-generic/topology.h>
 
 #endif
