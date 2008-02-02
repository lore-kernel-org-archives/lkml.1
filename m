Return-Path: <linux-kernel-owner+w=401wt.eu-S934847AbYBBUNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847AbYBBUNi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764119AbYBBUM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:12:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:44599 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761212AbYBBUMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:12:55 -0500
Message-Id: <20080202201200.726040222@polymtl.ca>
References: <20080202201031.860344390@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 02 Feb 2008 15:10:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
       David Howells <dhowells@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [patch 4/5] Add HAVE_KPROBES
Content-Disposition: inline; filename=add-have-kprobes.patch
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

        config KPROBES_SUPPORT
                def_bool y

instead, which is a bit denser.

We seem to use both kinds of syntax for these things, but this is really
what "def_bool" is there for...

- Use HAVE_KPROBES
- Use a select

- Yet another update :
Moving to HAVE_* now.

- Update ARM for kprobes support.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/arm/Kconfig               |    1 +
 arch/avr32/Kconfig             |    1 +
 arch/ia64/Kconfig              |    1 +
 arch/powerpc/Kconfig           |    1 +
 arch/ppc/Kconfig               |    1 +
 arch/s390/Kconfig              |    1 +
 arch/sparc64/Kconfig           |    1 +
 arch/x86/Kconfig               |    1 +
 kernel/Kconfig.instrumentation |    5 ++++-
 9 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/avr32/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig	2008-02-01 07:37:17.000000000 -0500
+++ linux-2.6-lttng/arch/avr32/Kconfig	2008-02-01 07:37:51.000000000 -0500
@@ -11,6 +11,7 @@ config AVR32
 	# that we usually don't need on AVR32.
 	select EMBEDDED
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: linux-2.6-lttng/arch/ia64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ia64/Kconfig	2008-02-01 07:37:17.000000000 -0500
+++ linux-2.6-lttng/arch/ia64/Kconfig	2008-02-01 07:39:09.000000000 -0500
@@ -16,6 +16,7 @@ config IA64
 	select PM if (!IA64_HP_SIM)
 	select ARCH_SUPPORTS_MSI
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2008-02-01 07:37:17.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2008-02-01 07:39:09.000000000 -0500
@@ -88,6 +88,7 @@ config PPC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6-lttng/arch/ppc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/ppc/Kconfig	2008-02-01 07:37:17.000000000 -0500
+++ linux-2.6-lttng/arch/ppc/Kconfig	2008-02-01 07:39:09.000000000 -0500
@@ -43,6 +43,7 @@ config PPC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config PPC32
 	bool
Index: linux-2.6-lttng/arch/s390/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/s390/Kconfig	2008-02-01 07:37:17.000000000 -0500
+++ linux-2.6-lttng/arch/s390/Kconfig	2008-02-01 07:39:09.000000000 -0500
@@ -52,6 +52,7 @@ mainmenu "Linux Kernel Configuration"
 config S390
 	def_bool y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 source "init/Kconfig"
 
Index: linux-2.6-lttng/arch/sparc64/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/sparc64/Kconfig	2008-02-01 07:37:17.000000000 -0500
+++ linux-2.6-lttng/arch/sparc64/Kconfig	2008-02-01 07:39:09.000000000 -0500
@@ -9,6 +9,7 @@ config SPARC
 	bool
 	default y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config SPARC64
 	bool
Index: linux-2.6-lttng/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6-lttng.orig/kernel/Kconfig.instrumentation	2008-02-01 07:37:17.000000000 -0500
+++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2008-02-01 07:39:09.000000000 -0500
@@ -35,7 +35,7 @@ config HAVE_OPROFILE
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES && !UML
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32 || (ARM && !XIP_KERNEL)
+	depends on HAVE_KPROBES
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -43,6 +43,9 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config HAVE_KPROBES
+	def_bool n
+
 config MARKERS
 	bool "Activate markers"
 	help
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2008-02-01 07:37:47.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2008-02-01 07:39:09.000000000 -0500
@@ -19,6 +19,7 @@ config X86_64
 config X86
 	def_bool y
 	select HAVE_OPROFILE
+	select HAVE_KPROBES
 
 config GENERIC_LOCKBREAK
 	def_bool n
Index: linux-2.6-lttng/arch/arm/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/arm/Kconfig	2008-02-01 07:39:34.000000000 -0500
+++ linux-2.6-lttng/arch/arm/Kconfig	2008-02-01 07:41:06.000000000 -0500
@@ -11,6 +11,7 @@ config ARM
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
 	select HAVE_OPROFILE
+	select HAVE_KPROBES if (!XIP_KERNEL)
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
