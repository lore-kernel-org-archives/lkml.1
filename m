Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYCXXsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYCXXsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYCXXrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:47:55 -0400
Received: from gw.goop.org ([64.81.55.164]:53653 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbYCXXry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:47:54 -0400
Message-ID: <47E83C99.3040800@goop.org>
Date: Mon, 24 Mar 2008 16:43:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH FIXED] x86: only enable interrupts when kernel state has been
 set up
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysenter path tries to enable interrupts immediately.  Unfortunately
this doesn't work in a paravirt environment, because not enough kernel
state has been set up at that point (namely, pointing %fs to the kernel
percpu data segment).  To fix this, defer ENABLE_INTERRUPTS until after
the kernel state has been set up.

Unfortunately this means that we're running with interrupts disabled
for a while without calling the IRQ tracing code, but that can't be
called without setting up %fs either.

[ Fix since last posting: make sure saved eflags has interrupts enabled. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_32.S |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -290,10 +290,10 @@ ENTRY(ia32_sysenter_target)
 	movl TSS_sysenter_sp0(%esp),%esp
 ENTRY(sysenter_past_esp)
 	/*
-	 * No need to follow this irqs on/off section: the syscall
-	 * disabled irqs and here we enable it straight after entry:
+	 * Interrupts are disabled here, but we can't trace it until
+	 * enough kernel state to call TRACE_IRQS_OFF can be called - but
+	 * we immediately enable interrupts at that point anyway.
 	 */
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushl $(__USER_DS)
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET ss, 0*/
@@ -301,6 +301,7 @@ ENTRY(sysenter_past_esp)
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET esp, 0
 	pushfl
+	orl $X86_EFLAGS_IF, (%esp)
 	CFI_ADJUST_CFA_OFFSET 4
 	pushl $(__USER_CS)
 	CFI_ADJUST_CFA_OFFSET 4
@@ -314,6 +315,11 @@ ENTRY(sysenter_past_esp)
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET eip, 0
 
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	ENABLE_INTERRUPTS(CLBR_NONE)
+
 /*
  * Load the potential sixth argument from user stack.
  * Careful about security.
@@ -321,14 +327,12 @@ ENTRY(sysenter_past_esp)
 	cmpl $__PAGE_OFFSET-3,%ebp
 	jae syscall_fault
 1:	movl (%ebp),%ebp
+	movl %ebp,PT_EBP(%esp)
 .section __ex_table,"a"
 	.align 4
 	.long 1b,syscall_fault
 .previous
 
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
@@ -542,9 +546,6 @@ END(syscall_exit_work)
 
 	RING0_INT_FRAME			# can't unwind into user space anyway
 syscall_fault:
-	pushl %eax			# save orig_eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
 	movl $-EFAULT,PT_EAX(%esp)
 	jmp resume_userspace

