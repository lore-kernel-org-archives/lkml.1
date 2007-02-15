Return-Path: <linux-kernel-owner+w=401wt.eu-S966145AbXBOQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966145AbXBOQ4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966150AbXBOQ4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:56:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40804 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966148AbXBOQz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:55:57 -0500
Date: Thu, 15 Feb 2007 17:52:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 05/14] syslets: core code
Message-ID: <20070215165228.GF4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

the core syslet / async system calls infrastructure code.

Is built only if CONFIG_ASYNC_SUPPORT is enabled.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/Makefile |    1 
 kernel/async.c  |  897 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 898 insertions(+)

Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -10,6 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o
 
+obj-$(CONFIG_ASYNC_SUPPORT) += async.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
Index: linux/kernel/async.c
===================================================================
--- /dev/null
+++ linux/kernel/async.c
@@ -0,0 +1,897 @@
+/*
+ * kernel/async.c
+ *
+ * The syslet subsystem - asynchronous syscall execution support.
+ *
+ * Started by Ingo Molnar:
+ *
+ *  Copyright (C) 2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *
+ * This file is released under the GPLv2.
+ *
+ * This code implements asynchronous syscalls via 'syslets'.
+ *
+ * Syslets consist of a set of 'syslet atoms' which are residing
+ * purely in user-space memory and have no kernel-space resource
+ * attached to them. These atoms can be linked to each other via
+ * pointers. Besides the fundamental ability to execute system
+ * calls, syslet atoms can also implement branches, loops and
+ * arithmetics.
+ *
+ * Thus syslets can be used to build small autonomous programs that
+ * the kernel can execute purely from kernel-space, without having
+ * to return to any user-space context. Syslets can be run by any
+ * unprivileged user-space application - they are executed safely
+ * by the kernel.
+ */
+#include <linux/syscalls.h>
+#include <linux/syslet.h>
+#include <linux/delay.h>
+#include <linux/async.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/err.h>
+
+#include <asm/uaccess.h>
+#include <asm/unistd.h>
+
+#include "async.h"
+
+typedef asmlinkage long (*syscall_fn_t)(long, long, long, long, long, long);
+
+extern syscall_fn_t sys_call_table[NR_syscalls];
+
+static void
+__mark_async_thread_ready(struct async_thread *at, struct async_head *ah)
+{
+	list_del(&at->entry);
+	list_add_tail(&at->entry, &ah->ready_async_threads);
+	if (list_empty(&ah->busy_async_threads))
+		wake_up(&ah->wait);
+}
+
+static void
+mark_async_thread_ready(struct async_thread *at, struct async_head *ah)
+{
+	spin_lock(&ah->lock);
+	__mark_async_thread_ready(at, ah);
+	spin_unlock(&ah->lock);
+}
+
+static void
+__mark_async_thread_busy(struct async_thread *at, struct async_head *ah)
+{
+	list_del(&at->entry);
+	list_add_tail(&at->entry, &ah->busy_async_threads);
+}
+
+static void
+mark_async_thread_busy(struct async_thread *at, struct async_head *ah)
+{
+	spin_lock(&ah->lock);
+	__mark_async_thread_busy(at, ah);
+	spin_unlock(&ah->lock);
+}
+
+static void
+__async_thread_init(struct task_struct *t, struct async_thread *at,
+		    struct async_head *ah)
+{
+	INIT_LIST_HEAD(&at->entry);
+	at->exit = 0;
+	at->task = t;
+	at->ah = ah;
+	at->work = NULL;
+
+	t->at = at;
+	ah->nr_threads++;
+}
+
+static void
+async_thread_init(struct task_struct *t, struct async_thread *at,
+		  struct async_head *ah)
+{
+	spin_lock(&ah->lock);
+	__async_thread_init(t, at, ah);
+	__mark_async_thread_ready(at, ah);
+	spin_unlock(&ah->lock);
+}
+
+
+static void
+async_thread_exit(struct async_thread *at, struct task_struct *t)
+{
+	struct async_head *ah = at->ah;
+
+	spin_lock(&ah->lock);
+	list_del_init(&at->entry);
+	if (at->exit)
+		complete(&ah->exit_done);
+	t->at = NULL;
+	at->task = NULL;
+	WARN_ON(!ah->nr_threads);
+	ah->nr_threads--;
+	spin_unlock(&ah->lock);
+}
+
+static struct async_thread *
+pick_ready_cachemiss_thread(struct async_head *ah)
+{
+	struct list_head *head = &ah->ready_async_threads;
+	struct async_thread *at;
+
+	if (list_empty(head))
+		return NULL;
+
+	at = list_entry(head->next, struct async_thread, entry);
+
+	return at;
+}
+
+void __async_schedule(struct task_struct *t)
+{
+	struct async_thread *new_async_thread;
+	struct async_thread *async_ready;
+	struct async_head *ah = t->ah;
+	struct task_struct *new_task;
+
+	spin_lock(&ah->lock);
+
+	new_async_thread = pick_ready_cachemiss_thread(ah);
+	if (!new_async_thread)
+		goto out_unlock;
+
+	async_ready = t->async_ready;
+	WARN_ON(!async_ready);
+	t->async_ready = NULL;
+
+	new_task = new_async_thread->task;
+
+	move_user_context(new_task, t);
+
+	new_task->at = NULL;
+	t->ah = NULL;
+	new_task->ah = ah;
+
+	wake_up_process(new_task);
+
+	__async_thread_init(t, async_ready, ah);
+	__mark_async_thread_busy(t->at, ah);
+
+ out_unlock:
+	spin_unlock(&ah->lock);
+}
+
+static void async_schedule(struct task_struct *t)
+{
+	if (t->async_ready)
+		__async_schedule(t);
+}
+
+static long __exec_atom(struct task_struct *t, struct syslet_atom *atom)
+{
+	struct async_thread *async_ready_save;
+	long ret;
+
+	/*
+	 * If user-space expects the syscall to schedule then
+	 * (try to) switch user-space to another thread straight
+	 * away and execute the syscall asynchronously:
+	 */
+	if (unlikely(atom->flags & SYSLET_ASYNC))
+		async_schedule(t);
+	/*
+	 * Does user-space want synchronous execution for this atom?:
+	 */
+	async_ready_save = t->async_ready;
+	if (unlikely(atom->flags & SYSLET_SYNC))
+		t->async_ready = NULL;
+
+	if (unlikely(atom->nr >= NR_syscalls))
+		return -ENOSYS;
+
+	ret = sys_call_table[atom->nr](atom->args[0], atom->args[1],
+				       atom->args[2], atom->args[3],
+				       atom->args[4], atom->args[5]);
+	if (atom->ret_ptr && put_user(ret, atom->ret_ptr))
+		return -EFAULT;
+
+	if (t->ah)
+		t->async_ready = async_ready_save;
+
+	return ret;
+}
+
+/*
+ * Arithmetics syscall, add a value to a user-space memory location.
+ *
+ * Generic C version - in case the architecture has not implemented it
+ * in assembly.
+ */
+asmlinkage __attribute__((weak)) long
+sys_umem_add(unsigned long __user *uptr, unsigned long inc)
+{
+	unsigned long val, new_val;
+
+	if (get_user(val, uptr))
+		return -EFAULT;
+	/*
+	 * inc == 0 means 'read memory value':
+	 */
+	if (!inc)
+		return val;
+
+	new_val = val + inc;
+	if (__put_user(new_val, uptr))
+		return -EFAULT;
+
+	return new_val;
+}
+
+/*
+ * Open-coded because this is a very hot codepath during syslet
+ * execution and every cycle counts ...
+ *
+ * [ NOTE: it's an explicit fastcall because optimized assembly code
+ *   might depend on this. There are some kernels that disable regparm,
+ *   so lets not break those if possible. ]
+ */
+fastcall __attribute__((weak)) long
+copy_uatom(struct syslet_atom *atom, struct syslet_uatom __user *uatom)
+{
+	unsigned long __user *arg_ptr;
+	long ret = 0;
+
+	if (!access_ok(VERIFY_READ, uatom, sizeof(*uatom)))
+		return -EFAULT;
+
+	ret = __get_user(atom->nr, &uatom->nr);
+	ret |= __get_user(atom->ret_ptr, &uatom->ret_ptr);
+	ret |= __get_user(atom->flags, &uatom->flags);
+	ret |= __get_user(atom->next, &uatom->next);
+
+	memset(atom->args, 0, sizeof(atom->args));
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[0]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_READ, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[0], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[1]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_READ, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[1], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[2]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_READ, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[2], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[3]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_READ, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[3], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[4]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_READ, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[4], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[5]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_READ, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[5], arg_ptr);
+
+	return ret;
+}
+
+/*
+ * Should the next atom run, depending on the return value of
+ * the current atom - or should we stop execution?
+ */
+static int run_next_atom(struct syslet_atom *atom, long ret)
+{
+	switch (atom->flags & SYSLET_STOP_MASK) {
+		case SYSLET_STOP_ON_NONZERO:
+			if (!ret)
+				return 1;
+			return 0;
+		case SYSLET_STOP_ON_ZERO:
+			if (ret)
+				return 1;
+			return 0;
+		case SYSLET_STOP_ON_NEGATIVE:
+			if (ret >= 0)
+				return 1;
+			return 0;
+		case SYSLET_STOP_ON_NON_POSITIVE:
+			if (ret > 0)
+				return 1;
+			return 0;
+	}
+	return 1;
+}
+
+static struct syslet_uatom __user *
+next_uatom(struct syslet_atom *atom, struct syslet_uatom *uatom, long ret)
+{
+	/*
+	 * If the stop condition is false then continue
+	 * to atom->next:
+	 */
+	if (run_next_atom(atom, ret))
+		return atom->next;
+	/*
+	 * Special-case: if the stop condition is true and the atom
+	 * has SKIP_TO_NEXT_ON_STOP set, then instead of
+	 * stopping we skip to the atom directly after this atom
+	 * (in linear address-space).
+	 *
+	 * This, combined with the atom->next pointer and the
+	 * stop condition flags is what allows true branches and
+	 * loops in syslets:
+	 */
+	if (atom->flags & SYSLET_SKIP_TO_NEXT_ON_STOP)
+		return uatom + 1;
+
+	return NULL;
+}
+
+/*
+ * If user-space requested a completion event then put the last
+ * executed uatom into the completion ring:
+ */
+static long
+complete_uatom(struct async_head *ah, struct task_struct *t,
+	       struct syslet_atom *atom, struct syslet_uatom __user *uatom)
+{
+	struct syslet_uatom __user **ring_slot, *slot_val = NULL;
+	long ret;
+
+	WARN_ON(!t->at);
+	WARN_ON(t->ah);
+
+	if (unlikely(atom->flags & SYSLET_NO_COMPLETE))
+		return 0;
+
+	/*
+	 * Asynchron threads can complete in parallel so use the
+	 * head-lock to serialize:
+	 */
+	spin_lock(&ah->lock);
+	ring_slot = ah->completion_ring + ah->curr_ring_idx;
+	ret = __copy_from_user_inatomic(&slot_val, ring_slot, sizeof(slot_val));
+	/*
+	 * User-space submitted more work than what fits into the
+	 * completion ring - do not stomp over it silently and signal
+	 * the error condition:
+	 */
+	if (unlikely(slot_val)) {
+		spin_unlock(&ah->lock);
+		return -EFAULT;
+	}
+	slot_val = uatom;
+	ret |= __copy_to_user_inatomic(ring_slot, &slot_val, sizeof(slot_val));
+
+	ah->curr_ring_idx++;
+	if (unlikely(ah->curr_ring_idx == ah->max_ring_idx))
+		ah->curr_ring_idx = 0;
+
+	/*
+	 * See whether the async-head is waiting and needs a wakeup:
+	 */
+	if (ah->events_left) {
+		ah->events_left--;
+		if (!ah->events_left)
+			wake_up(&ah->wait);
+	}
+
+	spin_unlock(&ah->lock);
+
+	return ret;
+}
+
+/*
+ * This is the main syslet atom execution loop. This fetches atoms
+ * and executes them until it runs out of atoms or until the
+ * exit condition becomes false:
+ */
+static struct syslet_uatom __user *
+exec_atom(struct async_head *ah, struct task_struct *t,
+	  struct syslet_uatom __user *uatom)
+{
+	struct syslet_uatom __user *last_uatom;
+	struct syslet_atom atom;
+	long ret;
+
+ run_next:
+	if (unlikely(copy_uatom(&atom, uatom)))
+		return ERR_PTR(-EFAULT);
+
+	last_uatom = uatom;
+	ret = __exec_atom(t, &atom);
+	if (unlikely(signal_pending(t) || need_resched()))
+		goto stop;
+
+	uatom = next_uatom(&atom, uatom, ret);
+	if (uatom)
+		goto run_next;
+ stop:
+	/*
+	 * We do completion only in async context:
+	 */
+	if (t->at && complete_uatom(ah, t, &atom, last_uatom))
+		return ERR_PTR(-EFAULT);
+
+	return last_uatom;
+}
+
+static void cachemiss_execute(struct async_thread *at, struct async_head *ah,
+			      struct task_struct *t)
+{
+	struct syslet_uatom __user *uatom;
+
+	uatom = at->work;
+	WARN_ON(!uatom);
+	at->work = NULL;
+
+	exec_atom(ah, t, uatom);
+}
+
+static struct syslet_uatom __user *
+cachemiss_loop(struct async_thread *at, struct async_head *ah,
+	       struct task_struct *t)
+{
+	for (;;) {
+		mark_async_thread_busy(at, ah);
+		set_task_state(t, TASK_INTERRUPTIBLE);
+		if (at->work)
+			cachemiss_execute(at, ah, t);
+		if (unlikely(t->ah || at->exit || signal_pending(t)))
+			break;
+		mark_async_thread_ready(at, ah);
+		schedule();
+	}
+	t->state = TASK_RUNNING;
+
+	async_thread_exit(at, t);
+
+	if (at->exit)
+		do_exit(0);
+
+	if (!t->ah) {
+		task_pt_regs(t)->esp = at->user_stack;
+		task_pt_regs(t)->eip = at->user_eip;
+
+		return (void *)-1;
+	}
+	/*
+	 * Head context: return to user-space with NULL:
+	 */
+	return NULL;
+}
+
+static int cachemiss_thread(void *data)
+{
+	struct pt_regs *head_regs, *regs;
+	struct task_struct *t = current;
+	struct async_head *ah = data;
+	struct async_thread *at;
+	int ret;
+
+	at = &t->__at;
+	async_thread_init(t, at, ah);
+
+	/*
+	 * Clone the head thread's user-space ptregs over,
+	 * now that we are in kernel-space:
+	 */
+	head_regs = task_pt_regs(ah->user_task);
+	regs = task_pt_regs(t);
+
+	*regs = *head_regs;
+	ret = get_user(at->user_stack, ah->new_stack);
+	WARN_ON(ret);
+	/*
+	 * Clear the stack pointer, signalling to user-space that
+	 * this thread stack has been used up:
+	 */
+	ret = put_user(0, ah->new_stack);
+	WARN_ON(ret);
+
+	complete(&ah->start_done);
+
+	/*
+	 * Fixme: 64-bit kernel threads should return long
+	 */
+	return (int)cachemiss_loop(at, ah, t);
+}
+
+/**
+ * sys_async_thread - do work as an async cachemiss thread again
+ */
+asmlinkage long sys_async_thread(void)
+{
+	struct task_struct *t = current;
+	struct async_thread *at = t->at;
+	struct async_head *ah = t->__at.ah;
+
+	/*
+	 * Only async threads are allowed to do this:
+	 */
+	if (!ah || t->ah)
+		return -EINVAL;
+
+	WARN_ON(at);
+	at = &t->__at;
+	WARN_ON(!at->ah);
+
+	async_thread_init(t, at, ah);
+
+	return (long)cachemiss_loop(at, at->ah, t);
+}
+
+
+static void __notify_async_thread_exit(struct async_thread *at,
+				       struct async_head *ah)
+{
+	list_del_init(&at->entry);
+	at->exit = 1;
+	init_completion(&ah->exit_done);
+	wake_up_process(at->task);
+}
+
+static void stop_cachemiss_threads(struct async_head *ah)
+{
+	struct async_thread *at;
+
+repeat:
+	spin_lock(&ah->lock);
+	list_for_each_entry(at, &ah->ready_async_threads, entry) {
+
+		__notify_async_thread_exit(at, ah);
+		spin_unlock(&ah->lock);
+
+		wait_for_completion(&ah->exit_done);
+
+		goto repeat;
+	}
+
+	list_for_each_entry(at, &ah->busy_async_threads, entry) {
+
+		__notify_async_thread_exit(at, ah);
+		spin_unlock(&ah->lock);
+
+		wait_for_completion(&ah->exit_done);
+
+		goto repeat;
+	}
+	spin_unlock(&ah->lock);
+}
+
+static void async_head_exit(struct async_head *ah, struct task_struct *t)
+{
+	stop_cachemiss_threads(ah);
+	WARN_ON(!list_empty(&ah->ready_async_threads));
+	WARN_ON(!list_empty(&ah->busy_async_threads));
+	WARN_ON(ah->nr_threads);
+	WARN_ON(spin_is_locked(&ah->lock));
+
+	t->ah = NULL;
+}
+
+/*
+ * Pretty arbitrary for now. The kernel resource-controls the number
+ * of threads anyway.
+ */
+#define DEFAULT_THREAD_LIMIT 1024
+
+/*
+ * Initialize the in-kernel async head, based on the user-space async
+ * head:
+ */
+static long
+async_head_init(struct task_struct *t, struct async_head_user __user *ahu)
+{
+	unsigned long max_nr_threads, ring_size_bytes, max_ring_idx;
+	struct syslet_uatom __user **completion_ring;
+	unsigned long head_stack, head_eip;
+	struct async_head *ah;
+	long ret;
+
+	if (get_user(max_nr_threads, &ahu->max_nr_threads))
+		return -EFAULT;
+	if (get_user(completion_ring, &ahu->completion_ring))
+		return -EFAULT;
+	if (get_user(head_stack, &ahu->head_stack))
+		return -EFAULT;
+	if (get_user(head_eip, &ahu->head_eip))
+		return -EFAULT;
+	if (get_user(ring_size_bytes, &ahu->ring_size_bytes))
+		return -EFAULT;
+	if (!ring_size_bytes)
+		return -EINVAL;
+	/*
+	 * We pre-check the ring pointer, so that in the fastpath
+	 * we can use __put_user():
+	 */
+	if (!access_ok(VERIFY_WRITE, completion_ring, ring_size_bytes))
+		return -EFAULT;
+
+	max_ring_idx = ring_size_bytes / sizeof(void *);
+	if (ring_size_bytes != max_ring_idx * sizeof(void *))
+		return -EINVAL;
+
+	/*
+	 * Lock down the ring. Note: user-space should not munlock() this,
+	 * because if the ring pages get swapped out then the async
+	 * completion code might return a -EFAULT instead of the expected
+	 * completion. (the kernel safely handles that case too, so this
+	 * isnt a security problem.)
+	 *
+	 * mlock() is better here because it gets resource-accounted
+	 * properly, and even unprivileged userspace has a few pages
+	 * of mlock-able memory available. (which is more than enough
+	 * for the completion-pointers ringbuffer)
+	 */
+	ret = sys_mlock((unsigned long)completion_ring, ring_size_bytes);
+	if (ret)
+		return ret;
+
+	/*
+	 * -1 means: the kernel manages the optimal size of the async pool.
+	 * Simple static limit for now.
+	 */
+	if (max_nr_threads == -1UL)
+		max_nr_threads = DEFAULT_THREAD_LIMIT;
+	/*
+	 * If the ring is smaller than the number of threads requested
+	 * then lower the thread count - otherwise we might lose
+	 * syslet completion events:
+	 */
+	max_nr_threads = min(max_ring_idx, max_nr_threads);
+
+	ah = &t->__ah;
+
+	spin_lock_init(&ah->lock);
+	ah->nr_threads = 0;
+	ah->max_nr_threads = max_nr_threads;
+	INIT_LIST_HEAD(&ah->ready_async_threads);
+	INIT_LIST_HEAD(&ah->busy_async_threads);
+	init_waitqueue_head(&ah->wait);
+	ah->events_left = 0;
+	ah->ahu = ahu;
+	ah->curr_ring_idx = 0;
+	ah->max_ring_idx = max_ring_idx;
+	ah->completion_ring = completion_ring;
+	ah->ring_size_bytes = ring_size_bytes;
+	ah->new_stack = NULL;
+	ah->new_eip = 0;
+	t->__at.user_stack = head_stack;
+	t->__at.user_eip = head_eip;
+
+	ah->user_task = NULL;
+	t->ah = ah;
+
+	return 0;
+}
+
+/**
+ * sys_async_register - enable async syscall support
+ *
+ * NOTE: @ahu is recorded by the kernel and it might read it, so
+ * make sure the user-space data structure persists. For example
+ * the kernel might adopt the pool size to ahu->max_nr_threads
+ * on the fly.
+ */
+asmlinkage long
+sys_async_register(struct async_head_user __user *ahu, unsigned int len)
+{
+	struct task_struct *t = current;
+
+	/*
+	 * This 'len' check enables future extension of
+	 * the async_head ABI:
+	 */
+	if (len != sizeof(struct async_head_user))
+		return -EINVAL;
+	/*
+	 * Already registered?
+	 */
+	if (t->ah)
+		return -EEXIST;
+
+	return async_head_init(t, ahu);
+}
+
+/**
+ * sys_async_unregister - disable async syscall support
+ */
+asmlinkage long
+sys_async_unregister(struct async_head_user __user *ahu, unsigned int len)
+{
+	struct syslet_uatom __user **completion_ring;
+	struct task_struct *t = current;
+	struct async_head *ah = t->ah;
+	unsigned long ring_size_bytes;
+
+	if (len != sizeof(struct async_head_user))
+		return -EINVAL;
+	/*
+	 * Already unregistered?
+	 */
+	if (!ah)
+		return -EINVAL;
+
+	completion_ring = ah->completion_ring;
+	ring_size_bytes = ah->ring_size_bytes;
+
+	async_head_exit(ah, t);
+
+	/*
+	 * Unpin the ring:
+	 */
+	return sys_munlock((unsigned long)completion_ring, ring_size_bytes);
+}
+
+/*
+ * Simple limit and pool management mechanism for now:
+ */
+static void
+refill_cachemiss_pool(struct async_head *ah, unsigned long __user *new_stackp,
+		      unsigned long new_eip)
+{
+	int pid;
+
+	if (ah->nr_threads >= ah->max_nr_threads)
+		return;
+
+	init_completion(&ah->start_done);
+	ah->user_task = current;
+	ah->new_stack = new_stackp;
+	ah->new_eip = new_eip;
+
+	pid = create_async_thread(cachemiss_thread, (void *)ah,
+			   CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND |
+			   CLONE_THREAD | CLONE_SYSVSEM);
+	if (pid < 0)
+		return;
+
+	wait_for_completion(&ah->start_done);
+	ah->user_task = NULL;
+	ah->new_stack = NULL;
+	ah->new_eip = 0;
+}
+
+/**
+ * sys_async_wait - wait for async completion events
+ *
+ * This syscall waits for @min_wait_events syslet completion events
+ * to finish or for all async processing to finish (whichever
+ * comes first).
+ */
+asmlinkage long
+sys_async_wait(unsigned long min_wait_events, unsigned long user_curr_ring_idx)
+{
+	struct task_struct *t = current;
+	struct async_head *ah = t->ah;
+
+	/*
+	 * Do not allow async waiting:
+	 */
+	if (async_syscall(t))
+		return -ENOSYS;
+	if (!ah)
+		return -EINVAL;
+
+	if (min_wait_events) {
+		spin_lock(&ah->lock);
+		/*
+		 * Account any completions that happened since user-space
+		 * checked the ring:
+	 	 */
+		ah->events_left = min_wait_events -
+				(ah->curr_ring_idx - user_curr_ring_idx);
+		spin_unlock(&ah->lock);
+	}
+
+	return wait_event_interruptible(ah->wait,
+		list_empty(&ah->busy_async_threads) || ah->events_left <= 0);
+}
+
+/**
+ * sys_async_exec - execute a syslet.
+ *
+ * returns the uatom that was last executed, if the kernel was able to
+ * execute the syslet synchronously, or NULL if the syslet became
+ * asynchronous. (in the latter case syslet completion will be notified
+ * via the completion ring)
+ *
+ * (Various errors might also be returned via the usual negative numbers.)
+ */
+asmlinkage struct syslet_uatom __user *
+sys_async_exec(struct syslet_uatom __user *uatom,
+	       unsigned long __user *new_stackp, unsigned long new_eip)
+{
+	struct syslet_uatom __user *ret;
+	struct task_struct *t = current;
+	struct async_head *ah = t->ah;
+	struct async_thread *at = &t->__at;
+
+	/*
+	 * Do not allow recursive calls of sys_async_exec():
+	 */
+	if (async_syscall(t))
+		return ERR_PTR(-ENOSYS);
+
+	if (unlikely(!ah))
+		return ERR_PTR(-EINVAL);
+
+	if (list_empty(&ah->ready_async_threads))
+		refill_cachemiss_pool(ah, new_stackp, new_eip);
+
+	t->async_ready = at;
+	ret = exec_atom(ah, t, uatom);
+
+	/*
+	 * Are we still executing as head?
+	 */
+	if (t->ah) {
+		t->async_ready = NULL;
+
+		return ret;
+	}
+
+	/*
+	 * We got turned into a cachemiss thread,
+	 * enter the cachemiss loop:
+	 */
+	set_task_state(t, TASK_INTERRUPTIBLE);
+	mark_async_thread_ready(at, ah);
+
+	return cachemiss_loop(at, ah, t);
+}
+
+/*
+ * fork()-time initialization:
+ */
+void async_init(struct task_struct *t)
+{
+	t->at		= NULL;
+	t->async_ready	= NULL;
+	t->ah		= NULL;
+	t->__at.ah	= NULL;
+}
+
+/*
+ * do_exit()-time cleanup:
+ */
+void async_exit(struct task_struct *t)
+{
+	struct async_thread *at = t->at;
+	struct async_head *ah = t->ah;
+
+	/*
+	 * If head does a sys_exit() then the final schedule() must
+	 * not be passed on to another cachemiss thread:
+	 */
+	t->async_ready = NULL;
+
+	if (unlikely(at))
+		async_thread_exit(at, t);
+
+	if (unlikely(ah))
+		async_head_exit(ah, t);
+}
