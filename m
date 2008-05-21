Return-Path: <linux-kernel-owner+w=401wt.eu-S934799AbYEURCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934799AbYEURCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYEURCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:02:20 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:46939 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbYEURCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:02:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroFAN/yM0hMQWqh/2dsb2JhbACBVa57
Date: Wed, 21 May 2008 13:01:50 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Fix Immediate Values x86_64 support old gcc
Message-ID: <20080521170150.GA29428@Krystal>
References: <482AB6C5.4060604@goop.org> <20080516124811.GC4226@Krystal> <482DFD65.10300@zytor.com> <20080521133122.GA18084@Krystal> <48344239.9070003@zytor.com> <20080521160217.GA26974@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080521160217.GA26974@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:58:27 up 82 days, 13:09,  5 users,  load average: 1.60, 1.37,
	1.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this fix make more sense ?

GCC < 4, on x86_64, does not accept symbol+offset operands for "i" constraints
asm statements. Fallback on generic immediate values if this compiler is
detected.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/Makefile           |    3 +++
 arch/x86/kernel/Makefile    |    4 +++-
 include/asm-x86/immediate.h |    5 +++++
 include/linux/immediate.h   |    4 +++-
 kernel/Makefile             |    4 +++-
 5 files changed, 17 insertions(+), 3 deletions(-)

Index: linux-2.6-sched-devel/arch/x86/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/Makefile	2008-05-21 09:04:52.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/Makefile	2008-05-21 09:22:05.000000000 -0400
@@ -78,6 +78,9 @@
                 "$(CC)" -fstack-protector-all )
 
         KBUILD_CFLAGS += $(stackp-y)
+
+	export GCC_BROKEN_IMMEDIATE
+	GCC_BROKEN_IMMEDIATE := $(shell if [ $(call cc-version) -lt 0400 ] ; then echo "y"; fi)
 endif
 
 # Stackpointer is addressed different for 32 bit and 64 bit x86
Index: linux-2.6-sched-devel/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-sched-devel.orig/include/asm-x86/immediate.h	2008-05-21 09:10:59.000000000 -0400
+++ linux-2.6-sched-devel/include/asm-x86/immediate.h	2008-05-21 09:15:43.000000000 -0400
@@ -12,6 +12,10 @@
 
 #include <asm/asm.h>
 
+#if (defined(CONFIG_X86_64) && __GNUC__ < 4)	/* Detect broken x86_64 gcc */
+#undef CONFIG_IMMEDIATE
+#else
+
 struct __imv {
 	unsigned long var;	/* Pointer to the identifier variable of the
 				 * immediate value
@@ -166,4 +170,5 @@
 
 extern int arch_imv_update(struct __imv *imv, int early);
 
+#endif
 #endif /* _ASM_X86_IMMEDIATE_H */
Index: linux-2.6-sched-devel/include/linux/immediate.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/immediate.h	2008-05-21 09:12:22.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/immediate.h	2008-05-21 09:12:59.000000000 -0400
@@ -11,8 +11,10 @@
  */
 
 #ifdef CONFIG_IMMEDIATE
+#include <asm/immediate.h>	/* May undef CONFIG_IMMEDIATE */
+#endif
 
-#include <asm/immediate.h>
+#ifdef CONFIG_IMMEDIATE
 
 /**
  * imv_set - set immediate variable (with locking)
Index: linux-2.6-sched-devel/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/Makefile	2008-05-21 09:20:49.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/Makefile	2008-05-21 09:21:22.000000000 -0400
@@ -75,7 +75,9 @@
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
-obj-$(CONFIG_IMMEDIATE)		+= immediate.o
+ifneq ($(GCC_BROKEN_IMMEDIATE),y)
+	obj-$(CONFIG_IMMEDIATE)	+= immediate.o
+endif
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
Index: linux-2.6-sched-devel/kernel/Makefile
===================================================================
--- linux-2.6-sched-devel.orig/kernel/Makefile	2008-05-21 09:21:28.000000000 -0400
+++ linux-2.6-sched-devel/kernel/Makefile	2008-05-21 09:21:44.000000000 -0400
@@ -75,7 +75,9 @@
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
-obj-$(CONFIG_IMMEDIATE) += immediate.o
+ifneq ($(GCC_BROKEN_IMMEDIATE),y)
+	obj-$(CONFIG_IMMEDIATE) += immediate.o
+endif
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_FTRACE) += trace/

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
