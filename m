Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbYBBUfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbYBBUfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYBBUfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:35:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58383 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbYBBUfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:35:01 -0500
Date: Sat, 2 Feb 2008 21:35:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [REVIEW for merge] kbuild updates including silence of section mismatch check
Message-ID: <20080202203503.GA26415@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have queued up 10 patched for kbuild.git.
As a few are new I post them for review here
before pushing to Linus.

The patchset from Mathieu causes the hing number of
lines changed - the rest is smaller stuff.

The most visible change is that I have made all the section mismatch
go away and in the end of the build modpost report the number
of section mismatch warnings and how to see detail.

The typical output is now:

modpost: Found 35 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

And CONFIG_DEBUG_SECTION_MISMATCH cannot be set
from the config anymore so we are not noisy in typical
allyesconfig builds.

When we are down to an acceptable number of warnings modpost
will start to be vocal again. The acceptable number is somewhere
below 20 for an allyseconfig/allmodconfig build.

All patches are pushed out to kbuild.git.

See below for more details and a combined patch.
Individual patches will be sent to kbuild only (and no cc:)

	Sam

Bryan Wu (1):
      kbuild: add svn revision information to setlocalversion

Geert Uytterhoeven (1):
      kbuild: Spelling/grammar fixes for config DEBUG_SECTION_MISMATCH

Mathieu Desnoyers (5):
      Fix ARM to play nicely with generic Instrumentation menu
      Create arch/Kconfig
      Add HAVE_OPROFILE
      Add HAVE_KPROBES
      Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig

Ralf Baechle (1):
      Remove __INIT_REFOK and __INITDATA_REFOK

Sam Ravnborg (3):
      kbuild: print only total number of section mismatces found
      kconfig: mark config as changed when loading an alternate config
      kconfig: ignore select of unknown symbol

 arch/Kconfig                     |   31 +++++++++++++++++++
 arch/alpha/Kconfig               |    3 +-
 arch/arm/Kconfig                 |   21 +++++++++++-
 arch/arm/Kconfig.instrumentation |   62 --------------------------------------
 arch/avr32/Kconfig               |    5 +--
 arch/blackfin/Kconfig            |    3 +-
 arch/cris/Kconfig                |    2 -
 arch/frv/Kconfig                 |    2 -
 arch/h8300/Kconfig               |    2 -
 arch/ia64/Kconfig                |    4 +-
 arch/m32r/Kconfig                |    3 +-
 arch/m68k/Kconfig                |    2 -
 arch/m68knommu/Kconfig           |    2 -
 arch/mips/Kconfig                |    3 +-
 arch/parisc/Kconfig              |    3 +-
 arch/powerpc/Kconfig             |    4 +-
 arch/ppc/Kconfig                 |    4 +-
 arch/s390/Kconfig                |    4 +-
 arch/sh/Kconfig                  |    3 +-
 arch/sparc/Kconfig               |    3 +-
 arch/sparc64/Kconfig             |    4 +-
 arch/um/Kconfig                  |    2 -
 arch/v850/Kconfig                |    2 -
 arch/x86/Kconfig                 |    8 +----
 arch/xtensa/Kconfig              |    2 -
 include/linux/init.h             |    3 --
 init/Kconfig                     |   14 ++++++++
 kernel/Kconfig.instrumentation   |   49 ------------------------------
 lib/Kconfig.debug                |   14 ++++----
 scripts/kconfig/mconf.c          |    1 +
 scripts/kconfig/menu.c           |    9 ++----
 scripts/mod/modpost.c            |   15 ++++-----
 scripts/setlocalversion          |   15 +++++++++
 33 files changed, 118 insertions(+), 186 deletions(-)
diff --git a/arch/Kconfig b/arch/Kconfig
new file mode 100644
index 0000000..3d72dc3
--- /dev/null
+++ b/arch/Kconfig
@@ -0,0 +1,31 @@
+#
+# General architecture dependent options
+#
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	depends on HAVE_OPROFILE
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config HAVE_OPROFILE
+	def_bool n
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on HAVE_KPROBES
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+config HAVE_KPROBES
+	def_bool n
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index c613d5f..9abcd5f 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,6 +5,7 @@
 config ALPHA
 	bool
 	default y
