Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZCXPXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZCXPXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZCXPXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:23:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45795 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZCXPXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:23:22 -0400
Date: Tue, 24 Mar 2009 16:22:00 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324152200.GM25436@pengutronix.de>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324143942.GA20462@elte.hu>
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
X-Uptime: 15:58:28 up 34 days,  6:51, 46 users,  load average: 13.63,
	14.24, 13.95
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Mar 24, 2009 at 03:39:42PM +0100, Ingo Molnar wrote:
> 
> * Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> 
> > On Tue, Mar 24, 2009 at 02:02:02PM +0100, Ingo Molnar wrote:
> > > If the box hung within 15 minutes, the kernel was deemed bad. Using 
> > > that method i arrived to this upstream networking fix which was 
> > > merged yesterday:
> > > 
> > >  | 303c6a0251852ecbdc5c15e466dcaff5971f7517 is first bad commit
> > >  | commit 303c6a0251852ecbdc5c15e466dcaff5971f7517
> > >  | Author: Herbert Xu <herbert@gondor.apana.org.au>
> > >  | Date:   Tue Mar 17 13:11:29 2009 -0700
> > >  |
> > >  |     gro: Fix legacy path napi_complete crash
> > 
> > This commit breaks nfsroot booting on i.MX27 and other ARM boxes 
> > with different network cards here in a reproducable way.
> 
> Can you confirm that Herbert's fix (see it below) solves the 
> problem?

No, still doesn't work.

It seems to have something to do with enabling interrupts between
__skb_dequeue() and __napi_complete().

I reverted 303c6a0251852ecbdc5c15e466dcaff5971f7517 and added a

local_irq_enable(); local_irq_disable();

right before __napi_complete() and this already breaks networking.


Sascha

> 
> 	Ingo
> 
> --------------->
> From b8b66ac07cab1b45aac93e4f406833a1e0d7677e Mon Sep 17 00:00:00 2001
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Tue, 24 Mar 2009 21:35:42 +0800
> Subject: [PATCH] net: Fix netpoll lockup in legacy receive path
> 
> When I fixed the GRO crash in the legacy receive path I used
> napi_complete to replace __napi_complete.  Unfortunately they're
> not the same when NETPOLL is enabled, which may result in us
> not calling __napi_complete at all.
> 
> While this is fishy in itself, let's make the obvious fix right
> now of reverting to the previous state where we always called
> __napi_complete.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20090324133542.GA29046@gondor.apana.org.au>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  net/core/dev.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index e3fe5c7..523f53e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2580,24 +2580,26 @@ static int process_backlog(struct napi_struct *napi, int quota)
>  	int work = 0;
>  	struct softnet_data *queue = &__get_cpu_var(softnet_data);
>  	unsigned long start_time = jiffies;
> +	struct sk_buff *skb;
>  
>  	napi->weight = weight_p;
>  	do {
> -		struct sk_buff *skb;
> -
>  		local_irq_disable();
>  		skb = __skb_dequeue(&queue->input_pkt_queue);
> -		if (!skb) {
> -			local_irq_enable();
> -			napi_complete(napi);
> -			goto out;
> -		}
>  		local_irq_enable();
> +		if (!skb)
> +			break;
>  
>  		napi_gro_receive(napi, skb);
>  	} while (++work < quota && jiffies == start_time);
>  
>  	napi_gro_flush(napi);
> +	if (skb)
> +		goto out;
> +
> +	local_irq_disable();
> +	__napi_complete(napi);
> +	local_irq_enable();
>  
>  out:
>  	return work;
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
