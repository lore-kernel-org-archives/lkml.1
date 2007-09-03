Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbXICIUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbXICIUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXICITt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:19:49 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:1427 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbXICITr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:19:47 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <20070903081736.588599000@amd.com>
References: <20070903081736.288288000@amd.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Sep 2007 10:17:39 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 3/5] x86: Add PCI extended config space access for AMD
 Barcelona
X-OriginalArrivalTime: 03 Sep 2007 08:18:31.0652 (UTC)
 FILETIME=[03A0A240:01C7EE03]
MIME-Version: 1.0
X-WSS-ID: 6AC51C181A46452963-02-01
Content-Disposition: inline;
 filename=fam10h-pci-ext-cfg-io.diff
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements PCI extended configuration space access for
AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
addresses. An x86 capability bit has been introduced that is set for
CPUs supporting PCI extended config space accesses.

Signed-off-by: Robert Richter <robert.richter@amd.com>

---
 arch/i386/kernel/cpu/amd.c    |   11 +++++-
 arch/i386/pci/direct.c        |   67 +++++++++++++++++++++++++++++++++++-------
 arch/x86_64/kernel/setup.c    |   12 ++++++-
 include/asm-i386/cpufeature.h |    2 +
 4 files changed, 77 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/i386/pci/direct.c
===================================================================
--- linux-2.6.orig/arch/i386/pci/direct.c
+++ linux-2.6/arch/i386/pci/direct.c
@@ -8,18 +8,22 @@
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
 
