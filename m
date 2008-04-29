Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYD2B4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYD2B4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYD2BxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:14 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56035 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752583AbYD2BxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:03 -0400
Message-Id: <20080429015302.614225671@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:40 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 9/9] x86: thread_info: Merge thread_info allocation
Content-Disposition: inline; filename=join_thread_alloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make them similar so that both use THREAD_ORDER and THREAD_FLAGS and have a
THREAD_SIZE definition that is setup in asm/page_xx.h

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/page_32.h     |    8 ++++++++
 include/asm-x86/thread_info.h |   37 +++++++++++--------------------------
 2 files changed, 19 insertions(+), 26 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:57:48.509890170 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 18:05:32.639893442 -0700
@@ -132,6 +132,7 @@ struct thread_info {
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
+/* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
 	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
 
@@ -143,18 +144,21 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
 
-
 #define PREEMPT_ACTIVE		0x10000000
 
-#ifdef CONFIG_X86_32
-
-#ifdef CONFIG_4KSTACKS
-#define THREAD_SIZE            (4096)
+/* thread information allocation */
+#ifdef CONFIG_DEBUG_STACK_USAGE
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
 #else
-#define THREAD_SIZE		(8192)
+#define THREAD_FLAGS GFP_KERNEL
 #endif
 
-#define STACK_WARN             (THREAD_SIZE/8)
+#define alloc_thread_info(tsk)						\
+	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+
+#ifdef CONFIG_X86_32
+
+#define STACK_WARN	(THREAD_SIZE/8)
 /*
  * macros/functions for gaining access to the thread information structure
  *
@@ -173,15 +177,6 @@ static inline struct thread_info *curren
 		(current_stack_pointer & ~(THREAD_SIZE - 1));
 }
 
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) ((struct thread_info *)			\
-	__get_free_pages(GFP_KERNEL | __GFP_ZERO, get_order(THREAD_SIZE)))
-#else
-#define alloc_thread_info(tsk) ((struct thread_info *)			\
-	__get_free_pages(GFP_KERNEL, get_order(THREAD_SIZE)))
-#endif
-
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
@@ -219,16 +214,6 @@ static inline struct thread_info *stack_
 	return ti;
 }
 
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
-#else
-#define THREAD_FLAGS GFP_KERNEL
-#endif
-
-#define alloc_thread_info(tsk)						\
-	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
-
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
Index: linux-2.6/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/page_32.h	2008-04-24 22:36:10.593649417 -0700
+++ linux-2.6/include/asm-x86/page_32.h	2008-04-28 17:58:35.272390596 -0700
@@ -13,6 +13,14 @@
  */
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
+#ifdef CONFIG_4KSTACKS
+#define THREAD_ORDER	0
+#else
+#define THREAD_ORDER	1
+#endif
+#define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
+
+
 #ifdef CONFIG_X86_PAE
 #define __PHYSICAL_MASK_SHIFT	36
 #define __VIRTUAL_MASK_SHIFT	32

-- 
