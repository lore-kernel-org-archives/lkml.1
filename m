Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXCZHTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXCZHTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 03:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXCZHTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 03:19:35 -0400
Received: from mail17.syd.optusnet.com.au ([211.29.132.198]:44164 "EHLO
	mail17.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932178AbXCZHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 03:19:34 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: rSDl cpu scheduler version 0.34-test patch
Date: Mon, 26 Mar 2007 17:19:00 +1000
User-Agent: KMail/1.9.5
Cc: linux list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200703261100.22467.kernel@kolivas.org> <1174885253.7040.57.camel@Homer.simpson.net>
In-Reply-To: <1174885253.7040.57.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703261719.01444.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 15:00, Mike Galbraith wrote:
> On Mon, 2007-03-26 at 11:00 +1000, Con Kolivas wrote:
> > This is just for testing at the moment! The reason is the size of this
> > patch.
>
> (no testing done yet, but I have a couple comments)
>
> > In the interest of evolution, I've taken the RSDL cpu scheduler and
> > increased the resolution of the task timekeeping to nanosecond
> > resolution.
>
> +	/* All the userspace visible cpu accounting is done here */
> +	time_diff = now - p->last_ran;
> ...
> +		/* cpu scheduler quota accounting is performed here */
> +		if (p->policy != SCHED_FIFO)
> +			p->time_slice -= time_diff;
>
> If we still have any jiffies resolution clocks out there, this could be
> a bit problematic.

Works fine with jiffy only resolution. sched_clock just returns the change 
when it happens. This leaves us with the accuracy of the previous code on 
hardware that doesn't give higher resolution time from sched_clock.

> +static inline void enqueue_pulled_task(struct rq *src_rq, struct rq *rq,
> +				       struct task_struct *p)
> +{
> +	int queue_prio;
> +
> +	p->array = rq->active; <== set
> +	if (!rt_task(p)) {
> +		if (p->rotation == src_rq->prio_rotation) {
> +			if (p->array == src_rq->expired) { <== evaluate

I don't see a problem.

> +				queue_expired(p, rq);
> +				goto out_queue;
> +			}
> +			if (p->time_slice < 0)
> +				task_new_array(p, rq);
> +		} else
> +			task_new_array(p, rq);
> +	}
> +	queue_prio = next_entitled_slot(p, rq);
>
> (bug aside, this special function really shouldn't exist imho, because
> there's nothing special going on.  we didn't need it before to do the
> same thing, so we shouldn't need it now.)

As the comment says, the likelihood that both runqueues happen to be at the 
same priority_level is very low so the exact position cannot be transposed in 
my opinion. I'll see if I can simplify it though.

> +static void recalc_task_prio(struct task_struct *p, struct rq *rq)
> +{
> +	struct prio_array *array = rq->active;
> +	int queue_prio;
> +
> +	if (p->rotation == rq->prio_rotation) {
> +		if (p->array == array) {
> +			if (p->time_slice > 0)
> +				return;
> +			p->time_slice = p->quota;
> +		} else if (p->array == rq->expired) {
> +			queue_expired(p, rq);
> +			return;
> +		} else
> +			task_new_array(p, rq);
> +	} else
>
> Dequeueing a task still leaves a stale p->array laying around to be
> possibly evaluated later.

I don't see quite why that's a problem. If there's memory of the last dequeue 
and it enqueues at a different rotation it gets ignored. If it enqueues 
during the same rotation then that memory proves useful for ensuring it 
doesn't get a new full quota. Either way the array is always updated on 
enqueue so it wont be trying to add it to the wrong runlist.

> try_to_wake_up() doesn't currently evaluate 
> and set p->rotation (but should per design doc),

try_to_wake_up->activate_task->enqueue_task->recalc_task_prio which updates 
p->rotation

> so when you get here, a 
> cross-cpu waking task won't continue it's rotation.  If it did evaluate
> and set, recalc_task_prio() would evaluate the guaranteed to fail these
> tests array pointer, so the task will still not continue it's rotation.

> Stale pointers are evil.

I prefer to use the array value as a memory in case it wakes up on the same 
rotation and runqueue.

>
> 	-Mike

Thanks.

-- 
-ck
