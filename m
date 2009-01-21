Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZAUIqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZAUIqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbZAUIqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:38063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbZAUIqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:30 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] x86: update canary handling during switch
Date: Wed, 21 Jan 2009 17:46:09 +0900
Message-Id: <1232527578-1960-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

In switch_to(), instead of taking offset to irq_stack_union.stack,
make it a proper percpu access using __percpu_arg() and per_cpu_var().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/system.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 52eb748..2fcc70b 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -89,13 +89,15 @@ do {									\
 #ifdef CONFIG_CC_STACKPROTECTOR
 #define __switch_canary							  \
 	"movq %P[task_canary](%%rsi),%%r8\n\t"				  \
-	"movq %%r8,%%gs:%P[gs_canary]\n\t"
-#define __switch_canary_param						  \
-	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))  \
-	, [gs_canary] "i" (offsetof(union irq_stack_union, stack_canary))
+	"movq %%r8,"__percpu_arg([gs_canary])"\n\t"
+#define __switch_canary_oparam						  \
+	, [gs_canary] "=m" (per_cpu_var(irq_stack_union.stack_canary))
+#define __switch_canary_iparam						  \
+	, [task_canary] "i" (offsetof(struct task_struct, stack_canary))
 #else	/* CC_STACKPROTECTOR */
 #define __switch_canary
-#define __switch_canary_param
+#define __switch_canary_oparam
+#define __switch_canary_iparam
 #endif	/* CC_STACKPROTECTOR */
 
 /* Save restore flags to clear handle leaking NT */
@@ -114,13 +116,14 @@ do {									\
 	     "jc   ret_from_fork\n\t"					  \
 	     RESTORE_CONTEXT						  \
 	     : "=a" (last)					  	  \
+	       __switch_canary_oparam					  \
 	     : [next] "S" (next), [prev] "D" (prev),			  \
 	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
 	       [tif_fork] "i" (TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
 	       [current_task] "m" (per_cpu_var(current_task))		  \
-	       __switch_canary_param					  \
+	       __switch_canary_iparam					  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
 #endif
 
-- 
1.6.0.2

