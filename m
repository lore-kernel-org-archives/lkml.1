Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXI1IET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXI1IET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757836AbXI1IBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbXI1IBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:46 -0400
Message-Id: <20070928080041.186579000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/12] lockdep: i386: connect the sysexit hook
Content-Disposition: inline; filename=lockdep-i386-sys_exit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Run the lockdep_sys_exit hook after all other C code on the syscall
return path.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/i386/kernel/entry.S    |    3 +++
 include/asm-i386/irqflags.h |   13 +++++++++++++
 2 files changed, 16 insertions(+)

Index: linux-2.6/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/i386/kernel/entry.S
+++ linux-2.6/arch/i386/kernel/entry.S
@@ -338,6 +338,7 @@ sysenter_past_esp:
 	jae syscall_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
+	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
@@ -376,6 +377,7 @@ ENTRY(system_call)
 syscall_call:
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)		# store the return value
+	LOCKDEP_SYS_EXIT
 syscall_exit:
 	DISABLE_INTERRUPTS(CLBR_ANY)	# make sure we don't miss an interrupt
 					# setting need_resched or sigpending
@@ -532,6 +534,7 @@ syscall_exit_work:
 	movl %esp, %eax
 	movl $1, %edx
 	call do_syscall_trace
+	LOCKDEP_SYS_EXIT
 	jmp resume_userspace
 END(syscall_exit_work)
 	CFI_ENDPROC
Index: linux-2.6/include/asm-i386/irqflags.h
===================================================================
--- linux-2.6.orig/include/asm-i386/irqflags.h
+++ linux-2.6/include/asm-i386/irqflags.h
@@ -160,4 +160,17 @@ static inline int raw_irqs_disabled(void
 # define TRACE_IRQS_OFF
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define LOCKDEP_SYS_EXIT			\
+	pushl %eax;				\
+	pushl %ecx;				\
+	pushl %edx;				\
+	call lockdep_sys_exit;			\
+	popl %edx;				\
+	popl %ecx;				\
+	popl %eax;
+#else
+# define LOCKDEP_SYS_EXIT
+#endif
+
 #endif

--

