Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbYACAyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbYACAyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbYACAuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759805AbYACAuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:12 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [15/20] x86: Move X86_FEATURE_CONSTANT_TSC into early cpu feature detection
Message-Id: <20080103005011.06E9914D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Need this in the next patch in time_init and that happens early.

This includes a minor fix on i386 where early_intel_workarounds()
[which is now called early_init_intel] really executes early as 
the comments say.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/amd.c    |   17 +++++++++++------
 arch/x86/kernel/cpu/common.c |   11 +++++++++--
 arch/x86/kernel/cpu/cpu.h    |    3 ++-
 arch/x86/kernel/cpu/intel.c  |   13 ++++++-------
 arch/x86/kernel/setup_64.c   |   39 +++++++++++++++++++++++++++++++--------
 5 files changed, 59 insertions(+), 24 deletions(-)

Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -553,9 +553,6 @@ static void __cpuinit display_cacheinfo(
 		printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
 		c->x86_cache_size, ecx & 0xFF);
 	}
-
-	if (n >= 0x80000007)
-		cpuid(0x80000007, &dummy, &dummy, &dummy, &c->x86_power);
 	if (n >= 0x80000008) {
 		cpuid(0x80000008, &eax, &dummy, &dummy, &dummy);
 		c->x86_virt_bits = (eax >> 8) & 0xff;
@@ -633,7 +630,7 @@ static void __init amd_detect_cmp(struct
 #endif
 }
 
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned bits, ecx;
@@ -691,6 +688,15 @@ static __cpuinit int amd_apic_timer_brok
 	return 0;
 }
 
+static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+	early_init_amd_mc(c);
+
+ 	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
+	if (c->x86_power & (1<<8))
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level;
@@ -740,10 +746,6 @@ static void __cpuinit init_amd(struct cp
 	}
 	display_cacheinfo(c);
 
-	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
-	if (c->x86_power & (1<<8))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008)
 		amd_detect_cmp(c);
@@ -850,6 +852,13 @@ static void srat_detect_node(void)
 #endif
 }
 
+static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+{
+	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
+	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
+		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
+}
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	/* Cache sizes */
@@ -1061,6 +1070,20 @@ void __cpuinit identify_cpu(struct cpuin
 #ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
+
+	c->extended_cpuid_level = cpuid_eax(0x80000000);
+
+	if (c->extended_cpuid_level >= 0x80000007)
+		c->x86_power = cpuid_edx(0x80000007);
+
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		early_init_amd(c);
+		break;
+	case X86_VENDOR_INTEL:
+		early_init_intel(c);
+		break;
+	}
 }
 
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
Index: linux/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/amd.c
+++ linux/arch/x86/kernel/cpu/amd.c
@@ -63,6 +63,15 @@ static __cpuinit int amd_apic_timer_brok
 
 int force_mwait __cpuinitdata;
 
+void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+	if (cpuid_eax(0x80000000) >= 0x80000007) {
+		c->x86_power = cpuid_edx(0x80000007);
+		if (c->x86_power & (1<<8))
+			set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
+	}
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
@@ -85,6 +94,8 @@ static void __cpuinit init_amd(struct cp
 	}
 #endif
 
+	early_init_amd(c);
+
 	/*
 	 *	FIXME: We should handle the K5 here. Set up the write
 	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
@@ -257,12 +268,6 @@ static void __cpuinit init_amd(struct cp
 		c->x86_max_cores = (cpuid_ecx(0x80000008) & 0xff) + 1;
 	}
 
-	if (cpuid_eax(0x80000000) >= 0x80000007) {
-		c->x86_power = cpuid_edx(0x80000007);
-		if (c->x86_power & (1<<8))
-			set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
-	}
-
 #ifdef CONFIG_X86_HT
 	/*
 	 * On a AMD multi core setup the lower bits of the APIC id
Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -307,6 +307,15 @@ static void __init early_cpu_detect(void
 	cpu_detect(c);
 
 	get_cpu_vendor(c, 1);
+
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		early_init_amd(c);
+		break;
+	case X86_VENDOR_INTEL:
+		early_init_intel(c);
+		break;
+	}
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
@@ -364,8 +373,6 @@ static void __cpuinit generic_identify(s
 		init_scattered_cpuid_features(c);
 	}
 
-	early_intel_workaround(c);
-
 #ifdef CONFIG_X86_HT
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
 #endif
Index: linux/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -29,13 +29,14 @@
 struct movsl_mask movsl_mask __read_mostly;
 #endif
 
-void __cpuinit early_intel_workaround(struct cpuinfo_x86 *c)
+void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
-	if (c->x86_vendor != X86_VENDOR_INTEL)
-		return;
 	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
 	if (c->x86 == 15 && c->x86_cache_alignment == 64)
 		c->x86_cache_alignment = 128;
+	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
+		(c->x86 == 0x6 && c->x86_model >= 0x0e))
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 }
 
 /*
@@ -115,6 +116,8 @@ static void __cpuinit init_intel(struct 
 	unsigned int l2 = 0;
 	char *p = NULL;
 
+	early_init_intel(c);
+
 #ifdef CONFIG_X86_F00F_BUG
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
@@ -209,10 +212,6 @@ static void __cpuinit init_intel(struct 
 	}
 	if (c->x86 == 6) 
 		set_bit(X86_FEATURE_P3, c->x86_capability);
-	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-		(c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
-
 	if (cpu_has_ds) {
 		unsigned int l1;
 		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
Index: linux/arch/x86/kernel/cpu/cpu.h
===================================================================
--- linux.orig/arch/x86/kernel/cpu/cpu.h
+++ linux/arch/x86/kernel/cpu/cpu.h
@@ -24,5 +24,6 @@ extern struct cpu_dev * cpu_devs [X86_VE
 extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
-extern void early_intel_workaround(struct cpuinfo_x86 *c);
+extern void early_init_intel(struct cpuinfo_x86 *c);
+extern void early_init_amd(struct cpuinfo_x86 *c);
 
