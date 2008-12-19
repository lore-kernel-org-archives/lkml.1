Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYLSEOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYLSEOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYLSEOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:14:06 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36388 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYLSEOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:14:04 -0500
Date: Thu, 18 Dec 2008 22:14:01 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for
	doing very slow work items [ver #41]
Message-ID: <20081219041401.GA29316@us.ibm.com>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> 
> +/**
> + * slow_work_enqueue - Schedule a slow work item for processing
> + * @work: The work item to queue
> + *
> + * Schedule a slow work item for processing.  If the item is already undergoing
> + * execution, this guarantees not to re-enter the execution routine until the
> + * first execution finishes.
> + *
> + * The item is pinned by this function as it retains a reference to it, managed
> + * through the item operations.  The item is unpinned once it has been
> + * executed.
> + *
> + * An item may hog the thread that is running it for a relatively large amount
> + * of time, sufficient, for example, to perform several lookup, mkdir, create
> + * and setxattr operations.  It may sleep on I/O and may sleep to obtain locks.
> + *
> + * Conversely, if a number of items are awaiting processing, it may take some
> + * time before any given item is given attention.  The number of threads in the
> + * pool may be increased to deal with demand, but only up to a limit.
> + *
> + * If SLOW_WORK_VERY_SLOW is set on the work item, then it will be placed in
> + * the very slow queue, from which only a portion of the threads will be
> + * allowed to pick items to execute.  This ensures that very slow items won't
> + * overly block ones that are just ordinarily slow.
> + *
> + * Returns 0 if successful, -EAGAIN if not.
> + */
> +int slow_work_enqueue(struct slow_work *work)
> +{
> +	unsigned long flags;
> +
> +	BUG_ON(slow_work_user_count <= 0);
> +	BUG_ON(!work);
> +	BUG_ON(!work->ops);
> +	BUG_ON(!work->ops->get_ref);
> +
> +	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {

Can you explain the purpose of the SLOW_WORK_PENDING bit a bit more?
I don't understand why you need it, or what exactly you're doing here.

Seems like if someone enqueues a work item twice in a row, behavior
is unpredicatble?  If it's done fast enough, the second submission
will be ignored.  If slow enough, then the first will have started
executing already, so PENDING bit will have cleared, so this
will set the DEFERRED bit.  But I suspect I'm completely
misunderstanding?

> +		spin_lock_irqsave(&slow_work_queue_lock, flags);
> +
> +		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
> +			/* can't queue lest we cause multiple threads to try
> +			 * executing this item, so defer for later */
> +			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
> +		} else {
> +			if (work->ops->get_ref(work) < 0)
> +				goto cant_get_ref;
> +			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
> +				list_add_tail(&work->link, &vslow_work_queue);
> +			else
> +				list_add_tail(&work->link, &slow_work_queue);
> +			wake_up(&slow_work_thread_wq);
> +		}
> +
> +		spin_unlock_irqrestore(&slow_work_queue_lock, flags);
> +	}
> +	return 0;
> +
> +cant_get_ref:
> +	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
> +	return -EAGAIN;
> +}
> +EXPORT_SYMBOL(slow_work_enqueue);
> +
> +/*
> + * Worker thread dispatcher
> + */
> +static int slow_work_thread(void *_data)
> +{
> +	int vsmax;
> +
> +	DEFINE_WAIT(wait);
> +
> +#define slow_work_available(vsmax) \
> +	(!list_empty(&slow_work_queue) || \
> +	 (!list_empty(&vslow_work_queue) && \
> +	  atomic_read(&vslow_work_executing_count) < (vsmax)))
> +
> +	set_freezable();
> +	set_user_nice(current, -5);

Just curious - why -5?  Whenever it is actually running you'd like it
to have slightly higher priority than ordinary user tasks?

> +
> +	for (;;) {
> +		vsmax = vslow_work_proportion;
> +		vsmax *= atomic_read(&slow_work_thread_count);
> +		vsmax /= 100;
> +
> +		prepare_to_wait(&slow_work_thread_wq, &wait,
> +				TASK_INTERRUPTIBLE);
> +		if (!freezing(current) &&
> +		    !slow_work_threads_should_exit &&
> +		    !slow_work_available(vsmax))
> +			schedule();
> +		finish_wait(&slow_work_thread_wq, &wait);
> +
> +		try_to_freeze();
> +
> +		vsmax = vslow_work_proportion;
> +		vsmax *= atomic_read(&slow_work_thread_count);
> +		vsmax /= 100;
> +
> +		if (slow_work_available(vsmax) && slow_work_execute()) {
> +			cond_resched();
> +			continue;
> +		}
> +
> +		if (slow_work_threads_should_exit)
> +			break;
> +	}
> +
> +	if (atomic_dec_and_test(&slow_work_thread_count))
> +		complete_and_exit(&slow_work_last_thread_exited, 0);
> +	return 0;
> +}
