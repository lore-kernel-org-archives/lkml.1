Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYB2B5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYB2B5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYB2B5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:57:34 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYB2B5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:57:33 -0500
Date: Thu, 28 Feb 2008 17:57:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-Id: <20080228175729.e7bebc44.akpm@linux-foundation.org>
In-Reply-To: <1204180441-8540-11-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
	<1204180441-8540-1-git-send-email-matthew@wil.cx>
	<1204180441-8540-2-git-send-email-matthew@wil.cx>
	<1204180441-8540-3-git-send-email-matthew@wil.cx>
	<1204180441-8540-4-git-send-email-matthew@wil.cx>
	<1204180441-8540-5-git-send-email-matthew@wil.cx>
	<1204180441-8540-6-git-send-email-matthew@wil.cx>
	<1204180441-8540-7-git-send-email-matthew@wil.cx>
	<1204180441-8540-8-git-send-email-matthew@wil.cx>
	<1204180441-8540-9-git-send-email-matthew@wil.cx>
	<1204180441-8540-10-git-send-email-matthew@wil.cx>
	<1204180441-8540-11-git-send-email-matthew@wil.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 01:34:00 -0500 Matthew Wilcox <matthew@wil.cx> wrote:

> Semaphores are no longer performance-critical, so a generic C
> implementation is better for maintainability, debuggability and
> extensibility.
> 

This make all architectures use the lib/semaphore-sleepers.c
implementation.  The major difference is that down() and up() will now
unconditionally do a spin_lock_irq[save]() on the not-contended fastpath,
whereas the hand-optimised arch-specific implementations would avoid that.

Yes, hopefully not many sempahores are used on fastpaths any more, and a
suitable fix for any which _are_ so used is usually convert-to-mutex.

And spin_lock_irqsave() probably isn't hugely slower than an atomic-dec
anyway.



A few nits, most or all of which pertain to the old code:

> --- /dev/null
> +++ b/kernel/semaphore.c
> @@ -0,0 +1,204 @@
> +/*
> + * Copyright (c) 2008 Intel Corporation
> + * Author: Matthew Wilcox <willy@linux.intel.com>
> + *
> + * Distributed under the terms of the GNU GPL, version 2
> + */
> +
> +#include <linux/compiler.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/sched.h>
> +#include <linux/semaphore.h>
> +#include <linux/spinlock.h>
> +
> +/*
> + * Some notes on the implementation:
> + *
> + * down_trylock() and up() can be called from interrupt context.
> + * So we have to disable interrupts when taking the lock.
> + *
> + * The ->count variable, if positive, defines how many more tasks can
> + * acquire the semaphore.  If negative, it represents how many tasks are
> + * waiting on the semaphore (*).  If zero, no tasks are waiting, and no more
> + * tasks can acquire the semaphore.
> + *
> + * (*) Except for the window between one task calling up() and the task
> + * sleeping in a __down_common() waking up.  In order to avoid a third task
> + * coming in and stealing the second task's wakeup, we leave the ->count
> + * negative.  If we have a more complex situation, the ->count may become
> + * zero or negative (eg a semaphore with count = 2, three tasks attempt to
> + * acquire it, one sleeps, two finish and call up(), the second task to call
> + * up() notices that the list is empty and just increments count).
> + */
> +
> +static void noinline __down(struct semaphore *sem);
> +static int noinline __down_interruptible(struct semaphore *sem);
> +static int noinline __down_killable(struct semaphore *sem);
> +static void noinline __up(struct semaphore *sem);

