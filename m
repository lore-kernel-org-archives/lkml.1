Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXF2VvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXF2VvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbXF2Vtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:49:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2548 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbXF2Vtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:49:46 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Jun 2007 14:48:52 -0700
Subject: [patch 4/6] sys_indirect RFC - compat code for sys_indirect and compat_call_syscall for x86-64
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28360.1183153737.4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the compat code necessary for sys_indirect(). Since the data
structure passed down to sys_indirect() is compat-free, this is the
only processing needed.
A required compat_call_syscall() has been added to the x86-64 arch.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



---
 arch/x86_64/ia32/ia32entry.S |   18 +++++++++++++++++
 include/asm-x86_64/unistd.h  |    1 
 kernel/compat.c              |   44 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

Index: linux-2.6.mod/kernel/compat.c
===================================================================
--- linux-2.6.mod.orig/kernel/compat.c	2007-06-29 12:12:41.000000000 -0700
+++ linux-2.6.mod/kernel/compat.c	2007-06-29 12:13:46.000000000 -0700
@@ -23,6 +23,8 @@
 #include <linux/timex.h>
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
+#include <linux/fsalloc.h>
+#include <linux/indirect.h>
 
 #include <asm/uaccess.h>
 
@@ -1082,3 +1084,45 @@
 	return 0;
 }
 
+asmlinkage long compat_sys_indirect(unsigned int nr,
+				    const __u32 __user *ctxs, unsigned int nctxs,
+				    const __u32 __user *params)
+{
+	unsigned int i;
+	long res;
+	u32 tmp;
+	struct indirect_op *iops;
+	const struct indirect_ctx __user * __user *uctxs;
+	unsigned long kparams[6];
+	struct fsa_context ator;
+	char ator_cache[128];
+
+	if (!indirect_call_ok(nr) || nctxs >= INT_MAX / sizeof(__u32))
+		return -EINVAL;
+	if (!access_ok(VERIFY_READ, params, 6 * sizeof(u32)) ||
+	    !access_ok(VERIFY_READ, ctxs, nctxs * sizeof(u32)))
+		return -EFAULT;
+	uctxs = compat_alloc_user_space(nctxs * sizeof(void *));
+	for (i = 0, res = 0; !res && i < nctxs; i++) {
+		res |= __get_user(tmp, &ctxs[i]);
+		res |= __put_user((unsigned long) tmp, &uctxs[i]);
+	}
+	if (res)
+		return -EFAULT;
+	for (i = 0, res = 0; i < 6; i++) {
+		res |= __get_user(tmp, &params[i]);
+		kparams[i] = tmp;
+	}
+	if (res)
+		return -EFAULT;
+	fsa_init(&ator, ator_cache, sizeof(ator_cache));
+	res = indirect_set_context(&ator, uctxs, nctxs, &iops);
+	if (likely(res == 0)) {
+		res = compat_call_syscall(nr, kparams);
+		indirect_unset_context(iops);
+	}
+	fsa_cleanup(&ator);
+
+	return res;
+}
+
Index: linux-2.6.mod/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86_64/unistd.h	2007-06-29 12:12:48.000000000 -0700
+++ linux-2.6.mod/include/asm-x86_64/unistd.h	2007-06-29 12:57:58.000000000 -0700
@@ -670,6 +670,7 @@
 				struct sigaction __user *oact,
 				size_t sigsetsize);
 extern long call_syscall(unsigned int nr, const unsigned long *params);
+extern long compat_call_syscall(unsigned int nr, const unsigned long *params);
 
 static inline int indirect_call_ok(unsigned int nr)
 {
Index: linux-2.6.mod/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.mod.orig/arch/x86_64/ia32/ia32entry.S	2007-06-29 12:12:41.000000000 -0700
+++ linux-2.6.mod/arch/x86_64/ia32/ia32entry.S	2007-06-29 12:57:58.000000000 -0700
@@ -392,6 +392,24 @@
 	CFI_ENDPROC
 END(ia32_ptregs_common)
 
+ENTRY(compat_call_syscall)
+	movq	$-ENOSYS, %rax
+	cmpl	$(IA32_NR_syscalls-1), %edi
+	ja	bad_sysc
+	mov	%edi, %eax
+	movq	%rsi, %r11
+	movq	(%r11), %rdi
+	movq	8(%r11), %rsi
+	movq	16(%r11), %rdx
+	movq	24(%r11), %rcx
+	movq	32(%r11), %r8
+	movq	40(%r11), %r9
+	call	*ia32_sys_call_table(,%rax,8)
+bad_sysc:
+	ret
+ENDPROC(compat_call_syscall)
+
+
 	.section .rodata,"a"
 	.align 8
 ia32_sys_call_table:

