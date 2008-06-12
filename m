Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYFLTH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYFLTH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYFLTHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:07:51 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.113]:7389 "EHLO
	mail109-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752696AbYFLTHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:07:49 -0400
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 15:07:49 EDT
X-BigFish: VPS-5(zz655Ozz10d3izzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2D580-01-6HA-01
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/2] x86: Move PCI IO ECS code to x86/pci
Date: Thu, 12 Jun 2008 20:19:23 +0200
Message-Id: <1213294763-19566-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <20080603072550.GR23679@erda.amd.com>
References: <20080603072550.GR23679@erda.amd.com>
X-OriginalArrivalTime: 12 Jun 2008 18:40:21.0204 (UTC) FILETIME=[C4C1B940:01C8CCBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Form follows function". Code is now where it belongs to.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/amd.c    |    3 ---
 arch/x86/kernel/cpu/amd_64.c |    4 ----
 arch/x86/kernel/cpu/cpu.h    |    2 --
 arch/x86/kernel/setup.c      |   13 -------------
 arch/x86/pci/Makefile_32     |    1 +
 arch/x86/pci/amd_bus.c       |   32 ++++++++++++++++++++++++++++++++
 arch/x86/pci/direct.c        |   16 +++++++++-------
 arch/x86/pci/pci.h           |    1 +
 include/asm-x86/cpufeature.h |    2 --
 9 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index acc891a..81a07ca 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -266,9 +266,6 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
-
-	if (c->x86 == 0x10)
-		amd_enable_pci_ext_cfg(c);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
index f8d2058..250bfe6 100644
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -6,7 +6,6 @@
 #include <asm/cacheflush.h>
 
 #include <mach_apic.h>
-#include "cpu.h"
 
 extern int __cpuinit get_model_name(struct cpuinfo_x86 *c);
 extern void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c);
@@ -187,9 +186,6 @@ void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 == 0x10)
 		fam10h_check_enable_mmcfg();
 
-	if (c->x86 == 0x10)
-		amd_enable_pci_ext_cfg(c);
-
 	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
 		unsigned long long tseg;
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index f5d5bb1..40ad189 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -39,5 +39,3 @@ extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
 #endif /* CONFIG_X86_32 */
-
-extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 20e14db..6f80b85 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -137,16 +137,3 @@ void __init setup_per_cpu_areas(void)
 }
 
 #endif
-#define ENABLE_CF8_EXT_CFG      (1ULL << 46)
-
-void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c)
-{
-	u64 reg;
-	rdmsrl(MSR_AMD64_NB_CFG, reg);
-	if (!(reg & ENABLE_CF8_EXT_CFG)) {
-		reg |= ENABLE_CF8_EXT_CFG;
-		wrmsrl(MSR_AMD64_NB_CFG, reg);
-	}
-	set_cpu_cap(c, X86_FEATURE_PCI_EXT_CFG);
-}
-
diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
index 89ec35d..f647e7e 100644
--- a/arch/x86/pci/Makefile_32
+++ b/arch/x86/pci/Makefile_32
@@ -22,3 +22,4 @@ pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
 pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
+obj-y				+= amd_bus.o
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 5c2799c..15f505d 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -1,5 +1,9 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include "pci.h"
+
+#ifdef CONFIG_X86_64
+
 #include <asm/pci-direct.h>
 #include <asm/mpspec.h>
 #include <linux/cpumask.h>
@@ -526,3 +530,31 @@ static int __init early_fill_mp_bus_info(void)
 }
 
 postcore_initcall(early_fill_mp_bus_info);
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
index 27d61b6..9915293 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -265,14 +265,16 @@ void __init pci_direct_init(int type)
 		 type);
 	if (type == 1) {
 		raw_pci_ops = &pci_direct_conf1;
-		if (!raw_pci_ext_ops && cpu_has_pci_ext_cfg) {
-			printk(KERN_INFO "PCI: Using configuration type 1 "
-			       "for extended access\n");
-			raw_pci_ext_ops = &pci_direct_conf1;
-		}
-	} else {
-		raw_pci_ops = &pci_direct_conf2;
+		if (raw_pci_ext_ops)
+			return;
+		if (!(pci_probe & PCI_HAS_IO_ECS))
+			return;
+		printk(KERN_INFO "PCI: Using configuration type 1 "
+		       "for extended access\n");
+		raw_pci_ext_ops = &pci_direct_conf1;
+		return;
 	}
+	raw_pci_ops = &pci_direct_conf2;
 }
 
 int __init pci_direct_probe(void)
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index f3972b1..fd53db5 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -27,6 +27,7 @@
 #define PCI_CAN_SKIP_ISA_ALIGN	0x8000
 #define PCI_USE__CRS		0x10000
 #define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
+#define PCI_HAS_IO_ECS		0x40000
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 40fcbba..0d609c8 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -79,7 +79,6 @@
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
-#define X86_FEATURE_PCI_EXT_CFG	(3*32+19) /* PCI extended cfg access */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
@@ -188,7 +187,6 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
-#define cpu_has_pci_ext_cfg	boot_cpu_has(X86_FEATURE_PCI_EXT_CFG)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
-- 
1.5.5.3


