Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbYFSPyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbYFSPyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbYFSPya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:54:30 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:20130 "EHLO
	mail183-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761028AbYFSPy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:54:28 -0400
X-BigFish: VPS-1(zz1fa4Lzz10d3izzz32i87i66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2PW5Y-01-ZFE-01
From: Robert Richter <robert.richter@amd.com>
To: stephane eranian <eranian@googlemail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sourceforge.net,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] x86: add PCI extended config space access for AMD Barcelona
Date: Thu, 19 Jun 2008 17:50:40 +0200
Message-Id: <1213890640-4444-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
References: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
X-OriginalArrivalTime: 19 Jun 2008 15:54:01.0653 (UTC) FILETIME=[B15F5650:01C8D224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements PCI extended configuration space access for
AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
addresses. An x86 capability bit has been introduced that is set for
CPUs supporting PCI extended config space accesses.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/cpu.h |    3 +
 arch/x86/pci/Makefile_32  |    1 +
 arch/x86/pci/Makefile_64  |    2 +-
 arch/x86/pci/amd_bus.c    |  560 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/direct.c     |   25 ++-
 arch/x86/pci/k8-bus_64.c  |  528 ------------------------------------------
 arch/x86/pci/pci.h        |    1 +
 7 files changed, 584 insertions(+), 536 deletions(-)
 create mode 100644 arch/x86/pci/amd_bus.c
 delete mode 100644 arch/x86/pci/k8-bus_64.c

diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 783691b..40ad189 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -1,3 +1,4 @@
+#ifdef CONFIG_X86_32
 
 struct cpu_model_info {
 	int vendor;
@@ -36,3 +37,5 @@ extern struct cpu_vendor_dev __x86cpuvendor_start[], __x86cpuvendor_end[];
 
 extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
+
+#endif /* CONFIG_X86_32 */
diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
index 89ec35d..f647e7e 100644
--- a/arch/x86/pci/Makefile_32
+++ b/arch/x86/pci/Makefile_32
@@ -22,3 +22,4 @@ pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
 pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
+obj-y				+= amd_bus.o
diff --git a/arch/x86/pci/Makefile_64 b/arch/x86/pci/Makefile_64
index 8fbd198..fd47068 100644
--- a/arch/x86/pci/Makefile_64
+++ b/arch/x86/pci/Makefile_64
@@ -13,5 +13,5 @@ obj-y			+= legacy.o irq.o common.o early.o
 # mmconfig has a 64bit special
 obj-$(CONFIG_PCI_MMCONFIG) += mmconfig_64.o direct.o mmconfig-shared.o
 
-obj-y		+= k8-bus_64.o
+obj-y		+= amd_bus.o
 
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
new file mode 100644
index 0000000..15f505d
--- /dev/null
+++ b/arch/x86/pci/amd_bus.c
@@ -0,0 +1,560 @@
+#include <linux/init.h>
+#include <linux/pci.h>
+#include "pci.h"
+
+#ifdef CONFIG_X86_64
+
+#include <asm/pci-direct.h>
+#include <asm/mpspec.h>
+#include <linux/cpumask.h>
+#include <linux/topology.h>
+
+/*
+ * This discovers the pcibus <-> node mapping on AMD K8.
+ * also get peer root bus resource for io,mmio
+ */
+
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
+
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
+#endif
+
+void set_pci_bus_resources_arch_default(struct pci_bus *b)
+{
+	int i;
+	int j;
+	struct pci_root_info *info;
+
+	/* if only one root bus, don't need to anything */
+	if (pci_root_num < 2)
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
+
+		if (start <= range[j].start && end >= range[j].end) {
+			range[j].start = 0;
+			range[j].end = 0;
+			continue;
+		}
+
+		if (start <= range[j].start && end < range[j].end && range[j].start < end + 1) {
+			range[j].start = end + 1;
+			continue;
+		}
+
+
+		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {
+			range[j].end = start - 1;
+			continue;
+		}
+
+		if (start > range[j].start && end < range[j].end) {
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
+			continue;
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
+		size_t final_start, final_end;
+		size_t common_start, common_end;
+
+		res = &info->res[i];
+		if (res->flags != flags)
+			continue;
+
+		common_start = max((size_t)res->start, start);
+		common_end = min((size_t)res->end, end);
+		if (common_start > common_end + 1)
+			continue;
+
+		final_start = min((size_t)res->start, start);
+		final_end = max((size_t)res->end, end);
+
+		res->start = final_start;
+		res->end = final_end;
+		return;
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
+
+static u64 __initdata fam10h_mmconf_start;
+static u64 __initdata fam10h_mmconf_end;
+static void __init get_pci_mmcfg_amd_fam10h_range(void)
+{
+	u32 address;
+	u64 base, msr;
+	unsigned segn_busn_bits;
+
+	/* assume all cpus from fam10h have mmconf */
+        if (boot_cpu_data.x86 < 0x10)
+		return;
+
+	address = MSR_FAM10H_MMIO_CONF_BASE;
+	rdmsrl(address, msr);
+
+	/* mmconfig is not enable */
+	if (!(msr & FAM10H_MMIO_CONF_ENABLE))
+		return;
+
+	base = msr & (FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT);
+
+	segn_busn_bits = (msr >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
+			 FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+	fam10h_mmconf_start = base;
+	fam10h_mmconf_end = base + (1ULL<<(segn_busn_bits + 20)) - 1;
+}
+
+/**
+ * early_fill_mp_bus_to_node()
+ * called before pcibios_scan_root and pci_scan_bus
+ * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
+ * Registers found in the K8 northbridge
+ */
+static int __init early_fill_mp_bus_info(void)
+{
+	int i;
+	int j;
+	unsigned bus;
+	unsigned slot;
+	int found;
+	int node;
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
+
+#ifdef CONFIG_NUMA
+	for (i = 0; i < BUS_NR; i++)
+		mp_bus_to_node[i] = -1;
+#endif
+
+	if (!early_pci_allowed())
+		return -1;
+
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
+
+	if (!found)
+		return 0;
+
+	pci_root_num = 0;
+	for (i = 0; i < 4; i++) {
+		int min_bus;
+		int max_bus;
+		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
+
+		/* Check if that register is enabled for bus range */
+		if ((reg & 7) != 3)
+			continue;
+
+		min_bus = (reg >> 16) & 0xff;
+		max_bus = (reg >> 24) & 0xff;
+		node = (reg >> 4) & 0x07;
+#ifdef CONFIG_NUMA
+		for (j = min_bus; j <= max_bus; j++)
+			mp_bus_to_node[j] = (unsigned char) node;
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
+		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
+		       node, link, (u64)start, (u64)end);
+
+		/* kernel only handle 16 bit only */
+		if (end > 0xffff)
+			end = 0xffff;
+		update_res(info, start, end, IORESOURCE_IO, 1);
+		update_range(range, start, end);
+	}
+	/* add left over io port range to def node/link, [0, 0xffff] */
+	/* find the position */
+	for (j = 0; j < pci_root_num; j++) {
+		info = &pci_root_info[j];
+		if (info->node == def_node && info->link == def_link)
+			break;
+	}
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
+	range[0].end = (0xfdULL<<32) - 1;
+
+	/* need to take out [0, TOM) for RAM*/
+	address = MSR_K8_TOP_MEM1;
+	rdmsrl(address, val);
+	end = (val & 0xffffff8000000ULL);
+	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
+	if (end < (1ULL<<32))
+		update_range(range, 0, end - 1);
+
+	/* get mmconfig */
+	get_pci_mmcfg_amd_fam10h_range();
+	/* need to take out mmconf range */
+	if (fam10h_mmconf_end) {
+		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n", fam10h_mmconf_start, fam10h_mmconf_end);
+		update_range(range, fam10h_mmconf_start, fam10h_mmconf_end);
+	}
+
+	/* mmio resource */
+	for (i = 0; i < 8; i++) {
+		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
+		if (!(reg & 3))
+			continue;
+
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
+
+		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
+		       node, link, (u64)start, (u64)end);
+		/*
+		 * some sick allocation would have range overlap with fam10h
+		 * mmconf range, so need to update start and end.
+		 */
+		if (fam10h_mmconf_end) {
+			int changed = 0;
+			u64 endx = 0;
+			if (start >= fam10h_mmconf_start &&
+			    start <= fam10h_mmconf_end) {
+				start = fam10h_mmconf_end + 1;
+				changed = 1;
+			}
+
+			if (end >= fam10h_mmconf_start &&
+			    end <= fam10h_mmconf_end) {
+				end = fam10h_mmconf_start - 1;
+				changed = 1;
+			}
+
+			if (start < fam10h_mmconf_start &&
+			    end > fam10h_mmconf_end) {
+				/* we got a hole */
+				endx = fam10h_mmconf_start - 1;
+				update_res(info, start, endx, IORESOURCE_MEM, 0);
+				update_range(range, start, endx);
+				printk(KERN_CONT " ==> [%llx, %llx]", (u64)start, endx);
+				start = fam10h_mmconf_end + 1;
+				changed = 1;
+			}
+			if (changed) {
+				if (start <= end) {
+					printk(KERN_CONT " %s [%llx, %llx]", endx?"and":"==>", (u64)start, (u64)end);
+				} else {
+					printk(KERN_CONT "%s\n", endx?"":" ==> none");
+					continue;
+				}
+			}
+		}
+
+		update_res(info, start, end, IORESOURCE_MEM, 1);
+		update_range(range, start, end);
+		printk(KERN_CONT "\n");
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
+
+			update_res(info, range[i].start, range[i].end,
+				   IORESOURCE_MEM, 1);
+		}
+	}
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
+	return 0;
+}
+
+postcore_initcall(early_fill_mp_bus_info);
+
+#endif
+
+/* common 32/64 bit code */
+
+#define ENABLE_CF8_EXT_CFG      (1ULL << 46)
+
+static void enable_pci_io_ecs_per_cpu(void *unused)
+{
+	u64 reg;
+	rdmsrl(MSR_AMD64_NB_CFG, reg);
+	if (!(reg & ENABLE_CF8_EXT_CFG)) {
+		reg |= ENABLE_CF8_EXT_CFG;
+		wrmsrl(MSR_AMD64_NB_CFG, reg);
+	}
+}
+
+static int __init enable_pci_io_ecs(void)
+{
+	/* assume all cpus from fam10h have IO ECS */
+        if (boot_cpu_data.x86 < 0x10)
+		return 0;
+	on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1, 1);
+	pci_probe |= PCI_HAS_IO_ECS;
+	return 0;
+}
+
+postcore_initcall(enable_pci_io_ecs);
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 21d1e0e..9915293 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -8,18 +8,21 @@
 #include "pci.h"
 
 /*
- * Functions for accessing PCI configuration space with type 1 accesses
+ * Functions for accessing PCI base (first 256 bytes) and extended
+ * (4096 bytes per PCI function) configuration space with type 1
+ * accesses.
  */
 
 #define PCI_CONF1_ADDRESS(bus, devfn, reg) \
-	(0x80000000 | (bus << 16) | (devfn << 8) | (reg & ~3))
+	(0x80000000 | ((reg & 0xF00) << 16) | (bus << 16) \
+	| (devfn << 8) | (reg & 0xFC))
 
 static int pci_conf1_read(unsigned int seg, unsigned int bus,
 			  unsigned int devfn, int reg, int len, u32 *value)
 {
 	unsigned long flags;
 
-	if ((bus > 255) || (devfn > 255) || (reg > 255)) {
+	if ((bus > 255) || (devfn > 255) || (reg > 4095)) {
 		*value = -1;
 		return -EINVAL;
 	}
@@ -50,7 +53,7 @@ static int pci_conf1_write(unsigned int seg, unsigned int bus,
 {
 	unsigned long flags;
 
-	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
+	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
@@ -260,10 +263,18 @@ void __init pci_direct_init(int type)
 		return;
 	printk(KERN_INFO "PCI: Using configuration type %d for base access\n",
 		 type);
-	if (type == 1)
+	if (type == 1) {
 		raw_pci_ops = &pci_direct_conf1;
-	else
-		raw_pci_ops = &pci_direct_conf2;
+		if (raw_pci_ext_ops)
+			return;
+		if (!(pci_probe & PCI_HAS_IO_ECS))
+			return;
+		printk(KERN_INFO "PCI: Using configuration type 1 "
+		       "for extended access\n");
+		raw_pci_ext_ops = &pci_direct_conf1;
+		return;
+	}
+	raw_pci_ops = &pci_direct_conf2;
 }
 
 int __init pci_direct_probe(void)
diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
deleted file mode 100644
index 5c2799c..0000000
--- a/arch/x86/pci/k8-bus_64.c
+++ /dev/null
@@ -1,528 +0,0 @@
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <asm/pci-direct.h>
-#include <asm/mpspec.h>
-#include <linux/cpumask.h>
-#include <linux/topology.h>
-
-/*
- * This discovers the pcibus <-> node mapping on AMD K8.
- * also get peer root bus resource for io,mmio
- */
-
-
-/*
- * sub bus (transparent) will use entres from 3 to store extra from root,
- * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
- */
-#define RES_NUM 16
-struct pci_root_info {
-	char name[12];
-	unsigned int res_num;
-	struct resource res[RES_NUM];
-	int bus_min;
-	int bus_max;
-	int node;
-	int link;
-};
-
-/* 4 at this time, it may become to 32 */
-#define PCI_ROOT_NR 4
-static int pci_root_num;
-static struct pci_root_info pci_root_info[PCI_ROOT_NR];
-
-#ifdef CONFIG_NUMA
-
-#define BUS_NR 256
-
-static int mp_bus_to_node[BUS_NR];
-
-void set_mp_bus_to_node(int busnum, int node)
-{
-	if (busnum >= 0 &&  busnum < BUS_NR)
-		mp_bus_to_node[busnum] = node;
-}
-
-int get_mp_bus_to_node(int busnum)
-{
-	int node = -1;
-
-	if (busnum < 0 || busnum > (BUS_NR - 1))
-		return node;
-
-	node = mp_bus_to_node[busnum];
-
-	/*
-	 * let numa_node_id to decide it later in dma_alloc_pages
-	 * if there is no ram on that node
-	 */
-	if (node != -1 && !node_online(node))
-		node = -1;
-
-	return node;
-}
-#endif
-
-void set_pci_bus_resources_arch_default(struct pci_bus *b)
-{
-	int i;
-	int j;
-	struct pci_root_info *info;
-
-	/* if only one root bus, don't need to anything */
-	if (pci_root_num < 2)
-		return;
-
-	for (i = 0; i < pci_root_num; i++) {
-		if (pci_root_info[i].bus_min == b->number)
-			break;
-	}
-
-	if (i == pci_root_num)
-		return;
-
-	info = &pci_root_info[i];
-	for (j = 0; j < info->res_num; j++) {
-		struct resource *res;
-		struct resource *root;
-
-		res = &info->res[j];
-		b->resource[j] = res;
-		if (res->flags & IORESOURCE_IO)
-			root = &ioport_resource;
-		else
-			root = &iomem_resource;
-		insert_resource(root, res);
-	}
-}
-
-#define RANGE_NUM 16
-
-struct res_range {
-	size_t start;
-	size_t end;
-};
-
-static void __init update_range(struct res_range *range, size_t start,
-				size_t end)
-{
-	int i;
-	int j;
-
-	for (j = 0; j < RANGE_NUM; j++) {
-		if (!range[j].end)
-			continue;
-
-		if (start <= range[j].start && end >= range[j].end) {
-			range[j].start = 0;
-			range[j].end = 0;
-			continue;
-		}
-
-		if (start <= range[j].start && end < range[j].end && range[j].start < end + 1) {
-			range[j].start = end + 1;
-			continue;
-		}
-
-
-		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {
-			range[j].end = start - 1;
-			continue;
-		}
-
-		if (start > range[j].start && end < range[j].end) {
-			/* find the new spare */
-			for (i = 0; i < RANGE_NUM; i++) {
-				if (range[i].end == 0)
-					break;
-			}
-			if (i < RANGE_NUM) {
-				range[i].end = range[j].end;
-				range[i].start = end + 1;
-			} else {
-				printk(KERN_ERR "run of slot in ranges\n");
-			}
-			range[j].end = start - 1;
-			continue;
-		}
-	}
-}
-
-static void __init update_res(struct pci_root_info *info, size_t start,
-			      size_t end, unsigned long flags, int merge)
-{
-	int i;
-	struct resource *res;
-
-	if (!merge)
-		goto addit;
-
-	/* try to merge it with old one */
-	for (i = 0; i < info->res_num; i++) {
-		size_t final_start, final_end;
-		size_t common_start, common_end;
-
-		res = &info->res[i];
-		if (res->flags != flags)
-			continue;
-
-		common_start = max((size_t)res->start, start);
-		common_end = min((size_t)res->end, end);
-		if (common_start > common_end + 1)
-			continue;
-
-		final_start = min((size_t)res->start, start);
-		final_end = max((size_t)res->end, end);
-
-		res->start = final_start;
-		res->end = final_end;
-		return;
-	}
-
-addit:
-
-	/* need to add that */
-	if (info->res_num >= RES_NUM)
-		return;
-
-	res = &info->res[info->res_num];
-	res->name = info->name;
-	res->flags = flags;
-	res->start = start;
-	res->end = end;
-	res->child = NULL;
-	info->res_num++;
-}
-
-struct pci_hostbridge_probe {
-	u32 bus;
-	u32 slot;
-	u32 vendor;
-	u32 device;
-};
-
-static struct pci_hostbridge_probe pci_probes[] __initdata = {
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
-};
-
-static u64 __initdata fam10h_mmconf_start;
-static u64 __initdata fam10h_mmconf_end;
-static void __init get_pci_mmcfg_amd_fam10h_range(void)
-{
-	u32 address;
-	u64 base, msr;
-	unsigned segn_busn_bits;
-
-	/* assume all cpus from fam10h have mmconf */
-        if (boot_cpu_data.x86 < 0x10)
-		return;
-
-	address = MSR_FAM10H_MMIO_CONF_BASE;
-	rdmsrl(address, msr);
-
-	/* mmconfig is not enable */
-	if (!(msr & FAM10H_MMIO_CONF_ENABLE))
-		return;
-
-	base = msr & (FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT);
-
-	segn_busn_bits = (msr >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
-			 FAM10H_MMIO_CONF_BUSRANGE_MASK;
-
-	fam10h_mmconf_start = base;
-	fam10h_mmconf_end = base + (1ULL<<(segn_busn_bits + 20)) - 1;
-}
-
-/**
- * early_fill_mp_bus_to_node()
- * called before pcibios_scan_root and pci_scan_bus
- * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
- * Registers found in the K8 northbridge
- */
-static int __init early_fill_mp_bus_info(void)
-{
-	int i;
-	int j;
-	unsigned bus;
-	unsigned slot;
-	int found;
-	int node;
-	int link;
-	int def_node;
-	int def_link;
-	struct pci_root_info *info;
-	u32 reg;
-	struct resource *res;
-	size_t start;
-	size_t end;
-	struct res_range range[RANGE_NUM];
-	u64 val;
-	u32 address;
-
-#ifdef CONFIG_NUMA
-	for (i = 0; i < BUS_NR; i++)
-		mp_bus_to_node[i] = -1;
-#endif
-
-	if (!early_pci_allowed())
-		return -1;
-
-	found = 0;
-	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
-		u32 id;
-		u16 device;
-		u16 vendor;
-
-		bus = pci_probes[i].bus;
-		slot = pci_probes[i].slot;
-		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
-
-		vendor = id & 0xffff;
-		device = (id>>16) & 0xffff;
-		if (pci_probes[i].vendor == vendor &&
-		    pci_probes[i].device == device) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found)
-		return 0;
-
-	pci_root_num = 0;
-	for (i = 0; i < 4; i++) {
-		int min_bus;
-		int max_bus;
-		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
-
-		/* Check if that register is enabled for bus range */
-		if ((reg & 7) != 3)
-			continue;
-
-		min_bus = (reg >> 16) & 0xff;
-		max_bus = (reg >> 24) & 0xff;
-		node = (reg >> 4) & 0x07;
-#ifdef CONFIG_NUMA
-		for (j = min_bus; j <= max_bus; j++)
-			mp_bus_to_node[j] = (unsigned char) node;
-#endif
-		link = (reg >> 8) & 0x03;
-
-		info = &pci_root_info[pci_root_num];
-		info->bus_min = min_bus;
-		info->bus_max = max_bus;
-		info->node = node;
-		info->link = link;
-		sprintf(info->name, "PCI Bus #%02x", min_bus);
-		pci_root_num++;
-	}
-
-	/* get the default node and link for left over res */
-	reg = read_pci_config(bus, slot, 0, 0x60);
-	def_node = (reg >> 8) & 0x07;
-	reg = read_pci_config(bus, slot, 0, 0x64);
-	def_link = (reg >> 8) & 0x03;
-
-	memset(range, 0, sizeof(range));
-	range[0].end = 0xffff;
-	/* io port resource */
-	for (i = 0; i < 4; i++) {
-		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
-		if (!(reg & 3))
-			continue;
-
-		start = reg & 0xfff000;
-		reg = read_pci_config(bus, slot, 1, 0xc4 + (i << 3));
-		node = reg & 0x07;
-		link = (reg >> 4) & 0x03;
-		end = (reg & 0xfff000) | 0xfff;
-
-		/* find the position */
-		for (j = 0; j < pci_root_num; j++) {
-			info = &pci_root_info[j];
-			if (info->node == node && info->link == link)
-				break;
-		}
-		if (j == pci_root_num)
-			continue; /* not found */
-
-		info = &pci_root_info[j];
-		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
-		       node, link, (u64)start, (u64)end);
-
-		/* kernel only handle 16 bit only */
-		if (end > 0xffff)
-			end = 0xffff;
-		update_res(info, start, end, IORESOURCE_IO, 1);
-		update_range(range, start, end);
-	}
-	/* add left over io port range to def node/link, [0, 0xffff] */
-	/* find the position */
-	for (j = 0; j < pci_root_num; j++) {
-		info = &pci_root_info[j];
-		if (info->node == def_node && info->link == def_link)
-			break;
-	}
-	if (j < pci_root_num) {
-		info = &pci_root_info[j];
-		for (i = 0; i < RANGE_NUM; i++) {
-			if (!range[i].end)
-				continue;
-
-			update_res(info, range[i].start, range[i].end,
-				   IORESOURCE_IO, 1);
-		}
-	}
-
-	memset(range, 0, sizeof(range));
-	/* 0xfd00000000-0xffffffffff for HT */
-	range[0].end = (0xfdULL<<32) - 1;
-
-	/* need to take out [0, TOM) for RAM*/
-	address = MSR_K8_TOP_MEM1;
-	rdmsrl(address, val);
-	end = (val & 0xffffff8000000ULL);
-	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
-	if (end < (1ULL<<32))
-		update_range(range, 0, end - 1);
-
-	/* get mmconfig */
-	get_pci_mmcfg_amd_fam10h_range();
-	/* need to take out mmconf range */
-	if (fam10h_mmconf_end) {
-		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n", fam10h_mmconf_start, fam10h_mmconf_end);
-		update_range(range, fam10h_mmconf_start, fam10h_mmconf_end);
-	}
-
-	/* mmio resource */
-	for (i = 0; i < 8; i++) {
-		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
-		if (!(reg & 3))
-			continue;
-
-		start = reg & 0xffffff00; /* 39:16 on 31:8*/
-		start <<= 8;
-		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
-		node = reg & 0x07;
-		link = (reg >> 4) & 0x03;
-		end = (reg & 0xffffff00);
-		end <<= 8;
-		end |= 0xffff;
-
-		/* find the position */
-		for (j = 0; j < pci_root_num; j++) {
-			info = &pci_root_info[j];
-			if (info->node == node && info->link == link)
-				break;
-		}
-		if (j == pci_root_num)
-			continue; /* not found */
-
-		info = &pci_root_info[j];
-
-		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
-		       node, link, (u64)start, (u64)end);
-		/*
-		 * some sick allocation would have range overlap with fam10h
-		 * mmconf range, so need to update start and end.
-		 */
-		if (fam10h_mmconf_end) {
-			int changed = 0;
-			u64 endx = 0;
-			if (start >= fam10h_mmconf_start &&
-			    start <= fam10h_mmconf_end) {
-				start = fam10h_mmconf_end + 1;
-				changed = 1;
-			}
-
-			if (end >= fam10h_mmconf_start &&
-			    end <= fam10h_mmconf_end) {
-				end = fam10h_mmconf_start - 1;
-				changed = 1;
-			}
-
-			if (start < fam10h_mmconf_start &&
-			    end > fam10h_mmconf_end) {
-				/* we got a hole */
-				endx = fam10h_mmconf_start - 1;
-				update_res(info, start, endx, IORESOURCE_MEM, 0);
-				update_range(range, start, endx);
-				printk(KERN_CONT " ==> [%llx, %llx]", (u64)start, endx);
-				start = fam10h_mmconf_end + 1;
-				changed = 1;
-			}
-			if (changed) {
-				if (start <= end) {
-					printk(KERN_CONT " %s [%llx, %llx]", endx?"and":"==>", (u64)start, (u64)end);
-				} else {
-					printk(KERN_CONT "%s\n", endx?"":" ==> none");
-					continue;
-				}
-			}
-		}
-
-		update_res(info, start, end, IORESOURCE_MEM, 1);
-		update_range(range, start, end);
-		printk(KERN_CONT "\n");
-	}
-
-	/* need to take out [4G, TOM2) for RAM*/
-	/* SYS_CFG */
-	address = MSR_K8_SYSCFG;
-	rdmsrl(address, val);
-	/* TOP_MEM2 is enabled? */
-	if (val & (1<<21)) {
-		/* TOP_MEM2 */
-		address = MSR_K8_TOP_MEM2;
-		rdmsrl(address, val);
-		end = (val & 0xffffff8000000ULL);
-		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
-		update_range(range, 1ULL<<32, end - 1);
-	}
-
-	/*
-	 * add left over mmio range to def node/link ?
-	 * that is tricky, just record range in from start_min to 4G
-	 */
-	for (j = 0; j < pci_root_num; j++) {
-		info = &pci_root_info[j];
-		if (info->node == def_node && info->link == def_link)
-			break;
-	}
-	if (j < pci_root_num) {
-		info = &pci_root_info[j];
-
-		for (i = 0; i < RANGE_NUM; i++) {
-			if (!range[i].end)
-				continue;
-
-			update_res(info, range[i].start, range[i].end,
-				   IORESOURCE_MEM, 1);
-		}
-	}
-
-	for (i = 0; i < pci_root_num; i++) {
-		int res_num;
-		int busnum;
-
-		info = &pci_root_info[i];
-		res_num = info->res_num;
-		busnum = info->bus_min;
-		printk(KERN_DEBUG "bus: [%02x,%02x] on node %x link %x\n",
-		       info->bus_min, info->bus_max, info->node, info->link);
-		for (j = 0; j < res_num; j++) {
-			res = &info->res[j];
-			printk(KERN_DEBUG "bus: %02x index %x %s: [%llx, %llx]\n",
-			       busnum, j,
-			       (res->flags & IORESOURCE_IO)?"io port":"mmio",
-			       res->start, res->end);
-		}
-	}
-
-	return 0;
-}
-
-postcore_initcall(early_fill_mp_bus_info);
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 720c4c5..ba263e6 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -27,6 +27,7 @@
 #define PCI_CAN_SKIP_ISA_ALIGN	0x8000
 #define PCI_USE__CRS		0x10000
 #define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
+#define PCI_HAS_IO_ECS		0x40000
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
-- 
1.5.5.3


