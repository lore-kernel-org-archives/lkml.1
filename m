Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbXLMJYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbXLMJYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXLMJYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:24:04 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31772
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbXLMJYB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:24:01 -0500
Message-Id: <47610870.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:24:48 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: honor notify_die() returning NOTIFY_STOP
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requires making die() return a value, making its callers honor
this (and be prepared that it may return), and making oops_end() have
two additional parameters.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 ++++----
 arch/x86/kernel/traps_64.c          |   23 +++++++++++++++--------
 arch/x86/mm/fault_64.c              |   12 ++++++------
 include/asm-x86/kdebug.h            |    4 ++--
 4 files changed, 27 insertions(+), 20 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_64.c	2007-12-12 16:48:17.000000000 +0100
+++ 2.6.24-rc5-x86_64-notify-die-return/arch/x86/kernel/cpu/mcheck/mce_64.c	2007-12-04 16:20:14.000000000 +0100
@@ -192,10 +192,10 @@ void do_machine_check(struct pt_regs * r
 
 	atomic_inc(&mce_entry);
 
-	if (regs)
-		notify_die(DIE_NMI, "machine check", regs, error_code, 18,
-			   SIGKILL);
-	if (!banks)
+	if ((regs
+	     && notify_die(DIE_NMI, "machine check", regs, error_code,
+			   18, SIGKILL) == NOTIFY_STOP)
+	    || !banks)
 		goto out2;
 
 	memset(&m, 0, sizeof(struct mce));
--- linux-2.6.24-rc5/arch/x86/kernel/traps_64.c	2007-12-12 16:48:17.000000000 +0100
+++ 2.6.24-rc5-x86_64-notify-die-return/arch/x86/kernel/traps_64.c	2007-12-04 17:50:33.000000000 +0100
@@ -496,7 +496,7 @@ unsigned __kprobes long oops_begin(void)
 	return flags;
 }
 
-void __kprobes oops_end(unsigned long flags)
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 { 
 	die_owner = -1;
 	bust_spinlocks(0);
@@ -505,12 +505,17 @@ void __kprobes oops_end(unsigned long fl
 		/* Nest count reaches zero, release the lock. */
 		__raw_spin_unlock(&die_lock);
 	raw_local_irq_restore(flags);
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
@@ -524,7 +529,8 @@ void __kprobes __die(const char * str, s
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
-	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
+	if (notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
 	show_registers(regs);
 	add_taint(TAINT_DIE);
 	/* Executive summary in case the oops scrolled away */
@@ -533,6 +539,7 @@ void __kprobes __die(const char * str, s
 	printk(" RSP <%016lx>\n", regs->rsp); 
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
+	return 0;
 }
 
 void die(const char * str, struct pt_regs * regs, long err)
@@ -542,9 +549,9 @@ void die(const char * str, struct pt_reg
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
@@ -561,10 +568,10 @@ void __kprobes die_nmi(char *str, struct
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
--- linux-2.6.24-rc5/arch/x86/mm/fault_64.c	2007-12-12 16:48:17.000000000 +0100
+++ 2.6.24-rc5-x86_64-notify-die-return/arch/x86/mm/fault_64.c	2007-12-04 16:18:59.000000000 +0100
@@ -228,9 +228,9 @@ static noinline void pgtable_bad(unsigne
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
@@ -542,11 +542,11 @@ no_context:
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
--- linux-2.6.24-rc5/include/asm-x86/kdebug.h	2007-12-12 16:48:42.000000000 +0100
+++ 2.6.24-rc5-x86_64-notify-die-return/include/asm-x86/kdebug.h	2007-12-04 16:18:59.000000000 +0100
@@ -24,10 +24,10 @@ enum die_val {
 
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


