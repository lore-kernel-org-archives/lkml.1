Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbYIHBAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbYIHBAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYIHA7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:59:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:6916 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYIHA7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=utcuAo4U8R1SCwZOmk3B2gUTj8MSJqlfKy2g5gNbgpVg8ZshrRydG3ZToNMKsgbYMi
         LHhMPSuW0s/PJXWYJ05WyPqJjwz5nguqJiNhsGZDofIqEi0HBFGmWx1DUFrSLi4u7Ln0
         xs+J6IQAZ5VvxrSPMeYA5h9pYLkgK0QF9Qs7I=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 5/9] x86: make amd.c have 64bit support code
Date: Sun,  7 Sep 2008 17:58:54 -0700
Message-Id: <1220835538-18280-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/amd.c |  137 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 126 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3c8090d..32e7352 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -16,6 +16,7 @@
 
 #include "cpu.h"
 
+#ifdef CONFIG_X86_32
 /*
  *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
  *	misexecution of code under Linux. Owners of such processors should
@@ -177,6 +178,26 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 
 	set_cpu_cap(c, X86_FEATURE_K7);
 }
+#endif
+
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+static int __cpuinit nearby_node(int apicid)
+{
+	int i, node;
+
+	for (i = apicid - 1; i >= 0; i--) {
+		node = apicid_to_node[i];
+		if (node != NUMA_NO_NODE && node_online(node))
+			return node;
+	}
+	for (i = apicid + 1; i < MAX_LOCAL_APIC; i++) {
+		node = apicid_to_node[i];
+		if (node != NUMA_NO_NODE && node_online(node))
+			return node;
+	}
+	return first_node(node_online_map); /* Shouldn't happen */
+}
+#endif
 
 /*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
@@ -196,6 +217,42 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
+static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
+{
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	int cpu = smp_processor_id();
+	int node;
+	unsigned apicid = hard_smp_processor_id();
+
+	node = c->phys_proc_id;
+	if (apicid_to_node[apicid] != NUMA_NO_NODE)
+		node = apicid_to_node[apicid];
+	if (!node_online(node)) {
+		/* Two possibilities here:
+		   - The CPU is missing memory and no node was created.
+		   In that case try picking one from a nearby CPU
+		   - The APIC IDs differ from the HyperTransport node IDs
+		   which the K8 northbridge parsing fills in.
+		   Assume they are all increased by a constant offset,
+		   but in the same order as the HT nodeids.
+		   If that doesn't result in a usable node fall back to the
+		   path for the previous case.  */
+
+		int ht_nodeid = c->initial_apicid;
+
+		if (ht_nodeid >= 0 &&
+		    apicid_to_node[ht_nodeid] != NUMA_NO_NODE)
+			node = apicid_to_node[ht_nodeid];
+		/* Pick a nearby node */
+		if (!node_online(node))
+			node = nearby_node(apicid);
+	}
+	numa_set_node(cpu, node);
+
+	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+#endif
+}
+
 static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
@@ -226,13 +283,19 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
+	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
 	if (c->x86_power & (1<<8))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
+#else
 	/*  Set MTRR capability flag if appropriate */
-	if (c->x86_model == 13 || c->x86_model == 9 ||
-	   (c->x86_model == 8 && c->x86_mask >= 8))
-		set_cpu_cap(c, X86_FEATURE_K6_MTRR);
+	if (c->x86 == 5)
+		if (c->x86_model == 13 || c->x86_model == 9 ||
+		    (c->x86_model == 8 && c->x86_mask >= 8))
+			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
+#endif
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
@@ -257,17 +320,30 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	early_init_amd(c);
 
 	/*
-	 *	FIXME: We should handle the K5 here. Set up the write
-	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
-	 *	no bus pipeline)
-	 */
-
-	/*
 	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
 	 */
 	clear_cpu_cap(c, 0*32+31);
 
+#ifdef CONFIG_X86_64
+	/* On C+ stepping K8 rep microcode works well for copy/memset */
+	if (c->x86 == 0xf) {
+		u32 level;
+
+		level = cpuid_eax(1);
+		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
+			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	}
+	if (c->x86 == 0x10 || c->x86 == 0x11)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
+
+	/*
+	 *	FIXME: We should handle the K5 here. Set up the write
+	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
+	 *	no bus pipeline)
+	 */
+
 	switch (c->x86) {
 	case 4:
 		init_amd_k5(c);
@@ -283,7 +359,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	/* K6s reports MCEs but don't actually have all the MSRs */
 	if (c->x86 < 6)
 		clear_cpu_cap(c, X86_FEATURE_MCE);
+#endif
 
+	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
@@ -300,10 +378,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	display_cacheinfo(c);
 
 	/* Multi core CPU? */
-	if (c->extended_cpuid_level >= 0x80000008)
+	if (c->extended_cpuid_level >= 0x80000008) {
 		amd_detect_cmp(c);
+		srat_detect_node(c);
+	}
 
+#ifdef CONFIG_X86_32
 	detect_ht(c);
+#endif
 
 	if (c->extended_cpuid_level >= 0x80000006) {
 		if ((c->x86 >= 0x0f) && (cpuid_edx(0x80000006) & 0xf000))
@@ -319,8 +401,38 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		/* MFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
+
+#ifdef CONFIG_X86_64
+	if (c->x86 == 0x10) {
+		/* do this for boot cpu */
+		if (c == &boot_cpu_data)
+			check_enable_amd_mmconf_dmi();
+
+		fam10h_check_enable_mmcfg();
+	}
+
+	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {
+		unsigned long long tseg;
+
+		/*
+		 * Split up direct mapping around the TSEG SMM area.
+		 * Don't do it for gbpages because there seems very little
+		 * benefit in doing so.
+		 */
+		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+		    printk(KERN_DEBUG "tseg: %010llx\n", tseg);
+		    if ((tseg>>PMD_SHIFT) <
+				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
+			((tseg>>PMD_SHIFT) <
+				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
+			 (tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
+			set_memory_4k((unsigned long)__va(tseg), 1);
+		}
+	}
+#endif
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* AMD errata T13 (order #21922) */
@@ -333,10 +445,12 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int
 	}
 	return size;
 }
+#endif
 
 static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
+#ifdef CONFIG_X86_32
 	.c_models = {
 		{ .vendor = X86_VENDOR_AMD, .family = 4, .model_names =
 		  {
@@ -349,9 +463,10 @@ static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_size_cache	= amd_size_cache,
+#endif
 	.c_early_init   = early_init_amd,
 	.c_init		= init_amd,
-	.c_size_cache	= amd_size_cache,
 	.c_x86_vendor	= X86_VENDOR_AMD,
 };
 
-- 
1.5.4.5

