Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYHNTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYHNTts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYHNTtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:49:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbYHNTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:49:04 -0400
Message-Id: <20080814194900.367467310@goodmis.org>
References: <20080814194506.233473381@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Aug 2008 15:45:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 6/6] ftrace: x86 mcount stub
Content-Disposition: inline; filename=ftrace-x86-mcount-stub.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 now sets up the mcount locations through the build and no longer
needs to record the ip when the function is executed. This patch changes
the initial mcount to simply return. There's no need to do any other work.
If the ftrace start up test fails, the original mcount will be what everything
will use, so having this as fast as possible is a good thing.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/entry_32.S |   14 --------------
 arch/x86/kernel/entry_64.S |   26 --------------------------
 arch/x86/kernel/ftrace.c   |   14 ++------------
 3 files changed, 2 insertions(+), 52 deletions(-)

Index: linux-tip.git/arch/x86/kernel/entry_32.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_32.S	2008-08-14 13:55:03.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_32.S	2008-08-14 14:06:00.000000000 -0400
@@ -1189,20 +1189,6 @@ ENDPROC(xen_failsafe_callback)
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 ENTRY(mcount)
-	pushl %eax
-	pushl %ecx
-	pushl %edx
-	movl 0xc(%esp), %eax
-	subl $MCOUNT_INSN_SIZE, %eax
-
-.globl mcount_call
-mcount_call:
-	call ftrace_stub
-
-	popl %edx
-	popl %ecx
-	popl %eax
-
 	ret
 END(mcount)
 
Index: linux-tip.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_64.S	2008-08-14 13:55:03.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_64.S	2008-08-14 14:06:10.000000000 -0400
@@ -64,32 +64,6 @@
 #ifdef CONFIG_FTRACE
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
-
-	subq $0x38, %rsp
-	movq %rax, (%rsp)
-	movq %rcx, 8(%rsp)
-	movq %rdx, 16(%rsp)
-	movq %rsi, 24(%rsp)
-	movq %rdi, 32(%rsp)
-	movq %r8, 40(%rsp)
-	movq %r9, 48(%rsp)
-
-	movq 0x38(%rsp), %rdi
-	subq $MCOUNT_INSN_SIZE, %rdi
-
-.globl mcount_call
-mcount_call:
-	call ftrace_stub
-
-	movq 48(%rsp), %r9
-	movq 40(%rsp), %r8
-	movq 32(%rsp), %rdi
-	movq 24(%rsp), %rsi
-	movq 16(%rsp), %rdx
-	movq 8(%rsp), %rcx
-	movq (%rsp), %rax
-	addq $0x38, %rsp
-
 	retq
 END(mcount)
 
Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-08-14 13:55:03.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-08-14 14:18:21.000000000 -0400
@@ -112,18 +112,8 @@ notrace int ftrace_update_ftrace_func(ft
 
 notrace int ftrace_mcount_set(unsigned long *data)
 {
-	unsigned long ip = (long)(&mcount_call);
-	unsigned long *addr = data;
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
-
-	/*
-	 * Replace the mcount stub with a pointer to the
-	 * ip recorder function.
-	 */
-	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(ip, *addr);
-	*addr = ftrace_modify_code(ip, old, new);
-
+	/* mcount is initialized as a nop */
+	*data = 0;
 	return 0;
 }
 

-- 
