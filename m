Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbXF0LSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbXF0LSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbXF0LSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:18:11 -0400
Received: from mail.screens.ru ([213.234.233.54]:52270 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbXF0LSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:18:10 -0400
Date: Wed, 27 Jun 2007 15:18:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Uli Luckas <u.luckas@road.de>,
       linux-kernel@vger.kernel.org
Subject: Re: synchronize_qrcu_timeout()
Message-ID: <20070627111831.GA108@tv-sign.ru>
References: <20070625104332.GA147@tv-sign.ru> <20070625145851.GB12976@linux.vnet.ibm.com> <20070625152011.GA160@tv-sign.ru> <20070625154957.GA197@tv-sign.ru> <20070626145308.GA8929@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626145308.GA8929@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Paul E. McKenney wrote:
>
> On Mon, Jun 25, 2007 at 07:49:57PM +0400, Oleg Nesterov wrote:
> > On 06/25, Oleg Nesterov wrote:
> > >
> > > On 06/25, Paul E. McKenney wrote:
> > > >
> > > > On Mon, Jun 25, 2007 at 02:43:32PM +0400, Oleg Nesterov wrote:
> > > > > 
> > > > > Sadly, you can't use srcu/qrcu because it doesn't handle timeouts.	
> > > > 
> > > > Interesting...  So the thought is to have a synchronize_srcu_timeout()
> > > > or something similar that waited for a grace period to elapse or for
> > > > a timeout to expire, whichever comes first?  It should not be too hard
> > > > to arrange something, if needed.
> > > 
> > > Yes. As for qrcu (see http://marc.info/?t=116484476500001), I think it is easy.
> > > First, we add "int interrupted" into struct qrcu_struct, then something like this
> > 
> > Even simpler, we don't need ->interrupted.
> 
> I have to ask...
> 
> What sorts of performance characteristics are needed here?  The reason
> that I ask is because putting a straight synchronize_qrcu() into a
> workqueue (or something similar) and then using a timer to provide
> any needed wakeup seems a lot simpler than rearranging the innards of
> synchronize_qrcu().

Didn't think about that... But yes, we can implement synchronize_qrcu_timeout()
on top of synchronize_qrcu() as you suggested. Hovewer, this implementation
will add more code to .text compared to changing synchronize_qrcu().

Note also that we can't share the "context" of synchronize_qrcu_timeout() in
that case. Each caller of synchronize_qrcu_timeout() needs a separate
wait_queue_head_t + work_struct. This context can't live on stack, because
it should survive after the timeout.


If we change synchronize_qrcu() instead, we only add

 		if (unlikely(atomic_read(qp->ctr + prv))) {
 			__wait_event_timeout(qp->wq, !atomic_read(qp->ctr + prv), tout);
 			if (unlikely(!tout))
 				goto out;
 		}

to the slow path. This has nearly zero perfomance penalty. Yes, we have
to wait if the previous call was interrupted by timeout. But in that case
we lost nothing, we spend the same time waiting for qp->mutex when the
previous call succeeds.


That said, I am not sure synchronize_Xrcu_timeout() is terribly useful.
Rafael could use it, but it is not better for this particular case.
Except the code re-use, which is always good.

Oleg.

