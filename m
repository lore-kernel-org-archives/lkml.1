Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbXD0FUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbXD0FUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXD0FUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:20:32 -0400
Received: from mx10.go2.pl ([193.17.41.74]:42265 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755347AbXD0FU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:20:29 -0400
Date: Fri, 27 Apr 2007 07:26:18 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070427052618.GA997@ff.dom.local>
References: <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local> <20070425124714.GA94@tv-sign.ru> <20070425144759.GA201@tv-sign.ru> <20070426125918.GC3145@ff.dom.local> <20070426163406.GA1933@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426163406.GA1933@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:34:06PM +0400, Oleg Nesterov wrote:
> On 04/26, Jarek Poplawski wrote:
> >
> > > 	void cancel_rearming_delayed_work(struct delayed_work *dwork)
> > > 	{
> > > 		struct work_struct *work = &dwork->work;
> > > 		struct cpu_workqueue_struct *cwq = get_wq_data(work);
> > > 		int done;
> > 
> > I don't understand, why you think cwq cannot be NULL here.
> 
> sure it can, this is just a template.
> 
> > > 
> > > 		do {
> > > 			done = 1;
> > > 			spin_lock_irq(&cwq->lock);
> > > 
> > > 			if (!list_empty(&work->entry))
> > > 				list_del_init(&work->entry);
> > 
> > BTW, isn't needs_a_good_name needles after this and after del_timer positive?
> 
> no, we still need it. work->func() may be running on another CPU as well.
> 
> > 
> > > 			else if (test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
> > > 				done = del_timer(&dwork->timer)
> > 
> > If this runs while a work function is fired in run_workqueue,
> > it sets _PENDING bit, but if the work skips rearming, we have probably
> > endless loop, again.
> 
> No, if the work skips rearming (or didn't yet), we set WORK_STRUCT_PENDING
> successfully.

Sorry! Should be:
"If this runs while a work function is fired in run_workqueue,
it sets _PENDING bit, but if the work skips rearming, I have probably
endless loop, again."

> 
> >                                  It is something alike to the current
> > way, with some added measures: you try to shoot a work on the run,
> > while queued or timer_pending, plus the _PENDING flag set, so it seems,
> > there is some risk of longer than planed looping.
> 
> Sorry, can't understand. done == 0 means that the queueing in progress,
> this work should be placed on cwq->worklist very soon, most probably
> right after we drop cwq->lock.

I think, theoretically, probably, maybe, there is possible some strange
case, this function gets spin_lock only when: list_empty(&work->entry) == 1
&& _PENDING == 1 && del_timer(&dwork->timer) == 0.

> 
> > I have to look at this more, at home and, if something new, I'll write
> > tomorrow. So, the good news, is you should have enough sleep this time!
> 
> Thanks for review!

OK. Here is the review:

It looks great!!! I cannot believe, it could be so "easy"!

Regards,
Jarek P.

PS: probably unusable, but for my own satisfaction:

Acked-by: Jarek Poplawski <jarkao2@o2.pl 