+	select HAVE_OPROFILE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -649,8 +650,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4b1a8e3..36176f4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -10,6 +10,8 @@ config ARM
 	default y
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
+	select HAVE_OPROFILE
+	select HAVE_KPROBES if (!XIP_KERNEL)
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
@@ -135,6 +137,23 @@ config FIQ
 config ARCH_MTD_XIP
 	bool
 
+if OPROFILE
+
+config OPROFILE_ARMV6
+	def_bool y
+	depends on CPU_V6 && !SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	def_bool y
+	depends on CPU_V6 && SMP
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
+endif
+
 config VECTORS_BASE
 	hex
 	default 0xffff0000 if MMU || CPU_HIGH_VECTOR
@@ -1128,8 +1147,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "arch/arm/Kconfig.instrumentation"
-
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/arm/Kconfig.instrumentation b/arch/arm/Kconfig.instrumentation
deleted file mode 100644
index 453ad8e..0000000
--- a/arch/arm/Kconfig.instrumentation
+++ /dev/null
@@ -1,62 +0,0 @@
-menuconfig INSTRUMENTATION
-	bool "Instrumentation Support"
-	default y
-	---help---
-	  Say Y here to get to see options related to performance measurement,
-	  system-wide debugging, and testing. This option alone does not add any
-	  kernel code.
-
-	  If you say N, all options in this submenu will be skipped and
-	  disabled. If you're trying to debug the kernel itself, go see the
-	  Kernel Hacking menu.
-
-if INSTRUMENTATION
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING && !UML
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config OPROFILE_ARMV6
-	bool
-	depends on OPROFILE && CPU_V6 && !SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_MPCORE
-	bool
-	depends on OPROFILE && CPU_V6 && SMP
-	default y
-	select OPROFILE_ARM11_CORE
-
-config OPROFILE_ARM11_CORE
-	bool
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES && !UML && !XIP_KERNEL
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-config MARKERS
-	bool "Activate markers"
-	help
-	  Place an empty function call at each marker site. Can be
-	  dynamically changed for a probe function.
-
-endif # INSTRUMENTATION
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index e34e2c9..0e56e96 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -10,6 +10,8 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select HAVE_OPROFILE
+	select HAVE_KPROBES
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
@@ -54,9 +56,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config ARCH_SUPPORTS_OPROFILE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 4802eb7..ba21e33 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -24,6 +24,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config ZONE_DMA
 	bool
@@ -973,8 +974,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/blackfin/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 222da15..7f0be4c 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -213,8 +213,6 @@ source "drivers/pci/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index e3f965c..68380cb 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -375,8 +375,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index ff6a871..dc61222 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -223,8 +223,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index c9307c9..a0740fb 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -15,6 +15,8 @@ config IA64
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
+	select HAVE_OPROFILE
+	select HAVE_KPROBES
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -600,8 +602,6 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ia64/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 49326e9..1225975 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/M32R Kernel Configuration"
 config M32R
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config SBUS
 	bool
@@ -426,8 +427,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 24e6bc0..8236e42 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -678,8 +678,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index bd92137..6abbbb8 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -711,8 +711,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 36a4018..d38ebd3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1,6 +1,7 @@
 config MIPS
 	bool
 	default y
+	select HAVE_OPROFILE
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
@@ -2095,8 +2096,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 2b649c4..25c10fa 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -7,6 +7,7 @@ mainmenu "Linux/PA-RISC Kernel Configuration"
 
 config PARISC
 	def_bool y
+	select HAVE_OPROFILE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
@@ -272,8 +273,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4a22c99..b94d450 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,6 +87,8 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config EARLY_PRINTK
 	bool
@@ -713,8 +715,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconfig"
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/powerpc/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/ppc/Kconfig b/arch/ppc/Kconfig
index db5934c..531156f 100644
--- a/arch/ppc/Kconfig
+++ b/arch/ppc/Kconfig
@@ -42,6 +42,8 @@ config GENERIC_CALIBRATE_DELAY
 config PPC
 	bool
 	default y
+	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config PPC32
 	bool
