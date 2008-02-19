Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbYBSLQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbYBSLQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759868AbYBSLNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:13:42 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55059 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbYBSLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:13:33 -0500
Date: Tue, 19 Feb 2008 03:21:20 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 8/8] x86_64: multi pci root bus with different io resource range
In-reply-to: <200802190311.44404.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802190321.21124.yinghai.lu@sun.com>
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


scan AMD opteron io/mmio routing to make sure every pci root bus get correct
resource range. So later pci scan could assign correct resource to device
with unassigned resource.

this some kind make up for system without _CRS for multi pci root bus.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/k8-bus_64.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/k8-bus_64.c
+++ linux-2.6/arch/x86/pci/k8-bus_64.c
@@ -7,23 +7,31 @@
 
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
- *
- * RED-PEN need to call this again on PCI hotplug
- * RED-PEN empty cpus get reported wrong
+ * also get peer root bus resource for io,mmio
  */
 
-#define NODE_ID(dword) ((dword>>4) & 0x07)
-#define LDT_BUS_NUMBER_REGISTER_0 0xE0
-#define LDT_BUS_NUMBER_REGISTER_1 0xE4
-#define LDT_BUS_NUMBER_REGISTER_2 0xE8
-#define LDT_BUS_NUMBER_REGISTER_3 0xEC
-#define NR_LDT_BUS_NUMBER_REGISTERS 4
-#define SECONDARY_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
-#define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 24) & 0xFF)
-
-#define PCI_DEVICE_ID_K8HTCONFIG 0x1100
-#define PCI_DEVICE_ID_K8_10H_HTCONFIG 0x1200
-#define PCI_DEVICE_ID_K8_11H_HTCONFIG 0x1300
+
+/*
+ * sub bus (transparent) will use entres from 3 to store extra from root,
+ * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
+ */
+#define RES_NUM 16
+struct pci_root_info {
+	char name[12];
+	unsigned int res_num;
+	struct resource res[RES_NUM];
+	int bus_min;
+	int bus_max;
+	int node;
+	int link;
+};
+
+/* 4 at this time, it may become to 32 */
+#define PCI_ROOT_NR 4
+static int pci_root_num;
+static struct pci_root_info pci_root_info[PCI_ROOT_NR];
+
+#ifdef CONFIG_NUMA
 
 #define BUS_NR 256
 
@@ -53,6 +61,135 @@ int get_mp_bus_to_node(int busnum)
 
 	return node;
 }
+#endif
+
+void set_pci_bus_resources_arch_default(struct pci_bus *b)
+{
+	int i;
+	int j;
+	struct pci_root_info *info;
+
+	if (!pci_root_num)
+		return;
+
+	for (i = 0; i < pci_root_num; i++) {
+		if (pci_root_info[i].bus_min == b->number)
+			break;
+	}
+
+	if (i == pci_root_num)
+		return;
+
+	info = &pci_root_info[i];
+	for (j = 0; j < info->res_num; j++) {
+		struct resource *res;
+		struct resource *root;
+
+		res = &info->res[j];
+		b->resource[j] = res;
+		if (res->flags & IORESOURCE_IO)
+			root = &ioport_resource;
+		else
+			root = &iomem_resource;
+		insert_resource(root, res);
+	}
+}
+
+#define RANGE_NUM 16
+
+struct res_range {
+	size_t start;
+	size_t end;
+};
+
+static void __init update_range(struct res_range *range, size_t start,
+				size_t end)
+{
+	int i;
+	int j;
+
+	for (j = 0; j < RANGE_NUM; j++) {
+		if (!range[j].end)
+			continue;
+		if (start == range[j].start && end < range[j].end) {
+			range[j].start = end + 1;
+			break;
+		} else if (start == range[j].start && end == range[j].end) {
+			range[j].start = 0;
+			range[j].end = 0;
+			break;
+		} else if (start > range[j].start && end == range[j].end) {
+			range[j].end = start - 1;
+			break;
+		} else if (start > range[j].start && end < range[j].end) {
+			/* find the new spare */
+			for (i = 0; i < RANGE_NUM; i++) {
+				if (range[i].end == 0)
+					break;
+			}
+			if (i < RANGE_NUM) {
+				range[i].end = range[j].end;
+				range[i].start = end + 1;
+			} else {
+				printk(KERN_ERR "run of slot in ranges\n");
+			}
+			range[j].end = start - 1;
+			break;
+		}
+	}
+}
+
+static void __init update_res(struct pci_root_info *info, size_t start,
+			      size_t end, unsigned long flags, int merge)
+{
+	int i;
+	struct resource *res;
+
+	if (!merge)
+		goto addit;
+
+	/* try to merge it with old one */
+	for (i = 0; i < info->res_num; i++) {
+		res = &info->res[i];
+		if (res->flags != flags)
+			continue;
+		if (res->end + 1 == start) {
+			res->end = end;
+			return;
+		} else if (end + 1 == res->start) {
+			res->start = start;
+			return;
+		}
+	}
+
+addit:
+
+	/* need to add that */
+	if (info->res_num >= RES_NUM)
+		return;
+
+	res = &info->res[info->res_num];
+	res->name = info->name;
+	res->flags = flags;
+	res->start = start;
+	res->end = end;
+	res->child = NULL;
+	info->res_num++;
+}
+
+struct pci_hostbridge_probe {
+	u32 bus;
+	u32 slot;
+	u32 vendor;
+	u32 device;
+};
+
+static struct pci_hostbridge_probe pci_probes[] __initdata = {
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
+	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
+};
 
 /**
  * early_fill_mp_bus_to_node()
@@ -60,25 +197,25 @@ int get_mp_bus_to_node(int busnum)
  * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
  * Registers found in the K8 northbridge
  */
