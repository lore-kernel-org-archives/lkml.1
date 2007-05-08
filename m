Return-Path: <linux-kernel-owner+w=401wt.eu-S967449AbXEHNBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967449AbXEHNBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967414AbXEHNBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:01:31 -0400
Received: from mx10.go2.pl ([193.17.41.74]:36807 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967370AbXEHNBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:01:30 -0400
Date: Tue, 8 May 2007 15:07:48 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make-cancel_rearming_delayed_work-reliable-fix
Message-ID: <20070508130748.GF1772@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru> <20070503181513.0b0aa4fb.akpm@linux-foundation.org> <20070505213213.GA1013@tv-sign.ru> <20070507103107.GD1754@ff.dom.local> <20070507103420.GA74@tv-sign.ru> <20070508091601.GB1772@ff.dom.local> <20070508120221.GA968@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508120221.GA968@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:02:21PM +0400, Oleg Nesterov wrote:
> On 05/08, Jarek Poplawski wrote:
> >
> > On Mon, May 07, 2007 at 02:34:20PM +0400, Oleg Nesterov wrote:
> > > On 05/07, Jarek Poplawski wrote:
...
> I am strongly against adding many different variants of cancel_xxx().
> With this patch the API is simple
> 
> 	- cancel_delayed_work() stops the timer
> 
> 	- cancel_rearming_delayed_work() stops the timer and work,
> 	  doesn't need cancel_work_sync/flush_workqueue

But most often there is a simple rearming (but not neccessarily
always) work for which the first is not enough and the second
an overkill (especially with system/workqueues loaded).

> When work->func() re-arms itself, both queue_work() and queue_delayed_work()
> may change CPU if CPU_DOWN_xxx happens. Note that this is possible
> even if we use freezer for cpu-hotplug, because the timer migrates to
> another CPU anyway.

Thanks for explanation - I try to think about this.
 
> >                                I'm not sure what exactly place
> > did you mean - if spinlocking in wait_on_work - maybe it's
> > a sign this place isn't optimal too: it seems to me, this all
> > inserting/waiting for completion could be done under existing
> > locks e.g. in run_workqueue (maybe with some flag?).
> 
> Sorry, can't understand this. Inserting uses existing lock, namely
> cwq->lock.

I meant held locks - maybe e.g. after seeing some flag set (or some
other global/per_cpu/atomic/whatever variable) in a processed work
insert_wq_barrier could be done in already locked place. Or maybe
the whole idea of these completions should be rethinked, for
something lighter (i.e. lockless)?

> 
> Just in case, I think wait_on_cpu_work() can check ->current_work without
> cwq->lock, but I am not sure yet. We can remove unneeded "new |= " from
> set_wq_data(), we can do a couple of other optimizations. However, there
> are already _a lot_ of workqueue changes in -mm tree. We can do this later.
> Right now my only concern is correctness.

I agree 100% - it's -mm, the old way is working, so why hurry?

Jarek P.
