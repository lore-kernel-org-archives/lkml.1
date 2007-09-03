Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbYE1Q6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbYE1Q6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYE1Q62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:58:28 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24370 "EHLO
	outbound2-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624AbYE1Q61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:58:27 -0400
X-BigFish: VPS-5(zz18c1K655Oc8kzz10d3izzz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K1L8GV-02-413-01
In-Reply-To: <20080526180616.GB2752@erda.amd.com>
References: <20080526180616.GB2752@erda.amd.com>
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 3 Sep 2007 10:17:39 +0200
Subject: [PATCH] x86: Add PCI extended config space access for AMD Barcelona
To: Arjan van de Ven <arjan@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Message-Id: <20080528165813.8D8E5814C@erda.amd.com>
X-OriginalArrivalTime: 28 May 2008 16:58:13.0822 (UTC) FILETIME=[045B2DE0:01C8C0E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements PCI extended configuration space access for
AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
addresses. An x86 capability bit has been introduced that is set for
CPUs supporting PCI extended config space accesses.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/amd.c    |    4 ++++
 arch/x86/kernel/setup.c      |   13 +++++++++++++
 arch/x86/kernel/setup.h      |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/setup_64.c   |    5 +++++
 arch/x86/pci/direct.c        |   21 +++++++++++++++------
 include/asm-x86/cpufeature.h |    2 ++
 6 files changed, 65 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/kernel/setup.h

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2458668..99221f9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -6,6 +6,7 @@
 #include <asm/apic.h>
 
 #include <mach_apic.h>
+#include "../setup.h"
 #include "cpu.h"
 
 /*
@@ -308,6 +309,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
+
+	if (c->x86 == 0x10)
+		amd_enable_pci_ext_cfg(c);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6f80b85..d8f1712 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -136,4 +136,17 @@ void __init setup_per_cpu_areas(void)
 	setup_cpumask_of_cpu();
 }
 
+#define ENABLE_CF8_EXT_CFG      (1ULL << 46)
+
+void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
+{
+	u64 reg;
+	rdmsrl(MSR_AMD64_NB_CFG, reg);
+	if (!(reg & ENABLE_CF8_EXT_CFG)) {
+		reg |= ENABLE_CF8_EXT_CFG;
+		wrmsrl(MSR_AMD64_NB_CFG, reg);
+	}
+	set_cpu_cap(c, X86_FEATURE_PCI_EXT_CFG);
+}
+
 #endif
diff --git a/arch/x86/kernel/setup.h b/arch/x86/kernel/setup.h
new file mode 100644
index 0000000..66cc2c7
--- /dev/null
+++ b/arch/x86/kernel/setup.h
@@ -0,0 +1,26 @@
+/*
+ * Internal declarations for shared x86 setup code.
+ *
+ * Copyright (c) 2008 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+
+#ifndef _ARCH_X86_KERNEL_SETUP_H
+
+extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
+
+#endif	/* _ARCH_X86_KERNEL_SETUP_H */
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 6dff128..fdd2469 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -72,6 +72,8 @@
 #include <asm/trampoline.h>
 #include <asm/pat.h>
 
+#include "setup.h"
+
 #include <mach_apic.h>
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
@@ -790,6 +792,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 == 0x10)
 		fam10h_check_enable_mmcfg();
 
+	if (c->x86 == 0x10)
+		amd_enable_pci_ext_cfg(c);
+
 	if (amd_apic_timer_broken())
 		disable_apic_timer = 1;
 
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 21d1e0e..27d61b6 100644
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
@@ -260,10 +263,16 @@ void __init pci_direct_init(int type)
 		return;
 	printk(KERN_INFO "PCI: Using configuration type %d for base access\n",
 		 type);
-	if (type == 1)
+	if (type == 1) {
 		raw_pci_ops = &pci_direct_conf1;
-	else
+		if (!raw_pci_ext_ops && cpu_has_pci_ext_cfg) {
+			printk(KERN_INFO "PCI: Using configuration type 1 "
+			       "for extended access\n");
+			raw_pci_ext_ops = &pci_direct_conf1;
+		}
+	} else {
 		raw_pci_ops = &pci_direct_conf2;
+	}
 }
 
 int __init pci_direct_probe(void)
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 0d609c8..40fcbba 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -79,6 +79,7 @@
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
+#define X86_FEATURE_PCI_EXT_CFG	(3*32+19) /* PCI extended cfg access */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
@@ -187,6 +188,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_pci_ext_cfg	boot_cpu_has(X86_FEATURE_PCI_EXT_CFG)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
-- 
1.5.3.7