@@ -1256,8 +1258,6 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 6ef54d2..974f9c3 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -51,6 +51,8 @@ mainmenu "Linux Kernel Configuration"
 
 config S390
 	def_bool y
+	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 source "init/Kconfig"
 
@@ -526,8 +528,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/s390/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index b30c4c3..bfbd54a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -8,6 +8,7 @@ mainmenu "Linux/SuperH Kernel Configuration"
 config SUPERH
 	def_bool y
 	select EMBEDDED
+	select HAVE_OPROFILE
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
@@ -896,8 +897,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 527adc8..51008a2 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -63,6 +63,7 @@ config NR_CPUS
 config SPARC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 # Identify this as a Sparc32 build
 config SPARC32
@@ -320,8 +321,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 158522f..a7739b5 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -8,6 +8,8 @@ mainmenu "Linux/UltraSPARC Kernel Configuration"
 config SPARC
 	bool
 	default y
+	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config SPARC64
 	bool
@@ -465,8 +467,6 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc64/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index dd1689b..55945db 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -289,6 +289,4 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/um/Kconfig.debug"
diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index b6a50b8..ace479a 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -331,8 +331,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7109037..3162cb4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -18,6 +18,8 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config GENERIC_LOCKBREAK
 	def_bool n
@@ -106,10 +108,6 @@ config GENERIC_TIME_VSYSCALL
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64
 
-config ARCH_SUPPORTS_OPROFILE
-	bool
-	default y
-
 select HAVE_KVM
 
 config ARCH_HIBERNATION_POSSIBLE
@@ -1597,8 +1595,6 @@ source "drivers/firmware/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 844721e..5d5546c 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -246,8 +246,6 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/include/linux/init.h b/include/linux/init.h
index 2efbda0..90cdbbb 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -124,9 +124,6 @@
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
 #define __REFCONST       .section       ".ref.rodata", "aw"
