Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZJNG7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZJNG7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZJNG7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:59:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:41037 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbZJNG7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:59:53 -0400
Date: Wed, 14 Oct 2009 06:58:41 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091013203425.042034383@goodmis.org>
References: <20091013203425.042034383@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] function-graph/x86: Replace unbalanced ret with jmp
Message-ID: <tip-194ec34184869f0de1cf255c924fc5299e1b3d27@git.kernel.org>
Git-Commit-ID: 194ec34184869f0de1cf255c924fc5299e1b3d27
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:58:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  194ec34184869f0de1cf255c924fc5299e1b3d27
Gitweb:     http://git.kernel.org/tip/194ec34184869f0de1cf255c924fc5299e1b3d27
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 13 Oct 2009 16:33:50 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 08:13:53 +0200

function-graph/x86: Replace unbalanced ret with jmp

The function graph tracer replaces the return address with a hook
to trace the exit of the function call. This hook will finish by
returning to the real location the function should return to.

But the current implementation uses a ret to jump to the real
return location. This causes a imbalance between calls and ret.
That is the original function does a call, the ret goes to the
handler and then the handler does a ret without a matching call.

Although the function graph tracer itself still breaks the branch
predictor by replacing the original ret, by using a second ret and
causing an imbalance, it breaks the predictor even more.

This patch replaces the ret with a jmp to keep the calls and ret
balanced. I tested this on one box and it showed a 1.7% increase in
performance. Another box only showed a small 0.3% increase. But no
box that I tested this on showed a decrease in performance by
making this change.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091013203425.042034383@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
 