-__init static int
-early_fill_mp_bus_to_node(void)
+static int __init early_fill_mp_bus_info(void)
 {
-	int i, j;
+	int i;
+	int j;
+	unsigned bus;
 	unsigned slot;
-	u32 ldtbus;
-	u32 id;
+	int found;
 	int node;
-	u16 deviceid;
-	u16 vendorid;
-	int min_bus;
-	int max_bus;
-
-	static int lbnr[NR_LDT_BUS_NUMBER_REGISTERS] = {
-		LDT_BUS_NUMBER_REGISTER_0,
-		LDT_BUS_NUMBER_REGISTER_1,
-		LDT_BUS_NUMBER_REGISTER_2,
-		LDT_BUS_NUMBER_REGISTER_3
-	};
+	int link;
+	int def_node;
+	int def_link;
+	struct pci_root_info *info;
+	u32 reg;
+	struct resource *res;
+	size_t start;
+	size_t end;
+	struct res_range range[RANGE_NUM];
+	u64 val;
+	u32 address;
 
 	for (i = 0; i < BUS_NR; i++)
 		mp_bus_to_node[i] = -1;
@@ -86,40 +223,221 @@ early_fill_mp_bus_to_node(void)
 	if (!early_pci_allowed())
 		return -1;
 
-	slot = 0x18;
-	id = read_pci_config(0, slot, 0, PCI_VENDOR_ID);
+	found = 0;
+	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
+		u32 id;
+		u16 device;
+		u16 vendor;
+
+		bus = pci_probes[i].bus;
+		slot = pci_probes[i].slot;
+		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
+
+		vendor = id & 0xffff;
+		device = (id>>16) & 0xffff;
+		if (pci_probes[i].vendor == vendor &&
+		    pci_probes[i].device == device) {
+			found = 1;
+			break;
+		}
+	}
 
-	vendorid = id & 0xffff;
-	if (vendorid != PCI_VENDOR_ID_AMD)
-		goto out;
-
-	deviceid = (id>>16) & 0xffff;
-	if ((deviceid != PCI_DEVICE_ID_K8HTCONFIG) &&
-	    (deviceid != PCI_DEVICE_ID_K8_10H_HTCONFIG) &&
-	    (deviceid != PCI_DEVICE_ID_K8_11H_HTCONFIG))
-		goto out;
+	if (!found)
+		return 0;
 
