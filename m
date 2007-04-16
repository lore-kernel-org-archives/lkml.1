Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXDPLzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXDPLzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXDPLzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:55:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbXDPLzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:55:00 -0400
Date: Mon, 16 Apr 2007 13:54:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH -mm] scheduler: fix the return of the first time_slice
Message-ID: <20070416115441.GA26177@elte.hu>
References: <877isozllw.wl%takeuchi_satoru@jp.fujitsu.com> <20070408230927.9a49c504.akpm@linux-foundation.org> <200704140131.12500.kernel@kolivas.org> <871wilrrlz.wl%takeuchi_satoru@jp.fujitsu.com> <87wt0dq6jn.wl%takeuchi_satoru@jp.fujitsu.com> <20070416104559.GA84@tv-sign.ru> <20070416114701.GB84@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416114701.GB84@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > >  	 * The remainder of the first timeslice might be recovered by
> > >  	 * the parent if the child exits early enough.
> > >  	 */
> > > -	p->first_time_slice = 1;
> > > +	p->time_slice_reaper = current;
> > >  	p->timestamp = sched_clock();
> > >  	local_irq_enable();
> > 
> > I am afraid this doesn't work for CLONE_THREAD. Suppose that some 
> > sub-thread (not main thread) T1 creates another sub-thread, T2.

> In case I was not clear...

> To make this correct, we should iterate over all thread-group, but 
> this can slow down exit() when we have a lot of threads.
> 
> I guess we need Ingo's opinion on that.

right now my first cautious estimation seems to be that we might be able 
to get rid of this whole child/parent timeslice sharing complexity and 
do all the scheduling setup without affecting the parent - hence 
avoiding all the reaper problems as well. People reported interactivity 
improvements with this removed from CFS. (It all still needs a ton of 
validation to make sure, but the trend seems to be this.)

(the only valid component of that complexity is 'child runs first' - but 
it's not really related to the timesplice splitting thing just 
intermixed with it.)

	Ingo
