Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbXE3UjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbXE3UjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbXE3Ui7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:38:59 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:54377 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388AbXE3Ui6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:38:58 -0400
Date: Wed, 30 May 2007 22:38:57 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jarek Poplawski <jarkao2@o2.pl>, Thomas Gleixner <tglx@linutronix.de>,
       stable@kernel.org
Subject: Re: [PATCH] Re: [2.6.21.1] soft lockup when removing netconsole
	module
Message-ID: <20070530203857.GE9806@vanheusden.com>
References: <20070526154011.GB3735@vanheusden.com> <20070529005628.f7f3abc6.akpm@linux-foundation.org> <465D7BE9.70702@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <465D7BE9.70702@windriver.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu May 31 22:26:34 CEST 2007
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seems to solve the problem.
I removed (and inserted) the module twice without any oopses or panics
or hangs in general.

On Wed, May 30, 2007 at 08:28:09AM -0500, Jason Wessel wrote:
>
> Attached is a patch to fix the soft lockup problem when removing the 
> netconsole module.
>
> It looks different than the original patch I posted because the context had 
> to change to maintain 80 column code.  For reference the original e-mail + 
> patch was "[BUG] 2.6.21 hang in cancel_rearming_delayed_workqueue()" sent 
> on 5/25/07.
>
> Jason.
>
>

> >From 102a018d601e954f658d272d4daeef139ae40e0e Mon Sep 17 00:00:00 2001
> From: Jason Wessel <jason.wessel@windriver.com>
> Date: Wed, 30 May 2007 08:03:52 -0500
> Subject: [PATCH] The netpoll_cleanup handler can hang the kernel if there is no work in
> the work queue because a call to cancel_rearming_delayed_work() with
> no work goes into an infinite loop.
> 
> The typical case where this is a problem is on removing a kernel
> module such as the netconsole driver or kgdboe.
> 
> To maintain 80 column code, the function had to have one level of braces
> dropped.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  net/core/netpoll.c |   36 +++++++++++++++++++-----------------
>  1 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index 4581ece..28fa50e 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -766,30 +766,32 @@ void netpoll_cleanup(struct netpoll *np)
>  	struct netpoll_info *npinfo;
>  	unsigned long flags;
>  
> -	if (np->dev) {
> -		npinfo = np->dev->npinfo;
> -		if (npinfo) {
> -			if (npinfo->rx_np == np) {
> -				spin_lock_irqsave(&npinfo->rx_lock, flags);
> -				npinfo->rx_np = NULL;
> -				npinfo->rx_flags &= ~NETPOLL_RX_ENABLED;
> -				spin_unlock_irqrestore(&npinfo->rx_lock, flags);
> -			}
> +	if (!np->dev)
> +		return;
> +
> +	npinfo = np->dev->npinfo;
> +	if (npinfo) {
> +		if (npinfo->rx_np == np) {
> +			spin_lock_irqsave(&npinfo->rx_lock, flags);
> +			npinfo->rx_np = NULL;
> +			npinfo->rx_flags &= ~NETPOLL_RX_ENABLED;
> +			spin_unlock_irqrestore(&npinfo->rx_lock, flags);
> +		}
>  
> -			np->dev->npinfo = NULL;
> -			if (atomic_dec_and_test(&npinfo->refcnt)) {
> -				skb_queue_purge(&npinfo->arp_tx);
> -				skb_queue_purge(&npinfo->txq);
> +		np->dev->npinfo = NULL;
> +		if (atomic_dec_and_test(&npinfo->refcnt)) {
> +			skb_queue_purge(&npinfo->arp_tx);
> +			skb_queue_purge(&npinfo->txq);
> +			if (delayed_work_pending(&npinfo->tx_work)) {
>  				cancel_rearming_delayed_work(&npinfo->tx_work);
>  				flush_scheduled_work();
> -
> -				kfree(npinfo);
>  			}
> -		}
>  
> -		dev_put(np->dev);
> +			kfree(npinfo);
> +		}
>  	}
>  
> +	dev_put(np->dev);
>  	np->dev = NULL;
>  }
>  
> -- 
> 1.5.0.6
> 



Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
