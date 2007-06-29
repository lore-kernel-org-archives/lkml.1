Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbXF2Vub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbXF2Vub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbXF2Vtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:49:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2536 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbXF2Vtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:49:36 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Jun 2007 14:48:52 -0700
Subject: [patch 2/6] sys_indirect RFC - add call_syscall helper to the x86 archs
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28360.1183153735.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new call_syscall() helper for the x86 family
archs, to be used by sys_indirect().


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 arch/i386/kernel/entry.S    |   18 ++++++++++++++++++
 arch/x86_64/kernel/entry.S  |   18 ++++++++++++++++++
 include/asm-i386/unistd.h   |   16 ++++++++++++++++
 include/asm-x86_64/unistd.h |   15 +++++++++++++++
 4 files changed, 67 insertions(+)

Index: linux-2.6.mod/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86_64/unistd.h	2007-06-29 12:12:42.000000000 -0700
+++ linux-2.6.mod/include/asm-x86_64/unistd.h	2007-06-29 12:57:59.000000000 -0700
@@ -669,6 +669,21 @@
 				const struct sigaction __user *act,
 				struct sigaction __user *oact,
 				size_t sigsetsize);
+extern long call_syscall(unsigned int nr, const unsigned long *params);
+
+static inline int indirect_call_ok(unsigned int nr)
+{
+	switch (nr) {
+	case __NR_clone:
+	case __NR_fork:
+	case __NR_vfork:
+	case __NR_rt_sigsuspend:
+	case __NR_sigaltstack:
+	case __NR_iopl:
+		return 0;
+	}
+	return 1;
+}
 
 #endif  /* __ASSEMBLY__ */
 #endif	/* __KERNEL__ */
Index: linux-2.6.mod/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.mod.orig/arch/i386/kernel/entry.S	2007-06-29 12:12:42.000000000 -0700
+++ linux-2.6.mod/arch/i386/kernel/entry.S	2007-06-29 12:12:48.000000000 -0700
@@ -1023,6 +1023,24 @@
 	CFI_ENDPROC
 ENDPROC(kernel_thread_helper)
 
+ENTRY(call_syscall)
+	movl	$-ENOSYS, %eax
+	movl	4(%esp), %edx
+	cmpl	$(nr_syscalls), %edx
+	jae	bad_sysc
+	movl	8(%esp), %eax
+	pushl	20(%eax)
+	pushl	16(%eax)
+	pushl	12(%eax)
+	pushl	8(%eax)
+	pushl	4(%eax)
+	pushl	(%eax)
+	call	*sys_call_table(,%edx,4)
+	addl	$24, %esp
+bad_sysc:
+	ret
+ENDPROC(call_syscall)
+
 .section .rodata,"a"
 #include "syscall_table.S"
 
Index: linux-2.6.mod/include/asm-i386/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-i386/unistd.h	2007-06-29 12:12:42.000000000 -0700
+++ linux-2.6.mod/include/asm-i386/unistd.h	2007-06-29 12:57:58.000000000 -0700
@@ -368,5 +368,21 @@
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
 #endif
 
+extern long call_syscall(unsigned int nr, const unsigned long *params);
+
+static inline int indirect_call_ok(unsigned int nr)
+{
+	switch (nr) {
+	case __NR_clone:
+	case __NR_fork:
+	case __NR_vfork:
+	case __NR_rt_sigsuspend:
+	case __NR_sigaltstack:
+	case __NR_iopl:
+		return 0;
+	}
+	return 1;
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_I386_UNISTD_H_ */
Index: linux-2.6.mod/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6.mod.orig/arch/x86_64/kernel/entry.S	2007-06-29 12:12:42.000000000 -0700
+++ linux-2.6.mod/arch/x86_64/kernel/entry.S	2007-06-29 12:12:48.000000000 -0700
@@ -1170,3 +1170,21 @@
 	sysret
 	CFI_ENDPROC
 ENDPROC(ignore_sysret)
+
+ENTRY(call_syscall)
+	movq	$-ENOSYS, %rax
+	cmpl	$__NR_syscall_max, %edi
+	ja	bad_sysc
+	mov	%edi, %eax
+	movq	%rsi, %r11
+	movq	(%r11), %rdi
+	movq	8(%r11), %rsi
+	movq	16(%r11), %rdx
+	movq	24(%r11), %rcx
+	movq	32(%r11), %r8
+	movq	40(%r11), %r9
+	call	*sys_call_table(,%rax,8)
+bad_sysc:
+	ret
+ENDPROC(call_syscall)
+

