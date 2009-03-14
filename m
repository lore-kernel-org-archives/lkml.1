Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZCNHTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZCNHTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZCNHTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:19:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:36913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbZCNHTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:19:09 -0400
Date: Sat, 14 Mar 2009 07:18:32 GMT
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, fweisbec@gmail.com,
       hpa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, fweisbec@gmail.com,
       hpa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237012693.18733.3.camel@ht.satnam>
References: <1237012693.18733.3.camel@ht.satnam>
Subject: [tip:tracing/syscalls] x86: entry_32.S fix compile warnings - fix work mask bit width
Message-ID: <tip-95baa1a17ff80183317d815189fe1f12fdb653bc@git.kernel.org>
Git-Commit-ID: 95baa1a17ff80183317d815189fe1f12fdb653bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 07:18:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95baa1a17ff80183317d815189fe1f12fdb653bc
Gitweb:     http://git.kernel.org/tip/95baa1a17ff80183317d815189fe1f12fdb653bc
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 14 Mar 2009 12:08:13 +0530
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 08:16:01 +0100

x86: entry_32.S fix compile warnings - fix work mask bit width

Fix:

 arch/x86/kernel/entry_32.S:446: Warning: 00000000080001d1 shortened to 00000000000001d1
 arch/x86/kernel/entry_32.S:457: Warning: 000000000800feff shortened to 000000000000feff
 arch/x86/kernel/entry_32.S:527: Warning: 00000000080001d1 shortened to 00000000000001d1
 arch/x86/kernel/entry_32.S:541: Warning: 000000000800feff shortened to 000000000000feff
 arch/x86/kernel/entry_32.S:676: Warning: 0000000008000091 shortened to 0000000000000091

TIF_SYSCALL_FTRACE is 0x08000000 and until now we checked the
first 16 bits of the work mask - bit 27 falls outside of that.

Update the entry_32.S code to check the full 32-bit mask.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>
LKML-Reference: <1237012693.18733.3.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
