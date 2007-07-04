Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbXGDMvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbXGDMvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXGDMvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:51:24 -0400
Received: from mail.screens.ru ([213.234.233.54]:41230 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328AbXGDMvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:51:23 -0400
Date: Wed, 4 Jul 2007 16:52:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070704125219.GA98@tv-sign.ru>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4> <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg> <20070703173112.GA108@tv-sign.ru> <1183549772.3812.10.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183549772.3812.10.camel@johannes.berg>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04, Johannes Berg wrote:
> 
> On Tue, 2007-07-03 at 21:31 +0400, Oleg Nesterov wrote:
> 
> > If A does NOT take a lock L1, then it is OK to do cancel_work_sync(A)
> > under L1, regardless of which other work_structs this workqueue has,
> > before or after A.
> 
> Ah, cancel_work_sync() waits only for it if A is currently running?

Yes. And no other work (except a barrier) can run before the caller of
wait_on_work() is woken.

> > Now we have a false positive if some time we queue B into that workqueue,
> > and this is not good.
> 
> Right. I was thinking of the flush_workqueue case where any of A or B
> matters.

Aha, now I see where I was confused. Yes, we can't avoid the false positives
with flush_workqueue().

I hope this won't be a problem, because almost every usage of flush_workqueue()
is pointless nowadays. So even if we have a false positive, it probably
means the code needs cleanups anyway.

But see below,

> > We can avoid this problem if we put lockdep_map into work_struct, so
> > that wait_on_work() "locks" work->lockdep_map, while flush_workqueue()
> > takes wq->lockdep_map.
> 
> Yeah, and then we'll take both wq->lockdep_map and the
> work_struct->lockdep_map when running that work. That should work, I'll
> give it a go later.

If you are going to do this, may I suggest you to make 2 separate patches?
Exactly because we can't avoid the false positives with flush_workqueue(),
it would be nice if we have an option to revert the 2-nd patch if there are
too many false positives (I hope this won't happen).

(please ignore if this is not suitable for you).

> > > @@ -257,7 +260,9 @@ static void run_workqueue(struct cpu_wor
> > >
> > >  		BUG_ON(get_wq_data(work) != cwq);
> > >  		work_clear_pending(work);
> > > +		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> > >  		f(work);
> > > +		lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
> >                                                    ^^^
> > Isn't it better to call lock_release() with nested == 1 ?
> 
> Not sure, Ingo?

Ingo, could you also explain the meaning of "nested" parameter? Looks
like it is just unneeded, lock_release_nested() does a quick check
and use lock_release_non_nested() when hlock is not on top of stack.

Oleg.

