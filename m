Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXKFXAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXKFXAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXKFW7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:59:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53806 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbXKFW7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:59:42 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: unification of cfufreq/Kconfig
Date: Wed,  7 Nov 2007 00:01:12 +0100
Message-Id: <11943900793940-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Merge the two Kconfig files to a single file.

Checked using make allmodconfig for x86_64.
No changes in build.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig.i386                              |    2 +-
 arch/x86/Kconfig.x86_64                            |    2 +-
 .../x86/kernel/cpu/cpufreq/{Kconfig_32 => Kconfig} |   69 +++++++++----
 arch/x86/kernel/cpu/cpufreq/Kconfig_64             |  108 --------------------
 4 files changed, 49 insertions(+), 132 deletions(-)
 rename arch/x86/kernel/cpu/cpufreq/{Kconfig_32 => Kconfig} (77%)
 delete mode 100644 arch/x86/kernel/cpu/cpufreq/Kconfig_64

diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index 7331efe..b6f2fd0 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -1092,7 +1092,7 @@ config APM_REAL_MODE_POWER_OFF
 
 endif # APM
 
-source "arch/x86/kernel/cpu/cpufreq/Kconfig_32"
+source "arch/x86/kernel/cpu/cpufreq/Kconfig"
 
 source "drivers/cpuidle/Kconfig"
 
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index cc468ea..8d6b534 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -719,7 +719,7 @@ config ARCH_HIBERNATION_HEADER
 
 source "drivers/acpi/Kconfig"
 
-source "arch/x86/kernel/cpu/cpufreq/Kconfig_64"
+source "arch/x86/kernel/cpu/cpufreq/Kconfig"
 
 source "drivers/cpuidle/Kconfig"
 
diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig_32 b/arch/x86/kernel/cpu/cpufreq/Kconfig
similarity index 77%
rename from arch/x86/kernel/cpu/cpufreq/Kconfig_32
rename to arch/x86/kernel/cpu/cpufreq/Kconfig
index d8c6f13..48c4465 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig_32
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -19,6 +19,9 @@ config X86_ACPI_CPUFREQ
 	  Processor Performance States.
 	  This driver also supports Intel Enhanced Speedstep.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called acpi-cpufreq.
+
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
 	  If in doubt, say N.
@@ -26,7 +29,7 @@ config X86_ACPI_CPUFREQ
 config ELAN_CPUFREQ
 	tristate "AMD Elan SC400 and SC410"
 	select CPU_FREQ_TABLE
-	depends on X86_ELAN
+	depends on X86_32 && X86_ELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC400 and SC410
 	  processors.
@@ -42,7 +45,7 @@ config ELAN_CPUFREQ
 config SC520_CPUFREQ
 	tristate "AMD Elan SC520"
 	select CPU_FREQ_TABLE
-	depends on X86_ELAN
+	depends on X86_32 && X86_ELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC520 processor.
 
@@ -54,6 +57,7 @@ config SC520_CPUFREQ
 config X86_POWERNOW_K6
 	tristate "AMD Mobile K6-2/K6-3 PowerNow!"
 	select CPU_FREQ_TABLE
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for mobile AMD K6-2+ and mobile
 	  AMD K6-3+ processors.
@@ -65,6 +69,7 @@ config X86_POWERNOW_K6
 config X86_POWERNOW_K7
 	tristate "AMD Mobile Athlon/Duron PowerNow!"
 	select CPU_FREQ_TABLE
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for mobile AMD K7 mobile processors.
 
@@ -76,23 +81,27 @@ config X86_POWERNOW_K7_ACPI
 	bool
 	depends on X86_POWERNOW_K7 && ACPI_PROCESSOR
 	depends on !(X86_POWERNOW_K7 = y && ACPI_PROCESSOR = m)
+	depends on X86_32
 	default y
 
 config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
-	depends on EXPERIMENTAL
 	help
 	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called powernow-k8.
+
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
 	  If in doubt, say N.
 
 config X86_POWERNOW_K8_ACPI
-	bool "ACPI Support"
-	select ACPI_PROCESSOR
-	depends on ACPI && X86_POWERNOW_K8
+	bool
+	prompt "ACPI Support" if X86_32
+	depends on ACPI && X86_POWERNOW_K8 && ACPI_PROCESSOR
+	depends on !(X86_POWERNOW_K8 = y && ACPI_PROCESSOR = m)
 	default y
 	help
 	  This provides access to the K8s Processor Performance States via ACPI.
@@ -104,7 +113,7 @@ config X86_POWERNOW_K8_ACPI
 
 config X86_GX_SUSPMOD
 	tristate "Cyrix MediaGX/NatSemi Geode Suspend Modulation"
