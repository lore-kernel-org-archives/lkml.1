Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZCDBQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZCDBQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZCDBQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:16:31 -0500
Received: from ozlabs.org ([203.10.76.45]:49778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbZCDBQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:16:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL] Trivial macros to help cpumask conversion in linux-next: tsk_cpumask and mm_cpumask
Date: Wed, 4 Mar 2009 11:46:22 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
References: <200903031635.54296.rusty@rustcorp.com.au> <alpine.LFD.2.00.0903031411320.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903031411320.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041146.22992.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009 08:42:09 Linus Torvalds wrote:
> 
> On Tue, 3 Mar 2009, Rusty Russell wrote:
> > 
> > Rusty Russell (2):
> >       cpumask: tsk_cpumask for accessing the struct task_struct's cpus_allowed.
> >       cpumask: mm_cpumask for accessing the struct mm_struct's cpu_vm_mask.
> 
> I really want to know the _reason_ for things like this, not just a 
> trivial patch that adds a stupid macro "for the future".

Sorry, should have been more explicit.

cpumask_t -> cpumask_var_t breaks all the users (since it looks like a
pointer).  So I decided wrappers were in order while I feed the conversion
patches via all the arch maintainers & linux-next.

(In fact, we probably want to use a dangling bitmap in these cases,
rather than a double alloc for CONFIG_CPUMASK_OFFSTACK=y, tho various
places use sizeof(struct task_struct) making this a little nasty).

Not that we *really* care about the size of these structs; but it does
allow us to make 'struct cpumask' undefined for CONFIG_CPUMASK_OFFSTACK=y
so noone can accidentally create one on the stack, or use *mask1 = *mask2.

FYI, here's the final conversion patch:

cpumask: convert task_struct cpus_allowed to dangling bitmap.

Rather than use the standard [] or [0] array, I truncate the struct
when CONFIG_CPUMASK_OFFSTACK=y.  This avoids complications with
INIT_TASK and sizeof(struct task_struct).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/init_task.h |    2 +-
 include/linux/sched.h     |    7 +++++--
 kernel/fork.c             |   18 +++++++++++++++++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -136,7 +136,7 @@ extern struct cred init_cred;
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
-	.cpus_allowed	= CPU_MASK_ALL,					\
+	.cpus_allowed	= CPU_BITS_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.se		= {						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1135,7 +1135,6 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
-	cpumask_t cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
@@ -1400,10 +1399,14 @@ struct task_struct {
 	/* state flags for use by tracers */
 	unsigned long trace;
 #endif
+
+	/* This has to go at the end: if CONFIG_CPUMASK_OFFSTACK=y, only
+	 * nr_cpu_ids bits will actually be allocated. */
+	DECLARE_BITMAP(cpus_allowed, CONFIG_NR_CPUS);
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
-#define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
+#define tsk_cpumask(tsk) (to_cpumask((tsk)->cpus_allowed))
 
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -173,9 +173,25 @@ void __init fork_init(unsigned long memp
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
 #endif
+	unsigned int task_size;
+
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	/*
+	 * Restrict task_struct allocations so cpus_allowed is only
+	 * nr_cpu_ids long.  cpus_allowed must be a NR_CPUS bitmap at
+	 * end for this to work.
+	 */
+	BUILD_BUG_ON(offsetof(struct task_struct, cpus_allowed)
+		     + BITS_TO_LONGS(CONFIG_NR_CPUS)*sizeof(long)
+		     != sizeof(struct task_struct));
+	task_size = offsetof(struct task_struct, cpus_allowed) +
+		BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
+#else
+	task_size = sizeof(struct task_struct);
+#endif
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep =
-		kmem_cache_create("task_struct", sizeof(struct task_struct),
+		kmem_cache_create("task_struct", task_size,
 			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
 #endif
 
