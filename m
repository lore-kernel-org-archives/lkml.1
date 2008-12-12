Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYLLVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYLLVfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYLLVfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:35:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:62310 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbYLLVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UsrlIm3/x+svos+eSbDsTwzLzm22Lnii87j2xgJKwZOtYOB4vpIUf1pSXWTGzSwEhq
         S42WgHNfXD4HY5DLGxWze4ZW+VhuocH8+ufA05tOd86+Qz9qkdwSDUmHI9aI9cq1363I
         WntmyIx3Zy5QdMXmrOp0jwKgoFafWkmvmc4TQ=
Date: Sat, 13 Dec 2008 00:35:38 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081212213538.GA731@localhost>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost> <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Steven Rostedt - Fri, Dec 12, 2008 at 04:22:49PM -0500]
...
| > Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
| > ===================================================================
| > --- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
| > +++ linux-2.6.git/arch/x86/include/asm/ftrace.h
| > @@ -1,6 +1,33 @@
| >  #ifndef _ASM_X86_FTRACE_H
| >  #define _ASM_X86_FTRACE_H
| >  
| > +#ifdef __ASSEMBLY__
| 
| Why add assembly condition? We only want this if CONFIG_FUNCTION_TRACER 
| is enabled, right?  We could combine it with the current #ifndef inside 
| the CONFIG_FUNCTION_TRACER. But I would make do:
| 
| #ifdef __ASSEMBLY__
| <your stuff>
| #else
| < C stuff >
| #endif
| 
| -- Steve

Steve, here is how it could look like:
(I liked first proposal more :)

---
 arch/x86/include/asm/ftrace.h |   36 ++++++++++++++++++++++----
 arch/x86/kernel/entry_64.S    |   57 +++++-------------------------------------
 2 files changed, 37 insertions(+), 56 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
+++ linux-2.6.git/arch/x86/include/asm/ftrace.h
@@ -1,11 +1,37 @@
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
+#else /* !__ASSEMBLY__ */
+
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
-#ifndef __ASSEMBLY__
 extern void mcount(void);
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
@@ -25,13 +51,10 @@ struct dyn_arch_ftrace {
 };
 
 #endif /*  CONFIG_DYNAMIC_FTRACE */
-#endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
-#ifndef __ASSEMBLY__
-
 /*
  * Stack of return addresses for functions
  * of a thread.
@@ -46,11 +69,12 @@ struct ftrace_ret_stack {
 /*
  * Primary handler of a function return.
  * It relays on ftrace_return_to_handler.
- * Defined in entry32.S
+ * Defined in entry_32/64.S
  */
 extern void return_to_handler(void);
 
-#endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
+#endif /* !__ASSEMBLY__ */
+
 #endif /* _ASM_X86_FTRACE_H */
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
 
		- Cyrill -