We conventionally do `static inline void' rather than `static void inline',
so I guess we should do `static noinline void' too.

> +int down_interruptible(struct semaphore *sem)
> +{
> +	int result = 0;
> +	might_sleep();
> +	spin_lock_irq(&sem->lock);
> +	if (unlikely(sem->count-- <= 0))
> +		result = __down_interruptible(sem);
> +	spin_unlock_irq(&sem->lock);
> +	return result;
> +}
> +EXPORT_SYMBOL(down_interruptible);

Some functions leave no blank line between end-of-locals and start-of-code...

> +int down_killable(struct semaphore *sem)
> +{
> +	int result = 0;
> +	might_sleep();
> +	spin_lock_irq(&sem->lock);
> +	if (unlikely(sem->count-- <= 0))
> +		result = __down_killable(sem);
> +	spin_unlock_irq(&sem->lock);
> +	return result;
> +}
> +EXPORT_SYMBOL(down_killable);
> +
> +/**
> + * down_trylock - try to acquire the semaphore, without waiting
> + * @sem: the semaphore to be acquired
> + *
> + * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
> + * been acquired successfully and 1 if it is contended.
> + *
> + * NOTE: This return value is inverted from both spin_trylock and
> + * mutex_trylock!  Be careful about this when converting code.
> + *
> + * Unlike mutex_trylock, this function can be used from interrupt context,
> + * and the semaphore can be released by any task or interrupt.
> + */
> +int down_trylock(struct semaphore *sem)
> +{
> +	unsigned long flags;
> +	int count;
> +
> +	spin_lock_irqsave(&sem->lock, flags);
> +	count = sem->count - 1;
> +	if (likely(count >= 0))
> +		sem->count = count;
> +	spin_unlock_irqrestore(&sem->lock, flags);
> +	return (count < 0);
> +}
> +EXPORT_SYMBOL(down_trylock);

whereas some others do leave a blank line.

I think the 51% consensus is that the latter form is preferred.

> +void up(struct semaphore *sem)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sem->lock, flags);
> +	if (likely(sem->count >= 0))
> +		sem->count++;
> +	else
> +		__up(sem);
> +	spin_unlock_irqrestore(&sem->lock, flags);
> +}
> +EXPORT_SYMBOL(up);
> +
> +/* Functions for the contended case */
> +
> +struct semaphore_waiter {
> +	struct list_head list;
> +	struct task_struct *task;
> +	int up;
> +};
> +
> +/*
> + * Wake up a process waiting on a semaphore.  We need to call this from both
> + * __up and __down_common as it's possible to race a task into the semaphore
> + * if it comes in at just the right time between two tasks calling up() and
> + * a third task waking up.  This function assumes the wait_list is already
> + * checked for being non-empty.
> + */
> +static void noinline __sched __up_down_common(struct semaphore *sem)
> +{
> +	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
> +						struct semaphore_waiter, list);
> +	list_del(&waiter->list);
> +	waiter->up = 1;

hm.  Do we need a barrier here?

> +	wake_up_process(waiter->task);
> +}
> +
> +/*
> + * Because this function is inlined, the 'state' parameter will be constant,
> + * and thus optimised away by the compiler.
> + */
> +static inline int __sched __down_common(struct semaphore *sem, long state)
> +{
> +	int result = 0;
> +	struct task_struct *task = current;
> +	struct semaphore_waiter waiter;
> +
> +	list_add_tail(&waiter.list, &sem->wait_list);
> +	waiter.task = task;
> +	waiter.up = 0;
> +
> +	for (;;) {
> +		if (unlikely((state == TASK_INTERRUPTIBLE &&
> +					signal_pending(task)) ||
> +			     (state == TASK_KILLABLE &&
> +					fatal_signal_pending(task))))
> +			goto interrupted;
> +		__set_task_state(task, state);
> +		spin_unlock_irq(&sem->lock);
> +		schedule();
> +		spin_lock_irq(&sem->lock);
> +		if (waiter.up)
> +			goto woken;
> +	}
> +
> + interrupted:
> +	list_del(&waiter.list);
> +	result = -EINTR;
> + woken:
> +	/*
> +	 * Account for the process which woke us up.  For the case where
> +	 * we're interrupted, we need to increment the count on our own
> +	 * behalf.  I don't believe we can hit the case where the
> +	 * sem->count hits zero, *and* there's a second task sleeping,
> +	 * but it doesn't hurt, that's not a commonly exercised path and
> +	 * it's not a performance path either.
> +	 */
> +	if (unlikely((++sem->count >= 0) && !list_empty(&sem->wait_list)))
> +		__up_down_common(sem);
> +	return result;
> +}

That is one huuuuuuuge inline.  Are we sure it's justified?

> +static void noinline __sched __down(struct semaphore *sem)
> +{
> +	__down_common(sem, TASK_UNINTERRUPTIBLE);
> +}
> +
> +static int noinline __sched __down_interruptible(struct semaphore *sem)
> +{
> +	return __down_common(sem, TASK_INTERRUPTIBLE);
> +}
> +
> +static int noinline __sched __down_killable(struct semaphore *sem)
> +{
> +	return __down_common(sem, TASK_KILLABLE);
> +}
> +
> +static void noinline __sched __up(struct semaphore *sem)
> +{
> +	if (unlikely(list_empty(&sem->wait_list)))
> +		sem->count++;
> +	else
> +		__up_down_common(sem);
> +}
> Please read the FAQ at  http://www.tux.org/lkml/
