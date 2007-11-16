Return-Path: <linux-kernel-owner+w=401wt.eu-S933752AbXKPCjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbXKPCjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbXKPCiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:38:13 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37401 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759146AbXKPCiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:38:12 -0500
Message-Id: <20071116023804.267352847@polymtl.ca>
References: <20071116023652.570920557@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 15 Nov 2007 21:36:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [patch 3/4] Add ARCH_SUPPORTS_KPROBES
Content-Disposition: inline; filename=add-arch-supports-kprobes.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 02:38:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
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

        config KPROBES_SUPPORT
                def_bool y

instead, which is a bit denser.

We seem to use both kinds of syntax for these things, but this is really
what "def_bool" is there for...

- Use ARCH_HAS_KPROBES
- Use a select

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/avr32/Kconfig             |    1 +
 arch/ia64/Kconfig              |    1 +
 arch/powerpc/Kconfig           |    1 +
 arch/ppc/Kconfig               |    1 +
 arch/s390/Kconfig              |    1 +
 arch/sparc64/Kconfig           |    1 +
 arch/x86/Kconfig               |    1 +
 kernel/Kconfig.instrumentation |    5 ++++-
 8 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/avr32/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig	2007-11-15 21:18:40.000000000 -0500
+++ linux-2.6-lttng/arch/avr32/Kconfig	2007-11-15 21:24:51.000000000 -0500
@@ -11,6 +11,7 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select ARCH_HAS_KPROBES
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2007-11-15 21:23:35.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/Kconfig	2007-11-15 21:33:43.000000000 -0500
@@ -16,6 +16,7 @@ config IA64
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
 	select ARCH_HAS_OPROFILE
+	select ARCH_HAS_KPROBES
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-11-15 21:23:35.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-11-15 21:33:43.000000000 -0500
@@ -80,6 +80,7 @@ config PPC
 	bool
 	default y
 	select ARCH_HAS_OPROFILE
+	select ARCH_HAS_KPROBES
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2007-11-15 21:23:35.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/Kconfig	2007-11-15 21:33:43.000000000 -0500
@@ -43,6 +43,7 @@ config PPC
 	bool
 	default y
 	select ARCH_HAS_OPROFILE
+	select ARCH_HAS_KPROBES
 
 config PPC32
 	bool
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2007-11-15 21:23:35.000000000 -0500
+++ linux-2.6-lttng/arch/s390/Kconfig	2007-11-15 21:33:43.000000000 -0500
@@ -52,6 +52,7 @@ mainmenu "Linux Kernel Configuration"
 config S390
 	def_bool y
 	select ARCH_HAS_OPROFILE
+	select ARCH_HAS_KPROBES
 
 source "init/Kconfig"
 
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2007-11-15 21:23:35.000000000 -0500
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2007-11-15 21:33:43.000000000 -0500
@@ -9,6 +9,7 @@ config SPARC
 	bool
 	default y
 	select ARCH_HAS_OPROFILE
+	select ARCH_HAS_KPROBES
 
 config SPARC64
 	bool
Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2007-11-15 21:23:35.000000000 -0500
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2007-11-15 21:33:43.000000000 -0500
@@ -35,7 +35,7 @@ config ARCH_HAS_OPROFILE
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	depends on ARCH_HAS_KPROBES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -43,6 +43,9 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config ARCH_HAS_KPROBES
+	def_bool n
+
 config MARKERS
 	bool "Activate markers"
 	help
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2007-11-15 21:25:00.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2007-11-15 21:34:59.000000000 -0500
@@ -20,6 +20,7 @@ config X86
 	bool
 	default y
 	select ARCH_HAS_OPROFILE
+	select ARCH_HAS_KPROBES
 
 config GENERIC_TIME
 	bool

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
