Return-Path: <linux-kernel-owner+w=401wt.eu-S1760412AbXK0XsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbXK0XsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbXK0Xr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:47:58 -0500
Received: from zrnetservice.com ([209.133.52.163]:42360 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754505AbXK0Xr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:47:56 -0500
X-Greylist: delayed 2681 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2007 18:47:56 EST
Message-Id: <20071127230130.584844311@goop.org>
References: <20071127230124.271668615@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Nov 2007 15:01:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] x86: add set/clear_cpu_cap operations
Content-Disposition: inline; filename=x86-set-clear-cpu_caps.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch to suppress bitops-related warnings added a pile of ugly
casts.  Many of these were related to the management of x86 CPU
capabilities.  Clean these up by adding specific set/clear_cpu_cap
macros, and use them consistently.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/alternative.c              |   13 ++++++------
 arch/x86/kernel/apic_32.c                  |    8 +++----
 arch/x86/kernel/apic_64.c                  |    2 -
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 -
 arch/x86/kernel/cpu/mcheck/mce_64.c        |    2 -
 arch/x86/kernel/setup_32.c                 |    2 -
 arch/x86/kernel/setup_64.c                 |   29 +++++++++++++---------------
 arch/x86/kernel/vmi_32.c                   |   10 ++++-----
 include/asm-x86/cpufeature.h               |    5 +++-
 9 files changed, 38 insertions(+), 35 deletions(-)

