Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXKPCA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXKPCA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbXKPCAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:00:38 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47885 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbXKPCAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:00:36 -0500
Message-Id: <20071116020027.836458315@polymtl.ca>
References: <20071116015925.175012068@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 15 Nov 2007 20:59:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 4/4] Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
Content-Disposition: inline; filename=move-kconfig-instrumentation-to-arch.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 02:00:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the instrumentation Kconfig to

arch/Kconfig for architecture dependent options
  - oprofile
  - kprobes

and

init/Kconfig for architecture independent options
  - profiling
  - markers

Remove the "Instrumentation Support" menu. Everything moves to "General setup".
Delete the kernel/Kconfig.instrumentation file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/Kconfig                   |   28 ++++++++++++++++++++
 arch/alpha/Kconfig             |    2 -
 arch/arm/Kconfig               |    2 -
 arch/blackfin/Kconfig          |    2 -
 arch/cris/Kconfig              |    2 -
 arch/frv/Kconfig               |    2 -
 arch/h8300/Kconfig             |    2 -
 arch/ia64/Kconfig              |    2 -
 arch/m32r/Kconfig              |    2 -
 arch/m68k/Kconfig              |    2 -
 arch/m68knommu/Kconfig         |    2 -
 arch/mips/Kconfig              |    2 -
 arch/parisc/Kconfig            |    2 -
 arch/powerpc/Kconfig           |    2 -
 arch/ppc/Kconfig               |    2 -
 arch/s390/Kconfig              |    2 -
 arch/sh/Kconfig                |    2 -
 arch/sh64/Kconfig              |    2 -
 arch/sparc/Kconfig             |    2 -
 arch/sparc64/Kconfig           |    2 -
 arch/um/Kconfig                |    2 -
 arch/v850/Kconfig              |    2 -
 arch/x86/Kconfig.i386          |    2 -
 arch/x86/Kconfig.x86_64        |    2 -
 arch/xtensa/Kconfig            |    2 -
 init/Kconfig                   |   12 ++++++++
 kernel/Kconfig.instrumentation |   55 -----------------------------------------
 27 files changed, 40 insertions(+), 103 deletions(-)

Index: linux-2.6-lttng/arch/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -1,3 +1,31 @@
 #
 # General architecture dependent options
 #
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	depends on ARCH_HAS_OPROFILE
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config ARCH_HAS_OPROFILE
+	def_bool n
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on ARCH_HAS_KPROBES
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
+config ARCH_HAS_KPROBES
+	def_bool n
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -644,6 +644,18 @@ config SLOB
 
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
 source "arch/Kconfig"
 
 endmenu		# General setup
Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2007-11-14 17:12:56.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,55 +0,0 @@
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
-	depends on PROFILING
-	depends on ARCH_HAS_OPROFILE
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config ARCH_HAS_OPROFILE
-	def_bool n
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	depends on ARCH_HAS_KPROBES
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
-config ARCH_HAS_KPROBES
-	def_bool n
-
-config MARKERS
-	bool "Activate markers"
-	help
-	  Place an empty function call at each marker site. Can be
-	  dynamically changed for a probe function.
-
-endif # INSTRUMENTATION
Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-11-14 17:04:59.000000000 -0500
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -655,8 +655,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-11-14 17:05:08.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -1071,8 +1071,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-11-14 17:10:25.000000000 -0500
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -1074,8 +1074,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -196,8 +196,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -375,8 +375,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -223,8 +223,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-11-14 17:12:56.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -594,8 +594,6 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ia64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-11-14 17:10:49.000000000 -0500
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -427,8 +427,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -683,8 +683,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -707,8 +707,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-11-14 17:06:22.000000000 -0500
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -2029,8 +2029,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-11-14 17:06:39.000000000 -0500
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -268,8 +268,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-11-14 17:12:56.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -671,8 +671,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/powerpc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-11-14 17:12:56.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -1319,8 +1319,6 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-11-14 17:12:56.000000000 -0500
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -531,8 +531,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/s390/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-11-14 17:08:24.000000000 -0500
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -757,8 +757,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-11-14 17:08:40.000000000 -0500
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -285,8 +285,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-11-14 17:08:59.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -321,8 +321,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-11-14 17:12:56.000000000 -0500
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -464,8 +464,6 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/um/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -289,6 +289,4 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -331,8 +331,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86/Kconfig.i386
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.i386	2007-11-14 17:12:56.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig.i386	2007-11-14 17:12:57.000000000 -0500
@@ -1272,8 +1272,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.x86_64	2007-11-14 17:12:56.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig.x86_64	2007-11-14 17:12:57.000000000 -0500
@@ -830,8 +830,6 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-11-14 17:03:04.000000000 -0500
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-11-14 17:12:57.000000000 -0500
@@ -251,8 +251,6 @@ config EMBEDDED_RAMDISK_IMAGE
 	  provide one yourself.
 endmenu
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/xtensa/Kconfig.debug"
 
 source "security/Kconfig"

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
