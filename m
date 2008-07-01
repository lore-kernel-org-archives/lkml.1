Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbYGAXfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbYGAXfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbYGAXfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:35:18 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:4334 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbYGAXfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:35:16 -0400
Date: Wed, 2 Jul 2008 01:33:14 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] x86: traps_xx: various small changes
Message-ID: <20080701233314.GG29903@mailshack.com>
References: <20080701193643.GA29695@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Wed, 02 Jul 2008 01:35:00 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - order of local variable declarations
 - minor code changes

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   15 +++++++--------
 arch/x86/kernel/traps_64.c |   23 +++++++++++++----------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 14fe3cd..5824dac 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -107,13 +107,13 @@ static int die_counter;
 void printk_address(unsigned long address, int reliable)
 {
 #ifdef CONFIG_KALLSYMS
-	char namebuf[KSYM_NAME_LEN];
 	unsigned long offset = 0;
 	unsigned long symsize;
 	const char *symname;
-	char reliab[4] = "";
-	char *delim = ":";
 	char *modname;
+	char *delim = ":";
+	char namebuf[KSYM_NAME_LEN];
+	char reliab[4] = "";
 
 	symname = kallsyms_lookup(address, &symsize, &offset,
 					&modname, namebuf);
@@ -136,8 +136,8 @@ void printk_address(unsigned long address, int reliable)
 static inline int valid_stack_ptr(struct thread_info *tinfo,
 			void *p, unsigned int size)
 {
-	return	p > (void *)tinfo &&
-		p <= (void *)tinfo + THREAD_SIZE - size;
+	void *t = tinfo;
+	return	p > t && p <= t + THREAD_SIZE - size;
 }
 
 /* The form of the top of the frame on the stack */
@@ -989,9 +989,8 @@ clear_TF_reenable:
 void math_error(void __user *ip)
 {
 	struct task_struct *task;
-	unsigned short cwd;
-	unsigned short swd;
 	siginfo_t info;
+	unsigned short cwd, swd;
 
 	/*
 	 * Save the info for the exception handler and clear the error.
@@ -1055,8 +1054,8 @@ void do_coprocessor_error(struct pt_regs *regs, long error_code)
 static void simd_math_error(void __user *ip)
 {
 	struct task_struct *task;
-	unsigned short mxcsr;
 	siginfo_t info;
+	unsigned short mxcsr;
 
 	/*
 	 * Save the info for the exception handler and clear the error.
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 2f8d87d..4ea2eec 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -107,7 +107,8 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 void printk_address(unsigned long address, int reliable)
 {
 #ifdef CONFIG_KALLSYMS
-	unsigned long offset = 0, symsize;
+	unsigned long offset = 0;
+	unsigned long symsize;
 	const char *symname;
 	char *modname;
 	char *delim = ":";
@@ -269,7 +270,6 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 	if (!task)
 		task = current;
-	tinfo = task_thread_info(task);
 
 	if (!stack) {
 		unsigned long dummy;
@@ -295,6 +295,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	 * current stack address. If the stacks consist of nested
 	 * exceptions
 	 */
+	tinfo = task_thread_info(task);
 	for (;;) {
 		char *id;
 		unsigned long *estack_end;
@@ -436,8 +437,8 @@ void show_stack(struct task_struct *task, unsigned long *sp)
  */
 void dump_stack(void)
 {
-	unsigned long stack;
 	unsigned long bp = 0;
+	unsigned long stack;
 
 #ifdef CONFIG_FRAME_POINTER
 	if (!bp)
@@ -460,12 +461,8 @@ void show_registers(struct pt_regs *regs)
 	unsigned long sp;
 	const int cpu = smp_processor_id();
 	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
-	u8 *ip;
-	unsigned int code_prologue = code_bytes * 43 / 64;
-	unsigned int code_len = code_bytes;
 
 	sp = regs->sp;
-	ip = (u8 *) regs->ip - code_prologue;
 	printk("CPU %d ", cpu);
 	__show_regs(regs, 1);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
@@ -476,12 +473,18 @@ void show_registers(struct pt_regs *regs)
 	 * time of the fault..
 	 */
 	if (!user_mode(regs)) {
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
 		unsigned char c;
+		u8 *ip;
+
 		printk("Stack: ");
 		_show_stack(NULL, regs, (unsigned long *)sp, regs->bp);
 		printk("\n");
 
 		printk(KERN_EMERG "Code: ");
+
+		ip = (u8 *)regs->ip - code_prologue;
 		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
 			/* try starting at RIP */
 			ip = (u8 *)regs->ip;
@@ -590,7 +593,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	return 0;
 }
 
-void die(const char * str, struct pt_regs *regs, long err)
+void die(const char *str, struct pt_regs *regs, long err)
 {
 	unsigned long flags = oops_begin();
 
@@ -933,8 +936,8 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 				   unsigned long error_code)
 {
-	unsigned long condition;
 	struct task_struct *tsk = current;
+	unsigned long condition;
 	siginfo_t info;
 
 	trace_hardirqs_fixup();
@@ -1215,7 +1218,7 @@ void __init trap_init(void)
 	/*
 	 * initialize the per thread extended state:
 	 */
-        init_thread_xstate();
+	init_thread_xstate();
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
-- 
1.5.4.3