-int pci_conf1_read(unsigned int seg, unsigned int bus,
-			  unsigned int devfn, int reg, int len, u32 *value)
+static inline int
+_pci_conf1ext_read(unsigned int seg, unsigned int bus,
+		   unsigned int devfn, int reg, int len, u32 *value)
 {
 	unsigned long flags;
 
-	if ((bus > 255) || (devfn > 255) || (reg > 255)) {
+	if ((bus > 255) || (devfn > 255) || (reg > 4095)) {
 		*value = -1;
 		return -EINVAL;
 	}
@@ -45,12 +49,29 @@ int pci_conf1_read(unsigned int seg, uns
 	return 0;
 }
 
-int pci_conf1_write(unsigned int seg, unsigned int bus,
-			   unsigned int devfn, int reg, int len, u32 value)
+int pci_conf1ext_read(unsigned int seg, unsigned int bus,
+		      unsigned int devfn, int reg, int len, u32 *value)
+{
+	return _pci_conf1ext_read(seg, bus, devfn, reg, len, value);
+}
+
+int pci_conf1_read(unsigned int seg, unsigned int bus,
+			  unsigned int devfn, int reg, int len, u32 *value)
+{
+	if (reg > 255) {
+		*value = -1;
+		return -EINVAL;
+	}
+	return _pci_conf1ext_read(seg, bus, devfn, reg, len, value);
+}
+
+static inline int
+_pci_conf1ext_write(unsigned int seg, unsigned int bus,
+		    unsigned int devfn, int reg, int len, u32 value)
 {
 	unsigned long flags;
 
-	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
+	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
@@ -74,6 +95,20 @@ int pci_conf1_write(unsigned int seg, un
 	return 0;
 }
 
+int pci_conf1ext_write(unsigned int seg, unsigned int bus,
+		       unsigned int devfn, int reg, int len, u32 value)
+{
+	return _pci_conf1ext_write(seg, bus, devfn, reg, len, value);
+}
+
+int pci_conf1_write(unsigned int seg, unsigned int bus,
+		 unsigned int devfn, int reg, int len, u32 value)
+{
+	if (reg > 255)
+		return -EINVAL;
+	return _pci_conf1ext_write(seg, bus, devfn, reg, len, value);
+}
+
 #undef PCI_CONF1_ADDRESS
 
 struct pci_raw_ops pci_direct_conf1 = {
@@ -81,6 +116,11 @@ struct pci_raw_ops pci_direct_conf1 = {
 	.write =	pci_conf1_write,
 };
 
+struct pci_raw_ops pci_direct_conf1ext = {
+	.read =		pci_conf1ext_read,
+	.write =	pci_conf1ext_write,
+};
+
 
 /*
  * Functions for accessing PCI configuration space with type 2 accesses
@@ -259,10 +299,15 @@ void __init pci_direct_init(int type)
 	if (type == 0)
 		return;
 	printk(KERN_INFO "PCI: Using configuration type %d\n", type);
-	if (type == 1)
-		raw_pci_ops = &pci_direct_conf1;
-	else
+	if (type != 1) {
 		raw_pci_ops = &pci_direct_conf2;
+	} else if (cpu_has_pci_ext_cfg) {
+		printk(KERN_INFO
+		       "PCI: Extended configuration space enabled\n");
+		raw_pci_ops = &pci_direct_conf1ext;
+	} else {
+		raw_pci_ops = &pci_direct_conf1;
+	}
 }
 
 int __init pci_direct_probe(void)
Index: linux-2.6/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/setup.c
+++ linux-2.6/arch/x86_64/kernel/setup.c
@@ -65,6 +65,8 @@
 #include <asm/sections.h>
 #include <asm/dmi.h>
 
+#define ENABLE_CF8_EXT_CFG		(1ULL << 46)
+
 /*
  * Machine setup..
  */
@@ -549,10 +551,9 @@ static void __init amd_detect_cmp(struct
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level;
-
-#ifdef CONFIG_SMP
 	unsigned long value;
 
+#ifdef CONFIG_SMP
 	/*
 	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
 	 * bit 6 of msr C001_0015
@@ -617,6 +618,13 @@ static void __cpuinit init_amd(struct cp
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
+
+	/* Access to PCI extended config space? */
+	if (c->x86 == 0x10) {
+		rdmsrl(MSR_AMD64_NB_CFG, value);
+		if (value & ENABLE_CF8_EXT_CFG)
+			set_bit(X86_FEATURE_PCI_EXT_CFG, &c->x86_capability);
+	}
 }
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
Index: linux-2.6/include/asm-i386/cpufeature.h
===================================================================
--- linux-2.6.orig/include/asm-i386/cpufeature.h
+++ linux-2.6/include/asm-i386/cpufeature.h
@@ -82,6 +82,7 @@
 /* 14 free */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
 #define X86_FEATURE_REP_GOOD   (3*32+16) /* rep microcode works well on this CPU */
+#define X86_FEATURE_PCI_EXT_CFG	(3*32+17) /* PCI extended cfg access */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
@@ -164,6 +165,7 @@
 #define cpu_has_pebs 		boot_cpu_has(X86_FEATURE_PEBS)
 #define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
 #define cpu_has_bts 		boot_cpu_has(X86_FEATURE_BTS)
+#define cpu_has_pci_ext_cfg	boot_cpu_has(X86_FEATURE_PCI_EXT_CFG)
 
 #endif /* __ASM_I386_CPUFEATURE_H */
 
Index: linux-2.6/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/cpu/amd.c
+++ linux-2.6/arch/i386/kernel/cpu/amd.c
@@ -32,6 +32,7 @@ __asm__(".align 4\nvide: ret");
 #define CPUID_XFAM_11H          0x00200000
 #define CPUID_XMOD              0x000f0000
 #define CPUID_XMOD_REV_F        0x00040000
+#define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
 /* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
 static __cpuinit int amd_apic_timer_broken(void)
@@ -63,10 +64,9 @@ static void __cpuinit init_amd(struct cp
 	u32 l, h;
 	int mbytes = num_physpages >> (20-PAGE_SHIFT);
 	int r;
-
-#ifdef CONFIG_SMP
 	unsigned long long value;
 
+#ifdef CONFIG_SMP
 	/* Disable TLB flush filter by setting HWCR.FFDIS on K8
 	 * bit 6 of msr C001_0015
 	 *
@@ -296,6 +296,13 @@ static void __cpuinit init_amd(struct cp
 	/* K6s reports MCEs but don't actually have all the MSRs */
 	if (c->x86 < 6)
 		clear_bit(X86_FEATURE_MCE, c->x86_capability);
+
+	/* Access to PCI extended config space? */
+	if (c->x86 == 0x10) {
+		rdmsrl(MSR_AMD64_NB_CFG, value);
+		if (value & ENABLE_CF8_EXT_CFG)
+			set_bit(X86_FEATURE_PCI_EXT_CFG, c->x86_capability);
+	}
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



