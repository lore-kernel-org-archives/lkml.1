Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZHaXik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZHaXik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZHaXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:38:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:57109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZHaXii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:38:38 -0400
Date: Mon, 31 Aug 2009 23:38:19 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, petkovbb@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, petkovbb@gmail.com
In-Reply-To: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
References: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr: CFI annotations, cleanups for msr-reg.S
Message-ID: <tip-79c5dca3619d6ae15815eec14cd7a43db5f38b47@git.kernel.org>
Git-Commit-ID: 79c5dca3619d6ae15815eec14cd7a43db5f38b47
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 23:38:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79c5dca3619d6ae15815eec14cd7a43db5f38b47
Gitweb:     http://git.kernel.org/tip/79c5dca3619d6ae15815eec14cd7a43db5f38b47
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 31 Aug 2009 13:59:53 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 31 Aug 2009 15:14:47 -0700

x86, msr: CFI annotations, cleanups for msr-reg.S

Add CFI annotations for native_{rd,wr}msr_safe_regs().
Simplify the 64-bit implementation: we don't allow the upper half
registers to be set, and so we can use them to carry state across the
operation.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <petkovbb@gmail.com>
LKML-Reference: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>


---
 arch/x86/lib/msr-reg.S |   80 +++++++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
index 51f1bb3..9e8cdcf 100644
--- a/arch/x86/lib/msr-reg.S
+++ b/arch/x86/lib/msr-reg.S
@@ -1,5 +1,6 @@
 #include <linux/linkage.h>
 #include <linux/errno.h>
+#include <asm/dwarf2.h>
 #include <asm/asm.h>
 #include <asm/msr.h>
 
@@ -12,10 +13,11 @@
  */
 .macro op_safe_regs op:req
 ENTRY(native_\op\()_safe_regs)
-	push    %rbx
-	push    %rbp
-	push    $0              /* Return value */
-	push    %rdi
+	CFI_STARTPROC
+	pushq_cfi %rbx
+	pushq_cfi %rbp
+	movq	%rdi, %r10	/* Save pointer */
+	xorl	%r11d, %r11d	/* Return value */
 	movl    (%rdi), %eax
 	movl    4(%rdi), %ecx
 	movl    8(%rdi), %edx
@@ -23,27 +25,26 @@ ENTRY(native_\op\()_safe_regs)
 	movl    20(%rdi), %ebp
 	movl    24(%rdi), %esi
 	movl    28(%rdi), %edi
+	CFI_REMEMBER_STATE
 1:	\op
-2:	movl    %edi, %r10d
-	pop     %rdi
-	movl    %eax, (%rdi)
-	movl    %ecx, 4(%rdi)
-	movl    %edx, 8(%rdi)
-	movl    %ebx, 12(%rdi)
-	movl    %ebp, 20(%rdi)
-	movl    %esi, 24(%rdi)
-	movl    %r10d, 28(%rdi)
-	pop     %rax
-	pop     %rbp
-	pop     %rbx
+2:	movl    %eax, (%r10)
+	movl	%r11d, %eax	/* Return value */
+	movl    %ecx, 4(%r10)
+	movl    %edx, 8(%r10)
+	movl    %ebx, 12(%r10)
+	movl    %ebp, 20(%r10)
+	movl    %esi, 24(%r10)
+	movl    %edi, 28(%r10)
+	popq_cfi %rbp
+	popq_cfi %rbx
 	ret
 3:
-	movq    $-EIO, 8(%rsp)
+	CFI_RESTORE_STATE
+	movl    $-EIO, %r11d
 	jmp     2b
-	.section __ex_table,"ax"
-	.balign 4
-	.quad   1b, 3b
-	.previous
+
+	_ASM_EXTABLE(1b, 3b)
+	CFI_ENDPROC
 ENDPROC(native_\op\()_safe_regs)
 .endm
 
@@ -51,12 +52,13 @@ ENDPROC(native_\op\()_safe_regs)
 
 .macro op_safe_regs op:req
 ENTRY(native_\op\()_safe_regs)
-	push    %ebx
-	push    %ebp
-	push    %esi
-	push    %edi
-	push    $0              /* Return value */
-	push    %eax
+	CFI_STARTPROC
+	pushl_cfi %ebx
+	pushl_cfi %ebp
+	pushl_cfi %esi
+	pushl_cfi %edi
+	pushl_cfi $0              /* Return value */
+	pushl_cfi %eax
 	movl    4(%eax), %ecx
 	movl    8(%eax), %edx
 	movl    12(%eax), %ebx
@@ -64,30 +66,32 @@ ENTRY(native_\op\()_safe_regs)
 	movl    24(%eax), %esi
 	movl    28(%eax), %edi
 	movl    (%eax), %eax
+	CFI_REMEMBER_STATE
 1:	\op
-2:	push    %eax
+2:	pushl_cfi %eax
 	movl    4(%esp), %eax
-	pop     (%eax)
+	popl_cfi (%eax)
 	addl    $4, %esp
+	CFI_ADJUST_CFA_OFFSET -4
 	movl    %ecx, 4(%eax)
 	movl    %edx, 8(%eax)
 	movl    %ebx, 12(%eax)
 	movl    %ebp, 20(%eax)
 	movl    %esi, 24(%eax)
 	movl    %edi, 28(%eax)
-	pop     %eax
-	pop     %edi
-	pop     %esi
-	pop     %ebp
-	pop     %ebx
+	popl_cfi %eax
+	popl_cfi %edi
+	popl_cfi %esi
+	popl_cfi %ebp
+	popl_cfi %ebx
 	ret
 3:
+	CFI_RESTORE_STATE
 	movl    $-EIO, 4(%esp)
 	jmp     2b
-	.section __ex_table,"ax"
-	.balign 4
-	.long   1b, 3b
-	.previous
+
+	_ASM_EXTABLE(1b, 3b)
+	CFI_ENDPROC
 ENDPROC(native_\op\()_safe_regs)
 .endm
 
