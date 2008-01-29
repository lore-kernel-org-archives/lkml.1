Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYA2Xoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYA2Xoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbYA2XoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:44:03 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:56627 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbYA2Xn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:43:57 -0500
Message-ID: <479FBA3B.5050209@web.de>
Date: Wed, 30 Jan 2008 00:43:55 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 1/5] KGDB: improve early init
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX1+pviagzlYvzMXa3lf2kiQasXjSM+zm1RvHozkp
	mq85l9Dvn014elqNET+XjTwLXRfQAXDmEmm6KpyqVPAoh0jx1B
	VoaLHq0tM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Warning in advance]
This patch reintroduces the early KGDB_CONSOLE registration issue: If
you switch this on, trigger the debugger before any tty-providing
console was registered and you do not provide an explicit console=
parameter, you end up with a panic due to lacking /dev/console. But this
time I have a better fix (for register_console), will be posted
separately later on.

<--snip-->

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
 include/linux/kgdb.h       |    7 ++++-
 kernel/kgdb.c              |   55 ++++++++++++++++++++++++---------------------
 4 files changed, 44 insertions(+), 26 deletions(-)

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
@@ -46,7 +46,8 @@ extern struct task_struct *kgdb_usethrea
 
 enum kgdb_initstate {
 	KGDB_UNINITIALIZED = 0,
-	KGDB_SEMI_INITIALIZED,
+	KGDB_ARCH_INITIALIZED,
+	KGDB_DELAYED_CONNECTION,
 	KGDB_FULLY_INITIALIZED
 };
 
@@ -286,11 +287,15 @@ int kgdb_handle_exception(int ex_vector,
 			  struct pt_regs *regs);
 int kgdb_nmihook(int cpu, void *regs);
 
+void __init kgdb_early_entry(void);
+
 extern int debugger_step;
 extern atomic_t debugger_active;
 
 #else /* !CONFIG_KGDB */
 static const atomic_t debugger_active = ATOMIC_INIT(0);
+
+static inline void kgdb_early_entry(void) { }
 #endif /* !CONFIG_KGDB */
 
 #endif /* _KGDB_H_ */
Index: b/kernel/kgdb.c
===================================================================
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1925,32 +1925,39 @@ void kgdb_unregister_io_module(struct kg
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
-
-	if (!EXCEPTION_STACK_READY()) {
-		kgdb_state = KGDB_SEMI_INITIALIZED;
-		/* any kind of break point is deferred to late_init */
+	if (!EXCEPTION_STACK_READY())
 		return;
-	}
 
 	/* Now try the I/O. */
 	/* For early entry kgdb_io_ops.init must be defined */
 	if (!kgdb_io_ops.init || kgdb_io_ops.init()) {
-		/* Try again later. */
-		kgdb_state = KGDB_SEMI_INITIALIZED;
+		printk(KERN_ERR "kgdb: Could not setup core I/O for KGDB.\n");
+		printk(KERN_INFO "kgdb: Defering I/O setup to late init.\n");
 		return;
 	}
 
@@ -1964,6 +1971,9 @@ static void __init kgdb_early_entry(void
 	 */
 	if (kgdb_io_ops.init)
 		kgdb_register_for_panic();
+
+	if (need_break)
+		kgdb_initial_breakpoint();
 }
 
 /*
@@ -1974,14 +1984,16 @@ static void __init kgdb_early_entry(void
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
@@ -2015,11 +2027,8 @@ static int __init kgdb_late_entry(void)
 	if (kgdb_io_ops.late_init)
 		kgdb_io_ops.late_init();
 
-	if (need_break) {
-		printk(KERN_CRIT "kgdb: Waiting for connection from remote"
-		       " gdb...\n");
-		breakpoint();
-	}
+	if (need_break)
+		kgdb_initial_breakpoint();
 
 	return 0;
 }
@@ -2072,7 +2081,6 @@ module_init(gdb_register_sysrq);
 static int kgdb_notify_reboot(struct notifier_block *this,
 		unsigned long code, void *x)
 {
-
 	unsigned long flags;
 
 	/* If we're debugging, or KGDB has not connected, don't try
@@ -2093,6 +2101,7 @@ static int __init opt_kgdb_attachwait(ch
 	attachwait = 1;
 	return 0;
 }
+
 static int __init opt_kgdb_enter(char *str)
 {
 	/* We've already done this by an explicit breakpoint() call. */
@@ -2101,15 +2110,11 @@ static int __init opt_kgdb_enter(char *s
 
 	kgdb_early_entry();
 	attachwait = 1;
-	if (kgdb_state == KGDB_FULLY_INITIALIZED)
-		printk(KERN_CRIT "Waiting for connection from remote "
-		       "gdb...\n");
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