-/* backward compatibility */
-#define __INIT_REFOK     .section	__REF
-#define __INITDATA_REFOK .section	__REFDATA
 
 #ifndef __ASSEMBLY__
 /*
diff --git a/init/Kconfig b/init/Kconfig
index dcc96a8..b2acdeb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -665,6 +665,20 @@ config SLOB
 
 endchoice
 
+config PROFILING
+	bool "Profiling support (EXPERIMENTAL)"
+	help
+	  Say Y here to enable the extended profiling support mechanisms used
+	  by profilers such as OProfile.
+
+config MARKERS
+	bool "Activate markers"
+	help
+	  Place an empty function call at each marker site. Can be
+	  dynamically changed for a probe function.
+
+source "arch/Kconfig"
+
 endmenu		# General setup
 
 config SLABINFO
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
deleted file mode 100644
index 468f47a..0000000
--- a/kernel/Kconfig.instrumentation
+++ /dev/null
@@ -1,49 +0,0 @@
-menuconfig INSTRUMENTATION
-	bool "Instrumentation Support"
-	default y
-	---help---
-	  Say Y here to get to see options related to performance measurement,
-	  system-wide debugging, and testing. This option alone does not add any
-	  kernel code.
-
-	  If you say N, all options in this submenu will be skipped and
-	  disabled. If you're trying to debug the kernel itself, go see the
-	  Kernel Hacking menu.
-
-if INSTRUMENTATION
-
-config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
-	help
-	  Say Y here to enable the extended profiling support mechanisms used
-	  by profilers such as OProfile.
-
-config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
-	depends on PROFILING && !UML
-	depends on ARCH_SUPPORTS_OPROFILE || ALPHA || ARM || BLACKFIN || IA64 || M32R || PARISC || PPC || S390 || SUPERH || SPARC
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES && !UML
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-config MARKERS
-	bool "Activate markers"
-	help
-	  Place an empty function call at each marker site. Can be
-	  dynamically changed for a probe function.
-
-endif # INSTRUMENTATION
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0d8a5a4..0d385be 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -81,7 +81,7 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	default n
+	depends on UNDEFINED
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.
@@ -90,19 +90,19 @@ config DEBUG_SECTION_MISMATCH
 	  most likely result in an oops.
 	  In the code functions and variables are annotated with
 	  __init, __devinit etc. (see full list in include/linux/init.h)
-	  which result in the code/data being placed in specific sections.
-	  The section mismatch anaylsis are always done after a full
-	  kernel build but enabling this options will in addition
+	  which results in the code/data being placed in specific sections.
+	  The section mismatch analysis is always done after a full
+	  kernel build but enabling this option will in addition
 	  do the following:
 	  - Add the option -fno-inline-functions-called-once to gcc
 	    When inlining a function annotated __init in a non-init
-	    function we would loose the section information and thus
+	    function we would lose the section information and thus
 	    the analysis would not catch the illegal reference.
-	    This options tell gcc to inline less but will also
+	    This option tells gcc to inline less but will also
 	    result in a larger kernel.
 	  - Run the section mismatch analysis for each module/built-in.o
 	    When we run the section mismatch analysis on vmlinux.o we
-	    looses valueable information about where the mismatch was
+	    lose valueble information about where the mismatch was
 	    introduced.
 	    Running the analysis for each module/built-in.o file
 	    will tell where the mismatch happens much closer to the
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 50e61c4..734cf4f 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -821,6 +821,7 @@ static void conf_load(void)
 				return;
 			if (!conf_read(dialog_input_result)) {
 				set_config_filename(dialog_input_result);
+				sym_set_change_count(1);
 				return;
 			}
 			show_textbox(NULL, _("File does not exist!"), 5, 38);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index fdad173..606ceb9 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -203,12 +203,9 @@ void sym_check_prop(struct symbol *sym)
 				prop_warn(prop,
 				    "config symbol '%s' uses select, but is "
 				    "not boolean or tristate", sym->name);
-			else if (sym2->type == S_UNKNOWN)
-				prop_warn(prop,
-				    "'select' used by config symbol '%s' "
-				    "refers to undefined symbol '%s'",
-				    sym->name, sym2->name);
-			else if (sym2->type != S_BOOLEAN && sym2->type != S_TRISTATE)
+			else if (sym2->type != S_UNKNOWN &&
+			         sym2->type != S_BOOLEAN &&
+			         sym2->type != S_TRISTATE)
 				prop_warn(prop,
 				    "'%s' has wrong type. 'select' only "
 				    "accept arguments of boolean and "
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f8efc93..c2e918e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1125,15 +1125,15 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 	to = to_is_func ? "function" : "variable";
 	to_p = to_is_func ? "()" : "";
 
+	sec_mismatch_count++;
+	if (!sec_mismatch_verbose)
+		return;
+
 	fprintf(stderr, "WARNING: %s(%s+0x%llx): Section mismatch in"
 	                " reference from the %s %s%s to the %s %s:%s%s\n",
                         modname, fromsec, fromaddr, from, fromsym, from_p,
 	                to, tosec, tosym, to_p);
 
-	sec_mismatch_count++;
-	if (!sec_mismatch_verbose)
-		return;
-
 	switch (mismatch) {
 	case TEXT_TO_INIT:
 		fprintf(stderr,
@@ -1939,10 +1939,9 @@ int main(int argc, char **argv)
 		write_dump(dump_write);
 	if (sec_mismatch_count && !sec_mismatch_verbose)
 		fprintf(stderr, "modpost: Found %d section mismatch(es).\n"
-		        "To see additional details select \"Enable full "
-		        "Section mismatch analysis\"\n"
-		        "in the Kernel Hacking menu "
-		        "(CONFIG_SECTION_MISMATCH).\n", sec_mismatch_count);
+		        "To see full details build your kernel with:\n"
+		        "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
+		        sec_mismatch_count);
 
 	return err;
 }
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
old mode 100644
new mode 100755
index 52f032e..17b0028
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -45,3 +45,18 @@ if hgid=`hg id 2>/dev/null`; then
 	# All done with mercurial
 	exit
 fi
+
+# Check for svn and a svn repo.
+if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` ; then
+	changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l`
+
+	# Are there uncommitted changes?
+	if [ $changes != 0 ]; then
+		printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
+	else
+		printf -- '-svn%s' "$rev"
+	fi
+
+	# All done with svn
+	exit
+fi
