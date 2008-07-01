Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYGAMr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYGAMr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYGAMrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:47:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60566 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbYGAMrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:47:48 -0400
Date: Tue, 1 Jul 2008 16:50:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: implement flush_work()
Message-ID: <20080701125018.GA99@tv-sign.ru>
References: <20080629144926.GA4347@tv-sign.ru> <20080630132512.GA2663@ami.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630132512.GA2663@ami.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Jarek Poplawski wrote:
>
> On Sun, Jun 29, 2008 at 06:49:26PM +0400, Oleg Nesterov wrote:
> ...
> > --- 26-rc2/kernel/workqueue.c~WQ_2_FLUSH_WORK	2008-06-12 21:28:13.000000000 +0400
> > +++ 26-rc2/kernel/workqueue.c	2008-06-29 18:20:33.000000000 +0400
> > @@ -399,6 +399,52 @@ void flush_workqueue(struct workqueue_st
> >  }
> >  EXPORT_SYMBOL_GPL(flush_workqueue);
> >
> > +/**
> > + * flush_work - block until a work_struct's callback has terminated
> > + * @work: the work which is to be flushed
> > + *
> > + * It is expected that, prior to calling flush_work(), the caller has
> > + * arranged for the work to not be requeued, otherwise it doesn't make
> > + * sense to use this function.
> > + */
>
> I missed this before, and probably it's not required, but "Returns..."
> could be added here.

Agreed, I'll update the comment later, together with other changes
in workqueue.c

> > +	spin_lock_irq(&cwq->lock);
> > +	if (!list_empty(&work->entry)) {
> > +		/*
> > +		 * See the comment near try_to_grab_pending()->smp_rmb().
> > +		 * If it was re-queued under us we are not going to wait.
> > +		 */
> > +		smp_rmb();
> > +		if (unlikely(cwq != get_wq_data(work)))
> > +			goto out;
> > +		prev = &work->entry;
> > +	} else {
>
> Probably it doesn't matter too much, but one little doubt: don't we
> need (for consistency) smp_rmb() for this branch as well? It seems
> this cwq could be read out of order here too.
>
> > +		if (cwq->current_work != work)
> > +			goto out;

Yes, cwq can be "stale", but this doesn't matter and we can't have
the false positive here.

cwq->current_work is always changed under cwq->lock, and we hold this
lock. If we see "cwq->current_work == work" we can safely insert the
barrier and wait. Even if this work was already re-queued on another
CPU or another workqueue_struct.

Note also that rmb() can't really help here.

> Otherwise, all looks correct to me as before.

Thanks!

Oleg.

