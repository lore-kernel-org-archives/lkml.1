Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbXK0Xs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbXK0Xs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbXK0Xr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:47:59 -0500
Received: from zrnetservice.com ([209.133.52.163]:42361 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756087AbXK0Xr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:47:57 -0500
Message-Id: <20071127230130.508648745@goop.org>
References: <20071127230124.271668615@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Nov 2007 15:01:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] x86: clean up bitops-related warnings
Content-Disposition: inline; filename=x86-bitops-warning-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add casts to appropriate places to silence spurious bitops warnings.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/setup_64.c   |   31 ++++++++++++++++---------------
 arch/x86/kernel/smpboot_64.c |    4 ++--
 arch/x86/mm/numa_64.c        |    2 +-
 include/asm-x86/cpufeature.h |    2 +-
 include/asm-x86/numa_64.h    |    2 +-
 include/linux/thread_info.h  |   10 +++++-----
 6 files changed, 26 insertions(+), 25 deletions(-)

===================================================================
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -685,19 +685,19 @@ static void __cpuinit init_amd(struct cp
 
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_bit(0*32+31, &c->x86_capability);
+	clear_bit(0*32+31, (unsigned long *)&c->x86_capability);
 
 	/* On C+ stepping K8 rep microcode works well for copy/memset */
 	level = cpuid_eax(1);
 	if (c->x86 == 15 && ((level >= 0x0f48 && level < 0x0f50) ||
 			     level >= 0x0f58))
-		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
+		set_bit(X86_FEATURE_REP_GOOD, (unsigned long *)&c->x86_capability);
 	if (c->x86 == 0x10 || c->x86 == 0x11)
-		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
+		set_bit(X86_FEATURE_REP_GOOD, (unsigned long *)&c->x86_capability);
 
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
-		set_bit(X86_FEATURE_FXSAVE_LEAK, &c->x86_capability);
+		set_bit(X86_FEATURE_FXSAVE_LEAK, (unsigned long *)&c->x86_capability);
 
 	level = get_model_name(c);
 	if (!level) {
@@ -713,7 +713,7 @@ static void __cpuinit init_amd(struct cp
 
 	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
 	if (c->x86_power & (1<<8))
-		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
+		set_bit(X86_FEATURE_CONSTANT_TSC, (unsigned long *)&c->x86_capability);
 
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008)
@@ -726,14 +726,14 @@ static void __cpuinit init_amd(struct cp
 		num_cache_leaves = 3;
 
 	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x11)
-		set_bit(X86_FEATURE_K8, &c->x86_capability);
+		set_bit(X86_FEATURE_K8, (unsigned long *)&c->x86_capability);
 
 	/* RDTSC can be speculated around */
-	clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
+	clear_bit(X86_FEATURE_SYNC_RDTSC, (unsigned long *)&c->x86_capability);
 
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
-		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
+		clear_bit(X86_FEATURE_MWAIT, (unsigned long *)&c->x86_capability);
 
 	if (c->x86 == 0x10)
 		fam10h_check_enable_mmcfg(c);
@@ -838,16 +838,17 @@ static void __cpuinit init_intel(struct 
 		unsigned eax = cpuid_eax(10);
 		/* Check for version and the number of counters */
 		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
-			set_bit(X86_FEATURE_ARCH_PERFMON, &c->x86_capability);
+			set_bit(X86_FEATURE_ARCH_PERFMON,
+				(unsigned long *)&c->x86_capability);
 	}
 
 	if (cpu_has_ds) {
 		unsigned int l1, l2;
 		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
 		if (!(l1 & (1<<11)))
-			set_bit(X86_FEATURE_BTS, c->x86_capability);
+			set_bit(X86_FEATURE_BTS, (unsigned long *)c->x86_capability);
 		if (!(l1 & (1<<12)))
-			set_bit(X86_FEATURE_PEBS, c->x86_capability);
+			set_bit(X86_FEATURE_PEBS, (unsigned long *)c->x86_capability);
 	}
 
 	n = c->extended_cpuid_level;
@@ -866,13 +867,13 @@ static void __cpuinit init_intel(struct 
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
+		set_bit(X86_FEATURE_CONSTANT_TSC, (unsigned long *)&c->x86_capability);
 	if (c->x86 == 6)
-		set_bit(X86_FEATURE_REP_GOOD, &c->x86_capability);
+		set_bit(X86_FEATURE_REP_GOOD, (unsigned long *)&c->x86_capability);
 	if (c->x86 == 15)
-		set_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
+		set_bit(X86_FEATURE_SYNC_RDTSC, (unsigned long *)&c->x86_capability);
 	else
-		clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
+		clear_bit(X86_FEATURE_SYNC_RDTSC, (unsigned long *)&c->x86_capability);
 	c->x86_max_cores = intel_num_cpu_cores(c);
 
 	srat_detect_node();
===================================================================
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -691,7 +691,7 @@ do_rest:
 	}
 	if (boot_error) {
 		cpu_clear(cpu, cpu_callout_map); /* was set here (do_boot_cpu()) */
-		clear_bit(cpu, &cpu_initialized); /* was set by cpu_init() */
+		clear_bit(cpu, (unsigned long *)&cpu_initialized); /* was set by cpu_init() */
 		clear_node_cpumask(cpu); /* was set by numa_add_cpu */
 		cpu_clear(cpu, cpu_present_map);
 		cpu_clear(cpu, cpu_possible_map);
@@ -1023,7 +1023,7 @@ void remove_cpu_from_maps(void)
 
 	cpu_clear(cpu, cpu_callout_map);
 	cpu_clear(cpu, cpu_callin_map);
-	clear_bit(cpu, &cpu_initialized); /* was set by cpu_init() */
+	clear_bit(cpu, (unsigned long *)&cpu_initialized); /* was set by cpu_init() */
 	clear_node_cpumask(cpu);
 }
 
===================================================================
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -549,7 +549,7 @@ void __init numa_initmem_init(unsigned l
 
 __cpuinit void numa_add_cpu(int cpu)
 {
-	set_bit(cpu, &node_to_cpumask_map[cpu_to_node(cpu)]);
+	set_bit(cpu, (unsigned long *)&node_to_cpumask_map[cpu_to_node(cpu)]);
 }
 
 void __cpuinit numa_set_node(int cpu, int node)
===================================================================
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -124,7 +124,7 @@
 	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
 	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
 	  ? 1 :								\
-	  test_bit(bit, (c)->x86_capability))
+	 test_bit(bit, (unsigned long *)(c)->x86_capability))
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
===================================================================
--- a/include/asm-x86/numa_64.h
+++ b/include/asm-x86/numa_64.h
@@ -32,7 +32,7 @@ extern void __init init_cpu_to_node(void
 
 static inline void clear_node_cpumask(int cpu)
 {
-	clear_bit(cpu, &node_to_cpumask_map[cpu_to_node(cpu)]);
+	clear_bit(cpu, (unsigned long *)&node_to_cpumask_map[cpu_to_node(cpu)]);
 }
 
 #else
===================================================================
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -29,27 +29,27 @@ extern long do_no_restart_syscall(struct
 
 static inline void set_ti_thread_flag(struct thread_info *ti, int flag)
 {
-	set_bit(flag,&ti->flags);
+	set_bit(flag, (unsigned long *)&ti->flags);
 }
 
 static inline void clear_ti_thread_flag(struct thread_info *ti, int flag)
 {
-	clear_bit(flag,&ti->flags);
+	clear_bit(flag, (unsigned long *)&ti->flags);
 }
 
 static inline int test_and_set_ti_thread_flag(struct thread_info *ti, int flag)
 {
-	return test_and_set_bit(flag,&ti->flags);
+	return test_and_set_bit(flag, (unsigned long *)&ti->flags);
 }
 
 static inline int test_and_clear_ti_thread_flag(struct thread_info *ti, int flag)
 {
-	return test_and_clear_bit(flag,&ti->flags);
+	return test_and_clear_bit(flag, (unsigned long *)&ti->flags);
 }
 
 static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 {
-	return test_bit(flag,&ti->flags);
+	return test_bit(flag, (unsigned long *)&ti->flags);
 }
 
 #define set_thread_flag(flag) \

-- 

