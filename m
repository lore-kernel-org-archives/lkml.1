Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZJAJ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZJAJ7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZJAJ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:59:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:55816 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbZJAJ7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:59:37 -0400
Date: Thu, 1 Oct 2009 09:59:12 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, stable@kernel.org, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, stable@kernel.org, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AC34D73020000780001744A@vpn.id2.novell.com>
References: <4AC34D73020000780001744A@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don't leak 64-bit kernel register values to 32-bit processes
Message-ID: <tip-24e35800cdc4350fc34e2bed37b608a9e13ab3b6@git.kernel.org>
Git-Commit-ID: 24e35800cdc4350fc34e2bed37b608a9e13ab3b6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 09:59:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24e35800cdc4350fc34e2bed37b608a9e13ab3b6
Gitweb:     http://git.kernel.org/tip/24e35800cdc4350fc34e2bed37b608a9e13ab3b6
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 30 Sep 2009 11:22:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 11:24:26 +0200

x86: Don't leak 64-bit kernel register values to 32-bit processes

While 32-bit processes can't directly access R8...R15, they can
gain access to these registers by temporarily switching themselves
into 64-bit mode.

Therefore, registers not preserved anyway by called C functions
(i.e. R8...R11) must be cleared prior to returning to user mode.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org>
LKML-Reference: <4AC34D73020000780001744A@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/ia32/ia32entry.S |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 74619c4..1733f9f 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
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
