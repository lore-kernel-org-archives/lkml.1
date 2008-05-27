Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYE0NMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYE0NMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbYE0NMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:12:40 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:45278 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757281AbYE0NMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:12:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlAFAKSfO0hMQWqh/2dsb2JhbACBVawF
Date: Tue, 27 May 2008 09:12:36 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH ftrace.git sched-fixes.git] Fix Immediate Values x86_64
	support old gcc (v3)
Message-ID: <20080527131236.GB6814@Krystal>
References: <20080521160217.GA26974@Krystal> <20080521170150.GA29428@Krystal> <20080521203743.GA12982@uranus.ravnborg.org> <20080521212809.GE6158@Krystal> <20080521214608.GA15136@uranus.ravnborg.org> <20080521215756.GA9869@Krystal> <20080521223842.GE15136@uranus.ravnborg.org> <20080521232430.GA14754@Krystal> <20080522020309.GB19848@Krystal> <20080525072124.GA32250@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080525072124.GA32250@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:06:26 up 88 days,  9:17,  3 users,  load average: 0.67, 0.57,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC < 4, on x86_64, does not accept symbol+offset operands for "i" constraints
asm statements. Fallback on a memory read in lieue of immediate value if this
compiler is detected.

Changelog :
- USE_IMMEDIATE must now be used in lieue of CONFIG_IMMEDIATE in Makefiles and
  in C code.
- Every architecture implementing immediate values must declare USE_IMMEDIATE
  in their Makefile.
- Tab -> spaces in Makefiles.

It should be pulled in
linux-2.6-ftrace.git
and
linux-2.6-sched-fixes.git,
which are the two trees which seem to have immediate values support.

Note to David Miller : the sparc64 patch you proposed will have to be
updated to follow these changes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>
CC: Paul Mackerras <paulus@samba.org>
---
 Makefile                     |    5 +++++
 arch/powerpc/Makefile        |    2 ++
 arch/powerpc/kernel/Makefile |    2 +-
 arch/x86/Makefile            |    5 +++++
 arch/x86/kernel/Makefile     |    2 +-
 arch/x86/kernel/traps_32.c   |    4 ++--
 include/linux/immediate.h    |    2 +-
 include/linux/module.h       |    4 ++--
 kernel/Makefile              |    2 +-
 kernel/module.c              |    8 ++++----
 10 files changed, 24 insertions(+), 12 deletions(-)

Index: linux-2.6-sched-devel/arch/x86/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/Makefile	2008-05-21 15:16:06.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/Makefile	2008-05-21 15:53:00.000000000 -0400
@@ -43,6 +43,7 @@
 
         # temporary until string.h is fixed
         KBUILD_CFLAGS += -ffreestanding
+        export USE_IMMEDIATE := $(CONFIG_IMMEDIATE)
 else
         BITS := 64
         UTS_MACHINE := x86_64
@@ -78,6 +79,10 @@
                 "$(CC)" -fstack-protector-all )
 
         KBUILD_CFLAGS += $(stackp-y)
+
+        # x86_64 gcc 3.x has problems with passing symbol+offset in
+        # asm "i" constraint.
+        export USE_IMMEDIATE := $(call cc-ifversion, -ge, 0400, $(CONFIG_IMMEDIATE))
 endif
 
 # Stackpointer is addressed different for 32 bit and 64 bit x86
Index: linux-2.6-sched-devel/include/linux/immediate.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/immediate.h	2008-05-21 15:16:06.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/immediate.h	2008-05-21 15:16:59.000000000 -0400
@@ -10,7 +10,7 @@
  * See the file COPYING for more details.
  */
 
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 
 #include <asm/immediate.h>
 
Index: linux-2.6-sched-devel/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/Makefile	2008-05-21 15:16:51.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/Makefile	2008-05-21 15:16:59.000000000 -0400
@@ -75,7 +75,7 @@
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
-obj-$(CONFIG_IMMEDIATE)		+= immediate.o
+obj-$(USE_IMMEDIATE)		+= immediate.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
Index: linux-2.6-sched-devel/kernel/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/kernel/Makefile	2008-05-21 15:16:52.000000000 -0400
+++ linux-2.6-sched-devel/kernel/Makefile	2008-05-21 15:16:59.000000000 -0400
@@ -75,7 +75,7 @@
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
-obj-$(CONFIG_IMMEDIATE) += immediate.o
+obj-$(USE_IMMEDIATE) += immediate.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_FTRACE) += trace/
Index: linux-2.6-sched-devel/arch/powerpc/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/arch/powerpc/Makefile	2008-05-21 15:16:06.000000000 -0400
+++ linux-2.6-sched-devel/arch/powerpc/Makefile	2008-05-21 15:16:59.000000000 -0400
@@ -98,6 +98,8 @@
 endif
 endif
 
