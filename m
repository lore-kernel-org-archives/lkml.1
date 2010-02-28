Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032039Ab0B1Uef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:34:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032025Ab0B1Uee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:34:34 -0500
Date: Sun, 28 Feb 2010 21:31:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 18/43] workqueue: reimplement workqueue flushing using
	color coded works
Message-ID: <20100228203136.GA28915@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-19-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267187000-18791-19-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Tejun Heo wrote:
>
> +	/*
> +	 * The last color is no color used for works which don't
> +	 * participate in workqueue flushing.
> +	 */
> +	WORK_NR_COLORS		= (1 << WORK_STRUCT_COLOR_BITS) - 1,
> +	WORK_NO_COLOR		= WORK_NR_COLORS,

Not sure this makes sense, but instead of special NO_COLOR reserved
for barriers we could change insert_wq_barrier() to use cwq == NULL
to mark this work as no-color. Note that the barriers doesn't need a
valid get_wq_data() or even _PENDING bit set (apart from BUG_ON()
check in run_workqueue).

> +static int work_flags_to_color(unsigned int flags)
> +{
> +	return (flags >> WORK_STRUCT_COLOR_SHIFT) &
> +		((1 << WORK_STRUCT_COLOR_BITS) - 1);
> +}

perhaps work_to_color(work) makes more sense, every caller needs to
read work->data anyway.

> +static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
> +{
> +	/* ignore uncolored works */
> +	if (color == WORK_NO_COLOR)
> +		return;
> +
> +	cwq->nr_in_flight[color]--;
> +
> +	/* is flush in progress and are we at the flushing tip? */
> +	if (likely(cwq->flush_color != color))
> +		return;
> +
> +	/* are there still in-flight works? */
> +	if (cwq->nr_in_flight[color])
> +		return;
> +
> +	/* this cwq is done, clear flush_color */
> +	cwq->flush_color = -1;

Well. I am not that smart to understand this patch quickly ;) will try to
read it more tomorrow, but...

Very naive question: why do we need cwq->nr_in_flight[] at all? Can't
cwq_dec_nr_in_flight(color) do

	if (WORK_NO_COLOR)
		return;

	if (cwq->flush_color == -1)
		return;

	BUG_ON((cwq->flush_color != color);
	if (next_work && work_to_color(next_work) == color)
		return;

	cwq->flush_color = -1;
	if (atomic_dec_and_test(nr_cwqs_to_flush))
		complete(first_flusher);

?

OK, try_to_grab_pending() needs more attention, it should check prev_work,
but this is slow path.


And I can't understand ->nr_cwqs_to_flush logic.

Say, we have 2 CPUs and both have a single pending work with color == 0.

flush_workqueue()->flush_workqueue_prep_cwqs() does for_each_possible_cpu()
and each iteration does atomic_inc(nr_cwqs_to_flush).

What if the first CPU flushes its work between these 2 iterations?

Afaics, in this case this first CPU will complete(first_flusher->done),
then the flusher will increment nr_cwqs_to_flush again during the
second iteration.

Then the flusher drops ->flush_mutex and wait_for_completion() succeeds
before the second CPU flushes its work.

No?


>  void flush_workqueue(struct workqueue_struct *wq)
>  {
> ...
> +	 * First flushers are responsible for cascading flushes and
> +	 * handling overflow.  Non-first flushers can simply return.
> +	 */
> +	if (wq->first_flusher != &this_flusher)
> +		return;
> +
> +	mutex_lock(&wq->flush_mutex);
> +
> +	wq->first_flusher = NULL;
> +
> +	BUG_ON(!list_empty(&this_flusher.list));
> +	BUG_ON(wq->flush_color != this_flusher.flush_color);
> +
> +	while (true) {
> +		struct wq_flusher *next, *tmp;
> +
> +		/* complete all the flushers sharing the current flush color */
> +		list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
> +			if (next->flush_color != wq->flush_color)
> +				break;
> +			list_del_init(&next->list);
> +			complete(&next->done);

Is it really possible that "next" can ever have the same flush_color?

Oleg.

