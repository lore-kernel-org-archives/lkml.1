Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab0CARX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:23:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:57517 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0CARX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:23:57 -0500
Message-ID: <4B8BFA65.8090706@kernel.org>
Date: Tue, 02 Mar 2010 02:33:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 18/43] workqueue: reimplement workqueue flushing using
 color coded works
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-19-git-send-email-tj@kernel.org> <20100228203136.GA28915@redhat.com>
In-Reply-To: <20100228203136.GA28915@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 17:22:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On 03/01/2010 05:31 AM, Oleg Nesterov wrote:
> On 02/26, Tejun Heo wrote:
>>
>> +	/*
>> +	 * The last color is no color used for works which don't
>> +	 * participate in workqueue flushing.
>> +	 */
>> +	WORK_NR_COLORS		= (1 << WORK_STRUCT_COLOR_BITS) - 1,
>> +	WORK_NO_COLOR		= WORK_NR_COLORS,
> 
> Not sure this makes sense, but instead of special NO_COLOR reserved
> for barriers we could change insert_wq_barrier() to use cwq == NULL
> to mark this work as no-color. Note that the barriers doesn't need a
> valid get_wq_data() or even _PENDING bit set (apart from BUG_ON()
> check in run_workqueue).

Later when all the worklists on a cpu is unified into a single per-cpu
worklist, work->data is the only way to access which cwq and wq a work
belongs to and process_one_work() depends on it.  Looking at how it's
used, I suspect process_one_work() can survive without knowing the cwq
and wq of a work but it's gonna require a number of condition checks
throughout the queueing, execution and debugfs code (or we can set the
current_cwq to a bogus barrier wq).

Yeah it's definitely something to think about but I think that 15
flush colors should be more than enough especially given that colors
will have increased throughput as pressure builds up, so I'm a bit
reluctant to break invariants for one more color at this point.

>> +static int work_flags_to_color(unsigned int flags)
>> +{
>> +	return (flags >> WORK_STRUCT_COLOR_SHIFT) &
>> +		((1 << WORK_STRUCT_COLOR_BITS) - 1);
>> +}
> 
> perhaps work_to_color(work) makes more sense, every caller needs to
> read work->data anyway.

I think it better matches work_color_to_flags() but yeah doing
*work_data_bits() in every caller is ugly.  I'll change it to
work_color().

>> +static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
>> +{
>> +	/* ignore uncolored works */
>> +	if (color == WORK_NO_COLOR)
>> +		return;
>> +
>> +	cwq->nr_in_flight[color]--;
>> +
>> +	/* is flush in progress and are we at the flushing tip? */
>> +	if (likely(cwq->flush_color != color))
>> +		return;
>> +
>> +	/* are there still in-flight works? */
>> +	if (cwq->nr_in_flight[color])
>> +		return;
>> +
>> +	/* this cwq is done, clear flush_color */
>> +	cwq->flush_color = -1;
> 
> Well. I am not that smart to understand this patch quickly ;) will try to
> read it more tomorrow, but...

Sadly, this is one complex piece of code.  I tried to make it simpler
but couldn't come up with anything significantly better and it takes
me some time to get my head around it even though I wrote and spent
quite some time with it.  If you can suggest something simpler, it
will be great.

> Very naive question: why do we need cwq->nr_in_flight[] at all? Can't
> cwq_dec_nr_in_flight(color) do
> 
> 	if (WORK_NO_COLOR)
> 		return;
> 
> 	if (cwq->flush_color == -1)
> 		return;
> 
> 	BUG_ON((cwq->flush_color != color);
> 	if (next_work && work_to_color(next_work) == color)
> 		return;
> 
> 	cwq->flush_color = -1;
> 	if (atomic_dec_and_test(nr_cwqs_to_flush))
> 		complete(first_flusher);
> 
> ?

Issues I can think of off the top of my head are...

1. Works are removed from the worklist before the callback is called
   and inaccessible once the callback starts running, so completion
   order can't be tracked with work structure themselves.

2. Even if it could be tracked that way, with later unified worklist,
   it will require walking the worklist looking for works with
   matching cwq.

3. Transfer of works to work->scheduled list and the linked works.
   This ends up fragmenting the worklist before execution starts.

> And I can't understand ->nr_cwqs_to_flush logic.
> 
> Say, we have 2 CPUs and both have a single pending work with color == 0.
> 
> flush_workqueue()->flush_workqueue_prep_cwqs() does for_each_possible_cpu()
> and each iteration does atomic_inc(nr_cwqs_to_flush).
> 
> What if the first CPU flushes its work between these 2 iterations?
> 
> Afaics, in this case this first CPU will complete(first_flusher->done),
> then the flusher will increment nr_cwqs_to_flush again during the
> second iteration.
> 
> Then the flusher drops ->flush_mutex and wait_for_completion() succeeds
> before the second CPU flushes its work.
> 
> No?

Yes, thanks for spotting it.  It should start with 1 and do
dec_and_test after the iterations are complete.  Will fix.

>>  void flush_workqueue(struct workqueue_struct *wq)
>>  {
>> ...
>> +	 * First flushers are responsible for cascading flushes and
>> +	 * handling overflow.  Non-first flushers can simply return.
>> +	 */
>> +	if (wq->first_flusher != &this_flusher)
>> +		return;
>> +
>> +	mutex_lock(&wq->flush_mutex);
>> +
>> +	wq->first_flusher = NULL;
>> +
>> +	BUG_ON(!list_empty(&this_flusher.list));
>> +	BUG_ON(wq->flush_color != this_flusher.flush_color);
>> +
>> +	while (true) {
>> +		struct wq_flusher *next, *tmp;
>> +
>> +		/* complete all the flushers sharing the current flush color */
>> +		list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
>> +			if (next->flush_color != wq->flush_color)
>> +				break;
>> +			list_del_init(&next->list);
>> +			complete(&next->done);
> 
> Is it really possible that "next" can ever have the same flush_color?

Yeap, when all the colors are consumed, works wait in the overflow
queue.  On the next flush completion, all works on the overflow list
get the same color so that flush colors increase their throughput as
pressure increases instead of building up a long queue of flushers.

Thanks.

-- 
tejun
