Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbXE3A41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbXE3A41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXE3A4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:56:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:45212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbXE3A4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,590,1170662400"; 
   d="scan'208";a="248612097"
Date: Tue, 29 May 2007 17:52:58 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070530005257.GA445@linux-os.sc.intel.com>
References: <653FFBB4508B9042B5D43DC9E18836F5EE12ED@scsmsx415.amr.corp.intel.com> <465627FD.9040301@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465627FD.9040301@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 05:04:13PM -0700, H. Peter Anvin wrote:
> 
> If they grow slowly from the bottom, I guess we could simply allocate
> space in the vector byte by byte instead.  Either way, it means more
> work whenever anything has to change.
> 

hpa,

Below patch adds a new word for feature bits that willb eused for all Intel
features that may be spread around in CPUID leafs like 0x6, 0xA, etc.
I added "ida" bit first into this word. I will send an incremental patch
to move ARCH_PERFMON bit and any other feature bits in these leaf subsequently.
The patch is against newsetup git tree.

Please apply.

Thanks,
Venki



Use a new CPU feature word to cover all Intel features that are spread around
in different CPUID leafs like 0x5, 0x6 and 0xA. Make this
feature detection code common across i386 and x86_64.

Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
will be enabled automatically by current acpi-cpufreq driver.

Refer to Intel Software Developer's Manual for more details about the feature.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6/include/asm-i386/cpufeature.h
===================================================================
--- linux-2.6.orig/include/asm-i386/cpufeature.h	2007-05-29 07:30:28.000000000 -0700
+++ linux-2.6/include/asm-i386/cpufeature.h	2007-05-29 10:21:17.000000000 -0700
@@ -12,7 +12,7 @@
 #endif
 #include <asm/required-features.h>
 
-#define NCAPINTS	7	/* N 32-bit words worth of info */
+#define NCAPINTS	8	/* N 32-bit words worth of info */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
 #define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
@@ -109,6 +109,9 @@
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
 
+/* More extended Intel flags: From various new CPUID levels like 0x6, 0xA etc */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
+
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) &&					\
 	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
@@ -117,7 +120,8 @@
 	   (((bit)>>5)==3 && (1UL<<((bit)&31) & REQUIRED_MASK3)) ||	\
 	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
 	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
-	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) )	\
+	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
+	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
 	  ? 1 :								\
 	  test_bit(bit, (c)->x86_capability))
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
Index: linux-2.6/arch/i386/kernel/cpu/proc.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/cpu/proc.c	2007-05-29 07:30:20.000000000 -0700
+++ linux-2.6/arch/i386/kernel/cpu/proc.c	2007-05-29 08:20:51.000000000 -0700
@@ -65,6 +65,12 @@
 		"osvw", "ibs", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+
