Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbXGKTWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbXGKTWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765007AbXGKTTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:25 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38261 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764108AbXGKTTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:22 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 07/33] Use a new CPU feature word to cover all Intel features that are spread around
Date: Wed, 11 Jul 2007 12:18:32 -0700
Message-Id: <118418153972-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184181539416-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
Message-Id: <b7ce2cdc4470b799c0ca96459898a24d1d04e8f5.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

in different CPUID leafs like 0x5, 0x6 and 0xA. Make this
feature detection code common across i386 and x86_64.

Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
will be enabled automatically by current acpi-cpufreq driver.

Refer to Intel Software Developer's Manual for more details about the feature.

Thanks to hpa (H Peter Anvin) for the making the actual code detecting the
scattered features data-driven.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/kernel/cpu/Makefile               |    2 +-
 arch/i386/kernel/cpu/addon_cpuid_features.c |   50 +++++++++++++++++++++++++++
 arch/i386/kernel/cpu/common.c               |    2 +
 arch/i386/kernel/cpu/proc.c                 |    6 +++
 arch/x86_64/kernel/Makefile                 |    2 +
 arch/x86_64/kernel/setup.c                  |    8 ++++
 include/asm-i386/cpufeature.h               |   11 +++++-
 include/asm-i386/processor.h                |    1 +
 include/asm-i386/required-features.h        |    1 +
 include/asm-x86_64/processor.h              |    1 +
 include/asm-x86_64/required-features.h      |    1 +
 11 files changed, 82 insertions(+), 3 deletions(-)
 create mode 100644 arch/i386/kernel/cpu/addon_cpuid_features.c

diff --git a/arch/i386/kernel/cpu/Makefile b/arch/i386/kernel/cpu/Makefile
index 74f27a4..0b6a855 100644
--- a/arch/i386/kernel/cpu/Makefile
+++ b/arch/i386/kernel/cpu/Makefile
@@ -8,7 +8,7 @@ obj-y	+=	amd.o
 obj-y	+=	cyrix.o
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
-obj-y	+=	intel.o intel_cacheinfo.o
+obj-y	+=	intel.o intel_cacheinfo.o addon_cpuid_features.o
 obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
diff --git a/arch/i386/kernel/cpu/addon_cpuid_features.c b/arch/i386/kernel/cpu/addon_cpuid_features.c
new file mode 100644
index 0000000..3e91d3e
--- /dev/null
+++ b/arch/i386/kernel/cpu/addon_cpuid_features.c
@@ -0,0 +1,50 @@
+
+/*
+ *	Routines to indentify additional cpu features that are scattered in
+ *	cpuid space.
+ */
+
+#include <linux/cpu.h>
+
+#include <asm/processor.h>
+
+struct cpuid_bit {
+	u16 feature;
+	u8 reg;
+	u8 bit;
+	u32 level;
+};
+
+enum cpuid_regs {
+	CR_EAX = 0,
+	CR_ECX,
+	CR_EDX,
+	CR_EBX
+};
+
+void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
+{
+	u32 max_level;
+	u32 regs[4];
+	const struct cpuid_bit *cb;
+
+	static const struct cpuid_bit cpuid_bits[] = {
+		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
+		{ 0, 0, 0, 0 }
+	};
+
+	for (cb = cpuid_bits; cb->feature; cb++) {
+
+		/* Verify that the level is valid */
+		max_level = cpuid_eax(cb->level & 0xffff0000);
+		if (max_level < cb->level ||
+		    max_level > (cb->level | 0xffff))
+			continue;
+
+		cpuid(cb->level, &regs[CR_EAX], &regs[CR_EBX],
+			&regs[CR_ECX], &regs[CR_EDX]);
+
+		if (regs[cb->reg] & (1 << cb->bit))
+			set_bit(cb->feature, c->x86_capability);
+	}
+}
diff --git a/arch/i386/kernel/cpu/common.c b/arch/i386/kernel/cpu/common.c
index 794d593..e5419a9 100644
--- a/arch/i386/kernel/cpu/common.c
+++ b/arch/i386/kernel/cpu/common.c
@@ -353,6 +353,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
 			if ( xlvl >= 0x80000004 )
 				get_model_name(c); /* Default name */
 		}
