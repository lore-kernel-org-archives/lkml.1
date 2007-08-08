Return-Path: <linux-kernel-owner+w=401wt.eu-S935666AbXHHBWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935666AbXHHBWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764733AbXHHBVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:21:00 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46054 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471AbXHHBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:20:57 -0400
Date: Tue, 07 Aug 2007 18:20:33 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/5] x86_64: get mp_bus_to_node as early v3
In-reply-to: <200708072245.l77MjVxU008742@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, ak@suse.de
Cc: apw@shadowen.org, clameter@sgi.com, greg@kroah.com, muli@il.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708071820.33720.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200708072245.l77MjVxU008742@imap1.linux-foundation.org>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

please check this one against pci_scan_bus_with_sysdata

[PATCH 1/5] x86_64: get mp_bus_to_node as early v3

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

this is one update version to pci_sysdata ...
also reverse pci_acpi_scan_root to use pcibios_scan_root again.

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

diff --git a/arch/i386/pci/Makefile b/arch/i386/pci/Makefile
index 44650e0..600d0e7 100644
--- a/arch/i386/pci/Makefile
+++ b/arch/i386/pci/Makefile
@@ -10,5 +10,6 @@ pci-y				+= legacy.o irq.o
 
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
 pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
diff --git a/arch/i386/pci/acpi.c b/arch/i386/pci/acpi.c
index bc8a44b..dfa24a1 100644
--- a/arch/i386/pci/acpi.c
+++ b/arch/i386/pci/acpi.c
@@ -8,46 +8,28 @@
 struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int domain, int busnum)
 {
 	struct pci_bus *bus;
-	struct pci_sysdata *sd;
+#ifdef CONFIG_ACPI_NUMA
 	int pxm;
-
-	/* Allocate per-root-bus (not per bus) arch-specific data.
-	 * TODO: leak; this memory is never freed.
-	 * It's arguable whether it's worth the trouble to care.
-	 */
-	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
-	if (!sd) {
-		printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n", busnum);
-		return NULL;
-	}
+	int node;
+#endif
 
 	if (domain != 0) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
-		kfree(sd);
 		return NULL;
 	}
 
-	sd->node = -1;
-
-	pxm = acpi_get_pxm(device->handle);
 #ifdef CONFIG_ACPI_NUMA
-	if (pxm >= 0)
-		sd->node = pxm_to_node(pxm);
+	pxm = acpi_get_pxm(device->handle);
+	if (pxm >= 0) {
+		node = pxm_to_node(pxm);
+		printk(KERN_INFO "bus %02x -> pxm %d -> node %02x\n",
+			busnum, pxm, node);
+		set_mp_bus_to_node(busnum, node);
+	}
 #endif
 
-	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
-	if (!bus)
-		kfree(sd);
+	bus = pcibios_scan_root(busnum);
 
-#ifdef CONFIG_ACPI_NUMA
-	if (bus != NULL) {
-		if (pxm >= 0) {
-			printk("bus %d -> pxm %d -> node %d\n",
-				busnum, pxm, sd->node);
-		}
-	}
-#endif
-	
 	return bus;
 }
 
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index 4bc62b3..0e1163c 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -314,9 +314,14 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
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
@@ -456,7 +461,7 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
@@ -471,11 +476,15 @@ struct pci_bus *pci_scan_bus_with_sysdata(int busno)
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
 
+struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+{
+	return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
+}
diff --git a/arch/i386/pci/irq.c b/arch/i386/pci/irq.c
index 8cfaaa4..4cedd46 100644
--- a/arch/i386/pci/irq.c
+++ b/arch/i386/pci/irq.c
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
 			printk(KERN_INFO "PCI: Discovered primary peer bus %02x [IRQ]\n", i);
 	}
 	pcibios_last_bus = -1;
