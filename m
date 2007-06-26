Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbXFZOxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbXFZOxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbXFZOxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:53:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46842 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbXFZOxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:53:13 -0400
Date: Tue, 26 Jun 2007 07:53:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Uli Luckas <u.luckas@road.de>,
       linux-kernel@vger.kernel.org
Subject: Re: synchronize_qrcu_timeout()
Message-ID: <20070626145308.GA8929@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070625104332.GA147@tv-sign.ru> <20070625145851.GB12976@linux.vnet.ibm.com> <20070625152011.GA160@tv-sign.ru> <20070625154957.GA197@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625154957.GA197@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 07:49:57PM +0400, Oleg Nesterov wrote:
> On 06/25, Oleg Nesterov wrote:
> >
> > On 06/25, Paul E. McKenney wrote:
> > >
> > > On Mon, Jun 25, 2007 at 02:43:32PM +0400, Oleg Nesterov wrote:
> > > > 
> > > > Sadly, you can't use srcu/qrcu because it doesn't handle timeouts.	
> > > 
> > > Interesting...  So the thought is to have a synchronize_srcu_timeout()
> > > or something similar that waited for a grace period to elapse or for
> > > a timeout to expire, whichever comes first?  It should not be too hard
> > > to arrange something, if needed.
> > 
> > Yes. As for qrcu (see http://marc.info/?t=116484476500001), I think it is easy.
> > First, we add "int interrupted" into struct qrcu_struct, then something like this
> 
> Even simpler, we don't need ->interrupted.

I have to ask...

What sorts of performance characteristics are needed here?  The reason
that I ask is because putting a straight synchronize_qrcu() into a
workqueue (or something similar) and then using a timer to provide
any needed wakeup seems a lot simpler than rearranging the innards of
synchronize_qrcu().

(Yes, I am feeling cowardly.  Why do you ask?)

						Thanx, Paul

> 	long synchronize_qrcu_timeout(struct qrcu_struct *qp, long tout)
> 	{
> 		int idx, prv;
> 
> 		smp_mb();
> 		mutex_lock(&qp->mutex);
> 
> 		idx = qp->completed & 0x1;
> 		prv = idx ^ 0x1;
> 
> 		if (unlikely(atomic_read(qp->ctr + prv))) {
> 			// the previous call has not succeed,
> 			// finish the wait
> 			__wait_event_timeout(qp->wq, !atomic_read(qp->ctr + prv), tout);
> 			if (unlikely(!tout))
> 				goto out;
> 		}
> 
> 		if (atomic_read(qp->ctr + idx) == 1)
> 			goto out;
> 
> 		atomic_inc(qp->ctr + prv);
> 		qp->completed++;
> 
> 		atomic_dec(qp->ctr + idx);
> 		__wait_event_timeout(qp->wq, !atomic_read(qp->ctr + idx), tout);
> 	out:
> 		mutex_unlock(&qp->mutex);
> 		smp_mb();
> 
> 		return tout;
> 	}
> 
> Oleg.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
