Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbXJMOnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbXJMOnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbXJMOmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:09 -0400
Received: from 1wt.eu ([62.212.114.60]:2919 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbXJMOmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:07 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143449.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:31 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 09/35] SPARC64: Fix sparc64 task stack traces.
Content-Disposition: inline; filename=0036-SPARC64-Fix-sparc64-task-stack-traces.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It didn't handle that case at all, and now dump_stack()
can be implemented directly as show_stack(current, NULL)

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc64/kernel/traps.c |   18 +++++++++++-------
 arch/sparc64/mm/fault.c     |    5 +----
 2 files changed, 12 insertions(+), 11 deletions(-)

Index: 2.6/arch/sparc64/kernel/traps.c
===================================================================
--- 2.6.orig/arch/sparc64/kernel/traps.c
+++ 2.6/arch/sparc64/kernel/traps.c
@@ -2146,12 +2146,20 @@ static void user_instruction_dump (unsig
 void show_stack(struct task_struct *tsk, unsigned long *_ksp)
 {
 	unsigned long pc, fp, thread_base, ksp;
-	void *tp = task_stack_page(tsk);
+	struct thread_info *tp;
 	struct reg_window *rw;
 	int count = 0;
 
 	ksp = (unsigned long) _ksp;
-
+	if (!tsk)
+		tsk = current;
+	tp = task_thread_info(tsk);
+	if (ksp == 0UL) {
+		if (tsk == current)
+			asm("mov %%fp, %0" : "=r" (ksp));
+		else
+			ksp = tp->ksp;
+	}
 	if (tp == current_thread_info())
 		flushw_all();
 
@@ -2180,11 +2188,7 @@ void show_stack(struct task_struct *tsk,
 
 void dump_stack(void)
 {
-	unsigned long *ksp;
-
-	__asm__ __volatile__("mov	%%fp, %0"
-			     : "=r" (ksp));
-	show_stack(current, ksp);
+	show_stack(current, NULL);
 }
 
 EXPORT_SYMBOL(dump_stack);
Index: 2.6/arch/sparc64/mm/fault.c
===================================================================
--- 2.6.orig/arch/sparc64/mm/fault.c
+++ 2.6/arch/sparc64/mm/fault.c
@@ -129,15 +129,12 @@ static void __kprobes unhandled_fault(un
 
 static void bad_kernel_pc(struct pt_regs *regs, unsigned long vaddr)
 {
-	unsigned long *ksp;
-
 	printk(KERN_CRIT "OOPS: Bogus kernel PC [%016lx] in fault handler
",
 	       regs->tpc);
 	printk(KERN_CRIT "OOPS: RPC [%016lx]
", regs->u_regs[15]);
 	print_symbol("RPC: <%s>
", regs->u_regs[15]);
 	printk(KERN_CRIT "OOPS: Fault was to vaddr[%lx]
", vaddr);
-	__asm__("mov %%sp, %0" : "=r" (ksp));
-	show_stack(current, ksp);
+	dump_stack();
 	unhandled_fault(regs->tpc, current, regs);
 }
 

-- 
