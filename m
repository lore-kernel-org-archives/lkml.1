Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXJaVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXJaVxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbXJaVxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:53:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52847 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758497AbXJaVx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:53:29 -0400
Date: Wed, 31 Oct 2007 22:55:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH/RFC] x86: unify Kconfig files
Message-ID: <20071031215501.GA28556@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It has been requested that we should let x86 behave like
other architectures so we at config time decide for 32 or 64 bit.
The challenge here is to mere the Kconfig files and I have done
an attempt to do so.

See patch below.

The diffstat looks nice:

 arch/x86/{Kconfig.i386 => Kconfig} | 1167 ++++++++++++++-------------
 arch/x86/Kconfig.cpu               |   79 ++-
 arch/x86/Kconfig.i386              | 1546 ++++++------------------------------
 arch/x86/Kconfig.x86_64            | 1051 +++++-------------------
 scripts/kconfig/Makefile           |    7 +-
 5 files changed, 1116 insertions(+), 2734 deletions(-)

But the merge was in no way trivial so a couple of trained eyes
on the result would be good.
I am heading for bed and I did not manage to unify the cpufreq
Kconfig files (but it looks trivial).
This needs to be done before we can apply this patch.

I merged all config options with prompts to the common Kconfig file
and the non-prompt config options were kept in Kconfig.$(ARCH)
In some case I added a depends on X86_{32,64} just to document
the dependency since it was given implicit.

In Kconfig.cpu I actually left out the 32/64 dependency since I
could not see it hamr since the relevant symbols were anyway not set.


When we have merged the Kconfig files we need to fix the Makefile.
But that is trivial. We shall check X86_64 / X86_32 as replacement
for ARCH in arch/x86/Makefile and I think we are done.

Comments?
I could split it up in smaller chunks - at least the Kconfig.cpu
thing could be merged independently. But I dunno if it is worth it.

	Sam

---
 arch/x86/{Kconfig.i386 => Kconfig} | 1167 ++++++++++++++-------------
 arch/x86/Kconfig.cpu               |   79 ++-
 arch/x86/Kconfig.i386              | 1546 ++++++------------------------------
 arch/x86/Kconfig.x86_64            | 1051 +++++-------------------
 scripts/kconfig/Makefile           |    7 +-
 5 files changed, 1116 insertions(+), 2734 deletions(-)
 rename arch/x86/{Kconfig.i386 => Kconfig} (78%)
 rewrite 
arch/x86/Kconfig.i386 (92%)
 rewrite 
arch/x86/Kconfig.x86_64 (88%)

diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig
similarity index 78%
rename from arch/x86/Kconfig.i386
rename to arch/x86/Kconfig
index 7331efe..16d547a 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig
@@ -5,91 +5,34 @@
 
 mainmenu "Linux Kernel Configuration"
 
+choice
+	prompt "Architecture?"
+	default X86_32
+	help
+	  Select the architecture.
+	  Previous this was explicit on the commandline when building
+	  the kernel but this choice is now moved to the Kconfig files.
+
 config X86_32
-	bool
-	default y
+	bool "i386"
 	help
 	  This is Linux's home port.  Linux was originally native to the Intel
 	  386, and runs on all the later x86 processors including the Intel
 	  486, 586, Pentiums, and various instruction-set-compatible chips by
 	  AMD, Cyrix, and others.
 
-config GENERIC_TIME
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
-config CLOCKSOURCE_WATCHDOG
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-	default y
-	depends on X86_LOCAL_APIC
-
-config LOCKDEP_SUPPORT
-	bool
-	default y
-
-config STACKTRACE_SUPPORT
-	bool
-	default y
-
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
-
-config X86
-	bool
-	default y
-
-config MMU
-	bool
-	default y
-
-config ZONE_DMA
-	bool
-	default y
-
-config QUICKLIST
-	bool
-	default y
-
-config SBUS
-	bool
-
-config GENERIC_ISA_DMA
-	bool
-	default y
-
-config GENERIC_IOMAP
-	bool
-	default y
-
-config GENERIC_BUG
-	bool
-	default y
-	depends on BUG
+config X86_64
+	bool "x86_64"
+	help
+	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
+	  classical 32-bit x86 architecture. For details see
+	  <http://www.x86-64.org/>.
+endchoice
 
-config GENERIC_HWEIGHT
-	bool
-	default y
+source "arch/x86/Kconfig.i386"
 
-config ARCH_MAY_HAVE_PC_FDC
-	bool
-	default y
+source "arch/x86/Kconfig.x86_64"
 
-config DMI
-	bool
-	default y
 
 source "init/Kconfig"
 
@@ -97,35 +40,6 @@ menu "Processor type and features"
 
 source "kernel/time/Kconfig"
 
-config SMP
-	bool "Symmetric multi-processing support"
-	---help---
-	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
-
-	  If you say N here, the kernel will run on single and multiprocessor
-	  machines, but will use only one CPU of a multiprocessor machine. If
-	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
-	  will run faster if you say N here.
-
-	  Note that if you say Y here and choose architecture "586" or
-	  "Pentium" under "Processor family", the kernel will not work on 486
-	  architectures. Similarly, multiprocessor kernels for the "PPro"
-	  architecture may not work on all Pentium based boards.
-
-	  People using multiprocessor machines who say Y here should also say
-	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
-	  Management" code will be disabled if you say Y here.
-
-	  See also the <file:Documentation/smp.txt>,
-	  <file:Documentation/i386/IO-APIC.txt>,
-	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  If you don't know what to do here, say N.
-
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC
@@ -137,6 +51,7 @@ config X86_PC
 
 config X86_ELAN
 	bool "AMD Elan"
+	depends on X86_32
 	help
 	  Select this for an AMD Elan processor.
 
@@ -146,6 +61,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
+	depends on X86_32
 	select SMP if !BROKEN
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
@@ -158,6 +74,7 @@ config X86_VOYAGER
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
+	depends on X86_32
 	select SMP
 	select NUMA
 	help
@@ -169,7 +86,7 @@ config X86_NUMAQ
 
 config X86_SUMMIT
 	bool "Summit/EXA (IBM x440)"
-	depends on SMP
+	depends on X86_32 && SMP
 	help
 	  This option is needed for IBM systems that use the Summit/EXA chipset.
 	  In particular, it is needed for the x440.
@@ -179,7 +96,7 @@ config X86_SUMMIT
 
 config X86_BIGSMP
 	bool "Support for other sub-arch SMP systems with more than 8 CPUs"
-	depends on SMP
+	depends on X86_32 && SMP
 	help
 	  This option is needed for the systems that have more than 8 CPUs
 	  and if the system is not of any sub-arch type above.
@@ -188,6 +105,7 @@ config X86_BIGSMP
 
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
+	depends on X86_32
 	help
 	  The SGI Visual Workstation series is an IA32-based workstation
 	  based on SGI systems chips with some legacy PC hardware attached.
@@ -198,25 +116,107 @@ config X86_VISWS
 	  and vice versa. See <file:Documentation/sgi-visws.txt> for details.
 
 config X86_GENERICARCH
-       bool "Generic architecture (Summit, bigsmp, ES7000, default)"
-       help
+	bool "Generic architecture (Summit, bigsmp, ES7000, default)"
+	depends on X86_32
+	help
           This option compiles in the Summit, bigsmp, ES7000, default subarchitectures.
 	  It is intended for a generic binary kernel.
 	  If you want a NUMA kernel, select ACPI.   We need SRAT for NUMA.
 
 config X86_ES7000
 	bool "Support for Unisys ES7000 IA32 series"
-	depends on SMP
+	depends on X86_32 && SMP
 	help
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 	  Only choose this option if you have such a system, otherwise you
 	  should say N here.
 
+config X86_VSMP
+	bool "Support for ScaleMP vSMP"
+	depends on X86_64 && PCI
+	help
+	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
+	  supposed to run on these EM64T-based machines.  Only choose this option
+	  if you have one of these machines.
+
 endchoice
 
+config SMP
+	bool "Symmetric multi-processing support"
+	---help---
+	  This enables support for systems with more than one CPU. If you have
+	  a system with only one CPU, like most personal computers, say N. If
+	  you have a system with more than one CPU, say Y.
+
+	  If you say N here, the kernel will run on single and multiprocessor
+	  machines, but will use only one CPU of a multiprocessor machine. If
+	  you say Y here, the kernel will run on many, but not all,
+	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  will run faster if you say N here.
+
+	  Note that if you say Y here and choose architecture "586" or
+	  "Pentium" under "Processor family", the kernel will not work on 486
+	  architectures. Similarly, multiprocessor kernels for the "PPro"
+	  architecture may not work on all Pentium based boards.
+
+	  People using multiprocessor machines who say Y here should also say
+	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
+	  Management" code will be disabled if you say Y here.
+
+	  See also the <file:Documentation/smp.txt>,
+	  <file:Documentation/i386/IO-APIC.txt>,
+	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  If you don't know what to do here, say N.
+
+config NR_CPUS
+	int "Maximum number of CPUs (2-255)"
+	range 2 255
+	depends on SMP
+	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
+	default "8"
+	help
+	  This allows you to specify the maximum number of CPUs which this
+	  kernel will support.  The maximum supported value is 255 and the
+	  minimum value which makes sense is 2.
+
+	  This is purely to save memory - each supported CPU adds
+	  approximately eight kilobytes to the kernel image.
+
+config HOTPLUG_CPU
+	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
+	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	help
+	  Say Y here to experiment with turning CPUs off and on.  CPUs
+	  can be controlled through /sys/devices/system/cpu/cpu#.
+	  This is also required for suspend/hibernation on SMP systems.
+
+	  Say N if you want to disable CPU hotplug and don't need to
+	  suspend.
+
+config SCHED_SMT
+	bool "SMT (Hyperthreading) scheduler support"
+	depends on X86_HT
+	help
+	  SMT scheduler support improves the CPU scheduler's decision making
+	  when dealing with Intel Pentium 4 chips with HyperThreading at a
+	  cost of slightly increased overhead in some places. If unsure say
+	  N here.
+
+config SCHED_MC
+	bool "Multi-core scheduler support"
+	depends on X86_HT
+	default y
+	help
+	  Multi-core scheduler support improves the CPU scheduler's decision
+	  making when dealing with multi-core CPU chips at a cost of slightly
+	  increased overhead in some places. If unsure say N here.
+
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	bool "Single-depth WCHAN output"
+	depends on X86_32
 	default y
 	help
 	  Calculate simpler /proc/<PID>/wchan values. If this option
@@ -226,6 +226,25 @@ config SCHED_NO_NO_OMIT_FRAME_POINTER
 
 	  If in doubt, say "Y".
 
+
+config HPET_TIMER
+	bool
+	prompt "HPET Timer Support" if X86_32
+	default y if X86_64
+	help
+	  This enables the use of the HPET for the kernel's internal timer.
+	  HPET is the next generation timer replacing legacy 8254s.
+	  You can safely choose Y here.  However, HPET will only be
+	  activated if the platform and the BIOS support this feature.
+	  Otherwise the 8254 will be used for timing services.
+
+	  Choose N to continue using the legacy 8254 timer.
+
+config HPET_EMULATE_RTC
+	bool
+	depends on HPET_TIMER && RTC=y
+	default y
+
 config PARAVIRT
 	bool
 	depends on !(X86_VISWS || X86_VOYAGER)
@@ -237,6 +256,7 @@ config PARAVIRT
 
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
+	depends on X86_32
 	help
 	  Say Y here to get to see options related to running Linux under
 	  various hypervisors.  This option alone does not add any kernel code.
@@ -261,87 +281,9 @@ source "arch/x86/lguest/Kconfig"
 
 endif
 
-config ACPI_SRAT
-	bool
-	default y
-	depends on ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
-	select ACPI_NUMA
-
-config HAVE_ARCH_PARSE_SRAT
-       bool
-       default y
-       depends on ACPI_SRAT
-
-config X86_SUMMIT_NUMA
-	bool
-	default y
-	depends on NUMA && (X86_SUMMIT || X86_GENERICARCH)
-
-config X86_CYCLONE_TIMER
-	bool
-	default y
-	depends on X86_SUMMIT || X86_GENERICARCH
-
-config ES7000_CLUSTERED_APIC
-	bool
-	default y
-	depends on SMP && X86_ES7000 && MPENTIUMIII
-
-source "arch/x86/Kconfig.cpu"
-
-config HPET_TIMER
-	bool "HPET Timer Support"
-	help
-	  This enables the use of the HPET for the kernel's internal timer.
-	  HPET is the next generation timer replacing legacy 8254s.
-	  You can safely choose Y here.  However, HPET will only be
-	  activated if the platform and the BIOS support this feature.
-	  Otherwise the 8254 will be used for timing services.
-
-	  Choose N to continue using the legacy 8254 timer.
-
-config HPET_EMULATE_RTC
-	bool
-	depends on HPET_TIMER && RTC=y
-	default y
-
-config NR_CPUS
-	int "Maximum number of CPUs (2-255)"
-	range 2 255
-	depends on SMP
-	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
-	default "8"
-	help
-	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 255 and the
-	  minimum value which makes sense is 2.
-
-	  This is purely to save memory - each supported CPU adds
-	  approximately eight kilobytes to the kernel image.
-
-config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on X86_HT
-	help
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with Intel Pentium 4 chips with HyperThreading at a
-	  cost of slightly increased overhead in some places. If unsure say
-	  N here.
-
-config SCHED_MC
-	bool "Multi-core scheduler support"
-	depends on X86_HT
-	default y
-	help
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
-
-source "kernel/Kconfig.preempt"
-
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on !SMP && !(X86_VISWS || X86_VOYAGER || X86_GENERICARCH)
+	depends on X86_32 && !SMP && !(X86_VISWS || X86_VOYAGER || X86_GENERICARCH)
 	help
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -364,25 +306,387 @@ config X86_UP_IOAPIC
 	  to use it. If you say Y here even though your machine doesn't have
 	  an IO-APIC, then the kernel will still run with no slowdown at all.
 
-config X86_LOCAL_APIC
-	bool
-	depends on X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH
+
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
 	default y
+	depends on CALGARY_IOMMU
+	help
+	  Should Calgary be enabled by default? if you choose 'y', Calgary
+	  will be used (if it exists). If you choose 'n', Calgary will not be
+	  used even if it exists. If you choose 'n' and would like to use
+	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
+	  If unsure, say Y.
 
-config X86_IO_APIC
+# need this always selected by IOMMU for the VIA workaround
+config SWIOTLB
 	bool