diff --git a/arch/i386/pci/legacy.c b/arch/i386/pci/legacy.c
index 5565d70..fa9227d 100644
--- a/arch/i386/pci/legacy.c
+++ b/arch/i386/pci/legacy.c
@@ -12,6 +12,9 @@
 static void __devinit pcibios_fixup_peer_bridges(void)
 {
 	int n, devfn;
+	struct pci_bus *bus = NULL;
+	struct pci_sysdata *sd;
+	long node;
 
 	if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
 		return;
@@ -21,12 +24,13 @@ static void __devinit pcibios_fixup_peer_bridges(void)
 		u32 l;
 		if (pci_find_bus(0, n))
 			continue;
+		node = get_mp_bus_to_node(n);
 		for (devfn = 0; devfn < 256; devfn += 8) {
 			if (!raw_pci_ops->read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus_with_sysdata(n);
+				pci_scan_bus_on_node(n, &pci_root_ops, node);
 				break;
 			}
 		}
diff --git a/arch/i386/pci/mp_bus_to_node.c b/arch/i386/pci/mp_bus_to_node.c
new file mode 100644
index 0000000..bf4e2e9
--- /dev/null
+++ b/arch/i386/pci/mp_bus_to_node.c
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
+	if (busnum < 0 || busnum > (BUS_NR - 1) )
+		return 0;
+	node = mp_bus_to_node[busnum];
+	return node;
+}
-
diff --git a/arch/x86_64/pci/k8-bus.c b/arch/x86_64/pci/k8-bus.c
index 9cc813e..6b71df7 100644
--- a/arch/x86_64/pci/k8-bus.c
+++ b/arch/x86_64/pci/k8-bus.c
@@ -1,7 +1,9 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <asm/mpspec.h>
 #include <linux/cpumask.h>
+#include <linux/topology.h>
 
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
@@ -20,64 +22,93 @@
 #define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
 #define PCI_DEVICE_ID_K8HTCONFIG 0x1100
 
+#define BUS_NR 256
+
+static unsigned char mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+		mp_bus_to_node[busnum] = (unsigned char) node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1) )
+		return 0;
+
+	node = mp_bus_to_node[busnum];
+
+	/* Algorithm a bit dumb, but it shouldn't matter here.
+	   even there is no ram installed for node0*/
+	if (!node_online(node))
+		node = 0;
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
+	memset(mp_bus_to_node, 0, BUS_NR);
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
+		if (node)
+			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
+	}
 	return 0;
 }
 
-fs_initcall(fill_mp_bus_to_cpumask);
+postcore_initcall(early_fill_mp_bus_to_node);
diff --git a/include/asm-i386/pci.h b/include/asm-i386/pci.h
index 4fcacc7..9946df8 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -9,6 +9,7 @@ struct pci_sysdata {
 };
 
 /* scan a bus after allocating a pci_sysdata for it */
+extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node);
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
 #include <linux/mm.h>		/* for struct page */
diff --git a/include/asm-i386/topology.h b/include/asm-i386/topology.h
index 19b2daf..df5cf24 100644
--- a/include/asm-i386/topology.h
+++ b/include/asm-i386/topology.h
@@ -101,7 +101,17 @@ extern unsigned long node_remap_size[];
 
 #define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
 
+int get_mp_bus_to_node(int busnum);
+void set_mp_bus_to_node(int busnum, int node);
+
 #else /* !CONFIG_NUMA */
+static inline int get_mp_bus_to_node(int busnum)
+{
+	return 0;
+}
+static inline void set_mp_bus_to_node(int busnum, int node)
+{
+}
 /*
  * Other i386 platforms should define their own version of the 
  * above macros here.
diff --git a/include/asm-x86_64/pci.h b/include/asm-x86_64/pci.h
index 5da8cb0..2e6f1ed 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -10,6 +10,7 @@ struct pci_sysdata {
 	void*		iommu;		/* IOMMU private data */
 };
 
+extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node);
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
 #ifdef CONFIG_CALGARY_IOMMU
diff --git a/include/asm-x86_64/topology.h b/include/asm-x86_64/topology.h
index 36e52fb..f9438fd 100644
--- a/include/asm-x86_64/topology.h
+++ b/include/asm-x86_64/topology.h
@@ -53,6 +53,19 @@ extern int __node_distance(int, int);
 	.nr_balance_failed	= 0,			\
 }
 
+int get_mp_bus_to_node(int busnum);
+void set_mp_bus_to_node(int busnum, int node);
+
+#else
+
+static inline int get_mp_bus_to_node(int busnum)
+{
+	return 0;
+}
+static inline void set_mp_bus_to_node(int busnum, int node)
+{
+}
+
 #endif
 
 #ifdef CONFIG_SMP
