Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbYIIXmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbYIIXmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYIIXlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:41:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:15126 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYIIXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e/JvK8aDYAg9N9wjxZDsBaWdPPnAz2Sz3NPitVA0eRQOGU4/Lj8WoOG3B1JriqBYQ7
         GwYVeC7laWeZ/qB2ahaPOxy+rio6mC/18F1eUS3pyd5J/8yoEaAgeFGRjc4qVVGlJq/o
         B+cHkjhJjMh34L5crGGAopeQX6i2sT1/FqcSo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/5] x86: intel.c put workaround for old cpus together
Date: Tue,  9 Sep 2008 16:40:38 -0700
Message-Id: <1221003639-15912-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1221003639-15912-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221003639-15912-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/intel.c |  192 ++++++++++++++++++++++---------------------
 1 files changed, 98 insertions(+), 94 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 365a008..5f76bf1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -63,15 +63,54 @@ int __cpuinit ppro_with_ram_bug(void)
 	return 0;
 }
 
+#ifdef CONFIG_X86_F00F_BUG
+static void __cpuinit trap_init_f00f_bug(void)
+{
+	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
 
-/*
- * P4 Xeon errata 037 workaround.
- * Hardware prefetcher may cause stale data to be loaded into the cache.
- */
-static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
+	/*
+	 * Update the IDT descriptor and reload the IDT so that
+	 * it uses the read-only mapped virtual address.
+	 */
+	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
+	load_idt(&idt_descr);
+}
+#endif
+
+static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
 
+#ifdef CONFIG_X86_F00F_BUG
+	/*
+	 * All current models of Pentium and Pentium with MMX technology CPUs
+	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
+	 * Note that the workaround only should be initialized once...
+	 */
+	c->f00f_bug = 0;
+	if (!paravirt_enabled() && c->x86 == 5) {
+		static int f00f_workaround_enabled;
+
+		c->f00f_bug = 1;
+		if (!f00f_workaround_enabled) {
+			trap_init_f00f_bug();
+			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
+			f00f_workaround_enabled = 1;
+		}
+	}
+#endif
+
+	/*
+	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
+	 * model 3 mask 3
+	 */
+	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
+		clear_cpu_cap(c, X86_FEATURE_SEP);
+
+	/*
+	 * P4 Xeon errata 037 workaround.
+	 * Hardware prefetcher may cause stale data to be loaded into the cache.
+	 */
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
 		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		if ((lo & (1<<9)) == 0) {
@@ -81,23 +120,44 @@ static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
 			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
 		}
 	}
-}
-
 
+	/*
+	 * See if we have a good local APIC by checking for buggy Pentia,
+	 * i.e. all B steppings and the C2 stepping of P54C when using their
+	 * integrated APIC (see 11AP erratum in "Pentium Processor
+	 * Specification Update").
+	 */
+	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
+	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
+		set_cpu_cap(c, X86_FEATURE_11AP);
 
-#ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
-{
-	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
 
+#ifdef CONFIG_X86_INTEL_USERCOPY
 	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
+	 * Set up the preferred alignment for movsl bulk memory moves
 	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
-}
+	switch (c->x86) {
+	case 4:		/* 486: untested */
+		break;
+	case 5:		/* Old Pentia: untested */
+		break;
+	case 6:		/* PII/PIII only like movsl with 8-byte alignment */
+		movsl_mask.mask = 7;
+		break;
+	case 15:	/* P4 is OK down to 8-byte alignment */
+		movsl_mask.mask = 7;
+		break;
+	}
 #endif
+
+#ifdef CONFIG_X86_NUMAQ
+	numaq_tsc_disable();
+#endif
+}
+#else
+static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
+{
+}
 #endif
 
 static void __cpuinit srat_detect_node(void)
@@ -139,28 +199,10 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
-	char *p = NULL;
 
 	early_init_intel(c);
 
