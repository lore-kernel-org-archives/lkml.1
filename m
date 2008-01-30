Return-Path: <linux-kernel-owner+w=401wt.eu-S1764370AbYA3XIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764370AbYA3XIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763161AbYA3XIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:08:10 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:42953 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763573AbYA3XII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:08:08 -0500
Message-ID: <47A10355.9090707@web.de>
Date: Thu, 31 Jan 2008 00:08:05 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 1/5] KGDB: improve early init
References: <479FBA3B.5050209@web.de>
In-Reply-To: <479FBA3B.5050209@web.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/FKV630mBUETiAugYywH/lFeEDBqWcAjvyROqh
	QC8cMK5JrXnpBcxVaihgVMPrJLJ1S+TFbb4IO1FQpWvFF6Re/0
	mcyt3/PbE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Here comes a rebased version against latest x86/mm]

In case "kgdbwait" is passed as kernel parameter, KGDB tries to set up
and connect to the front-end already during early_param evaluation. This
fails on x86 as the exception stack is not yet initialized, effectively
delaying kgdbwait until late-init.

Therefore, this patch hooks into the x86 trap initialization and
re-triggers the KGDB setup, including a potential early rendezvous with
gdb. As a precondition, KGDB's setup states are refactored once again to
allow multiple invocations of kgdb_early_entry and correct tracking of
pending kgdbwait requests.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 arch/x86/kernel/traps_32.c |    4 +++
 arch/x86/kernel/traps_64.c |    4 +++
 include/linux/kgdb.h       |    7 +++++-
 kernel/kgdb.c              |   52 +++++++++++++++++++++++++--------------------
 4 files changed, 44 insertions(+), 23 deletions(-)

Index: b/arch/x86/kernel/traps_32.c
===================================================================
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -25,6 +25,7 @@
 #include <linux/utsname.h>
 #include <linux/kprobes.h>
 #include <linux/kexec.h>
+#include <linux/kgdb.h>
 #include <linux/unwind.h>
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
@@ -1215,6 +1216,9 @@ void __init trap_init(void)
 	 */
 	cpu_init();
 
+	/* With the TSS set up, it's now save to arm early KGDB. */
+	kgdb_early_entry();
+
 	trap_init_hook();
 }
 
Index: b/arch/x86/kernel/traps_64.c
===================================================================
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -27,6 +27,7 @@
 #include <linux/nmi.h>
 #include <linux/kprobes.h>
 #include <linux/kexec.h>
+#include <linux/kgdb.h>
 #include <linux/unwind.h>
 #include <linux/uaccess.h>
 #include <linux/bug.h>
@@ -1162,6 +1163,9 @@ void __init trap_init(void)
 	 * Should be a barrier for any external CPU state.
 	 */
 	cpu_init();
+
+	/* With the TSS set up, it's now save to arm early KGDB. */
+	kgdb_early_entry();
 }
 
 
Index: b/include/linux/kgdb.h
===================================================================
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -43,7 +43,8 @@ extern struct task_struct	*kgdb_contthre
 
 enum kgdb_initstate {
 	KGDB_UNINITIALIZED = 0,
-	KGDB_SEMI_INITIALIZED,
+	KGDB_ARCH_INITIALIZED,
+	KGDB_DELAYED_CONNECTION,
 	KGDB_FULLY_INITIALIZED
 };
 
@@ -287,6 +288,8 @@ int kgdb_handle_exception(int ex_vector,
 			  struct pt_regs *regs);
 int kgdb_nmihook(int cpu, void *regs);
 
+void __init kgdb_early_entry(void);
+
 extern int		debugger_step;
 extern atomic_t		debugger_active;
 
@@ -296,6 +299,8 @@ extern atomic_t		debugger_active;
 
 #else /* !CONFIG_KGDB */
 static const atomic_t	debugger_active = ATOMIC_INIT(0);
+
+static inline void kgdb_early_entry(void) { }
 #endif /* !CONFIG_KGDB */
 
 #endif /* _KGDB_H_ */
Index: b/kernel/kgdb.c
===================================================================
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -2104,33 +2104,41 @@ void kgdb_unregister_io_module(struct kg
 }
 EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
 
