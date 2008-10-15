Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYJOImv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYJOImv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYJOImS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:42:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149AbYJOImR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:42:17 -0400
Date: Wed, 15 Oct 2008 01:41:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
 mechanism
Message-Id: <20081015014117.faff3a61.akpm@linux-foundation.org>
In-Reply-To: <20081012194427.2e21c22e@infradead.org>
References: <20081012194427.2e21c22e@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 12 Oct 2008 19:44:27 -0400 Arjan van de Ven <arjan@infradead.org> wrote:
> after the discussion on fastboot I came up with the following patch
> (this was all done at 35000 feet so if it's h0rked .. I'll claim lack of oxygen)
> 
> I'll also reply to this email with 2 users of the new infrastructure just to show how it'd be used.
> 
> 
> 
> >From c5fd398d7210bcdc726dc813523d8b4c58481553 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 12 Oct 2008 15:27:22 -0400
> Subject: [PATCH] fastboot: Introduce an asynchronous function call mechanism
> 
> During the system boot there are many things that take a long time
> and also can be done asynchronous; this patch introduces a call_async()
> function that implements a pool of threads to execute the asynchronous
> calls.
> 
> The calls are divided into pools, and within a pool the calls are processed
> in order; this is done to preserve stable device numbers.
>
> ...
> 
> +#include <linux/list.h>
> +#include <linux/workqueue.h>
> +#include <linux/wait.h>
> +#include <linux/hrtimer.h>
> +#include <linux/slab.h>
> +#include <linux/kthread.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +
> +#include <stdarg.h>
> +
> +static int async_active = 0;

?

> +typedef int (*async_func_t_0)(void);
> +typedef int (*async_func_t_1)(void *);
> +typedef int (*async_func_t_2)(void *, void *);
> +typedef int (*async_func_t_3)(void *, void *, void *);
> +typedef int (*async_func_t_4)(void *, void *, void *, void *);
> +
> +
> +struct async_item {
> +	struct list_head list;
> +
> +	async_func_t_0 	func;
> +	int		argument_count;
> +	void		*arg1;
> +	void		*arg2;
> +	void		*arg3;
> +	void		*arg4;
> +};
> +
> +
> +static struct list_head list_pool[ASYNC_MAX_POOL + 1];
> +static struct task_struct * thread_pool[ASYNC_MAX_POOL + 1];
> +static wait_queue_head_t waitqueue_pool[ASYNC_MAX_POOL + 1];
> +static int pool_count[ASYNC_MAX_POOL + 1];
> +
> +static spinlock_t pool_lock;

DEFINE_SPINLOCK(), remove spin_lock_init()

> +extern int initcall_debug;

no externs in C.

> +static void do_async_item(struct async_item *item)
> +{
> +	ktime_t t0, t1, delta;
> +	int result;
> +	async_func_t_0 fn0 = item->func;
> +	async_func_t_1 fn1 = (async_func_t_1)item->func;
> +	async_func_t_2 fn2 = (async_func_t_2)item->func;
> +	async_func_t_3 fn3 = (async_func_t_3)item->func;
> +	async_func_t_4 fn4 = (async_func_t_4)item->func;
> +
> +	if (initcall_debug) {
> +		printk("calling  %pF @ %i\n", item->func,
> +			task_pid_nr(current));
> +		t0 = ktime_get();
> +	}
> +
> +	switch (item->argument_count) {
> +	case 0:
> +		result = fn0();
> +		break;
> +	case 1:
> +		result = fn1(item->arg1);
> +		break;
> +	case 2:
> +		result = fn2(item->arg1, item->arg2);
> +		break;
> +	case 3:
> +		result = fn3(item->arg1, item->arg2, item->arg3);
> +		break;
> +	case 4:
> +		result = fn4(item->arg1, item->arg2, item->arg3, item->arg4);
> +		break;
> +	default:
> +		result = 0;
> +		WARN_ON(1);
> +	}
> +	if (initcall_debug) {
> +		t1 = ktime_get();
> +		delta = ktime_sub(t1, t0);
> +
> +		printk("asynccall %pF returned %d after %Ld msecs\n",
> +			item->func, result,
> +			(unsigned long long) delta.tv64 >> 20);
> +	}
> +}
> +
> +
> +static int async_thread(void *data)
> +{
> +	int pool = (unsigned long) data;
> +
> +	DECLARE_WAITQUEUE(wq, current);

random newline in locals

> +	add_wait_queue(&waitqueue_pool[pool], &wq);

never gets removed

> +	while (!kthread_should_stop()) {
> +		struct async_item *item = NULL;
> +
> +		spin_lock(&pool_lock);
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (!list_empty(&list_pool[pool])) {
> +			item = list_first_entry(&list_pool[pool], struct async_item, list);
> +			list_del(&item->list);
> +			pool_count[pool]--;
> +		}
> +		spin_unlock(&pool_lock);
> +
> +		if (!item) {
> +			schedule();
> +			continue;
> +		}
> +		__set_current_state(TASK_RUNNING);
> +		do_async_item(item);
> +		kfree(item);
> +		wake_up(&waitqueue_pool[pool]);
> +	}
> +	return 0;
> +}
> +
> +
> +void init_async_calls(void)
> +{
> +	unsigned long i;
> +	spin_lock_init(&pool_lock);
> +	for (i = 0; i <= ASYNC_MAX_POOL; i++) {
> +		INIT_LIST_HEAD(&list_pool[i]);
> +		init_waitqueue_head(&waitqueue_pool[i]);
> +		thread_pool[i] = kthread_run(&async_thread, (void *)i, "kasyncd/%li", i);
> +	}
> +	async_active = 1;
> +}

Please talk to Evgeniy about his new thread_pool stuff which I've suggested
become a generic library.

(looks at changelog, doesn't really understand the need for the thread pool
thing, doesn't understand the comment about device numbers)

> +
> +void call_async(int pool_number, int argc, ...)

This looks like schedule_work().  Why cannot that be used (perhaps after
suitable modification)?



