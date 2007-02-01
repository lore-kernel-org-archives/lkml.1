Return-Path: <linux-kernel-owner+w=401wt.eu-S1422656AbXBAQAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656AbXBAQAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422665AbXBAQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:00:47 -0500
Received: from mail.screens.ru ([213.234.233.54]:56549 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422656AbXBAQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:00:46 -0500
Date: Thu, 1 Feb 2007 19:00:10 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070201160010.GA121@tv-sign.ru>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu> <20070131191215.GK2574@linux.vnet.ibm.com> <20070131211340.GA171@tv-sign.ru> <1170280101.10924.36.camel@lappy> <20070131233229.GP2574@linux.vnet.ibm.com> <1170288190.10924.108.camel@lappy> <20070201004849.GS2574@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201004849.GS2574@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Paul E. McKenney wrote:
> 
> QRCU as currently written (http://lkml.org/lkml/2006/11/29/330) doesn't
> do what you want, as it acquires the lock unconditionally.  I am proposing
> that synchronize_qrcu() change to something like the following:
> 
> 	void synchronize_qrcu(struct qrcu_struct *qp)
> 	{
> 		int idx;
> 	
> 		smp_mb();
> 	
> 		if (atomic_read(qp->ctr[0]) + atomic_read(qp->ctr[1]) <= 1) {
> 			smp_rmb();
> 			if (atomic_read(qp->ctr[0]) +
> 			    atomic_read(qp->ctr[1]) <= 1)
> 				goto out;
> 		}
> 	
> 		mutex_lock(&qp->mutex);
> 		idx = qp->completed & 0x1;
> 		atomic_inc(qp->ctr + (idx ^ 0x1));
> 		/* Reduce the likelihood that qrcu_read_lock() will loop */
> 		smp_mb__after_atomic_inc();
> 		qp->completed++;
> 	
> 		atomic_dec(qp->ctr + idx);
> 		__wait_event(qp->wq, !atomic_read(qp->ctr + idx));
> 		mutex_unlock(&qp->mutex);
> 	out:
> 		smp_mb();
> 	}
> 
> For the first "if" to give a false positive, a concurrent switch had
> to have happened.  For example, qp->ctr[0] was zero and qp->ctr[1]
> was two at the time of the first atomic_read(), but then qp->completed
> switched so that both qp->ctr[0] and qp->ctr[1] were one at the time
> of the second atomic_read.  The only way the second "if" can give us a
> false positive is if there was another change to qp->completed in the
> meantime -- but that means that all of the pre-existing qrcu_read_lock()
> holders must have gotten done, otherwise the second switch could not
> have happened.  Yes, you do incur three memory barriers on the fast
> path, but the best you could hope for with your approach was two of them
> (unless I am confused about how you were using barrier_sync()).

While doing qrcu, somehow I convinced myself we can't optimize out taking
qp->mutex. Now I think I was wrong. Good!

Q: you deleted "if (atomic_read(qp->ctr + idx) == 1)" fastpath under ->mutex,
was this needed for this optimization to work? I am asking because I can't
understand how it can make any difference.

> Oleg, does this look safe?

Yes. But let me think more about this later, I've got a fever, and can't
think properly today :)

Oleg.