-#ifdef CONFIG_X86_F00F_BUG
-	/*
-	 * All current models of Pentium and Pentium with MMX technology CPUs
-	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
-	 * Note that the workaround only should be initialized once...
-	 */
-	c->f00f_bug = 0;
-	if (!paravirt_enabled() && c->x86 == 5) {
-		static int f00f_workaround_enabled;
-
-		c->f00f_bug = 1;
-		if (!f00f_workaround_enabled) {
-			trap_init_f00f_bug();
-			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
-			f00f_workaround_enabled = 1;
-		}
-	}
-#endif
+	intel_workarounds(c);
 
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
@@ -170,17 +212,32 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
-#ifdef CONFIG_X86_32
-	/* SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until model 3 mask 3 */
-	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
-		clear_cpu_cap(c, X86_FEATURE_SEP);
+	if (cpu_has_xmm2)
+		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+	if (cpu_has_ds) {
+		unsigned int l1;
+		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
+		if (!(l1 & (1<<11)))
+			set_cpu_cap(c, X86_FEATURE_BTS);
+		if (!(l1 & (1<<12)))
+			set_cpu_cap(c, X86_FEATURE_PEBS);
+		ds_init_intel(c);
+	}
 
+#ifdef CONFIG_X86_64
+	if (c->x86 == 15)
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+	if (c->x86 == 6)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
 	/*
 	 * Names for the Pentium II/Celeron processors
 	 * detectable only by also checking the cache size.
 	 * Dixon is NOT a Celeron.
 	 */
 	if (c->x86 == 6) {
+		char *p = NULL;
+
 		switch (c->x86_model) {
 		case 5:
 			if (c->x86_mask == 0) {
@@ -203,51 +260,11 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 				p = "Celeron (Coppermine)";
 			break;
 		}
-	}
 
-	if (p)
-		strcpy(c->x86_model_id, p);
-
-	Intel_errata_workarounds(c);
-
-#ifdef CONFIG_X86_INTEL_USERCOPY
-	/*
-	 * Set up the preferred alignment for movsl bulk memory moves
-	 */
-	switch (c->x86) {
-	case 4:		/* 486: untested */
-		break;
-	case 5:		/* Old Pentia: untested */
-		break;
-	case 6:		/* PII/PIII only like movsl with 8-byte alignment */
-		movsl_mask.mask = 7;
-		break;
-	case 15:	/* P4 is OK down to 8-byte alignment */
-		movsl_mask.mask = 7;
-		break;
+		if (p)
+			strcpy(c->x86_model_id, p);
 	}
-#endif
-
-#endif
 
-	if (cpu_has_xmm2)
-		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	if (cpu_has_ds) {
-		unsigned int l1;
-		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
-		if (!(l1 & (1<<11)))
-			set_cpu_cap(c, X86_FEATURE_BTS);
-		if (!(l1 & (1<<12)))
-			set_cpu_cap(c, X86_FEATURE_PEBS);
-		ds_init_intel(c);
-	}
-
-#ifdef CONFIG_X86_64
-	if (c->x86 == 15)
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-	if (c->x86 == 6)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-#else
 	if (c->x86 == 15)
 		set_cpu_cap(c, X86_FEATURE_P4);
 	if (c->x86 == 6)
@@ -256,19 +273,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has_bts)
 		ptrace_bts_init_intel(c);
 
-	/*
-	 * See if we have a good local APIC by checking for buggy Pentia,
-	 * i.e. all B steppings and the C2 stepping of P54C when using their
-	 * integrated APIC (see 11AP erratum in "Pentium Processor
-	 * Specification Update").
-	 */
-	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
-	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
-		set_cpu_cap(c, X86_FEATURE_11AP);
-
-#ifdef CONFIG_X86_NUMAQ
-	numaq_tsc_disable();
-#endif
 #endif
 
 	detect_extended_topology(c);
-- 
1.5.4.5

