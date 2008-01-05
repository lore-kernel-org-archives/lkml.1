Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbYAEVhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbYAEVhU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYAEVhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:37:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47761 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbYAEVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:37:07 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 5 Jan 2008 13:35:25 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Christian Kujau <lists@nerdbynature.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Johannes Berg <johannes@sipsolutions.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.24-rc6: possible recursive locking detected
In-Reply-To: <1199552476.31975.45.camel@lappy>
Message-ID: <Pine.LNX.4.64.0801051242070.3896@alien.or.mcafeemobile.com>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de> 
 <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu> 
 <20080105071205.GA28936@gondor.apana.org.au>  <1199552016.31975.41.camel@lappy>
 <1199552476.31975.45.camel@lappy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008, Peter Zijlstra wrote:

> 
> On Sat, 2008-01-05 at 17:53 +0100, Peter Zijlstra wrote:
> > On Sat, 2008-01-05 at 18:12 +1100, Herbert Xu wrote:
> > > On Fri, Jan 04, 2008 at 09:30:49AM +0100, Ingo Molnar wrote:
> > > >
> > > > > > [ 1310.670986] =============================================
> > > > > > [ 1310.671690] [ INFO: possible recursive locking detected ]
> > > > > > [ 1310.672097] 2.6.24-rc6 #1
> > > > > > [ 1310.672421] ---------------------------------------------
> > > > > > [ 1310.672828] FahCore_a0.exe/3692 is trying to acquire lock:
> > > > > > [ 1310.673238]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > > > > > [ 1310.673869]
> > > > > > [ 1310.673870] but task is already holding lock:
> > > > > > [ 1310.674567]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > > > > > [ 1310.675267]
> > > > > > [ 1310.675268] other info that might help us debug this:
> > > > > > [ 1310.675952] 5 locks held by FahCore_a0.exe/3692:
> > > > > > [ 1310.676334]  #0:  (rcu_read_lock){..--}, at: [<c038b620>] net_rx_action+0x60/0x1b0
> > > > > > [ 1310.677251]  #1:  (rcu_read_lock){..--}, at: [<c0388d60>] netif_receive_skb+0x100/0x470
> > > > > > [ 1310.677924]  #2:  (rcu_read_lock){..--}, at: [<c03a7fb2>] ip_local_deliver_finish+0x32/0x210
> > > > > > [ 1310.678460]  #3:  (clock-AF_INET){-.-?}, at: [<c038164e>] sock_def_readable+0x1e/0x80
> > > > > > [ 1310.679250]  #4:  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > > 
> > > The net part might just be a red herring, since the problem is that
> > > __wake_up is somehow reentering itself.
> > 
> > /*
> >  * Perform a safe wake up of the poll wait list. The problem is that
> >  * with the new callback'd wake up system, it is possible that the
> >  * poll callback is reentered from inside the call to wake_up() done
> >  * on the poll wait queue head. The rule is that we cannot reenter the
> >  * wake up code from the same task more than EP_MAX_POLLWAKE_NESTS times,
> >  * and we cannot reenter the same wait queue head at all. This will
> >  * enable to have a hierarchy of epoll file descriptor of no more than
> >  * EP_MAX_POLLWAKE_NESTS deep. We need the irq version of the spin lock
> >  * because this one gets called by the poll callback, that in turn is called
> >  * from inside a wake_up(), that might be called from irq context.
> >  */
> > 
> > Seems to suggest that the epoll code can indeed recurse into wakeup.
> > 
> > Davide, Johannes, any ideas?
> 
> Since EP_MAX_POLLWAKE_NESTS < MAX_LOCKDEP_SUBCLASSES we could perhaps do
> something like:
> 
>   wake_up_nested(..., wake_nests);
> 
> although I'm not quite sure that is correct, my understanding of this
> code is still fragile at best.

I remember I talked with Arjan about this time ago. Basically, since 1) 
you can drop an epoll fd inside another epoll fd 2) callback-based wakeups 
are used, you can see a wake_up() from inside another wake_up(), but they 
will never refer to the same lock instance.
Think about:

	dfd = socket(...);
	efd1 = epoll_create();
	efd2 = epoll_create();
	epoll_ctl(efd1, EPOLL_CTL_ADD, dfd, ...);
	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);

When a packet arrives to the device underneath "dfd", the net code will 
issue a wake_up() on its poll wake list. Epoll (efd1) has installed a 
callback wakeup entry on that queue, and the wake_up() performed by the 
"dfd" net code will end up in ep_poll_callback(). At this point epoll 
(efd1) notices that it may have some event ready, so it needs to wake up 
the waiters on its poll wait list (efd2). So it calls ep_poll_safewake() 
that ends up in another wake_up(), after having checked about the 
recursion constraints. That are, no more than EP_MAX_POLLWAKE_NESTS, to 
avoid stack blasting. Never hit the same queue, to avoid loops like:

	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
	epoll_ctl(efd3, EPOLL_CTL_ADD, efd2, ...);
	epoll_ctl(efd4, EPOLL_CTL_ADD, efd3, ...);
	epoll_ctl(efd1, EPOLL_CTL_ADD, efd4, ...);

The code "if (tncur->wq == wq || ..." prevents re-entering the same 
queue/lock.
I don't know how the lockdep code works, so I can't say about 
wake_up_nested(). Although I have a feeling is not enough in this case.
A solution may be to move the call to ep_poll_safewake() (that'd become a 
simple wake_up()) inside a tasklet or whatever is today trendy for delayed 
work. But his kinda scares me to be honest, since epoll has already a 
bunch of places where it could be asynchronously hit (plus performance 
regression will need to be verified).



- Davide


