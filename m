Return-Path: <linux-kernel-owner+w=401wt.eu-S1946495AbXBCQjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946495AbXBCQjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 11:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946496AbXBCQjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 11:39:25 -0500
Received: from mail.screens.ru ([213.234.233.54]:60267 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946495AbXBCQjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 11:39:25 -0500
Date: Sat, 3 Feb 2007 19:38:50 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070203163850.GA675@tv-sign.ru>
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

I almost forgot. Currently this smp_mb__after_atomic_inc() is not strictly
needed, and the comment is correct. However, it becomes mandatory with your
optimization. Without this barrier, it is possible that both checks above
mutex_lock() will see the result of atomic_dec(), but not the atomic_inc().

So, may I ask you to also update this comment?

	/*
	 * Reduce the likelihood that qrcu_read_lock() will loop
	 *	AND
	 * make sure the second re-check above will see the result
	 * of atomic_inc() if it sees the result of atomic_dec()
	 */

Something like this, I hope you will make it better.

And another note: this all assumes that STORE-MB-LOAD works "correctly", yes?
We have other code which relies on that, should not be a problem.

(Alan Stern cc'ed).

Oleg.