-	depends on X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH
+	help
+	  Support for software bounce buffers used on x86-64 systems
+	  which don't have a hardware IOMMU (e.g. the current generation
+	  of Intel's x86-64 CPUs). Using this PCI devices which can only
+	  access 32-bits of memory can be used on systems with more than
+	  3 GB of memory. If unsure, say Y.
+
+
+source "kernel/Kconfig.preempt"
+
+config NUMA
+	bool "Non Uniform Memory Access (NUMA) Support"
+	depends on X86_64 && SMP
+	help
+	  Enable NUMA (Non Uniform Memory Access) support. The kernel 
+	  will try to allocate memory used by a CPU on the local memory 
+	  controller of the CPU and add some more NUMA awareness to the kernel.
+	  This code is recommended on all multiprocessor Opteron systems.
+	  If the system is EM64T, you should say N unless your system is EM64T 
+	  NUMA. 
+
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
+# Common NUMA Features
+config NUMA
+	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
+	depends on X86_32 && SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
+	default n if X86_PC
+	default y if (X86_NUMAQ || X86_SUMMIT)
+	help
+	  NUMA support for i386. This is currently highly experimental
+	  and should be only used for kernel development. It might also
+	  cause boot failures.
+
+comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
+	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
+
+config NODES_SHIFT
+	int
+	default "6" if X86_64
+	default "4" if X86_NUMAQ
+	default "3"
+	depends on NEED_MULTIPLE_NODES
+
+# Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
+config X86_64_ACPI_NUMA
+	bool "ACPI NUMA detection"
+#	depends on NUMA   # FIXME results in recursive dependency
+	select ACPI 
+	select PCI
+	select ACPI_NUMA
 	default y
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
+source "mm/Kconfig"
 
-config X86_VISWS_APIC
+config HIGHPTE
+	bool "Allocate 3rd-level pagetables from highmem"
+	depends on X86_32 && HIGHMEM4G || HIGHMEM64G
+	help
+	  The VM uses one page table entry for each page of physical memory.
+	  For systems with a lot of RAM, this can be wasteful of precious
+	  low memory.  Setting this option will put user-space page table
+	  entries in high memory.
+
+config MATH_EMULATION
 	bool
-	depends on X86_VISWS
+	prompt "Math emulation" if X86_32
+	help
+	  Linux can emulate a math coprocessor (used for floating point
+	  operations) if you don't have one. 486DX and Pentium processors have
+	  a math coprocessor built in, 486SX and 386 do not, unless you added
+	  a 487DX or 387, respectively. (The messages during boot time can
+	  give you some hints here ["man dmesg"].) Everyone needs either a
+	  coprocessor or this emulation.
+
+	  If you don't have a math coprocessor, you need to say Y here; if you
+	  say Y here even though you have a coprocessor, the coprocessor will
+	  be used nevertheless. (This behavior can be changed with the kernel
+	  command line option "no387", which comes handy if your coprocessor
+	  is broken. Try "man bootparam" or see the documentation of your boot
+	  loader (lilo or loadlin) about how to pass options to the kernel at
+	  boot time.) This means that it is a good idea to say Y here if you
+	  intend to use this kernel on different machines.
+
+	  More information about the internals of the Linux math coprocessor
+	  emulation can be found in <file:arch/x86/math-emu/README>.
+
+	  If you are not sure, say Y; apart from resulting in a 66 KB bigger
+	  kernel, it won't hurt.
+
+config MTRR
+	bool "MTRR (Memory Type Range Register) support"
+	---help---
+	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
+	  the Memory Type Range Registers (MTRRs) may be used to control
+	  processor access to memory ranges. This is most useful if you have
+	  a video (VGA) card on a PCI or AGP bus. Enabling write-combining
+	  allows bus write transfers to be combined into a larger transfer
+	  before bursting over the PCI/AGP bus. This can increase performance
+	  of image write operations 2.5 times or more. Saying Y here creates a
+	  /proc/mtrr file which may be used to manipulate your processor's
+	  MTRRs. Typically the X server should use this.
+
+	  This code has a reasonably generic interface so that similar
+	  control registers on other processors can be easily supported
+	  as well:
+
+	  The Cyrix 6x86, 6x86MX and M II processors have Address Range
+	  Registers (ARRs) which provide a similar functionality to MTRRs. For
+	  these, the ARRs are used to emulate the MTRRs.
+	  The AMD K6-2 (stepping 8 and above) and K6-3 processors have two
+	  MTRRs. The Centaur C6 (WinChip) has 8 MCRs, allowing
+	  write-combining. All of these processors are supported by this code
+	  and it makes sense to say Y here if you have one of them.
+
+	  Saying Y here also fixes a problem with buggy SMP BIOSes which only
+	  set the MTRRs for the boot CPU and not for the secondary CPUs. This
+	  can lead to all sorts of problems, so it's good to say Y here.
+
+	  You can safely say Y even if your machine doesn't have MTRRs, you'll
+	  just add about 9 KB to your kernel.
+	  Just say Y here for all x86-64 machines - they support MTRRs.
+
+	  See <file:Documentation/mtrr.txt> for more information.
+
+config EFI
+	bool "Boot from EFI support"
+	depends on X86_32 && ACPI
+	default n
+	---help---
+	This enables the kernel to boot on EFI platforms using
+	system configuration information passed to it from the firmware.
+	This also enables the kernel to use any EFI runtime services that are
+	available (such as the EFI variable services).
+
+	This option is only useful on systems that have EFI firmware
+	and will result in a kernel image that is ~8k larger.  In addition,
+	you must use the latest ELILO loader available at
+	<http://elilo.sourceforge.net> in order to take advantage of
+	kernel initialization using EFI information (neither GRUB nor LILO know
+	anything about EFI).  However, even with this option, the resultant
+	kernel should continue to boot on existing non-EFI platforms.
+
+config IRQBALANCE
+ 	bool "Enable kernel irq balancing"
+	depends on X86_32 && SMP && X86_IO_APIC
+	default y
+	help
+ 	  The default yes will allow the kernel to do irq load balancing.
+	  Saying no will keep the kernel from doing irq load balancing.
+
+config SECCOMP
+	bool "Enable seccomp to safely compute untrusted bytecode"
+	depends on PROC_FS
 	default y
+	help
+	  This kernel feature is useful for number crunching applications
+	  that may need to compute untrusted bytecode during their
+	  execution. By using pipes or other transports made available to
+	  the process as file descriptors supporting the read/write
+	  syscalls, it's possible to isolate those applications in
+	  their own address space using seccomp. Once seccomp is
+	  enabled via /proc/<pid>/seccomp, it cannot be disabled
+	  and the task is only allowed to execute a few safe syscalls
+	  defined by each seccomp mode.
+
+	  If unsure, say Y. Only embedded should say N here.
+
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
+source kernel/Kconfig.hz
+
+config KEXEC
+	bool "kexec system call"
+	help
+	  kexec is a system call that implements the ability to shutdown your
+	  current kernel, and to start another kernel.  It is like a reboot
+	  but it is independent of the system firmware.   And like a reboot
+	  you can start any kernel with it, not just Linux.
+
+	  The name comes from the similarity to the exec system call.
+
+	  It is an ongoing process to be certain the hardware in a machine
+	  is properly shutdown, so do not be surprised if this code does not
+	  initially work for you.  It may help to enable device hotplugging
+	  support.  As of this writing the exact hardware interface is
+	  strongly in flux, so no good recommendation can be made.
+
+config CRASH_DUMP
+	bool "kernel crash dumps (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Generate crash dump after being started by kexec.
+	  This should be normally only set in special crash dump kernels
+	  which are loaded in the main kernel with kexec-tools into
+	  a specially reserved region and then later executed after
+	  a crash by kdump/kexec. The crash dump kernel must be compiled
+	  to a memory address not used by the main kernel or BIOS using
+	  PHYSICAL_START, or it must be built as a relocatable image
+	  (CONFIG_RELOCATABLE=y).
+	  For more details see Documentation/kdump/kdump.txt
+
+config PHYSICAL_START
+	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
+	default "0x200000" if X86_64
+	default "0x1000000" if X86_NUMAQ
+	default "0x100000"
+	help
+	  This gives the physical address where the kernel is loaded. It
+	  should be aligned to 2MB boundary.
+
+	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
+	  bzImage will decompress itself to above physical address and
+	  run from there. Otherwise, bzImage will run from the address where
+	  it has been loaded by the boot loader and will ignore above physical
+	  address.
+
+	  In normal kdump cases one does not have to set/change this option
+	  as now bzImage can be compiled as a completely relocatable image
+	  (CONFIG_RELOCATABLE=y) and be used to load and run from a different
+	  address. This option is mainly useful for the folks who don't want
+	  to use a bzImage for capturing the crash dump and want to use a
+	  vmlinux instead.
+
+	  So if you are using bzImage for capturing the crash dump, leave
+	  the value here unchanged and set CONFIG_RELOCATABLE=y.
+	  Otherwise if you plan to use vmlinux for capturing the crash dump
+	  change this value to start of the reserved region (Typically 16MB
+	  0x1000000). In other words, it can be set based on the "X" value as
+	  specified in the "crashkernel=YM@XM" command line boot parameter
+	  passed to the panic-ed kernel. Typically this parameter is set as
+	  crashkernel=64M@16M. Please take a look at
+	  Documentation/kdump/kdump.txt for more details about crash dumps.
+
+	  Usage of bzImage for capturing the crash dump is advantageous as
+	  one does not have to build two kernels. Same kernel can be used
+	  as production kernel and capture kernel.
+
+	  Don't change this unless you know what you are doing.
+
+config RELOCATABLE
+	bool "Build a relocatable kernel (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Builds a relocatable kernel. This enables loading and running
+	  a kernel binary from a different physical address than it has
+	  been compiled for.
+
+	  One use is for the kexec on panic case where the recovery kernel
+	  must live at a different physical address than the primary
+	  kernel.
+
+	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
+	  it has been loaded at and the compile time physical address
+	  (CONFIG_PHYSICAL_START) is ignored.
+
+config PHYSICAL_ALIGN
+	hex
+	prompt "Alignment value to which kernel should be aligned" if X86_32
+	default "0x100000" if X86_32
+	default "0x200000" if X86_64
+	range 0x2000 0x400000
+	help
+	  This value puts the alignment restrictions on physical address
+ 	  where kernel is loaded and run from. Kernel is compiled for an
+ 	  address which meets above alignment restriction.
+
+ 	  If bootloader loads the kernel at a non-aligned address and
+ 	  CONFIG_RELOCATABLE is set, kernel will move itself to nearest
+ 	  address aligned to above value and run from there.
+
+ 	  If bootloader loads the kernel at a non-aligned address and
+ 	  CONFIG_RELOCATABLE is not set, kernel will ignore the run time
+ 	  load address and decompress itself to the address it has been
+ 	  compiled for and run from there. The address for which kernel is
+ 	  compiled already meets above alignment restrictions. Hence the
+ 	  end result is that kernel runs from a physical address meeting
+	  above alignment restrictions.
+
+	  Don't change this unless you know what you are doing.
+
+
 
 config X86_MCE
-	bool "Machine Check Exception"
+	bool "Machine Check Exception" if EMBEDDED
 	depends on !X86_VOYAGER
-	---help---
+	default y
+	help
 	  Machine Check Exception support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, component failure).
 	  The action the kernel takes depends on the severity of the problem,
@@ -398,7 +702,7 @@ config X86_MCE
 
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
-	depends on X86_MCE
+	depends on X86_32 && X86_MCE
 	help
 	  Enabling this feature starts a timer that triggers every 5 seconds which
 	  will look at the machine check registers to see if anything happened.
@@ -411,13 +715,30 @@ config X86_MCE_NONFATAL
 
 config X86_MCE_P4THERMAL
 	bool "check for P4 thermal throttling interrupt."
-	depends on X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
+	depends on X86_32 && X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
 	help
 	  Enabling this feature will cause a message to be printed when the P4
 	  enters thermal throttling.
 
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
 config VM86
 	default y
+	depends on X86_32
 	bool "Enable VM86 support" if EMBEDDED
 	help
           This option is required by programs like DOSEMU to run 16-bit legacy
@@ -427,6 +748,7 @@ config VM86
 
 config TOSHIBA
 	tristate "Toshiba Laptop support"
+	depends on X86_32
 	---help---
 	  This adds a driver to safely access the System Management Mode of
 	  the CPU on Toshiba portables with a genuine Toshiba BIOS. It does
@@ -442,6 +764,7 @@ config TOSHIBA
 
 config I8K
 	tristate "Dell laptop support"
+	depends on X86_32
 	---help---
 	  This adds a driver to safely access the System Management Mode
 	  of the CPU on the Dell Inspiron 8000. The System Management Mode
@@ -463,6 +786,7 @@ config I8K
 config X86_REBOOTFIXUPS
 	bool "Enable X86 board specific fixups for reboot"
 	depends on X86
+	depends on X86_32
 	default n
 	---help---
 	  This enables chipset and/or board specific fixups to be done
@@ -517,12 +841,11 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
-source "drivers/firmware/Kconfig"
-
 choice
 	prompt "High Memory Support"
 	default HIGHMEM4G if !X86_NUMAQ
 	default HIGHMEM64G if X86_NUMAQ
+	depends on X86_32
 
 config NOHIGHMEM
 	bool "off"
@@ -579,6 +902,7 @@ config HIGHMEM64G
 endchoice
 
 choice
+	depends on X86_32
 	depends on EXPERIMENTAL
 	prompt "Memory split" if EMBEDDED
 	default VMSPLIT_3G
@@ -620,15 +944,10 @@ config PAGE_OFFSET
 	default 0x40000000 if VMSPLIT_1G
 	default 0xC0000000
 
-config HIGHMEM
-	bool
-	depends on HIGHMEM64G || HIGHMEM4G
-	default y
-
 config X86_PAE
 	bool "PAE (Physical Address Extension) Support"
 	default n
-	depends on !HIGHMEM4G
+	depends on X86_32 && !HIGHMEM4G
 	select RESOURCES_64BIT
 	help
 	  PAE is required for NX support, and furthermore enables
@@ -636,312 +955,11 @@ config X86_PAE
 	  has the cost of more pagetable lookup overhead, and also
 	  consumes more pagetable space per process.
 
