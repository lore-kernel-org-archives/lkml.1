Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXGBJX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXGBJX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 05:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXGBJXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 05:23:50 -0400
Received: from mail.screens.ru ([213.234.233.54]:36893 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXGBJXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 05:23:49 -0400
Date: Mon, 2 Jul 2007 13:24:08 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [NETPOLL] netconsole: fix soft lockup when removing module
Message-ID: <20070702092408.GA137@tv-sign.ru>
References: <20070701173558.GA207@tv-sign.ru> <20070702063424.GA1639@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702063424.GA1639@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Jarek Poplawski wrote:
>
> > > --- a/net/core/netpoll.c
> > > +++ b/net/core/netpoll.c
> > > @@ -72,7 +72,8 @@ static void queue_process(struct work_struct *work)
> > >  			netif_tx_unlock(dev);
> > >  			local_irq_restore(flags);
> > >  
> > > -			schedule_delayed_work(&npinfo->tx_work, HZ/10);
> > > +			if (atomic_read(&npinfo->refcnt))
> > > +				schedule_delayed_work(&npinfo->tx_work, HZ/10);
> > >  			return;
> > >  		}
>
> [...snip...]
> 
> So, 2.6.21 needs something better (maybe you've found it btw.?),
> but they weren't too interested, anyway.

We can do a double flush trick. If queue_process() checks ->refcnt before
schedule_delayed_work() like above, netpoll_cleanup() can do

	flush_scheduled_work();

	// the next invocation of queue_process()
	// must see ->refcnt == 0
	if (!cancel_delayed_work(&npinfo->tx_work)) {
		/* may be queued, wait for completion */
		flush_scheduled_work();
	}

Jarek, I don't understand net/, a silly question. Why do we need the #2 chunk?
Isn't it better to move skb_queue_purge(&npinfo->txq) after cancel_..._work()
instead?

Oleg.	

