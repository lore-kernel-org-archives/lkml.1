Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbXGBI7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbXGBI7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 04:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXGBI7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 04:59:33 -0400
Received: from mail.screens.ru ([213.234.233.54]:40790 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbXGBI7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 04:59:32 -0400
Date: Mon, 2 Jul 2007 12:59:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Re: [NETPOLL] netconsole: fix soft lockup when removing module
Message-ID: <20070702085949.GA110@tv-sign.ru>
References: <20070701173558.GA207@tv-sign.ru> <20070702075226.GB1639@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070702075226.GB1639@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Jarek Poplawski wrote:
> 
> diff -Nurp 2.6.22-rc7-/net/core/netpoll.c 2.6.22-rc7/net/core/netpoll.c
> --- 2.6.22-rc7-/net/core/netpoll.c	2007-07-02 09:03:27.000000000 +0200
> +++ 2.6.22-rc7/net/core/netpoll.c	2007-07-02 09:32:34.000000000 +0200
> @@ -72,8 +72,7 @@ static void queue_process(struct work_st
>  			netif_tx_unlock(dev);
>  			local_irq_restore(flags);
>  
> -			if (atomic_read(&npinfo->refcnt))
> -				schedule_delayed_work(&npinfo->tx_work, HZ/10);
> +			schedule_delayed_work(&npinfo->tx_work, HZ/10);
>  			return;
>  		}
>  		netif_tx_unlock(dev);
> @@ -786,7 +785,7 @@ void netpoll_cleanup(struct netpoll *np)
>  			if (atomic_dec_and_test(&npinfo->refcnt)) {
>  				skb_queue_purge(&npinfo->arp_tx);
>  				skb_queue_purge(&npinfo->txq);
> -				cancel_delayed_work(&npinfo->tx_work);
> +				cancel_rearming_delayed_work(&npinfo->tx_work);
>  				flush_scheduled_work();

While you are here, could you also delete this flush_scheduled_work() ?
It is not needed any longer.

Oleg.