-# Common NUMA Features
-config NUMA
-	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
-	depends on SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
-	default n if X86_PC
-	default y if (X86_NUMAQ || X86_SUMMIT)
-	help
-	  NUMA support for i386. This is currently highly experimental
-	  and should be only used for kernel development. It might also
-	  cause boot failures.
-
-comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
-	depends on X86_SUMMIT && (!HIGHMEM64G || !ACPI)
-
-config NODES_SHIFT
-	int
-	default "4" if X86_NUMAQ
-	default "3"
-	depends on NEED_MULTIPLE_NODES
-
-config HAVE_ARCH_BOOTMEM_NODE
-	bool
-	depends on NUMA
-	default y
-
-config ARCH_HAVE_MEMORY_PRESENT
-	bool
-	depends on DISCONTIGMEM
-	default y
-
-config NEED_NODE_MEMMAP_SIZE
-	bool
-	depends on DISCONTIGMEM || SPARSEMEM
-	default y
-
-config HAVE_ARCH_ALLOC_REMAP
-	bool
-	depends on NUMA
-	default y
-
-config ARCH_FLATMEM_ENABLE
-	def_bool y
-	depends on (ARCH_SELECT_MEMORY_MODEL && X86_PC)
-
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool y
-	depends on NUMA
-
-config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y
-	depends on NUMA
-
-config ARCH_SPARSEMEM_ENABLE
-	def_bool y
-	depends on (NUMA || (X86_PC && EXPERIMENTAL))
-	select SPARSEMEM_STATIC
-
-config ARCH_SELECT_MEMORY_MODEL
-	def_bool y
-	depends on ARCH_SPARSEMEM_ENABLE
-
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
-source "mm/Kconfig"
-
-config HIGHPTE
-	bool "Allocate 3rd-level pagetables from highmem"
-	depends on HIGHMEM4G || HIGHMEM64G
-	help
-	  The VM uses one page table entry for each page of physical memory.
-	  For systems with a lot of RAM, this can be wasteful of precious
-	  low memory.  Setting this option will put user-space page table
-	  entries in high memory.
-
-config MATH_EMULATION
-	bool "Math emulation"
-	---help---
-	  Linux can emulate a math coprocessor (used for floating point
-	  operations) if you don't have one. 486DX and Pentium processors have
-	  a math coprocessor built in, 486SX and 386 do not, unless you added
-	  a 487DX or 387, respectively. (The messages during boot time can
-	  give you some hints here ["man dmesg"].) Everyone needs either a
-	  coprocessor or this emulation.
-
-	  If you don't have a math coprocessor, you need to say Y here; if you
-	  say Y here even though you have a coprocessor, the coprocessor will
-	  be used nevertheless. (This behavior can be changed with the kernel
-	  command line option "no387", which comes handy if your coprocessor
-	  is broken. Try "man bootparam" or see the documentation of your boot
-	  loader (lilo or loadlin) about how to pass options to the kernel at
-	  boot time.) This means that it is a good idea to say Y here if you
-	  intend to use this kernel on different machines.
-
-	  More information about the internals of the Linux math coprocessor
-	  emulation can be found in <file:arch/x86/math-emu/README>.
-
-	  If you are not sure, say Y; apart from resulting in a 66 KB bigger
-	  kernel, it won't hurt.
-
-config MTRR
-	bool "MTRR (Memory Type Range Register) support"
-	---help---
-	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
-	  the Memory Type Range Registers (MTRRs) may be used to control
-	  processor access to memory ranges. This is most useful if you have
-	  a video (VGA) card on a PCI or AGP bus. Enabling write-combining
-	  allows bus write transfers to be combined into a larger transfer
-	  before bursting over the PCI/AGP bus. This can increase performance
-	  of image write operations 2.5 times or more. Saying Y here creates a
-	  /proc/mtrr file which may be used to manipulate your processor's
-	  MTRRs. Typically the X server should use this.
-
-	  This code has a reasonably generic interface so that similar
-	  control registers on other processors can be easily supported
-	  as well:
-
-	  The Cyrix 6x86, 6x86MX and M II processors have Address Range
-	  Registers (ARRs) which provide a similar functionality to MTRRs. For
-	  these, the ARRs are used to emulate the MTRRs.
-	  The AMD K6-2 (stepping 8 and above) and K6-3 processors have two
-	  MTRRs. The Centaur C6 (WinChip) has 8 MCRs, allowing
-	  write-combining. All of these processors are supported by this code
-	  and it makes sense to say Y here if you have one of them.
-
-	  Saying Y here also fixes a problem with buggy SMP BIOSes which only
-	  set the MTRRs for the boot CPU and not for the secondary CPUs. This
-	  can lead to all sorts of problems, so it's good to say Y here.
-
-	  You can safely say Y even if your machine doesn't have MTRRs, you'll
-	  just add about 9 KB to your kernel.
-
-	  See <file:Documentation/mtrr.txt> for more information.
-
-config EFI
-	bool "Boot from EFI support"
-	depends on ACPI
-	default n
-	---help---
-	This enables the kernel to boot on EFI platforms using
-	system configuration information passed to it from the firmware.
-	This also enables the kernel to use any EFI runtime services that are
-	available (such as the EFI variable services).
-
-	This option is only useful on systems that have EFI firmware
-	and will result in a kernel image that is ~8k larger.  In addition,
-	you must use the latest ELILO loader available at
-	<http://elilo.sourceforge.net> in order to take advantage of
-	kernel initialization using EFI information (neither GRUB nor LILO know
-	anything about EFI).  However, even with this option, the resultant
-	kernel should continue to boot on existing non-EFI platforms.
-
-config IRQBALANCE
- 	bool "Enable kernel irq balancing"
-	depends on SMP && X86_IO_APIC
-	default y
-	help
- 	  The default yes will allow the kernel to do irq load balancing.
-	  Saying no will keep the kernel from doing irq load balancing.
-
-# turning this on wastes a bunch of space.
-# Summit needs it only when NUMA is on
-config BOOT_IOREMAP
-	bool
-	depends on (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
-	default y
-
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
-source kernel/Kconfig.hz
-
-config KEXEC
-	bool "kexec system call"
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
-
-	  The name comes from the similarity to the exec system call.
-
-	  It is an ongoing process to be certain the hardware in a machine
-	  is properly shutdown, so do not be surprised if this code does not
-	  initially work for you.  It may help to enable device hotplugging
-	  support.  As of this writing the exact hardware interface is
-	  strongly in flux, so no good recommendation can be made.
-
-config CRASH_DUMP
-	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	depends on HIGHMEM
-	help
-	  Generate crash dump after being started by kexec.
-	  This should be normally only set in special crash dump kernels
-	  which are loaded in the main kernel with kexec-tools into
-	  a specially reserved region and then later executed after
-	  a crash by kdump/kexec. The crash dump kernel must be compiled
-	  to a memory address not used by the main kernel or BIOS using
-	  PHYSICAL_START, or it must be built as a relocatable image
-	  (CONFIG_RELOCATABLE=y).
-	  For more details see Documentation/kdump/kdump.txt
-
-config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
-	default "0x1000000" if X86_NUMAQ
-	default "0x100000"
-	help
-	  This gives the physical address where the kernel is loaded.
-
-	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
-	  bzImage will decompress itself to above physical address and
-	  run from there. Otherwise, bzImage will run from the address where
-	  it has been loaded by the boot loader and will ignore above physical
-	  address.
-
-	  In normal kdump cases one does not have to set/change this option
-	  as now bzImage can be compiled as a completely relocatable image
-	  (CONFIG_RELOCATABLE=y) and be used to load and run from a different
-	  address. This option is mainly useful for the folks who don't want
-	  to use a bzImage for capturing the crash dump and want to use a
-	  vmlinux instead. vmlinux is not relocatable hence a kernel needs
-	  to be specifically compiled to run from a specific memory area
-	  (normally a reserved region) and this option comes handy.
-
-	  So if you are using bzImage for capturing the crash dump, leave
-	  the value here unchanged to 0x100000 and set CONFIG_RELOCATABLE=y.
-	  Otherwise if you plan to use vmlinux for capturing the crash dump
-	  change this value to start of the reserved region (Typically 16MB
-	  0x1000000). In other words, it can be set based on the "X" value as
-	  specified in the "crashkernel=YM@XM" command line boot parameter
-	  passed to the panic-ed kernel. Typically this parameter is set as
-	  crashkernel=64M@16M. Please take a look at
-	  Documentation/kdump/kdump.txt for more details about crash dumps.
-
-	  Usage of bzImage for capturing the crash dump is recommended as
-	  one does not have to build two kernels. Same kernel can be used
-	  as production kernel and capture kernel. Above option should have
-	  gone away after relocatable bzImage support is introduced. But it
-	  is present because there are users out there who continue to use
-	  vmlinux for dump capture. This option should go away down the
-	  line.
-
-	  Don't change this unless you know what you are doing.
-
-config RELOCATABLE
-	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  This builds a kernel image that retains relocation information
-	  so it can be loaded someplace besides the default 1MB.
-	  The relocations tend to make the kernel binary about 10% larger,
-	  but are discarded at runtime.
-
-	  One use is for the kexec on panic case where the recovery kernel
-	  must live at a different physical address than the primary
-	  kernel.
-
-config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned"
-	default "0x100000"
-	range 0x2000 0x400000
-	help
-	  This value puts the alignment restrictions on physical address
- 	  where kernel is loaded and run from. Kernel is compiled for an
- 	  address which meets above alignment restriction.
-
- 	  If bootloader loads the kernel at a non-aligned address and
- 	  CONFIG_RELOCATABLE is set, kernel will move itself to nearest
- 	  address aligned to above value and run from there.
-
- 	  If bootloader loads the kernel at a non-aligned address and
- 	  CONFIG_RELOCATABLE is not set, kernel will ignore the run time
- 	  load address and decompress itself to the address it has been
- 	  compiled for and run from there. The address for which kernel is
- 	  compiled already meets above alignment restrictions. Hence the
- 	  end result is that kernel runs from a physical address meeting
-	  above alignment restrictions.
-
-	  Don't change this unless you know what you are doing.
-
-config HOTPLUG_CPU
-	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
-	---help---
-	  Say Y here to experiment with turning CPUs off and on, and to
-	  enable suspend on SMP systems. CPUs can be controlled through
-	  /sys/devices/system/cpu.
 
 config COMPAT_VDSO
 	bool "Compat VDSO support"
-	default y
+	depends on X86_32
+	default y if X86_32
 	help
 	  Map the VDSO to the predictable old-style address too.
 	---help---
@@ -953,11 +971,7 @@ config COMPAT_VDSO
 
 endmenu
 
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-	depends on HIGHMEM
-
-menu "Power management options (ACPI, APM)"
+menu "Power management options"
 	depends on !X86_VOYAGER
 
 source kernel/power/Kconfig
@@ -966,7 +980,7 @@ source "drivers/acpi/Kconfig"
 
 menuconfig APM
 	tristate "APM (Advanced Power Management) BIOS support"
-	depends on PM_SLEEP && !X86_VISWS
+	depends on X86_32 && PM_SLEEP && !X86_VISWS
 	---help---
 	  APM is a BIOS specification for saving power using several different
 	  techniques. This is mostly useful for battery powered laptops with
@@ -1092,13 +1106,14 @@ config APM_REAL_MODE_POWER_OFF
 
 endif # APM
 
+#TODO needs to be merged
 source "arch/x86/kernel/cpu/cpufreq/Kconfig_32"
 
 source "drivers/cpuidle/Kconfig"
 
 endmenu
 
-menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
+menu "Bus options (PCI etc.)"
 
 config PCI
 	bool "PCI support" if !X86_VISWS
@@ -1118,7 +1133,7 @@ config PCI
 
 choice
 	prompt "PCI access mode"
-	depends on PCI && !X86_VISWS
+	depends on X86_32 && PCI && !X86_VISWS
 	default PCI_GOANY
 	---help---
 	  On PCI systems, the BIOS can be used to detect the PCI devices and
@@ -1151,17 +1166,21 @@ endchoice
 
 config PCI_BIOS
 	bool
+	depends on X86_32
 	depends on !X86_VISWS && PCI && (PCI_GOBIOS || PCI_GOANY)
 	default y
 
+# x86-64 doesn't support PCI BIOS access from long mode so always go direct.
 config PCI_DIRECT
 	bool
- 	depends on PCI && ((PCI_GODIRECT || PCI_GOANY) || X86_VISWS)
+	depends on X86_64 && PCI
+ 	depends on X86_32 && PCI && ((PCI_GODIRECT || PCI_GOANY) || X86_VISWS)
 	default y
 
 config PCI_MMCONFIG
 	bool
-	depends on PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
+	prompt "Support mmconfig PCI config space access" if X86_64
+	depends on PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY || X86_64)
 	default y
 
 config PCI_DOMAINS
@@ -1169,10 +1188,44 @@ config PCI_DOMAINS
 	depends on PCI
 	default y
 
+
+config DMAR
+	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
+	depends on X86_64 && PCI_MSI && ACPI && EXPERIMENTAL
+	help
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
+	  These DMA remapping devices are reported via ACPI tables
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
+
+config DMAR_GFX_WA
+	bool "Support for Graphics workaround"
+	depends on DMAR
+	default y
+	help
+	 Current Graphics drivers tend to use physical address
+	 for DMA and avoid using DMA APIs. Setting this config
+	 option permits the IOMMU driver to set a unity map for
+	 all the OS-visible memory. Hence the driver can continue
+	 to use physical addresses for DMA.
+
+config DMAR_FLOPPY_WA
+	bool
+	depends on DMAR
+	default y
+	help
+	 Floppy disk drivers are know to bypass DMA API calls
+	 thereby failing to work when IOMMU is enabled. This
+	 workaround will setup a 1:1 mapping for the first
+	 16M to make floppy (an ISA device) work.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
 
+if X86_32
+
 config ISA_DMA_API
 	bool
 	default y
@@ -1252,22 +1305,55 @@ config K8_NB
 	def_bool y
 	depends on AGP_AMD64
 
+endif # X86_32
+
 source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
 
 endmenu
 
-menu "Executable file formats"
+menu "Executable file formats / Emulations"
 
 source "fs/Kconfig.binfmt"
 
+config IA32_EMULATION
+	bool "IA32 Emulation"
+	depends on X86_64
+	help
+	  Include code to run 32-bit programs under a 64-bit kernel. You should
+	  likely turn this on, unless you're 100% sure that you don't have any
+	  32-bit programs left.
+
+config IA32_AOUT
+	tristate "IA32 a.out support"
+	depends on IA32_EMULATION
+	help
+	  Support old a.out binaries in the 32bit emulation.
+
+config COMPAT
+	bool
+	depends on IA32_EMULATION
+	default y
+
+config COMPAT_FOR_U64_ALIGNMENT
+	def_bool COMPAT
+	depends on X86_64
+
+config SYSVIPC_COMPAT
+	bool
+	depends on COMPAT && SYSVIPC
+	depends on X86_64
+	default y
+
 endmenu
 
 source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "kernel/Kconfig.instrumentation"
@@ -1280,42 +1366,3 @@ source "crypto/Kconfig"
 
 source "lib/Kconfig"
 
-#
-# Use the generic interrupt handling code in kernel/irq/:
-#
-config GENERIC_HARDIRQS
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
-config GENERIC_PENDING_IRQ
-	bool
-	depends on GENERIC_HARDIRQS && SMP
-	default y
-
-config X86_SMP
-	bool
-	depends on SMP && !X86_VOYAGER
-	default y
-
-config X86_HT
-	bool
-	depends on SMP && !(X86_VISWS || X86_VOYAGER)
-	default y
-
-config X86_BIOS_REBOOT
-	bool
-	depends on !(X86_VISWS || X86_VOYAGER)
-	default y
-
-config X86_TRAMPOLINE
-	bool
-	depends on X86_SMP || (X86_VOYAGER && SMP)
-	default y
-
-config KTIME_SCALAR
-	bool
-	default y
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 0e2adad..1f03b2a 100644
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
@@ -100,12 +108,14 @@ config MPENTIUMIII
 
 config MPENTIUMM
 	bool "Pentium M"
+	depends on X86_32
 	help
 	  Select this for Intel Pentium M (not Pentium-4 M)
 	  notebook chips.
 
 config MCORE2
 	bool "Core 2/newer Xeon"
+	depends on X86_32
 	help
 	  Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and 53xx)
 	  CPUs. You can distinguish newer from older Xeons by the CPU family
@@ -113,6 +123,7 @@ config MCORE2
 
 config MPENTIUM4
 	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
+	depends on X86_32
 	help
 	  Select this for Intel Pentium 4 chips.  This includes the
 	  Pentium 4, Pentium D, P4-based Celeron and Xeon, and
@@ -148,6 +159,7 @@ config MPENTIUM4
 
 config MK6
 	bool "K6/K6-II/K6-III"
+	depends on X86_32
 	help
 	  Select this for an AMD K6-family processor.  Enables use of
 	  some extended instructions, and passes appropriate optimization