-	for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
-		ldtbus = read_pci_config(0, slot, 1, lbnr[i]);
+	pci_root_num = 0;
+	for (i = 0; i < 4; i++) {
+		int min_bus;
+		int max_bus;
+		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
 
 		/* Check if that register is enabled for bus range */
-		if ((ldtbus & 7) != 3)
+		if ((reg & 7) != 3)
 			continue;
 
-		min_bus = SECONDARY_LDT_BUS_NUMBER(ldtbus);
-		max_bus = SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
-		node = NODE_ID(ldtbus);
+		min_bus = (reg >> 16) & 0xff;
+		max_bus = (reg >> 24) & 0xff;
+		node = (reg >> 4) & 0x07;
+#ifdef CONFIG_NUMA
 		for (j = min_bus; j <= max_bus; j++)
 			mp_bus_to_node[j] = (unsigned char) node;
+#endif
+		link = (reg >> 8) & 0x03;
+
+		info = &pci_root_info[pci_root_num];
+		info->bus_min = min_bus;
+		info->bus_max = max_bus;
+		info->node = node;
+		info->link = link;
+		sprintf(info->name, "PCI Bus #%02x", min_bus);
+		pci_root_num++;
+	}
+
+	/* get the default node and link for left over res */
+	reg = read_pci_config(bus, slot, 0, 0x60);
+	def_node = (reg >> 8) & 0x07;
+	reg = read_pci_config(bus, slot, 0, 0x64);
+	def_link = (reg >> 8) & 0x03;
+
+	memset(range, 0, sizeof(range));
+	range[0].end = 0xffff;
+	/* io port resource */
+	for (i = 0; i < 4; i++) {
+		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
+		if (!(reg & 3))
+			continue;
+
+		start = reg & 0xfff000;
+		reg = read_pci_config(bus, slot, 1, 0xc4 + (i << 3));
+		node = reg & 0x07;
+		link = (reg >> 4) & 0x03;
+		end = (reg & 0xfff000) | 0xfff;
+
+		/* find the position */
+		for (j = 0; j < pci_root_num; j++) {
+			info = &pci_root_info[j];
+			if (info->node == node && info->link == link)
+				break;
+		}
+		if (j == pci_root_num)
+			continue; /* not found */
+
+		info = &pci_root_info[j];
+		update_res(info, start, end, IORESOURCE_IO, 0);
+		update_range(range, start, end);
+	}
+	/* add left over io port range to def node/link, [0, 0xffff] */
+	/* find the position */
+	for (j = 0; j < pci_root_num; j++) {
+		info = &pci_root_info[j];
+		if (info->node == def_node && info->link == def_link)
+			break;
 	}
+	if (j < pci_root_num) {
+		info = &pci_root_info[j];
+		for (i = 0; i < RANGE_NUM; i++) {
+			if (!range[i].end)
+				continue;
+
+			update_res(info, range[i].start, range[i].end,
+				   IORESOURCE_IO, 1);
+		}
+	}
+
+	memset(range, 0, sizeof(range));
+	/* 0xfd00000000-0xffffffffff for HT */
+	/* 0xfc00000000-0xfcffffffff for Family 10h mmconfig*/
+	range[0].end = 0xfbffffffffULL;
+
+	/* need to take out [0, TOM) for RAM*/
+	address = MSR_K8_TOP_MEM1;
+	rdmsrl(address, val);
+	end = (val & 0xffffff8000000ULL);
+	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
+	if (end < (1ULL<<32))
+		update_range(range, 0, end - 1);
+
+	/* mmio resource */
+	for (i = 0; i < 8; i++) {
+		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
+		if (!(reg & 3))
+			continue;
 
-out:
+		start = reg & 0xffffff00; /* 39:16 on 31:8*/
+		start <<= 8;
+		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
+		node = reg & 0x07;
+		link = (reg >> 4) & 0x03;
+		end = (reg & 0xffffff00);
+		end <<= 8;
+		end |= 0xffff;
+
+		/* find the position */
+		for (j = 0; j < pci_root_num; j++) {
+			info = &pci_root_info[j];
+			if (info->node == node && info->link == link)
+				break;
+		}
+		if (j == pci_root_num)
+			continue; /* not found */
+
+		info = &pci_root_info[j];
+		update_res(info, start, end, IORESOURCE_MEM, 0);
+		update_range(range, start, end);
+	}
+
+	/* need to take out [4G, TOM2) for RAM*/
+	/* SYS_CFG */
+	address = MSR_K8_SYSCFG;
+	rdmsrl(address, val);
+	/* TOP_MEM2 is enabled? */
+	if (val & (1<<21)) {
+		/* TOP_MEM2 */
+		address = MSR_K8_TOP_MEM2;
+		rdmsrl(address, val);
+		end = (val & 0xffffff8000000ULL);
+		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
+		update_range(range, 1ULL<<32, end - 1);
+	}
+
+	/*
+	 * add left over mmio range to def node/link ?
+	 * that is tricky, just record range in from start_min to 4G
+	 */
+	for (j = 0; j < pci_root_num; j++) {
+		info = &pci_root_info[j];
+		if (info->node == def_node && info->link == def_link)
+			break;
+	}
+	if (j < pci_root_num) {
+		info = &pci_root_info[j];
+
+		for (i = 0; i < RANGE_NUM; i++) {
+			if (!range[i].end)
+				continue;
+#if 0
+			/* don't use the one start less than 1M */
+			if (range[i].start < 0x100000)
+				continue;
+#endif
+#if 0
+			/* don't use last one near 4G */
+			if (range[i].end == 0xffffffffULL)
+				continue;
+#endif
+
+			update_res(info, range[i].start, range[i].end,
+				   IORESOURCE_MEM, 1);
+		}
+	}
+
+#ifdef CONFIG_NUMA
 	for (i = 0; i < BUS_NR; i++) {
 		node = mp_bus_to_node[i];
 		if (node >= 0)
 			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
 	}
