Return-Path: <linux-kernel-owner+w=401wt.eu-S1161081AbXAaXcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161081AbXAaXcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161080AbXAaXcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:32:41 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60687 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161081AbXAaXck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:32:40 -0500
Date: Wed, 31 Jan 2007 15:32:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070131233229.GP2574@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu> <20070131191215.GK2574@linux.vnet.ibm.com> <20070131211340.GA171@tv-sign.ru> <1170280101.10924.36.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170280101.10924.36.camel@lappy>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 10:48:21PM +0100, Peter Zijlstra wrote:
> On Thu, 2007-02-01 at 00:13 +0300, Oleg Nesterov wrote:
> > On 01/31, Paul E. McKenney wrote:
> > > On Sun, Jan 28, 2007 at 04:24:35PM +0100, Ingo Molnar wrote:
> > > > * Christoph Hellwig <hch@infradead.org> wrote:
> > > > > On Sun, Jan 28, 2007 at 12:51:21PM +0100, Peter Zijlstra wrote:
> > > > > > This barrier thing is constructed so that it will not write in the 
> > > > > > sync() condition (the hot path) when there are no active lock 
> > > > > > sections; thus avoiding cacheline bouncing. -- I'm just not sure how 
> > > > > > this will work out in relation to PI. We might track those in the 
> > > > > > barrier scope and boost those by the max prio of the blockers.
> > > > > 
> > > > > Is this really needed?  We seem to grow new funky locking algorithms 
> > > > > exponentially, while people already have a hard time understanding the 
> > > > > existing ones.
> > > > 
> > > > yes, it's needed.
> > > 
> > > Would it be possible to come up with something common between this primitive
> > > and the one that Oleg Nesterov put together for Jens Axboe?
> > > 
> > > 	http://lkml.org/lkml/2006/11/29/330
> > > 
> > > Oleg's approach acquires a lock on the update side, which Peter would
> > > not want in the uncontended case -- but perhaps there is some way to
> > > make Oleg's approach be able to safely test both counters so as to
> > > avoid acquiring the lock if there are no readers.
> > > 
> > > Oleg, any chance of this working?  I believe it does, but have not
> > > thought it through fully.
> > 
> > I think no. From the quick reading, barrier_sync() and qrcu/srcu are
> > quite different. Consider:
> > 
> > barrier_lock()
> > 
> > 				barrier_sync();
> > 
> > barrier_unlock();
> > 				... wake up ...
> > 							barrier_lock();
> > 
> > 				schedule again
> > 
> > The last "schedule again" would be a BUG for qrcu/srcu, but probably
> > it is ok for barrier_sync().
> 
> Yes, that would be ok.

The wakeup in barrier_sync() would mean that the counter was zero
at some point in the past.  The counter would then be rechecked, and
if it were still zero, barrier_sync() would invoke finish_wait() and
then return -- but the counter might well become non-zero in the
meantime, right?

So given that barrier_sync() is permitted to return after the counter
becomes non-zero, why can't it just rely on the fact that barrier_unlock()
saw it as zero not long in the past?

> >  It looks like barrier_sync() is more a
> > rw semaphore biased to readers.
> 
> Indeed, the locked sections are designed to be the rare case.

OK -- but barrier_sync() just waits for readers, it doesn't exclude them.

If all barrier_sync() needs to do is to wait until all pre-existing
barrier_lock()/barrier_unlock() pairs to complete, it seems to me to
be compatible with qrcu's semantics.

So what am I missing here?

							Thanx, Paul

> > A couple of minor off-topic notes,
> > 
> > +static inline void barrier_unlock(struct barrier *b)
> > +{
> > +       smp_wmb();
> > +       if (atomic_dec_and_test(&b->count))
> > +               __wake_up(&b->wait, TASK_INTERRUPTIBLE|TASK_UNINTERRUPTIBLE, 0, b);
> > 
> > This is wake_up_all(&b->wait), yes? I don't undestans why key == b, it could be NULL.
> > 
> > +static inline void barrier_sync(struct barrier *b)
> > +{
> > +       might_sleep();
> > +
> > +       if (unlikely(atomic_read(&b->count))) {
> > +               DEFINE_WAIT(wait);
> > +               prepare_to_wait(&b->wait, &wait, TASK_UNINTERRUPTIBLE);
> > +               while (atomic_read(&b->count))
> > +                       schedule();
> > +               finish_wait(&b->wait, &wait);
> > +       }
> > +}
> > 
> > This should be open-coded wait_event(), but wrong! With the scenario above this
> > can hang forever! because the first wake_up removes the task from the &b->wait.
> 
> This would be me struggling with the waitqueue API, its all a tad
> confusing at first look.
> 
