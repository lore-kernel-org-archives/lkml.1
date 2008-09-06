Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYIFCWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYIFCWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 22:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYIFCWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 22:22:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYIFCWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 22:22:38 -0400
Date: Fri, 5 Sep 2008 19:22:31 -0700
Message-Id: <200809060222.m862MVtP024813@askone.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] x86 fixes (NOPL issue)
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus-2

H. Peter Anvin (4):
      x86: boot: stub out unimplemented CPU feature words
      x86: add NOPL as a synthetic CPU feature bit
      x86: use X86_FEATURE_NOPL in alternatives
      Merge branch 'x86/urgent' into x86-fixes-for-linus-2

This fixes the NOPL issue by detecting it explicitly.  I don't have
access to Virtual PC, but this works on Virtual Server 2005 R2 which
has the same issue.  These changes have been in -tip since August 18,
so they have had some reasonable degree of exposure already.

 arch/x86/boot/cpucheck.c            |    8 +++---
 arch/x86/kernel/alternative.c       |   36 ++++++++++++----------------------
 arch/x86/kernel/cpu/common.c        |   32 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/common_64.c     |   36 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/feature_names.c |    3 +-
 include/asm-x86/cpufeature.h        |   11 +++++----
 include/asm-x86/required-features.h |    8 ++++++-
 7 files changed, 99 insertions(+), 35 deletions(-)

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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 80ab20d..0785b3c 100644
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
@@ -341,6 +342,35 @@ static void __init early_cpu_detect(void)
 	early_get_cap(c);
 }
 
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
+}
+
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
@@ -395,8 +425,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		}
 
 		init_scattered_cpuid_features(c);
+		detect_nopl(c);
 	}
-
 }
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index dd6e3f1..c3afba5 100644
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
