Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXD0Hwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXD0Hwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXD0Hwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:52:49 -0400
Received: from mail.screens.ru ([213.234.233.54]:34938 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbXD0Hwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:52:47 -0400
Date: Fri, 27 Apr 2007 11:52:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070427075247.GB106@tv-sign.ru>
References: <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local> <20070425124714.GA94@tv-sign.ru> <20070425144759.GA201@tv-sign.ru> <20070426125918.GC3145@ff.dom.local> <20070426163406.GA1933@tv-sign.ru> <20070427052618.GA997@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427052618.GA997@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Jarek Poplawski wrote:
>
> On Thu, Apr 26, 2007 at 08:34:06PM +0400, Oleg Nesterov wrote:
> > > 
> > > > 			else if (test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
> > > > 				done = del_timer(&dwork->timer)
> > > 
> > [...snip...]
> > >                                  It is something alike to the current
> > > way, with some added measures: you try to shoot a work on the run,
> > > while queued or timer_pending, plus the _PENDING flag set, so it seems,
> > > there is some risk of longer than planed looping.
> > 
> > Sorry, can't understand. done == 0 means that the queueing in progress,
> > this work should be placed on cwq->worklist very soon, most probably
> > right after we drop cwq->lock.
> 
> I think, theoretically, probably, maybe, there is possible some strange
> case, this function gets spin_lock only when: list_empty(&work->entry) == 1
> && _PENDING == 1 && del_timer(&dwork->timer) == 0.

Yes, but this is not so strange, this means the queueing in progress. Most
probably the "owner" of WORK_STRUCT_PENDING bit spins waiting for cwq->lock.
We will retry in this case. Of course, if we have a workqueue with the single
work which just re-arms itself via queue_work() (without delay) and does nothing
more, we may need a lot of looping.

> PS: probably unusable, but for my own satisfaction:
> 
> Acked-by: Jarek Poplawski <jarkao2@o2.pl>

It is useable, at least for me. I hope you will re-ack when I actually send
the patch. Note that the "else" branch above doesn't need cwq->lock, and we
should start with del_timer(), because the pending timer is the most common
case.

Oleg.

