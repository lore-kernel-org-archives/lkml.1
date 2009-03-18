Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbZCRUdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbZCRUdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZCRUbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:45 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56203 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752581AbZCRUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:39 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 03/57] microblaze_v7: Cpuinfo handling
Date: Wed, 18 Mar 2009 21:30:30 +0100
Message-Id: <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/cpuinfo.h         |  102 +++++++++++++++++
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |  101 +++++++++++++++++
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |  145 +++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/cpuinfo.c          |   87 +++++++++++++++
 4 files changed, 435 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/cpuinfo.h
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-static.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo.c

diff --git a/arch/microblaze/include/asm/cpuinfo.h b/arch/microblaze/include/asm/cpuinfo.h
new file mode 100644
index 0000000..0f40f7a
--- /dev/null
+++ b/arch/microblaze/include/asm/cpuinfo.h
@@ -0,0 +1,102 @@
+/*
+ * Generic support for queying CPU info
+ *
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_CPUINFO_H
+#define _ASM_MICROBLAZE_CPUINFO_H
+
+#include <asm/prom.h>
+
+/* CPU Version and FPGA Family code conversion table type */
+struct cpu_ver_key {
+	const char *s;
+	const unsigned k;
+};
+
+extern const struct cpu_ver_key cpu_ver_lookup[];
+
+struct family_string_key {
+	const char *s;
+	const unsigned k;
+};
+
+extern const struct family_string_key family_string_lookup[];
+
+struct cpuinfo {
+	/* Core CPU configuration */
+	int use_instr;
+	int use_mult;
+	int use_fpu;
+	int use_exc;
+	int ver_code;
+	int mmu;
+
+	/* CPU caches */
+	int use_icache;
+	int icache_tagbits;
+	int icache_write;
+	int icache_line;
+	int icache_size;
+	unsigned long icache_base;
+	unsigned long icache_high;
+
+	int use_dcache;
+	int dcache_tagbits;
+	int dcache_write;
+	int dcache_line;
+	int dcache_size;
+	unsigned long dcache_base;
+	unsigned long dcache_high;
+
+	/* Bus connections */
+	int use_dopb;
+	int use_iopb;
+	int use_dlmb;
+	int use_ilmb;
+	int num_fsl;
+
+	/* CPU interrupt line info */
+	int irq_edge;
+	int irq_positive;
+
+	int area_optimised;
+
+	/* HW debug support */
+	int hw_debug;
+	int num_pc_brk;
+	int num_rd_brk;
+	int num_wr_brk;
+	int cpu_clock_freq; /* store real freq of cpu */
+	int freq_div_hz; /* store freq/HZ */
+
+	/* FPGA family */
+	int fpga_family_code;
+
+	/* User define */
+	int pvr_user1;
+	int pvr_user2;
+};
+
+extern struct cpuinfo cpuinfo;
+
+/* fwd declarations of the various CPUinfo populators */
+void setup_cpuinfo(void);
+
+void set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu);
+void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu);
+
+static inline unsigned int fcpu(struct device_node *cpu, char *n)
+{
+	int *val;
+	return (val = (int *) of_get_property(cpu, n, NULL)) ? *val : 0;
+}
+
+#endif /* _ASM_MICROBLAZE_CPUINFO_H */
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
new file mode 100644
index 0000000..576b456
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
@@ -0,0 +1,101 @@
+/*
+ * Support for MicroBlaze PVR (processor version register)
+ *
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/string.h>
+#include <asm/pvr.h>
+#include <asm/cpuinfo.h>
+
+/*
+ * Helper macro to map between fields in our struct cpuinfo, and
+ * the PVR macros in pvr.h.
+ */
+
+#define CI(c, p) { ci->c = PVR_##p(pvr); }
+#define err_printk(x) \
+	early_printk("ERROR: Microblaze " x " - different for PVR and DTS\n");
+
+void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu)
+{
+	struct pvr_s pvr;
+	int temp; /* for saving temp value */
+	get_pvr(&pvr);
+
+	temp = PVR_USE_BARREL(pvr) | PVR_USE_MSR_INSTR(pvr) |\
+		PVR_USE_PCMP_INSTR(pvr) | PVR_USE_DIV(pvr);
+	if (ci->use_instr != temp)
+		err_printk("BARREL, MSR, PCMP or DIV");
+	ci->use_instr = temp;
+
+	temp = PVR_USE_HW_MUL(pvr) | PVR_USE_MUL64(pvr);
+	if (ci->use_mult != temp)
+		err_printk("HW_MUL");
+	ci->use_mult = temp;
+
+	temp = PVR_USE_FPU(pvr) | PVR_USE_FPU2(pvr);
+	if (ci->use_fpu != temp)
+		err_printk("HW_FPU");
+	ci->use_fpu = temp;
+
+	ci->use_exc = PVR_OPCODE_0x0_ILLEGAL(pvr) |\
+			PVR_UNALIGNED_EXCEPTION(pvr) |\
+			PVR_ILL_OPCODE_EXCEPTION(pvr) |\
+			PVR_IOPB_BUS_EXCEPTION(pvr) |\
+			PVR_DOPB_BUS_EXCEPTION(pvr) |\
+			PVR_DIV_ZERO_EXCEPTION(pvr) |\
+			PVR_FPU_EXCEPTION(pvr) |\
+			PVR_FSL_EXCEPTION(pvr);
+
+	CI(pvr_user1, USER1);
+	CI(pvr_user2, USER2);
+
+	CI(mmu, USE_MMU);
+
+	CI(ver_code, VERSION);
+
+	CI(use_icache, USE_ICACHE);
+	CI(icache_tagbits, ICACHE_ADDR_TAG_BITS);
+	CI(icache_write, ICACHE_ALLOW_WR);
+	CI(icache_line, ICACHE_LINE_LEN);
+	CI(icache_size, ICACHE_BYTE_SIZE);
+	CI(icache_base, ICACHE_BASEADDR);
+	CI(icache_high, ICACHE_HIGHADDR);
+
+	CI(use_dcache, USE_DCACHE);
+	CI(dcache_tagbits, DCACHE_ADDR_TAG_BITS);
+	CI(dcache_write, DCACHE_ALLOW_WR);
+	CI(dcache_line, DCACHE_LINE_LEN);
+	CI(dcache_size, DCACHE_BYTE_SIZE);
+	CI(dcache_base, DCACHE_BASEADDR);
+	CI(dcache_high, DCACHE_HIGHADDR);
+
+	CI(use_dopb, D_OPB);
+	CI(use_iopb, I_OPB);
+	CI(use_dlmb, D_LMB);
+	CI(use_ilmb, I_LMB);
+	CI(num_fsl, FSL_LINKS);
+
+	CI(irq_edge, INTERRUPT_IS_EDGE);
+	CI(irq_positive, EDGE_IS_POSITIVE);
+
+	CI(area_optimised, AREA_OPTIMISED);
+
+	CI(hw_debug, DEBUG_ENABLED);
+	CI(num_pc_brk, NUMBER_OF_PC_BRK);
+	CI(num_rd_brk, NUMBER_OF_RD_ADDR_BRK);
+	CI(num_wr_brk, NUMBER_OF_WR_ADDR_BRK);
+
+	CI(fpga_family_code, TARGET_FAMILY);
+
+	/* take timebase-frequency from DTS */
+	ci->cpu_clock_freq = fcpu(cpu, "timebase-frequency");
+}
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-static.c b/arch/microblaze/kernel/cpu/cpuinfo-static.c
new file mode 100644
index 0000000..2bba402
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
@@ -0,0 +1,145 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <asm/cpuinfo.h>
+#include <asm/pvr.h>
+
+const static char family_string[] = CONFIG_XILINX_MICROBLAZE0_FAMILY;
+const static char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;
+
+#define err_printk(x) \
+	early_printk("ERROR: Microblaze " x "- different for kernel and DTS\n");
+
+void __init set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu)
+{
+	int i = 0;
+
+	ci->use_instr =
+		(fcpu(cpu, "xlnx,use-barrel") ? PVR0_USE_BARREL_MASK : 0) |
+		(fcpu(cpu, "xlnx,use-msr-instr") ? PVR2_USE_MSR_INSTR : 0) |
+		(fcpu(cpu, "xlnx,use-pcmp-instr") ? PVR2_USE_PCMP_INSTR : 0) |
+		(fcpu(cpu, "xlnx,use-div") ? PVR0_USE_DIV_MASK : 0);
+	if (CONFIG_XILINX_MICROBLAZE0_USE_BARREL)
+		i |= PVR0_USE_BARREL_MASK;
+	if (CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR)
+		i |= PVR2_USE_MSR_INSTR;
+	if (CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR)
+		i |= PVR2_USE_PCMP_INSTR;
+	if (CONFIG_XILINX_MICROBLAZE0_USE_DIV)
+		i |= PVR0_USE_DIV_MASK;
+	if (ci->use_instr != i)
+		err_printk("BARREL, MSR, PCMP or DIV");
+
+	ci->use_mult = fcpu(cpu, "xlnx,use-hw-mul");
+	if (ci->use_mult != CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL)
+		err_printk("HW_MUL");
+	ci->use_mult =
+		(ci->use_mult > 1 ?
+				(PVR2_USE_MUL64_MASK | PVR0_USE_HW_MUL_MASK) :
+				(ci->use_mult == 1 ? PVR0_USE_HW_MUL_MASK : 0));
+
+	ci->use_fpu = fcpu(cpu, "xlnx,use-fpu");
+	if (ci->use_fpu != CONFIG_XILINX_MICROBLAZE0_USE_FPU)
+		err_printk("HW_FPU");
+	ci->use_fpu = (ci->use_fpu > 1 ?
+				(PVR2_USE_FPU2_MASK | PVR0_USE_FPU_MASK) :
+				(ci->use_fpu == 1 ? PVR0_USE_FPU_MASK : 0));
+
+	ci->use_exc =
+		(fcpu(cpu, "xlnx,unaligned-exceptions") ?
+				PVR2_UNALIGNED_EXC_MASK : 0) |
+		(fcpu(cpu, "xlnx,ill-opcode-exception") ?
+				PVR2_ILL_OPCODE_EXC_MASK : 0) |
+		(fcpu(cpu, "xlnx,iopb-bus-exception") ?
+				PVR2_IOPB_BUS_EXC_MASK : 0) |
+		(fcpu(cpu, "xlnx,dopb-bus-exception") ?
+				PVR2_DOPB_BUS_EXC_MASK : 0) |
+		(fcpu(cpu, "xlnx,div-zero-exception") ?
+				PVR2_DIV_ZERO_EXC_MASK : 0) |
+		(fcpu(cpu, "xlnx,fpu-exception") ? PVR2_FPU_EXC_MASK : 0) |
+		(fcpu(cpu, "xlnx,fsl-exception") ? PVR2_USE_EXTEND_FSL : 0);
+
+	ci->use_icache = fcpu(cpu, "xlnx,use-icache");
+	ci->icache_tagbits = fcpu(cpu, "xlnx,addr-tag-bits");
+	ci->icache_write = fcpu(cpu, "xlnx,allow-icache-wr");
+	ci->icache_line = fcpu(cpu, "xlnx,icache-line-len") << 2;
+	if (!ci->icache_line) {
+		if (fcpu(cpu, "xlnx,icache-use-fsl"))
+			ci->icache_line = 4 << 2;
+		else
+			ci->icache_line = 1 << 2;
+	}
+	ci->icache_size = fcpu(cpu, "i-cache-size");
+	ci->icache_base = fcpu(cpu, "i-cache-baseaddr");
+	ci->icache_high = fcpu(cpu, "i-cache-highaddr");
+
+	ci->use_dcache = fcpu(cpu, "xlnx,use-dcache");
+	ci->dcache_tagbits = fcpu(cpu, "xlnx,dcache-addr-tag");
+	ci->dcache_write = fcpu(cpu, "xlnx,allow-dcache-wr");
+	ci->dcache_line = fcpu(cpu, "xlnx,dcache-line-len") << 2;
+	if (!ci->dcache_line) {
+		if (fcpu(cpu, "xlnx,dcache-use-fsl"))
+			ci->dcache_line = 4 << 2;
+		else
+			ci->dcache_line = 1 << 2;
+	}
+	ci->dcache_size = fcpu(cpu, "d-cache-size");
+	ci->dcache_base = fcpu(cpu, "d-cache-baseaddr");
+	ci->dcache_high = fcpu(cpu, "d-cache-highaddr");
+
+	ci->use_dopb = fcpu(cpu, "xlnx,d-opb");
+	ci->use_iopb = fcpu(cpu, "xlnx,i-opb");
+	ci->use_dlmb = fcpu(cpu, "xlnx,d-lmb");
+	ci->use_ilmb = fcpu(cpu, "xlnx,i-lmb");
+
+	ci->num_fsl = fcpu(cpu, "xlnx,fsl-links");
+	ci->irq_edge = fcpu(cpu, "xlnx,interrupt-is-edge");
+	ci->irq_positive = fcpu(cpu, "xlnx,edge-is-positive");
+	ci->area_optimised = 0;
+
+	ci->hw_debug = fcpu(cpu, "xlnx,debug-enabled");
+	ci->num_pc_brk = fcpu(cpu, "xlnx,number-of-pc-brk");
+	ci->num_rd_brk = fcpu(cpu, "xlnx,number-of-rd-addr-brk");
+	ci->num_wr_brk = fcpu(cpu, "xlnx,number-of-wr-addr-brk");
+
+	ci->cpu_clock_freq = fcpu(cpu, "timebase-frequency");
+
+	ci->pvr_user1 = fcpu(cpu, "xlnx,pvr-user1");
+	ci->pvr_user2 = fcpu(cpu, "xlnx,pvr-user2");
+
+	ci->mmu = fcpu(cpu, "xlnx,use-mmu");
+
+	ci->ver_code = 0;
+	ci->fpga_family_code = 0;
+
+	/* Do various fixups based on CPU version and FPGA family strings */
+
+	/* Resolved the CPU version code */
+	for (i = 0; cpu_ver_lookup[i].s != NULL; i++) {
+		if (strcmp(cpu_ver_lookup[i].s, cpu_ver_string) == 0)
+			ci->ver_code = cpu_ver_lookup[i].k;
+	}
+
+	/* Resolved the fpga family code */
+	for (i = 0; family_string_lookup[i].s != NULL; i++) {
+		if (strcmp(family_string_lookup[i].s, family_string) == 0)
+			ci->fpga_family_code = family_string_lookup[i].k;
+	}
+
+	/* FIXME - mb3 and spartan2 do not exist in PVR */
+	/* This is mb3 and on a non Spartan2 */
+	if (ci->ver_code == 0x20 && ci->fpga_family_code != 0xf0)
+		/* Hardware Multiplier in use */
+		ci->use_mult = 1;
+}
diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
new file mode 100644
index 0000000..3cf2b3a
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <asm/cpuinfo.h>
+#include <asm/pvr.h>
+
+const struct cpu_ver_key cpu_ver_lookup[] = {
+	/* These key value are as per MBV field in PVR0 */
+	{"5.00.a", 0x01},
+	{"5.00.b", 0x02},
+	{"5.00.c", 0x03},
+	{"6.00.a", 0x04},
+	{"6.00.b", 0x06},
+	{"7.00.a", 0x05},
+	{"7.00.b", 0x07},
+	{"7.10.a", 0x08},
+	{"7.10.b", 0x09},
+	{"7.10.c", 0x0a},
+	{"7.10.d", 0x0b},
+	/* FIXME There is no keycode defined in MBV for these versions */
+	{"2.10.a", 0x10},
+	{"3.00.a", 0x20},
+	{"4.00.a", 0x30},
+	{"4.00.b", 0x40},
+	{NULL, 0},
+};
+
+/*
+ * FIXME Not sure if the actual key is defined by Xilinx in the PVR
+ */
+const struct family_string_key family_string_lookup[] = {
+	{"virtex2", 0x4},
+	{"virtex2pro", 0x5},
+	{"spartan3", 0x6},
+	{"virtex4", 0x7},
+	{"virtex5", 0x8},
+	{"spartan3e", 0x9},
+	{"spartan3a", 0xa},
+	{"spartan3an", 0xb},
+	{"spartan3adsp", 0xc},
+	/* FIXME There is no key code defined for spartan2 */
+	{"spartan2", 0xf0},
+	{NULL, 0},
+};
+
+struct cpuinfo cpuinfo;
+
+void __init setup_cpuinfo(void)
+{
+	struct device_node *cpu = NULL;
+
+	cpu = (struct device_node *) of_find_node_by_type(NULL, "cpu");
+	if (!cpu)
+		printk(KERN_ERR "You don't have cpu!!!\n");
+
+	printk(KERN_INFO "%s: initialising\n", __func__);
+
+	switch (cpu_has_pvr()) {
+	case 0:
+		printk(KERN_WARNING
+			"%s: No PVR support. Using static CPU info from FDT\n",
+			__func__);
+		set_cpuinfo_static(&cpuinfo, cpu);
+		break;
+/* FIXME I found weird behavior with MB 7.00.a/b
+ * please do not use FULL PVR with MMU */
+	case 1:
+		printk(KERN_INFO "%s: Using full CPU PVR support\n",
+			__func__);
+		set_cpuinfo_static(&cpuinfo, cpu);
+		set_cpuinfo_pvr_full(&cpuinfo, cpu);
+		break;
+	default:
+		printk(KERN_WARNING "%s: Unsupported PVR setting\n", __func__);
+		set_cpuinfo_static(&cpuinfo, cpu);
+	}
+}
-- 
1.5.5.1

