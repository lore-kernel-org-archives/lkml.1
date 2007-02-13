Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbXBMOYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbXBMOYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbXBMOYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:24:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbXBMOYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:24:05 -0500
Date: Tue, 13 Feb 2007 15:20:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 05/11] syslets: core code
Message-ID: <20070213142035.GF638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060529212109.GA2058@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

the core syslet / async system calls infrastructure code.

Is built only if CONFIG_ASYNC_SUPPORT is enabled.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/Makefile |    1 
 kernel/async.c  |  811 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 812 insertions(+)

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
@@ -0,0 +1,811 @@
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
+	struct async_head *ah;
+
+	ah = at->ah;
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
+static void pick_new_async_head(struct async_head *ah,
+				struct task_struct *t, struct pt_regs *old_regs)
+{
+	struct async_thread *new_async_thread;
+	struct async_thread *async_ready;
+	struct task_struct *new_task;
+	struct pt_regs *new_regs;
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
+	new_regs = task_pt_regs(new_task);
+	*new_regs = *old_regs;
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
+void __async_schedule(struct task_struct *t)
+{
+	struct async_head *ah = t->ah;
+	struct pt_regs *old_regs = task_pt_regs(t);
+
+	pick_new_async_head(ah, t, old_regs);
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
+	__put_user(new_val, uptr);
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
+	if (!access_ok(VERIFY_WRITE, uatom, sizeof(*uatom)))
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
+	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[0], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[1]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[1], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[2]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[2], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[3]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[3], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[4]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
+		return -EFAULT;
+	ret |= __get_user(atom->args[4], arg_ptr);
+
+	ret |= __get_user(arg_ptr, &uatom->arg_ptr[5]);
+	if (!arg_ptr)
+		return ret;
+	if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
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
+static void
+cachemiss_loop(struct async_thread *at, struct async_head *ah,
+	       struct task_struct *t)
+{
+	for (;;) {
+		schedule();
+		mark_async_thread_busy(at, ah);
+		set_task_state(t, TASK_INTERRUPTIBLE);
+		if (at->work)
+			cachemiss_execute(at, ah, t);
+		if (unlikely(t->ah || at->exit || signal_pending(t)))
+			break;
+		mark_async_thread_ready(at, ah);
+	}
+	t->state = TASK_RUNNING;
+
+	async_thread_exit(at, t);
+}
+
+static int cachemiss_thread(void *data)
+{
+	struct task_struct *t = current;
+	struct async_head *ah = data;
+	struct async_thread at;
+
+	async_thread_init(t, &at, ah);
+	complete(&ah->start_done);
+
+	cachemiss_loop(&at, ah, t);
+	if (at.exit)
+		do_exit(0);
+
+	if (!t->ah && signal_pending(t)) {
+		WARN_ON(1);
+		do_exit(0);
+	}
+
+	/*
+	 * Return to user-space with NULL:
+	 */
+	return 0;
+}
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
+	kfree(ah);
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
+async_head_init(struct task_struct *t, struct async_head_user __user *uah)
+{
+	unsigned long max_nr_threads, ring_size_bytes, max_ring_idx;
+	struct syslet_uatom __user **completion_ring;
+	struct async_head *ah;
+	long ret;
+
+	if (get_user(max_nr_threads, &uah->max_nr_threads))
+		return -EFAULT;
+	if (get_user(completion_ring, &uah->completion_ring))
+		return -EFAULT;
+	if (get_user(ring_size_bytes, &uah->ring_size_bytes))
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
+	ah = kmalloc(sizeof(*ah), GFP_KERNEL);
+	if (!ah)
+		return -ENOMEM;
+
+	spin_lock_init(&ah->lock);
+	ah->nr_threads = 0;
+	ah->max_nr_threads = max_nr_threads;
+	INIT_LIST_HEAD(&ah->ready_async_threads);
+	INIT_LIST_HEAD(&ah->busy_async_threads);
+	init_waitqueue_head(&ah->wait);
+	ah->events_left = 0;
+	ah->uah = uah;
+	ah->curr_ring_idx = 0;
+	ah->max_ring_idx = max_ring_idx;
+	ah->completion_ring = completion_ring;
+	ah->ring_size_bytes = ring_size_bytes;
+
+	ah->user_task = t;
+	t->ah = ah;
+
+	return 0;
+}
+
+/**
+ * sys_async_register - enable async syscall support
+ */
+asmlinkage long
+sys_async_register(struct async_head_user __user *uah, unsigned int len)
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
+	return async_head_init(t, uah);
+}
+
+/**
+ * sys_async_unregister - disable async syscall support
+ */
+asmlinkage long
+sys_async_unregister(struct async_head_user __user *uah, unsigned int len)
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
+static void refill_cachemiss_pool(struct async_head *ah)
+{
+	int pid;
+
+	if (ah->nr_threads >= ah->max_nr_threads)
+		return;
+
+	init_completion(&ah->start_done);
+
+	pid = create_async_thread(cachemiss_thread, (void *)ah,
+			   CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND |
+			   CLONE_PTRACE | CLONE_THREAD | CLONE_SYSVSEM);
+	if (pid < 0)
+		return;
+
+	wait_for_completion(&ah->start_done);
+}
+
+/**
+ * sys_async_wait - wait for async completion events
+ *
+ * This syscall waits for @min_wait_events syslet completion events
+ * to finish or for all async processing to finish (whichever
+ * comes first).
+ */
+asmlinkage long sys_async_wait(unsigned long min_wait_events)
+{
+	struct async_head *ah = current->ah;
+
+	if (!ah)
+		return -EINVAL;
+
+	if (min_wait_events) {
+		spin_lock(&ah->lock);
+		ah->events_left = min_wait_events;
+		spin_unlock(&ah->lock);
+	}
+
+	return wait_event_interruptible(ah->wait,
+		list_empty(&ah->busy_async_threads) || !ah->events_left);
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
+sys_async_exec(struct syslet_uatom __user *uatom)
+{
+	struct syslet_uatom __user *ret;
+	struct task_struct *t = current;
+	struct async_head *ah = t->ah;
+	struct async_thread at;
+
+	if (unlikely(!ah))
+		return ERR_PTR(-EINVAL);
+
+	if (list_empty(&ah->ready_async_threads))
+		refill_cachemiss_pool(ah);
+
+	t->async_ready = &at;
+	ret = exec_atom(ah, t, uatom);
+
+	if (t->ah) {
+		WARN_ON(!t->async_ready);
+		t->async_ready = NULL;
+		return ret;
+	}
+	ret = ERR_PTR(-EINTR);
+	if (!at.exit && !signal_pending(t)) {
+		set_task_state(t, TASK_INTERRUPTIBLE);
+		mark_async_thread_ready(&at, ah);
+		cachemiss_loop(&at, ah, t);
+	}
+	if (t->ah)
+		return NULL;
+	else
+		do_exit(0);
+}
+
+/*
+ * fork()-time initialization:
+ */
+void async_init(struct task_struct *t)
+{
+	t->at = NULL;
+	t->async_ready = NULL;
+	t->ah = NULL;
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
+	WARN_ON(at && ah);
+	WARN_ON(t->async_ready);
+
+	if (unlikely(at))
+		async_thread_exit(at, t);
+
+	if (unlikely(ah))
+		async_head_exit(ah, t);
+}
