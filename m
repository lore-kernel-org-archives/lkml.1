Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbZCXPbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbZCXPbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761403AbZCXPaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:30:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42416 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761402AbZCXPaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:30:11 -0400
Date: Tue, 24 Mar 2009 16:29:03 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324152903.GN25436@pengutronix.de>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324150928.GB30224@gondor.apana.org.au>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 16:25:09 up 34 days,  7:18, 45 users,  load average: 4.67, 8.84,
	11.33
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:09:28PM +0800, Herbert Xu wrote:
> On Tue, Mar 24, 2009 at 03:39:42PM +0100, Ingo Molnar wrote:
> >
> > Subject: [PATCH] net: Fix netpoll lockup in legacy receive path
> 
> Actually, this patch is still racy.  If some interrupt comes in
> and we suddenly get the maximum amount of backlog we can still
> hang when we call __napi_complete incorrectly.  It's unlikely
> but we certainly shouldn't allow that.  Here's a better version.

Yes, this one works. I always wanted to give a

Tested-by: Sascha Hauer <s.hauer@pengutronix.de>

Thanks
  Sascha

> 
> net: Fix netpoll lockup in legacy receive path
> 
> When I fixed the GRO crash in the legacy receive path I used
> napi_complete to replace __napi_complete.  Unfortunately they're
> not the same when NETPOLL is enabled, which may result in us
> not calling __napi_complete at all.
> 
> What's more, we really do need to keep the __napi_complete call
> within the IRQ-off section since in theory an IRQ can occur in
> between and fill up the backlog to the maximum, causing us to
> lock up.
> 
> This patch fixes this by essentially open-coding __napi_complete.
> 
> Note we no longer need the memory barrier because this function
> is per-cpu.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index e3fe5c7..2a7f6b3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2588,9 +2588,10 @@ static int process_backlog(struct napi_struct *napi, int quota)
>  		local_irq_disable();
>  		skb = __skb_dequeue(&queue->input_pkt_queue);
>  		if (!skb) {
> +			list_del(&napi->poll_list);
> +			clear_bit(NAPI_STATE_SCHED, &napi->state);
>  			local_irq_enable();
> -			napi_complete(napi);
> -			goto out;
> +			break;
>  		}
>  		local_irq_enable();
>  
> @@ -2599,7 +2600,6 @@ static int process_backlog(struct napi_struct *napi, int quota)
>  
>  	napi_gro_flush(napi);
>  
> -out:
>  	return work;
>  }
> 
> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
