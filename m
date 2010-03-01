Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab0CATuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:50:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab0CATuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:50:22 -0500
Date: Mon, 1 Mar 2010 20:47:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 18/43] workqueue: reimplement workqueue flushing using
	color coded works
Message-ID: <20100301194728.GA22286@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-19-git-send-email-tj@kernel.org> <20100228203136.GA28915@redhat.com> <4B8BFA65.8090706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8BFA65.8090706@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Tejun Heo wrote:
>
> > Very naive question: why do we need cwq->nr_in_flight[] at all? Can't
> > cwq_dec_nr_in_flight(color) do
> >
> > 	if (WORK_NO_COLOR)
> > 		return;
> >
> > 	if (cwq->flush_color == -1)
> > 		return;
> >
> > 	BUG_ON((cwq->flush_color != color);
> > 	if (next_work && work_to_color(next_work) == color)
> > 		return;
> >
> > 	cwq->flush_color = -1;
> > 	if (atomic_dec_and_test(nr_cwqs_to_flush))
> > 		complete(first_flusher);
> >
> > ?
>
> Issues I can think of off the top of my head are...
>
> 1. Works are removed from the worklist before the callback is called
>    and inaccessible once the callback starts running, so completion
>    order can't be tracked with work structure themselves.
>
> 2. Even if it could be tracked that way, with later unified worklist,
>    it will require walking the worklist looking for works with
>    matching cwq.
>
> 3. Transfer of works to work->scheduled list and the linked works.
>    This ends up fragmenting the worklist before execution starts.

Yes, thanks. Not that I fully understand this right now, but I see
that the next patches make my naive suggestion impossible.

> >>  void flush_workqueue(struct workqueue_struct *wq)
> >>  {
> >> ...
> >> +	 * First flushers are responsible for cascading flushes and
> >> +	 * handling overflow.  Non-first flushers can simply return.
> >> +	 */
> >> +	if (wq->first_flusher != &this_flusher)
> >> +		return;
> >> +
> >> +	mutex_lock(&wq->flush_mutex);
> >> +
> >> +	wq->first_flusher = NULL;
> >> +
> >> +	BUG_ON(!list_empty(&this_flusher.list));
> >> +	BUG_ON(wq->flush_color != this_flusher.flush_color);
> >> +
> >> +	while (true) {
> >> +		struct wq_flusher *next, *tmp;
> >> +
> >> +		/* complete all the flushers sharing the current flush color */
> >> +		list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
> >> +			if (next->flush_color != wq->flush_color)
> >> +				break;
> >> +			list_del_init(&next->list);
> >> +			complete(&next->done);
> >
> > Is it really possible that "next" can ever have the same flush_color?
>
> Yeap, when all the colors are consumed, works wait in the overflow
> queue.  On the next flush completion, all works on the overflow list
> get the same color

Ah. I see.

Thanks Tejun,

Oleg.

