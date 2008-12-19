Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYLSHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYLSHQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 02:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYLSHQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 02:16:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbYLSHQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 02:16:06 -0500
Date: Thu, 18 Dec 2008 23:15:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for
 doing very slow work items [ver #41]
Message-Id: <20081218231511.d9201464.akpm@linux-foundation.org>
In-Reply-To: <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 14:41:45 +0000 David Howells <dhowells@redhat.com> wrote:

> Create a dynamically sized pool of threads for doing very slow work items, such
> as invoking mkdir() or rmdir() - things that may take a long time and may
> sleep, holding mutexes/semaphores and hogging a thread, and are thus unsuitable
> for workqueues.
> 
> The number of threads is always at least a settable minimum, but more are
> started when there's more work to do, up to a limit.  Because of the nature of
> the load, it's not suitable for a 1-thread-per-CPU type pool.  A system with
> one CPU may well want several threads.
> 
> This is used by FS-Cache to do slow caching operations in the background, such
> as looking up, creating or deleting cache objects.
> 

This may be the most skilfully commented kernel code I've ever seen.

>
> ...
>
> +/*
> + * The pool of threads has at least min threads in it as long as someone is
> + * using the facility, and may have as many as max.
> + *
> + * A portion of the pool may be processing very slow operations.
> + */
> +static unsigned slow_work_min_threads = 2;
> +static unsigned slow_work_max_threads = (NR_CPUS > 4) ? NR_CPUS : 4;

I suspect there will be a requirement to tune this at runtime.

Using num_possible_cpus() would be more accurate here.  One could
easily envisage NR_CPUS=1024 on a 2-way machine.  Generally any use
of NR_CPUS is a red flag.  In fact there's a checkpatch warning about
it now.

>
> ...
>
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

This could be a regular C function?

> +	set_freezable();
> +	set_user_nice(current, -5);
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
> +
>
> ...
>
> +int slow_work_register_user(void)
> +{
> +	struct task_struct *p;
> +	int loop;
> +
> +	mutex_lock(&slow_work_user_lock);
> +
> +	if (slow_work_user_count == 0) {
> +		printk(KERN_NOTICE "Slow work thread pool: Starting up\n");
> +		init_completion(&slow_work_last_thread_exited);
> +
> +		slow_work_threads_should_exit = false;
> +
> +		/* start the minimum number of threads */
> +		for (loop = 0; loop < slow_work_min_threads; loop++) {
> +			atomic_inc(&slow_work_thread_count);
> +			p = kthread_create(slow_work_thread, NULL,
> +					   "kslow%Xd", loop);
> +			if (!p)
> +				goto error;
> +			wake_up_process(p);

The above reimplements kthread_run().

> +		}
> +		printk(KERN_NOTICE "Slow work thread pool: Ready\n");
> +	}
> +
> +	slow_work_user_count++;
> +	mutex_unlock(&slow_work_user_lock);
> +	return 0;
> +
> +error:
> +	if (atomic_dec_and_test(&slow_work_thread_count))
> +		complete(&slow_work_last_thread_exited);
> +	if (loop > 0) {
> +		printk(KERN_ERR "Slow work thread pool:"
> +		       " Aborting startup on ENOMEM\n");
> +		slow_work_threads_should_exit = true;
> +		wake_up_all(&slow_work_thread_wq);
> +		wait_for_completion(&slow_work_last_thread_exited);
> +		printk(KERN_ERR "Slow work thread pool: Aborted\n");
> +	}
> +	mutex_unlock(&slow_work_user_lock);
> +	return PTR_ERR(p);
> +}
> +EXPORT_SYMBOL(slow_work_register_user);

