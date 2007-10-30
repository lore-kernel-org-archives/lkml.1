Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXJ3QZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXJ3QZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbXJ3QQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:16:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbXJ3QNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:13:39 -0400
Message-Id: <20071030160911.540148000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/33] mm: allow PF_MEMALLOC from softirq context
Content-Disposition: inline; filename=mm-PF_MEMALLOC-softirq.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow PF_MEMALLOC to be set in softirq context. When running softirqs from
a borrowed context save current->flags, ksoftirqd will have its own 
task_struct.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    4 ++++
 kernel/softirq.c      |    3 +++
 mm/page_alloc.c       |    7 ++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -1557,9 +1557,10 @@ int gfp_to_alloc_flags(gfp_t gfp_mask)
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
-		if (!in_interrupt() &&
-		    ((p->flags & PF_MEMALLOC) ||
-		     unlikely(test_thread_flag(TIF_MEMDIE))))
+		if (!in_irq() && (p->flags & PF_MEMALLOC))
+			alloc_flags |= ALLOC_NO_WATERMARKS;
+		else if (!in_interrupt() &&
+				unlikely(test_thread_flag(TIF_MEMDIE)))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
 
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -211,6 +211,8 @@ asmlinkage void __do_softirq(void)
 	__u32 pending;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	int cpu;
+	unsigned long pflags = current->flags;
+	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
 	account_system_vtime(current);
@@ -249,6 +251,7 @@ restart:
 
 	account_system_vtime(current);
 	_local_bh_enable();
+	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 }
 
 #ifndef __ARCH_HAS_DO_SOFTIRQ
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1389,6 +1389,10 @@ static inline void put_task_struct(struc
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
+#define tsk_restore_flags(p, pflags, mask) \
+	do {	(p)->flags &= ~(mask); \
+		(p)->flags |= ((pflags) & (mask)); } while (0)
+
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask);
 #else

--

