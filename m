Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZA1Ebx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZA1Ebx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZA1Ebo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:31:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:55433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZA1Ebo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:31:44 -0500
Message-ID: <497FDFA7.8080402@kernel.org>
Date: Wed, 28 Jan 2009 13:31:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 x86#stackprotector] x86: conditionalize stack canary handling
 in hot path
References: <497FDF7C.8080706@kernel.org>
In-Reply-To: <497FDF7C.8080706@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 04:31:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: no unnecessary stack canary swapping during context switch

There's no point in moving stack_canary around during context switch
if it's not enabled.  Conditionalize it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Ditto as the previous one.

 arch/x86/include/asm/system.h |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 8cadfe9..b77bd8b 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -86,17 +86,28 @@ do {									\
 	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
 	  "r12", "r13", "r14", "r15"
 
+#ifdef CONFIG_CC_STACKPROTECTOR
+#define __switch_canary							  \
+	"movq %P[task_canary](%%rsi),%%r8\n\t"				  \
+	"movq %%r8,%%gs:%P[pda_canary]\n\t"
+#define __switch_canary_param						  \
+	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))  \
+	, [pda_canary] "i" (offsetof(struct x8664_pda, stack_canary))
+#else	/* CC_STACKPROTECTOR */
+#define __switch_canary
+#define __switch_canary_param
+#endif	/* CC_STACKPROTECTOR */
+
 /* Save restore flags to clear handle leaking NT */
 #define switch_to(prev, next, last) \
-	asm volatile(SAVE_CONTEXT						    \
+	asm volatile(SAVE_CONTEXT					  \
 	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
 	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
 	     "call __switch_to\n\t"					  \
 	     ".globl thread_return\n"					  \
 	     "thread_return:\n\t"					  \
 	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
-	     "movq %P[task_canary](%%rsi),%%r8\n\t"			  \
-	     "movq %%r8,%%gs:%P[pda_canary]\n\t"			  \
+	     __switch_canary						  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
 	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
@@ -108,9 +119,8 @@ do {									\
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
 	       [tif_fork] "i" (TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
-	       [task_canary] "i" (offsetof(struct task_struct, stack_canary)),\
-	       [current_task] "m" (per_cpu_var(current_task)),		  \
-	       [pda_canary] "i" (offsetof(struct x8664_pda, stack_canary))\
+	       [current_task] "m" (per_cpu_var(current_task))		  \
+	       __switch_canary_param					  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
-- 
1.6.0.2

