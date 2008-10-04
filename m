Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYJDVRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYJDVRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYJDVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:17:10 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:4823 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYJDVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:17:09 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumpstack: x86: various small unification steps
Date: Sat,  4 Oct 2008 23:12:46 +0200
Message-Id: <1223154766-19350-8-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223154766-19350-7-git-send-email-heukelum@fastmail.fm>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-4-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-5-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-6-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-7-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:16:49 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - define STACKSLOTS_PER_LINE and use it
 - define get_bp macro to hide the %%ebp/%%rbp difference
 - i386: check task==NULL in dump_trace, like x86_64
 - i386: show_trace(NULL, ...) uses current automatically
 - x86_64: use [#%d] for die_counter, like i386
 - whitespace and comments

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   23 +++++++++++------------
 arch/x86/kernel/dumpstack_64.c |   15 +++++++++------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index d5347f1..8d13ebe 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -16,8 +16,11 @@
 
 #include <asm/stacktrace.h>
 
+#define STACKSLOTS_PER_LINE 8
+#define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
+
 int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 24;
+int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static unsigned int code_bytes = 64;
 static int die_counter;
 
@@ -82,7 +85,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!stack) {
 		unsigned long dummy;
 		stack = &dummy;
-		if (task != current)
+		if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;
 	}
 
@@ -90,7 +93,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!bp) {
 		if (task == current) {
 			/* Grab bp right from our regs */
-			asm("movl %%ebp, %0" : "=r" (bp) :);
+			get_bp(bp);
 		} else {
 			/* bp is the last reg pushed by switch_to */
 			bp = *(unsigned long *) task->thread.sp;
@@ -167,7 +170,7 @@ void show_trace(struct task_struct *task, struct pt_regs *regs,
 
 static void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+		unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -183,7 +186,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (kstack_end(stack))
 			break;
-		if (i && ((i % 8) == 0))
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
 			printk("\n%s", log_lvl);
 		printk(" %08lx", *stack++);
 		touch_nmi_watchdog();
@@ -207,7 +210,7 @@ void dump_stack(void)
 
 #ifdef CONFIG_FRAME_POINTER
 	if (!bp)
-		asm("movl %%ebp, %0" : "=r" (bp):);
+		get_bp(bp);
 #endif
 
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
@@ -215,8 +218,7 @@ void dump_stack(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-
-	show_trace(current, NULL, &stack, bp);
+	show_trace(NULL, NULL, &stack, bp);
 }
 
 EXPORT_SYMBOL(dump_stack);
@@ -249,7 +251,7 @@ void show_registers(struct pt_regs *regs)
 
 		ip = (u8 *)regs->ip - code_prologue;
 		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at EIP */
+			/* try starting at IP */
 			ip = (u8 *)regs->ip;
 			code_len = code_len - code_prologue + 1;
 		}
@@ -320,13 +322,10 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 
 	if (in_nmi())
 		panic("Fatal exception in non-maskable interrupt");
-
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
-
 	if (panic_on_oops)
 		panic("Fatal exception");
-
 	oops_exit();
 	do_exit(signr);
 }
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6ac80f0..ddc8a38 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -16,8 +16,11 @@
 
 #include <asm/stacktrace.h>
 
+#define STACKSLOTS_PER_LINE 4
+#define get_bp(bp) asm("movl %%rbp, %0" : "=r" (bp) :)
+
 int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 12;
+int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static unsigned int code_bytes = 64;
 static int die_counter;
 
@@ -177,7 +180,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!bp) {
 		if (task == current) {
 			/* Grab bp right from our regs */
-			asm("movq %%rbp, %0" : "=r" (bp) : );
+			get_bp(bp);
 		} else {
 			/* bp is the last reg pushed by switch_to */
 			bp = *(unsigned long *) task->thread.sp;
@@ -329,7 +332,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (((long) stack & (THREAD_SIZE-1)) == 0)
 			break;
 		}
-		if (i && ((i % 4) == 0))
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
 			printk("\n%s", log_lvl);
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
@@ -353,7 +356,7 @@ void dump_stack(void)
 
 #ifdef CONFIG_FRAME_POINTER
 	if (!bp)
-		asm("movq %%rbp, %0" : "=r" (bp) : );
+		get_bp(bp);
 #endif
 
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
@@ -396,7 +399,7 @@ void show_registers(struct pt_regs *regs)
 
 		ip = (u8 *)regs->ip - code_prologue;
 		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at RIP */
+			/* try starting at IP */
 			ip = (u8 *)regs->ip;
 			code_len = code_len - code_prologue + 1;
 		}
@@ -477,7 +480,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 
 int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 {
-	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
 #endif
-- 
1.5.4.3

