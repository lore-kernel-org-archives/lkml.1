Return-Path: <linux-kernel-owner+w=401wt.eu-S966462AbXEHMb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966462AbXEHMb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966391AbXEHMb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:31:56 -0400
Received: from mail.screens.ru ([213.234.233.54]:58714 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966366AbXEHMbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:31:55 -0400
Date: Tue, 8 May 2007 16:31:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070508123102.GB968@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <20070508071544.GA1772@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508071544.GA1772@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Jarek Poplawski wrote:
> 
> On Fri, May 04, 2007 at 12:42:26AM +0400, Oleg Nesterov wrote:
> ...
> > +static int try_to_grab_pending(struct work_struct *work)
> > +{
> > +	struct cpu_workqueue_struct *cwq;
> > +	int ret = 0;
> > +
> > +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
> > +		return 1;
> 
> Previous version used this check to run del_timer, and I think, it
> was good idea. So, maybe, try something like this:
> 
> - run once del_timer before the loop (in cancel_rearming_ only),

hmm, cancel_rearming_ does del_timer() before try_to_grab_pending().

> - add a parmeter to try_to_grab_pending, e.g. "rearming",
> - add here something like this:
> 
> 	else if (rearming && del_timer(&work->timer)
> 		return 1;

I thought about adding such a parameter, and I don't like this. This is
a matter of taste, of course, but _imho_ this uglifies the code.

In any case, unless we do completely different patch, the sequence should be

	del_timer()	- a pending timer is the most common case

	test_and_set_bit(WORK_STRUCT_PENDING) - the work is idle

	try-to-steal-the-queued-work

This is what we are doing now.

> > +
> > +	/*
> > +	 * The queueing is in progress, or it is already queued. Try to
> > +	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
> > +	 */
> > +
> > +	cwq = get_wq_data(work);
> > +	if (!cwq)
> > +		return ret;
> 
> Probably you meant:
> 		return 1;

No, we should return 0. This can happen if the queueing of the freshly-
initialized @dwork is in progress.

NOTE: right now try_to_grab_pending() is called from cancel_xxx() only, so
this can't happen (it would be meaningless to do cancel_xxx if somebody else
can queue this work or start the timer), but I'd like try_to_grab_pending()
to be as generic as possible.

So, we should either return 0, or add BUG_ON(!cwq).

> BTW, probably there is some special reason it's in the loop now,
> so maybe you should add a comment, why the old way (at the beginning
> of a cancel_ function) is not enough.

see above. Note that wait_on_work() checks cwq == NULL as well. This is
because I do not want to tie try_to_grab_pending() and wait_on_work(),
they should be generic, and could be used independently.

> I think adding the first check:
> 
>    if (!list_empty(&work->entry)) {
>
> without the lock is usable here.

We should optimize the common case, and most probably this work is
already queued, so I don't this it is worth to enlarge .text.

> > +void cancel_work_sync(struct work_struct *work)
> > +{
> > +	while (!try_to_grab_pending(work))
> 
> So this could be:
> 	while (!try_to_grab_pending(work, 0))
> 
> > +		;
> > +	wait_on_work(work);
> > +	work_clear_pending(work);
> >  }
> > ...
> > +void cancel_rearming_delayed_work(struct delayed_work *dwork)
> > +{
> > +	while (!del_timer(&dwork->timer) &&
> > +	       !try_to_grab_pending(&dwork->work))
> 
> ...and this like here:
> 
>   if (!del_timer(&dwork->timer)
> 	while (!try_to_grab_pending(&dwork->work, 1))
> 
> 
> > +		;
> > +	wait_on_work(&dwork->work);
> > +	work_clear_pending(&dwork->work);
> > +}

As I said, I personally don't like this, mostly because this complicates
the code a bit more.

> I didn't have as much time as needed, so I'll try to look
> at this yet.

Yes, please, and thank you very much for review!

Oleg.

