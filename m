Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYIFTCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYIFTCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 15:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIFTB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 15:01:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYIFTB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 15:01:56 -0400
Date: Sat, 6 Sep 2008 21:01:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080906190136.GA2932@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

The NOP impact is a bit wider than what i'd like, but it addresses the 
VirtualPC regression and it's what Peter tested - and also Peter's 
solution of turning enhanced NOPs into a virtual CPUID flag that is 
tested before use is kind of elegant IMO and reduces some of the mess 
and risks.

The memory leak fixes are old commits freshly cherry-picked over from 
another branch (i already ran a few test builds and test boots of it) - 
they have a lot of test time already otherwise, i just missed their .27 
impact.

Thanks,

	Ingo

------------------>
Andreas Herrmann (2):
      x86: pda_init(): fix memory leak when using CPU hotplug
      x86: cpu_init(): fix memory leak when using CPU hotplug

Eduardo Habkost (1):
      x86, xen: Use native_pte_flags instead of native_pte_val for .pte_flags

H. Peter Anvin (3):
      x86: boot: stub out unimplemented CPU feature words
      x86: add NOPL as a synthetic CPU feature bit
      x86: use X86_FEATURE_NOPL in alternatives

Krzysztof Helt (1):
      x86: delay early cpu initialization until cpuid is done

Yinghai Lu (1):
      x86: move mtrr cpu cap setting early in early_init_xxxx


 arch/x86/boot/cpucheck.c            |    8 ++--
 arch/x86/kernel/alternative.c       |   36 ++++++-----------
 arch/x86/kernel/cpu/amd.c           |    9 ++--
 arch/x86/kernel/cpu/centaur.c       |   11 +++++
 arch/x86/kernel/cpu/common.c        |   34 +++++++++++++++-
 arch/x86/kernel/cpu/common_64.c     |   74 +++++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/cyrix.c         |   32 +++++++++++++--
 arch/x86/kernel/cpu/feature_names.c |    3 +-
 arch/x86/xen/enlighten.c            |    2 +-
 include/asm-x86/cpufeature.h        |   11 +++--
 include/asm-x86/required-features.h |    8 +++-
 11 files changed, 167 insertions(+), 61 deletions(-)

diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 4b9ae7c..4d3ff03 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -38,12 +38,12 @@ static const u32 req_flags[NCAPINTS] =
 {
 	REQUIRED_MASK0,
 	REQUIRED_MASK1,
-	REQUIRED_MASK2,
-	REQUIRED_MASK3,
+	0, /* REQUIRED_MASK2 not implemented in this file */
+	0, /* REQUIRED_MASK3 not implemented in this file */
 	REQUIRED_MASK4,
-	REQUIRED_MASK5,
+	0, /* REQUIRED_MASK5 not implemented in this file */
 	REQUIRED_MASK6,
-	REQUIRED_MASK7,
+	0, /* REQUIRED_MASK7 not implemented in this file */
 };
 
 #define A32(a, b, c, d) (((d) << 24)+((c) << 16)+((b) << 8)+(a))
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2763cb3..65a0c1b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -145,35 +145,25 @@ static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
 extern char __vsyscall_0;
 const unsigned char *const *find_nop_table(void)
 {
-	return boot_cpu_data.x86_vendor != X86_VENDOR_INTEL ||
-	       boot_cpu_data.x86 < 6 ? k8_nops : p6_nops;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+	    boot_cpu_has(X86_FEATURE_NOPL))
+		return p6_nops;
+	else
+		return k8_nops;
 }
 
 #else /* CONFIG_X86_64 */
 
