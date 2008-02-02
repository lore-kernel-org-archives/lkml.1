Return-Path: <linux-kernel-owner+w=401wt.eu-S934966AbYBBUN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966AbYBBUN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764542AbYBBUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:13:00 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44616 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764325AbYBBUM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:12:59 -0500
Message-Id: <20080202201200.330032665@polymtl.ca>
References: <20080202201031.860344390@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:10:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [patch 3/5] Add HAVE_OPROFILE
Content-Disposition: inline; filename=add-have-oprofile.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat,  2 Feb 2008 20:12:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus:
On the per-architecture side, I do think it would be better to *not* have
internal architecture knowledge in a generic file, and as such a line like

        depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32

really shouldn't exist in a file like kernel/Kconfig.instrumentation.

It would be much better to do

        depends on ARCH_SUPPORTS_KPROBES

in that generic file, and then architectures that do support it would just
have a

        bool ARCH_SUPPORTS_KPROBES
                default y

in *their* architecture files. That would seem to be much more logical,
and is readable both for arch maintainers *and* for people who have no
clue - and don't care - about which architecture is supposed to support
which interface...

Changelog:

Actually, I know I gave this as the magic incantation, but now that I see
it, I realize that I should have told you to just use

        config ARCH_SUPPORTS_KPROBES
                def_bool y

instead, which is a bit denser.

We seem to use both kinds of syntax for these things, but this is really
what "def_bool" is there for...

Changelog :

- Moving to HAVE_*.
- Add AVR32 oprofile.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/alpha/Kconfig             |    1 +
 arch/arm/Kconfig               |    1 +
 arch/avr32/Kconfig             |    4 +---
 arch/blackfin/Kconfig          |    1 +
 arch/ia64/Kconfig              |    1 +
 arch/m32r/Kconfig              |    1 +
 arch/mips/Kconfig              |    1 +
 arch/parisc/Kconfig            |    1 +
 arch/powerpc/Kconfig           |    1 +
 arch/ppc/Kconfig               |    1 +
 arch/s390/Kconfig              |    1 +
 arch/sh/Kconfig                |    1 +
 arch/sparc/Kconfig             |    1 +
 arch/sparc64/Kconfig           |    1 +
 arch/x86/Kconfig               |    5 +----
 kernel/Kconfig.instrumentation |    5 ++++-
 16 files changed, 19 insertions(+), 8 deletions(-)

Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2008-02-02 15:05:46.000000000 -0500
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2008-02-02 15:06:13.000000000 -0500
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING && !UML
-	depends on ARCH_SUPPORTS_OPROFILE || ALPHA || ARM || BLACKFIN || IA64 || M32R || PARISC || PPC || S390 || SUPERH || SPARC
+	depends on HAVE_OPROFILE
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
@@ -29,6 +29,9 @@ config OPROFILE
 
 	  If unsure, say N.
 
+config HAVE_OPROFILE
+	def_bool n
+
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES && !UML
Index: linux-2.6-lttng/arch/alpha/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/alpha/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/alpha/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -5,6 +5,7 @@
 config ALPHA
 	bool
 	default y
+	select HAVE_OPROFILE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2008-02-02 15:05:46.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -10,6 +10,7 @@ config ARM
 	default y
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
+	select HAVE_OPROFILE
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
Index: linux-2.6-lttng/arch/blackfin/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/blackfin/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -24,6 +24,7 @@ config RWSEM_XCHGADD_ALGORITHM
 config BLACKFIN
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config ZONE_DMA
 	bool
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -15,6 +15,7 @@ config IA64
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
+	select HAVE_OPROFILE
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: linux-2.6-lttng/arch/m32r/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/m32r/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -8,6 +8,7 @@ mainmenu "Linux/M32R Kernel Configuratio
 config M32R
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config SBUS
 	bool
Index: linux-2.6-lttng/arch/mips/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/mips/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/mips/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -1,6 +1,7 @@
 config MIPS
 	bool
 	default y
+	select HAVE_OPROFILE
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
Index: linux-2.6-lttng/arch/parisc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/parisc/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/parisc/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -7,6 +7,7 @@ mainmenu "Linux/PA-RISC Kernel Configura
 
 config PARISC
 	def_bool y
+	select HAVE_OPROFILE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -87,6 +87,7 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -42,6 +42,7 @@ config GENERIC_CALIBRATE_DELAY
 config PPC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config PPC32
 	bool
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/s390/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -51,6 +51,7 @@ mainmenu "Linux Kernel Configuration"
 
 config S390
 	def_bool y
+	select HAVE_OPROFILE
 
 source "init/Kconfig"
 
Index: linux-2.6-lttng/arch/sh/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sh/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/sh/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -8,6 +8,7 @@ mainmenu "Linux/SuperH Kernel Configurat
 config SUPERH
 	def_bool y
 	select EMBEDDED
+	select HAVE_OPROFILE
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: linux-2.6-lttng/arch/sparc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/sparc/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -63,6 +63,7 @@ config NR_CPUS
 config SPARC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 # Identify this as a Sparc32 build
 config SPARC32
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -8,6 +8,7 @@ mainmenu "Linux/UltraSPARC Kernel Config
 config SPARC
 	bool
 	default y
+	select HAVE_OPROFILE
 
 config SPARC64
 	bool
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2008-02-02 15:06:13.000000000 -0500
@@ -18,6 +18,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select HAVE_OPROFILE
 
 config GENERIC_LOCKBREAK
 	def_bool n
@@ -106,10 +107,6 @@ config GENERIC_TIME_VSYSCALL
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64
 
-config ARCH_SUPPORTS_OPROFILE
-	bool
-	default y
-
 select HAVE_KVM
 
 config ARCH_HIBERNATION_POSSIBLE
Index: linux-2.6-lttng/arch/avr32/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig	2008-02-02 14:55:45.000000000 -0500
+++ linux-2.6-lttng/arch/avr32/Kconfig	2008-02-02 15:06:27.000000000 -0500
@@ -10,6 +10,7 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select HAVE_OPROFILE
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
@@ -54,9 +55,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config ARCH_SUPPORTS_OPROFILE
-	def_bool y
-
 config GENERIC_HWEIGHT
 	def_bool y
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
