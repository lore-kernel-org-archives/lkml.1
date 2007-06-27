Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbXF0Upa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbXF0Upa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXF0UpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:45:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277AbXF0UpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:45:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: synchronize_qrcu_timeout()
Date: Wed, 27 Jun 2007 22:52:14 +0200
User-Agent: KMail/1.9.5
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Uli Luckas <u.luckas@road.de>,
       linux-kernel@vger.kernel.org
References: <20070625104332.GA147@tv-sign.ru> <20070626145308.GA8929@linux.vnet.ibm.com> <20070627111831.GA108@tv-sign.ru>
In-Reply-To: <20070627111831.GA108@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272252.15495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 June 2007 13:18, Oleg Nesterov wrote:
> On 06/26, Paul E. McKenney wrote:
> >
> > On Mon, Jun 25, 2007 at 07:49:57PM +0400, Oleg Nesterov wrote:
> > > On 06/25, Oleg Nesterov wrote:
> > > >
> > > > On 06/25, Paul E. McKenney wrote:
> > > > >
> > > > > On Mon, Jun 25, 2007 at 02:43:32PM +0400, Oleg Nesterov wrote:
> > > > > > 
> > > > > > Sadly, you can't use srcu/qrcu because it doesn't handle timeouts.	
> > > > > 
> > > > > Interesting...  So the thought is to have a synchronize_srcu_timeout()
> > > > > or something similar that waited for a grace period to elapse or for
> > > > > a timeout to expire, whichever comes first?  It should not be too hard
> > > > > to arrange something, if needed.
> > > > 
> > > > Yes. As for qrcu (see http://marc.info/?t=116484476500001), I think it is easy.
> > > > First, we add "int interrupted" into struct qrcu_struct, then something like this
> > > 
> > > Even simpler, we don't need ->interrupted.
> > 
> > I have to ask...
> > 
> > What sorts of performance characteristics are needed here?  The reason
> > that I ask is because putting a straight synchronize_qrcu() into a
> > workqueue (or something similar) and then using a timer to provide
> > any needed wakeup seems a lot simpler than rearranging the innards of
> > synchronize_qrcu().
> 
> Didn't think about that... But yes, we can implement synchronize_qrcu_timeout()
> on top of synchronize_qrcu() as you suggested. Hovewer, this implementation
> will add more code to .text compared to changing synchronize_qrcu().
> 
> Note also that we can't share the "context" of synchronize_qrcu_timeout() in
> that case. Each caller of synchronize_qrcu_timeout() needs a separate
> wait_queue_head_t + work_struct. This context can't live on stack, because
> it should survive after the timeout.
> 
> 
> If we change synchronize_qrcu() instead, we only add
> 
>  		if (unlikely(atomic_read(qp->ctr + prv))) {
>  			__wait_event_timeout(qp->wq, !atomic_read(qp->ctr + prv), tout);
>  			if (unlikely(!tout))
>  				goto out;
>  		}
> 
> to the slow path. This has nearly zero perfomance penalty. Yes, we have
> to wait if the previous call was interrupted by timeout. But in that case
> we lost nothing, we spend the same time waiting for qp->mutex when the
> previous call succeeds.
> 
> 
> That said, I am not sure synchronize_Xrcu_timeout() is terribly useful.
> Rafael could use it, but it is not better for this particular case.
> Except the code re-use, which is always good.

Well, if there are more cases in which it's useful, we'll be able to modify
this code to use it too in the future.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