+		/* Intel-defined (#3) */
+		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
 	static const char * const x86_power_flags[] = {
 		"ts",	/* temperature sensor */
Index: linux-2.6/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/setup.c	2007-05-29 07:30:21.000000000 -0700
+++ linux-2.6/arch/x86_64/kernel/setup.c	2007-05-29 09:20:01.000000000 -0700
@@ -699,6 +699,7 @@
 	/* Cache sizes */
 	unsigned n;
 
+	init_additional_intel_features(c);
 	init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9 ) {
 		unsigned eax = cpuid_eax(10);
@@ -973,6 +974,12 @@
 		"osvw", "ibs", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+
+		/* Intel-defined (#3) */
+		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
 	static char *x86_power_flags[] = { 
 		"ts",	/* temperature sensor */
Index: linux-2.6/include/asm-i386/required-features.h
===================================================================
--- linux-2.6.orig/include/asm-i386/required-features.h	2007-05-29 07:30:28.000000000 -0700
+++ linux-2.6/include/asm-i386/required-features.h	2007-05-29 08:11:13.000000000 -0700
@@ -56,5 +56,6 @@
 #define REQUIRED_MASK4	0
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
+#define REQUIRED_MASK7	0
 
 #endif
Index: linux-2.6/include/asm-x86_64/required-features.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/required-features.h	2007-05-29 07:30:29.000000000 -0700
+++ linux-2.6/include/asm-x86_64/required-features.h	2007-05-29 08:12:30.000000000 -0700
@@ -42,5 +42,6 @@
 #define REQUIRED_MASK4	0
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
+#define REQUIRED_MASK7	0
 
 #endif
Index: linux-2.6/arch/i386/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/cpu/intel.c	2007-05-29 09:14:31.000000000 -0700
+++ linux-2.6/arch/i386/kernel/cpu/intel.c	2007-05-29 09:15:52.000000000 -0700
@@ -120,6 +120,7 @@
 #endif
 
 	select_idle_routine(c);
+	init_additional_intel_features(c);
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9 ) {
 		unsigned eax = cpuid_eax(10);
Index: linux-2.6/arch/i386/kernel/cpu/intel_features.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/i386/kernel/cpu/intel_features.c	2007-05-29 10:38:25.000000000 -0700
@@ -0,0 +1,22 @@
+
+/*
+ *	Routines to indentify additional Intel cpu features
+ *	Features in word 7
+ */
+
+#include <linux/cpu.h>
+
+#include <asm/processor.h>
+
+#define CPUID_6_EAX_IDA		0x2
+
+void __cpuinit init_additional_intel_features(struct cpuinfo_x86 *c)
+{
+	unsigned int eax;
+
+	if (c->cpuid_level >= 6) {
+		eax = cpuid_eax(6);
+		if (eax & CPUID_6_EAX_IDA)
+			set_bit(X86_FEATURE_IDA, c->x86_capability);
+	}
+}
Index: linux-2.6/arch/i386/kernel/cpu/Makefile
===================================================================
--- linux-2.6.orig/arch/i386/kernel/cpu/Makefile	2007-05-29 07:30:20.000000000 -0700
+++ linux-2.6/arch/i386/kernel/cpu/Makefile	2007-05-29 10:01:03.000000000 -0700
@@ -8,7 +8,7 @@
 obj-y	+=	cyrix.o
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
-obj-y	+=	intel.o intel_cacheinfo.o
+obj-y	+=	intel.o intel_cacheinfo.o intel_features.o
 obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
Index: linux-2.6/arch/x86_64/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/Makefile	2007-05-29 07:30:21.000000000 -0700
+++ linux-2.6/arch/x86_64/kernel/Makefile	2007-05-29 10:01:41.000000000 -0700
@@ -44,6 +44,7 @@
 
 obj-y				+= topology.o
 obj-y				+= intel_cacheinfo.o
+obj-y				+= intel_features.o
 obj-y				+= pcspeaker.o
 
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
@@ -55,6 +56,7 @@
 topology-y                     += ../../i386/kernel/topology.o
 microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
 intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
+intel_features-y		+= ../../i386/kernel/cpu/intel_features.o
 quirks-y			+= ../../i386/kernel/quirks.o
 i8237-y				+= ../../i386/kernel/i8237.o
 msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
Index: linux-2.6/include/asm-i386/processor.h
===================================================================
--- linux-2.6.orig/include/asm-i386/processor.h	2007-05-29 07:30:28.000000000 -0700
+++ linux-2.6/include/asm-i386/processor.h	2007-05-29 10:13:41.000000000 -0700
@@ -119,6 +119,7 @@
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
+extern void init_additional_intel_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
Index: linux-2.6/include/asm-x86_64/processor.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/processor.h	2007-05-29 07:30:29.000000000 -0700
+++ linux-2.6/include/asm-x86_64/processor.h	2007-05-29 10:14:11.000000000 -0700
@@ -100,6 +100,7 @@
 
 extern void identify_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
+extern void init_additional_intel_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
