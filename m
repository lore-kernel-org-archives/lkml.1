Return-Path: <linux-kernel-owner+w=401wt.eu-S1751588AbXA3Vjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbXA3Vjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbXA3Vjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:39:49 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:46903 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXA3Vjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:39:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 4] Introduce i386 fibril scheduling
X-Mercurial-Node: df7bc026d50ec5bbdd8e272c29891aa01e2fd91b
Message-Id: <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
In-Reply-To: <patchbomb.1170193181@tetsuo.zabbo.net>
Date: Tue, 30 Jan 2007 13:39:43 -0700
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the notion of a 'fibril'.  It's meant to be a lighter
kernel thread.  There can be multiple of them in the process of executing for a
given task_struct, but only one can every be actively running at a time.  Think
of it as a stack and some metadata for scheduling them inside the task_stuct.

This implementation is wildly architecture-specific but isn't put in the right
places.  Since these are not code paths that I have extensive experience with,
I focused more on on getting it going and representative of the concept than on
making it right on the first try.  I'm actively interested in feedback from
people who know more about the places this touches.

The fibril struct itself is left stand-alone for clarity.  There is a 1:1
relationship between fibrils and struct thread_info, though, so it might make
more sense to embed the two somehow.

The use of list_head for the run queue is simplistic.  As long as we're not
removing specific fibrils from the list, which seems unlikely, we be more
clever.  Maybe no more clever than a singly-linked list, though.

Fibril management is under the runqueue lock because that ends up working well
for the wake-up path as well.  In the current patch, though, it makes for some
pretty sloppy code for unlocking the runqueue lock (and re-enabling interrupts
and pre-emption) on the other side of the switch.

The actual mechanics of switching from one stack to another at the end of
schedule_fibril() makes me nervous.  I'm not convinced that blindly copying the
contents of thread_info from the previous to the next stack is safe, even if
done with interrupts disabled.  (NMIs?)  The juggling of current->thread_info
might be racy, etc.

diff -r 26e278468209 -r df7bc026d50e arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c	Mon Jan 29 15:36:13 2007 -0800
+++ b/arch/i386/kernel/process.c	Mon Jan 29 15:36:16 2007 -0800
@@ -698,6 +698,28 @@ struct task_struct fastcall * __switch_t
 	return prev_p;
 }
 
+/*
+ * We've just switched the stack and instruction pointer to point to a new
+ * fibril.  We were called from schedule() -> schedule_fibril() with the
+ * runqueue lock held _irq and with preemption disabled.
+ *
+ * We let finish_fibril_switch() unwind the state that was built up by
+ * our callers.  We do that here so that we don't need to ask fibrils to
+ * first execute something analagous to schedule_tail(). Maybe that's
+ * wrong.
+ *
+ * We'd also have to reacquire the kernel lock here.  For now we know the
+ * BUG_ON(lock_depth) prevents us from having to worry about it.
+ */
+void fastcall __switch_to_fibril(struct thread_info *ti)
+{
+	finish_fibril_switch();
+
+	/* free the ti if schedule_fibril() told us that it's done */
+	if (ti->status & TS_FREE_AFTER_SWITCH)
+		free_thread_info(ti);
+}
+
 asmlinkage int sys_fork(struct pt_regs regs)
 {
 	return do_fork(SIGCHLD, regs.esp, &regs, 0, NULL, NULL);
diff -r 26e278468209 -r df7bc026d50e include/asm-i386/system.h
--- a/include/asm-i386/system.h	Mon Jan 29 15:36:13 2007 -0800
+++ b/include/asm-i386/system.h	Mon Jan 29 15:36:16 2007 -0800
@@ -31,6 +31,31 @@ extern struct task_struct * FASTCALL(__s
 		      "=a" (last),"=S" (esi),"=D" (edi)			\
 		     :"m" (next->thread.esp),"m" (next->thread.eip),	\
 		      "2" (prev), "d" (next));				\
+} while (0)
+
+struct thread_info;
+void fastcall __switch_to_fibril(struct thread_info *ti);
+
+/*
+ * This is called with the run queue lock held _irq and with preemption
+ * disabled.  __switch_to_fibril drops those.
+ */
+#define switch_to_fibril(prev, next, ti) do {				\
+	unsigned long esi,edi;						\
+	asm volatile("pushfl\n\t"		/* Save flags */	\
+		     "pushl %%ebp\n\t"					\
+		     "movl %%esp,%0\n\t"	/* save ESP */		\
+		     "movl %4,%%esp\n\t"	/* restore ESP */	\
+		     "movl $1f,%1\n\t"		/* save EIP */		\
+		     "pushl %5\n\t"		/* restore EIP */	\
+		     "jmp __switch_to_fibril\n"				\
+		     "1:\t"						\
+		     "popl %%ebp\n\t"					\
+		     "popfl"						\
+		     :"=m" (prev->esp),"=m" (prev->eip),		\
+		      "=S" (esi),"=D" (edi)				\
+		     :"m" (next->esp),"m" (next->eip),			\
+		      "d" (prev), "a" (ti));				\
 } while (0)
 
 #define _set_base(addr,base) do { unsigned long __pr; \
