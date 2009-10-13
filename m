Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbZJMVWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbZJMVWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761369AbZJMVWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:22:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbZJMVWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:22:16 -0400
Message-Id: <20091013212018.685721258@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 17:19:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 1/4] [PATCH 1/4] function-graph/x86: replace unbalanced ret with jmp
References: <20091013211934.941504044@goodmis.org>
Content-Disposition: inline; filename=0001-function-graph-x86-replace-unbalanced-ret-with-jmp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function graph tracer replaces the return address with a hook to
trace the exit of the function call. This hook will finish by returning
to the real location the function should return to.

But the current implementation uses a ret to jump to the real return
location. This causes a imbalance between calls and ret. That is
the original function does a call, the ret goes to the handler
and then the handler does a ret without a matching call.

Although the function graph tracer itself still breaks the branch
predictor by replacing the original ret, by using a second ret and
causing an imbalance, it breaks the predictor even more.

This patch replaces the ret with a jmp to keep the calls and ret
balanced. I tested this on one box and it showed a 1.7% increase in
performance. Another box only showed a small 0.3% increase. But no
box that I tested this on showed a decrease in performance by making this
change.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    7 ++-----
 arch/x86/kernel/entry_64.S |    6 +++---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c097e7d..7d52e9d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1185,17 +1185,14 @@ END(ftrace_graph_caller)
 
 .globl return_to_handler
 return_to_handler:
-	pushl $0
 	pushl %eax
-	pushl %ecx
 	pushl %edx
 	movl %ebp, %eax
 	call ftrace_return_to_handler
-	movl %eax, 0xc(%esp)
+	movl %eax, %ecx
 	popl %edx
-	popl %ecx
 	popl %eax
-	ret
+	jmp *%ecx
 #endif
 
 .section .rodata,"a"
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b5c061f..bd5bbdd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -155,11 +155,11 @@ GLOBAL(return_to_handler)
 
 	call ftrace_return_to_handler
 
-	movq %rax, 16(%rsp)
+	movq %rax, %rdi
 	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
-	addq $16, %rsp
-	retq
+	addq $24, %rsp
+	jmp *%rdi
 #endif
 
 
-- 
1.6.3.3


