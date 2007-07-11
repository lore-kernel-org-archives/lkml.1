Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbXGKTVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbXGKTVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763985AbXGKTTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761560AbXGKTTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:12 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 04/33] Unify the CPU features vectors between i386 and x86-64
Date: Wed, 11 Jul 2007 12:18:29 -0700
Message-Id: <11841815393975-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815392122-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
Message-Id: <c74269f00504931e6a653be3b4f0684ca8753561.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Unify the handling of the CPU features vectors between i386 and x86-64.
This also adopts the collapsing of features which are required at
compile-time into constant tests from x86-64 to i386.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/kernel/cpu/proc.c            |   15 +++--
 arch/i386/kernel/verify_cpu.S          |   12 ++--
 arch/x86_64/kernel/setup.c             |   13 ++--
 arch/x86_64/kernel/verify_cpu.S        |   22 +-----
 include/asm-i386/cpufeature.h          |   17 +++--
 include/asm-i386/required-features.h   |   38 ++++++++---
 include/asm-x86_64/alternative.h       |   68 ++++++++++---------
 include/asm-x86_64/cpufeature.h        |  115 +++----------------------------
 include/asm-x86_64/processor.h         |    2 -
 include/asm-x86_64/required-features.h |   45 ++++++++++++
 10 files changed, 159 insertions(+), 188 deletions(-)
 create mode 100644 include/asm-x86_64/required-features.h

diff --git a/arch/i386/kernel/cpu/proc.c b/arch/i386/kernel/cpu/proc.c
index 89d91e6..ed73091 100644
--- a/arch/i386/kernel/cpu/proc.c
+++ b/arch/i386/kernel/cpu/proc.c
@@ -29,7 +29,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, "syscall", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, "mp", "nx", NULL, "mmxext", NULL,
-		NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm", "3dnowext", "3dnow",
+		NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm",
+		"3dnowext", "3dnow",
 
 		/* Transmeta-defined */
 		"recovery", "longrun", NULL, "lrti", NULL, NULL, NULL, NULL,
@@ -40,8 +41,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		/* Other (Linux-defined) */
 		"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
 		NULL, NULL, NULL, NULL,
