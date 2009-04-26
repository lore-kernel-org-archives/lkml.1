Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZDZWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZDZWOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZDZWOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 18:14:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZDZWOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 18:14:02 -0400
Date: Mon, 27 Apr 2009 00:09:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jeff Dike <jdike@addtoit.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: PT_DTRACE && uml
Message-ID: <20090426220954.GA6580@redhat.com>
References: <20090408203954.GA26816@redhat.com> <20090416204004.GA28013@redhat.com> <20090416232430.4DAE4FC3C6@magilla.sf.frob.com> <20090420183718.GC32527@redhat.com> <20090421011354.4B19EFC3C7@magilla.sf.frob.com> <20090421214819.GA22845@redhat.com> <20090422032205.B8D39FC3C7@magilla.sf.frob.com> <20090422220400.GA22755@redhat.com> <20090422221726.GC22755@redhat.com> <20090423160229.GA9820@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423160229.GA9820@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Jeff Dike wrote:
>
> On Thu, Apr 23, 2009 at 12:17:26AM +0200, Oleg Nesterov wrote:
> > (cc Jeff Dike)
> >
> > So, arch/um/ seems to be the only user of PT_DTRACE.
> >
> > I do not understand this code at all. It looks as if we can just
> > s/PT_DTRACE/TIF_SINGLESTEP/.
> >
> > But it can't be that simple?
>
> It looks like it.

OK. Please look at the patch below. It is literally s/PT_DTRACE/TIF_SINGLESTEP/
and nothing more.

Except, it removes task_lock() arch/um/kernel/exec.c:execve1(). We don't
need this lock to clear bit (actually we could clear PT_DTRACE without
this lock too). But what about SUBARCH_EXECVE1(), does it need this lock ?
grep finds nothing about SUBARCH_EXECVE1.

> The one odd part is the use in the signal delivery
> code.  That looks like a bug to me.

Cough. Where?

arch/um/sys-i386/signal.c:setup_signal_stack_sc() and setup_signal_stack_si()
looks suspicious. Why do they play with single-step? And why arch/um/sys-x86_64/
does not?

It seems to me we should kill this code, and change handle_signal() to call
tracehook_signal_handler(test_thread_flag(TIF_SINGLESTEP)).

UML hooks ptrace_disable() which calls set_singlestepping(0), so we can't
leak TIF_SINGLESTEP after ptrace_detach(). Unfortunately, if the tracer
dies nobody will clear this flag. But currently this is common problem.

Do you see other problems with this patch? (uncompiled, untested).

Oleg.


--- PTRACE/arch/um/include/asm/thread_info.h~DT_5_um	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/um/include/asm/thread_info.h	2009-04-26 21:14:05.000000000 +0200
@@ -69,6 +69,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_SINGLESTEP		8
 #define TIF_FREEZE		16	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
@@ -78,6 +79,7 @@ static inline struct thread_info *curren
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #endif
--- PTRACE/arch/um/kernel/exec.c~DT_5_um	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/um/kernel/exec.c	2009-04-26 23:29:11.000000000 +0200
@@ -50,12 +50,10 @@ static long execve1(char *file, char __u
 
 	error = do_execve(file, argv, env, &current->thread.regs);
 	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
+		clear_thread_flag(TIF_SINGLESTEP);
 #ifdef SUBARCH_EXECVE1
 		SUBARCH_EXECVE1(&current->thread.regs.regs);
 #endif
-		task_unlock(current);
 	}
 	return error;
 }
--- PTRACE/arch/um/kernel/process.c~DT_5_um	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/um/kernel/process.c	2009-04-27 00:03:26.000000000 +0200
@@ -384,7 +384,7 @@ int singlestepping(void * t)
 {
 	struct task_struct *task = t ? t : current;
 
-	if (!(task->ptrace & PT_DTRACE))
+	if (!test_tsk_thread_flag(task, TIF_SINGLESTEP))
 		return 0;
 
 	if (task->thread.singlestep_syscall)
--- PTRACE/arch/um/kernel/ptrace.c~DT_5_um	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/um/kernel/ptrace.c	2009-04-26 23:24:18.000000000 +0200
@@ -15,9 +15,9 @@
 static inline void set_singlestepping(struct task_struct *child, int on)
 {
 	if (on)
-		child->ptrace |= PT_DTRACE;
+		set_tsk_thread_flag(child, TIF_SINGLESTEP);
 	else
-		child->ptrace &= ~PT_DTRACE;
+		clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 	child->thread.singlestep_syscall = 0;
 
 #ifdef SUBARCH_SET_SINGLESTEPPING
@@ -247,12 +247,11 @@ static void send_sigtrap(struct task_str
 }
 
 /*
- * XXX Check PT_DTRACE vs TIF_SINGLESTEP for singlestepping check and
- * PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
+ * XXX Check PT_PTRACED vs TIF_SYSCALL_TRACE for syscall tracing check
  */
 void syscall_trace(struct uml_pt_regs *regs, int entryexit)
 {
-	int is_singlestep = (current->ptrace & PT_DTRACE) && entryexit;
+	int is_singlestep = test_thread_flag(TIF_SINGLESTEP) && entryexit;
 	int tracesysgood;
 
 	if (unlikely(current->audit_context)) {
--- PTRACE/arch/um/kernel/signal.c~DT_5_um	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/um/kernel/signal.c	2009-04-26 21:56:02.000000000 +0200
@@ -138,7 +138,7 @@ static int kern_do_signal(struct pt_regs
 	 * on the host.  The tracing thread will check this flag and
 	 * PTRACE_SYSCALL if necessary.
 	 */
-	if (current->ptrace & PT_DTRACE)
+	if (test_thread_flag(TIF_SINGLESTEP))
 		current->thread.singlestep_syscall =
 			is_syscall(PT_REGS_IP(&current->thread.regs));
 
--- PTRACE/arch/um/sys-i386/signal.c~DT_5_um	2009-04-06 00:03:36.000000000 +0200
+++ PTRACE/arch/um/sys-i386/signal.c	2009-04-26 23:26:14.000000000 +0200
@@ -377,7 +377,7 @@ int setup_signal_stack_sc(unsigned long 
 	PT_REGS_EDX(regs) = (unsigned long) 0;
 	PT_REGS_ECX(regs) = (unsigned long) 0;
 
-	if ((current->ptrace & PT_DTRACE) && (current->ptrace & PT_PTRACED))
+	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 	return 0;
 
@@ -434,7 +434,7 @@ int setup_signal_stack_si(unsigned long 
 	PT_REGS_EDX(regs) = (unsigned long) &frame->info;
 	PT_REGS_ECX(regs) = (unsigned long) &frame->uc;
 
-	if ((current->ptrace & PT_DTRACE) && (current->ptrace & PT_PTRACED))
+	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 	return 0;
 

