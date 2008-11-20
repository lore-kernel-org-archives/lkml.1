Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYKTOmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYKTOmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYKTOly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:41:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYKTOlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:41:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/45] Create a dynamically sized pool of threads for doing
	very slow work items [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:41:45 +0000
Message-ID: <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a dynamically sized pool of threads for doing very slow work items, such
as invoking mkdir() or rmdir() - things that may take a long time and may
sleep, holding mutexes/semaphores and hogging a thread, and are thus unsuitable
for workqueues.

The number of threads is always at least a settable minimum, but more are
started when there's more work to do, up to a limit.  Because of the nature of
the load, it's not suitable for a 1-thread-per-CPU type pool.  A system with
one CPU may well want several threads.

This is used by FS-Cache to do slow caching operations in the background, such
as looking up, creating or deleting cache objects.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/slow-work.h |   88 +++++++++++
 init/Kconfig              |   12 ++
 kernel/Makefile           |    1 
 kernel/slow-work.c        |  351 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 452 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/slow-work.h
 create mode 100644 kernel/slow-work.c


diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
new file mode 100644
index 0000000..16c3ea8
--- /dev/null
+++ b/include/linux/slow-work.h
@@ -0,0 +1,88 @@
+/* Worker thread pool for slow items, such as filesystem lookups or mkdirs
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_SLOW_WORK_H
+#define _LINUX_SLOW_WORK_H
+
+#ifdef CONFIG_SLOW_WORK
+
+struct slow_work;
+
+/*
+ * The operations used to support slow work items
+ */
+struct slow_work_ops {
+	/* get a ref on a work item
+	 * - return 0 if successful, -ve if not
+	 */
+	int (*get_ref)(struct slow_work *work);
+
+	/* discard a ref to a work item */
+	void (*put_ref)(struct slow_work *work);
+
+	/* execute a work item */
+	void (*execute)(struct slow_work *work);
+};
+
+/*
+ * A slow work item
+ * - A reference is held on the parent object by the thread pool when it is
+ *   queued
+ */
+struct slow_work {
+	unsigned long		flags;		/* flags defining the state of the work item */
+#define SLOW_WORK_PENDING	0		/* - work item is pending (further) execution */
+#define SLOW_WORK_EXECUTING	1		/* - work item is currently executing */
+#define SLOW_WORK_ENQ_DEFERRED	2		/* - work item enqueue deferred */
+#define SLOW_WORK_VERY_SLOW	3		/* - work item is very slow */
+	const struct slow_work_ops *ops;	/* operations table for this item */
+	struct list_head	link;		/* link in queue */
+};
+
+/**
+ * slow_work_init - Initialise a slow work item
+ * @work: The work item to initialise
+ * @ops: The operations to use to handle the slow work item
+ *
+ * Initialise a slow work item.
+ */
+static inline void slow_work_init(struct slow_work *work,
+				  const struct slow_work_ops *ops)
+{
+	work->flags = 0;
+	work->ops = ops;
+	INIT_LIST_HEAD(&work->link);
+}
+
+/**
+ * slow_work_init - Initialise a very slow work item
+ * @work: The work item to initialise
+ * @ops: The operations to use to handle the slow work item
+ *
+ * Initialise a very slow work item.  This item will be restricted such that
+ * only a certain number of the pool threads will be able to execute items of
+ * this type.
+ */
+static inline void vslow_work_init(struct slow_work *work,
+				   const struct slow_work_ops *ops)
+{
+	work->flags = 1 << SLOW_WORK_VERY_SLOW;
+	work->ops = ops;
+	INIT_LIST_HEAD(&work->link);
+}
+
+extern int slow_work_enqueue(struct slow_work *work);
+extern int slow_work_register_user(void);
+extern void slow_work_unregister_user(void);
+
+
+#endif /* CONFIG_SLOW_WORK */
+#endif /* _LINUX_SLOW_WORK_H */
diff --git a/init/Kconfig b/init/Kconfig
index 226da27..8547ea4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -814,6 +814,18 @@ config MARKERS
 
 source "arch/Kconfig"
 
+config SLOW_WORK
+	default n
+	bool "Enable slow work thread pool"
+	help
+	  The slow work thread pool provides a number of dynamically allocated
+	  threads that can be used by the kernel to perform operations that
+	  take a relatively long time.
+
+	  An example of this would be CacheFiles doing a path lookup followed
+	  by a series of mkdirs and a create call, all of which have to touch
+	  disk.
+
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT
diff --git a/kernel/Makefile b/kernel/Makefile
index b1e6b66..61734c5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_SLOW_WORK) += slow-work.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
new file mode 100644
index 0000000..590fc7b
--- /dev/null
+++ b/kernel/slow-work.c
@@ -0,0 +1,351 @@
+/* Worker thread pool for slow items, such as filesystem lookups or mkdirs
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slow-work.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/wait.h>
+#include <asm/system.h>
+
+/*
+ * The pool of threads has at least min threads in it as long as someone is
+ * using the facility, and may have as many as max.
+ *
+ * A portion of the pool may be processing very slow operations.
+ */
+static unsigned slow_work_min_threads = 2;
+static unsigned slow_work_max_threads = (NR_CPUS > 4) ? NR_CPUS : 4;
+static unsigned vslow_work_proportion = 50; /* % of threads that may process
+					     * very slow work */
+static atomic_t slow_work_thread_count;
+static atomic_t vslow_work_executing_count;
+
+/*
+ * The queues of work items and the lock governing access to them.  These are
+ * shared between all the CPUs.  It doesn't make sense to have per-CPU queues
+ * as the number of threads bears no relation to the number of CPUs.
+ *
+ * There are two queues of work items: one for slow work items, and one for
+ * very slow work items.
+ */
+static LIST_HEAD(slow_work_queue);
+static LIST_HEAD(vslow_work_queue);
+static DEFINE_SPINLOCK(slow_work_queue_lock);
+
+/*
+ * The thread controls.  A variable used to signal to the threads that they
+ * should exit when the queue is empty, a waitqueue used by the threads to wait
+ * for signals, and a completion set by the last thread to exit.
+ */
+static bool slow_work_threads_should_exit;
+static DECLARE_WAIT_QUEUE_HEAD(slow_work_thread_wq);
+static DECLARE_COMPLETION(slow_work_last_thread_exited);
+
+/*
+ * The number of users of the thread pool and its lock.  Whilst this is zero we
+ * have no threads hanging around, and when this reaches zero, we wait for all
+ * active or queued work items to complete and kill all the threads we do have.
+ */
+static int slow_work_user_count;
+static DEFINE_MUTEX(slow_work_user_lock);
+
+/*
+ * Calculate the maximum number of active threads in the pool that are
+ * permitted to process very slow work items.
+ *
+ * The answer is rounded up to at least 1, but may not equal or exceed the
+ * maximum number of the threads in the pool.  This means we always have at
+ * least one thread that can process slow work items, and we always have at
+ * least one thread that won't get tied up doing so.
+ */
+static unsigned slow_work_calc_vsmax(void)
+{
+	unsigned vsmax;
+
+	vsmax = atomic_read(&slow_work_thread_count) * vslow_work_proportion;
+	vsmax /= 100;
+	vsmax = max(vsmax, 1U);
+	return min(vsmax, slow_work_max_threads - 1);
+}
+
+/*
+ * Attempt to execute stuff queued on a slow thread.  Return true if we managed
+ * it, false if there was nothing to do.
+ */
+static bool slow_work_execute(void)
+{
+	struct slow_work *work = NULL;
+	unsigned vsmax;
+	bool very_slow;
+
+	vsmax = slow_work_calc_vsmax();
+
+	/* find something to execute */
+	spin_lock_irq(&slow_work_queue_lock);
+	if (!list_empty(&vslow_work_queue) &&
+	    atomic_read(&vslow_work_executing_count) < vsmax) {
+		work = list_entry(vslow_work_queue.next,
+				  struct slow_work, link);
+		if (test_and_set_bit_lock(SLOW_WORK_EXECUTING, &work->flags))
+			BUG();
+		list_del_init(&work->link);
+		atomic_inc(&vslow_work_executing_count);
+		very_slow = true;
+	} else if (!list_empty(&slow_work_queue)) {
+		work = list_entry(slow_work_queue.next,
+				  struct slow_work, link);
+		if (test_and_set_bit_lock(SLOW_WORK_EXECUTING, &work->flags))
+			BUG();
+		list_del_init(&work->link);
+		very_slow = false;
+	} else {
+		very_slow = false; /* avoid the compiler warning */
+	}
+	spin_unlock_irq(&slow_work_queue_lock);
+
+	if (!work)
+		return false;
+
+	if (!test_and_clear_bit(SLOW_WORK_PENDING, &work->flags))
+		BUG();
+
+	work->ops->execute(work);
+
+	if (very_slow)
+		atomic_dec(&vslow_work_executing_count);
+	clear_bit_unlock(SLOW_WORK_EXECUTING, &work->flags);
+
+	/* if someone tried to enqueue the item whilst we were executing it,
+	 * then it'll be left unenqueued to avoid multiple threads trying to
+	 * execute it simultaneously
+	 *
+	 * there is, however, a race between us testing the pending flag and
+	 * getting the spinlock, and between the enqueuer setting the pending
+	 * flag and getting the spinlock, so we use a deferral bit to tell us
+	 * if the enqueuer got there first
+	 */
+	if (test_bit(SLOW_WORK_PENDING, &work->flags)) {
+		spin_lock_irq(&slow_work_queue_lock);
+			
+		if (!test_bit(SLOW_WORK_EXECUTING, &work->flags) &&
+		    test_and_clear_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags))
+			goto auto_requeue;
+
+		spin_unlock_irq(&slow_work_queue_lock);
+	}
+
+	work->ops->put_ref(work);
+	return true;
+
+auto_requeue:
+	/* we must complete the enqueue operation
+	 * - we transfer our ref on the item back to the appropriate queue
+	 * - don't wake another thread up as we're awake already
+	 */
+	if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
+		list_add_tail(&work->link, &vslow_work_queue);
+	else
+		list_add_tail(&work->link, &slow_work_queue);
+	spin_unlock_irq(&slow_work_queue_lock);
+	return true;
+}
+
+/**
+ * slow_work_enqueue - Schedule a slow work item for processing
+ * @work: The work item to queue
+ *
+ * Schedule a slow work item for processing.  If the item is already undergoing
+ * execution, this guarantees not to re-enter the execution routine until the
+ * first execution finishes.
+ *
+ * The item is pinned by this function as it retains a reference to it, managed
+ * through the item operations.  The item is unpinned once it has been
+ * executed.
+ *
+ * An item may hog the thread that is running it for a relatively large amount
+ * of time, sufficient, for example, to perform several lookup, mkdir, create
+ * and setxattr operations.  It may sleep on I/O and may sleep to obtain locks.
+ *
+ * Conversely, if a number of items are awaiting processing, it may take some
+ * time before any given item is given attention.  The number of threads in the
+ * pool may be increased to deal with demand, but only up to a limit.
+ *
+ * If SLOW_WORK_VERY_SLOW is set on the work item, then it will be placed in
+ * the very slow queue, from which only a portion of the threads will be
+ * allowed to pick items to execute.  This ensures that very slow items won't
+ * overly block ones that are just ordinarily slow.
+ *
+ * Returns 0 if successful, -EAGAIN if not.
+ */
+int slow_work_enqueue(struct slow_work *work)
+{
+	unsigned long flags;
+
+	BUG_ON(slow_work_user_count <= 0);
+	BUG_ON(!work);
+	BUG_ON(!work->ops);
+	BUG_ON(!work->ops->get_ref);
+
+	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
+		spin_lock_irqsave(&slow_work_queue_lock, flags);
+
+		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
+			/* can't queue lest we cause multiple threads to try
+			 * executing this item, so defer for later */
+			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
+		} else {
+			if (work->ops->get_ref(work) < 0)
+				goto cant_get_ref;
+			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
+				list_add_tail(&work->link, &vslow_work_queue);
+			else
+				list_add_tail(&work->link, &slow_work_queue);
+			wake_up(&slow_work_thread_wq);
+		}
+
+		spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+	}
+	return 0;
+
+cant_get_ref:
+	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
+	return -EAGAIN;
+}
+EXPORT_SYMBOL(slow_work_enqueue);
+
+/*
+ * Worker thread dispatcher
+ */
+static int slow_work_thread(void *_data)
+{
+	int vsmax;
+
+	DEFINE_WAIT(wait);
+
+#define slow_work_available(vsmax) \
+	(!list_empty(&slow_work_queue) || \
+	 (!list_empty(&vslow_work_queue) && \
+	  atomic_read(&vslow_work_executing_count) < (vsmax)))
+
+	set_freezable();
+	set_user_nice(current, -5);
+
+	for (;;) {
+		vsmax = vslow_work_proportion;
+		vsmax *= atomic_read(&slow_work_thread_count);
+		vsmax /= 100;
+
+		prepare_to_wait(&slow_work_thread_wq, &wait,
+				TASK_INTERRUPTIBLE);
+		if (!freezing(current) &&
+		    !slow_work_threads_should_exit &&
+		    !slow_work_available(vsmax))
+			schedule();
+		finish_wait(&slow_work_thread_wq, &wait);
+
+		try_to_freeze();
+
+		vsmax = vslow_work_proportion;
+		vsmax *= atomic_read(&slow_work_thread_count);
+		vsmax /= 100;
+
+		if (slow_work_available(vsmax) && slow_work_execute()) {
+			cond_resched();
+			continue;
+		}
+
+		if (slow_work_threads_should_exit)
+			break;
+	}
+
+	if (atomic_dec_and_test(&slow_work_thread_count))
+		complete_and_exit(&slow_work_last_thread_exited, 0);
+	return 0;
+}
+
+/**
+ * slow_work_register_user - Register a user of the facility
+ *
+ * Register a user of the facility, starting up the initial threads if there
+ * aren't any other users at this point.  This will return 0 if successful, or
+ * an error if not.
+ */
+int slow_work_register_user(void)
+{
+	struct task_struct *p;
+	int loop;
+
+	mutex_lock(&slow_work_user_lock);
+
+	if (slow_work_user_count == 0) {
+		printk(KERN_NOTICE "Slow work thread pool: Starting up\n");
+		init_completion(&slow_work_last_thread_exited);
+
+		slow_work_threads_should_exit = false;
+
+		/* start the minimum number of threads */
+		for (loop = 0; loop < slow_work_min_threads; loop++) {
+			atomic_inc(&slow_work_thread_count);
+			p = kthread_create(slow_work_thread, NULL,
+					   "kslow%Xd", loop);
+			if (!p)
+				goto error;
+			wake_up_process(p);
+		}
+		printk(KERN_NOTICE "Slow work thread pool: Ready\n");
+	}
+
+	slow_work_user_count++;
+	mutex_unlock(&slow_work_user_lock);
+	return 0;
+
+error:
+	if (atomic_dec_and_test(&slow_work_thread_count))
+		complete(&slow_work_last_thread_exited);
+	if (loop > 0) {
+		printk(KERN_ERR "Slow work thread pool:"
+		       " Aborting startup on ENOMEM\n");
+		slow_work_threads_should_exit = true;
+		wake_up_all(&slow_work_thread_wq);
+		wait_for_completion(&slow_work_last_thread_exited);
+		printk(KERN_ERR "Slow work thread pool: Aborted\n");
+	}
+	mutex_unlock(&slow_work_user_lock);
+	return PTR_ERR(p);
+}
+EXPORT_SYMBOL(slow_work_register_user);
+
+/**
+ * slow_work_unregister_user - Unregister a user of the facility
+ *
+ * Unregister a user of the facility, killing all the threads if this was the
+ * last one.
+ */
+void slow_work_unregister_user(void)
+{
+	mutex_lock(&slow_work_user_lock);
+
+	BUG_ON(slow_work_user_count <= 0);
+
+	slow_work_user_count--;
+	if (slow_work_user_count == 0) {
+		printk(KERN_NOTICE "Slow work thread pool: Shutting down\n");
+		slow_work_threads_should_exit = true;
+		wake_up_all(&slow_work_thread_wq);
+		wait_for_completion(&slow_work_last_thread_exited);
+		printk(KERN_NOTICE "Slow work thread pool:"
+		       " Shut down complete\n");
+	}
+
+	mutex_unlock(&slow_work_user_lock);
+}
+EXPORT_SYMBOL(slow_work_unregister_user);

