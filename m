Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbXKGFLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbXKGFLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXKGFL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:11:26 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:64161 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXKGFLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:11:25 -0500
Date: Wed, 07 Nov 2007 14:04:46 +0900
From: Yuichi Nakamura <ynakam@hitachisoft.jp>
To: linux-kernel@vger.kernel.org
Subject: [patch] audit support for SH
Cc: linuxsh-dev@lists.sourceforge.net, lethal@linux-sh.org, sgrubb@redhat.com,
       ynakam@hitachisoft.jp
Message-Id: <20071107135743.C1BD.YNAKAM@hitachisoft.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.31 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I found syscall audit does not work on SH(SuperH).
I made patch to support syscall audit for SH.

Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>
---
 arch/sh/kernel/entry-common.S |    8 ++++++--
 arch/sh/kernel/ptrace.c       |   19 +++++++++++++++----
 include/asm-sh/thread_info.h  |    2 ++
 init/Kconfig                  |    2 +-
 4 files changed, 24 insertions(+), 7 deletions(-)
diff -purN -X linux-2.6.24.rc1/Documentation/dontdiff linux-2.6.24.rc1.orig/arch/sh/kernel/entry-common.S linux-2.6.24.rc1/arch/sh/kernel/entry-common.S
--- linux-2.6.24.rc1.orig/arch/sh/kernel/entry-common.S	2007-11-06 16:03:17.000000000 +0900
+++ linux-2.6.24.rc1/arch/sh/kernel/entry-common.S	2007-11-06 18:16:11.000000000 +0900
@@ -224,7 +224,7 @@ work_resched:
 syscall_exit_work:
 	! r0: current_thread_info->flags
 	! r8: current_thread_info
-	tst	#_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP, r0
+	tst	#_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP |_TIF_SYSCALL_AUDIT, r0
 	bt/s	work_pending
 	 tst	#_TIF_NEED_RESCHED, r0
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -234,6 +234,8 @@ syscall_exit_work:
 #endif
 	sti
 	! XXX setup arguments...
+	mov	r15, r4
+	mov	#1, r5
 	mov.l	4f, r0			! do_syscall_trace
 	jsr	@r0
 	 nop
@@ -244,6 +246,8 @@ syscall_exit_work:
 syscall_trace_entry:
 	!                     	Yes it is traced.
 	! XXX setup arguments...
+	mov     r15, r4
+	mov     #0, r5
 	mov.l	4f, r11		! Call do_syscall_trace which notifies
 	jsr	@r11	    	! superior (will chomp R[0-7])
 	 nop
@@ -366,7 +370,7 @@ ENTRY(system_call)
 	!
 	get_current_thread_info r8, r10
 	mov.l	@(TI_FLAGS,r8), r8
-	mov	#_TIF_SYSCALL_TRACE, r10
+	mov	#(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT), r10
 	tst	r10, r8
 	bf	syscall_trace_entry
 	!
diff -purN -X linux-2.6.24.rc1/Documentation/dontdiff linux-2.6.24.rc1.orig/arch/sh/kernel/ptrace.c linux-2.6.24.rc1/arch/sh/kernel/ptrace.c
--- linux-2.6.24.rc1.orig/arch/sh/kernel/ptrace.c	2007-11-06 16:03:17.000000000 +0900
+++ linux-2.6.24.rc1/arch/sh/kernel/ptrace.c	2007-11-07 08:46:14.000000000 +0900
@@ -6,7 +6,7 @@
  *	edited by Linus Torvalds
  *
  * SuperH version:   Copyright (C) 1999, 2000  Kaz Kojima & Niibe Yutaka
- *
+ * Audit support: Yuichi Nakamura <ynakam@hitachisoft.jp>
  */
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -24,6 +24,7 @@
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
+#include <linux/audit.h>
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -248,15 +249,18 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
-asmlinkage void do_syscall_trace(void)
+asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
 {
 	struct task_struct *tsk = current;
+	if (unlikely(current->audit_context) && entryexit)
+		audit_syscall_exit(AUDITSC_RESULT(regs->regs[0]),
+				   regs->regs[0]);
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    !test_thread_flag(TIF_SINGLESTEP))
-		return;
+		goto out;
 	if (!(tsk->ptrace & PT_PTRACED))
-		return;
+		goto out;
 	/* the 0x80 provides a way for the tracing parent to distinguish
 	   between a syscall stop and SIGTRAP delivery */
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) &&
@@ -271,4 +275,11 @@ asmlinkage void do_syscall_trace(void)
 		send_sig(tsk->exit_code, tsk, 1);
 		tsk->exit_code = 0;
 	}
+
+out:
+	if (unlikely(current->audit_context) && !entryexit)
+		audit_syscall_entry(AUDIT_ARCH_SH, regs->regs[3],
+				    regs->regs[4], regs->regs[5],
+				    regs->regs[6], regs->regs[7]);
+
 }
--- linux-2.6.24.rc1.orig/include/asm-sh/thread_info.h	2007-10-10 05:31:38.000000000 +0900
+++ linux-2.6.24.rc1/include/asm-sh/thread_info.h	2007-11-07 08:46:37.000000000 +0900
@@ -111,6 +111,7 @@ static inline struct thread_info *curren
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	3	/* restore signal mask in do_signal() */
 #define TIF_SINGLESTEP		4	/* singlestepping active */
+#define TIF_SYSCALL_AUDIT	5
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
@@ -121,6 +122,7 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
+#define _TIF_SYSCALL_AUDIT		(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
--- linux-2.6.24.rc1.orig/init/Kconfig	2007-11-06 16:03:31.000000000 +0900
+++ linux-2.6.24.rc1/init/Kconfig	2007-11-06 16:19:08.000000000 +0900
@@ -226,7 +226,7 @@ config AUDIT
 
 config AUDITSYSCALL
 	bool "Enable system-call auditing support"
-	depends on AUDIT && (X86 || PPC || PPC64 || S390 || IA64 || UML || SPARC64)
+	depends on AUDIT && (X86 || PPC || PPC64 || S390 || IA64 || UML || SPARC64|| SUPERH)
 	default y if SECURITY_SELINUX
 	help
 	  Enable low-overhead system-call auditing infrastructure that


Regards,
-- 
Yuichi Nakamura
Hitachi Software Engineering Co., Ltd.
Japan SELinux Users Group(JSELUG): http://www.selinux.gr.jp/
SELinux Policy Editor: http://seedit.sourceforge.net/

