Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbXIUWoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbXIUWoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764047AbXIUWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:40 -0400
Received: from ns.suse.de ([195.135.220.2]:57073 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763594AbXIUWcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:32 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [31/50] x86_64: honor notify_die() returning NOTIFY_STOP
Message-Id: <20070921223230.D0C8013DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
If a debugger or other low level code resolves a kernel exception, don't
send signals, kill the kernel, or do anything the like.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/x86_64/kernel/mce.c    |    7 ++++---
 arch/x86_64/kernel/traps.c  |   23 +++++++++++++++--------
 arch/x86_64/mm/fault.c      |   12 ++++++------
 include/asm-x86_64/kdebug.h |    4 ++--
 4 files changed, 27 insertions(+), 19 deletions(-)

Index: linux/arch/x86_64/kernel/mce.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce.c
+++ linux/arch/x86_64/kernel/mce.c
@@ -196,9 +196,10 @@ void do_machine_check(struct pt_regs * r
 
 	atomic_inc(&mce_entry);
 
-	if (regs)
-		notify_die(DIE_NMI, "machine check", regs, error_code, 18, SIGKILL);
-	if (!banks)
+	if ((regs
+	     && notify_die(DIE_NMI, "machine check", regs, error_code,
+			   18, SIGKILL) == NOTIFY_STOP)
+	    || !banks)
 		goto out2;
 
 	memset(&m, 0, sizeof(struct mce));
Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
@@ -557,7 +557,7 @@ unsigned __kprobes long oops_begin(void)
 	return flags;
 }
 
-void __kprobes oops_end(unsigned long flags)
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 { 
 	die_owner = -1;
 	bust_spinlocks(0);
@@ -568,12 +568,17 @@ void __kprobes oops_end(unsigned long fl
 	else
 		/* Nest count reaches zero, release the lock. */
 		spin_unlock_irqrestore(&die_lock, flags);
+	if (!regs) {
+		oops_exit();
+		return;
+	}
 	if (panic_on_oops)
 		panic("Fatal exception");
 	oops_exit();
+	do_exit(signr);
 }
 
-void __kprobes __die(const char * str, struct pt_regs * regs, long err)
+int __kprobes __die(const char * str, struct pt_regs * regs, long err)
 {
 	static int die_counter;
 	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff,++die_counter);
@@ -587,7 +592,8 @@ void __kprobes __die(const char * str, s
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
-	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
+	if (notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
 	show_registers(regs);
 	add_taint(TAINT_DIE);
 	/* Executive summary in case the oops scrolled away */
@@ -596,6 +602,7 @@ void __kprobes __die(const char * str, s
 	printk(" RSP <%016lx>\n", regs->rsp); 
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
+	return 0;
 }
 
 void die(const char * str, struct pt_regs * regs, long err)
@@ -605,9 +612,9 @@ void die(const char * str, struct pt_reg
 	if (!user_mode(regs))
 		report_bug(regs->rip, regs);
 
-	__die(str, regs, err);
-	oops_end(flags);
-	do_exit(SIGSEGV); 
+	if (__die(str, regs, err))
+		regs = NULL;
+	oops_end(flags, regs, SIGSEGV);
 }
 
 void __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
@@ -624,10 +631,10 @@ void __kprobes die_nmi(char *str, struct
 		crash_kexec(regs);
 	if (do_panic || panic_on_oops)
 		panic("Non maskable interrupt");
-	oops_end(flags);
+	oops_end(flags, NULL, SIGBUS);
 	nmi_exit();
 	local_irq_enable();
-	do_exit(SIGSEGV);
+	do_exit(SIGBUS);
 }
 
 static void __kprobes do_trap(int trapnr, int signr, char *str,
Index: linux/arch/x86_64/mm/fault.c
===================================================================
--- linux.orig/arch/x86_64/mm/fault.c
+++ linux/arch/x86_64/mm/fault.c
@@ -234,9 +234,9 @@ static noinline void pgtable_bad(unsigne
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
-	__die("Bad pagetable", regs, error_code);
-	oops_end(flags);
-	do_exit(SIGKILL);
+	if (__die("Bad pagetable", regs, error_code))
+		regs = NULL;
+	oops_end(flags, regs, SIGKILL);
 }
 
 /*
@@ -541,11 +541,11 @@ no_context:
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
-	__die("Oops", regs, error_code);
+	if (__die("Oops", regs, error_code))
+		regs = NULL;
 	/* Executive summary in case the body of the oops scrolled away */
 	printk(KERN_EMERG "CR2: %016lx\n", address);
-	oops_end(flags);
-	do_exit(SIGKILL);
+	oops_end(flags, regs, SIGKILL);
 
 /*
  * We ran out of memory, or some other thing happened to us that made
Index: linux/include/asm-x86_64/kdebug.h
===================================================================
--- linux.orig/include/asm-x86_64/kdebug.h
+++ linux/include/asm-x86_64/kdebug.h
@@ -27,10 +27,10 @@ enum die_val {
 
 extern void printk_address(unsigned long address);
 extern void die(const char *,struct pt_regs *,long);
-extern void __die(const char *,struct pt_regs *,long);
+extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
 extern void dump_pagetable(unsigned long);
 extern unsigned long oops_begin(void);
-extern void oops_end(unsigned long);
+extern void oops_end(unsigned long, struct pt_regs *, int signr);
 
 #endif
