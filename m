Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbYBBUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbYBBUOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbYBBUNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:13:07 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44629 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934693AbYBBUNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:13:05 -0500
Message-Id: <20080202201159.594018620@polymtl.ca>
References: <20080202201031.860344390@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:10:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
       David Howells <dhowells@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: [patch 1/5] Fix ARM to play nicely with generic Instrumentation menu
Content-Disposition: inline; filename=fix-arm-to-play-nicely-with-generic-instrumentation-menu.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:12:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conflicting commit for 
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
is the ARM fix from Linus :

commit 38ad9aebe70dc72df08851bbd1620d89329129ba

He just seemed to agree that my approach (just putting the missing ARM
config options in arch/arm/Kconfig) works too. The main advantage it has
is that it is smaller, does not need a cleanup in the future and does
not break the following patches unnecessarily.

It's just been discussed here

http://lkml.org/lkml/2008/1/15/267

However, Linus might prefer to stay with his own patch and I would
totally understand it that late in the release cycle. Therefore I submit
this for the next release cycle.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Russell King <rmk+lkml@arm.linux.org.uk>
---
 arch/arm/Kconfig                 |   19 +++++++++++
 arch/arm/Kconfig.instrumentation |   62 ---------------------------------------
 kernel/Kconfig.instrumentation   |    4 +-
 3 files changed, 20 insertions(+), 65 deletions(-)

Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2008-02-02 14:36:22.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2008-02-02 14:37:00.000000000 -0500
@@ -135,6 +135,23 @@ config FIQ
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
@@ -1128,7 +1145,7 @@ endmenu
 
 source "fs/Kconfig"
 
-source "arch/arm/Kconfig.instrumentation"
+source "kernel/Kconfig.instrumentation"
 
 source "arch/arm/Kconfig.debug"
 
Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2008-02-02 14:36:22.000000000 -0500
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2008-02-02 14:37:00.000000000 -0500
@@ -32,7 +32,7 @@ config OPROFILE
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES && !UML
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32 || (ARM && !XIP_KERNEL)
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
Index: linux-2.6-lttng/arch/arm/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig.instrumentation	2008-02-02 14:36:22.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
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

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
