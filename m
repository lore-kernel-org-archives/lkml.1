Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbXKMOau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbXKMOau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXKMO3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:29:49 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:34112 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXKMO3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:29:47 -0500
Message-Id: <20071113142935.889693264@polymtl.ca>
References: <20071113142609.103579906@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 09:26:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 4/4] Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig
Content-Disposition: inline; filename=move-kconfig-instrumentation-to-arch.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 14:29:39 +0000
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
 arch/Kconfig                   |   22 ++++++++++++++++++
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
 init/Kconfig                   |   12 ++++++++++
 kernel/Kconfig.instrumentation |   49 -----------------------------------------
 27 files changed, 34 insertions(+), 97 deletions(-)

Index: linux-2.6-lttng/arch/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/Kconfig	2007-11-11 22:01:40.000000000 -0500
+++ linux-2.6-lttng/arch/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -1,3 +1,25 @@
 #
 # General architecture dependent options
 #
+
+config OPROFILE
+	tristate "OProfile system profiling (EXPERIMENTAL)"
+	depends on PROFILING
+	depends on ARCH_SUPPORTS_OPROFILE
+	help
+	  OProfile is a profiling system capable of profiling the
+	  whole system, include the kernel, kernel modules, libraries,
+	  and applications.
+
+	  If unsure, say N.
+
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES
+	depends on ARCH_SUPPORTS_KPROBES
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-11-11 22:01:40.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2007-11-11 22:02:32.000000000 -0500
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
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2007-11-11 22:01:56.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
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
-	depends on PROFILING
-	depends on ARCH_SUPPORTS_OPROFILE
-	help
-	  OProfile is a profiling system capable of profiling the
-	  whole system, include the kernel, kernel modules, libraries,
-	  and applications.
-
-	  If unsure, say N.
-
-config KPROBES
-	bool "Kprobes"
-	depends on KALLSYMS && MODULES
-	depends on ARCH_SUPPORTS_KPROBES
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
Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/alpha/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -657,8 +657,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/alpha/Kconfig.debug"
 
 # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -1071,8 +1071,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/arm/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -1076,8 +1076,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
Index: linux-2.6-lttng/arch/cris/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/cris/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/cris/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -196,8 +196,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/frv/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/frv/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/frv/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -375,8 +375,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/frv/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/h8300/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/h8300/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/h8300/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -223,8 +223,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/h8300/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-11-11 22:01:56.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -598,8 +598,6 @@ config IRQ_PER_CPU
 
 source "arch/ia64/hp/sim/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ia64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/m32r/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -429,8 +429,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m32r/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68k/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/m68k/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -683,8 +683,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68k/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/m68knommu/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m68knommu/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/m68knommu/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -707,8 +707,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/m68knommu/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/mips/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -2031,8 +2031,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/mips/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/parisc/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -270,8 +270,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/parisc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-11-11 22:01:56.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -675,8 +675,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/powerpc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-11-11 22:01:56.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -1323,8 +1323,6 @@ endmenu
 
 source "lib/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/ppc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-11-11 22:01:56.000000000 -0500
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -535,8 +535,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/s390/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/sh/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -757,8 +757,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sh64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh64/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/sh64/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -287,8 +287,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sh64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2007-11-11 22:01:51.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -323,8 +323,6 @@ endmenu
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-11-11 22:01:56.000000000 -0500
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -468,8 +468,6 @@ source "drivers/sbus/char/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/sparc64/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/um/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/um/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/um/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -289,6 +289,4 @@ config INPUT
 	bool
 	default n
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/um/Kconfig.debug"
Index: linux-2.6-lttng/arch/v850/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/v850/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/v850/Kconfig	2007-11-11 22:02:03.000000000 -0500
@@ -331,8 +331,6 @@ source "sound/Kconfig"
 
 source "drivers/usb/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/v850/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86/Kconfig.i386
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.i386	2007-11-11 22:01:56.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig.i386	2007-11-11 22:02:03.000000000 -0500
@@ -1276,8 +1276,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/x86/Kconfig.x86_64
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig.x86_64	2007-11-11 22:01:56.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig.x86_64	2007-11-11 22:02:03.000000000 -0500
@@ -834,8 +834,6 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
-source "kernel/Kconfig.instrumentation"
-
 source "arch/x86/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng/arch/xtensa/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/xtensa/Kconfig	2007-11-11 22:01:26.000000000 -0500
+++ linux-2.6-lttng/arch/xtensa/Kconfig	2007-11-11 22:02:03.000000000 -0500
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
