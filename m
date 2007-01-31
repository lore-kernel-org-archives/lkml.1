Return-Path: <linux-kernel-owner+w=401wt.eu-S1030586AbXAaVsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586AbXAaVsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXAaVsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:48:33 -0500
Received: from amsfep19-int.chello.nl ([213.46.243.16]:51765 "EHLO
	amsfep11-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030586AbXAaVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:48:32 -0500
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070131211340.GA171@tv-sign.ru>
References: <20070128115118.837777000@programming.kicks-ass.net>
	 <20070128120509.719287000@programming.kicks-ass.net>
	 <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu>
	 <20070131191215.GK2574@linux.vnet.ibm.com>
	 <20070131211340.GA171@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 22:48:21 +0100
Message-Id: <1170280101.10924.36.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 00:13 +0300, Oleg Nesterov wrote:
> On 01/31, Paul E. McKenney wrote:
> >
> > On Sun, Jan 28, 2007 at 04:24:35PM +0100, Ingo Molnar wrote:
> > > 
> > > * Christoph Hellwig <hch@infradead.org> wrote:
> > > 
> > > > On Sun, Jan 28, 2007 at 12:51:21PM +0100, Peter Zijlstra wrote:
> > > > > This barrier thing is constructed so that it will not write in the 
> > > > > sync() condition (the hot path) when there are no active lock 
> > > > > sections; thus avoiding cacheline bouncing. -- I'm just not sure how 
> > > > > this will work out in relation to PI. We might track those in the 
> > > > > barrier scope and boost those by the max prio of the blockers.
> > > > 
> > > > Is this really needed?  We seem to grow new funky locking algorithms 
> > > > exponentially, while people already have a hard time understanding the 
> > > > existing ones.
> > > 
> > > yes, it's needed.
> > 
> > Would it be possible to come up with something common between this primitive
> > and the one that Oleg Nesterov put together for Jens Axboe?
> > 
> > 	http://lkml.org/lkml/2006/11/29/330
> > 
> > Oleg's approach acquires a lock on the update side, which Peter would
> > not want in the uncontended case -- but perhaps there is some way to
> > make Oleg's approach be able to safely test both counters so as to
> > avoid acquiring the lock if there are no readers.
> > 
> > Oleg, any chance of this working?  I believe it does, but have not
> > thought it through fully.
> 
> I think no. From the quick reading, barrier_sync() and qrcu/srcu are
> quite different. Consider:
> 
> barrier_lock()
> 
> 				barrier_sync();
> 
> barrier_unlock();
> 				... wake up ...
> 							barrier_lock();
> 
> 				schedule again
> 
> The last "schedule again" would be a BUG for qrcu/srcu, but probably
> it is ok for barrier_sync().

Yes, that would be ok.

>  It looks like barrier_sync() is more a
> rw semaphore biased to readers.

Indeed, the locked sections are designed to be the rare case.

> A couple of minor off-topic notes,
> 
> +static inline void barrier_unlock(struct barrier *b)
> +{
> +       smp_wmb();
> +       if (atomic_dec_and_test(&b->count))
> +               __wake_up(&b->wait, TASK_INTERRUPTIBLE|TASK_UNINTERRUPTIBLE, 0, b);
> 
> This is wake_up_all(&b->wait), yes? I don't undestans why key == b, it could be NULL.
> 
> +static inline void barrier_sync(struct barrier *b)
> +{
> +       might_sleep();
> +
> +       if (unlikely(atomic_read(&b->count))) {
> +               DEFINE_WAIT(wait);
> +               prepare_to_wait(&b->wait, &wait, TASK_UNINTERRUPTIBLE);
> +               while (atomic_read(&b->count))
> +                       schedule();
> +               finish_wait(&b->wait, &wait);
> +       }
> +}
> 
> This should be open-coded wait_event(), but wrong! With the scenario above this
> can hang forever! because the first wake_up removes the task from the &b->wait.

This would be me struggling with the waitqueue API, its all a tad
confusing at first look.

