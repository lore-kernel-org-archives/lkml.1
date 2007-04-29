Return-Path: <linux-kernel-owner+w=401wt.eu-S1161590AbXD2Xt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161590AbXD2Xt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161616AbXD2XrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:41950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161597AbXD2XqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:24 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [14/26] x86_64: Clean up asm-x86_64/bugs.h
Message-Id: <20070429234623.9FCA3150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Most of asm-x86_64/bugs.h is code which should be in a C file, so put it there.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

---
 arch/x86_64/kernel/Makefile      |    3 ++-
 arch/x86_64/kernel/bugs.c        |   28 ++++++++++++++++++++++++++++
 include/asm-x86_64/alternative.h |    1 +
 include/asm-x86_64/bugs.h        |   30 ++++--------------------------
 4 files changed, 35 insertions(+), 27 deletions(-)

===================================================================
Index: linux/arch/x86_64/kernel/Makefile
===================================================================
--- linux.orig/arch/x86_64/kernel/Makefile
+++ linux/arch/x86_64/kernel/Makefile
@@ -8,7 +8,8 @@ obj-y	:= process.o signal.o entry.o trap
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
-		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o sched-clock.o
+		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o sched-clock.o \
+		bugs.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
Index: linux/arch/x86_64/kernel/bugs.c
===================================================================
--- /dev/null
+++ linux/arch/x86_64/kernel/bugs.c
@@ -0,0 +1,28 @@
+/*
+ *  arch/x86_64/kernel/bugs.c
+ *
+ *  Copyright (C) 1994  Linus Torvalds
+ *  Copyright (C) 2000  SuSE
+ *
+ * This is included by init/main.c to check for architecture-dependent bugs.
+ *
+ * Needs:
+ *	void check_bugs(void);
+ */
+
+#include <linux/kernel.h>
+#include <asm/alternative.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+#include <asm/msr.h>
+#include <asm/pda.h>
+
+void __init check_bugs(void)
+{
+	identify_cpu(&boot_cpu_data);
+#if !defined(CONFIG_SMP)
+	printk("CPU: ");
+	print_cpu_info(&boot_cpu_data);
+#endif
+	alternative_instructions();
+}
Index: linux/include/asm-x86_64/alternative.h
===================================================================
--- linux.orig/include/asm-x86_64/alternative.h
+++ linux/include/asm-x86_64/alternative.h
@@ -16,6 +16,7 @@ struct alt_instr {
 	u8  pad[5];
 };
 
+extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
 struct module;
Index: linux/include/asm-x86_64/bugs.h
===================================================================
--- linux.orig/include/asm-x86_64/bugs.h
+++ linux/include/asm-x86_64/bugs.h
@@ -1,28 +1,6 @@
-/*
- *  include/asm-x86_64/bugs.h
- *
- *  Copyright (C) 1994  Linus Torvalds
- *  Copyright (C) 2000  SuSE
- *
- * This is included by init/main.c to check for architecture-dependent bugs.
- *
- * Needs:
- *	void check_bugs(void);
- */
+#ifndef _ASM_X86_64_BUGS_H
+#define _ASM_X86_64_BUGS_H
 
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/pda.h>
+void check_bugs(void);
 
-extern void alternative_instructions(void);
-
-static void __init check_bugs(void)
-{
-	identify_cpu(&boot_cpu_data);
-#if !defined(CONFIG_SMP)
-	printk("CPU: ");
-	print_cpu_info(&boot_cpu_data);
-#endif
-	alternative_instructions(); 
-}
+#endif	/* _ASM_X86_64_BUGS_H */