===================================================================
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -356,15 +356,15 @@ void alternatives_smp_switch(int smp)
 	spin_lock_irqsave(&smp_alt, flags);
 	if (smp) {
 		printk(KERN_INFO "SMP alternatives: switching to SMP code\n");
-		clear_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
-		clear_bit(X86_FEATURE_UP, cpu_data(0).x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
+		clear_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
 		list_for_each_entry(mod, &smp_alt_modules, next)
 			alternatives_smp_lock(mod->locks, mod->locks_end,
 					      mod->text, mod->text_end);
 	} else {
 		printk(KERN_INFO "SMP alternatives: switching to UP code\n");
-		set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
-		set_bit(X86_FEATURE_UP, cpu_data(0).x86_capability);
+		set_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
+		set_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
 		list_for_each_entry(mod, &smp_alt_modules, next)
 			alternatives_smp_unlock(mod->locks, mod->locks_end,
 						mod->text, mod->text_end);
@@ -431,8 +431,9 @@ void __init alternative_instructions(voi
 	if (smp_alt_once) {
 		if (1 == num_possible_cpus()) {
 			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
-			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
-			set_bit(X86_FEATURE_UP, cpu_data(0).x86_capability);
+			set_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
+			set_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
+
 			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
 						_text, _etext);
 		}
===================================================================
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1078,7 +1078,7 @@ static int __init detect_init_APIC (void
 		printk(KERN_WARNING "Could not enable APIC!\n");
 		return -1;
 	}
-	set_bit(X86_FEATURE_APIC, boot_cpu_data.x86_capability);
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
 
 	/* The BIOS may have set up the APIC at some other address */
@@ -1168,7 +1168,7 @@ int __init APIC_init_uniprocessor (void)
 int __init APIC_init_uniprocessor (void)
 {
 	if (enable_local_apic < 0)
-		clear_bit(X86_FEATURE_APIC, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 
 	if (!smp_found_config && !cpu_has_apic)
 		return -1;
@@ -1180,7 +1180,7 @@ int __init APIC_init_uniprocessor (void)
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
 		       boot_cpu_physical_apicid);
-		clear_bit(X86_FEATURE_APIC, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
 
@@ -1536,7 +1536,7 @@ static int __init parse_nolapic(char *ar
 static int __init parse_nolapic(char *arg)
 {
 	enable_local_apic = -1;
-	clear_bit(X86_FEATURE_APIC, boot_cpu_data.x86_capability);
+	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 	return 0;
 }
 early_param("nolapic", parse_nolapic);
===================================================================
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1193,7 +1193,7 @@ static __init int setup_disableapic(char
 static __init int setup_disableapic(char *str)
 {
 	disable_apic = 1;
-	clear_bit(X86_FEATURE_APIC, boot_cpu_data.x86_capability);
+	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 	return 0;
 }
 early_param("disableapic", setup_disableapic);
===================================================================
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -45,6 +45,6 @@ void __cpuinit init_scattered_cpuid_feat
 			&regs[CR_ECX], &regs[CR_EDX]);
 
 		if (regs[cb->reg] & (1 << cb->bit))
-			set_bit(cb->feature, c->x86_capability);
+			set_cpu_cap(c, cb->feature);
 	}
 }
===================================================================
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -80,7 +80,7 @@ void mce_log(struct mce *mce)
 			/* When the buffer fills up discard new entries. Assume
 			   that the earlier errors are the more interesting. */
 			if (entry >= MCE_LOG_LEN) {
-				set_bit(MCE_OVERFLOW, &mcelog.flags);
+				set_bit(MCE_OVERFLOW, (unsigned long *)&mcelog.flags);
 				return;
 			}
 			/* Old left over entry. Skip. */
===================================================================
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -238,7 +238,7 @@ static int __init parse_mem(char *arg)
 		return -EINVAL;
 
 	if (strcmp(arg, "nopentium") == 0) {
-		clear_bit(X86_FEATURE_PSE, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_PSE);
 		disable_pse = 1;
 	} else {
 		/* If the user specifies memory size, we
===================================================================
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -691,13 +691,13 @@ static void __cpuinit init_amd(struct cp
 	level = cpuid_eax(1);
 	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) ||
 			     level >= 0x0f58))
-		set_bit(X86_FEATURE_REP_GOOD, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	if (c->x86 == 0x10 || c->x86 == 0x11)
-		set_bit(X86_FEATURE_REP_GOOD, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
-		set_bit(X86_FEATURE_FXSAVE_LEAK, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
 	level = get_model_name(c);
 	if (!level) {
@@ -713,7 +713,7 @@ static void __cpuinit init_amd(struct cp
 
 	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
 	if (c->x86_power & (1<<8))
-		set_bit(X86_FEATURE_CONSTANT_TSC, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008)
@@ -726,14 +726,14 @@ static void __cpuinit init_amd(struct cp
 		num_cache_leaves = 3;
 
 	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x11)
-		set_bit(X86_FEATURE_K8, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_K8);
 
 	/* RDTSC can be speculated around */
-	clear_bit(X86_FEATURE_SYNC_RDTSC, (unsigned long *)&c->x86_capability);
+	clear_cpu_cap(c, X86_FEATURE_SYNC_RDTSC);
 
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
-		clear_bit(X86_FEATURE_MWAIT, (unsigned long *)&c->x86_capability);
+		clear_cpu_cap(c, X86_FEATURE_MWAIT);
 
 	if (c->x86 == 0x10)
 		fam10h_check_enable_mmcfg(c);
@@ -838,17 +838,16 @@ static void __cpuinit init_intel(struct 
 		unsigned eax = cpuid_eax(10);
 		/* Check for version and the number of counters */
 		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
-			set_bit(X86_FEATURE_ARCH_PERFMON,
-				(unsigned long *)&c->x86_capability);
+			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
 	if (cpu_has_ds) {
 		unsigned int l1, l2;
 		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
 		if (!(l1 & (1<<11)))
-			set_bit(X86_FEATURE_BTS, (unsigned long *)c->x86_capability);
+			set_cpu_cap(c, X86_FEATURE_BTS);
 		if (!(l1 & (1<<12)))
-			set_bit(X86_FEATURE_PEBS, (unsigned long *)c->x86_capability);
+			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
 	n = c->extended_cpuid_level;
@@ -867,13 +866,13 @@ static void __cpuinit init_intel(struct 
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_bit(X86_FEATURE_CONSTANT_TSC, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	if (c->x86 == 6)
-		set_bit(X86_FEATURE_REP_GOOD, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	if (c->x86 == 15)
-		set_bit(X86_FEATURE_SYNC_RDTSC, (unsigned long *)&c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_SYNC_RDTSC);
 	else
-		clear_bit(X86_FEATURE_SYNC_RDTSC, (unsigned long *)&c->x86_capability);
+		clear_cpu_cap(c, X86_FEATURE_SYNC_RDTSC);
 	c->x86_max_cores = intel_num_cpu_cores(c);
 
 	srat_detect_node();
===================================================================
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -963,19 +963,19 @@ static int __init parse_vmi(char *arg)
 		return -EINVAL;
 
 	if (!strcmp(arg, "disable_pge")) {
-		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_PGE);
 		disable_pge = 1;
 	} else if (!strcmp(arg, "disable_pse")) {
-		clear_bit(X86_FEATURE_PSE, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_PSE);
 		disable_pse = 1;
 	} else if (!strcmp(arg, "disable_sep")) {
-		clear_bit(X86_FEATURE_SEP, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
 		disable_sep = 1;
 	} else if (!strcmp(arg, "disable_tsc")) {
-		clear_bit(X86_FEATURE_TSC, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC);
 		disable_tsc = 1;
 	} else if (!strcmp(arg, "disable_mtrr")) {
-		clear_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_MTRR);
 		disable_mtrr = 1;
 	} else if (!strcmp(arg, "disable_timer")) {
 		disable_vmi_timer = 1;
===================================================================
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -124,8 +124,11 @@
 	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
 	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
 	  ? 1 :								\
-	 test_bit(bit, (unsigned long *)(c)->x86_capability))
+	 test_bit(bit, (unsigned long *)((c)->x86_capability)))
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
+
+#define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
+#define clear_cpu_cap(c, bit)	clear_bit(bit, (unsigned long *)((c)->x86_capability))
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
 #define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)

-- 

