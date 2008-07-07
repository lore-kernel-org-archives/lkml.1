Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYGGG5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYGGG5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYGGG5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:57:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYGGG5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:57:39 -0400
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
Subject: [PATCH 2/4] x86_64 syscall audit fast-path
In-Reply-To: Roland McGrath's message of  Sunday, 6 July 2008 23:56:15 -0700 <20080707065615.77BD9154246@magilla.localdomain>
References: <20080707065615.77BD9154246@magilla.localdomain>
Emacs: it's not slow --- it's stately.
Message-Id: <20080707065706.8407D154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 23:57:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a fast path for 64-bit syscall entry and exit when
TIF_SYSCALL_AUDIT is set, but no other kind of syscall tracing.
This path does not need to save and restore all registers as
the general case of tracing does.  Avoiding the iret return path
when syscall audit is enabled helps performance a lot.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/entry_64.S |   42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/auditsc.c           |    3 ++-
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index f9c859d..9b152d5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -52,6 +52,12 @@
 #include <asm/irqflags.h>
 #include <asm/paravirt.h>
 
+/* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
+#include <linux/elf-em.h>
+#define AUDIT_ARCH_X86_64	(EM_X86_64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
+#define __AUDIT_ARCH_64BIT 0x80000000
+#define __AUDIT_ARCH_LE	   0x40000000
+
 	.code64
 
 #ifndef CONFIG_PREEMPT
@@ -246,6 +252,7 @@ ENTRY(system_call_after_swapgs)
 	GET_THREAD_INFO(%rcx)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
 	jnz tracesys
+system_call_fastpath:
 	cmpq $__NR_syscall_max,%rax
 	ja badsys
 	movq %r10,%rcx
@@ -296,6 +303,8 @@ sysret_careful:
 sysret_signal:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
+	bt $TIF_SYSCALL_AUDIT,%edx
+	jc sysret_audit
 	/* edx:	work flags (arg3) */
 	leaq do_notify_resume(%rip),%rax
 	leaq -ARGOFFSET(%rsp),%rdi # &pt_regs -> arg1
@@ -312,8 +321,41 @@ badsys:
 	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
 	jmp ret_from_sys_call
 
+	/*
+	 * Fast path for syscall audit without full syscall trace.
+	 * We just call audit_syscall_entry() directly, and then
+	 * jump back to the normal fast path.
+	 */
+auditsys:
+	movq %r10,%r9			/* 6th arg: 4th syscall arg */
+	movq %rdx,%r8			/* 5th arg: 3rd syscall arg */
+	movq %rsi,%rcx			/* 4th arg: 2nd syscall arg */
+	movq %rdi,%rdx			/* 3rd arg: 1st syscall arg */
+	movq %rax,%rsi			/* 2nd arg: syscall number */
+	movl $AUDIT_ARCH_X86_64,%edi	/* 1st arg: audit arch */
+	call audit_syscall_entry
+	LOAD_ARGS 0		/* reload call-clobbered registers */
+	jmp system_call_fastpath
+
+	/*
+	 * Return fast path for syscall audit.  Call audit_syscall_exit()
+	 * directly and then jump back to the fast path with TIF_SYSCALL_AUDIT
+	 * masked off.
+	 */
+sysret_audit:
+	movq %rax,%rsi		/* second arg, syscall return value */
+	cmpq $0,%rax		/* is it < 0? */
+	setl %al		/* 1 if so, 0 if not */
+	movzbl %al,%edi		/* zero-extend that into %edi */
+	inc %edi /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
+	call audit_syscall_exit
+	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
+	jmp sysret_check
+
 	/* Do syscall tracing */
 tracesys:			 
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SECCOMP),threadinfo_flags(%rcx)
+	jz auditsys
 	SAVE_REST
 	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
 	FIXUP_TOP_OF_STACK %rdi
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c10e7aa..4699950 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1476,7 +1476,8 @@ void audit_syscall_entry(int arch, int major,
 	struct audit_context *context = tsk->audit_context;
 	enum audit_state     state;
 
-	BUG_ON(!context);
+	if (unlikely(!context))
+		return;
 
 	/*
 	 * This happens only on certain architectures that make system
