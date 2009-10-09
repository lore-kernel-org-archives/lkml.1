Return-Path: <linux-kernel-owner+w=401wt.eu-S1761571AbZJIXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761571AbZJIXQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761561AbZJIXQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:16:48 -0400
Received: from kroah.org ([198.145.64.141]:36732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045AbZJIXQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:16:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:00 2009
Message-Id: <20091009231000.480936034@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 03/26] x86: Dont leak 64-bit kernel register values to 32-bit processes
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=x86-don-t-leak-64-bit-kernel-register-values-to-32-bit-processes.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan Beulich <JBeulich@novell.com>

commit 24e35800cdc4350fc34e2bed37b608a9e13ab3b6 upstream.

While 32-bit processes can't directly access R8...R15, they can
gain access to these registers by temporarily switching themselves
into 64-bit mode.

Therefore, registers not preserved anyway by called C functions
(i.e. R8...R11) must be cleared prior to returning to user mode.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4AC34D73020000780001744A@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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


