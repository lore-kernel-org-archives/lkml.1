Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYGPAWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYGPAWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYGPAWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:22:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbYGPAWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=mQryg9qd3XOvtL+asHJIENCkp5FGXoTC4XZGUqbbnDZTW7oj0MWACNKLcCjAsaEYOg
         8iAAegoG0SKeQQ4/Y+AaC1KqnaJ6iILOfrWyUbkCYrnzKe1+WFllCLgrqGWCx6up9Na+
         lYTw4uJu4V9C3NPweTE0ArJq9BQ/3Br09Xym0=
Date: Wed, 16 Jul 2008 02:22:17 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/13] x86: __show_registers() and __show_regs() API
	unification
Message-ID: <20080716002217.GB12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 37c80e22248d89c2785246c3f5db0e41223cfc4a Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 3 Apr 2008 16:40:48 +0300
Subject: [PATCH 01/13] x86: __show_registers() and __show_regs() API unification

Currently the low-level function to dump user-passed registers on i386 is
called __show_registers() whereas on x86-64 it's called __show_regs(). Unify
the API to simplify porting of kmemcheck to x86-64.

Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |    4 ++--
 arch/x86/kernel/process_64.c |   12 ++++++++----
 arch/x86/kernel/traps_32.c   |    2 +-
 arch/x86/kernel/traps_64.c   |    2 +-
 include/asm-x86/kdebug.h     |    3 +--
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index e2db9ac..267f3f7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -194,7 +194,7 @@ void cpu_idle(void)
 	}
 }
 
-void __show_registers(struct pt_regs *regs, int all)
+void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -255,7 +255,7 @@ void __show_registers(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	__show_registers(regs, 1);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index c6eb5c9..594cb95 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -180,7 +180,7 @@ void cpu_idle(void)
 }
 
 /* Prints also some state that isn't saved in the pt_regs */
-void __show_regs(struct pt_regs * regs)
+void __show_regs(struct pt_regs * regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -219,13 +219,17 @@ void __show_regs(struct pt_regs * regs)
 	rdmsrl(MSR_GS_BASE, gs); 
 	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs); 
 
+	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	       fs,fsindex,gs,gsindex,shadowgs);
+
+	if (!all)
+		return;
+
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n", 
-	       fs,fsindex,gs,gsindex,shadowgs); 
 	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
 
@@ -242,7 +246,7 @@ void __show_regs(struct pt_regs * regs)
 void show_regs(struct pt_regs *regs)
 {
 	printk("CPU %d:", smp_processor_id());
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 08d752d..a4739a8 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -330,7 +330,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 
 	print_modules();
-	__show_registers(regs, 0);
+	__show_regs(regs, 0);
 
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index adff76e..552506c 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -470,7 +470,7 @@ void show_registers(struct pt_regs *regs)
 	sp = regs->sp;
 	ip = (u8 *) regs->ip - code_prologue;
 	printk("CPU %d ", cpu);
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
 		cur->comm, cur->pid, task_thread_info(cur), cur);
 
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index 96651bb..fe1fbde 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -27,10 +27,9 @@ extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
-extern void __show_registers(struct pt_regs *, int all);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
-extern void __show_regs(struct pt_regs *regs);
+extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
-- 
1.5.5.1