+
+		init_scattered_cpuid_features(c);
 	}
 
 	early_intel_workaround(c);
diff --git a/arch/i386/kernel/cpu/proc.c b/arch/i386/kernel/cpu/proc.c
index ed73091..1e31b6c 100644
--- a/arch/i386/kernel/cpu/proc.c
+++ b/arch/i386/kernel/cpu/proc.c
@@ -65,6 +65,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		"osvw", "ibs", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+
+		/* Auxiliary (Linux-defined) */
+		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
 	static const char * const x86_power_flags[] = {
 		"ts",	/* temperature sensor */
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index de1de8a..47f1dc3 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 
 obj-y				+= topology.o
 obj-y				+= intel_cacheinfo.o
+obj-y				+= addon_cpuid_features.o
 obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
@@ -55,6 +56,7 @@ cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  += ../../i386/kernel/cpuid.o
 topology-y                     += ../../i386/kernel/topology.o
 microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
 intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
+addon_cpuid_features-y		+= ../../i386/kernel/cpu/addon_cpuid_features.o
 quirks-y			+= ../../i386/kernel/quirks.o
 i8237-y				+= ../../i386/kernel/i8237.o
 msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index dc7630d..33ef718 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -846,6 +846,8 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 			c->x86_capability[2] = cpuid_edx(0x80860001);
 	}
 
+	init_scattered_cpuid_features(c);
+
 	c->apicid = phys_pkg_id(0);
 
 	/*
@@ -973,6 +975,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		"osvw", "ibs", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+
+		/* Auxiliary (Linux-defined) */
+		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
 	static char *x86_power_flags[] = { 
 		"ts",	/* temperature sensor */
diff --git a/include/asm-i386/cpufeature.h b/include/asm-i386/cpufeature.h
index 7ea5f4a..c961c03 100644
--- a/include/asm-i386/cpufeature.h
+++ b/include/asm-i386/cpufeature.h
@@ -12,7 +12,7 @@
 #endif
 #include <asm/required-features.h>
 
-#define NCAPINTS	7	/* N 32-bit words worth of info */
+#define NCAPINTS	8	/* N 32-bit words worth of info */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
 #define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
@@ -109,6 +109,12 @@
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
 
+/*
+ * Auxiliary flags: Linux defined - For features scattered in various
+ * CPUID levels like 0x6, 0xA etc
+ */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
+
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) &&					\
 	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
@@ -117,7 +123,8 @@
 	   (((bit)>>5)==3 && (1UL<<((bit)&31) & REQUIRED_MASK3)) ||	\
 	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
 	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
-	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) )	\
+	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
+	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
 	  ? 1 :								\
 	  test_bit(bit, (c)->x86_capability))
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
diff --git a/include/asm-i386/processor.h b/include/asm-i386/processor.h
index 338668b..94e0c14 100644
--- a/include/asm-i386/processor.h
+++ b/include/asm-i386/processor.h
@@ -119,6 +119,7 @@ void __init cpu_detect(struct cpuinfo_x86 *c);
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
+extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
diff --git a/include/asm-i386/required-features.h b/include/asm-i386/required-features.h
index a9c3b11..65848a0 100644
--- a/include/asm-i386/required-features.h
+++ b/include/asm-i386/required-features.h
@@ -50,5 +50,6 @@
 #define REQUIRED_MASK4	0
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
+#define REQUIRED_MASK7	0
 
 #endif
diff --git a/include/asm-x86_64/processor.h b/include/asm-x86_64/processor.h
index df64572..efc87a5 100644
--- a/include/asm-x86_64/processor.h
+++ b/include/asm-x86_64/processor.h
@@ -100,6 +100,7 @@ extern char ignore_irq13;
 
 extern void identify_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
+extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
diff --git a/include/asm-x86_64/required-features.h b/include/asm-x86_64/required-features.h
index 262f315..e80d576 100644
--- a/include/asm-x86_64/required-features.h
+++ b/include/asm-x86_64/required-features.h
@@ -41,5 +41,6 @@
 #define REQUIRED_MASK4	0
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
+#define REQUIRED_MASK7	0
 
 #endif
-- 
1.5.2.2

