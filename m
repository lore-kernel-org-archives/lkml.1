Return-Path: <linux-kernel-owner+w=401wt.eu-S1945972AbXBBRNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945972AbXBBRNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 12:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945969AbXBBRNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 12:13:12 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41067 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945979AbXBBRNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 12:13:11 -0500
Date: Fri, 2 Feb 2007 09:13:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070202171301.GD4732@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070128152435.GC9196@elte.hu> <20070131191215.GK2574@linux.vnet.ibm.com> <20070131211340.GA171@tv-sign.ru> <1170280101.10924.36.camel@lappy> <20070131233229.GP2574@linux.vnet.ibm.com> <1170288190.10924.108.camel@lappy> <20070201004849.GS2574@linux.vnet.ibm.com> <20070201160010.GA121@tv-sign.ru> <20070201213829.GH1831@linux.vnet.ibm.com> <20070202115612.GA106@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202115612.GA106@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 02:56:12PM +0300, Oleg Nesterov wrote:
> On 02/01, Paul E. McKenney wrote:
> > > > 
> > > > 	void synchronize_qrcu(struct qrcu_struct *qp)
> > > > 	{
> > > > 		int idx;
> > > > 	
> > > > 		smp_mb();
> > > > 	
> > > > 		if (atomic_read(qp->ctr[0]) + atomic_read(qp->ctr[1]) <= 1) {
> > > > 			smp_rmb();
> > > > 			if (atomic_read(qp->ctr[0]) +
> > > > 			    atomic_read(qp->ctr[1]) <= 1)
> > > > 				goto out;
> > > > 		}
> > > > 	
> > > > 		mutex_lock(&qp->mutex);
> > > > 		idx = qp->completed & 0x1;
> > > > 		atomic_inc(qp->ctr + (idx ^ 0x1));
> > > > 		/* Reduce the likelihood that qrcu_read_lock() will loop */
> > > > 		smp_mb__after_atomic_inc();
> > > > 		qp->completed++;
> > > > 	
> > > > 		atomic_dec(qp->ctr + idx);
> > > > 		__wait_event(qp->wq, !atomic_read(qp->ctr + idx));
> > > > 		mutex_unlock(&qp->mutex);
> > > > 	out:
> > > > 		smp_mb();
> > > > 	}
> > > > 
> > > > For the first "if" to give a false positive, a concurrent switch had
> > > > to have happened.  For example, qp->ctr[0] was zero and qp->ctr[1]
> > > > was two at the time of the first atomic_read(), but then qp->completed
> > > > switched so that both qp->ctr[0] and qp->ctr[1] were one at the time
> > > > of the second atomic_read.  The only way the second "if" can give us a
> > > > false positive is if there was another change to qp->completed in the
> > > > meantime -- but that means that all of the pre-existing qrcu_read_lock()
> > > > holders must have gotten done, otherwise the second switch could not
> > > > have happened.  Yes, you do incur three memory barriers on the fast
> > > > path, but the best you could hope for with your approach was two of them
> > > > (unless I am confused about how you were using barrier_sync()).
> 
> Yes. Without synchronize_qrcu() in between, one of the counters should be == 0,
> another >= 1. == 1 means we have no active readers. So the false positive really
> means a concurrent switch. And we can check twice - excellent idea!

Well, if it ends up really working.  ;-)

This one needs more than just testing -- I will put together a Promela
model that does a full state-space search for races.

I do have one fall-back, namely putting both counters into a single
aligned long.  But I would like to avoid this, since there might be
architectures out there that cannot cleanly store into half-longs.
Such architectures would have to use atomic ops.  :-/

> > > While doing qrcu, somehow I convinced myself we can't optimize out taking
> > > qp->mutex. Now I think I was wrong. Good!
> > 
> > Me, I didn't want to worry about it unless someone needed it.  Which
> > it now appears they do.  ;-)
> 
> No. I do remember I tried hard to optimize out taking qp->mutex, but failed.
> So I decided it is not possible. And now you show that I just don't have enough
> brains! (of course, I hate you :)

Coming from you, that is high praise indeed!!!  ;-)

Now if it really does work...

> > > Q: you deleted "if (atomic_read(qp->ctr + idx) == 1)" fastpath under ->mutex,
> > > was this needed for this optimization to work? I am asking because I can't
> > > understand how it can make any difference.
> > 
> > Before, we held the lock, so we could just check the single current
> > element.  Now we don't hold the lock, so we need to check both elements.
> > So I replaced the "if (atomic_read(qp->ctr + idx) == 1)" with the
> > nested "if" statements that test both elements.
> 
> Ah, my question was different. The current version of qrcu does
> 
> 	mutex_lock(&qp->mutex);
> 
> 	idx = qp->completed & 0x1;
> 	if (atomic_read(qp->ctr + idx) == 1)	// fast path
> 		return;
> 
> 	...
> 
> and it seems to me that we can retain this fastpath even with your optimization,
> no? Surely, it is not so important, but it is nearly free.

Ah!  This does make sense, excellent point!!!

> Paul, could you make a patch? (I'll do rcutorture test tomorrow, but I only have
> P-4 ht).

I will do the Promela model, and if that works, I will submit a patch.

						Thanx, Paul

> Peter, do you think you can use qrcu?
> 
> Oleg.
> 
