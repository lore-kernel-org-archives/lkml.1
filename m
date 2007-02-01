Return-Path: <linux-kernel-owner+w=401wt.eu-S1751182AbXBAVik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbXBAVik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXBAVij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:38:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41114 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbXBAVii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:38:38 -0500
Date: Thu, 1 Feb 2007 13:38:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070201213829.GH1831@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu> <20070131191215.GK2574@linux.vnet.ibm.com> <20070131211340.GA171@tv-sign.ru> <1170280101.10924.36.camel@lappy> <20070131233229.GP2574@linux.vnet.ibm.com> <1170288190.10924.108.camel@lappy> <20070201004849.GS2574@linux.vnet.ibm.com> <20070201160010.GA121@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201160010.GA121@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 07:00:10PM +0300, Oleg Nesterov wrote:
> On 01/31, Paul E. McKenney wrote:
> > 
> > QRCU as currently written (http://lkml.org/lkml/2006/11/29/330) doesn't
> > do what you want, as it acquires the lock unconditionally.  I am proposing
> > that synchronize_qrcu() change to something like the following:
> > 
> > 	void synchronize_qrcu(struct qrcu_struct *qp)
> > 	{
> > 		int idx;
> > 	
> > 		smp_mb();
> > 	
> > 		if (atomic_read(qp->ctr[0]) + atomic_read(qp->ctr[1]) <= 1) {
> > 			smp_rmb();
> > 			if (atomic_read(qp->ctr[0]) +
> > 			    atomic_read(qp->ctr[1]) <= 1)
> > 				goto out;
> > 		}
> > 	
> > 		mutex_lock(&qp->mutex);
> > 		idx = qp->completed & 0x1;
> > 		atomic_inc(qp->ctr + (idx ^ 0x1));
> > 		/* Reduce the likelihood that qrcu_read_lock() will loop */
> > 		smp_mb__after_atomic_inc();
> > 		qp->completed++;
> > 	
> > 		atomic_dec(qp->ctr + idx);
> > 		__wait_event(qp->wq, !atomic_read(qp->ctr + idx));
> > 		mutex_unlock(&qp->mutex);
> > 	out:
> > 		smp_mb();
> > 	}
> > 
> > For the first "if" to give a false positive, a concurrent switch had
> > to have happened.  For example, qp->ctr[0] was zero and qp->ctr[1]
> > was two at the time of the first atomic_read(), but then qp->completed
> > switched so that both qp->ctr[0] and qp->ctr[1] were one at the time
> > of the second atomic_read.  The only way the second "if" can give us a
> > false positive is if there was another change to qp->completed in the
> > meantime -- but that means that all of the pre-existing qrcu_read_lock()
> > holders must have gotten done, otherwise the second switch could not
> > have happened.  Yes, you do incur three memory barriers on the fast
> > path, but the best you could hope for with your approach was two of them
> > (unless I am confused about how you were using barrier_sync()).
> 
> While doing qrcu, somehow I convinced myself we can't optimize out taking
> qp->mutex. Now I think I was wrong. Good!

Me, I didn't want to worry about it unless someone needed it.  Which
it now appears they do.  ;-)

> Q: you deleted "if (atomic_read(qp->ctr + idx) == 1)" fastpath under ->mutex,
> was this needed for this optimization to work? I am asking because I can't
> understand how it can make any difference.

Before, we held the lock, so we could just check the single current
element.  Now we don't hold the lock, so we need to check both elements.
So I replaced the "if (atomic_read(qp->ctr + idx) == 1)" with the
nested "if" statements that test both elements.

> > Oleg, does this look safe?
> 
> Yes. But let me think more about this later, I've got a fever, and can't
> think properly today :)

Get well!!!  ;-)

And yes, the concurrency on the fastpath is nontrivial...

							Thanx, Paul
