Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXLMJTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXLMJTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXLMJTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:19:32 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31486
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbXLMJTb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:19:31 -0500
Message-Id: <47610766.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:20:22 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <76306.1226@compuserve.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: ia32entry adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This addresses several points:
- CLEAR_RREGS' clearing of R9 became redundant with the recent change
  to cstar_tracesys' saving/restoring %r9
- LOAD_ARGS32 has no need for re-loading %r8-%r11, except in the case
  of cstar_tracesys, where %r9 must be re-loaded
- the recent change to sysenter handling aimed for full compatibility
  with native i386 code, but didn't go as far as making the code match
  that behavior even for the non-traced case (i386 loads %ebp from
  (%ebp) in all cases)
- that same recent patch failed to recognize the possibility to
  eliminate the re-loading for %r8d in cstar_tracesys

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Chuck Ebbert <76306.1226@compuserve.com>

 arch/x86/ia32/ia32entry.S |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- linux-2.6.24-rc5/arch/x86/ia32/ia32entry.S	2007-12-12 16:48:17.000000000 +0100
+++ 2.6.24-rc5-x86_64-ia32entry/arch/x86/ia32/ia32entry.S	2007-12-07 14:41:50.000000000 +0100
@@ -30,19 +30,18 @@
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
@@ -119,7 +118,7 @@ ENTRY(ia32_sysenter_target)
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
+1:	movl	(%rbp),%ebp
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
  	.previous	
@@ -131,7 +130,7 @@ ENTRY(ia32_sysenter_target)
 sysenter_do_call:	
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
-	IA32_ARG_FIXUP 1
+	IA32_ARG_FIXUP
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
 	GET_THREAD_INFO(%r10)
@@ -159,16 +158,13 @@ sysenter_do_call:	
 
 sysenter_tracesys:
 	CFI_RESTORE_STATE
-	xchgl	%r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
-	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	xchgl	%ebp,%r9d
 	jmp	sysenter_do_call
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
@@ -260,15 +256,13 @@ cstar_tracesys:	
 	CFI_RESTORE_STATE
 	xchgl %r9d,%ebp
 	SAVE_REST
-	CLEAR_RREGS
-	movq %r9,R9(%rsp)
+	CLEAR_RREGS r9
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	movl RSP-ARGOFFSET(%rsp), %r8d
 	jmp cstar_do_call
 END(ia32_cstar_target)
 				