+static void __init kgdb_initial_breakpoint(void)
+{
+	printk(KERN_CRIT "kgdb: Waiting for connection from remote gdb...\n");
+	breakpoint();
+}
+
 /*
  * This function can be called very early, either via early_param() or
  * an explicit breakpoint() early on.
  */
-static void __init kgdb_early_entry(void)
+void __init kgdb_early_entry(void)
 {
+	int need_break = (kgdb_state == KGDB_DELAYED_CONNECTION);
+
 	/* Let the architecture do any setup that it needs to. */
-	kgdb_arch_init();
+	if (kgdb_state == KGDB_UNINITIALIZED) {
+		kgdb_arch_init();
+		kgdb_state = KGDB_ARCH_INITIALIZED;
+	}
 
 	/*
 	 * Don't try and do anything until the architecture is able to
 	 * setup the exception stack.  In this case, it is up to the
 	 * architecture to hook in and look at us when they are ready.
 	 */
-	if (!EXCEPTION_STACK_READY()) {
-		kgdb_state = KGDB_SEMI_INITIALIZED;
-		/* any kind of break point is deferred to late_init */
+	if (!EXCEPTION_STACK_READY())
 		return;
-	}
 
 	/*
 	 * Now try the I/O.
 	 * For early entry kgdb_io_ops.init must be defined
 	 */
 	if (!kgdb_io_ops.init || kgdb_io_ops.init()) {
-		/* Try again later. */
-		kgdb_state = KGDB_SEMI_INITIALIZED;
+		printk(KERN_ERR "kgdb: Could not setup core I/O for KGDB.\n");
+		printk(KERN_INFO "kgdb: Defering I/O setup to late init.\n");
 		return;
 	}
 
@@ -2145,6 +2153,9 @@ static void __init kgdb_early_entry(void
 	 */
 	if (kgdb_io_ops.init)
 		kgdb_register_for_panic();
+
+	if (need_break)
+		kgdb_initial_breakpoint();
 }
 
 /*
@@ -2155,14 +2166,16 @@ static void __init kgdb_early_entry(void
  */
 static int __init kgdb_late_entry(void)
 {
-	int need_break = (kgdb_state == KGDB_SEMI_INITIALIZED);
+	int need_break = (kgdb_state == KGDB_DELAYED_CONNECTION);
 
 	/*
 	 * If we haven't tried to initialize KGDB yet, we need to call
 	 * kgdb_arch_init before moving onto the I/O.
 	 */
-	if (kgdb_state == KGDB_UNINITIALIZED)
+	if (kgdb_state == KGDB_UNINITIALIZED) {
 		kgdb_arch_init();
+		kgdb_state = KGDB_ARCH_INITIALIZED;
+	}
 
 	if (kgdb_state != KGDB_FULLY_INITIALIZED) {
 		if (kgdb_io_ops.init && kgdb_io_ops.init()) {
@@ -2177,6 +2190,7 @@ static int __init kgdb_late_entry(void)
 			printk(KERN_INFO "kgdb: Defering I/O setup to kernel "
 					 "module.\n");
 			memset(&kgdb_io_ops, 0, sizeof(struct kgdb_io));
+			need_break = 0;
 		}
 
 		kgdb_internal_init();
@@ -2198,11 +2212,8 @@ static int __init kgdb_late_entry(void)
 	if (kgdb_io_ops.late_init)
 		kgdb_io_ops.late_init();
 
-	if (need_break) {
-		printk(KERN_CRIT "kgdb: Waiting for connection from remote"
-				 " gdb...\n");
-		breakpoint();
-	}
+	if (need_break)
+		kgdb_initial_breakpoint();
 
 	return 0;
 }
@@ -2290,14 +2301,11 @@ static int __init opt_kgdb_enter(char *s
 
 	kgdb_early_entry();
 	attachwait = 1;
-	if (kgdb_state == KGDB_FULLY_INITIALIZED)
-		printk(KERN_CRIT "Waiting for connection from remote gdb...\n");
-	else {
-		printk(KERN_CRIT "KGDB cannot initialize I/O yet.\n");
-		return 0;
-	}
 
-	breakpoint();
+	if (kgdb_state == KGDB_FULLY_INITIALIZED)
+		kgdb_initial_breakpoint();
+	else
+		kgdb_state = KGDB_DELAYED_CONNECTION;
 
 	return 0;
 }
