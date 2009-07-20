Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZGTKKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZGTKKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZGTKKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:10:09 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59260 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbZGTKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:10:07 -0400
Subject: Re: [RFC PATCH] kmemleak: Scan all thread stacks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1247850069.6522.91.camel@laptop>
References: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com>
	 <20090717164346.GC5131@elte.hu>
	 <1247849826.6313.64.camel@pc1117.cambridge.arm.com>
	 <1247850069.6522.91.camel@laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 20 Jul 2009 11:09:50 +0100
Message-Id: <1248084591.21585.25.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jul 2009 10:09:51.0925 (UTC) FILETIME=[38C1E650:01CA0922]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 19:01 +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-17 at 17:57 +0100, Catalin Marinas wrote:
> > On Fri, 2009-07-17 at 18:43 +0200, Ingo Molnar wrote:
> > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > 2. Is it safe to use rcu_read_lock() and task_lock() when scanning the
> > > >    corresponding kernel stack (thread_info structure)? The loop doesn't
> > > >    do any modification to the task list. The reason for this is to
> > > >    allow kernel preemption when scanning the stacks.
> > > 
> > > you cannot generally preempt while holding the RCU read-lock.
> > 
> > This may work with rcupreempt enabled. But, with classic RCU is it safe
> > to call schedule (or cond_resched) while holding the RCU read-lock?
> 
> No.

Thanks for the clarification. So, to really make a difference in
latency, task stack scanning in kmemleak doesn't need to be explicit.
The patch below would be required:


kmemleak: Inform kmemleak about kernel stack allocation

From: Catalin Marinas <catalin.marinas@arm.com>

Traversing all the tasks in the system for scanning the kernel stacks
requires locking which increases the kernel latency considerably. This
patch informs kmemleak about newly allocated or freed stacks so that
they are treated as any other allocated object. Subsequent patch will
remove the explicit stack scanning from mm/kmemleak.c.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/x86/include/asm/thread_info.h |    7 ++++++-
 arch/x86/kernel/process.c          |    1 +
 kernel/fork.c                      |    7 ++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..f26432a 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -162,7 +162,12 @@ struct thread_info {
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
 #define alloc_thread_info(tsk)						\
-	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+({									\
+	struct thread_info *ti = (struct thread_info *)			\
+		__get_free_pages(THREAD_FLAGS, THREAD_ORDER);		\
+	kmemleak_alloc(ti, THREAD_SIZE, 1, THREAD_FLAGS);		\
+	ti;								\
+})
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 994dd6a..ac43992 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -55,6 +55,7 @@ void free_thread_xstate(struct task_struct *tsk)
 void free_thread_info(struct thread_info *ti)
 {
 	free_thread_xstate(ti->task);
+	kmemleak_free(ti);
 	free_pages((unsigned long)ti, get_order(THREAD_SIZE));
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index bd29592..31a4e77 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -62,6 +62,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_counter.h>
+#include <linux/kmemleak.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -104,16 +105,20 @@ static struct kmem_cache *task_struct_cachep;
 #ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 static inline struct thread_info *alloc_thread_info(struct task_struct *tsk)
 {
+	struct thread_info *ti;
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
 #else
 	gfp_t mask = GFP_KERNEL;
 #endif
-	return (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+	ti = (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+	kmemleak_alloc(ti, THREAD_SIZE, 1, mask);
+	return ti;
 }
 
 static inline void free_thread_info(struct thread_info *ti)
 {
+	kmemleak_free(ti);
 	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 #endif

-- 
Catalin

