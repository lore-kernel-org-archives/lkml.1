Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYGGG6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYGGG6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYGGG6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:58:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYGGG6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:58:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 4/4] i386 syscall audit fast-path
In-Reply-To: Roland McGrath's message of  Sunday, 6 July 2008 23:56:15 -0700 <20080707065615.77BD9154246@magilla.localdomain>
References: <20080707065615.77BD9154246@magilla.localdomain>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20080707065813.3A1D9154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 23:58:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds fast paths for 32-bit syscall entry and exit when
TIF_SYSCALL_AUDIT is set, but no other kind of syscall tracing.
These paths does not need to save and restore all registers as
the general case of tracing does.  Avoiding the iret return path
when syscall audit is enabled helps performance a lot.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_32.S |   48 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c778e4f..daf1361 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -53,6 +53,11 @@
 #include <asm/processor-flags.h>
 #include "irq_vectors.h"
 
+/* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
+#include <linux/elf-em.h>
+#define AUDIT_ARCH_I386		(EM_386|__AUDIT_ARCH_LE)
+#define __AUDIT_ARCH_LE	   0x40000000
+
 /*
  * We use macros for low-level operations which need to be overridden
  * for paravirtualization.  The following will never clobber any registers:
@@ -332,7 +337,8 @@ sysenter_past_esp:
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
 	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
-	jnz syscall_trace_entry
+	jnz sysenter_audit
+sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
 	call *sys_call_table(,%eax,4)
@@ -342,7 +348,8 @@ sysenter_past_esp:
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
 	testw $_TIF_ALLWORK_MASK, %cx
-	jne syscall_exit_work
+	jne sysexit_audit
+sysenter_exit:
 /* if something modifies registers it must also disable sysexit */
 	movl PT_EIP(%esp), %edx
 	movl PT_OLDESP(%esp), %ecx
@@ -350,6 +357,43 @@ sysenter_past_esp:
 	TRACE_IRQS_ON
 1:	mov  PT_FS(%esp), %fs
 	ENABLE_INTERRUPTS_SYSCALL_RET
+
+sysenter_audit:
+	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP),TI_flags(%ebp)
+	jnz syscall_trace_entry
+	addl $4,%esp
+	CFI_ADJUST_CFA_OFFSET -4
+	/* %esi already in 8(%esp)	   6th arg: 4th syscall arg */
+	/* %edx already in 4(%esp)	   5th arg: 3rd syscall arg */
+	/* %ecx already in 0(%esp)	   4th arg: 2nd syscall arg */
+	movl %ebx,%ecx			/* 3rd arg: 1st syscall arg */
+	movl %eax,%edx			/* 2nd arg: syscall number */
+	movl $AUDIT_ARCH_I386,%eax	/* 1st arg: audit arch */
+	call audit_syscall_entry
+	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	movl PT_EAX(%esp),%eax		/* reload syscall number */
+	jmp sysenter_do_call
+
+sysexit_audit:
+	testw $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
+	jne syscall_exit_work
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_ANY)
+	movl %eax,%edx		/* second arg, syscall return value */
+	cmpl $0,%eax		/* is it < 0? */
+	setl %al		/* 1 if so, 0 if not */
+	movzbl %al,%eax		/* zero-extend that */
+	inc %eax /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
+	call audit_syscall_exit
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	TRACE_IRQS_OFF
+	movl TI_flags(%ebp), %ecx
+	testw $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
+	jne syscall_exit_work
+	movl PT_EAX(%esp),%eax	/* reload syscall return value */
+	jmp sysenter_exit
+
 	CFI_ENDPROC
 .pushsection .fixup,"ax"
 2:	movl $0,PT_FS(%esp)