+#endif
+
+	for (i = 0; i < pci_root_num; i++) {
+		int res_num;
+		int busnum;
+
+		info = &pci_root_info[i];
+		res_num = info->res_num;
+		busnum = info->bus_min;
+		printk(KERN_DEBUG "bus: [%02x,%02x] on node %x link %x\n",
+		       info->bus_min, info->bus_max, info->node, info->link);
+		for (j = 0; j < res_num; j++) {
+			res = &info->res[j];
+			printk(KERN_DEBUG "bus: %02x index %x %s: [%llx, %llx]\n",
+			       busnum, j,
+			       (res->flags & IORESOURCE_IO)?"io port":"mmio",
+			       res->start, res->end);
+		}
+	}
+
 	return 0;
 }
 
-postcore_initcall(early_fill_mp_bus_to_node);
+postcore_initcall(early_fill_mp_bus_info);
Index: linux-2.6/include/asm-x86/topology.h
===================================================================
--- linux-2.6.orig/include/asm-x86/topology.h
+++ linux-2.6/include/asm-x86/topology.h
@@ -25,6 +25,7 @@
 #ifndef _ASM_X86_TOPOLOGY_H
 #define _ASM_X86_TOPOLOGY_H
 
+struct pci_bus;
 #ifdef CONFIG_NUMA
 #include <linux/cpumask.h>
 #include <asm/mpspec.h>
@@ -191,6 +192,8 @@ extern cpumask_t cpu_coregroup_map(int c
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
 
+void set_pci_bus_resources_arch_default(struct pci_bus *b);
+
 #ifdef CONFIG_SMP
 #define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
 #define smt_capable()			(smp_num_siblings > 1)
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1076,6 +1076,10 @@ unsigned int pci_scan_child_bus(struct p
 	return max;
 }
 
+void __attribute__((weak)) set_pci_bus_resources_arch_default(struct pci_bus *b)
+{
+}
+
 struct pci_bus * pci_create_bus(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
@@ -1135,6 +1139,8 @@ struct pci_bus * pci_create_bus(struct d
 	b->resource[0] = &ioport_resource;
 	b->resource[1] = &iomem_resource;
 
+	set_pci_bus_resources_arch_default(b);
+
 	return b;
 
 dev_create_file_err:
Index: linux-2.6/arch/x86/pci/Makefile_64
===================================================================
--- linux-2.6.orig/arch/x86/pci/Makefile_64
+++ linux-2.6/arch/x86/pci/Makefile_64
@@ -13,5 +13,5 @@ obj-y			+= legacy.o irq.o common.o early
 # mmconfig has a 64bit special
 obj-$(CONFIG_PCI_MMCONFIG) += mmconfig_64.o direct.o mmconfig-shared.o
 
-obj-$(CONFIG_NUMA)	+= k8-bus_64.o
+obj-y		+= k8-bus_64.o
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -247,7 +247,7 @@ static inline void pci_add_saved_cap(str
 #define PCI_NUM_RESOURCES	11
 
 #ifndef PCI_BUS_NUM_RESOURCES
-#define PCI_BUS_NUM_RESOURCES	8
+#define PCI_BUS_NUM_RESOURCES	16
 #endif
 
 #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits of resource flags tell us the PCI region flags */

