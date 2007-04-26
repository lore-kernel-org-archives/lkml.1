Return-Path: <linux-kernel-owner+w=401wt.eu-S1031368AbXDZR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031368AbXDZR2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXDZR2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:28:41 -0400
Received: from mail.screens.ru ([213.234.233.54]:41661 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbXDZR2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:28:40 -0400
Date: Thu, 26 Apr 2007 20:34:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070426163406.GA1933@tv-sign.ru>
References: <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local> <20070425124714.GA94@tv-sign.ru> <20070425144759.GA201@tv-sign.ru> <20070426125918.GC3145@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426125918.GC3145@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Jarek Poplawski wrote:
>
> > 	void cancel_rearming_delayed_work(struct delayed_work *dwork)
> > 	{
> > 		struct work_struct *work = &dwork->work;
> > 		struct cpu_workqueue_struct *cwq = get_wq_data(work);
> > 		int done;
> 
> I don't understand, why you think cwq cannot be NULL here.

sure it can, this is just a template.

> > 
> > 		do {
> > 			done = 1;
> > 			spin_lock_irq(&cwq->lock);
> > 
> > 			if (!list_empty(&work->entry))
> > 				list_del_init(&work->entry);
> 
> BTW, isn't needs_a_good_name needles after this and after del_timer positive?

no, we still need it. work->func() may be running on another CPU as well.

> 
> > 			else if (test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
> > 				done = del_timer(&dwork->timer)
> 
> If this runs while a work function is fired in run_workqueue,
> it sets _PENDING bit, but if the work skips rearming, we have probably
> endless loop, again.

No, if the work skips rearming (or didn't yet), we set WORK_STRUCT_PENDING
successfully.

>                                  It is something alike to the current
> way, with some added measures: you try to shoot a work on the run,
> while queued or timer_pending, plus the _PENDING flag set, so it seems,
> there is some risk of longer than planed looping.

Sorry, can't understand. done == 0 means that the queueing in progress,
this work should be placed on cwq->worklist very soon, most probably
right after we drop cwq->lock.

> I have to look at this more, at home and, if something new, I'll write
> tomorrow. So, the good news, is you should have enough sleep this time!

Thanks for review!

Oleg.

