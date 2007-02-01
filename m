Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXBAAtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXBAAtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161141AbXBAAtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:49:00 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58666 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137AbXBAAs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:48:59 -0500
Date: Wed, 31 Jan 2007 16:48:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070201004849.GS2574@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu> <20070131191215.GK2574@linux.vnet.ibm.com> <20070131211340.GA171@tv-sign.ru> <1170280101.10924.36.camel@lappy> <20070131233229.GP2574@linux.vnet.ibm.com> <1170288190.10924.108.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170288190.10924.108.camel@lappy>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:03:09AM +0100, Peter Zijlstra wrote:
> On Wed, 2007-01-31 at 15:32 -0800, Paul E. McKenney wrote:
> 
> > The wakeup in barrier_sync() would mean that the counter was zero
> > at some point in the past.  The counter would then be rechecked, and
> > if it were still zero, barrier_sync() would invoke finish_wait() and
> > then return -- but the counter might well become non-zero in the
> > meantime, right?
> > 
> > So given that barrier_sync() is permitted to return after the counter
> > becomes non-zero, why can't it just rely on the fact that barrier_unlock()
> > saw it as zero not long in the past?
> > 
> > > >  It looks like barrier_sync() is more a
> > > > rw semaphore biased to readers.
> > > 
> > > Indeed, the locked sections are designed to be the rare case.
> > 
> > OK -- but barrier_sync() just waits for readers, it doesn't exclude them.
> > 
> > If all barrier_sync() needs to do is to wait until all pre-existing
> > barrier_lock()/barrier_unlock() pairs to complete, it seems to me to
> > be compatible with qrcu's semantics.
> > 
> > So what am I missing here?
> 
> I might be the one missing stuff, I'll have a hard look at qrcu.
> 
> The intent was that barrier_sync() would not write to memory when there
> are no active locked sections, so that the cacheline can stay shared,
> thus keeping is fast.
> 
> If qrcu does exactly this, then yes we have a match.

QRCU as currently written (http://lkml.org/lkml/2006/11/29/330) doesn't
do what you want, as it acquires the lock unconditionally.  I am proposing
that synchronize_qrcu() change to something like the following:

	void synchronize_qrcu(struct qrcu_struct *qp)
	{
		int idx;
	
		smp_mb();
	
		if (atomic_read(qp->ctr[0]) + atomic_read(qp->ctr[1]) <= 1) {
			smp_rmb();
			if (atomic_read(qp->ctr[0]) +
			    atomic_read(qp->ctr[1]) <= 1)
				goto out;
		}
	
		mutex_lock(&qp->mutex);
		idx = qp->completed & 0x1;
		atomic_inc(qp->ctr + (idx ^ 0x1));
		/* Reduce the likelihood that qrcu_read_lock() will loop */
		smp_mb__after_atomic_inc();
		qp->completed++;
	
		atomic_dec(qp->ctr + idx);
		__wait_event(qp->wq, !atomic_read(qp->ctr + idx));
		mutex_unlock(&qp->mutex);
	out:
		smp_mb();
	}

For the first "if" to give a false positive, a concurrent switch had
to have happened.  For example, qp->ctr[0] was zero and qp->ctr[1]
was two at the time of the first atomic_read(), but then qp->completed
switched so that both qp->ctr[0] and qp->ctr[1] were one at the time
of the second atomic_read.  The only way the second "if" can give us a
false positive is if there was another change to qp->completed in the
meantime -- but that means that all of the pre-existing qrcu_read_lock()
holders must have gotten done, otherwise the second switch could not
have happened.  Yes, you do incur three memory barriers on the fast
path, but the best you could hope for with your approach was two of them
(unless I am confused about how you were using barrier_sync()).

Oleg, does this look safe?

Ugly at best, I know, but I do very much sympathize with Christoph's
desire to keep the number of synchronization primitives down to a
dull roar.  ;-)

							Thanx, Paul
