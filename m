Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbYAJQsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbYAJQsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbYAJQsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:48:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbYAJQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:48:13 -0500
Date: Thu, 10 Jan 2008 08:47:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: x86: Add the "print code before the trapping instruction" feature
 to 64 bit
Message-ID: <20080110084739.5ba72522@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86: Add the "print code before the trapping instruction" feature to 64 bit
From: Arjan van de Ven <arjan@linux.intel.com>

The 32 bit x86 tree has a very useful feature that prints the Code: line
for the code even before the trapping instrution (and the start of the
trapping instruction is then denoted with a <>). Unfortunately, the 64 bit
x86 tree does not yet have this feature, making diagnosing backtraces harder
than needed.

This patch adds this feature in the same was as the 32 bit tree has
(including the same kernel boot parameter), and including a bugfix
to make the code use probe_kernel_address() rarther than a buggy (deadlocking)
__get_user.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 Documentation/kernel-parameters.txt |    4 +--
 arch/x86/kernel/traps_64.c          |   44 +++++++++++++++++++++++++++---------
 2 files changed, 35 insertions(+), 13 deletions(-)

Index: linux-2.6.24-rc7/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.24-rc7.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.24-rc7/Documentation/kernel-parameters.txt
@@ -408,8 +408,8 @@ and is between 256 and 4096 characters. 
 			[SPARC64] tick
 			[X86-64] hpet,tsc
 
-	code_bytes	[IA32] How many bytes of object code to print in an
-			oops report.
+	code_bytes	[IA32/X86_64] How many bytes of object code to print
+			in an oops report.
 			Range: 0 - 8192
 			Default: 64
 
Index: linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_64.c
@@ -74,6 +74,8 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);
 
+static unsigned int code_bytes = 64;
+
 static inline void conditional_sti(struct pt_regs *regs)
 {
 	if (regs->eflags & X86_EFLAGS_IF)
@@ -483,12 +485,15 @@ EXPORT_SYMBOL(dump_stack);
 void show_registers(struct pt_regs *regs)
 {
 	int i;
-	int in_kernel = !user_mode(regs);
 	unsigned long rsp;
 	const int cpu = smp_processor_id();
 	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+	u8 *rip;
+	unsigned int code_prologue = code_bytes * 43 / 64;
+	unsigned int code_len = code_bytes;
 
 	rsp = regs->rsp;
+	rip = (u8 *) regs->rip - code_prologue;
 	printk("CPU %d ", cpu);
 	__show_regs(regs);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
@@ -498,22 +503,28 @@ void show_registers(struct pt_regs *regs
 	 * When in-kernel, we also print out the stack and code at the
 	 * time of the fault..
 	 */
-	if (in_kernel) {
+	if (!user_mode(regs)) {
+		unsigned char c;
 		printk("Stack: ");
 		_show_stack(NULL, regs, (unsigned long*)rsp);
+		printk("\n");
 
-		printk("\nCode: ");
-		if (regs->rip < PAGE_OFFSET)
-			goto bad;
-
-		for (i=0; i<20; i++) {
-			unsigned char c;
-			if (__get_user(c, &((unsigned char*)regs->rip)[i])) {
-bad:
+		printk(KERN_EMERG "Code: ");
+		if (rip < (u8 *)PAGE_OFFSET || probe_kernel_address(rip, c)) {
+			/* try starting at RIP */
+			rip = (u8 *) regs->rip;
+			code_len = code_len - code_prologue + 1;
+		}
+		for (i = 0; i < code_len; i++, rip++) {
+			if (rip < (u8 *)PAGE_OFFSET ||
+					probe_kernel_address(rip, c)) {
 				printk(" Bad RIP value.");
 				break;
 			}
-			printk("%02x ", c);
+			if (rip == (u8 *)regs->rip)
+				printk("<%02x> ", c);
+			else
+				printk("%02x ", c);
 		}
 	}
 	printk("\n");
@@ -1211,3 +1222,14 @@ static int __init kstack_setup(char *s)
 	return 0;
 }
 early_param("kstack", kstack_setup);
+
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
