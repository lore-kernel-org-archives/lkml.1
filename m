Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbYGHMsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbYGHMsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYGHMqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:46:43 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27565 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759670AbYGHMqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:46:40 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 03/58] microblaze_v5: Cpuinfo handling
Date: Tue,  8 Jul 2008 13:59:03 +0200
Message-Id: <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |   83 ++++++++++++++++++
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |  114 +++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/cpuinfo.c          |   84 ++++++++++++++++++
 include/asm-microblaze/cpuinfo.h              |  110 ++++++++++++++++++++++++
 4 files changed, 391 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-static.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo.c
 create mode 100644 include/asm-microblaze/cpuinfo.h

diff --git a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
new file mode 100644
index 0000000..b5ff5b1
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
@@ -0,0 +1,83 @@
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
+#define CI(c, p) ci->c = PVR_##p(pvr)
+
+void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu)
+{
+	struct pvr_s pvr;
+	get_pvr(&pvr);
+
+	CI(use_barrel, USE_BARREL);
+	CI(use_divider, USE_DIV);
+	CI(use_mult, USE_HW_MUL);
+	CI(use_fpu, USE_FPU);
+
+	CI(use_mul_64, USE_MUL64);
+	CI(use_msr_instr, USE_MSR_INSTR);
+	CI(use_pcmp_instr, USE_PCMP_INSTR);
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
+	CI(opcode_0_illegal, OPCODE_0x0_ILLEGAL);
+	CI(exc_unaligned, UNALIGNED_EXCEPTION);
+	CI(exc_ill_opcode, ILL_OPCODE_EXCEPTION);
+	CI(exc_iopb, IOPB_BUS_EXCEPTION);
+	CI(exc_dopb, DOPB_BUS_EXCEPTION);
+	CI(exc_div_zero, DIV_ZERO_EXCEPTION);
+	CI(exc_fpu, FPU_EXCEPTION);
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
index 0000000..a81bcd6
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
@@ -0,0 +1,114 @@
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
+
+const static char family_string[] = CONFIG_XILINX_MICROBLAZE0_FAMILY;
+const static char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;
+
+void __init set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu)
+{
+	int i;
+
+	ci->use_barrel = fcpu(cpu, "xlnx,use-barrel");
+	ci->use_divider = fcpu(cpu, "xlnx,use-div");
+	ci->use_mult = fcpu(cpu, "xlnx,use-hw-mul");
+	ci->use_fpu = fcpu(cpu, "xlnx,use-fpu");
+	ci->use_mul_64 = (ci->use_mult == 2 ? 1 : 0);
+	ci->use_msr_instr = fcpu(cpu, "xlnx,use-msr-instr");
+	ci->use_pcmp_instr = fcpu(cpu, "xlnx,use-pcmp-instr");
+
+	ci->use_exception = fcpu(cpu, "xlnx,unaligned-exceptions") ||
+			fcpu(cpu, "xlnx,ill-opcode-exception") ||
+			fcpu(cpu, "xlnx,iopb-bus-exception") ||
+			fcpu(cpu, "xlnx,dopb-bus-exception") ||
+			fcpu(cpu, "xlnx,div-zero-exception") ||
+			fcpu(cpu, "xlnx,fpu-exception");
+
+	ci->exc_unaligned = fcpu(cpu, "xlnx,unaligned-exceptions");
+	ci->exc_unaligned = fcpu(cpu, "xlnx,ill-opcode-exception");
+	ci->exc_iopb = fcpu(cpu, "xlnx,iopb-bus-exception");
+	ci->exc_dopb = fcpu(cpu, "xlnx,dopb-bus-exception");
+	ci->exc_fpu = fcpu(cpu, "xlnx,fpu-exception");
+	ci->exc_div_zero = fcpu(cpu, "xlnx,div-zero-exception");
+	ci->opcode_0_illegal = fcpu(cpu, "xlnx,opcode-0x0-illegal");
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
index 0000000..7a3ace8
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -0,0 +1,84 @@
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
+		set_cpuinfo_pvr_full(&cpuinfo, cpu);
+		break;
+	default:
+		printk(KERN_WARNING "%s: Unsupported PVR setting\n", __func__);
+		set_cpuinfo_static(&cpuinfo, cpu);
+	}
+}
diff --git a/include/asm-microblaze/cpuinfo.h b/include/asm-microblaze/cpuinfo.h
new file mode 100644
index 0000000..b9cd56d
--- /dev/null
+++ b/include/asm-microblaze/cpuinfo.h
@@ -0,0 +1,110 @@
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
+	int use_barrel;
+	int use_divider;
+	int use_mult;
+	int use_fpu;
+	int use_exception;
+	int use_mul_64;
+	int use_msr_instr;
+	int use_pcmp_instr;
+
+	int ver_code;
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
+	/* HW support for CPU exceptions */
+	int opcode_0_illegal;
+	int exc_unaligned;
+	int exc_ill_opcode;
+	int exc_iopb;
+	int exc_dopb;
+	int exc_div_zero;
+	int exc_fpu;
+
+	/* HW debug support */
+	int hw_debug;
+	int num_pc_brk;
+	int num_rd_brk;
+	int num_wr_brk;
+	int cpu_clock_freq;
+
+	/* FPGA family */
+	int fpga_family_code;
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
+	return ((val = (int *) of_get_property(cpu, n, NULL)) ? *val : 0);
+}
+
+#endif /* _ASM_MICROBLAZE_CPUINFO_H */
-- 
1.5.4.GIT

