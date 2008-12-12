Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbYLLSlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbYLLSlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbYLLSlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:41:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:32609 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbYLLSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:41:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=aIEZwNxX1+FRBypuxkfrjnLyv2kFzFk7JHp77Bwk/RRE38pVyWOC4Zd/0+fk7waSLl
         Rdw7ae84UxJl7vzv9MHUeD6bcfzbEFh+9zslhFudEScCvCEldrZFdXbU6o1sFNYYXHzc
         Dd8iVFZXAJX3e8CItGuN29WYy4en4j/pHI7bg=
Date: Fri, 12 Dec 2008 21:41:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081212184136.GB14192@localhost>
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
Actually I'm not that sure about bringing new macros there
since we already have a lot so feel free to just drop it.

Maybe it would be good to comment args passed
to ftrace_call on ABI level :)

Ah, the patch is on top of -tip e3bdf48

 arch/x86/include/asm/ftrace.h |    2 -
 arch/x86/kernel/entry_64.S    |   70 +++++++++++++++---------------------------
 2 files changed, 26 insertions(+), 46 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
+++ linux-2.6.git/arch/x86/include/asm/ftrace.h
@@ -46,7 +46,7 @@ struct ftrace_ret_stack {
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
@@ -66,10 +66,7 @@ ENTRY(mcount)
 	retq
 END(mcount)
 
-ENTRY(ftrace_caller)
-	cmpl $0, function_trace_stop
-	jne  ftrace_stub
-
+	.macro FTRACE_SAVE_FRAME
 	/* taken from glibc */
 	subq $0x38, %rsp
 	movq %rax, (%rsp)
@@ -79,15 +76,9 @@ ENTRY(ftrace_caller)
 	movq %rdi, 32(%rsp)
 	movq %r8, 40(%rsp)
 	movq %r9, 48(%rsp)
+	.endm
 
-	movq 0x38(%rsp), %rdi
-	movq 8(%rbp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rdi
-
-.globl ftrace_call
-ftrace_call:
-	call ftrace_stub
-
+	.macro FTRACE_RESTORE_FRAME
 	movq 48(%rsp), %r9
 	movq 40(%rsp), %r8
 	movq 32(%rsp), %rdi
@@ -96,6 +87,23 @@ ftrace_call:
 	movq 8(%rsp), %rcx
 	movq (%rsp), %rax
 	addq $0x38, %rsp
+	.endm
+
+ENTRY(ftrace_caller)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
+	FTRACE_SAVE_FRAME
+
+	movq 0x38(%rsp), %rdi
+	movq 8(%rbp), %rsi
+	subq $MCOUNT_INSN_SIZE, %rdi
+
+.globl ftrace_call
+ftrace_call:
+	call ftrace_stub
+
+	FTRACE_RESTORE_FRAME
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 .globl ftrace_graph_call
@@ -129,15 +137,7 @@ ftrace_stub:
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
@@ -145,14 +145,7 @@ trace:
 
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
@@ -164,14 +157,7 @@ ENTRY(ftrace_graph_caller)
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
@@ -179,14 +165,8 @@ ENTRY(ftrace_graph_caller)
 
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
 
