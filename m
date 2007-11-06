Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbXKFXAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbXKFXAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXKFW7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:59:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37388 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbXKFW7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:59:42 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: arch/x86/Kconfig.cpu unification
Date: Wed,  7 Nov 2007 00:01:14 +0100
Message-Id: <11943900793757-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11943900792519-git-send-email-sam@ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org> <11943900792519-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move all CPU definitions to Kconfig.cpu
Always define X86_MINIMUM_CPU_FAMILY and do the
obvious code cleanup in boot/cpucheck.c

Comments from: Adrian Bunk <bunk@kernel.org> incorporated.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>
---
 arch/x86/Kconfig         |   19 +++++++
 arch/x86/Kconfig.cpu     |  121 ++++++++++++++++++++++++++++-----------------
 arch/x86/Kconfig.x86_64  |   83 +-------------------------------
 arch/x86/boot/cpucheck.c |    6 --
 4 files changed, 95 insertions(+), 134 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d1382c5..e741fc7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,3 +1,22 @@
+# x86 configuration
+
+### Arch settings
+config RWSEM_GENERIC_SPINLOCK
+	def_bool !X86_XADD
+
+config RWSEM_XCHGADD_ALGORITHM
+	def_bool X86_XADD
+
+config ARCH_HAS_ILOG2_U32
+	def_bool n
+
+config ARCH_HAS_ILOG2_U64
+	def_bool n
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+
 menu "Power management options"
 	depends on !X86_VOYAGER
 
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 0e2adad..c301622 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -3,11 +3,12 @@ if !X86_ELAN
 
 choice
 	prompt "Processor family"
-	default M686
+	default M686 if X86_32
+	default GENERIC_CPU if X86_64
 
 config M386
 	bool "386"
-	depends on !UML
+	depends on X86_32 && !UML
 	---help---
 	  This is the processor type of your CPU. This information is used for
 	  optimizing purposes. In order to compile a kernel that can run on
@@ -49,6 +50,7 @@ config M386
 
 config M486
 	bool "486"
+	depends on X86_32
 	help
 	  Select this for a 486 series processor, either Intel or one of the
 	  compatible processors from AMD, Cyrix, IBM, or Intel.  Includes DX,
@@ -57,6 +59,7 @@ config M486
 
 config M586
 	bool "586/K5/5x86/6x86/6x86MX"
+	depends on X86_32
 	help
 	  Select this for an 586 or 686 series processor such as the AMD K5,
 	  the Cyrix 5x86, 6x86 and 6x86MX.  This choice does not
@@ -64,18 +67,21 @@ config M586
 
 config M586TSC
 	bool "Pentium-Classic"
+	depends on X86_32
 	help
 	  Select this for a Pentium Classic processor with the RDTSC (Read
 	  Time Stamp Counter) instruction for benchmarking.
 
 config M586MMX
 	bool "Pentium-MMX"
+	depends on X86_32
 	help
 	  Select this for a Pentium with the MMX graphics/multimedia
 	  extended instructions.
 
 config M686
 	bool "Pentium-Pro"
+	depends on X86_32
 	help
 	  Select this for Intel Pentium Pro chips.  This enables the use of
 	  Pentium Pro extended instructions, and disables the init-time guard
@@ -83,6 +89,7 @@ config M686
 
 config MPENTIUMII
 	bool "Pentium-II/Celeron(pre-Coppermine)"
+	depends on X86_32
 	help
 	  Select this for Intel chips based on the Pentium-II and
 	  pre-Coppermine Celeron core.  This option enables an unaligned
@@ -92,6 +99,7 @@ config MPENTIUMII
 
 config MPENTIUMIII
 	bool "Pentium-III/Celeron(Coppermine)/Pentium-III Xeon"
+	depends on X86_32
 	help
 	  Select this for Intel chips based on the Pentium-III and
 	  Celeron-Coppermine core.  This option enables use of some
@@ -100,19 +108,14 @@ config MPENTIUMIII
 
 config MPENTIUMM
 	bool "Pentium M"
+	depends on X86_32
 	help
 	  Select this for Intel Pentium M (not Pentium-4 M)
 	  notebook chips.
 
-config MCORE2
-	bool "Core 2/newer Xeon"
-	help
-	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
-	  CPUs. You can distinguish newer from older Xeons by the CPU family
-	  in /proc/cpuinfo. Newer ones have 6 and older ones 15 (not a typo)
-
 config MPENTIUM4
 	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
+	depends on X86_32
 	help
 	  Select this for Intel Pentium 4 chips.  This includes the
 	  Pentium 4, Pentium D, P4-based Celeron and Xeon, and
@@ -148,6 +151,7 @@ config MPENTIUM4
 
 config MK6
 	bool "K6/K6-II/K6-III"
+	depends on X86_32
 	help
 	  Select this for an AMD K6-family processor.  Enables use of
 	  some extended instructions, and passes appropriate optimization
@@ -155,6 +159,7 @@ config MK6
 
 config MK7
 	bool "Athlon/Duron/K7"