-		"constant_tsc", "up", NULL, NULL, NULL, NULL, NULL, NULL,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"constant_tsc", "up", NULL, "arch_perfmon",
+		"pebs", "bts", NULL, "sync_rdtsc",
+		"rep_good", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* Intel-defined (#2) */
@@ -57,9 +59,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* AMD-defined (#2) */
-		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8legacy", "abm",
-		"sse4a", "misalignsse",
-		"3dnowprefetch", "osvw", "ibs", NULL, NULL, NULL, NULL, NULL,
+		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8_legacy",
+		"altmovcr8", "abm", "sse4a",
+		"misalignsse", "3dnowprefetch",
+		"osvw", "ibs", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
diff --git a/arch/i386/kernel/verify_cpu.S b/arch/i386/kernel/verify_cpu.S
index f1d1eac..3efc5c1 100644
--- a/arch/i386/kernel/verify_cpu.S
+++ b/arch/i386/kernel/verify_cpu.S
@@ -20,7 +20,7 @@ verify_cpu:
 	testl	$(1<<18),%eax
 	jz	bad
 #endif
-#if REQUIRED_MASK1 != 0
+#if REQUIRED_MASK0 != 0
 	pushfl				# standard way to check for cpuid
 	popl	%eax
 	movl	%eax,%ebx
@@ -39,14 +39,14 @@ verify_cpu:
 	pushfl
 	popl	%eax
 	cmpl	%eax,%ebx
-	jz	bad			# REQUIRED_MASK1 != 0 requires CPUID
+	jz	bad			# REQUIRED_MASK0 != 0 requires CPUID
 
 	movl	$0x0,%eax		# See if cpuid 1 is implemented
 	cpuid
 	cmpl	$0x1,%eax
 	jb	bad			# no cpuid 1
 
-#if REQUIRED_MASK1 & NEED_CMPXCHG64
+#if REQUIRED_MASK0 & NEED_CMPXCHG64
 	/* Some VIA C3s need magic MSRs to enable CX64. Do this here */
 	cmpl	$0x746e6543,%ebx	# Cent
 	jne	1f
@@ -79,10 +79,10 @@ verify_cpu:
 #error	add proper model checking here
 #endif
 
-	andl	$REQUIRED_MASK1,%edx
-	xorl	$REQUIRED_MASK1,%edx
+	andl	$REQUIRED_MASK0,%edx
+	xorl	$REQUIRED_MASK0,%edx
 	jnz	bad
-#endif /* REQUIRED_MASK1 */
+#endif /* REQUIRED_MASK0 */
 
 	popfl
 	xor	%eax,%eax
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index eb6524f..dc7630d 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -931,7 +931,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	        "fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
 	        "cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
 	        "pat", "pse36", "pn", "clflush", NULL, "dts", "acpi", "mmx",
-	        "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", NULL,
+	        "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", "pbe",
 
 		/* AMD-defined */
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
@@ -947,10 +947,11 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* Other (Linux-defined) */
-		"cxmmx", NULL, "cyrix_arr", "centaur_mcr", NULL,
-		"constant_tsc", NULL, NULL,
-		"up", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
+		NULL, NULL, NULL, NULL,
+		"constant_tsc", "up", NULL, "arch_perfmon",
+		"pebs", "bts", NULL, "sync_rdtsc",
+		"rep_good", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* Intel-defined (#2) */
@@ -961,7 +962,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 		/* VIA/Cyrix/Centaur-defined */
 		NULL, NULL, "rng", "rng_en", NULL, NULL, "ace", "ace_en",
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"ace2", "ace2_en", "phe", "phe_en", "pmm", "pmm_en", NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
diff --git a/arch/x86_64/kernel/verify_cpu.S b/arch/x86_64/kernel/verify_cpu.S
index e035f59..45b6f8a 100644
--- a/arch/x86_64/kernel/verify_cpu.S
+++ b/arch/x86_64/kernel/verify_cpu.S
@@ -37,20 +37,6 @@ verify_cpu:
 	pushl	$0			# Kill any dangerous flags
 	popfl
 
-	/* minimum CPUID flags for x86-64 as defined by AMD */
-#define M(x) (1<<(x))
-#define M2(a,b) M(a)|M(b)
-#define M4(a,b,c,d) M(a)|M(b)|M(c)|M(d)
-
-#define SSE_MASK \
-	(M2(X86_FEATURE_XMM,X86_FEATURE_XMM2))
-#define REQUIRED_MASK1 \
-	(M4(X86_FEATURE_FPU,X86_FEATURE_PSE,X86_FEATURE_TSC,X86_FEATURE_MSR)|\
-	 M4(X86_FEATURE_PAE,X86_FEATURE_CX8,X86_FEATURE_PGE,X86_FEATURE_CMOV)|\
-	 M(X86_FEATURE_FXSR))
-#define REQUIRED_MASK2 \
-	(M(X86_FEATURE_LM - 32))
-
 	pushfl				# standard way to check for cpuid
 	popl	%eax
 	movl	%eax,%ebx
@@ -79,8 +65,8 @@ verify_cpu:
 verify_cpu_noamd:
 	movl    $0x1,%eax		# Does the cpu have what it takes
 	cpuid
-	andl	$REQUIRED_MASK1,%edx
-	xorl	$REQUIRED_MASK1,%edx
+	andl	$REQUIRED_MASK0,%edx
+	xorl	$REQUIRED_MASK0,%edx
 	jnz	verify_cpu_no_longmode
 
 	movl    $0x80000000,%eax	# See if extended cpuid is implemented
@@ -90,8 +76,8 @@ verify_cpu_noamd:
 
 	movl    $0x80000001,%eax	# Does the cpu have what it takes
 	cpuid
-	andl    $REQUIRED_MASK2,%edx
-	xorl    $REQUIRED_MASK2,%edx
+	andl    $REQUIRED_MASK1,%edx
+	xorl    $REQUIRED_MASK1,%edx
 	jnz     verify_cpu_no_longmode
 
 verify_cpu_sse_test:
diff --git a/include/asm-i386/cpufeature.h b/include/asm-i386/cpufeature.h
index f514e90..7ea5f4a 100644
--- a/include/asm-i386/cpufeature.h
+++ b/include/asm-i386/cpufeature.h
@@ -81,6 +81,7 @@
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
 #define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
+#define X86_FEATURE_REP_GOOD   (3*32+16) /* rep microcode works well on this CPU */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
@@ -108,11 +109,17 @@
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
 
-#define cpu_has(c, bit)					\
-	((__builtin_constant_p(bit) && (bit) < 32 && 	\
-		(1UL << (bit)) & REQUIRED_MASK1) ?	\
-		1 : 					\
-	test_bit(bit, (c)->x86_capability))
+#define cpu_has(c, bit)							\
+	(__builtin_constant_p(bit) &&					\
+	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
+	   (((bit)>>5)==1 && (1UL<<((bit)&31) & REQUIRED_MASK1)) ||	\
+	   (((bit)>>5)==2 && (1UL<<((bit)&31) & REQUIRED_MASK2)) ||	\
+	   (((bit)>>5)==3 && (1UL<<((bit)&31) & REQUIRED_MASK3)) ||	\
+	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
+	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
+	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) )	\
+	  ? 1 :								\
+	  test_bit(bit, (c)->x86_capability))
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
diff --git a/include/asm-i386/required-features.h b/include/asm-i386/required-features.h
index 9db866c..a9c3b11 100644
--- a/include/asm-i386/required-features.h
+++ b/include/asm-i386/required-features.h
@@ -3,32 +3,52 @@
 
 /* Define minimum CPUID feature set for kernel These bits are checked
    really early to actually display a visible error message before the
-   kernel dies.  Only add word 0 bits here
+   kernel dies.  Make sure to assign features to the proper mask!
 
    Some requirements that are not in CPUID yet are also in the
-   CONFIG_X86_MINIMUM_CPU mode which is checked too.
+   CONFIG_X86_MINIMUM_CPU_FAMILY which is checked too.
 
    The real information is in arch/i386/Kconfig.cpu, this just converts
    the CONFIGs into a bitmask */
 
+#ifndef CONFIG_MATH_EMULATION
+# define NEED_FPU	(1<<(X86_FEATURE_FPU & 31))
+#else
+# define NEED_FPU	0
+#endif
+
 #ifdef CONFIG_X86_PAE
-#define NEED_PAE	(1<<X86_FEATURE_PAE)
+# define NEED_PAE	(1<<(X86_FEATURE_PAE & 31))
 #else
-#define NEED_PAE	0
+# define NEED_PAE	0
 #endif
 
 #ifdef CONFIG_X86_CMOV
-#define NEED_CMOV	(1<<X86_FEATURE_CMOV)
+# define NEED_CMOV	(1<<(X86_FEATURE_CMOV & 31))
 #else
-#define NEED_CMOV	0
+# define NEED_CMOV	0
 #endif
 
 #ifdef CONFIG_X86_CMPXCHG64
-#define NEED_CMPXCHG64  (1<<X86_FEATURE_CX8)
+# define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
+#else
+# define NEED_CX8	0
+#endif
+
+#define REQUIRED_MASK0	(NEED_FPU|NEED_PAE|NEED_CMOV|NEED_CX8)
+
+#ifdef CONFIG_X86_USE_3DNOW
+# define NEED_3DNOW	(1<<(X86_FEATURE_3DNOW & 31))
 #else
-#define NEED_CMPXCHG64  0
+# define NEED_3DNOW	0
 #endif
 
-#define REQUIRED_MASK1	(NEED_PAE|NEED_CMOV|NEED_CMPXCHG64)
+#define REQUIRED_MASK1	(NEED_3DNOW)
+
+#define REQUIRED_MASK2	0
+#define REQUIRED_MASK3	0
+#define REQUIRED_MASK4	0
+#define REQUIRED_MASK5	0
+#define REQUIRED_MASK6	0
 
 #endif
diff --git a/include/asm-x86_64/alternative.h b/include/asm-x86_64/alternative.h
index a094276..eea7aec 100644
--- a/include/asm-x86_64/alternative.h
+++ b/include/asm-x86_64/alternative.h
@@ -5,6 +5,41 @@
 
 #include <linux/types.h>
 #include <linux/stddef.h>
+
+/*
+ * Alternative inline assembly for SMP.
+ *
+ * The LOCK_PREFIX macro defined here replaces the LOCK and
+ * LOCK_PREFIX macros used everywhere in the source tree.
+ *
+ * SMP alternatives use the same data structures as the other
+ * alternatives and the X86_FEATURE_UP flag to indicate the case of a
+ * UP system running a SMP kernel.  The existing apply_alternatives()
+ * works fine for patching a SMP kernel for UP.
+ *
+ * The SMP alternative tables can be kept after boot and contain both
+ * UP and SMP versions of the instructions to allow switching back to
+ * SMP at runtime, when hotplugging in a new CPU, which is especially
+ * useful in virtualized environments.
+ *
+ * The very common lock prefix is handled as special case in a
+ * separate table which is a pure address list without replacement ptr
+ * and size information.  That keeps the table sizes small.
+ */
+
+#ifdef CONFIG_SMP
+#define LOCK_PREFIX \
+		".section .smp_locks,\"a\"\n"	\
+		"  .align 8\n"			\
+		"  .quad 661f\n" /* address */	\
+		".previous\n"			\
+	       	"661:\n\tlock; "
+
+#else /* ! CONFIG_SMP */
+#define LOCK_PREFIX ""
+#endif
+
+/* This must be included *after* the definition of LOCK_PREFIX */
 #include <asm/cpufeature.h>
 
 struct alt_instr {
@@ -108,39 +143,6 @@ static inline void alternatives_smp_switch(int smp) {}
  */
 #define ASM_OUTPUT2(a, b) a, b
 
-/*
- * Alternative inline assembly for SMP.
- *
- * The LOCK_PREFIX macro defined here replaces the LOCK and
- * LOCK_PREFIX macros used everywhere in the source tree.
- *
- * SMP alternatives use the same data structures as the other
- * alternatives and the X86_FEATURE_UP flag to indicate the case of a
- * UP system running a SMP kernel.  The existing apply_alternatives()
- * works fine for patching a SMP kernel for UP.
- *
- * The SMP alternative tables can be kept after boot and contain both
- * UP and SMP versions of the instructions to allow switching back to
- * SMP at runtime, when hotplugging in a new CPU, which is especially
- * useful in virtualized environments.
- *
- * The very common lock prefix is handled as special case in a
- * separate table which is a pure address list without replacement ptr
- * and size information.  That keeps the table sizes small.
- */
-
-#ifdef CONFIG_SMP
-#define LOCK_PREFIX \
-		".section .smp_locks,\"a\"\n"	\
-		"  .align 8\n"			\
-		"  .quad 661f\n" /* address */	\
-		".previous\n"			\
-	       	"661:\n\tlock; "
-
-#else /* ! CONFIG_SMP */
-#define LOCK_PREFIX ""
-#endif
-
 struct paravirt_patch;
 #ifdef CONFIG_PARAVIRT
 void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
diff --git a/include/asm-x86_64/cpufeature.h b/include/asm-x86_64/cpufeature.h
index 0b3c686..8baefc3 100644
--- a/include/asm-x86_64/cpufeature.h
+++ b/include/asm-x86_64/cpufeature.h
@@ -7,115 +7,24 @@
 #ifndef __ASM_X8664_CPUFEATURE_H
 #define __ASM_X8664_CPUFEATURE_H
 
-#define NCAPINTS	7	/* N 32-bit words worth of info */
+#include <asm-i386/cpufeature.h>
 
-/* Intel-defined CPU features, CPUID level 0x00000001, word 0 */
-#define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
-#define X86_FEATURE_VME		(0*32+ 1) /* Virtual Mode Extensions */
-#define X86_FEATURE_DE		(0*32+ 2) /* Debugging Extensions */
-#define X86_FEATURE_PSE 	(0*32+ 3) /* Page Size Extensions */
-#define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
-#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers, RDMSR, WRMSR */
-#define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
-#define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
-#define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
-#define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
-#define X86_FEATURE_MTRR	(0*32+12) /* Memory Type Range Registers */
-#define X86_FEATURE_PGE		(0*32+13) /* Page Global Enable */
-#define X86_FEATURE_MCA		(0*32+14) /* Machine Check Architecture */
-#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instruction (FCMOVCC and FCOMI too if FPU present) */
-#define X86_FEATURE_PAT		(0*32+16) /* Page Attribute Table */
-#define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
-#define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
-#define X86_FEATURE_CLFLSH	(0*32+19) /* Supports the CLFLUSH instruction */
-#define X86_FEATURE_DS		(0*32+21) /* Debug Store */
-#define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
-#define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
-#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE and FXRSTOR instructions (fast save and restore */
-				          /* of FPU context), and CR4.OSFXSR available */
-#define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
-#define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
-#define X86_FEATURE_SELFSNOOP	(0*32+27) /* CPU self snoop */
-#define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
-#define X86_FEATURE_ACC		(0*32+29) /* Automatic clock control */
-#define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
-
-/* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
-/* Don't duplicate feature flags which are redundant with Intel! */
-#define X86_FEATURE_SYSCALL	(1*32+11) /* SYSCALL/SYSRET */
-#define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-#define X86_FEATURE_FXSR_OPT	(1*32+25) /* FXSR optimizations */
-#define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
-#define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
-#define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
-#define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
-
-/* Transmeta-defined CPU features, CPUID level 0x80860001, word 2 */
-#define X86_FEATURE_RECOVERY	(2*32+ 0) /* CPU in recovery mode */
-#define X86_FEATURE_LONGRUN	(2*32+ 1) /* Longrun power control */
-#define X86_FEATURE_LRTI	(2*32+ 3) /* LongRun table interface */
-
-/* Other features, Linux-defined mapping, word 3 */
-/* This range is used for feature bits which conflict or are synthesized */
-#define X86_FEATURE_CXMMX	(3*32+ 0) /* Cyrix MMX extensions */
-#define X86_FEATURE_K6_MTRR	(3*32+ 1) /* AMD K6 nonstandard MTRRs */
-#define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (= MTRRs) */
-#define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (= MTRRs) */
-#define X86_FEATURE_REP_GOOD	(3*32+ 4) /* rep microcode works well on this CPU */
-#define X86_FEATURE_CONSTANT_TSC (3*32+5) /* TSC runs at constant rate */
-#define X86_FEATURE_SYNC_RDTSC  (3*32+6)  /* RDTSC syncs CPU core */
-#define X86_FEATURE_FXSAVE_LEAK (3*32+7)  /* FIP/FOP/FDP leaks through FXSAVE */
-#define X86_FEATURE_UP		(3*32+8) /* SMP kernel running on UP */
-#define X86_FEATURE_ARCH_PERFMON (3*32+9) /* Intel Architectural PerfMon */
-#define X86_FEATURE_PEBS	(3*32+10) /* Precise-Event Based Sampling */
-#define X86_FEATURE_BTS		(3*32+11) /* Branch Trace Store */
-
-/* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
-#define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
-#define X86_FEATURE_MWAIT	(4*32+ 3) /* Monitor/Mwait support */
-#define X86_FEATURE_DSCPL	(4*32+ 4) /* CPL Qualified Debug Store */
-#define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
-#define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
-#define X86_FEATURE_CID		(4*32+10) /* Context ID */
-#define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
-#define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
-
-/* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
-#define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
-#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* on-CPU RNG enabled */
-#define X86_FEATURE_XCRYPT	(5*32+ 6) /* on-CPU crypto (xcrypt insn) */
-#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* on-CPU crypto enabled */
-
-/* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
-#define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
-#define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
-
-#define cpu_has(c, bit)                test_bit(bit, (c)->x86_capability)
-#define boot_cpu_has(bit)      test_bit(bit, boot_cpu_data.x86_capability)
-
-#define cpu_has_fpu            1
+#undef  cpu_has_vme
 #define cpu_has_vme            0
-#define cpu_has_de             1
-#define cpu_has_pse            1
-#define cpu_has_tsc            1
+
+#undef  cpu_has_pae
 #define cpu_has_pae            ___BUG___
-#define cpu_has_pge            1
-#define cpu_has_apic           boot_cpu_has(X86_FEATURE_APIC)
-#define cpu_has_mtrr           1
-#define cpu_has_mmx            1
-#define cpu_has_fxsr           1
-#define cpu_has_xmm            1
-#define cpu_has_xmm2           1
-#define cpu_has_xmm3           boot_cpu_has(X86_FEATURE_XMM3)
-#define cpu_has_ht             boot_cpu_has(X86_FEATURE_HT)
+
+#undef  cpu_has_mp
 #define cpu_has_mp             1 /* XXX */
+
+#undef  cpu_has_k6_mtrr
 #define cpu_has_k6_mtrr        0
+
+#undef  cpu_has_cyrix_arr
 #define cpu_has_cyrix_arr      0
+
+#undef  cpu_has_centaur_mcr
 #define cpu_has_centaur_mcr    0
-#define cpu_has_clflush	       boot_cpu_has(X86_FEATURE_CLFLSH)
-#define cpu_has_ds 	       boot_cpu_has(X86_FEATURE_DS)
-#define cpu_has_pebs 	       boot_cpu_has(X86_FEATURE_PEBS)
-#define cpu_has_bts 	       boot_cpu_has(X86_FEATURE_BTS)
 
 #endif /* __ASM_X8664_CPUFEATURE_H */
diff --git a/include/asm-x86_64/processor.h b/include/asm-x86_64/processor.h
index 461ffe4..df64572 100644
--- a/include/asm-x86_64/processor.h
+++ b/include/asm-x86_64/processor.h
@@ -368,8 +368,6 @@ static inline void sync_core(void)
 	asm volatile("cpuid" : "=a" (tmp) : "0" (1) : "ebx","ecx","edx","memory");
 } 
 
-#define cpu_has_fpu 1
-
 #define ARCH_HAS_PREFETCH
 static inline void prefetch(void *x) 
 { 
diff --git a/include/asm-x86_64/required-features.h b/include/asm-x86_64/required-features.h
new file mode 100644
index 0000000..262f315
--- /dev/null
+++ b/include/asm-x86_64/required-features.h
@@ -0,0 +1,45 @@
+#ifndef _ASM_REQUIRED_FEATURES_H
+#define _ASM_REQUIRED_FEATURES_H 1
+
+/* Define minimum CPUID feature set for kernel These bits are checked
+   really early to actually display a visible error message before the
+   kernel dies.  Make sure to assign features to the proper mask!
+
+   The real information is in arch/x86_64/Kconfig.cpu, this just converts
+   the CONFIGs into a bitmask */
+
+/* x86-64 baseline features */
+#define NEED_FPU	(1<<(X86_FEATURE_FPU & 31))
+#define NEED_PSE	(1<<(X86_FEATURE_PSE & 31))
+#define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
+#define NEED_PAE	(1<<(X86_FEATURE_PAE & 31))
+#define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
+#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
+#define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
+#define NEED_CMOV	(1<<(X86_FEATURE_CMOV & 31))
+#define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
+#define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
+
+#define REQUIRED_MASK0	(NEED_FPU|NEED_PSE|NEED_MSR|NEED_PAE|\
+			 NEED_CX8|NEED_PGE|NEED_FXSR|NEED_CMOV|\
+			 NEED_XMM|NEED_XMM2)
+#define SSE_MASK	(NEED_XMM|NEED_XMM2)
+
+/* x86-64 baseline features */
+#define NEED_LM		(1<<(X86_FEATURE_LM & 31))
+
+#ifdef CONFIG_X86_USE_3DNOW
+# define NEED_3DNOW	(1<<(X86_FEATURE_3DNOW & 31))
+#else
+# define NEED_3DNOW	0
+#endif
+
+#define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW)
+
+#define REQUIRED_MASK2	0
+#define REQUIRED_MASK3	0
+#define REQUIRED_MASK4	0
+#define REQUIRED_MASK5	0
+#define REQUIRED_MASK6	0
+
+#endif
-- 
1.5.2.2

