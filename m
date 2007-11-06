Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbXKFXBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbXKFXBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXKFW7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:59:50 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53817 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbXKFW7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:59:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: copy x86_64 specific Kconfig symbols to Kconifg.i386
Date: Wed,  7 Nov 2007 00:01:17 +0100
Message-Id: <11943900802493-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1194390080957-git-send-email-sam@ravnborg.org>
References: <11943900793940-git-send-email-sam@ravnborg.org> <11943900792519-git-send-email-sam@ravnborg.org> <11943900793757-git-send-email-sam@ravnborg.org> <11943900792324-git-send-email-sam@ravnborg.org> <1194390080957-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.
A prepatory step towards full unification.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig      |    6 +-
 arch/x86/Kconfig.i386 |  215 ++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 198 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e741fc7..9fbb049 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -353,11 +353,11 @@ config GEODE_MFGPT_TIMER
 	  MFGPTs have a better resolution and max interval than the
 	  generic PIT, and are suitable for use as high-res timers.
 
+endif # X86_32
+
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64
-
-endif # X86_32
+	depends on AGP_AMD64 || (X86_64 && (GART_IOMMU || (PCI && NUMA)))
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index 174b909..a616d65 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -218,6 +218,14 @@ config X86_ES7000
 	  Only choose this option if you have such a system, otherwise you
 	  should say N here.
 
+config X86_VSMP
+	bool "Support for ScaleMP vSMP"
+	depends on X86_64 && PCI
+	 help
+	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
+	  supposed to run on these EM64T-based machines.  Only choose this option
+	  if you have one of these machines.
+
 endchoice
 
 config SCHED_NO_NO_OMIT_FRAME_POINTER
@@ -299,20 +307,87 @@ source "arch/x86/Kconfig.cpu"
 config HPET_TIMER
 	bool
 	prompt "HPET Timer Support" if X86_32
+	default X86_64
 	help
-	  This enables the use of the HPET for the kernel's internal timer.
-	  HPET is the next generation timer replacing legacy 8254s.
-	  You can safely choose Y here.  However, HPET will only be
-	  activated if the platform and the BIOS support this feature.
-	  Otherwise the 8254 will be used for timing services.
+         Use the IA-PC HPET (High Precision Event Timer) to manage
+         time in preference to the PIT and RTC, if a HPET is
+         present.
+         HPET is the next generation timer replacing legacy 8254s.
+         The HPET provides a stable time base on SMP
+         systems, unlike the TSC, but it is more expensive to access,
+         as it is off-chip.  You can find the HPET spec at
+         <http://www.intel.com/hardwaredesign/hpetspec.htm>.
+
+         You can safely choose Y here.  However, HPET will only be
+         activated if the platform and the BIOS support this feature.
+         Otherwise the 8254 will be used for timing services.
 
-	  Choose N to continue using the legacy 8254 timer.
+         Choose N to continue using the legacy 8254 timer.
 
 config HPET_EMULATE_RTC
 	bool
 	depends on HPET_TIMER && RTC=y
 	default y
 
