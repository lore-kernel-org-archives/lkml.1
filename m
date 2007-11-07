Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbXKGPtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbXKGPtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXKGPtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:49:33 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:59219 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXKGPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:49:32 -0500
Date: Wed, 7 Nov 2007 10:48:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Chuck Ebbert <76306.1226@compuserve.com>,
       Roland McGrath <roland@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 - 32-bit ptrace emulation mishandles 6th arg
Message-ID: <20071107154839.GA5981@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <76306.1226@compuserve.com>

[ jdike - Pushing Chuck's patch - see
http://lkml.org/lkml/2005/9/16/261 for some history and a test
program.  UML is also broken without this patch - its processes get
SIGBUS from the corrupt 6th argument to mmap being interpretted as a
file offset ]

When the 32-bit vDSO is used to make a system call, the %ebp register for
the 6th syscall arg has to be loaded from the user stack (where it's pushed
by the vDSO user code).  The native i386 kernel always does this before
stopping for syscall tracing, so %ebp can be seen and modified via ptrace
to access the 6th syscall argument.  The x86-64 kernel fails to do this,
presenting the stack address to ptrace instead.  This makes the %rbp value
seen by 64-bit ptrace of a 32-bit process, and the %ebp value seen by a
32-bit caller of ptrace, both differ from the native i386 behavior.

This patch fixes the problem by putting the word loaded from the user stack
into %rbp before calling syscall_trace_enter, and reloading the 6th syscall
argument from there afterwards (so ptrace can change it).  This makes the
behavior match that of i386 kernels.

Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Original-Patch-By: Roland McGrath <roland@redhat.com>
---
 arch/x86_64/ia32/ia32entry.S |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 18b2318..df588f0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -159,20 +159,16 @@ sysenter_do_call:
 
 sysenter_tracesys:
 	CFI_RESTORE_STATE
+	xchgl	%r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	movl	%ebp, %ebp
-	/* no need to do an access_ok check here because rbp has been
-	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
+	xchgl	%ebp,%r9d
 	jmp	sysenter_do_call
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
@@ -262,20 +258,17 @@ cstar_do_call:
 	
 cstar_tracesys:	
 	CFI_RESTORE_STATE
+	xchgl %r9d,%ebp
 	SAVE_REST
 	CLEAR_RREGS
+	movq %r9,R9(%rsp)
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
+	xchgl %ebp,%r9d
 	movl RSP-ARGOFFSET(%rsp), %r8d
-	/* no need to do an access_ok check here because r8 has been
-	   32bit zero extended */ 
-1:	movl	(%r8),%r9d
-	.section __ex_table,"a"
-	.quad 1b,ia32_badarg
-	.previous
 	jmp cstar_do_call
 END(ia32_cstar_target)
 				
