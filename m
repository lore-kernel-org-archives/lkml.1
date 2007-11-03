Return-Path: <linux-kernel-owner+w=401wt.eu-S1762788AbXKCXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788AbXKCXvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbXKCXtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:49:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59240 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239AbXKCXto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:49:44 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 07/10] x86: add remaning bits from x86_64 to Kconfig.i386
Date: Sun,  4 Nov 2007 00:51:17 +0100
Message-Id: <11941338813105-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11941338813125-git-send-email-sam@ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org> <11941338802525-git-send-email-sam@ravnborg.org> <11941338802646-git-send-email-sam@ravnborg.org> <11941338813125-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few symbols remained in Kconfig.x86_64 where the
dependencies were different or the help text was
different from the i386 one.
Modify all relevant Kconfig.i386 symbols such that
they have X86_64 dependencies for x86_64 specific items
and update the help text as appropriate.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig.i386 |   51 ++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig.i386 b/arch/x86/Kconfig.i386
index 890c258..4984904 100644
--- a/arch/x86/Kconfig.i386
+++ b/arch/x86/Kconfig.i386
@@ -307,9 +307,17 @@ source "arch/x86/Kconfig.cpu"
 config HPET_TIMER
 	bool
 	prompt "HPET Timer Support" if X86_32
+	default y if X86_64
 	help
-	  This enables the use of the HPET for the kernel's internal timer.
+	  Use the IA-PC HPET (High Precision Event Timer) to manage
+	  time in preference to the PIT and RTC, if a HPET is
+	  present.
 	  HPET is the next generation timer replacing legacy 8254s.
+          The HPET provides a stable time base on SMP
+	  systems, unlike the TSC, but it is more expensive to access,
+	  as it is off-chip.  You can find the HPET spec at
+	  <http://www.intel.com/hardwaredesign/hpetspec.htm>.
+
 	  You can safely choose Y here.  However, HPET will only be
 	  activated if the platform and the BIOS support this feature.
 	  Otherwise the 8254 will be used for timing services.
@@ -377,8 +385,8 @@ config NR_CPUS
 	default "8"
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 255 and the
-	  minimum value which makes sense is 2.
+	  kernel will support. Current maximum is 255 CPUs due to
+	  APIC addressing limits. Less depending on the hardware.
 
 	  This is purely to save memory - each supported CPU adds
 	  approximately eight kilobytes to the kernel image.
@@ -444,8 +452,10 @@ config X86_VISWS_APIC
 	default y
 
 config X86_MCE
-	bool "Machine Check Exception"
+	bool
+	prompt "Machine Check Exception" if X86_32 || (X86_64 && EMBEDDED)
 	depends on !X86_VOYAGER
+	default y if X86_64
 	---help---
 	  Machine Check Exception support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, component failure).
@@ -459,6 +469,9 @@ config X86_MCE
 	  problem on some new non-standard machine, you can boot with "nomce"
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
+	  This version for x86_64 will require the mcelog utility to decode
+	  some machine check error logs. See
+	  ftp://ftp.x86-64.org/pub/linux/tools/mcelog
 
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
@@ -577,6 +590,8 @@ config MICROCODE
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called microcode.
+	  If you use modprobe or kmod you may also want to add the line
+	  'alias char-major-10-184 microcode' to your /etc/modules.conf file.
 
 config MICROCODE_OLD_INTERFACE
 	bool
@@ -722,13 +737,19 @@ config X86_PAE
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
-	depends on X86_32 && SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
+	depends on (X86_32 && SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL) || (X86_64 && SMP)
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT)
 	help
-	  NUMA support for i386. This is currently highly experimental
-	  and should be only used for kernel development. It might also
-	  cause boot failures.
+	  NUMA (Non Uniform Memory Access) support.
+	  For i386 this is currently highly experimental and should be
+	  only used for kernel development. It might also cause boot failures.
+	  NUMA support for X86_64 is working fine. The kernel
+	  will try to allocate memory used by a CPU on the local memory
+	  controller of the CPU and add some more NUMA awareness to the kernel.
+	  This code is recommended on all multiprocessor Opteron systems.
+	  If the system is EM64T, you should say N unless your system is EM64T
+	  NUMA.
 
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
@@ -879,6 +900,8 @@ config MTRR
 
 	  You can safely say Y even if your machine doesn't have MTRRs, you'll
 	  just add about 9 KB to your kernel.
+	  For x86_64 you should just say Y here, all x86_64 machines
+	  support MTRRs.
 
 	  See <file:Documentation/mtrr.txt> for more information.
 
@@ -977,7 +1000,7 @@ config KEXEC
 config CRASH_DUMP
 	bool "kernel crash dumps (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	depends on HIGHMEM
+	depends on X86_64 || HIGHMEM
 	help
 	  Generate crash dump after being started by kexec.
 	  This should be normally only set in special crash dump kernels
@@ -992,6 +1015,7 @@ config CRASH_DUMP
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
 	default "0x1000000" if X86_NUMAQ
+	default "0x200000"  if X86_64
 	default "0x100000"
 	help
 	  This gives the physical address where the kernel is loaded.
@@ -1044,6 +1068,10 @@ config RELOCATABLE
 	  must live at a different physical address than the primary
 	  kernel.
 
+	  Note: If CONFIG_RELOCATABLE=y, then the kernel runs from the address
+	  it has been loaded at and the compile time physical address
+	  (CONFIG_PHYSICAL_START) is ignored.
+
 config PHYSICAL_ALIGN
 	hex
 	prompt "Alignment value to which kernel should be aligned" if X86_32
@@ -1075,6 +1103,11 @@ config HOTPLUG_CPU
 	  Say Y here to experiment with turning CPUs off and on, and to
 	  enable suspend on SMP systems. CPUs can be controlled through
 	  /sys/devices/system/cpu.
+	  This is also required for suspend/hibernation on SMP systems.
+
+	  Say N if you want to disable CPU hotplug and don't need to
+	  suspend.
+
 
 config COMPAT_VDSO
 	bool "Compat VDSO support"
-- 
1.5.3.4.1157.g0e74-dirty

