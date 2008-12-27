Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYL0FUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYL0FUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYL0FTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:19:54 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:42421 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYL0FTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:19:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zu7OstTsjYgrl3B0DiEAAnhVKNPZhLvmPMgEQWvgJNJew5CSO0Z9TAC8hmlPwGeLI8
         wL2UthJMh+rJRWuL0bazmGnr5VdvDvlaiLVfIT9sKXgG/pfqVZQOZV4h+rl2PVX5wm4s
         R/DkBkzESCmH2gmEYXmdi2VedtX2FyXS5Cpas=
Date: Sat, 27 Dec 2008 14:19:45 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/4] x86: use generic thread_info allocator
Message-ID: <20081227051943.GE3295@localhost.localdomain>
References: <20081227051606.GA3295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20081227051606.GA3295@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic thread_info allocator for x86.
Because thread_info allocator for x86 and generic one are same now.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/include/asm/page_32.h     |    6 +++---
 arch/x86/include/asm/page_64.h     |    4 ++--
 arch/x86/include/asm/thread_info.h |   13 -------------
 arch/x86/kernel/process.c          |    5 -----
 4 files changed, 5 insertions(+), 23 deletions(-)

Index: 2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- 2.6.orig/arch/x86/include/asm/thread_info.h
+++ 2.6/arch/x86/include/asm/thread_info.h
@@ -147,18 +147,6 @@ struct thread_info {
 
 #define PREEMPT_ACTIVE		0x10000000
 
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define THREAD_FLAGS (GFP_KERNEL | __GFP_ZERO)
-#else
-#define THREAD_FLAGS GFP_KERNEL
-#endif
-
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-#define alloc_thread_info(tsk)						\
-	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
-
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
@@ -257,7 +245,6 @@ static inline void set_restore_sigmask(v
 
 #ifndef __ASSEMBLY__
 extern void arch_task_cache_init(void);
-extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 #define arch_task_cache_init arch_task_cache_init
 
Index: 2.6/arch/x86/kernel/process.c
===================================================================
--- 2.6.orig/arch/x86/kernel/process.c
+++ 2.6/arch/x86/kernel/process.c
@@ -38,11 +38,6 @@ void free_thread_xstate(struct task_stru
 	}
 }
 
-void free_thread_info(struct thread_info *ti)
-{
-	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
-}
-
 static struct kmem_cache *task_struct_cachep;
 
 struct task_struct *alloc_task_struct(void)
Index: 2.6/arch/x86/include/asm/page_32.h
===================================================================
--- 2.6.orig/arch/x86/include/asm/page_32.h
+++ 2.6/arch/x86/include/asm/page_32.h
@@ -14,11 +14,11 @@
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
 #ifdef CONFIG_4KSTACKS
-#define THREAD_ORDER	0
+#define THREAD_SIZE_ORDER	0
 #else
-#define THREAD_ORDER	1
+#define THREAD_SIZE_ORDER	1
 #endif
-#define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE 	(PAGE_SIZE << THREAD_SIZE_ORDER)
 
 #define STACKFAULT_STACK 0
 #define DOUBLEFAULT_STACK 1
Index: 2.6/arch/x86/include/asm/page_64.h
===================================================================
--- 2.6.orig/arch/x86/include/asm/page_64.h
+++ 2.6/arch/x86/include/asm/page_64.h
@@ -3,8 +3,8 @@
 
 #define PAGETABLE_LEVELS	4
 
-#define THREAD_ORDER	1
-#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
+#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
 #define EXCEPTION_STACK_ORDER 0
