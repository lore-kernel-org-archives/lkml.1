Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbZHUVbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbZHUVbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbZHUVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:15 -0400
Received: from www.tglx.de ([62.245.132.106]:51447 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbZHUVbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:12 -0400
Message-Id: <20090821205601.823408290@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:29:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 01/32] x86: Add platform_setup infrastructure
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-add-platform-setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The upcoming Moorestown support brings the embedded world to x86. The
setup code of x86 has already a couple of hooks which are either
x86_quirks or paravirt ops. Some of those setup hooks are pretty
convoluted like the timer setup and the tsc calibration code. But
there are other places which could do with a cleanup.

Instead of having inline functions/macros which are modified at
compile time I decided to introduce platform_setup ops which are
unconditional in the code and make it clear that they can be changed
either during compile time or in the early boot process. The function
pointers are initialized by default functions which can be noops so
that the pointer can be called unconditionally in the most cases. This
also allows us to remove 32bit/64bit, paravirt and other #ifdeffery.

paravirt guests are just a hardware platform in the setup code, so we
should treat them as such and not hide all behind multiple layers of
indirection and compile time dependencies.

It's obvious that platform_setup.timers.timer_init() is a function
pointer than late_time_init = choose_time_init() obscurity. It's also
way simpler to grep for platform_setup.timers.timer_init and find all
the places which modify that function pointer instead of analyzing
weak functions, macros and paravirt indirections.

Note. This is not a general paravirt_ops replacement. It just will
move setup related hooks which are potentially useful for other
platform setup purposes as well out of the paravirt domain.

Add the base infrastructure without any functionality.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/platform.h  |   23 +++++++++++++++++++++++
 arch/x86/include/asm/setup.h     |    2 ++
 arch/x86/kernel/Makefile         |    2 +-
 arch/x86/kernel/platform_setup.c |   17 +++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -0,0 +1,23 @@
+#ifndef _ASM_X86_PLATFORM_H
+#define _ASM_X86_PLATFORM_H
+
+/**
+ * struct platform_setup_quirks - platform specific quirks
+ *
+ */
+struct platform_setup_quirks {
+};
+
+/**
+ * struct platform_setup_ops - functions for platform specific setup
+ *
+ */
+struct platform_setup_ops {
+	struct platform_setup_quirks quirks;
+};
+
+extern struct platform_setup_ops platform_setup;
+
+extern void platform_setup_noop(void);
+
+#endif
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -7,6 +7,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/platform.h>
+
 /*
  * Any setup quirks to be performed?
  */
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -32,7 +32,7 @@ GCOV_PROFILE_paravirt.o		:= n
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
-obj-y			+= setup.o i8259.o irqinit.o
+obj-y			+= setup.o platform_setup.o i8259.o irqinit.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2009 Thomas Gleixner <tglx@linutronix.de>
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+#include <linux/init.h>
+
+#include <asm/platform.h>
+
+void __cpuinit platform_setup_noop(void) { }
+
+/*
+ * The platform setup functions are preset with the default functions
+ * for standard PC hardware.
+ */
+struct __initdata platform_setup_ops platform_setup = {
+};


