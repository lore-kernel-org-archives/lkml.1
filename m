Return-Path: <linux-kernel-owner+w=401wt.eu-S933775AbXIUXDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbXIUXDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762202AbXIUXCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:02:53 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45230 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbXIUXCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:02:52 -0400
Date: Fri, 21 Sep 2007 16:02:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.7
Message-ID: <20070921230202.GC3906@sequoia.sous-sol.org>
References: <20070921230031.GB3906@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921230031.GB3906@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3067f6a..12edea0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = .6
+EXTRAVERSION = .7
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/arch/x86_64/ia32/ia32entry.S b/arch/x86_64/ia32/ia32entry.S
index 47565c3..0bc623a 100644
--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -38,6 +38,18 @@
 	movq	%rax,R8(%rsp)
 	.endm
 
+	.macro LOAD_ARGS32 offset
+	movl \offset(%rsp),%r11d
+	movl \offset+8(%rsp),%r10d
+	movl \offset+16(%rsp),%r9d
+	movl \offset+24(%rsp),%r8d
+	movl \offset+40(%rsp),%ecx
+	movl \offset+48(%rsp),%edx
+	movl \offset+56(%rsp),%esi
+	movl \offset+64(%rsp),%edi
+	movl \offset+72(%rsp),%eax
+	.endm
+	
 	.macro CFI_STARTPROC32 simple
 	CFI_STARTPROC	\simple
 	CFI_UNDEFINED	r8
@@ -152,7 +164,7 @@ sysenter_tracesys:
 	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
-	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	movl	%ebp, %ebp
 	/* no need to do an access_ok check here because rbp has been
@@ -255,7 +267,7 @@ cstar_tracesys:
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	movl RSP-ARGOFFSET(%rsp), %r8d
 	/* no need to do an access_ok check here because r8 has been
@@ -333,7 +345,7 @@ ia32_tracesys:
 	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	jmp ia32_do_syscall
 END(ia32_syscall)
diff --git a/arch/x86_64/kernel/ptrace.c b/arch/x86_64/kernel/ptrace.c
index 9409117..8d89d8c 100644
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -223,10 +223,6 @@ static int putreg(struct task_struct *child,
 {
 	unsigned long tmp; 
 	
-	/* Some code in the 64bit emulation may not be 64bit clean.
-	   Don't take any chances. */
-	if (test_tsk_thread_flag(child, TIF_IA32))
-		value &= 0xffffffff;
 	switch (regno) {
 		case offsetof(struct user_regs_struct,fs):
 			if (value && (value & 3) != 3)