-	depends on PCI
+	depends on X86_32 && PCI
 	help
 	 This add the CPUFreq driver for NatSemi Geode processors which
 	 support suspend modulation.
@@ -114,15 +123,20 @@ config X86_GX_SUSPMOD
 	 If in doubt, say N.
 
 config X86_SPEEDSTEP_CENTRINO
-	tristate "Intel Enhanced SpeedStep"
+	tristate "Intel Enhanced SpeedStep (deprecated)"
 	select CPU_FREQ_TABLE
-	select X86_SPEEDSTEP_CENTRINO_TABLE
+	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
+	depends on X86_64 && ACPI_PROCESSOR
 	help
+	  This is deprecated and this functionality is now merged into
+	  acpi_cpufreq (X86_ACPI_CPUFREQ). Use that driver instead of
+	  speedstep_centrino.
 	  This adds the CPUFreq driver for Enhanced SpeedStep enabled
-	  mobile CPUs.  This means Intel Pentium M (Centrino) CPUs. However,
-	  you also need to say Y to "Use ACPI tables to decode..." below
-	  [which might imply enabling ACPI] if you want to use this driver
-	  on non-Banias CPUs.
+	  mobile CPUs.  This means Intel Pentium M (Centrino) CPUs
+	  or 64bit enabled Intel Xeons.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called speedstep-centrino.
 
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
@@ -130,7 +144,7 @@ config X86_SPEEDSTEP_CENTRINO
 
 config X86_SPEEDSTEP_CENTRINO_TABLE
 	bool "Built-in tables for Banias CPUs"
-	depends on X86_SPEEDSTEP_CENTRINO
+	depends on X86_32 && X86_SPEEDSTEP_CENTRINO
 	default y
 	help
 	  Use built-in tables for Banias CPUs if ACPI encoding
@@ -141,6 +155,7 @@ config X86_SPEEDSTEP_CENTRINO_TABLE
 config X86_SPEEDSTEP_ICH
 	tristate "Intel Speedstep on ICH-M chipsets (ioport interface)"
 	select CPU_FREQ_TABLE
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
 	  (Coppermine), all mobile Intel Pentium III-M (Tualatin) and all
@@ -154,7 +169,7 @@ config X86_SPEEDSTEP_ICH
 config X86_SPEEDSTEP_SMI
 	tristate "Intel SpeedStep on 440BX/ZX/MX chipsets (SMI interface)"
 	select CPU_FREQ_TABLE
-	depends on EXPERIMENTAL
+	depends on X86_32 && EXPERIMENTAL
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
 	  (Coppermine), all mobile Intel Pentium III-M (Tualatin)
@@ -169,15 +184,24 @@ config X86_P4_CLOCKMOD
 	select CPU_FREQ_TABLE
 	help
 	  This adds the CPUFreq driver for Intel Pentium 4 / XEON
-	  processors.
+	  processors.  When enabled it will lower CPU temperature by skipping
+	  clocks.
+
+	  This driver should be only used in exceptional
+	  circumstances when very low power is needed because it causes severe
+	  slowdowns and noticeable latencies.  Normally Speedstep should be used
+	  instead.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called p4-clockmod.
 
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
-	  If in doubt, say N.
+	  Unless you are absolutely sure say N.
 
 config X86_CPUFREQ_NFORCE2
 	tristate "nVidia nForce2 FSB changing"
-	depends on EXPERIMENTAL
+	depends on X86_32 && EXPERIMENTAL
 	help
 	  This adds the CPUFreq driver for FSB changing on nVidia nForce2
 	  platforms.
@@ -188,6 +212,7 @@ config X86_CPUFREQ_NFORCE2
 
 config X86_LONGRUN
 	tristate "Transmeta LongRun"
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for Transmeta Crusoe and Efficeon processors
 	  which support LongRun.
@@ -199,7 +224,7 @@ config X86_LONGRUN
 config X86_LONGHAUL
 	tristate "VIA Cyrix III Longhaul"
 	select CPU_FREQ_TABLE
-	depends on ACPI_PROCESSOR
+	depends on X86_32 && ACPI_PROCESSOR
 	help
 	  This adds the CPUFreq driver for VIA Samuel/CyrixIII,
 	  VIA Cyrix Samuel/C3, VIA Cyrix Ezra and VIA Cyrix Ezra-T
@@ -212,7 +237,7 @@ config X86_LONGHAUL
 config X86_E_POWERSAVER
 	tristate "VIA C7 Enhanced PowerSaver (EXPERIMENTAL)"
 	select CPU_FREQ_TABLE
