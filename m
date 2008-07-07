Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYGGG63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYGGG63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYGGG6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:58:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbYGGG6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:58:19 -0400
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
Subject: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: Roland McGrath's message of  Sunday, 6 July 2008 23:56:15 -0700 <20080707065615.77BD9154246@magilla.localdomain>
References: <20080707065615.77BD9154246@magilla.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080707065742.7C119154246@magilla.localdomain>
Date: Sun,  6 Jul 2008 23:57:42 -0700 (PDT)
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
 arch/x86/ia32/ia32entry.S  |   78 +++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/entry_64.S |    1 +
 2 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index b5e329d..f38a354 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -15,6 +15,11 @@
 #include <asm/irqflags.h>
 #include <linux/linkage.h>
 
+/* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
+#include <linux/elf-em.h>
+#define AUDIT_ARCH_I386		(EM_386|__AUDIT_ARCH_LE)
+#define __AUDIT_ARCH_LE	   0x40000000
+
 #define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
 
 	.macro IA32_ARG_FIXUP noebp=0
@@ -131,13 +136,17 @@ sysenter_do_call:
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 	IA32_ARG_FIXUP 1
+sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),threadinfo_flags(%r10)
 	jnz	int_ret_from_sys_call
+	bt	$TIF_SYSCALL_AUDIT,threadinfo_flags(%r10)
+	jc	sysexit_audit
+sysexit_from_sys_call:
 	andl    $~TS_COMPAT,threadinfo_status(%r10)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
@@ -156,9 +165,56 @@ sysenter_do_call:
 	/* sysexit */
 	.byte	0xf, 0x35
 
-sysenter_tracesys:
+	.macro auditsys_entry dispatch
+	movl %esi,%r9d			/* 6th arg: 4th syscall arg */
+	movl %edx,%r8d			/* 5th arg: 3rd syscall arg */
+	/* (already in %ecx)		   4th arg: 2nd syscall arg */
+	movl %ebx,%edx			/* 3rd arg: 1st syscall arg */
+	movl %eax,%esi			/* 2nd arg: syscall number */
+	movl $AUDIT_ARCH_I386,%edi	/* 1st arg: audit arch */
+	call audit_syscall_entry
+	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall number */
+	cmpl $(IA32_NR_syscalls-1),%eax
+	ja ia32_badsys
+	movl %ebx,%edi			/* reload 1st syscall arg */
+	movl RCX-ARGOFFSET(%rsp),%esi	/* reload 2nd syscall arg */
+	movl RDX-ARGOFFSET(%rsp),%edx	/* reload 3rd syscall arg */
+	movl RSI-ARGOFFSET(%rsp),%ecx	/* reload 4th syscall arg */
+	movl RDI-ARGOFFSET(%rsp),%r8d	/* reload 5th syscall arg */
+	movl %ebp,%r9d			/* reload 6th syscall arg */
+	jmp \dispatch
+	.endm
+
+	.macro auditsys_exit exit
+	TRACE_IRQS_ON
+	sti
+	movl %eax,%esi		/* second arg, syscall return value */
+	cmpl $0,%eax		/* is it < 0? */
+	setl %al		/* 1 if so, 0 if not */
+	movzbl %al,%edi		/* zero-extend that into %edi */
+	inc %edi /* first arg, 0->1(AUDITSC_SUCCESS), 1->2(AUDITSC_FAILURE) */
+	call audit_syscall_exit
+	GET_THREAD_INFO(%r10)
+	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
+	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
+	cli
+	TRACE_IRQS_OFF
+	testl %edi,threadinfo_flags(%r10)
+	jnz int_with_check
+	jmp \exit
+	.endm
+
+sysenter_auditsys:
 	CFI_RESTORE_STATE
+	auditsys_entry sysenter_dispatch
+
+sysexit_audit:
+	auditsys_exit sysexit_from_sys_call
+
+sysenter_tracesys:
 	xchgl	%r9d,%ebp
+	testl	$(_TIF_SYSCALL_TRACE|_TIF_SECCOMP),threadinfo_flags(%r10)
+	jz	sysenter_auditsys
 	SAVE_REST
 	CLEAR_RREGS
 	movq	%r9,R9(%rsp)
@@ -238,13 +294,17 @@ cstar_do_call:
 	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
 	IA32_ARG_FIXUP 1
+cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
 	GET_THREAD_INFO(%r10)
 	cli
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
-	jnz  int_ret_from_sys_call
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),threadinfo_flags(%r10)
+	jnz int_ret_from_sys_call
+	bt $TIF_SYSCALL_AUDIT,threadinfo_flags(%r10)
+	jc sysretl_audit
+sysretl_from_sys_call:
 	andl $~TS_COMPAT,threadinfo_status(%r10)
 	RESTORE_ARGS 1,-ARG_SKIP,1,1,1
 	movl RIP-ARGOFFSET(%rsp),%ecx
@@ -257,9 +317,17 @@ cstar_do_call:
 	swapgs
 	sysretl
 	
-cstar_tracesys:	
+cstar_auditsys:
 	CFI_RESTORE_STATE
+	auditsys_entry cstar_dispatch
+
+sysretl_audit:
+	auditsys_exit sysretl_from_sys_call
+
+cstar_tracesys:
 	xchgl %r9d,%ebp
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SECCOMP),threadinfo_flags(%r10)
+	jz cstar_auditsys
 	SAVE_REST
 	CLEAR_RREGS
 	movq %r9,R9(%rsp)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 9b152d5..01c3e6b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -375,6 +375,7 @@ tracesys:
  * Has correct top of stack, but partial stack frame.
  */
 	.globl int_ret_from_sys_call
+	.globl int_with_check
 int_ret_from_sys_call:
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
