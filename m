Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZCNGjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZCNGjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 02:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZCNGi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 02:38:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:54113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbZCNGi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 02:38:58 -0400
Subject: [PATCH -tip] x86: entry_32.S fix compiling warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 12:08:13 +0530
Message-Id: <1237012693.18733.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Are these looks OK to you:

Subject: [PATCH] x86: entry_32.S fix compiling warnings

Fixed:
 arch/x86/kernel/entry_32.S:446: Warning: 00000000080001d1 shortened to 00000000000001d1
 arch/x86/kernel/entry_32.S:457: Warning: 000000000800feff shortened to 000000000000feff
 arch/x86/kernel/entry_32.S:527: Warning: 00000000080001d1 shortened to 00000000000001d1
 arch/x86/kernel/entry_32.S:541: Warning: 000000000800feff shortened to 000000000000feff
 arch/x86/kernel/entry_32.S:676: Warning: 0000000008000091 shortened to 0000000000000091

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/entry_32.S |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 899e893..82cf555 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -442,8 +442,7 @@ sysenter_past_esp:
 
 	GET_THREAD_INFO(%ebp)
 
-	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
-	testw $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz sysenter_audit
 sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
@@ -454,7 +453,7 @@ sysenter_do_call:
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
-	testw $_TIF_ALLWORK_MASK, %cx
+	testl $_TIF_ALLWORK_MASK, %ecx
 	jne sysexit_audit
 sysenter_exit:
 /* if something modifies registers it must also disable sysexit */
@@ -468,7 +467,7 @@ sysenter_exit:
 
 #ifdef CONFIG_AUDITSYSCALL
 sysenter_audit:
-	testw $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
 	jnz syscall_trace_entry
 	addl $4,%esp
 	CFI_ADJUST_CFA_OFFSET -4
@@ -485,7 +484,7 @@ sysenter_audit:
 	jmp sysenter_do_call
 
 sysexit_audit:
-	testw $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
 	jne syscall_exit_work
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)
@@ -498,7 +497,7 @@ sysexit_audit:
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
-	testw $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %cx
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT), %ecx
 	jne syscall_exit_work
 	movl PT_EAX(%esp),%eax	/* reload syscall return value */
 	jmp sysenter_exit
@@ -523,8 +522,7 @@ ENTRY(system_call)
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 					# system call tracing in operation / emulation
-	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
-	testw $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%ebp)
 	jnz syscall_trace_entry
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
@@ -538,7 +536,7 @@ syscall_exit:
 					# between sampling and the iret
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
-	testw $_TIF_ALLWORK_MASK, %cx	# current->work
+	testl $_TIF_ALLWORK_MASK, %ecx	# current->work
 	jne syscall_exit_work
 
 restore_all:
@@ -673,7 +671,7 @@ END(syscall_trace_entry)
 	# perform syscall exit tracing
 	ALIGN
 syscall_exit_work:
-	testb $_TIF_WORK_SYSCALL_EXIT, %cl
+	testl $_TIF_WORK_SYSCALL_EXIT, %ecx
 	jz work_pending
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_ANY)	# could let syscall_trace_leave() call
-- 
1.6.0.6



