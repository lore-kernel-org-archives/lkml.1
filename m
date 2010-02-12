Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0BLSGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:06:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0BLSGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:06:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1263776272-382-36-git-send-email-tj@kernel.org>
References: <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 35/40] fscache: convert object to use workqueue instead of slow-work
Date: Fri, 12 Feb 2010 18:03:29 +0000
Message-ID: <24913.1265997809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

>  		/* otherwise we sleep until either the object we're waiting for
> -		 * is done, or the slow-work facility wants the thread back to
> -		 * do other work */
> +		 * is done */
>  		wq = bit_waitqueue(&xobject->flags, CACHEFILES_OBJECT_ACTIVE);
>  		init_wait(&wait);
> -		requeue = false;
>  		do {
>  			prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
>  			if (!test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags))
>  				break;
> -			requeue = slow_work_sleep_till_thread_needed(
> -				&object->fscache.work, &timeout);
> -		} while (timeout > 0 && !requeue);
> +			timeout = schedule_timeout(timeout);
> +		} while (timeout > 0);
>  		finish_wait(wq, &wait);

Okay, how do you stop the workqueue from having all its threads blocking on
pending work?  The reason the code you've removed interacts with the slow work
facility in this way is that there can be a dependency whereby an executing
work item depends on something that is queued.  This code allows the thread to
be given back to the pool and processing deferred.

Note that just creating more threads isn't a good answer - that can run you out
of resources instead.

> +	ret = -ENOMEM;
> +	fscache_object_wq =
> +		__create_workqueue("fscache_object", WQ_SINGLE_CPU, 99);
> +	if (!fscache_object_wq)
> +		goto error_object_wq;
> +

What does fscache_object_wq being WQ_SINGLE_CPU imply?  Does that mean there
can only be one CPU processing object state changes?  I'm not sure that's a
good idea - something like a tar command can create thousands of objects, all
of which will start undergoing state changes.

Why did you do this?  Is it because cmwq does _not_ prevent reentrance to
executing work items?  I take it that's why you can get away with this:

	-	slow_work_enqueue(&object->work);
	+	if (fscache_get_object(object) >= 0)
	+		if (!queue_work(fscache_object_wq, &object->work))
	+			fscache_put_object(object);

One of the reasons I _don't_ want to use the old workqueue facility is that it
doesn't manage reentrancy.  That can end up tying up multiple threads for one
long-duration work item.

>  	seq_printf(m,
> -		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx %1lx | ",
> +		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx | ",

You've got to alter the printed header lines too and the documentation.

Note that it would still be useful to know whether an object was queued for
work or being executed.

> -
> -/*
> - * describe an object for slow-work debugging
> - */
> -#ifdef CONFIG_SLOW_WORK_PROC
> -static void fscache_object_slow_work_desc(struct slow_work *work,
> -					  struct seq_file *m)
> -{
> -	struct fscache_object *object =
> -		container_of(work, struct fscache_object, work);
> -
> -	seq_printf(m, "FSC: OBJ%x: %s",
> -		   object->debug_id,
> -		   fscache_object_states_short[object->state]);
> -}
> -#endif

Please provide this facility as part of cmwq - it's been really useful, and I'd
rather not dispense with it.

David
