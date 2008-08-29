Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYH2MUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYH2MUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 08:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYH2MT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 08:19:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15204 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYH2MT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 08:19:57 -0400
Message-Id: <48B805D7.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 13:21:11 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: slightly stream-line 32-bit syscall entry code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid updating registers or memory twice as well as needlessly loading
or copying registers.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/ia32/ia32entry.S |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

--- linux-2.6.27-rc5/arch/x86/ia32/ia32entry.S	2008-08-29 10:53:00.000000000 +0200
+++ 2.6.27-rc5-x86_64-ia32entry/arch/x86/ia32/ia32entry.S	2008-08-22 15:24:33.000000000 +0200
@@ -39,11 +39,11 @@
 	.endm 
 
 	/* clobbers %eax */	
-	.macro  CLEAR_RREGS
+	.macro  CLEAR_RREGS _r9=rax
 	xorl 	%eax,%eax
 	movq	%rax,R11(%rsp)
 	movq	%rax,R10(%rsp)
-	movq	%rax,R9(%rsp)
+	movq	%\_r9,R9(%rsp)
 	movq	%rax,R8(%rsp)
 	.endm
 
@@ -52,11 +52,10 @@
 	 * We don't reload %eax because syscall_trace_enter() returned
 	 * the value it wants us to use in the table lookup.
 	 */
-	.macro LOAD_ARGS32 offset
-	movl \offset(%rsp),%r11d
-	movl \offset+8(%rsp),%r10d
+	.macro LOAD_ARGS32 offset, _r9=0
+	.if \_r9
 	movl \offset+16(%rsp),%r9d
-	movl \offset+24(%rsp),%r8d
+	.endif
 	movl \offset+40(%rsp),%ecx
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
@@ -145,7 +144,7 @@ ENTRY(ia32_sysenter_target)
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
+1:	movl	(%rbp),%ebp
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
  	.previous	
@@ -157,7 +156,7 @@ ENTRY(ia32_sysenter_target)
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 sysenter_do_call:
-	IA32_ARG_FIXUP 1
+	IA32_ARG_FIXUP
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
@@ -234,20 +233,17 @@ sysexit_audit:
 #endif
 
 sysenter_tracesys:
-	xchgl	%r9d,%ebp
 #ifdef CONFIG_AUDITSYSCALL
 	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
 	CLEAR_RREGS
-	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	xchgl	%ebp,%r9d
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
@@ -314,9 +310,9 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-cstar_do_call:	
 	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
+cstar_do_call:
 	IA32_ARG_FIXUP 1
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
@@ -357,15 +353,13 @@ cstar_tracesys:
 #endif
 	xchgl %r9d,%ebp
 	SAVE_REST
-	CLEAR_RREGS
-	movq %r9,R9(%rsp)
+	CLEAR_RREGS r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	movl RSP-ARGOFFSET(%rsp), %r8d
 	cmpl $(IA32_NR_syscalls-1),%eax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call