+	depends on X86_32
 	help
 	  Select this for an AMD Athlon K7-family processor.  Enables use of
 	  some extended instructions, and passes appropriate optimization
@@ -169,6 +174,7 @@ config MK8
 
 config MCRUSOE
 	bool "Crusoe"
+	depends on X86_32
 	help
 	  Select this for a Transmeta Crusoe processor.  Treats the processor
 	  like a 586 with TSC, and sets some GCC optimization flags (like a
@@ -176,11 +182,13 @@ config MCRUSOE
 
 config MEFFICEON
 	bool "Efficeon"
+	depends on X86_32
 	help
 	  Select this for a Transmeta Efficeon processor.
 
 config MWINCHIPC6
 	bool "Winchip-C6"
+	depends on X86_32
 	help
 	  Select this for an IDT Winchip C6 chip.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
@@ -188,6 +196,7 @@ config MWINCHIPC6
 
 config MWINCHIP2
 	bool "Winchip-2"
+	depends on X86_32
 	help
 	  Select this for an IDT Winchip-2.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
@@ -195,6 +204,7 @@ config MWINCHIP2
 
 config MWINCHIP3D
 	bool "Winchip-2A/Winchip-3"
+	depends on X86_32
 	help
 	  Select this for an IDT Winchip-2A or 3.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
@@ -204,16 +214,19 @@ config MWINCHIP3D
 
 config MGEODEGX1
 	bool "GeodeGX1"
+	depends on X86_32
 	help
 	  Select this for a Geode GX1 (Cyrix MediaGX) chip.
 
 config MGEODE_LX
        bool "Geode GX/LX"
+	depends on X86_32
        help
          Select this for AMD Geode GX and LX processors.
 
 config MCYRIXIII
 	bool "CyrixIII/VIA-C3"
+	depends on X86_32
 	help
 	  Select this for a Cyrix III or C3 chip.  Presently Linux and GCC
 	  treat this chip as a generic 586. Whilst the CPU is 686 class,
@@ -225,6 +238,7 @@ config MCYRIXIII
 
 config MVIAC3_2
 	bool "VIA C3-2 (Nehemiah)"
+	depends on X86_32
 	help
 	  Select this for a VIA C3 "Nehemiah". Selecting this enables usage
 	  of SSE and tells gcc to treat the CPU as a 686.
@@ -232,15 +246,42 @@ config MVIAC3_2
 
 config MVIAC7
 	bool "VIA C7"
+	depends on X86_32
 	help
 	  Select this for a VIA C7.  Selecting this uses the correct cache
 	  shift and tells gcc to treat the CPU as a 686.
 
+config MPSC
+	bool "Intel P4 / older Netburst based Xeon"
+	depends on X86_64
+	help
+	  Optimize for Intel Pentium 4, Pentium D and older Nocona/Dempsey
+	  Xeon CPUs with Intel 64bit which is compatible with x86-64.
+	  Note that the latest Xeons (Xeon 51xx and 53xx) are not based on the
+          Netburst core and shouldn't use this option. You can distinguish them
+	  using the cpu family field
+	  in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one.
+
+config MCORE2
+	bool "Core 2/newer Xeon"
+	help
+	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
+	  CPUs. You can distinguish newer from older Xeons by the CPU family
+	  in /proc/cpuinfo. Newer ones have 6 and older ones 15 (not a typo)
+
+config GENERIC_CPU
+	bool "Generic-x86-64"
+	depends on X86_64
+	help
+	  Generic x86-64 CPU.
+	  Run equally well on all x86-64 CPUs.
+
 endchoice
 
 config X86_GENERIC
-       bool "Generic x86 support"
-       help
+	bool "Generic x86 support"
+	depends on X86_32
+	help
 	  Instead of just including optimizations for the selected
 	  x86 variant (e.g. PII, Crusoe or Athlon), include some more
 	  generic optimizations as well. This will make the kernel
@@ -253,44 +294,31 @@ endif
 
 #
 # Define implied options from the CPU selection here
-#
+config X86_L1_CACHE_BYTES
+	int
+	default "128" if GENERIC_CPU || MPSC
+	default "64" if MK8 || MCORE2
+	depends on X86_64
+
+config X86_INTERNODE_CACHE_BYTES
+	int
+	default "4096" if X86_VSMP
+	default X86_L1_CACHE_BYTES if !X86_VSMP
+	depends on X86_64
+
 config X86_CMPXCHG
-	bool
-	depends on !M386
-	default y
+	def_bool X86_64 || (X86_32 && !M386)
 
 config X86_L1_CACHE_SHIFT
 	int
-	default "7" if MPENTIUM4 || X86_GENERIC
+	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
 
 config X86_XADD
 	bool
-	depends on !M386
-	default y
-
-config RWSEM_GENERIC_SPINLOCK
-	bool
-	depends on !X86_XADD
-	default y
-
-config RWSEM_XCHGADD_ALGORITHM
-	bool
-	depends on X86_XADD
-	default y
-
-config ARCH_HAS_ILOG2_U32
-	bool
-	default n
-
-config ARCH_HAS_ILOG2_U64
-	bool
-	default n
-
-config GENERIC_CALIBRATE_DELAY
-	bool
+	depends on X86_32 && !M386
 	default y
 
 config X86_PPRO_FENCE
@@ -305,22 +333,22 @@ config X86_F00F_BUG
 
 config X86_WP_WORKS_OK
 	bool
-	depends on !M386
+	depends on X86_32 && !M386
 	default y
 
 config X86_INVLPG
 	bool
-	depends on !M386
+	depends on X86_32 && !M386
 	default y
 
 config X86_BSWAP
 	bool
-	depends on !M386
+	depends on X86_32 && !M386
 	default y
 
 config X86_POPAD_OK
 	bool
-	depends on !M386
+	depends on X86_32 && !M386
 	default y
 
 config X86_ALIGNMENT_16
@@ -330,7 +358,7 @@ config X86_ALIGNMENT_16
 
 config X86_GOOD_APIC
 	bool
-	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7
+	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7 || X86_64
 	default y
 
 config X86_INTEL_USERCOPY
@@ -355,7 +383,7 @@ config X86_OOSTORE
 
 config X86_TSC
 	bool
-	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
+	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
 	default y
 
 # this should be set for all -march=.. options where the compiler
@@ -367,6 +395,7 @@ config X86_CMOV
 
 config X86_MINIMUM_CPU_FAMILY
 	int
-	default "4" if X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK
+	default "64" if X86_64
+	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
 	default "3"
 
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index 264623c..cdd1458 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -78,25 +78,10 @@ config ISA
 config SBUS
 	bool
 
-config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
-
-config RWSEM_XCHGADD_ALGORITHM
-	bool
-
 config GENERIC_HWEIGHT
 	bool
 	default y
 
-config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
-
-config X86_CMPXCHG
-	bool
-	default y
-
 config GENERIC_ISA_DMA
 	bool
 	default y
@@ -125,13 +110,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config ARCH_HAS_ILOG2_U32
-	bool
-	default n
-
-config ARCH_HAS_ILOG2_U64
-	bool
-	default n
 
 source "init/Kconfig"
 
@@ -159,66 +137,7 @@ config X86_VSMP
 
 endchoice
 
-choice
-	prompt "Processor family"
-	default GENERIC_CPU
-
-config MK8
-	bool "AMD-Opteron/Athlon64"
-	help
-	  Optimize for AMD Opteron/Athlon64/Hammer/K8 CPUs.
-
-config MPSC
-       bool "Intel P4 / older Netburst based Xeon"
-       help
-	  Optimize for Intel Pentium 4, Pentium D and older Nocona/Dempsey
-	  Xeon CPUs with Intel 64bit which is compatible with x86-64.
-	  Note that the latest Xeons (Xeon 51xx and 53xx) are not based on the
-          Netburst core and shouldn't use this option. You can distinguish them
-	  using the cpu family field
-	  in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one.
-
-config MCORE2
-	bool "Intel Core2 / newer Xeon"
-	help
-	  Optimize for Intel Core2 and newer Xeons (51xx)
-	  You can distinguish the newer Xeons from the older ones using
-	  the cpu family field in /proc/cpuinfo. 15 is an older Xeon
-	  (use CONFIG_MPSC then), 6 is a newer one.
-
-config GENERIC_CPU
-	bool "Generic-x86-64"
-	help
-	  Generic x86-64 CPU.
-	  Run equally well on all x86-64 CPUs.
-
-endchoice
-
-#
-# Define implied options from the CPU selection here
-#
-config X86_L1_CACHE_BYTES
-	int
-	default "128" if GENERIC_CPU || MPSC
-	default "64" if MK8 || MCORE2
-
-config X86_L1_CACHE_SHIFT
-	int
-	default "7" if GENERIC_CPU || MPSC
-	default "6" if MK8 || MCORE2
-
-config X86_INTERNODE_CACHE_BYTES
-	int
-	default "4096" if X86_VSMP
-	default X86_L1_CACHE_BYTES if !X86_VSMP
-
-config X86_TSC
-	bool
-	default y
-
-config X86_GOOD_APIC
-	bool
-	default y
+source "arch/x86/Kconfig.cpu"
 
 config MICROCODE
 	tristate "/dev/cpu/microcode - Intel CPU microcode support"
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index e655a89..769065b 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -42,13 +42,7 @@ static struct cpu_features cpu;
 static u32 cpu_vendor[3];
 static u32 err_flags[NCAPINTS];
 
-#ifdef CONFIG_X86_64
-static const int req_level = 64;
-#elif defined(CONFIG_X86_MINIMUM_CPU_FAMILY)
 static const int req_level = CONFIG_X86_MINIMUM_CPU_FAMILY;
-#else
-static const int req_level = 3;
-#endif
 
 static const u32 req_flags[NCAPINTS] =
 {
-- 
1.5.3.4.1157.g0e74-dirty

