Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbXGARfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbXGARfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 13:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbXGARfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 13:35:41 -0400
Received: from mail.screens.ru ([213.234.233.54]:53765 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbXGARfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 13:35:40 -0400
Date: Sun, 1 Jul 2007 21:35:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [NETPOLL] netconsole: fix soft lockup when removing module
Message-ID: <20070701173558.GA207@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
>
>    #1
>    Until kernel ver. 2.6.21 (including) cancel_rearming_delayed_work()
>    required a work function should always (unconditionally) rearm with
>    delay > 0 - otherwise it would endlessly loop. This patch replaces
>    this function with cancel_delayed_work(). Later kernel versions don't
>    require this, so here it's only for uniformity.

But 2.6.22 doesn't need this change, why it was merged?

In fact, I suspect this change adds a race,

> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -72,7 +72,8 @@ static void queue_process(struct work_struct *work)
>  			netif_tx_unlock(dev);
>  			local_irq_restore(flags);
>  
> -			schedule_delayed_work(&npinfo->tx_work, HZ/10);
> +			if (atomic_read(&npinfo->refcnt))
> +				schedule_delayed_work(&npinfo->tx_work, HZ/10);
>  			return;
>  		}
>  		netif_tx_unlock(dev);
> @@ -785,9 +786,15 @@ void netpoll_cleanup(struct netpoll *np)
>  			if (atomic_dec_and_test(&npinfo->refcnt)) {
>  				skb_queue_purge(&npinfo->arp_tx);
>  				skb_queue_purge(&npinfo->txq);
> -				cancel_rearming_delayed_work(&npinfo->tx_work);
> +				cancel_delayed_work(&npinfo->tx_work);
>  				flush_scheduled_work();

Suppose that ->refcnt == 1, and queue_process() was preempted just after
atomic_read(&npinfo->refcnt).

netpoll_cleanup() comes, cancel_delayed_work() does nothing, flush_scheduled_work()
sleeps.

queue_process() gets CPU, re-schedules ->tx_work, and returns.

flush_scheduled_work() completes, netpoll_cleanup() frees npinfo and returns
while ->tx_work is pending.

No?

Oleg.