@@ -155,6 +167,7 @@ config MK6
 
 config MK7
 	bool "Athlon/Duron/K7"
+	depends on X86_32
 	help
 	  Select this for an AMD Athlon K7-family processor.  Enables use of
 	  some extended instructions, and passes appropriate optimization
@@ -169,6 +182,7 @@ config MK8
 
 config MCRUSOE
 	bool "Crusoe"
+	depends on X86_32
 	help
 	  Select this for a Transmeta Crusoe processor.  Treats the processor
 	  like a 586 with TSC, and sets some GCC optimization flags (like a
@@ -176,11 +190,13 @@ config MCRUSOE
 
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
@@ -188,6 +204,7 @@ config MWINCHIPC6
 
 config MWINCHIP2
 	bool "Winchip-2"
+	depends on X86_32
 	help
 	  Select this for an IDT Winchip-2.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
@@ -195,6 +212,7 @@ config MWINCHIP2
 
 config MWINCHIP3D
 	bool "Winchip-2A/Winchip-3"
+	depends on X86_32
 	help
 	  Select this for an IDT Winchip-2A or 3.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
@@ -204,16 +222,19 @@ config MWINCHIP3D
 
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
@@ -225,6 +246,7 @@ config MCYRIXIII
 
 config MVIAC3_2
 	bool "VIA C3-2 (Nehemiah)"
+	depends on X86_32
 	help
 	  Select this for a VIA C3 "Nehemiah". Selecting this enables usage
 	  of SSE and tells gcc to treat the CPU as a 686.
@@ -232,15 +254,44 @@ config MVIAC3_2
 
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
+	bool "Intel Core2 / newer Xeon"
+	depends on X86_64
+	help
+	  Optimize for Intel Core2 and newer Xeons (51xx)
+	  You can distinguish the newer Xeons from the older ones using
+	  the cpu family field in /proc/cpuinfo. 15 is an older Xeon
+	  (use CONFIG_MPSC then), 6 is a newer one.
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
@@ -253,7 +304,19 @@ endif
 
 #
 # Define implied options from the CPU selection here
-#
+# Most is only relevant for X86_32
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
 	bool
 	depends on !M386
@@ -261,7 +324,7 @@ config X86_CMPXCHG
 
 config X86_L1_CACHE_SHIFT
 	int
-	default "7" if MPENTIUM4 || X86_GENERIC
+	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
@@ -330,7 +393,7 @@ config X86_ALIGNMENT_16
 
 config X86_GOOD_APIC
 	bool
-	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7
+	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7 || X86_64
 	default y
 
 config X86_INTEL_USERCOPY
@@ -355,7 +418,7 @@ config X86_OOSTORE
 
 config X86_TSC
 	bool
-	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
+	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ || X86_64
 	default y
 
 # this should be set for all -march=.. options where the compiler
diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
dissimilarity index 92%
index 7331efe..f2d33fd 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -1,1321 +1,225 @@
-#
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
-#
-
-mainmenu "Linux Kernel Configuration"
-
-config X86_32
-	bool
-	default y
-	help
-	  This is Linux's home port.  Linux was originally native to the Intel
-	  386, and runs on all the later x86 processors including the Intel
-	  486, 586, Pentiums, and various instruction-set-compatible chips by
-	  AMD, Cyrix, and others.
-
-config GENERIC_TIME
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
-config CLOCKSOURCE_WATCHDOG
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-	default y
-	depends on X86_LOCAL_APIC
-
-config LOCKDEP_SUPPORT
-	bool
-	default y
-
-config STACKTRACE_SUPPORT
-	bool
-	default y
-
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
-
-config X86
-	bool
-	default y
-
-config MMU
-	bool
-	default y
-
-config ZONE_DMA
-	bool
-	default y
-
-config QUICKLIST
-	bool
-	default y
-
-config SBUS
-	bool
-
-config GENERIC_ISA_DMA
-	bool
-	default y
-
-config GENERIC_IOMAP
-	bool
-	default y
-
-config GENERIC_BUG
-	bool
-	default y
-	depends on BUG
-
-config GENERIC_HWEIGHT
-	bool
-	default y
-
-config ARCH_MAY_HAVE_PC_FDC
-	bool
-	default y
-
-config DMI
-	bool
-	default y
-
-source "init/Kconfig"
-
-menu "Processor type and features"
-
-source "kernel/time/Kconfig"
-
-config SMP
-	bool "Symmetric multi-processing support"
-	---help---
-	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
-
-	  If you say N here, the kernel will run on single and multiprocessor
-	  machines, but will use only one CPU of a multiprocessor machine. If
-	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
-	  will run faster if you say N here.
-
-	  Note that if you say Y here and choose architecture "586" or
-	  "Pentium" under "Processor family", the kernel will not work on 486
-	  architectures. Similarly, multiprocessor kernels for the "PPro"
-	  architecture may not work on all Pentium based boards.
-
-	  People using multiprocessor machines who say Y here should also say
-	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
-	  Management" code will be disabled if you say Y here.
-
-	  See also the <file:Documentation/smp.txt>,
-	  <file:Documentation/i386/IO-APIC.txt>,
-	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  If you don't know what to do here, say N.
-
-choice
-	prompt "Subarchitecture Type"
-	default X86_PC
-
-config X86_PC
-	bool "PC-compatible"
-	help
-	  Choose this option if your computer is a standard PC or compatible.
-
-config X86_ELAN
-	bool "AMD Elan"
-	help
-	  Select this for an AMD Elan processor.
-
-	  Do not use this option for K6/Athlon/Opteron processors!
-
-	  If unsure, choose "PC-compatible" instead.
-
-config X86_VOYAGER
-	bool "Voyager (NCR)"
-	select SMP if !BROKEN
-	help
-	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
-	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
-
-	  *** WARNING ***
-
-	  If you do not specifically know you have a Voyager based machine,
-	  say N here, otherwise the kernel you build will not be bootable.
-
-config X86_NUMAQ
-	bool "NUMAQ (IBM/Sequent)"
-	select SMP
-	select NUMA
-	help
-	  This option is used for getting Linux to run on a (IBM/Sequent) NUMA
-	  multiquad box. This changes the way that processors are bootstrapped,
-	  and uses Clustered Logical APIC addressing mode instead of Flat Logical.
-	  You will need a new lynxer.elf file to flash your firmware with - send
-	  email to <Martin.Bligh@us.ibm.com>.
-
-config X86_SUMMIT
-	bool "Summit/EXA (IBM x440)"
-	depends on SMP
-	help
-	  This option is needed for IBM systems that use the Summit/EXA chipset.
-	  In particular, it is needed for the x440.
-
-	  If you don't have one of these computers, you should say N here.
-	  If you want to build a NUMA kernel, you must select ACPI.
-
-config X86_BIGSMP
-	bool "Support for other sub-arch SMP systems with more than 8 CPUs"
-	depends on SMP
-	help
-	  This option is needed for the systems that have more than 8 CPUs
-	  and if the system is not of any sub-arch type above.
-
-	  If you don't have such a system, you should say N here.
-
-config X86_VISWS
-	bool "SGI 320/540 (Visual Workstation)"
-	help
-	  The SGI Visual Workstation series is an IA32-based workstation
-	  based on SGI systems chips with some legacy PC hardware attached.
-
-	  Say Y here to create a kernel to run on the SGI 320 or 540.
-
-	  A kernel compiled for the Visual Workstation will not run on PCs
-	  and vice versa. See <file:Documentation/sgi-visws.txt> for details.
-
-config X86_GENERICARCH
-       bool "Generic architecture (Summit, bigsmp, ES7000, default)"
-       help
-          This option compiles in the Summit, bigsmp, ES7000, default subarchitectures.
-	  It is intended for a generic binary kernel.
-	  If you want a NUMA kernel, select ACPI.   We need SRAT for NUMA.
-
-config X86_ES7000
-	bool "Support for Unisys ES7000 IA32 series"
-	depends on SMP
-	help
-	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
-	  supposed to run on an IA32-based Unisys ES7000 system.
-	  Only choose this option if you have such a system, otherwise you
-	  should say N here.
-
-endchoice
-
-config SCHED_NO_NO_OMIT_FRAME_POINTER
-	bool "Single-depth WCHAN output"
-	default y
-	help
-	  Calculate simpler /proc/<PID>/wchan values. If this option
-	  is disabled then wchan values will recurse back to the
-	  caller function. This provides more accurate wchan values,
-	  at the expense of slightly more scheduling overhead.
-
-	  If in doubt, say "Y".
-
-config PARAVIRT
-	bool
-	depends on !(X86_VISWS || X86_VOYAGER)
-	help
-	  This changes the kernel so it can modify itself when it is run
-	  under a hypervisor, potentially improving performance significantly
-	  over full virtualization.  However, when run without a hypervisor
-	  the kernel is theoretically slower and slightly larger.
-
-menuconfig PARAVIRT_GUEST
-	bool "Paravirtualized guest support"
-	help
-	  Say Y here to get to see options related to running Linux under
-	  various hypervisors.  This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if PARAVIRT_GUEST
-
-source "arch/x86/xen/Kconfig"
-
-config VMI
-	bool "VMI Guest support"
-	select PARAVIRT
-	depends on !(X86_VISWS || X86_VOYAGER)
-	help
-	  VMI provides a paravirtualized interface to the VMware ESX server
-	  (it could be used by other hypervisors in theory too, but is not
-	  at the moment), by linking the kernel to a GPL-ed ROM module
-	  provided by the hypervisor.
-
-source "arch/x86/lguest/Kconfig"
-
-endif
-
-config ACPI_SRAT
-	bool
-	default y
-	depends on ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
-	select ACPI_NUMA
-
-config HAVE_ARCH_PARSE_SRAT
-       bool
-       default y
-       depends on ACPI_SRAT
-
-config X86_SUMMIT_NUMA
-	bool
-	default y
-	depends on NUMA && (X86_SUMMIT || X86_GENERICARCH)
-
-config X86_CYCLONE_TIMER
-	bool
-	default y
-	depends on X86_SUMMIT || X86_GENERICARCH
-
-config ES7000_CLUSTERED_APIC
-	bool
-	default y
-	depends on SMP && X86_ES7000 && MPENTIUMIII
-
-source "arch/x86/Kconfig.cpu"
-
-config HPET_TIMER
-	bool "HPET Timer Support"
-	help
-	  This enables the use of the HPET for the kernel's internal timer.
-	  HPET is the next generation timer replacing legacy 8254s.
-	  You can safely choose Y here.  However, HPET will only be
-	  activated if the platform and the BIOS support this feature.
-	  Otherwise the 8254 will be used for timing services.
-
-	  Choose N to continue using the legacy 8254 timer.
-
-config HPET_EMULATE_RTC
-	bool
-	depends on HPET_TIMER && RTC=y
-	default y
-
-config NR_CPUS
-	int "Maximum number of CPUs (2-255)"
-	range 2 255
-	depends on SMP
-	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
-	default "8"
-	help
-	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 255 and the
-	  minimum value which makes sense is 2.
-
-	  This is purely to save memory - each supported CPU adds
-	  approximately eight kilobytes to the kernel image.
-
-config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on X86_HT
-	help
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with Intel Pentium 4 chips with HyperThreading at a
-	  cost of slightly increased overhead in some places. If unsure say
-	  N here.
-
-config SCHED_MC
-	bool "Multi-core scheduler support"
-	depends on X86_HT
-	default y
-	help
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
-
-source "kernel/Kconfig.preempt"
-
-config X86_UP_APIC
-	bool "Local APIC support on uniprocessors"
-	depends on !SMP && !(X86_VISWS || X86_VOYAGER || X86_GENERICARCH)
-	help
-	  A local APIC (Advanced Programmable Interrupt Controller) is an
-	  integrated interrupt controller in the CPU. If you have a single-CPU
-	  system which has a processor with a local APIC, you can say Y here to
-	  enable and use it. If you say Y here even though your machine doesn't
-	  have a local APIC, then the kernel will still run with no slowdown at
-	  all. The local APIC supports CPU-generated self-interrupts (timer,
-	  performance counters), and the NMI watchdog which detects hard
-	  lockups.
-
-config X86_UP_IOAPIC
-	bool "IO-APIC support on uniprocessors"
-	depends on X86_UP_APIC
-	help
-	  An IO-APIC (I/O Advanced Programmable Interrupt Controller) is an
-	  SMP-capable replacement for PC-style interrupt controllers. Most
-	  SMP systems and many recent uniprocessor systems have one.
-
-	  If you have a single-CPU system with an IO-APIC, you can say Y here
-	  to use it. If you say Y here even though your machine doesn't have
-	  an IO-APIC, then the kernel will still run with no slowdown at all.
-
-config X86_LOCAL_APIC
-	bool
-	depends on X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH
-	default y
-
-config X86_IO_APIC
-	bool
-	depends on X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH
-	default y
-
-config X86_VISWS_APIC
-	bool
-	depends on X86_VISWS
-	default y
-
-config X86_MCE
-	bool "Machine Check Exception"
-	depends on !X86_VOYAGER
-	---help---
-	  Machine Check Exception support allows the processor to notify the
-	  kernel if it detects a problem (e.g. overheating, component failure).
-	  The action the kernel takes depends on the severity of the problem,
-	  ranging from a warning message on the console, to halting the machine.
-	  Your processor must be a Pentium or newer to support this - check the
-	  flags in /proc/cpuinfo for mce.  Note that some older Pentium systems
-	  have a design flaw which leads to false MCE events - hence MCE is
-	  disabled on all P5 processors, unless explicitly enabled with "mce"
-	  as a boot argument.  Similarly, if MCE is built in and creates a
-	  problem on some new non-standard machine, you can boot with "nomce"
-	  to disable it.  MCE support simply ignores non-MCE processors like
-	  the 386 and 486, so nearly everyone can say Y here.
-
-config X86_MCE_NONFATAL
-	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
-	depends on X86_MCE
-	help
-	  Enabling this feature starts a timer that triggers every 5 seconds which
-	  will look at the machine check registers to see if anything happened.
-	  Non-fatal problems automatically get corrected (but still logged).
-	  Disable this if you don't want to see these messages.
-	  Seeing the messages this option prints out may be indicative of dying
-	  or out-of-spec (ie, overclocked) hardware.
-	  This option only does something on certain CPUs.
-	  (AMD Athlon/Duron and Intel Pentium 4)
-
-config X86_MCE_P4THERMAL
-	bool "check for P4 thermal throttling interrupt."
-	depends on X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
-	help
-	  Enabling this feature will cause a message to be printed when the P4
-	  enters thermal throttling.
-
-config VM86
-	default y
-	bool "Enable VM86 support" if EMBEDDED
-	help
-          This option is required by programs like DOSEMU to run 16-bit legacy
-	  code on X86 processors. It also may be needed by software like
-          XFree86 to initialize some video cards via BIOS. Disabling this
-          option saves about 6k.
-
-config TOSHIBA
-	tristate "Toshiba Laptop support"
-	---help---
-	  This adds a driver to safely access the System Management Mode of
-	  the CPU on Toshiba portables with a genuine Toshiba BIOS. It does
-	  not work on models with a Phoenix BIOS. The System Management Mode
-	  is used to set the BIOS and power saving options on Toshiba portables.
-
-	  For information on utilities to make use of this driver see the
-	  Toshiba Linux utilities web site at:
-	  <http://www.buzzard.org.uk/toshiba/>.
-
-	  Say Y if you intend to run this kernel on a Toshiba portable.
-	  Say N otherwise.
-
-config I8K
-	tristate "Dell laptop support"
-	---help---
-	  This adds a driver to safely access the System Management Mode
-	  of the CPU on the Dell Inspiron 8000. The System Management Mode
-	  is used to read cpu temperature and cooling fan status and to
-	  control the fans on the I8K portables.
-
-	  This driver has been tested only on the Inspiron 8000 but it may
-	  also work with other Dell laptops. You can force loading on other
-	  models by passing the parameter `force=1' to the module. Use at
-	  your own risk.
-
-	  For information on utilities to make use of this driver see the
-	  I8K Linux utilities web site at:
-	  <http://people.debian.org/~dz/i8k/>
-
-	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
-	  Say N otherwise.
-
-config X86_REBOOTFIXUPS
-	bool "Enable X86 board specific fixups for reboot"
-	depends on X86
-	default n
-	---help---
-	  This enables chipset and/or board specific fixups to be done
-	  in order to get reboot to work correctly. This is only needed on
-	  some combinations of hardware and BIOS. The symptom, for which
-	  this config is intended, is when reboot ends with a stalled/hung
-	  system.
-
-	  Currently, the only fixup is for the Geode machines using
-	  CS5530A and CS5536 chipsets.
-
-	  Say Y if you want to enable the fixup. Currently, it's safe to
-	  enable this option even if you don't need it.
-	  Say N otherwise.
-
-config MICROCODE
-	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
-	select FW_LOADER
-	---help---
-	  If you say Y here, you will be able to update the microcode on
-	  Intel processors in the IA32 family, e.g. Pentium Pro, Pentium II,
-	  Pentium III, Pentium 4, Xeon etc.  You will obviously need the
-	  actual microcode binary data itself which is not shipped with the
-	  Linux kernel.
-
-	  For latest news and information on obtaining all the required
-	  ingredients for this driver, check:
-	  <http://www.urbanmyth.org/microcode/>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called microcode.
-
-config MICROCODE_OLD_INTERFACE
-	bool
-	depends on MICROCODE
-	default y
-
-config X86_MSR
-	tristate "/dev/cpu/*/msr - Model-specific register support"
-	help
-	  This device gives privileged processes access to the x86
-	  Model-Specific Registers (MSRs).  It is a character device with
-	  major 202 and minors 0 to 31 for /dev/cpu/0/msr to /dev/cpu/31/msr.
-	  MSR accesses are directed to a specific CPU on multi-processor
-	  systems.
-
-config X86_CPUID
-	tristate "/dev/cpu/*/cpuid - CPU information support"
-	help
-	  This device gives processes access to the x86 CPUID instruction to
-	  be executed on a specific processor.  It is a character device
-	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
-	  /dev/cpu/31/cpuid.
-
-source "drivers/firmware/Kconfig"
-
-choice
-	prompt "High Memory Support"
-	default HIGHMEM4G if !X86_NUMAQ
-	default HIGHMEM64G if X86_NUMAQ
-
-config NOHIGHMEM
-	bool "off"
-	depends on !X86_NUMAQ
-	---help---
-	  Linux can use up to 64 Gigabytes of physical memory on x86 systems.
-	  However, the address space of 32-bit x86 processors is only 4
-	  Gigabytes large. That means that, if you have a large amount of
-	  physical memory, not all of it can be "permanently mapped" by the
-	  kernel. The physical memory that's not permanently mapped is called
-	  "high memory".
-
-	  If you are compiling a kernel which will never run on a machine with
-	  more than 1 Gigabyte total physical RAM, answer "off" here (default
-	  choice and suitable for most users). This will result in a "3GB/1GB"
-	  split: 3GB are mapped so that each process sees a 3GB virtual memory
-	  space and the remaining part of the 4GB virtual memory space is used
-	  by the kernel to permanently map as much physical memory as
-	  possible.
-
-	  If the machine has between 1 and 4 Gigabytes physical RAM, then
-	  answer "4GB" here.
-
-	  If more than 4 Gigabytes is used then answer "64GB" here. This
-	  selection turns Intel PAE (Physical Address Extension) mode on.
-	  PAE implements 3-level paging on IA32 processors. PAE is fully
-	  supported by Linux, PAE mode is implemented on all recent Intel
-	  processors (Pentium Pro and better). NOTE: If you say "64GB" here,
-	  then the kernel will not boot on CPUs that don't support PAE!
-
-	  The actual amount of total physical memory will either be
-	  auto detected or can be forced by using a kernel command line option
-	  such as "mem=256M". (Try "man bootparam" or see the documentation of
-	  your boot loader (lilo or loadlin) about how to pass options to the
-	  kernel at boot time.)
-
-	  If unsure, say "off".
-
-config HIGHMEM4G
-	bool "4GB"
-	depends on !X86_NUMAQ
-	help
-	  Select this if you have a 32-bit processor and between 1 and 4
-	  gigabytes of physical RAM.
-
-config HIGHMEM64G
-	bool "64GB"
-	depends on !M386 && !M486
-	select X86_PAE
-	help
-	  Select this if you have a 32-bit processor and more than 4
-	  gigabytes of physical RAM.
-
-endchoice
-
-choice
-	depends on EXPERIMENTAL
-	prompt "Memory split" if EMBEDDED
-	default VMSPLIT_3G
-	help
-	  Select the desired split between kernel and user memory.
-
-	  If the address range available to the kernel is less than the
-	  physical memory installed, the remaining memory will be available
-	  as "high memory". Accessing high memory is a little more costly
-	  than low memory, as it needs to be mapped into the kernel first.
-	  Note that increasing the kernel address space limits the range
-	  available to user programs, making the address space there
-	  tighter.  Selecting anything other than the default 3G/1G split
-	  will also likely make your kernel incompatible with binary-only
-	  kernel modules.
-
-	  If you are not absolutely sure what you are doing, leave this
-	  option alone!
-
-	config VMSPLIT_3G
-		bool "3G/1G user/kernel split"
-	config VMSPLIT_3G_OPT
-		depends on !X86_PAE
-		bool "3G/1G user/kernel split (for full 1G low memory)"
-	config VMSPLIT_2G
-		bool "2G/2G user/kernel split"
-	config VMSPLIT_2G_OPT
-		depends on !X86_PAE
-		bool "2G/2G user/kernel split (for full 2G low memory)"
-	config VMSPLIT_1G
-		bool "1G/3G user/kernel split"
-endchoice
-
-config PAGE_OFFSET
-	hex
-	default 0xB0000000 if VMSPLIT_3G_OPT
-	default 0x80000000 if VMSPLIT_2G
-	default 0x78000000 if VMSPLIT_2G_OPT
-	default 0x40000000 if VMSPLIT_1G
-	default 0xC0000000
-
-config HIGHMEM
-	bool
-	depends on HIGHMEM64G || HIGHMEM4G
-	default y
-
-config X86_PAE
-	bool "PAE (Physical Address Extension) Support"
-	default n
-	depends on !HIGHMEM4G
-	select RESOURCES_64BIT
-	help
-	  PAE is required for NX support, and furthermore enables
-	  larger swapspace support for non-overcommit purposes. It
-	  has the cost of more pagetable lookup overhead, and also
-	  consumes more pagetable space per process.
-
-# Common NUMA Features
-config NUMA
-	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
-	depends on SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
-	default n if X86_PC
-	default y if (X86_NUMAQ || X86_SUMMIT)
-	help
-	  NUMA support for i386. This is currently highly experimental
-	  and should be only used for kernel development. It might also
-	  cause boot failures.
-
-comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
-	depends on X86_SUMMIT && (!HIGHMEM64G || !ACPI)
-
-config NODES_SHIFT
-	int
-	default "4" if X86_NUMAQ
-	default "3"
-	depends on NEED_MULTIPLE_NODES
-
-config HAVE_ARCH_BOOTMEM_NODE
-	bool
-	depends on NUMA
-	default y
-
-config ARCH_HAVE_MEMORY_PRESENT
-	bool
-	depends on DISCONTIGMEM
-	default y
-
-config NEED_NODE_MEMMAP_SIZE
-	bool
-	depends on DISCONTIGMEM || SPARSEMEM
-	default y
-
-config HAVE_ARCH_ALLOC_REMAP
-	bool
-	depends on NUMA
-	default y
-
-config ARCH_FLATMEM_ENABLE
-	def_bool y
-	depends on (ARCH_SELECT_MEMORY_MODEL && X86_PC)
-
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool y
-	depends on NUMA
-
-config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y
-	depends on NUMA
-
-config ARCH_SPARSEMEM_ENABLE
-	def_bool y
-	depends on (NUMA || (X86_PC && EXPERIMENTAL))
-	select SPARSEMEM_STATIC
-
-config ARCH_SELECT_MEMORY_MODEL
-	def_bool y
-	depends on ARCH_SPARSEMEM_ENABLE
-
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
-source "mm/Kconfig"
-
-config HIGHPTE
-	bool "Allocate 3rd-level pagetables from highmem"
-	depends on HIGHMEM4G || HIGHMEM64G
-	help
-	  The VM uses one page table entry for each page of physical memory.
-	  For systems with a lot of RAM, this can be wasteful of precious
-	  low memory.  Setting this option will put user-space page table
-	  entries in high memory.
-
-config MATH_EMULATION
-	bool "Math emulation"
-	---help---
-	  Linux can emulate a math coprocessor (used for floating point
-	  operations) if you don't have one. 486DX and Pentium processors have
-	  a math coprocessor built in, 486SX and 386 do not, unless you added
-	  a 487DX or 387, respectively. (The messages during boot time can
-	  give you some hints here ["man dmesg"].) Everyone needs either a
-	  coprocessor or this emulation.
-
-	  If you don't have a math coprocessor, you need to say Y here; if you
-	  say Y here even though you have a coprocessor, the coprocessor will
-	  be used nevertheless. (This behavior can be changed with the kernel
-	  command line option "no387", which comes handy if your coprocessor
-	  is broken. Try "man bootparam" or see the documentation of your boot
-	  loader (lilo or loadlin) about how to pass options to the kernel at
-	  boot time.) This means that it is a good idea to say Y here if you
-	  intend to use this kernel on different machines.
-
-	  More information about the internals of the Linux math coprocessor
-	  emulation can be found in <file:arch/x86/math-emu/README>.
-
-	  If you are not sure, say Y; apart from resulting in a 66 KB bigger
-	  kernel, it won't hurt.
-
-config MTRR
-	bool "MTRR (Memory Type Range Register) support"
-	---help---
-	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
-	  the Memory Type Range Registers (MTRRs) may be used to control
-	  processor access to memory ranges. This is most useful if you have
-	  a video (VGA) card on a PCI or AGP bus. Enabling write-combining
-	  allows bus write transfers to be combined into a larger transfer
-	  before bursting over the PCI/AGP bus. This can increase performance
-	  of image write operations 2.5 times or more. Saying Y here creates a
-	  /proc/mtrr file which may be used to manipulate your processor's
-	  MTRRs. Typically the X server should use this.
-
-	  This code has a reasonably generic interface so that similar
-	  control registers on other processors can be easily supported
-	  as well:
-
-	  The Cyrix 6x86, 6x86MX and M II processors have Address Range
-	  Registers (ARRs) which provide a similar functionality to MTRRs. For
-	  these, the ARRs are used to emulate the MTRRs.
-	  The AMD K6-2 (stepping 8 and above) and K6-3 processors have two
-	  MTRRs. The Centaur C6 (WinChip) has 8 MCRs, allowing
-	  write-combining. All of these processors are supported by this code
-	  and it makes sense to say Y here if you have one of them.
-
-	  Saying Y here also fixes a problem with buggy SMP BIOSes which only
-	  set the MTRRs for the boot CPU and not for the secondary CPUs. This
-	  can lead to all sorts of problems, so it's good to say Y here.
-
-	  You can safely say Y even if your machine doesn't have MTRRs, you'll
-	  just add about 9 KB to your kernel.
-
-	  See <file:Documentation/mtrr.txt> for more information.
-
-config EFI
-	bool "Boot from EFI support"
-	depends on ACPI
-	default n
-	---help---
-	This enables the kernel to boot on EFI platforms using
-	system configuration information passed to it from the firmware.
-	This also enables the kernel to use any EFI runtime services that are
-	available (such as the EFI variable services).
-
-	This option is only useful on systems that have EFI firmware
-	and will result in a kernel image that is ~8k larger.  In addition,
-	you must use the latest ELILO loader available at
-	<http://elilo.sourceforge.net> in order to take advantage of
-	kernel initialization using EFI information (neither GRUB nor LILO know
-	anything about EFI).  However, even with this option, the resultant
-	kernel should continue to boot on existing non-EFI platforms.
-
-config IRQBALANCE
- 	bool "Enable kernel irq balancing"
-	depends on SMP && X86_IO_APIC
-	default y
-	help
- 	  The default yes will allow the kernel to do irq load balancing.
-	  Saying no will keep the kernel from doing irq load balancing.
-
-# turning this on wastes a bunch of space.
-# Summit needs it only when NUMA is on
-config BOOT_IOREMAP
-	bool
-	depends on (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
-	default y
-
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
-source kernel/Kconfig.hz
-
-config KEXEC
-	bool "kexec system call"
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
-
-	  The name comes from the similarity to the exec system call.
-
-	  It is an ongoing process to be certain the hardware in a machine
-	  is properly shutdown, so do not be surprised if this code does not
-	  initially work for you.  It may help to enable device hotplugging
-	  support.  As of this writing the exact hardware interface is
-	  strongly in flux, so no good recommendation can be made.
-
-config CRASH_DUMP
-	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	depends on HIGHMEM
-	help
-	  Generate crash dump after being started by kexec.
-	  This should be normally only set in special crash dump kernels
-	  which are loaded in the main kernel with kexec-tools into
-	  a specially reserved region and then later executed after
-	  a crash by kdump/kexec. The crash dump kernel must be compiled
-	  to a memory address not used by the main kernel or BIOS using
-	  PHYSICAL_START, or it must be built as a relocatable image
-	  (CONFIG_RELOCATABLE=y).
-	  For more details see Documentation/kdump/kdump.txt
-
-config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
-	default "0x1000000" if X86_NUMAQ
-	default "0x100000"
-	help
-	  This gives the physical address where the kernel is loaded.
-
-	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
-	  bzImage will decompress itself to above physical address and
-	  run from there. Otherwise, bzImage will run from the address where
-	  it has been loaded by the boot loader and will ignore above physical
-	  address.
-
-	  In normal kdump cases one does not have to set/change this option
-	  as now bzImage can be compiled as a completely relocatable image
-	  (CONFIG_RELOCATABLE=y) and be used to load and run from a different
-	  address. This option is mainly useful for the folks who don't want
-	  to use a bzImage for capturing the crash dump and want to use a
-	  vmlinux instead. vmlinux is not relocatable hence a kernel needs
-	  to be specifically compiled to run from a specific memory area
-	  (normally a reserved region) and this option comes handy.
-
-	  So if you are using bzImage for capturing the crash dump, leave
-	  the value here unchanged to 0x100000 and set CONFIG_RELOCATABLE=y.
-	  Otherwise if you plan to use vmlinux for capturing the crash dump
-	  change this value to start of the reserved region (Typically 16MB
-	  0x1000000). In other words, it can be set based on the "X" value as
-	  specified in the "crashkernel=YM@XM" command line boot parameter
-	  passed to the panic-ed kernel. Typically this parameter is set as
-	  crashkernel=64M@16M. Please take a look at
-	  Documentation/kdump/kdump.txt for more details about crash dumps.
-
-	  Usage of bzImage for capturing the crash dump is recommended as
-	  one does not have to build two kernels. Same kernel can be used
-	  as production kernel and capture kernel. Above option should have
-	  gone away after relocatable bzImage support is introduced. But it
-	  is present because there are users out there who continue to use
-	  vmlinux for dump capture. This option should go away down the
-	  line.
-
-	  Don't change this unless you know what you are doing.
-
-config RELOCATABLE
-	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  This builds a kernel image that retains relocation information
-	  so it can be loaded someplace besides the default 1MB.
-	  The relocations tend to make the kernel binary about 10% larger,
-	  but are discarded at runtime.
-
-	  One use is for the kexec on panic case where the recovery kernel
-	  must live at a different physical address than the primary
-	  kernel.
-
-config PHYSICAL_ALIGN
-	hex "Alignment value to which kernel should be aligned"
-	default "0x100000"
-	range 0x2000 0x400000
-	help
-	  This value puts the alignment restrictions on physical address
- 	  where kernel is loaded and run from. Kernel is compiled for an
- 	  address which meets above alignment restriction.
-
- 	  If bootloader loads the kernel at a non-aligned address and
- 	  CONFIG_RELOCATABLE is set, kernel will move itself to nearest
- 	  address aligned to above value and run from there.
-
- 	  If bootloader loads the kernel at a non-aligned address and
- 	  CONFIG_RELOCATABLE is not set, kernel will ignore the run time
- 	  load address and decompress itself to the address it has been
- 	  compiled for and run from there. The address for which kernel is
- 	  compiled already meets above alignment restrictions. Hence the
- 	  end result is that kernel runs from a physical address meeting
-	  above alignment restrictions.
-
-	  Don't change this unless you know what you are doing.
-
-config HOTPLUG_CPU
-	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
-	---help---
-	  Say Y here to experiment with turning CPUs off and on, and to
-	  enable suspend on SMP systems. CPUs can be controlled through
-	  /sys/devices/system/cpu.
-
-config COMPAT_VDSO
-	bool "Compat VDSO support"
-	default y
-	help
-	  Map the VDSO to the predictable old-style address too.
-	---help---
-	  Say N here if you are running a sufficiently recent glibc
-	  version (2.3.3 or later), to remove the high-mapped
-	  VDSO mapping and to exclusively use the randomized VDSO.
-
-	  If unsure, say Y.
-
-endmenu
-
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-	depends on HIGHMEM
-
-menu "Power management options (ACPI, APM)"
-	depends on !X86_VOYAGER
-
-source kernel/power/Kconfig
-
-source "drivers/acpi/Kconfig"
-
-menuconfig APM
-	tristate "APM (Advanced Power Management) BIOS support"
-	depends on PM_SLEEP && !X86_VISWS
-	---help---
-	  APM is a BIOS specification for saving power using several different
-	  techniques. This is mostly useful for battery powered laptops with
-	  APM compliant BIOSes. If you say Y here, the system time will be
-	  reset after a RESUME operation, the /proc/apm device will provide
-	  battery status information, and user-space programs will receive
-	  notification of APM "events" (e.g. battery status change).
-
-	  If you select "Y" here, you can disable actual use of the APM
-	  BIOS by passing the "apm=off" option to the kernel at boot time.
-
-	  Note that the APM support is almost completely disabled for
-	  machines with more than one CPU.
-
-	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/pm.txt> and the
-	  Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver does not spin down disk drives (see the hdparm(8)
-	  manpage ("man 8 hdparm") for that), and it doesn't turn off
-	  VESA-compliant "green" monitors.
-
-	  This driver does not support the TI 4000M TravelMate and the ACER
-	  486/DX4/75 because they don't have compliant BIOSes. Many "green"
-	  desktop machines also don't have compliant BIOSes, and this driver
-	  may cause those machines to panic during the boot phase.
-
-	  Generally, if you don't have a battery in your machine, there isn't
-	  much point in using this driver and you should say N. If you get
-	  random kernel OOPSes or reboots that don't seem to be related to
-	  anything, try disabling/enabling this option (or disabling/enabling
-	  APM in your BIOS).
-
-	  Some other things you should try when experiencing seemingly random,
-	  "weird" problems:
-
-	  1) make sure that you have enough swap space and that it is
-	  enabled.
-	  2) pass the "no-hlt" option to the kernel
-	  3) switch on floating point emulation in the kernel and pass
-	  the "no387" option to the kernel
-	  4) pass the "floppy=nodma" option to the kernel
-	  5) pass the "mem=4M" option to the kernel (thereby disabling
-	  all but the first 4 MB of RAM)
-	  6) make sure that the CPU is not over clocked.
-	  7) read the sig11 FAQ at <http://www.bitwizard.nl/sig11/>
-	  8) disable the cache from your BIOS settings
-	  9) install a fan for the video card or exchange video RAM
-	  10) install a better fan for the CPU
-	  11) exchange RAM chips
-	  12) exchange the motherboard.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called apm.
-
-if APM
-
-config APM_IGNORE_USER_SUSPEND
-	bool "Ignore USER SUSPEND"
-	help
-	  This option will ignore USER SUSPEND requests. On machines with a
-	  compliant APM BIOS, you want to say N. However, on the NEC Versa M
-	  series notebooks, it is necessary to say Y because of a BIOS bug.
-
-config APM_DO_ENABLE
-	bool "Enable PM at boot time"
-	---help---
-	  Enable APM features at boot time. From page 36 of the APM BIOS
-	  specification: "When disabled, the APM BIOS does not automatically
-	  power manage devices, enter the Standby State, enter the Suspend
-	  State, or take power saving steps in response to CPU Idle calls."
-	  This driver will make CPU Idle calls when Linux is idle (unless this
-	  feature is turned off -- see "Do CPU IDLE calls", below). This
-	  should always save battery power, but more complicated APM features
-	  will be dependent on your BIOS implementation. You may need to turn
-	  this option off if your computer hangs at boot time when using APM
-	  support, or if it beeps continuously instead of suspending. Turn
-	  this off if you have a NEC UltraLite Versa 33/C or a Toshiba
-	  T400CDT. This is off by default since most machines do fine without
-	  this feature.
-
-config APM_CPU_IDLE
-	bool "Make CPU Idle calls when idle"
-	help
-	  Enable calls to APM CPU Idle/CPU Busy inside the kernel's idle loop.
-	  On some machines, this can activate improved power savings, such as
-	  a slowed CPU clock rate, when the machine is idle. These idle calls
-	  are made after the idle loop has run for some length of time (e.g.,
-	  333 mS). On some machines, this will cause a hang at boot time or
-	  whenever the CPU becomes idle. (On machines with more than one CPU,
-	  this option does nothing.)
-
-config APM_DISPLAY_BLANK
-	bool "Enable console blanking using APM"
-	help
-	  Enable console blanking using the APM. Some laptops can use this to
-	  turn off the LCD backlight when the screen blanker of the Linux
-	  virtual console blanks the screen. Note that this is only used by
-	  the virtual console screen blanker, and won't turn off the backlight
-	  when using the X Window system. This also doesn't have anything to
-	  do with your VESA-compliant power-saving monitor. Further, this
-	  option doesn't work for all laptops -- it might not turn off your
-	  backlight at all, or it might print a lot of errors to the console,
-	  especially if you are using gpm.
-
-config APM_ALLOW_INTS
-	bool "Allow interrupts during APM BIOS calls"
-	help
-	  Normally we disable external interrupts while we are making calls to
-	  the APM BIOS as a measure to lessen the effects of a badly behaving
-	  BIOS implementation.  The BIOS should reenable interrupts if it
-	  needs to.  Unfortunately, some BIOSes do not -- especially those in
-	  many of the newer IBM Thinkpads.  If you experience hangs when you
-	  suspend, try setting this to Y.  Otherwise, say N.
-
-config APM_REAL_MODE_POWER_OFF
-	bool "Use real mode APM BIOS call to power off"
-	help
-	  Use real mode APM BIOS calls to switch off the computer. This is
-	  a work-around for a number of buggy BIOSes. Switch this option on if
-	  your computer crashes instead of powering off properly.
-
-endif # APM
-
-source "arch/x86/kernel/cpu/cpufreq/Kconfig_32"
-
-source "drivers/cpuidle/Kconfig"
-
-endmenu
-
-menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
-
-config PCI
-	bool "PCI support" if !X86_VISWS
-	depends on !X86_VOYAGER
-	default y if X86_VISWS
-	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
-	help
-	  Find out whether you have a PCI motherboard. PCI is the name of a
-	  bus system, i.e. the way the CPU talks to the other stuff inside
-	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
-	  VESA. If you have PCI, say Y, otherwise N.
-
-	  The PCI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, contains valuable
-	  information about which PCI hardware does work under Linux and which
-	  doesn't.
-
-choice
-	prompt "PCI access mode"
-	depends on PCI && !X86_VISWS
-	default PCI_GOANY
-	---help---
-	  On PCI systems, the BIOS can be used to detect the PCI devices and
-	  determine their configuration. However, some old PCI motherboards
-	  have BIOS bugs and may crash if this is done. Also, some embedded
-	  PCI-based systems don't have any BIOS at all. Linux can also try to
-	  detect the PCI hardware directly without using the BIOS.
-
-	  With this option, you can specify how Linux should detect the
-	  PCI devices. If you choose "BIOS", the BIOS will be used,
-	  if you choose "Direct", the BIOS won't be used, and if you
-	  choose "MMConfig", then PCI Express MMCONFIG will be used.
-	  If you choose "Any", the kernel will try MMCONFIG, then the
-	  direct access method and falls back to the BIOS if that doesn't
-	  work. If unsure, go with the default, which is "Any".
-
-config PCI_GOBIOS
-	bool "BIOS"
-
-config PCI_GOMMCONFIG
-	bool "MMConfig"
-
-config PCI_GODIRECT
-	bool "Direct"
-
-config PCI_GOANY
-	bool "Any"
-
-endchoice
-
-config PCI_BIOS
-	bool
-	depends on !X86_VISWS && PCI && (PCI_GOBIOS || PCI_GOANY)
-	default y
-
-config PCI_DIRECT
-	bool
- 	depends on PCI && ((PCI_GODIRECT || PCI_GOANY) || X86_VISWS)
-	default y
-
-config PCI_MMCONFIG
-	bool
-	depends on PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
-	default y
-
-config PCI_DOMAINS
-	bool
-	depends on PCI
-	default y
-
-source "drivers/pci/pcie/Kconfig"
-
-source "drivers/pci/Kconfig"
-
-config ISA_DMA_API
-	bool
-	default y
-
-config ISA
-	bool "ISA support"
-	depends on !(X86_VOYAGER || X86_VISWS)
-	help
-	  Find out whether you have ISA slots on your motherboard.  ISA is the
-	  name of a bus system, i.e. the way the CPU talks to the other stuff
-	  inside your box.  Other bus systems are PCI, EISA, MicroChannel
-	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
-	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
-
-config EISA
-	bool "EISA support"
-	depends on ISA
-	---help---
-	  The Extended Industry Standard Architecture (EISA) bus was
-	  developed as an open alternative to the IBM MicroChannel bus.
-
-	  The EISA bus provided some of the features of the IBM MicroChannel
-	  bus while maintaining backward compatibility with cards made for
-	  the older ISA bus.  The EISA bus saw limited use between 1988 and
-	  1995 when it was made obsolete by the PCI bus.
-
-	  Say Y here if you are building a kernel for an EISA-based machine.
-
-	  Otherwise, say N.
-
-source "drivers/eisa/Kconfig"
-
-config MCA
-	bool "MCA support" if !(X86_VISWS || X86_VOYAGER)
-	default y if X86_VOYAGER
-	help
-	  MicroChannel Architecture is found in some IBM PS/2 machines and
-	  laptops.  It is a bus system similar to PCI or ISA. See
-	  <file:Documentation/mca.txt> (and especially the web page given
-	  there) before attempting to build an MCA bus kernel.
-
-source "drivers/mca/Kconfig"
-
-config SCx200
-	tristate "NatSemi SCx200 support"
-	depends on !X86_VOYAGER
-	help
-	  This provides basic support for National Semiconductor's
-	  (now AMD's) Geode processors.  The driver probes for the
-	  PCI-IDs of several on-chip devices, so its a good dependency
-	  for other scx200_* drivers.
-
-	  If compiled as a module, the driver is named scx200.
-
-config SCx200HR_TIMER
-	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
-	default y
-	help
-	  This driver provides a clocksource built upon the on-chip
-	  27MHz high-resolution timer.  Its also a workaround for
-	  NSC Geode SC-1100's buggy TSC, which loses time when the
-	  processor goes idle (as is done by the scheduler).  The
-	  other workaround is idle=poll boot option.
-
-config GEODE_MFGPT_TIMER
-	bool "Geode Multi-Function General Purpose Timer (MFGPT) events"
-	depends on MGEODE_LX && GENERIC_TIME && GENERIC_CLOCKEVENTS
-	default y
-	help
-	  This driver provides a clock event source based on the MFGPT
-	  timer(s) in the CS5535 and CS5536 companion chip for the geode.
-	  MFGPTs have a better resolution and max interval than the
-	  generic PIT, and are suitable for use as high-res timers.
-
-config K8_NB
-	def_bool y
-	depends on AGP_AMD64
-
-source "drivers/pcmcia/Kconfig"
-
-source "drivers/pci/hotplug/Kconfig"
-
-endmenu
-
-menu "Executable file formats"
-
-source "fs/Kconfig.binfmt"
-
-endmenu
-
-source "net/Kconfig"
-
-source "drivers/Kconfig"
-
-source "fs/Kconfig"
-
-source "kernel/Kconfig.instrumentation"
-
-source "arch/x86/Kconfig.debug"
-
-source "security/Kconfig"
-
-source "crypto/Kconfig"
-
-source "lib/Kconfig"
-
-#
-# Use the generic interrupt handling code in kernel/irq/:
-#
-config GENERIC_HARDIRQS
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
-config GENERIC_PENDING_IRQ
-	bool
-	depends on GENERIC_HARDIRQS && SMP
-	default y
-
-config X86_SMP
-	bool
-	depends on SMP && !X86_VOYAGER
-	default y
-
-config X86_HT
-	bool
-	depends on SMP && !(X86_VISWS || X86_VOYAGER)
-	default y
-
-config X86_BIOS_REBOOT
-	bool
-	depends on !(X86_VISWS || X86_VOYAGER)
-	default y
-
-config X86_TRAMPOLINE
-	bool
-	depends on X86_SMP || (X86_VOYAGER && SMP)
-	default y
-
-config KTIME_SCALAR
-	bool
-	default y
+# i386 specific configuration
+
+if X86_32
+config GENERIC_TIME
+	bool
+	default y
+
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
+config CLOCKSOURCE_WATCHDOG
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	default y
+	depends on X86_LOCAL_APIC
+
+config LOCKDEP_SUPPORT
+	bool
+	default y
+
+config STACKTRACE_SUPPORT
+	bool
+	default y
+
+config SEMAPHORE_SLEEPERS
+	bool
+	default y
+
+config X86
+	bool
+	default y
+
+config MMU
+	bool
+	default y
+
+config ZONE_DMA
+	bool
+	default y
+
+config QUICKLIST
+	bool
+	default y
+
+config SBUS
+	bool
+
+config GENERIC_ISA_DMA
+	bool
+	default y
+
+config GENERIC_IOMAP
+	bool
+	default y
+
+config GENERIC_BUG
+	bool
+	default y
+	depends on BUG
+
+config GENERIC_HWEIGHT
+	bool
+	default y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+	default y
+
+config DMI
+	bool
+	default y
+
+
+config ACPI_SRAT
+	bool
+	default y
+	depends on ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
+	select ACPI_NUMA
+
+config HAVE_ARCH_PARSE_SRAT
+       bool
+       default y
+       depends on ACPI_SRAT
+
+config X86_SUMMIT_NUMA
+	bool
+	default y
+	depends on NUMA && (X86_SUMMIT || X86_GENERICARCH)
+
+config X86_CYCLONE_TIMER
+	bool
+	default y
+	depends on X86_SUMMIT || X86_GENERICARCH
+
+config ES7000_CLUSTERED_APIC
+	bool
+	default y
+	depends on SMP && X86_ES7000 && MPENTIUMIII
+
+
+config X86_LOCAL_APIC
+	bool
+	depends on X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH
+	default y
+
+config X86_IO_APIC
+	bool
+	depends on X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH
+	default y
+
+config X86_VISWS_APIC
+	bool
+	depends on X86_VISWS
+	default y
+
+config HIGHMEM
+	bool
+	depends on HIGHMEM64G || HIGHMEM4G
+	default y
+
+config HAVE_ARCH_BOOTMEM_NODE
+	bool
+	depends on NUMA
+	default y
+
+config ARCH_HAVE_MEMORY_PRESENT
+	bool
+	depends on DISCONTIGMEM
+	default y
+
+config NEED_NODE_MEMMAP_SIZE
+	bool
+	depends on DISCONTIGMEM || SPARSEMEM
+	default y
+
+config HAVE_ARCH_ALLOC_REMAP
+	bool
+	depends on NUMA
+	default y
+
+config ARCH_FLATMEM_ENABLE
+	def_bool y
+	depends on (ARCH_SELECT_MEMORY_MODEL && X86_PC)
+
+config ARCH_DISCONTIGMEM_ENABLE
+	def_bool y
+	depends on NUMA
+
+config ARCH_DISCONTIGMEM_DEFAULT
+	def_bool y
+	depends on NUMA
+
+config ARCH_SPARSEMEM_ENABLE
+	def_bool y
+	depends on (NUMA || (X86_PC && EXPERIMENTAL))
+	select SPARSEMEM_STATIC
+
+config ARCH_SELECT_MEMORY_MODEL
+	def_bool y
+	depends on ARCH_SPARSEMEM_ENABLE
+
+config ARCH_POPULATES_NODE_MAP
+	def_bool y
+
+# turning this on wastes a bunch of space.
+# Summit needs it only when NUMA is on
+config BOOT_IOREMAP
+	bool
+	depends on (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
+	default y
+
+config ARCH_ENABLE_MEMORY_HOTPLUG
+	def_bool y
+	depends on HIGHMEM
+
+
+#
+# Use the generic interrupt handling code in kernel/irq/:
+#
+config GENERIC_HARDIRQS
+	bool
+	default y
+
+config GENERIC_IRQ_PROBE
+	bool
+	default y
+
+config GENERIC_PENDING_IRQ
+	bool
+	depends on GENERIC_HARDIRQS && SMP
+	default y
+
+config X86_SMP
+	bool
+	depends on SMP && !X86_VOYAGER
+	default y
+
+config X86_HT
+	bool
+	depends on SMP && !(X86_VISWS || X86_VOYAGER)
+	default y
+
+config X86_BIOS_REBOOT
+	bool
+	depends on !(X86_VISWS || X86_VOYAGER)
+	default y
+
+config X86_TRAMPOLINE
+	bool
+	depends on X86_SMP || (X86_VOYAGER && SMP)
+	default y
+
+config KTIME_SCALAR
+	bool
+	default y
+
+endif # if X86_32
diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
dissimilarity index 88%
index cc468ea..111d671 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -1,839 +1,212 @@
-#
-# For a description of the syntax of this configuration file,
-# see Documentation/kbuild/kconfig-language.txt.
-#
-# Note: ISA is disabled and will hopefully never be enabled.
-# If you managed to buy an ISA x86-64 box you'll have to fix all the
-# ISA drivers you need yourself.
-#
-
-mainmenu "Linux Kernel Configuration"
-
-config X86_64
-	bool
-	default y
-	help
-	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
-	  classical 32-bit x86 architecture. For details see
-	  <http://www.x86-64.org/>.
-
-config 64BIT
-	def_bool y
-
-config X86
-	bool
-	default y
-
-config GENERIC_TIME
-	bool
-	default y
-
-config GENERIC_TIME_VSYSCALL
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
-config CLOCKSOURCE_WATCHDOG
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-	default y
-
-config ZONE_DMA32
-	bool
-	default y
-
-config LOCKDEP_SUPPORT
-	bool
-	default y
-
-config STACKTRACE_SUPPORT
-	bool
-	default y
-
-config SEMAPHORE_SLEEPERS
-	bool
-	default y
-
-config MMU
-	bool
-	default y
-
-config ZONE_DMA
-	bool
-	default y
-
-config ISA
-	bool
-
-config SBUS
-	bool
-
-config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
-
-config RWSEM_XCHGADD_ALGORITHM
-	bool
-
-config GENERIC_HWEIGHT
-	bool
-	default y
-
-config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
-
-config X86_CMPXCHG
-	bool
-	default y
-
-config GENERIC_ISA_DMA
-	bool
-	default y
-
-config GENERIC_IOMAP
-	bool
-	default y
-
-config ARCH_MAY_HAVE_PC_FDC
-	bool
-	default y
-
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
-config DMI
-	bool
-	default y
-
-config AUDIT_ARCH
-	bool
-	default y
-
-config GENERIC_BUG
-	bool
-	default y
-	depends on BUG
-
-config ARCH_HAS_ILOG2_U32
-	bool
-	default n
-
-config ARCH_HAS_ILOG2_U64
-	bool
-	default n
-
-source "init/Kconfig"
-
-
-menu "Processor type and features"
-
-source "kernel/time/Kconfig"
-
-choice
-	prompt "Subarchitecture Type"
-	default X86_PC
-
-config X86_PC
-	bool "PC-compatible"
-	help
-	  Choose this option if your computer is a standard PC or compatible.
-
-config X86_VSMP
-	bool "Support for ScaleMP vSMP"
-	depends on PCI
-	 help
-	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
-	  supposed to run on these EM64T-based machines.  Only choose this option
-	  if you have one of these machines.
-
-endchoice
-
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
-
-config MICROCODE
-	tristate "/dev/cpu/microcode - Intel CPU microcode support"
-	select FW_LOADER
-	---help---
-	  If you say Y here the 'File systems' section, you will be
-	  able to update the microcode on Intel processors. You will
-	  obviously need the actual microcode binary data itself which is
-	  not shipped with the Linux kernel.
-
-	  For latest news and information on obtaining all the required
-	  ingredients for this driver, check:
-	  <http://www.urbanmyth.org/microcode/>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called microcode.
-	  If you use modprobe or kmod you may also want to add the line
-	  'alias char-major-10-184 microcode' to your /etc/modules.conf file.
-
-config MICROCODE_OLD_INTERFACE
-	bool
-	depends on MICROCODE
-	default y
-
-config X86_MSR
-	tristate "/dev/cpu/*/msr - Model-specific register support"
-	help
-	  This device gives privileged processes access to the x86
-	  Model-Specific Registers (MSRs).  It is a character device with
-	  major 202 and minors 0 to 31 for /dev/cpu/0/msr to /dev/cpu/31/msr.
-	  MSR accesses are directed to a specific CPU on multi-processor
-	  systems.
-
-config X86_CPUID
-	tristate "/dev/cpu/*/cpuid - CPU information support"
-	help
-	  This device gives processes access to the x86 CPUID instruction to
-	  be executed on a specific processor.  It is a character device
-	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
-	  /dev/cpu/31/cpuid.
-
-config X86_HT
-	bool
-	depends on SMP && !MK8
-	default y
-
-config MATH_EMULATION
-	bool
-
-config MCA
-	bool
-
-config EISA
-	bool
-
-config X86_IO_APIC
-	bool
-	default y
-
-config X86_LOCAL_APIC
-	bool
-	default y
-
-config MTRR
-	bool "MTRR (Memory Type Range Register) support"
-	---help---
-	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
-	  the Memory Type Range Registers (MTRRs) may be used to control
-	  processor access to memory ranges. This is most useful if you have
-	  a video (VGA) card on a PCI or AGP bus. Enabling write-combining
-	  allows bus write transfers to be combined into a larger transfer
-	  before bursting over the PCI/AGP bus. This can increase performance
-	  of image write operations 2.5 times or more. Saying Y here creates a
-	  /proc/mtrr file which may be used to manipulate your processor's
-	  MTRRs. Typically the X server should use this.
-
-	  This code has a reasonably generic interface so that similar
-	  control registers on other processors can be easily supported
-	  as well.
-
-	  Saying Y here also fixes a problem with buggy SMP BIOSes which only
-	  set the MTRRs for the boot CPU and not for the secondary CPUs. This
-	  can lead to all sorts of problems, so it's good to say Y here.
-
-	  Just say Y here, all x86-64 machines support MTRRs.
-
-	  See <file:Documentation/mtrr.txt> for more information.
-
-config SMP
-	bool "Symmetric multi-processing support"
-	---help---
-	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
-
-	  If you say N here, the kernel will run on single and multiprocessor
-	  machines, but will use only one CPU of a multiprocessor machine. If
-	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
-	  will run faster if you say N here.
-
-	  If you don't know what to do here, say N.
-
-config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on SMP
-	default n
-	help
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with Intel Pentium 4 chips with HyperThreading at a
-	  cost of slightly increased overhead in some places. If unsure say
-	  N here.
-
-config SCHED_MC
-	bool "Multi-core scheduler support"
-	depends on SMP
-	default y
-	help
-	  Multi-core scheduler support improves the CPU scheduler's decision
-	  making when dealing with multi-core CPU chips at a cost of slightly
-	  increased overhead in some places. If unsure say N here.
-
-source "kernel/Kconfig.preempt"
-
-config NUMA
-       bool "Non Uniform Memory Access (NUMA) Support"
-       depends on SMP
-       help
-	 Enable NUMA (Non Uniform Memory Access) support. The kernel 
-	 will try to allocate memory used by a CPU on the local memory 
-	 controller of the CPU and add some more NUMA awareness to the kernel.
-	 This code is recommended on all multiprocessor Opteron systems.
-	 If the system is EM64T, you should say N unless your system is EM64T 
-	 NUMA. 
-
-config K8_NUMA
-       bool "Old style AMD Opteron NUMA detection"
-       depends on NUMA && PCI
-       default y
-       help
-	 Enable K8 NUMA node topology detection.  You should say Y here if
-	 you have a multi processor AMD K8 system. This uses an old
-	 method to read the NUMA configuration directly from the builtin
-	 Northbridge of Opteron. It is recommended to use X86_64_ACPI_NUMA
-	 instead, which also takes priority if both are compiled in.   
-
-config NODES_SHIFT
-	int
-	default "6"
-	depends on NEED_MULTIPLE_NODES
-
-# Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
-
-config X86_64_ACPI_NUMA
-       bool "ACPI NUMA detection"
-       depends on NUMA
-       select ACPI 
-	select PCI
-       select ACPI_NUMA
-       default y
-       help
-	 Enable ACPI SRAT based node topology detection.
-
-config NUMA_EMU
-	bool "NUMA emulation"
-	depends on NUMA
-	help
-	  Enable NUMA emulation. A flat machine will be split
-	  into virtual nodes when booted with "numa=fake=N", where N is the
-	  number of nodes. This is only useful for debugging.
-
-config ARCH_DISCONTIGMEM_ENABLE
-       bool
-       depends on NUMA
-       default y
-
-config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y
-	depends on NUMA
-
-config ARCH_SPARSEMEM_ENABLE
-	def_bool y
-	depends on (NUMA || EXPERIMENTAL)
-	select SPARSEMEM_VMEMMAP_ENABLE
-
-config ARCH_MEMORY_PROBE
-	def_bool y
-	depends on MEMORY_HOTPLUG
-
-config ARCH_FLATMEM_ENABLE
-	def_bool y
-	depends on !NUMA
-
-source "mm/Kconfig"
-
-config MEMORY_HOTPLUG_RESERVE
-	def_bool y
-	depends on (MEMORY_HOTPLUG && DISCONTIGMEM)
-
-config HAVE_ARCH_EARLY_PFN_TO_NID
-	def_bool y
-	depends on NUMA
-
-config OUT_OF_LINE_PFN_TO_PAGE
-	def_bool y
-	depends on DISCONTIGMEM
-
-config NR_CPUS
-	int "Maximum number of CPUs (2-255)"
-	range 2 255
-	depends on SMP
-	default "8"
-	help
-	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support. Current maximum is 255 CPUs due to
-	  APIC addressing limits. Less depending on the hardware.
-
-	  This is purely to save memory - each supported CPU requires
-	  memory in the static kernel configuration.
-
-config PHYSICAL_ALIGN
-	hex
-	default "0x200000"
-
-config HOTPLUG_CPU
-	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL
-	help
-		Say Y here to experiment with turning CPUs off and on.  CPUs
-		can be controlled through /sys/devices/system/cpu/cpu#.
-		This is also required for suspend/hibernation on SMP systems.
-
-		Say N if you want to disable CPU hotplug and don't need to
-		suspend.
-
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-
-config HPET_TIMER
-	bool
-	default y
-	help
-	  Use the IA-PC HPET (High Precision Event Timer) to manage
-	  time in preference to the PIT and RTC, if a HPET is
-	  present.  The HPET provides a stable time base on SMP
-	  systems, unlike the TSC, but it is more expensive to access,
-	  as it is off-chip.  You can find the HPET spec at
-	  <http://www.intel.com/hardwaredesign/hpetspec.htm>.
-
-config HPET_EMULATE_RTC
-	bool
-	depends on HPET_TIMER && RTC=y
-	default y
-
-# Mark as embedded because too many people got it wrong.
-# The code disables itself when not needed.
-config GART_IOMMU
-	bool "GART IOMMU support" if EMBEDDED
-	default y
-	select SWIOTLB
-	select AGP
-	depends on PCI
-	help
-	  Support for full DMA access of devices with 32bit memory access only
-	  on systems with more than 3GB. This is usually needed for USB,
-	  sound, many IDE/SATA chipsets and some other devices.
-	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
-	  based hardware IOMMU and a software bounce buffer based IOMMU used
-	  on Intel systems and as fallback.
-	  The code is only active when needed (enough memory and limited
-	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
-	  too.
-
-config CALGARY_IOMMU
-	bool "IBM Calgary IOMMU support"
-	select SWIOTLB
-	depends on PCI && EXPERIMENTAL
-	help
-	  Support for hardware IOMMUs in IBM's xSeries x366 and x460
-	  systems. Needed to run systems with more than 3GB of memory
-	  properly with 32-bit PCI devices that do not support DAC
-	  (Double Address Cycle). Calgary also supports bus level
-	  isolation, where all DMAs pass through the IOMMU.  This
-	  prevents them from going anywhere except their intended
-	  destination. This catches hard-to-find kernel bugs and
-	  mis-behaving drivers and devices that do not use the DMA-API
-	  properly to set up their DMA buffers.  The IOMMU can be
-	  turned off at boot time with the iommu=off parameter.
-	  Normally the kernel will make the right choice by itself.
-	  If unsure, say Y.
-
-config CALGARY_IOMMU_ENABLED_BY_DEFAULT
-	bool "Should Calgary be enabled by default?"
-	default y
-	depends on CALGARY_IOMMU
-	help
-	  Should Calgary be enabled by default? if you choose 'y', Calgary
-	  will be used (if it exists). If you choose 'n', Calgary will not be
-	  used even if it exists. If you choose 'n' and would like to use
-	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
-	  If unsure, say Y.
-
-# need this always selected by IOMMU for the VIA workaround
-config SWIOTLB
-	bool
-	help
-	  Support for software bounce buffers used on x86-64 systems
-	  which don't have a hardware IOMMU (e.g. the current generation
-	  of Intel's x86-64 CPUs). Using this PCI devices which can only
-	  access 32-bits of memory can be used on systems with more than
-	  3 GB of memory. If unsure, say Y.
-
-config X86_MCE
-	bool "Machine check support" if EMBEDDED
-	default y
-	help
-	   Include a machine check error handler to report hardware errors.
-	   This version will require the mcelog utility to decode some
-	   machine check error logs. See
-	   ftp://ftp.x86-64.org/pub/linux/tools/mcelog
-
-config X86_MCE_INTEL
-	bool "Intel MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
-	default y
-	help
-	   Additional support for intel specific MCE features such as
-	   the thermal monitor.
-
-config X86_MCE_AMD
-	bool "AMD MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
-	default y
-	help
-	   Additional support for AMD specific MCE features such as
-	   the DRAM Error Threshold.
-
-config KEXEC
-	bool "kexec system call"
-	help
-	  kexec is a system call that implements the ability to shutdown your
-	  current kernel, and to start another kernel.  It is like a reboot
-	  but it is independent of the system firmware.   And like a reboot
-	  you can start any kernel with it, not just Linux.
-
-	  The name comes from the similarity to the exec system call.
-
-	  It is an ongoing process to be certain the hardware in a machine
-	  is properly shutdown, so do not be surprised if this code does not
-	  initially work for you.  It may help to enable device hotplugging
-	  support.  As of this writing the exact hardware interface is
-	  strongly in flux, so no good recommendation can be made.
-
-config CRASH_DUMP
-	bool "kernel crash dumps (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  Generate crash dump after being started by kexec.
-	  This should be normally only set in special crash dump kernels
-	  which are loaded in the main kernel with kexec-tools into
-	  a specially reserved region and then later executed after
-	  a crash by kdump/kexec. The crash dump kernel must be compiled
-	  to a memory address not used by the main kernel or BIOS using
-	  PHYSICAL_START, or it must be built as a relocatable image
-	  (CONFIG_RELOCATABLE=y).
-	  For more details see Documentation/kdump/kdump.txt
-
-config RELOCATABLE
-	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  Builds a relocatable kernel. This enables loading and running
-	  a kernel binary from a different physical address than it has
-	  been compiled for.
-
-	  One use is for the kexec on panic case where the recovery kernel
-	  must live at a different physical address than the primary
-	  kernel.
-
-	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
-	  it has been loaded at and the compile time physical address
-	  (CONFIG_PHYSICAL_START) is ignored.
-
-config PHYSICAL_START
-	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
-	default "0x200000"
-	help
-	  This gives the physical address where the kernel is loaded. It
-	  should be aligned to 2MB boundary.
-
-	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
-	  bzImage will decompress itself to above physical address and
-	  run from there. Otherwise, bzImage will run from the address where
-	  it has been loaded by the boot loader and will ignore above physical
-	  address.
-
-	  In normal kdump cases one does not have to set/change this option
-	  as now bzImage can be compiled as a completely relocatable image
-	  (CONFIG_RELOCATABLE=y) and be used to load and run from a different
-	  address. This option is mainly useful for the folks who don't want
-	  to use a bzImage for capturing the crash dump and want to use a
-	  vmlinux instead.
-
-	  So if you are using bzImage for capturing the crash dump, leave
-	  the value here unchanged to 0x200000 and set CONFIG_RELOCATABLE=y.
-	  Otherwise if you plan to use vmlinux for capturing the crash dump
-	  change this value to start of the reserved region (Typically 16MB
-	  0x1000000). In other words, it can be set based on the "X" value as
-	  specified in the "crashkernel=YM@XM" command line boot parameter
-	  passed to the panic-ed kernel. Typically this parameter is set as
-	  crashkernel=64M@16M. Please take a look at
-	  Documentation/kdump/kdump.txt for more details about crash dumps.
-
-	  Usage of bzImage for capturing the crash dump is advantageous as
-	  one does not have to build two kernels. Same kernel can be used
-	  as production kernel and capture kernel.
-
-	  Don't change this unless you know what you are doing.
-
-config SECCOMP
-	bool "Enable seccomp to safely compute untrusted bytecode"
-	depends on PROC_FS
-	default y
-	help
-	  This kernel feature is useful for number crunching applications
-	  that may need to compute untrusted bytecode during their
-	  execution. By using pipes or other transports made available to
-	  the process as file descriptors supporting the read/write
-	  syscalls, it's possible to isolate those applications in
-	  their own address space using seccomp. Once seccomp is
-	  enabled via /proc/<pid>/seccomp, it cannot be disabled
-	  and the task is only allowed to execute a few safe syscalls
-	  defined by each seccomp mode.
-
-	  If unsure, say Y. Only embedded should say N here.
-
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-         This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of critical functions, a canary
-	  value on the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-
-	  This feature requires gcc version 4.2 or above, or a distribution
-	  gcc with the feature backported. Older versions are automatically
-	  detected and for those versions, this configuration option is ignored.
-
-config CC_STACKPROTECTOR_ALL
-	bool "Use stack-protector for all functions"
-	depends on CC_STACKPROTECTOR
-	help
-	  Normally, GCC only inserts the canary value protection for
-	  functions that use large-ish on-stack buffers. By enabling
-	  this option, GCC will be asked to do this for ALL functions.
-
-source kernel/Kconfig.hz
-
-config K8_NB
-	def_bool y
-	depends on AGP_AMD64 || GART_IOMMU || (PCI && NUMA)
-
-endmenu
-
-#
-# Use the generic interrupt handling code in kernel/irq/:
-#
-config GENERIC_HARDIRQS
-	bool
-	default y
-
-config GENERIC_IRQ_PROBE
-	bool
-	default y
-
-# we have no ISA slots, but we do have ISA-style DMA.
-config ISA_DMA_API
-	bool
-	default y
-
-config GENERIC_PENDING_IRQ
-	bool
-	depends on GENERIC_HARDIRQS && SMP
-	default y
-
-menu "Power management options"
-
-source kernel/power/Kconfig
-
-config ARCH_HIBERNATION_HEADER
-	bool
-	depends on HIBERNATION
-	default y
-
-source "drivers/acpi/Kconfig"
-
-source "arch/x86/kernel/cpu/cpufreq/Kconfig_64"
-
-source "drivers/cpuidle/Kconfig"
-
-endmenu
-
-menu "Bus options (PCI etc.)"
-
-config PCI
-	bool "PCI support"
-	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
-
-# x86-64 doesn't support PCI BIOS access from long mode so always go direct.
-config PCI_DIRECT
-	bool
-	depends on PCI
-	default y
-
-config PCI_MMCONFIG
-	bool "Support mmconfig PCI config space access"
-	depends on PCI && ACPI
-
-config PCI_DOMAINS
-	bool
-	depends on PCI
-	default y
-
-config DMAR
-	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
-	depends on PCI_MSI && ACPI && EXPERIMENTAL
-	help
-	  DMA remapping (DMAR) devices support enables independent address
-	  translations for Direct Memory Access (DMA) from devices.
-	  These DMA remapping devices are reported via ACPI tables
-	  and include PCI device scope covered by these DMA
-	  remapping devices.
-
-config DMAR_GFX_WA
-	bool "Support for Graphics workaround"
-	depends on DMAR
-	default y
-	help
-	 Current Graphics drivers tend to use physical address
-	 for DMA and avoid using DMA APIs. Setting this config
-	 option permits the IOMMU driver to set a unity map for
-	 all the OS-visible memory. Hence the driver can continue
-	 to use physical addresses for DMA.
-
-config DMAR_FLOPPY_WA
-	bool
-	depends on DMAR
-	default y
-	help
-	 Floppy disk drivers are know to bypass DMA API calls
-	 thereby failing to work when IOMMU is enabled. This
-	 workaround will setup a 1:1 mapping for the first
-	 16M to make floppy (an ISA device) work.
-
-source "drivers/pci/pcie/Kconfig"
-
-source "drivers/pci/Kconfig"
-
-source "drivers/pcmcia/Kconfig"
-
-source "drivers/pci/hotplug/Kconfig"
-
-endmenu
-
-
-menu "Executable file formats / Emulations"
-
-source "fs/Kconfig.binfmt"
-
-config IA32_EMULATION
-	bool "IA32 Emulation"
-	help
-	  Include code to run 32-bit programs under a 64-bit kernel. You should
-	  likely turn this on, unless you're 100% sure that you don't have any
-	  32-bit programs left.
-
-config IA32_AOUT
-       tristate "IA32 a.out support"
-       depends on IA32_EMULATION
-       help
-         Support old a.out binaries in the 32bit emulation.
-
-config COMPAT
-	bool
-	depends on IA32_EMULATION
-	default y
-
-config COMPAT_FOR_U64_ALIGNMENT
-	def_bool COMPAT
-
-config SYSVIPC_COMPAT
-	bool
-	depends on COMPAT && SYSVIPC
-	default y
-
-endmenu
-
-source "net/Kconfig"
-
-source drivers/Kconfig
-
-source "drivers/firmware/Kconfig"
-
-source fs/Kconfig
-
-source "kernel/Kconfig.instrumentation"
-
-source "arch/x86/Kconfig.debug"
-
-source "security/Kconfig"
-
-source "crypto/Kconfig"
-
-source "lib/Kconfig"
+#
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/kconfig-language.txt.
+#
+# X86_64 specific configuration
+
+if X86_64
+
+config 64BIT
+	def_bool y
+
+config X86
+	bool
+	default y
+
+config GENERIC_TIME
+	bool
+	default y
+
+config GENERIC_TIME_VSYSCALL
+	bool
+	default y
+
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
+config CLOCKSOURCE_WATCHDOG
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	default y
+
+config ZONE_DMA32
+	bool
+	default y
+
+config LOCKDEP_SUPPORT
+	bool
+	default y
+
+config STACKTRACE_SUPPORT
+	bool
+	default y
+
+config SEMAPHORE_SLEEPERS
+	bool
+	default y
+
+config MMU
+	bool
+	default y
+
+config ZONE_DMA
+	bool
+	default y
+
+config ISA
+	bool
+
+config SBUS
+	bool
+
+config RWSEM_GENERIC_SPINLOCK
+	bool
+	default y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+config GENERIC_HWEIGHT
+	bool
+	default y
+
+config GENERIC_CALIBRATE_DELAY
+	bool
+	default y
+
+config X86_CMPXCHG
+	bool
+	default y
+
+config GENERIC_ISA_DMA
+	bool
+	default y
+
+config GENERIC_IOMAP
+	bool
+	default y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+	default y
+
+config ARCH_POPULATES_NODE_MAP
+	def_bool y
+
+config DMI
+	bool
+	default y
+
+config AUDIT_ARCH
+	bool
+	default y
+
+config GENERIC_BUG
+	bool
+	default y
+	depends on BUG
+
+config ARCH_HAS_ILOG2_U32
+	bool
+	default n
+
+config ARCH_HAS_ILOG2_U64
+	bool
+	default n
+
+config X86_HT
+	bool
+	depends on SMP && !MK8
+	default y
+
+config MCA
+	bool
+
+config EISA
+	bool
+
+config X86_IO_APIC
+	bool
+	default y
+
+config X86_LOCAL_APIC
+	bool
+	default y
+
+config ARCH_DISCONTIGMEM_ENABLE
+       bool
+       depends on NUMA
+       default y
+
+config ARCH_DISCONTIGMEM_DEFAULT
+	def_bool y
+	depends on NUMA
+
+config ARCH_SPARSEMEM_ENABLE
+	def_bool y
+	depends on (NUMA || EXPERIMENTAL)
+	select SPARSEMEM_VMEMMAP_ENABLE
+
+config ARCH_MEMORY_PROBE
+	def_bool y
+	depends on MEMORY_HOTPLUG
+
+config ARCH_FLATMEM_ENABLE
+	def_bool y
+	depends on !NUMA
+
+config MEMORY_HOTPLUG_RESERVE
+	def_bool y
+	depends on (MEMORY_HOTPLUG && DISCONTIGMEM)
+
+config HAVE_ARCH_EARLY_PFN_TO_NID
+	def_bool y
+	depends on NUMA
+
+config OUT_OF_LINE_PFN_TO_PAGE
+	def_bool y
+	depends on DISCONTIGMEM
+
+config ARCH_ENABLE_MEMORY_HOTPLUG
+	def_bool y
+
+config K8_NB
+	def_bool y
+	depends on AGP_AMD64 || GART_IOMMU || (PCI && NUMA)
+
+config ARCH_HIBERNATION_HEADER
+	bool
+	depends on HIBERNATION
+	default y
+#
+# Use the generic interrupt handling code in kernel/irq/:
+#
+config GENERIC_HARDIRQS
+	bool
+	default y
+
+config GENERIC_IRQ_PROBE
+	bool
+	default y
+
+# we have no ISA slots, but we do have ISA-style DMA.
+config ISA_DMA_API
+	bool
+	default y
+
+config GENERIC_PENDING_IRQ
+	bool
+	depends on GENERIC_HARDIRQS && SMP
+	default y
+
+endif # if X86_64
+
+
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 5959412..1ad6f7f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -4,12 +4,7 @@
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
-# If a arch/$(SRCARCH)/Kconfig.$(ARCH) file exist use it
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/Kconfig.$(ARCH)),)
-        Kconfig := arch/$(SRCARCH)/Kconfig.$(ARCH)
-else
-        Kconfig := arch/$(SRCARCH)/Kconfig
-endif
+Kconfig := arch/$(SRCARCH)/Kconfig
 
 xconfig: $(obj)/qconf
 	$< $(Kconfig)
-- 
1.5.3.4.1157.g0e74-dirty