+# Mark as embedded because too many people got it wrong.
+# The code disables itself when not needed.
+config GART_IOMMU
+	bool "GART IOMMU support" if EMBEDDED
+	default y
+	select SWIOTLB
+	select AGP
+	depends on X86_64 && PCI
+	help
+	  Support for full DMA access of devices with 32bit memory access only
+	  on systems with more than 3GB. This is usually needed for USB,
+	  sound, many IDE/SATA chipsets and some other devices.
+	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
+	  based hardware IOMMU and a software bounce buffer based IOMMU used
+	  on Intel systems and as fallback.
+	  The code is only active when needed (enough memory and limited
+	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
+	  too.
+
+config CALGARY_IOMMU
+	bool "IBM Calgary IOMMU support"
+	select SWIOTLB
+	depends on X86_64 && PCI && EXPERIMENTAL
+	help
+	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
+	  systems. Needed to run systems with more than 3GB of memory
+	  properly with 32-bit PCI devices that do not support DAC
+	  (Double Address Cycle). Calgary also supports bus level
+	  isolation, where all DMAs pass through the IOMMU.  This
+	  prevents them from going anywhere except their intended
+	  destination. This catches hard-to-find kernel bugs and
+	  mis-behaving drivers and devices that do not use the DMA-API
+	  properly to set up their DMA buffers.  The IOMMU can be
+	  turned off at boot time with the iommu=off parameter.
+	  Normally the kernel will make the right choice by itself.
+	  If unsure, say Y.
+
+config CALGARY_IOMMU_ENABLED_BY_DEFAULT
+	bool "Should Calgary be enabled by default?"
+	default y
+	depends on CALGARY_IOMMU
+	help
+	  Should Calgary be enabled by default? if you choose 'y', Calgary
+	  will be used (if it exists). If you choose 'n', Calgary will not be
+	  used even if it exists. If you choose 'n' and would like to use
+	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
+	  If unsure, say Y.
+
+# need this always selected by IOMMU for the VIA workaround
+config SWIOTLB
+	bool
+	help
+	  Support for software bounce buffers used on x86-64 systems
+	  which don't have a hardware IOMMU (e.g. the current generation
+	  of Intel's x86-64 CPUs). Using this PCI devices which can only
+	  access 32-bits of memory can be used on systems with more than
+	  3 GB of memory. If unsure, say Y.
+
+
 config NR_CPUS
 	int "Maximum number of CPUs (2-255)"
 	range 2 255
@@ -329,7 +404,7 @@ config NR_CPUS
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
-	depends on X86_HT
+	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
 	help
 	  SMT scheduler support improves the CPU scheduler's decision making
 	  when dealing with Intel Pentium 4 chips with HyperThreading at a
@@ -338,7 +413,7 @@ config SCHED_SMT
 
 config SCHED_MC
 	bool "Multi-core scheduler support"
-	depends on X86_HT
+	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
 	default y
 	help
 	  Multi-core scheduler support improves the CPU scheduler's decision
@@ -374,12 +449,12 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	bool
-	depends on X86_32 && (X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH)
+	depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH))
 	default y
 
 config X86_IO_APIC
 	bool
-	depends on X86_32 && (X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH)
+	depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH))
 	default y
 
 config X86_VISWS_APIC
@@ -404,6 +479,22 @@ config X86_MCE
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
 
+config X86_MCE_INTEL
+	bool "Intel MCE features"
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	default y
+	help
+	   Additional support for intel specific MCE features such as
+	   the thermal monitor.
+
+config X86_MCE_AMD
+	bool "AMD MCE features"
+	depends on X86_64 && X86_MCE && X86_LOCAL_APIC
+	default y
+	help
+	   Additional support for AMD specific MCE features such as
+	   the DRAM Error Threshold.
+
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
 	depends on X86_32 && X86_MCE
@@ -651,19 +742,55 @@ config X86_PAE
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
-	depends on X86_32 && SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
+	depends on SMP
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL)
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT)
 	help
-	  NUMA support for i386. This is currently highly experimental
-	  and should be only used for kernel development. It might also
-	  cause boot failures.
+	  Enable NUMA (Non Uniform Memory Access) support.
+	  The kernel will try to allocate memory used by a CPU on the
+	  local memory controller of the CPU and add some more
+	  NUMA awareness to the kernel.
+
+	  For i386 this is currently highly experimental and should be only
+	  used for kernel development. It might also cause boot failures.
+	  For x86_64 this is recommended on all multiprocessor Opteron systems.
+	  If the system is EM64T, you should say N unless your system is
+	  EM64T NUMA.
 
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
 
+config K8_NUMA
+       bool "Old style AMD Opteron NUMA detection"
+       depends on X86_64 && NUMA && PCI
+       default y
+       help
+	 Enable K8 NUMA node topology detection.  You should say Y here if
+	 you have a multi processor AMD K8 system. This uses an old
+	 method to read the NUMA configuration directly from the builtin
+	 Northbridge of Opteron. It is recommended to use X86_64_ACPI_NUMA
+	 instead, which also takes priority if both are compiled in.   
+
+config X86_64_ACPI_NUMA
+	bool "ACPI NUMA detection"
+	depends on X86_64 && NUMA && ACPI && PCI
+	select ACPI_NUMA
+	default y
+	help
+	  Enable ACPI SRAT based node topology detection.
+
+config NUMA_EMU
+	bool "NUMA emulation"
+	depends on X86_64 && NUMA
+	help
+	  Enable NUMA emulation. A flat machine will be split
+	  into virtual nodes when booted with "numa=fake=N", where N is the
+	  number of nodes. This is only useful for debugging.
+
 config NODES_SHIFT
 	int