+export USE_IMMEDIATE := $(CONFIG_IMMEDIATE)
+
 ifeq ($(CONFIG_TUNE_CELL),y)
 	KBUILD_CFLAGS += $(call cc-option,-mtune=cell)
 endif
Index: linux-2.6-sched-devel/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/Makefile	2008-05-21 15:16:51.000000000 -0400
+++ linux-2.6-sched-devel/Makefile	2008-05-21 15:16:59.000000000 -0400
@@ -532,6 +532,11 @@
 KBUILD_CFLAGS	+= -pg
 endif
 
+# arch Makefile detects if the compiler permits use of immediate values
+ifdef USE_IMMEDIATE
+KBUILD_CFLAGS	+= -DUSE_IMMEDIATE
+endif
+
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
Index: linux-2.6-sched-devel/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/arch/powerpc/kernel/Makefile	2008-05-21 15:16:06.000000000 -0400
+++ linux-2.6-sched-devel/arch/powerpc/kernel/Makefile	2008-05-21 15:16:59.000000000 -0400
@@ -45,7 +45,7 @@
 obj64-$(CONFIG_HIBERNATION)	+= swsusp_asm64.o
 obj-$(CONFIG_MODULES)		+= module_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_44x)		+= cpu_setup_44x.o
-obj-$(CONFIG_IMMEDIATE)		+= immediate.o
+obj-$(USE_IMMEDIATE)		+= immediate.o
 
 ifeq ($(CONFIG_PPC_MERGE),y)
 
Index: linux-2.6-sched-devel/kernel/module.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/module.c	2008-05-21 15:16:52.000000000 -0400
+++ linux-2.6-sched-devel/kernel/module.c	2008-05-21 15:16:59.000000000 -0400
@@ -2013,7 +2013,7 @@
 	mod->gpl_future_syms = (void *)sechdrs[gplfutureindex].sh_addr;
 	if (gplfuturecrcindex)
 		mod->gpl_future_crcs = (void *)sechdrs[gplfuturecrcindex].sh_addr;
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 	mod->immediate = (void *)sechdrs[immediateindex].sh_addr;
 	mod->num_immediate =
 		sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
@@ -2097,7 +2097,7 @@
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 		/* Immediate values must be updated after markers */
 		imv_update_range(mod->immediate,
 			mod->immediate + mod->num_immediate);
@@ -2258,7 +2258,7 @@
 	/* Drop initial reference. */
 	module_put(mod);
 	unwind_remove_table(mod->unwind_info, 1);
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 	imv_unref(mod->immediate, mod->immediate + mod->num_immediate,
 		mod->module_init, mod->init_size);
 #endif
@@ -2657,7 +2657,7 @@
 }
 #endif
 
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 /**
  * _module_imv_update - update all immediate values in the kernel
  *
Index: linux-2.6-sched-devel/include/linux/module.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/module.h	2008-05-21 15:16:52.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/module.h	2008-05-21 15:16:59.000000000 -0400
@@ -339,7 +339,7 @@
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
 	char *args;
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 	struct __imv *immediate;
 	unsigned int num_immediate;
 	unsigned long *immediate_cond_end;
@@ -563,7 +563,7 @@
 
 #endif /* CONFIG_MODULES */
 
-#if defined(CONFIG_MODULES) && defined(CONFIG_IMMEDIATE)
+#if defined(CONFIG_MODULES) && defined(USE_IMMEDIATE)
 extern void _module_imv_update(void);
 extern void module_imv_update(void);
 extern int is_imv_cond_end_module(unsigned long addr1, unsigned long addr2);
Index: linux-2.6-sched-devel/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/traps_32.c	2008-05-21 15:16:06.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/traps_32.c	2008-05-21 15:16:59.000000000 -0400
@@ -595,7 +595,7 @@
 }
 
 DO_VM86_ERROR_INFO(0, SIGFPE,  "divide error", divide_error, FPE_INTDIV, regs->ip)
-#if !defined(CONFIG_KPROBES) && !defined(CONFIG_IMMEDIATE)
+#if !defined(CONFIG_KPROBES) && !defined(USE_IMMEDIATE)
 DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
@@ -860,7 +860,7 @@
 	acpi_nmi_enable();
 }
 
-#if defined(CONFIG_KPROBES) || defined(CONFIG_IMMEDIATE)
+#if defined(CONFIG_KPROBES) || defined(USE_IMMEDIATE)
 void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	trace_hardirqs_fixup();

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
