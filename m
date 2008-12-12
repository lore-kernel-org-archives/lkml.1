Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYLLVJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYLLVJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYLLVJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:09:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:3864 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYLLVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PT3Iwofl+pwVysetro9YZhtfzzXS7AXnDTwD1leloGPktVpwplkTBcvVyc0R80VexG
         fWAZqpQcQ3yau2xzMbMIp/cbLNUXiW4riZVYZmVz9N1q3gq2mXGWP4aNoUxtIKtLmUM8
         xlnaTDHPfShqbwyt+jyaGnHjHFOGX6AAQl638=
Date: Sat, 13 Dec 2008 00:09:08 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] x86: entry_64 - introduce FTRACE_ frame macro v2
Message-ID: <20081212210908.GA30557@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: clean up

Itroduce FTRACE_SAVE/RESTORE_FRAME which allow us to
save a number of lines on source level.

Also fix a comment in ftrace.h.
---

Didn't add Steve's Ack since it's a new version

 arch/x86/include/asm/ftrace.h |   29 ++++++++++++++++++++-
 arch/x86/kernel/entry_64.S    |   57 +++++-------------------------------------
 2 files changed, 35 insertions(+), 51 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
+++ linux-2.6.git/arch/x86/include/asm/ftrace.h
@@ -1,6 +1,33 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
+#ifdef __ASSEMBLY__
+
+	.macro FTRACE_SAVE_FRAME
+	/* taken from glibc */
+	subq $0x38, %rsp
+	movq %rax, (%rsp)
+	movq %rcx, 8(%rsp)
+	movq %rdx, 16(%rsp)
+	movq %rsi, 24(%rsp)
+	movq %rdi, 32(%rsp)
+	movq %r8, 40(%rsp)
+	movq %r9, 48(%rsp)
+	.endm
+
+	.macro FTRACE_RESTORE_FRAME
+	movq 48(%rsp), %r9
+	movq 40(%rsp), %r8
+	movq 32(%rsp), %rdi
+	movq 24(%rsp), %rsi
+	movq 16(%rsp), %rdx
+	movq 8(%rsp), %rcx
+	movq (%rsp), %rax
+	addq $0x38, %rsp
+	.endm
+
+#endif
+
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
@@ -46,7 +73,7 @@ struct ftrace_ret_stack {
 /*
  * Primary handler of a function return.
  * It relays on ftrace_return_to_handler.
- * Defined in entry32.S
+ * Defined in entry_32/64.S
  */
 extern void return_to_handler(void);
 
Index: linux-2.6.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6.git/arch/x86/kernel/entry_64.S
@@ -70,15 +70,7 @@ ENTRY(ftrace_caller)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
-	/* taken from glibc */
-	subq $0x38, %rsp
-	movq %rax, (%rsp)
-	movq %rcx, 8(%rsp)
-	movq %rdx, 16(%rsp)
-	movq %rsi, 24(%rsp)
-	movq %rdi, 32(%rsp)
-	movq %r8, 40(%rsp)
-	movq %r9, 48(%rsp)
+	FTRACE_SAVE_FRAME
 
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
@@ -88,14 +80,7 @@ ENTRY(ftrace_caller)
 ftrace_call:
 	call ftrace_stub
 
-	movq 48(%rsp), %r9
-	movq 40(%rsp), %r8
-	movq 32(%rsp), %rdi
-	movq 24(%rsp), %rsi
-	movq 16(%rsp), %rdx
-	movq 8(%rsp), %rcx
-	movq (%rsp), %rax
-	addq $0x38, %rsp
+	FTRACE_RESTORE_FRAME
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 .globl ftrace_graph_call
@@ -129,15 +114,7 @@ ftrace_stub:
 	retq
 
 trace:
-	/* taken from glibc */
-	subq $0x38, %rsp
-	movq %rax, (%rsp)
-	movq %rcx, 8(%rsp)
-	movq %rdx, 16(%rsp)
-	movq %rsi, 24(%rsp)
-	movq %rdi, 32(%rsp)
-	movq %r8, 40(%rsp)
-	movq %r9, 48(%rsp)
+	FTRACE_SAVE_FRAME
 
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
@@ -145,14 +122,7 @@ trace:
 
 	call   *ftrace_trace_function
 
-	movq 48(%rsp), %r9
-	movq 40(%rsp), %r8
-	movq 32(%rsp), %rdi
-	movq 24(%rsp), %rsi
-	movq 16(%rsp), %rdx
-	movq 8(%rsp), %rcx
-	movq (%rsp), %rax
-	addq $0x38, %rsp
+	FTRACE_RESTORE_FRAME
 
 	jmp ftrace_stub
 END(mcount)
@@ -164,14 +134,7 @@ ENTRY(ftrace_graph_caller)
 	cmpl $0, function_trace_stop
 	jne ftrace_stub
 
-	subq $0x38, %rsp
-	movq %rax, (%rsp)
-	movq %rcx, 8(%rsp)
-	movq %rdx, 16(%rsp)
-	movq %rsi, 24(%rsp)
-	movq %rdi, 32(%rsp)
-	movq %r8, 40(%rsp)
-	movq %r9, 48(%rsp)
+	FTRACE_SAVE_FRAME
 
 	leaq 8(%rbp), %rdi
 	movq 0x38(%rsp), %rsi
@@ -179,14 +142,8 @@ ENTRY(ftrace_graph_caller)
 
 	call	prepare_ftrace_return
 
-	movq 48(%rsp), %r9
-	movq 40(%rsp), %r8
-	movq 32(%rsp), %rdi
-	movq 24(%rsp), %rsi
-	movq 16(%rsp), %rdx
-	movq 8(%rsp), %rcx
-	movq (%rsp), %rax
-	addq $0x38, %rsp
+	FTRACE_RESTORE_FRAME
+
 	retq
 END(ftrace_graph_caller)
 