+	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"
 	depends on NEED_MULTIPLE_NODES
@@ -690,7 +817,7 @@ config HAVE_ARCH_ALLOC_REMAP
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC
+	depends on (X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC) || (X86_64 && !NUMA)
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
@@ -702,8 +829,9 @@ config ARCH_DISCONTIGMEM_DEFAULT
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on (NUMA || (X86_PC && EXPERIMENTAL))
+	depends on NUMA || (EXPERIMENTAL && (X86_PC || X86_64))
 	select SPARSEMEM_STATIC if X86_32
+	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
@@ -712,6 +840,10 @@ config ARCH_SELECT_MEMORY_MODEL
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
+config ARCH_MEMORY_PROBE
+	def_bool X86_64
+	depends on MEMORY_HOTPLUG
+
 source "mm/Kconfig"
 
 config HIGHPTE
@@ -833,6 +965,30 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
+config CC_STACKPROTECTOR
+	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
+	depends on X86_64 && EXPERIMENTAL
+	help
+         This option turns on the -fstack-protector GCC feature. This
+	  feature puts, at the beginning of critical functions, a canary
+	  value on the stack just before the return address, and validates
+	  the value just before actually returning.  Stack based buffer
+	  overflows (that need to overwrite this return address) now also
+	  overwrite the canary, which gets detected and the attack is then
+	  neutralized via a kernel panic.
+
+	  This feature requires gcc version 4.2 or above, or a distribution
+	  gcc with the feature backported. Older versions are automatically
+	  detected and for those versions, this configuration option is ignored.
+
+config CC_STACKPROTECTOR_ALL
+	bool "Use stack-protector for all functions"
+	depends on CC_STACKPROTECTOR
+	help
+	  Normally, GCC only inserts the canary value protection for
+	  functions that use large-ish on-stack buffers. By enabling
+	  this option, GCC will be asked to do this for ALL functions.
+
 source kernel/Kconfig.hz
 
 config KEXEC
@@ -854,7 +1010,7 @@ config KEXEC
 config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	depends on HIGHMEM
+	depends on X86_64 || (X86_32 && HIGHMEM)
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
@@ -869,6 +1025,7 @@ config CRASH_DUMP
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
 	default "0x1000000" if X86_NUMAQ
+	default "0x200000" if X86_64
 	default "0x100000"
 	help
 	  This gives the physical address where the kernel is loaded.
@@ -921,10 +1078,15 @@ config RELOCATABLE
 	  must live at a different physical address than the primary
 	  kernel.
 
+	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
+	  it has been loaded at and the compile time physical address
+	  (CONFIG_PHYSICAL_START) is ignored.
+
 config PHYSICAL_ALIGN
 	hex
 	prompt "Alignment value to which kernel should be aligned" if X86_32
-	default "0x100000"
+	default "0x100000" if X86_32
+	default "0x200000" if X86_64
 	range 0x2000 0x400000
 	help
 	  This value puts the alignment restrictions on physical address
@@ -952,6 +1114,8 @@ config HOTPLUG_CPU
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
 	  /sys/devices/system/cpu.
+	  Say N if you want to disable CPU hotplug and don't need to
+	  suspend.
 
 config COMPAT_VDSO
 	bool "Compat VDSO support"
@@ -970,8 +1134,19 @@ endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
-	depends on HIGHMEM
+	depends on X86_64 || (X86_32 && HIGHMEM)
+
+config MEMORY_HOTPLUG_RESERVE
+	def_bool X86_64
+	depends on (MEMORY_HOTPLUG && DISCONTIGMEM)
+
+config HAVE_ARCH_EARLY_PFN_TO_NID
+	def_bool X86_64
+	depends on NUMA
 
+config OUT_OF_LINE_PFN_TO_PAGE
+	def_bool X86_64
+	depends on DISCONTIGMEM
 
 #
 # Use the generic interrupt handling code in kernel/irq/:
@@ -996,7 +1171,7 @@ config X86_SMP
 
 config X86_HT
 	bool
-	depends on SMP && !(X86_VISWS || X86_VOYAGER)
+	depends on SMP && !(X86_VISWS || X86_VOYAGER || MK8)
 	default y
 
 config X86_BIOS_REBOOT
-- 
1.5.3.4.1157.g0e74-dirty