-static const struct nop {
-	int cpuid;
-	const unsigned char *const *noptable;
-} noptypes[] = {
-	{ X86_FEATURE_K8, k8_nops },
-	{ X86_FEATURE_K7, k7_nops },
-	{ X86_FEATURE_P4, p6_nops },
-	{ X86_FEATURE_P3, p6_nops },
-	{ -1, NULL }
-};
-
 const unsigned char *const *find_nop_table(void)
 {
-	const unsigned char *const *noptable = intel_nops;
-	int i;
-
-	for (i = 0; noptypes[i].cpuid >= 0; i++) {
-		if (boot_cpu_has(noptypes[i].cpuid)) {
-			noptable = noptypes[i].noptable;
-			break;
-		}
-	}
-	return noptable;
+	if (boot_cpu_has(X86_FEATURE_K8))
+		return k8_nops;
+	else if (boot_cpu_has(X86_FEATURE_K7))
+		return k7_nops;
+	else if (boot_cpu_has(X86_FEATURE_NOPL))
+		return p6_nops;
+	else
+		return intel_nops;
 }
 
 #endif /* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index cae9cab..18514ed 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -31,6 +31,11 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 		if (c->x86_power & (1<<8))
 			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	}
+
+	/*  Set MTRR capability flag if appropriate */
+	if (c->x86_model == 13 || c->x86_model == 9 ||
+	   (c->x86_model == 8 && c->x86_mask >= 8))
+		set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
@@ -166,10 +171,6 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 						mbytes);
 				}
 
-				/*  Set MTRR capability flag if appropriate */
-				if (c->x86_model == 13 || c->x86_model == 9 ||
-				   (c->x86_model == 8 && c->x86_mask >= 8))
-					set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 				break;
 			}
 
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index e0f45ed..a0534c0 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -314,6 +314,16 @@ enum {
 		EAMD3D		= 1<<20,
 };
 
+static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 5:
+		/* Emulate MTRRs using Centaur's MCR. */
+		set_cpu_cap(c, X86_FEATURE_CENTAUR_MCR);
+		break;
+	}
+}
+
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
 
@@ -462,6 +472,7 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
+	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
 	.c_size_cache	= centaur_size_cache,
 };
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 80ab20d..8aab851 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -13,6 +13,7 @@
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/pat.h>
+#include <asm/asm.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
@@ -334,11 +335,40 @@ static void __init early_cpu_detect(void)
 
 	get_cpu_vendor(c, 1);
 
+	early_get_cap(c);
+
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
+}
 
-	early_get_cap(c);
+/*
+ * The NOPL instruction is supposed to exist on all CPUs with
+ * family >= 6, unfortunately, that's not true in practice because
+ * of early VIA chips and (more importantly) broken virtualizers that
+ * are not easy to detect.  Hence, probe for it based on first
+ * principles.
+ */
+static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
+{
+	const u32 nopl_signature = 0x888c53b1; /* Random number */
+	u32 has_nopl = nopl_signature;
+
+	clear_cpu_cap(c, X86_FEATURE_NOPL);
+	if (c->x86 >= 6) {
+		asm volatile("\n"
+			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
+			     "2:\n"
+			     "        .section .fixup,\"ax\"\n"
+			     "3:      xor %0,%0\n"
+			     "        jmp 2b\n"
+			     "        .previous\n"
+			     _ASM_EXTABLE(1b,3b)
+			     : "+a" (has_nopl));
+
+		if (has_nopl == nopl_signature)
+			set_cpu_cap(c, X86_FEATURE_NOPL);
+	}
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
@@ -395,8 +425,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		}
 
 		init_scattered_cpuid_features(c);
+		detect_nopl(c);
 	}
-
 }
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index dd6e3f1..a11f5d4 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -18,6 +18,7 @@
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/pat.h>
+#include <asm/asm.h>
 #include <asm/numa.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
@@ -215,6 +216,39 @@ static void __init early_cpu_support_print(void)
 	}
 }
 