diff -r 26e278468209 -r df7bc026d50e include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h	Mon Jan 29 15:36:13 2007 -0800
+++ b/include/asm-i386/thread_info.h	Mon Jan 29 15:36:16 2007 -0800
@@ -91,6 +91,12 @@ static inline struct thread_info *curren
 static inline struct thread_info *current_thread_info(void)
 {
 	return (struct thread_info *)(current_stack_pointer & ~(THREAD_SIZE - 1));
+}
+
+/* XXX perhaps should be integrated with task_pt_regs(task) */
+static inline struct pt_regs *thread_info_pt_regs(struct thread_info *info)
+{
+	return (struct pt_regs *)(KSTK_TOP(info)-8) - 1;
 }
 
 /* thread information allocation */
@@ -169,6 +175,7 @@ static inline struct thread_info *curren
  */
 #define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
 #define TS_POLLING		0x0002	/* True if in idle loop and not sleeping */
+#define TS_FREE_AFTER_SWITCH	0x0004	/* free ti in __switch_to_fibril() */
 
 #define tsk_is_polling(t) ((t)->thread_info->status & TS_POLLING)
 
diff -r 26e278468209 -r df7bc026d50e include/linux/init_task.h
--- a/include/linux/init_task.h	Mon Jan 29 15:36:13 2007 -0800
+++ b/include/linux/init_task.h	Mon Jan 29 15:36:16 2007 -0800
@@ -111,6 +111,8 @@ extern struct group_info init_groups;
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
+	.fibril		= NULL,						\
+	.runnable_fibrils = LIST_HEAD_INIT(tsk.runnable_fibrils),	\
 	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
 	.ioprio		= 0,						\
 	.time_slice	= HZ,						\
