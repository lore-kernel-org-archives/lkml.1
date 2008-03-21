Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYCUGWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYCUGWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYCUGT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:19:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49203 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536AbYCUGSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:55 -0400
Message-Id: <20080321061726.782068299@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:14 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [11/14] vcompound: Fallbacks for order 1 stack allocations on IA64 and x86
Content-Disposition: inline; filename=0016-vcompound-Fallbacks-for-order-2-stack-allocations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows fallback for order 1 stack allocations. In the fallback
scenario the stacks will be virtually mapped.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/asm-ia64/thread_info.h   |    5 +++--
 include/asm-x86/thread_info_32.h |    6 +++---
 include/asm-x86/thread_info_64.h |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6.25-rc5-mm1/include/asm-ia64/thread_info.h
===================================================================
--- linux-2.6.25-rc5-mm1.orig/include/asm-ia64/thread_info.h	2008-03-20 20:03:47.165885870 -0700
+++ linux-2.6.25-rc5-mm1/include/asm-ia64/thread_info.h	2008-03-20 20:04:51.302135777 -0700
@@ -82,8 +82,9 @@ struct thread_info {
 #define end_of_stack(p) (unsigned long *)((void *)(p) + IA64_RBS_OFFSET)
 
 #define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-#define alloc_task_struct()	((struct task_struct *)__get_free_pages(GFP_KERNEL | __GFP_COMP, KERNEL_STACK_SIZE_ORDER))
-#define free_task_struct(tsk)	free_pages((unsigned long) (tsk), KERNEL_STACK_SIZE_ORDER)
+#define alloc_task_struct()	((struct task_struct *)__alloc_vcompound( \
+			GFP_KERNEL, KERNEL_STACK_SIZE_ORDER))
+#define free_task_struct(tsk)	__free_vcompound(tsk)
 
 #define tsk_set_notify_resume(tsk) \
 	set_ti_thread_flag(task_thread_info(tsk), TIF_NOTIFY_RESUME)
Index: linux-2.6.25-rc5-mm1/include/asm-x86/thread_info_32.h
===================================================================
--- linux-2.6.25-rc5-mm1.orig/include/asm-x86/thread_info_32.h	2008-03-20 20:03:47.173885951 -0700
+++ linux-2.6.25-rc5-mm1/include/asm-x86/thread_info_32.h	2008-03-20 20:04:51.306136067 -0700
@@ -96,13 +96,13 @@ static inline struct thread_info *curren
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk) ((struct thread_info *) \
-	__get_free_pages(GFP_KERNEL| __GFP_ZERO, get_order(THREAD_SIZE)))
+	__alloc_vcompound(GFP_KERNEL| __GFP_ZERO, get_order(THREAD_SIZE)))
 #else
 #define alloc_thread_info(tsk) ((struct thread_info *) \
-	__get_free_pages(GFP_KERNEL, get_order(THREAD_SIZE)))
+	__alloc_vcompound(GFP_KERNEL, get_order(THREAD_SIZE)))
 #endif
 
-#define free_thread_info(info)	free_pages((unsigned long)(info), get_order(THREAD_SIZE))
+#define free_thread_info(info)	__free_vcompound(info)
 
 #else /* !__ASSEMBLY__ */
 
Index: linux-2.6.25-rc5-mm1/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6.25-rc5-mm1.orig/include/asm-x86/thread_info_64.h	2008-03-20 20:03:47.189886138 -0700
+++ linux-2.6.25-rc5-mm1/include/asm-x86/thread_info_64.h	2008-03-20 20:04:51.306136067 -0700
@@ -83,9 +83,9 @@ static inline struct thread_info *stack_
 #endif
 
 #define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+	((struct thread_info *) __alloc_vcompound(THREAD_FLAGS, THREAD_ORDER))
 
-#define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
+#define free_thread_info(ti) __free_vcompound(ti)
 
 #else /* !__ASSEMBLY__ */
 

-- 