-	depends on EXPERIMENTAL
+	depends on X86_32 && EXPERIMENTAL
 	help
 	  This adds the CPUFreq driver for VIA C7 processors.
 
@@ -233,11 +258,11 @@ config X86_ACPI_CPUFREQ_PROC_INTF
 
 config X86_SPEEDSTEP_LIB
 	tristate
-	default X86_SPEEDSTEP_ICH || X86_SPEEDSTEP_SMI || X86_P4_CLOCKMOD
+	default (X86_SPEEDSTEP_ICH || X86_SPEEDSTEP_SMI || X86_P4_CLOCKMOD)
 
 config X86_SPEEDSTEP_RELAXED_CAP_CHECK
 	bool "Relaxed speedstep capability checks"
-	depends on (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)
+	depends on X86_32 && (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)
 	help
 	  Don't perform all checks for a speedstep capable system which would
 	  normally be done. Some ancient or strange systems, though speedstep
diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig_64 b/arch/x86/kernel/cpu/cpufreq/Kconfig_64
deleted file mode 100644
index 9c9699f..0000000
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig_64
+++ /dev/null
@@ -1,108 +0,0 @@
-#
-# CPU Frequency scaling
-#
-
-menu "CPU Frequency scaling"
-
-source "drivers/cpufreq/Kconfig"
-
-if CPU_FREQ
-
-comment "CPUFreq processor drivers"
-
-config X86_POWERNOW_K8
-	tristate "AMD Opteron/Athlon64 PowerNow!"
-	select CPU_FREQ_TABLE
-	help
-	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called powernow-k8.
-
-	  For details, take a look at <file:Documentation/cpu-freq/>.
-
-	  If in doubt, say N.
-
-config X86_POWERNOW_K8_ACPI
-	bool
-	depends on X86_POWERNOW_K8 && ACPI_PROCESSOR
-	depends on !(X86_POWERNOW_K8 = y && ACPI_PROCESSOR = m)
-	default y
-
-config X86_SPEEDSTEP_CENTRINO
-	tristate "Intel Enhanced SpeedStep (deprecated)"
-	select CPU_FREQ_TABLE
-	depends on ACPI_PROCESSOR
-	help
-	  This is deprecated and this functionality is now merged into
-	  acpi_cpufreq (X86_ACPI_CPUFREQ). Use that driver instead of
-	  speedstep_centrino.
-	  This adds the CPUFreq driver for Enhanced SpeedStep enabled
-	  mobile CPUs.  This means Intel Pentium M (Centrino) CPUs
-	  or 64bit enabled Intel Xeons.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called speedstep-centrino.
-
-	  For details, take a look at <file:Documentation/cpu-freq/>.
-
-	  If in doubt, say N.
-
-config X86_ACPI_CPUFREQ
-	tristate "ACPI Processor P-States driver"
-	select CPU_FREQ_TABLE
-	depends on ACPI_PROCESSOR
-	help
-	  This driver adds a CPUFreq driver which utilizes the ACPI
-	  Processor Performance States.
-	  This driver also supports Intel Enhanced Speedstep.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called acpi-cpufreq.
-
-	  For details, take a look at <file:Documentation/cpu-freq/>.
-
-	  If in doubt, say N.
-
-comment "shared options"
-
-config X86_ACPI_CPUFREQ_PROC_INTF
-	bool "/proc/acpi/processor/../performance interface (deprecated)"
-	depends on PROC_FS
-	depends on X86_ACPI_CPUFREQ || X86_POWERNOW_K8_ACPI
-	help
-	  This enables the deprecated /proc/acpi/processor/../performance
-	  interface. While it is helpful for debugging, the generic,
-	  cross-architecture cpufreq interfaces should be used.
-
-	  If in doubt, say N.
-
-config X86_P4_CLOCKMOD
-	tristate "Intel Pentium 4 clock modulation"
-	depends on EMBEDDED
-	select CPU_FREQ_TABLE
-	help
-	  This adds the clock modulation driver for Intel Pentium 4 / XEON
-	  processors.  When enabled it will lower CPU temperature by skipping
-	  clocks.
-
-	  This driver should be only used in exceptional
-	  circumstances when very low power is needed because it causes severe
-	  slowdowns and noticeable latencies.  Normally Speedstep should be used
-	  instead.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called p4-clockmod.
-
-	  For details, take a look at <file:Documentation/cpu-freq/>.
-
-	  Unless you are absolutely sure say N.
-
-
-config X86_SPEEDSTEP_LIB
-	tristate
-	default X86_P4_CLOCKMOD
-
-endif
-
-endmenu
-- 
1.5.3.4.1157.g0e74-dirty

