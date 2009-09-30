Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZI3KWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZI3KWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZI3KWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:22:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:17233 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZI3KWK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Wed, 30 Sep 2009 06:22:10 -0400
Message-Id: <4AC34D73020000780001744A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Sep 2009 11:22:11 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: don't leak kernel register values to 32-bit
	 processes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While 32-bit processes can't directly access R8...R15, they can gain
access to these registers by temporarily switching themselves into
64-bit mode. Therefore, registers not preserved anyway by called C
functions (i.e. R8...R11) must be cleared prior to returning to user
mode.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/ia32/ia32entry.S |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- linux-2.6.32-rc1/arch/x86/ia32/ia32entry.S	2009-09-30 11:48:25.000000000 +0200
+++ 2.6.32-rc1-x86_64-ia32-syscall-reg-leak/arch/x86/ia32/ia32entry.S	2009-09-28 16:16:44.000000000 +0200
@@ -21,8 +21,8 @@
 #define __AUDIT_ARCH_LE	   0x40000000
 
 #ifndef CONFIG_AUDITSYSCALL
-#define sysexit_audit int_ret_from_sys_call
-#define sysretl_audit int_ret_from_sys_call
+#define sysexit_audit ia32_ret_from_sys_call
+#define sysretl_audit ia32_ret_from_sys_call
 #endif
 
 #define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
@@ -39,12 +39,12 @@
 	.endm 
 
 	/* clobbers %eax */	
-	.macro  CLEAR_RREGS _r9=rax
+	.macro  CLEAR_RREGS offset=0, _r9=rax
 	xorl 	%eax,%eax
-	movq	%rax,R11(%rsp)
-	movq	%rax,R10(%rsp)
-	movq	%\_r9,R9(%rsp)
-	movq	%rax,R8(%rsp)
+	movq	%rax,\offset+R11(%rsp)
+	movq	%rax,\offset+R10(%rsp)
+	movq	%\_r9,\offset+R9(%rsp)
+	movq	%rax,\offset+R8(%rsp)
 	.endm
 
 	/*
@@ -172,6 +172,10 @@ sysexit_from_sys_call:
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
 	RESTORE_ARGS 1,24,1,1,1,1
+	xorq	%r8,%r8
+	xorq	%r9,%r9
+	xorq	%r10,%r10
+	xorq	%r11,%r11
 	popfq
 	CFI_ADJUST_CFA_OFFSET -8
 	/*CFI_RESTORE rflags*/
@@ -202,7 +206,7 @@ sysexit_from_sys_call:
 
 	.macro auditsys_exit exit,ebpsave=RBP
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
-	jnz int_ret_from_sys_call
+	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
 	sti
 	movl %eax,%esi		/* second arg, syscall return value */
@@ -218,8 +222,9 @@ sysexit_from_sys_call:
 	cli
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags(%r10)
-	jnz int_with_check
-	jmp \exit
+	jz \exit
+	CLEAR_RREGS -ARGOFFSET
+	jmp int_with_check
 	.endm
 
 sysenter_auditsys:
@@ -329,6 +334,9 @@ sysretl_from_sys_call:
 	CFI_REGISTER rip,rcx
 	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
 	/*CFI_REGISTER rflags,r11*/
+	xorq	%r10,%r10
+	xorq	%r9,%r9
+	xorq	%r8,%r8
 	TRACE_IRQS_ON
 	movl RSP-ARGOFFSET(%rsp),%esp
 	CFI_RESTORE rsp
@@ -353,7 +361,7 @@ cstar_tracesys:
 #endif
 	xchgl %r9d,%ebp
 	SAVE_REST
-	CLEAR_RREGS r9
+	CLEAR_RREGS 0, r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
@@ -425,6 +433,8 @@ ia32_do_call:
 	call *ia32_sys_call_table(,%rax,8) # xxx: rip relative
 ia32_sysret:
 	movq %rax,RAX-ARGOFFSET(%rsp)
+ia32_ret_from_sys_call:
+	CLEAR_RREGS -ARGOFFSET
 	jmp int_ret_from_sys_call 
 
 ia32_tracesys:			 
@@ -442,8 +452,8 @@ END(ia32_syscall)
 
 ia32_badsys:
 	movq $0,ORIG_RAX-ARGOFFSET(%rsp)
-	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
-	jmp int_ret_from_sys_call
+	movq $-ENOSYS,%rax
+	jmp ia32_sysret
 
 quiet_ni_syscall:
 	movq $-ENOSYS,%rax



