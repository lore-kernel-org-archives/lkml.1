Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYAERB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYAERB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 12:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbYAERBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 12:01:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbYAERBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:01:49 -0500
Subject: Re: 2.6.24-rc6: possible recursive locking detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net,
       Davide Libenzi <davidel@xmailserver.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1199552016.31975.41.camel@lappy>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de>
	 <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu>
	 <20080105071205.GA28936@gondor.apana.org.au>
	 <1199552016.31975.41.camel@lappy>
Content-Type: text/plain
Date: Sat, 05 Jan 2008 18:01:16 +0100
Message-Id: <1199552476.31975.45.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-05 at 17:53 +0100, Peter Zijlstra wrote:
> On Sat, 2008-01-05 at 18:12 +1100, Herbert Xu wrote:
> > On Fri, Jan 04, 2008 at 09:30:49AM +0100, Ingo Molnar wrote:
> > >
> > > > > [ 1310.670986] =============================================
> > > > > [ 1310.671690] [ INFO: possible recursive locking detected ]
> > > > > [ 1310.672097] 2.6.24-rc6 #1
> > > > > [ 1310.672421] ---------------------------------------------
> > > > > [ 1310.672828] FahCore_a0.exe/3692 is trying to acquire lock:
> > > > > [ 1310.673238]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > > > > [ 1310.673869]
> > > > > [ 1310.673870] but task is already holding lock:
> > > > > [ 1310.674567]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > > > > [ 1310.675267]
> > > > > [ 1310.675268] other info that might help us debug this:
> > > > > [ 1310.675952] 5 locks held by FahCore_a0.exe/3692:
> > > > > [ 1310.676334]  #0:  (rcu_read_lock){..--}, at: [<c038b620>] net_rx_action+0x60/0x1b0
> > > > > [ 1310.677251]  #1:  (rcu_read_lock){..--}, at: [<c0388d60>] netif_receive_skb+0x100/0x470
> > > > > [ 1310.677924]  #2:  (rcu_read_lock){..--}, at: [<c03a7fb2>] ip_local_deliver_finish+0x32/0x210
> > > > > [ 1310.678460]  #3:  (clock-AF_INET){-.-?}, at: [<c038164e>] sock_def_readable+0x1e/0x80
> > > > > [ 1310.679250]  #4:  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
> > 
> > The net part might just be a red herring, since the problem is that
> > __wake_up is somehow reentering itself.
> 
> /*
>  * Perform a safe wake up of the poll wait list. The problem is that
>  * with the new callback'd wake up system, it is possible that the
>  * poll callback is reentered from inside the call to wake_up() done
>  * on the poll wait queue head. The rule is that we cannot reenter the
>  * wake up code from the same task more than EP_MAX_POLLWAKE_NESTS times,
>  * and we cannot reenter the same wait queue head at all. This will
>  * enable to have a hierarchy of epoll file descriptor of no more than
>  * EP_MAX_POLLWAKE_NESTS deep. We need the irq version of the spin lock
>  * because this one gets called by the poll callback, that in turn is called
>  * from inside a wake_up(), that might be called from irq context.
>  */
> 
> Seems to suggest that the epoll code can indeed recurse into wakeup.
> 
> Davide, Johannes, any ideas?

Since EP_MAX_POLLWAKE_NESTS < MAX_LOCKDEP_SUBCLASSES we could perhaps do
something like:

  wake_up_nested(..., wake_nests);

although I'm not quite sure that is correct, my understanding of this
code is still fragile at best.

