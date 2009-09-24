Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZIXPfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZIXPfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZIXPff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:35:35 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:39671 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbZIXPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:35:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAN8su0pMROOX/2dsb2JhbACBUtV4hBsF
Date: Thu, 24 Sep 2009 11:35:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch 10.2/12] Fix Immediate Values x86_64 support old gcc
Message-ID: <20090924153536.GB29580@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133400.512675657@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090924133400.512675657@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:33:57 up 37 days,  2:23,  3 users,  load average: 1.30, 0.67,
	0.48
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>
CC: Paul Mackerras <paulus@samba.org>
---
 Makefile                  |    5 +++++
 arch/powerpc/Makefile     |    2 ++
 arch/x86/Makefile         |    5 +++++
 include/linux/immediate.h |    2 +-
 include/linux/module.h    |    2 +-
 kernel/Makefile           |    2 +-
 kernel/module.c           |    6 +++---
 7 files changed, 18 insertions(+), 6 deletions(-)

Index: linux.trees.git/arch/x86/Makefile
===================================================================
--- linux.trees.git.orig/arch/x86/Makefile	2009-09-24 08:52:41.000000000 -0400
+++ linux.trees.git/arch/x86/Makefile	2009-09-24 10:53:59.000000000 -0400
@@ -41,6 +41,7 @@ ifeq ($(CONFIG_X86_32),y)
 
         # temporary until string.h is fixed
         KBUILD_CFLAGS += -ffreestanding
+        export USE_IMMEDIATE := $(CONFIG_IMMEDIATE)
 else
         BITS := 64
         UTS_MACHINE := x86_64
@@ -70,6 +71,10 @@ else
         # this works around some issues with generating unwind tables in older gccs
         # newer gccs do it by default
         KBUILD_CFLAGS += -maccumulate-outgoing-args
+
+        # x86_64 gcc 3.x has problems with passing symbol+offset in
+        # asm "i" constraint.
+        export USE_IMMEDIATE := $(call cc-ifversion, -ge, 0400, $(CONFIG_IMMEDIATE))
 endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
Index: linux.trees.git/include/linux/immediate.h
===================================================================
--- linux.trees.git.orig/include/linux/immediate.h	2009-09-24 10:53:51.000000000 -0400
+++ linux.trees.git/include/linux/immediate.h	2009-09-24 10:53:59.000000000 -0400
@@ -10,7 +10,7 @@
  * See the file COPYING for more details.
  */
 
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 
 struct __imv {
 	unsigned long var;	/* Pointer to the identifier variable of the
Index: linux.trees.git/kernel/Makefile
===================================================================
--- linux.trees.git.orig/kernel/Makefile	2009-09-24 09:20:19.000000000 -0400
+++ linux.trees.git/kernel/Makefile	2009-09-24 10:55:09.000000000 -0400
@@ -88,7 +88,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
-obj-$(CONFIG_IMMEDIATE) += immediate.o
+obj-$(USE_IMMEDIATE) += immediate.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
Index: linux.trees.git/arch/powerpc/Makefile
===================================================================
--- linux.trees.git.orig/arch/powerpc/Makefile	2009-09-24 08:52:40.000000000 -0400
+++ linux.trees.git/arch/powerpc/Makefile	2009-09-24 10:53:59.000000000 -0400
@@ -96,6 +96,8 @@ else
 LDFLAGS_MODULE	+= arch/powerpc/lib/crtsavres.o
 endif
 
+export USE_IMMEDIATE := $(CONFIG_IMMEDIATE)
+
 ifeq ($(CONFIG_TUNE_CELL),y)
 	KBUILD_CFLAGS += $(call cc-option,-mtune=cell)
 endif
Index: linux.trees.git/Makefile
===================================================================
--- linux.trees.git.orig/Makefile	2009-09-24 08:52:38.000000000 -0400
+++ linux.trees.git/Makefile	2009-09-24 10:53:59.000000000 -0400
@@ -550,6 +550,11 @@ ifdef CONFIG_FUNCTION_TRACER
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
Index: linux.trees.git/kernel/module.c
===================================================================
--- linux.trees.git.orig/kernel/module.c	2009-09-24 09:20:37.000000000 -0400
+++ linux.trees.git/kernel/module.c	2009-09-24 10:53:59.000000000 -0400
@@ -2237,7 +2237,7 @@ static noinline struct module *load_modu
 	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
 #endif
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 	mod->immediate = section_objs(hdr, sechdrs, secstrings, "__imv",
 					sizeof(*mod->immediate),
 					&mod->num_immediate);
@@ -2491,7 +2491,7 @@ SYSCALL_DEFINE3(init_module, void __user
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
 	module_put(mod);
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 	imv_unref(mod->immediate, mod->immediate + mod->num_immediate,
 		mod->module_init, mod->init_size);
 #endif
@@ -3011,7 +3011,7 @@ int module_get_iter_tracepoints(struct t
 }
 #endif
 
-#ifdef CONFIG_IMMEDIATE
+#ifdef USE_IMMEDIATE
 /**
  * _module_imv_update - update all immediate values in the kernel
  *
Index: linux.trees.git/include/linux/module.h
===================================================================
--- linux.trees.git.orig/include/linux/module.h	2009-09-24 10:53:51.000000000 -0400
+++ linux.trees.git/include/linux/module.h	2009-09-24 10:53:59.000000000 -0400
@@ -660,7 +660,7 @@ static inline int module_get_iter_tracep
 
 #endif /* CONFIG_MODULES */
 
-#if defined(CONFIG_MODULES) && defined(CONFIG_IMMEDIATE)
+#if defined(CONFIG_MODULES) && defined(USE_IMMEDIATE)
 extern void _module_imv_update(void);
 extern void module_imv_update(void);
 #else

