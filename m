Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbYEBJUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbYEBJUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbYEBJTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:19:55 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:31435 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbYEBJTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:19:53 -0400
Date: Fri, 2 May 2008 11:19:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, zdenek.kabelac@gmail.com
Subject: [PATCH REPOST^3] Run IST traps from user mode preemptive on process stack
Message-ID: <20080502091948.GA26099@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 May 2008 09:12:54.0622 (UTC) FILETIME=[B479D7E0:01C8AC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixes a bug originally introduced in 2.6.23 I think. Reposted many times
so far, but still not applied. Please apply.]

Run IST traps from user mode preemptive on process stack

x86-64 has a few exceptions which run on special architecture 
supported IST exception stacks: these are nmi, double fault, stack fault,
int 3, debug.

Previously they would check for a scheduling event on returning
if the original CPU state was user mode and then switch to a 
process stack to schedule.

But the actual trap handler would still run on the IST stack
with preemption disabled.

This patch changes these traps instead to always switch 
to the process stack when the trap originated from user mode.
For kernel traps it keeps running non preemptive on the IST stack
because that is much safer (e.g. to still get nmi watchdog events
out even when the process stack is corrupted) 

Then the actual trap handlers can run with preemption enabled
or schedule as needed (e.g. to take locks) 

This fixes a regression I added earlier with print_vma_addr()
executing down() in these trap handlers from user space.

Strictly the change would have been only needed for debug 
and int3, but since they share this code as macros it was 
cleanest to just change all.

Cc: jkosina@suse.cz
Cc: zdenek.kabelac@gmail.com

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>

---
 arch/x86/kernel/entry_64.S |   17 ++++++++++-------
 arch/x86/kernel/traps_64.c |   17 ++++++++++-------
 2 files changed, 20 insertions(+), 14 deletions(-)

Index: linux/arch/x86/kernel/entry_64.S
===================================================================
--- linux.orig/arch/x86/kernel/entry_64.S
+++ linux/arch/x86/kernel/entry_64.S
@@ -771,12 +771,18 @@ END(spurious_interrupt)
 	.if \ist
 	movq	%gs:pda_data_offset, %rbp
 	.endif
-	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi
 	movq $-1,ORIG_RAX(%rsp)
 	.if \ist
 	subq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
 	.endif
+	testl $3,CS(%rsp)
+	jz 2f					/* in kernel? stay on exception stack for now */
+	movq %rsp,%rdi
+	call sync_regs				/* Move all state over to process stack */
+	movq %rax,%rsp				/* switch stack to process stack */
+2:
+	movq %rsp,%rdi
 	call \sym
 	.if \ist
 	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
@@ -802,16 +808,16 @@ END(spurious_interrupt)
 	.macro paranoidexit trace=1
 	/* ebx:	no swapgs flag */
 paranoid_exit\trace:
-	testl %ebx,%ebx				/* swapgs needed? */
-	jnz paranoid_restore\trace
 	testl $3,CS(%rsp)
 	jnz   paranoid_userspace\trace
 paranoid_swapgs\trace:
+	testl %ebx,%ebx 			/* swapgs needed? */
+	jnz 1f
 	.if \trace
 	TRACE_IRQS_IRETQ 0
 	.endif
 	SWAPGS_UNSAFE_STACK
-paranoid_restore\trace:
+1:
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_userspace\trace:
@@ -819,9 +825,6 @@ paranoid_userspace\trace:
 	movl threadinfo_flags(%rcx),%ebx
 	andl $_TIF_WORK_MASK,%ebx
 	jz paranoid_swapgs\trace
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
 	testl $_TIF_NEED_RESCHED,%ebx
 	jnz paranoid_schedule\trace
 	movl %ebx,%edx			/* arg3: thread flags */
Index: linux/arch/x86/kernel/traps_64.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_64.c
+++ linux/arch/x86/kernel/traps_64.c
@@ -84,7 +84,8 @@ static inline void conditional_sti(struc
 
 static inline void preempt_conditional_sti(struct pt_regs *regs)
 {
-	inc_preempt_count();
+	if (!user_mode(regs))
+		inc_preempt_count();
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -95,7 +96,8 @@ static inline void preempt_conditional_c
 		local_irq_disable();
 	/* Make sure to not schedule here because we could be running
 	   on an exception stack. */
-	dec_preempt_count();
+	if (!user_mode(regs))
+		dec_preempt_count();
 }
 
 int kstack_depth_to_print = 12;
@@ -855,7 +857,7 @@ asmlinkage __kprobes void default_do_nmi
 		io_check_error(reason, regs);
 }
 
-/* runs on IST stack. */
+/* May run on IST stack. */
 asmlinkage void __kprobes do_int3(struct pt_regs * regs, long error_code)
 {
 	trace_hardirqs_fixup();
@@ -868,9 +870,10 @@ asmlinkage void __kprobes do_int3(struct
 	preempt_conditional_cli(regs);
 }
 
-/* Help handler running on IST stack to switch back to user stack
-   for scheduling or signal handling. The actual stack switch is done in
-   entry.S */
+/*
+ * Help handler running on IST stack to switch back to user stack.
+ * The actual stack switch is done in entry.S
+ */
 asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
@@ -889,7 +892,7 @@ asmlinkage __kprobes struct pt_regs *syn
 	return regs;
 }
 
-/* runs on IST stack. */
+/* May run on IST stack. */
 asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 				   unsigned long error_code)
 {
