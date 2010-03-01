Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab0CAOzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:55:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0CAOzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:55:41 -0500
Date: Mon, 1 Mar 2010 15:53:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 20/43] workqueue: reimplement work flushing using
	linked works
Message-ID: <20100301145344.GA9815@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-21-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267187000-18791-21-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Tejun Heo wrote:
>
> +static void move_linked_works(struct work_struct *work, struct list_head *head,
> +			      struct work_struct **nextp)
> +{
> ...
> +	work = list_entry(work->entry.prev, struct work_struct, entry);
> +	list_for_each_entry_safe_continue(work, n, NULL, entry) {

list_for_each_entry_safe_from(work) ? It doesn't need to move this
work back.

> @@ -680,7 +734,27 @@ static int worker_thread(void *__worker)
>  		if (kthread_should_stop())
>  			break;
>
> -		run_workqueue(worker);
> +		spin_lock_irq(&cwq->lock);
> +
> +		while (!list_empty(&cwq->worklist)) {
> +			struct work_struct *work =
> +				list_first_entry(&cwq->worklist,
> +						 struct work_struct, entry);
> +
> +			if (likely(!(*work_data_bits(work) &
> +				     WORK_STRUCT_LINKED))) {
> +				/* optimization path, not strictly necessary */
> +				process_one_work(worker, work);
> +				if (unlikely(!list_empty(&worker->scheduled)))
> +					process_scheduled_works(worker);
> +			} else {
> +				move_linked_works(work, &worker->scheduled,
> +						  NULL);
> +				process_scheduled_works(worker);
> +			}
> +		}

So. If the next pending work W doesn't have WORK_STRUCT_LINKED,
it will be executed first, then we flush ->scheduled.

But,

>  static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
> -			struct wq_barrier *barr, struct list_head *head)
> +			      struct wq_barrier *barr,
> +			      struct work_struct *target, struct worker *worker)
>  {
> ...
> +	/*
> +	 * If @target is currently being executed, schedule the
> +	 * barrier to the worker; otherwise, put it after @target.
> +	 */
> +	if (worker)
> +		head = worker->scheduled.next;

this is the "target == current_work" case,

> -	insert_work(cwq, &barr->work, head, work_color_to_flags(WORK_NO_COLOR));
> +	insert_work(cwq, &barr->work, head,
> +		    work_color_to_flags(WORK_NO_COLOR) | linked);
>  }

and in this case we put this barrier at the head of ->scheduled list.

This means, this barrier will run after that work W, not before it?


Hmm. And what if there are no pending works but ->current_work == target ?
Again, we add the barrier to ->scheduled, but in this case worker_thread()
can't even notice ->scheduled is not empty because it only checks ->worklist?

Well. most probably I just misread this code completely...


insert_wq_barrier() also does:

	unsigned long *bits = work_data_bits(target);
	...
	*bits |= WORK_STRUCT_LINKED;

perhaps this needs atomic_long_set(), although I am not sure this really
matters.

Oleg.