+/*
+ * The NOPL instruction is supposed to exist on all CPUs with
+ * family >= 6, unfortunately, that's not true in practice because
+ * of early VIA chips and (more importantly) broken virtualizers that
+ * are not easy to detect.  Hence, probe for it based on first
+ * principles.
+ *
+ * Note: no 64-bit chip is known to lack these, but put the code here
+ * for consistency with 32 bits, and to make it utterly trivial to
+ * diagnose the problem should it ever surface.
+ */
+static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
+{
+	const u32 nopl_signature = 0x888c53b1; /* Random number */
+	u32 has_nopl = nopl_signature;
+
+	clear_cpu_cap(c, X86_FEATURE_NOPL);
+	if (c->x86 >= 6) {
+		asm volatile("\n"
+			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
+			     "2:\n"
+			     "        .section .fixup,\"ax\"\n"
+			     "3:      xor %0,%0\n"
+			     "        jmp 2b\n"
+			     "        .previous\n"
+			     _ASM_EXTABLE(1b,3b)
+			     : "+a" (has_nopl));
+
+		if (has_nopl == nopl_signature)
+			set_cpu_cap(c, X86_FEATURE_NOPL);
+	}
+}
+
 static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
 
 void __init early_cpu_init(void)
@@ -313,6 +347,8 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 		c->x86_phys_bits = eax & 0xff;
 	}
 
+	detect_nopl(c);
+
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
@@ -493,17 +529,20 @@ void pda_init(int cpu)
 		/* others are initialized in smpboot.c */
 		pda->pcurrent = &init_task;
 		pda->irqstackptr = boot_cpu_stack;
+		pda->irqstackptr += IRQSTACKSIZE - 64;
 	} else {
-		pda->irqstackptr = (char *)
-			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-		if (!pda->irqstackptr)
-			panic("cannot allocate irqstack for cpu %d", cpu);
+		if (!pda->irqstackptr) {
+			pda->irqstackptr = (char *)
+				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
+			if (!pda->irqstackptr)
+				panic("cannot allocate irqstack for cpu %d",
+				      cpu);
+			pda->irqstackptr += IRQSTACKSIZE - 64;
+		}
 
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
 	}
-
-	pda->irqstackptr += IRQSTACKSIZE-64;
 }
 
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
@@ -601,19 +640,22 @@ void __cpuinit cpu_init(void)
 	/*
 	 * set up and load the per-CPU TSS
 	 */
-	for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+	if (!orig_ist->ist[0]) {
 		static const unsigned int order[N_EXCEPTION_STACKS] = {
-			[0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-			[DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
+		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
 		};
-		if (cpu) {
-			estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-			if (!estacks)
-				panic("Cannot allocate exception stack %ld %d\n",
-				      v, cpu);
+		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+			if (cpu) {
+				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
+				if (!estacks)
+					panic("Cannot allocate exception "
+					      "stack %ld %d\n", v, cpu);
+			}
+			estacks += PAGE_SIZE << order[v];
+			orig_ist->ist[v] = t->x86_tss.ist[v] =
+					(unsigned long)estacks;
 		}
-		estacks += PAGE_SIZE << order[v];
-		orig_ist->ist[v] = t->x86_tss.ist[v] = (unsigned long)estacks;
 	}
 
 	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index e710a21..898a5a2 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -15,13 +15,11 @@
 /*
  * Read NSC/Cyrix DEVID registers (DIR) to get more detailed info. about the CPU
  */
-static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+static void __cpuinit __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned char ccr2, ccr3;
-	unsigned long flags;
 
 	/* we test for DEVID by checking whether CCR3 is writable */
-	local_irq_save(flags);
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, ccr3 ^ 0x80);
 	getCx86(0xc0);   /* dummy to change bus */
@@ -44,9 +42,16 @@ static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 		*dir0 = getCx86(CX86_DIR0);
 		*dir1 = getCx86(CX86_DIR1);
 	}
-	local_irq_restore(flags);
 }
 
