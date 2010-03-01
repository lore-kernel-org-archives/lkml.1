Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab0CARvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:51:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:47027 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab0CARvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:51:08 -0500
Message-ID: <4B8C00BB.4090500@kernel.org>
Date: Tue, 02 Mar 2010 03:00:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 20/43] workqueue: reimplement work flushing using	linked
 works
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-21-git-send-email-tj@kernel.org> <20100301145344.GA9815@redhat.com>
In-Reply-To: <20100301145344.GA9815@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 17:49:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/01/2010 11:53 PM, Oleg Nesterov wrote:
> On 02/26, Tejun Heo wrote:
>>
>> +static void move_linked_works(struct work_struct *work, struct list_head *head,
>> +			      struct work_struct **nextp)
>> +{
>> ...
>> +	work = list_entry(work->entry.prev, struct work_struct, entry);
>> +	list_for_each_entry_safe_continue(work, n, NULL, entry) {
> 
> list_for_each_entry_safe_from(work) ? It doesn't need to move this
> work back.

Yeap, that will be prettier.  I used _continue there thinking continue
will step from the current one and after finding out that it didn't, I
rewound work not knowing about _from.  Will update.

>> @@ -680,7 +734,27 @@ static int worker_thread(void *__worker)
>>  		if (kthread_should_stop())
>>  			break;
>>
>> -		run_workqueue(worker);
>> +		spin_lock_irq(&cwq->lock);
>> +
>> +		while (!list_empty(&cwq->worklist)) {
>> +			struct work_struct *work =
>> +				list_first_entry(&cwq->worklist,
>> +						 struct work_struct, entry);
>> +
>> +			if (likely(!(*work_data_bits(work) &
>> +				     WORK_STRUCT_LINKED))) {
>> +				/* optimization path, not strictly necessary */
>> +				process_one_work(worker, work);
>> +				if (unlikely(!list_empty(&worker->scheduled)))
>> +					process_scheduled_works(worker);
>> +			} else {
>> +				move_linked_works(work, &worker->scheduled,
>> +						  NULL);
>> +				process_scheduled_works(worker);
>> +			}
>> +		}
> 
> So. If the next pending work W doesn't have WORK_STRUCT_LINKED,
> it will be executed first, then we flush ->scheduled.
> 
> But,
> 
>>  static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
>> -			struct wq_barrier *barr, struct list_head *head)
>> +			      struct wq_barrier *barr,
>> +			      struct work_struct *target, struct worker *worker)
>>  {
>> ...
>> +	/*
>> +	 * If @target is currently being executed, schedule the
>> +	 * barrier to the worker; otherwise, put it after @target.
>> +	 */
>> +	if (worker)
>> +		head = worker->scheduled.next;
> 
> this is the "target == current_work" case,
> 
>> -	insert_work(cwq, &barr->work, head, work_color_to_flags(WORK_NO_COLOR));
>> +	insert_work(cwq, &barr->work, head,
>> +		    work_color_to_flags(WORK_NO_COLOR) | linked);
>>  }
> 
> and in this case we put this barrier at the head of ->scheduled list.
> 
> This means, this barrier will run after that work W, not before it?

Yes, the barrier will run after the target work as it should.

> Hmm. And what if there are no pending works but ->current_work == target ?
> Again, we add the barrier to ->scheduled, but in this case worker_thread()
> can't even notice ->scheduled is not empty because it only checks ->worklist?

A worker always checks ->scheduled after a work is finished.  IOW, if
someone saw worker->current_work == target while holding the lock, the
worker will check the scheduled queue after finishing the target.  If
it's not doing it somewhere, it's a bug.

> insert_wq_barrier() also does:
> 
> 	unsigned long *bits = work_data_bits(target);
> 	...
> 	*bits |= WORK_STRUCT_LINKED;
> 
> perhaps this needs atomic_long_set(), although I am not sure this really
> matters.

Yeah, well, work->data access is pretty messed up.  At this point,
there's no reason for atomic_long_t to begin with.  No real
atomic_long operations are used anyway.  Maybe work->data started as
proper atomic_long_t and lost its properness as it got overloaded with
multiple things.  I'm thinking about just making it a unsigned long
and killing work_data_bits().

Thanks.

-- 
tejun
