Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbYAaXGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbYAaXGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbYAaXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:06:30 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:55136 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbYAaXG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:06:28 -0500
Message-ID: <47A25472.3030403@web.de>
Date: Fri, 01 Feb 2008 00:06:26 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: george@wildturkeyranch.net, Jason Wessel <jason.wessel@windriver.com>,
       Ingo Molnar <mingo@elte.hu>
CC: kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Kgdb-bugreport] [PATCH 1/5] KGDB: improve early init
References: <479FBA3B.5050209@web.de> <47A10355.9090707@web.de> <47A1D9AE.4090206@wildturkeyranch.net> <47A1DE37.9060202@web.de>
In-Reply-To: <47A1DE37.9060202@web.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+boMZnAap83kRwAqm7Q/C/A5TxRpeChPZ1WtPp
	hGTKjvpJm1JGsKfGDfcaOUya3oymIDT0h2vi17kIDmK1NXHIS1
	1iqYDlAOU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> George Anzinger wrote:
>> On 01/31/2008 01:36 AM,  Jan Kiszka was caught saying:
>>> BTW, do you know if EXCEPTION_STACK_READY fails for other archs in
>>> parse_early_param as well? It should, because my under standing of
>>> trap_init is that it's the functions to arm things like... exception
>>> handlers? And that raises the question of the deeper purpose of this
>>> check (and the invocation of kgdb_early_init from the argument parsing
>>> function). Sigh, KGDB is still a quite improvable piece of code.
>> Likely.  Once you get it in the main line kernel, one would hope that
>> other arch code would be forth coming as many more "eyes" will be in play.
> 
> Meanwhile I realized that there is early_trap_init - for x86-32 only! I
> assume now we are only lacking the same for x86-64 to get kgdb running
> there already during early_param-parsing.

Looks like that was the key. Thanks for pointing me at this, George.
Here the updated patch:

------snip-------

This cleans up the early entry of kgdb. It introduces early_trap_init
for x86-64, reloads the idt register also in the 32-bit variant, removes
the now unneeded EXCEPTION_STACK_READY construction, and matures the
init-state machine of kgdb.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 arch/x86/kernel/setup_64.c |    4 +++
 arch/x86/kernel/traps_32.c |    3 +-
 arch/x86/kernel/traps_64.c |   10 ++++++++-
 include/asm-x86/kgdb.h     |    3 --
 include/linux/kgdb.h       |    7 +-----
 kernel/kgdb.c              |   47 +++++++++++++++++++--------------------------
 6 files changed, 37 insertions(+), 37 deletions(-)

Index: b/arch/x86/kernel/traps_32.c
===================================================================
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1137,12 +1137,13 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
-/* Some traps need to be set early. */
+/* Set of traps needed for early debugging. */
 void __init early_trap_init(void)
 {
 	set_intr_gate(1, &debug);
 	set_system_intr_gate(3, &int3); /* int3 can be called from all */
 	set_intr_gate(14, &page_fault);
+	load_idt(&idt_descr);
 }
 
 void __init trap_init(void)
Index: b/arch/x86/kernel/traps_64.c
===================================================================
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1129,6 +1129,15 @@ asmlinkage void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
+/* Set of traps needed for early debugging. */
+void __init early_trap_init(void)
+{
+	set_intr_gate(1, &debug);
+	set_intr_gate(3, &int3);
+	set_intr_gate(14, &page_fault);
+	load_idt((const struct desc_ptr *)&idt_descr);
+}
+
 void __init trap_init(void)
 {
 	set_intr_gate(0,&divide_error);
@@ -1145,7 +1154,6 @@ void __init trap_init(void)
 	set_intr_gate(11,&segment_not_present);
 	set_intr_gate_ist(12,&stack_segment,STACKFAULT_STACK);
 	set_intr_gate(13,&general_protection);
-	set_intr_gate(14,&page_fault);
 	set_intr_gate(15,&spurious_interrupt_bug);
 	set_intr_gate(16,&coprocessor_error);
 	set_intr_gate(17,&alignment_check);
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
 
@@ -290,10 +291,6 @@ int kgdb_nmihook(int cpu, void *regs);
 extern int		debugger_step;
 extern atomic_t		debugger_active;
 
-#ifndef EXCEPTION_STACK_READY
-# define EXCEPTION_STACK_READY()	1
-#endif
-
 #else /* !CONFIG_KGDB */
 static const atomic_t	debugger_active = ATOMIC_INIT(0);
 #endif /* !CONFIG_KGDB */
Index: b/kernel/kgdb.c
===================================================================
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -2104,6 +2104,12 @@ void kgdb_unregister_io_module(struct kg
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
@@ -2112,25 +2118,15 @@ static void __init kgdb_early_entry(void
 {
 	/* Let the architecture do any setup that it needs to. */
 	kgdb_arch_init();
-
-	/*
-	 * Don't try and do anything until the architecture is able to
-	 * setup the exception stack.  In this case, it is up to the
-	 * architecture to hook in and look at us when they are ready.
-	 */
-	if (!EXCEPTION_STACK_READY()) {
-		kgdb_state = KGDB_SEMI_INITIALIZED;
-		/* any kind of break point is deferred to late_init */
-		return;
-	}
+	kgdb_state = KGDB_ARCH_INITIALIZED;
 
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
 
@@ -2155,14 +2151,16 @@ static void __init kgdb_early_entry(void
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
@@ -2177,6 +2175,7 @@ static int __init kgdb_late_entry(void)
 			printk(KERN_INFO "kgdb: Defering I/O setup to kernel "
 					 "module.\n");
 			memset(&kgdb_io_ops, 0, sizeof(struct kgdb_io));
+			need_break = 0;
 		}
 
 		kgdb_internal_init();
@@ -2198,11 +2197,8 @@ static int __init kgdb_late_entry(void)
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
@@ -2290,14 +2286,11 @@ static int __init opt_kgdb_enter(char *s
 
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
Index: b/arch/x86/kernel/setup_64.c
===================================================================
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -92,6 +92,8 @@ unsigned long saved_video_mode;
 
 int force_mwait __cpuinitdata;
 
+void early_trap_init(void);
+
 /*
  * Early DMI memory
  */
@@ -264,6 +266,8 @@ void __init setup_arch(char **cmdline_p)
 {
 	unsigned i;
 
+	early_trap_init();
+
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
Index: b/include/asm-x86/kgdb.h
===================================================================
--- a/include/asm-x86/kgdb.h
+++ b/include/asm-x86/kgdb.h
@@ -76,9 +76,6 @@ enum regnames { _AX,	/* 0 */
 
 #ifndef __ASSEMBLY__
 #define BREAKPOINT()		asm("   int $3");
-#ifndef CONFIG_X86_32
-#define EXCEPTION_STACK_READY() ((&__get_cpu_var(init_tss))[0].x86_tss.ist[0])
-#endif /* ! CONFIG_X86_32 */
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
 #endif				/* !__ASSEMBLY__ */