+static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__do_cyrix_devid(dir0, dir1);
+	local_irq_restore(flags);
+}
 /*
  * Cx86_dir0_msb is a HACK needed by check_cx686_cpuid/slop in bugs.h in
  * order to identify the Cyrix CPU model after we're out of setup.c
@@ -161,6 +166,24 @@ static void __cpuinit geode_configure(void)
 	local_irq_restore(flags);
 }
 
+static void __cpuinit early_init_cyrix(struct cpuinfo_x86 *c)
+{
+	unsigned char dir0, dir0_msn, dir1 = 0;
+
+	__do_cyrix_devid(&dir0, &dir1);
+	dir0_msn = dir0 >> 4; /* identifies CPU "family"   */
+
+	switch (dir0_msn) {
+	case 3: /* 6x86/6x86L */
+		/* Emulate MTRRs using Cyrix's ARRs. */
+		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
+		break;
+	case 5: /* 6x86MX/M II */
+		/* Emulate MTRRs using Cyrix's ARRs. */
+		set_cpu_cap(c, X86_FEATURE_CYRIX_ARR);
+		break;
+	}
+}
 
 static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 {
@@ -416,6 +439,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Cyrix",
 	.c_ident	= { "CyrixInstead" },
+	.c_early_init	= early_init_cyrix,
 	.c_init		= init_cyrix,
 	.c_identify	= cyrix_identify,
 };
diff --git a/arch/x86/kernel/cpu/feature_names.c b/arch/x86/kernel/cpu/feature_names.c
index e43ad4a..c901779 100644
--- a/arch/x86/kernel/cpu/feature_names.c
+++ b/arch/x86/kernel/cpu/feature_names.c
@@ -39,7 +39,8 @@ const char * const x86_cap_flags[NCAPINTS*32] = {
 	NULL, NULL, NULL, NULL,
 	"constant_tsc", "up", NULL, "arch_perfmon",
 	"pebs", "bts", NULL, NULL,
-	"rep_good", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+	"rep_good", NULL, NULL, NULL,
+	"nopl", NULL, NULL, NULL,
 	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 	/* Intel-defined (#2) */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 9ff6e3c..a4e201b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1324,7 +1324,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
 	.pte_val = xen_pte_val,
-	.pte_flags = native_pte_val,
+	.pte_flags = native_pte_flags,
 	.pgd_val = xen_pgd_val,
 
 	.make_pte = xen_make_pte,
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 762f6a6..9489283 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -72,14 +72,15 @@
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
 #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
-#define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
-#define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
-#define X86_FEATURE_SYSCALL32	(3*32+14)  /* syscall in ia32 userspace */
-#define X86_FEATURE_SYSENTER32	(3*32+15)  /* sysenter in ia32 userspace */
+#define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
+#define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
+#define X86_FEATURE_SYSCALL32	(3*32+14) /* syscall in ia32 userspace */
+#define X86_FEATURE_SYSENTER32	(3*32+15) /* sysenter in ia32 userspace */
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
-#define X86_FEATURE_11AP	(3*32+19)  /* Bad local APIC aka 11AP */
+#define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
+#define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
diff --git a/include/asm-x86/required-features.h b/include/asm-x86/required-features.h
index adec887..5c2ff4b 100644
--- a/include/asm-x86/required-features.h
+++ b/include/asm-x86/required-features.h
@@ -41,6 +41,12 @@
 # define NEED_3DNOW	0
 #endif
 
+#if defined(CONFIG_X86_P6_NOP) || defined(CONFIG_X86_64)
+# define NEED_NOPL	(1<<(X86_FEATURE_NOPL & 31))
+#else
+# define NEED_NOPL	0
+#endif
+
 #ifdef CONFIG_X86_64
 #define NEED_PSE	0
 #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
@@ -67,7 +73,7 @@
 #define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW)
 
 #define REQUIRED_MASK2	0
-#define REQUIRED_MASK3	0
+#define REQUIRED_MASK3	(NEED_NOPL)
 #define REQUIRED_MASK4	0
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