diff -r 26e278468209 -r df7bc026d50e include/linux/sched.h
--- a/include/linux/sched.h	Mon Jan 29 15:36:13 2007 -0800
+++ b/include/linux/sched.h	Mon Jan 29 15:36:16 2007 -0800
@@ -812,6 +812,38 @@ enum sleep_type {
 
 struct prio_array;
 
+/*
+ * A 'fibril' is a very small fiber.  It's used here to mean a small thread.
+ *
+ * (Chosing a weird new name avoided yet more overloading of 'task', 'call',
+ * 'thread', 'stack', 'fib{er,re}', etc).
+ *
+ * This structure is used by the schduler to track multiple executing stacks
+ * inside a task_struct.
+ *
+ * Only one fibril executes for a given task_struct at a time.  When it
+ * blocks, however, another fibril has the chance to execute while it sleeps.
+ * This means that call chains executing in fibrils can see concurrent
+ * current-> accesses at blocking points.  "per_call_chain()" members are
+ * switched along with the fibril, so they remain local.  Preemption *will not*
+ * trigger a fibril switch.
+ *
+ * XXX
+ *  - arch specific
+ */
+struct fibril {
+	struct list_head		run_list;
+	/* -1 unrunnable, 0 runnable, >0 stopped */
+	long				state;
+	unsigned long			eip;
+	unsigned long			esp;
+	struct thread_info		*ti;
+	struct per_call_chain_storage	per_call;
+};
+
+void sched_new_runnable_fibril(struct fibril *fibril);
+void finish_fibril_switch(void);
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	struct thread_info *thread_info;
@@ -857,6 +889,20 @@ struct task_struct {
 	struct list_head ptrace_list;
 
 	struct mm_struct *mm, *active_mm;
+
+	/*
+	 * The scheduler uses this to determine if the current call is a
+	 * stand-alone task or a fibril.  If it's a fibril then wake-ups
+	 * will target the fibril and a schedule() might result in swapping
+	 * in another runnable fibril.  So to start executing fibrils at all
+	 * one allocates a fibril to represent the running task and then
+	 * puts initialized runnable fibrils in the run list.
+	 *
+	 * The state members of the fibril and runnable_fibrils list are
+	 * managed under the task's run queue lock.
+	 */
+	struct fibril *fibril;
+	struct list_head runnable_fibrils;
 
 /* task state */
 	struct linux_binfmt *binfmt;
diff -r 26e278468209 -r df7bc026d50e kernel/exit.c
--- a/kernel/exit.c	Mon Jan 29 15:36:13 2007 -0800
+++ b/kernel/exit.c	Mon Jan 29 15:36:16 2007 -0800
@@ -854,6 +854,13 @@ fastcall NORET_TYPE void do_exit(long co
 {
 	struct task_struct *tsk = current;
 	int group_dead;
+
+	/* 
+	 * XXX this is just a debug helper, this should be waiting for all
+	 * fibrils to return.  Possibly after sending them lots of -KILL
+	 * signals?
+	 */
+	BUG_ON(!list_empty(&current->runnable_fibrils));
 
 	profile_task_exit(tsk);
 
diff -r 26e278468209 -r df7bc026d50e kernel/fork.c
--- a/kernel/fork.c	Mon Jan 29 15:36:13 2007 -0800
+++ b/kernel/fork.c	Mon Jan 29 15:36:16 2007 -0800
@@ -1179,6 +1179,9 @@ static struct task_struct *copy_process(
 
 	/* for sys_ioprio_set(IOPRIO_WHO_PGRP) */
 	p->ioprio = current->ioprio;
+
+	p->fibril = NULL;
+	INIT_LIST_HEAD(&p->runnable_fibrils);
 
 	/*
 	 * The task hasn't been attached yet, so its cpus_allowed mask will
diff -r 26e278468209 -r df7bc026d50e kernel/sched.c
--- a/kernel/sched.c	Mon Jan 29 15:36:13 2007 -0800
+++ b/kernel/sched.c	Mon Jan 29 15:36:16 2007 -0800
@@ -3407,6 +3407,111 @@ static inline int interactive_sleep(enum
 }
 
 /*
+ * This unwinds the state that was built up by schedule -> schedule_fibril().
+ * The arch-specific switch_to_fibril() path calls here once the new fibril
+ * is executing.
+ */
+void finish_fibril_switch(void)
+{
+	spin_unlock_irq(&this_rq()->lock);
+	preempt_enable_no_resched();
+}
+
+/*
+ * Add a new fibril to the runnable list.  It'll be switched to next time
+ * the caller comes through schedule().
+ */
+void sched_new_runnable_fibril(struct fibril *fibril)
+{
+	struct task_struct *tsk = current;
+	unsigned long flags;
+	struct rq *rq = task_rq_lock(tsk, &flags);
+
+	fibril->state = TASK_RUNNING;
+	BUG_ON(!list_empty(&fibril->run_list));
+	list_add_tail(&fibril->run_list, &tsk->runnable_fibrils);
+
+	task_rq_unlock(rq, &flags);
+}
+
+/*
+ * This is called from schedule() when we're not being preempted and there is a
+ * fibril waiting in current->runnable_fibrils.
+ *
+ * This is called under the run queue lock to serialize fibril->state and the
+ * runnable_fibrils list with wake-up.  We drop it before switching and the
+ * return path takes that into account.
+ *
+ * We always switch so that a caller can specifically make a single pass
+ * through the runnable fibrils by marking itself _RUNNING and calling
+ * schedule().
+ */
+void schedule_fibril(struct task_struct *tsk)
+{
+	struct thread_info *ti = task_thread_info(tsk);
+	struct fibril *prev;
+	struct fibril *next;
+	struct fibril dummy;
+
+	/*
+	 * XXX We don't deal with the kernel lock yet.  It'd need to be audited
+	 * and lock_depth moved under per_call_chain().
+	 */
+	BUG_ON(tsk->lock_depth >= 0);
+
+	next = list_entry(current->runnable_fibrils.next, struct fibril,
+			 run_list);
+	list_del_init(&next->run_list);
+	BUG_ON(next->state != TASK_RUNNING);
+
+	prev = tsk->fibril;
+	if (prev) {
+		prev->state = tsk->state;
+		prev->per_call = current->per_call;
+		/*
+		 * This catches the case where the caller wants to make a pass
+		 * through runnable fibrils by marking itself _RUNNING and
+		 * calling schedule().  A fibril should not be able to be on
+		 * both tsk->fibril and the runnable_list.
+		 */
+		if (prev->state == TASK_RUNNING) {
+			BUG_ON(!list_empty(&prev->run_list));
+			list_add_tail(&prev->run_list,
+				      &current->runnable_fibrils);
+		}
+	} else {
+		/*
+		 * To free a fibril the calling path can free the structure
+		 * itself, set current->fibril to NULL, and call schedule().
+		 * That causes us to tell __switch_to_fibril() to free the ti
+		 * associated with the fibril once we've switched away from it.
+		 * The dummy is just use to give switch_to_fibril() something
+		 * to save state in to.
+		 */
+		prev = &dummy;
+	}
+
+	/* 
+	 * XXX The idea is to copy all but the actual call stack.  Obviously
+	 * this is wildly arch-specific and belongs abstracted out.
+	 */
+	*next->ti = *ti;
+	*thread_info_pt_regs(next->ti) = *thread_info_pt_regs(ti);
+
+	current->thread_info = next->ti;
+	current->thread.esp0 = (unsigned long)(thread_info_pt_regs(next->ti) + 1);
+	current->fibril = next;
+	current->state = next->state;
+	current->per_call = next->per_call;
+
+	if (prev == &dummy)
+		ti->status |= TS_FREE_AFTER_SWITCH;
+
+	/* __switch_to_fibril() drops the runqueue lock and enables preempt */
+	switch_to_fibril(prev, next, ti);
+}
+
+/*
  * schedule() is the main scheduler function.
  */
 asmlinkage void __sched schedule(void)
@@ -3468,6 +3573,22 @@ need_resched_nonpreemptible:
 	run_time /= (CURRENT_BONUS(prev) ? : 1);
 
 	spin_lock_irq(&rq->lock);
+
+	/* always switch to a runnable fibril if we aren't being preempted */
+	if (unlikely(!(preempt_count() & PREEMPT_ACTIVE) &&
+		     !list_empty(&prev->runnable_fibrils))) {
+		schedule_fibril(prev);
+		/* 
+		 * finish_fibril_switch() drops the rq lock and enables
+		 * premption, but the popfl disables interrupts again.  Watch
+		 * me learn how context switch locking works before your very
+		 * eyes!  XXX This will need to be fixed up by throwing
+		 * together something like the prepare_lock_switch() path the
+		 * scheduler does.  Guidance appreciated!
+		 */
+		local_irq_enable();
+		return;
+	}
 
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
