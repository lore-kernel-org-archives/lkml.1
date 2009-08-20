Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZHTKbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZHTKbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZHTKbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:31:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:53561 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZHTKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:31:51 -0400
Subject: Re: [PATCH] netpoll: WARN_ONCE for start_xmit returns with
	interrupts enabled
From: DDD <Dongdong.deng@windriver.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org
In-Reply-To: <1250678596.3937.182.camel@calx>
References: <1250678607.17891.26.camel@dengdd-desktop>
	 <1250678596.3937.182.camel@calx>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Aug 2009 18:44:00 +0800
Message-Id: <1250765040.17891.91.camel@dengdd-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 20 Aug 2009 10:31:28.0301 (UTC) FILETIME=[60436DD0:01CA2181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 05:43 -0500, Matt Mackall wrote: 
> On Wed, 2009-08-19 at 18:43 +0800, DDD wrote:
> > The NETPOLL API requires that interrupts remain disabled in
> > netpoll_send_skb().
> > 
> > Add a WARN_ONCE when ndo_start_xmit returns with interrupts enabled
> > in netpoll_send_skb().
> > 
> > Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> > ---
> >  net/core/netpoll.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> > index df30feb..d38103f 100644
> > --- a/net/core/netpoll.c
> > +++ b/net/core/netpoll.c
> > @@ -319,6 +319,12 @@ static void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
> >  
> >  			udelay(USEC_PER_POLL);
> >  		}
> > +
> > +		WARN_ONCE(!irqs_disabled(),
> > +			KERN_WARNING "netpoll_send_skb(): [net driver %s]"
> > +			"ndo_start_xmit() shouldn't return with interrupts"
> > +			"enabled!", dev->name);
> 
> Hmm, perhaps:
> 
> "netpoll_send_skb(): %s enabled interrupts in poll (%pF)\n",
> dev->name, ops->ndo_start_xmit
> 
> That'll give us a real function name and maybe even a module name.

Thanks, I will modify it as your suggestions.

When I test the WRAN_ONCE, I find that some net drivers still have this problem,
such as using local_irq_disable/local_irq_enable in ndo_start_xmit() or other cases.


I will do an new patch and hope it could fix this problem completely in all the net drivers that support NETPOLL.


I check the drivers that support NETPOLL one by one again(almost 100 drivers),
and following drivers's fix will be included by my patch:

1: ixp2000/ixpdev.c : 66 local_irq_disable

2: fec_mpc52xx.c : 319 spin_unlock_irq

3: macb.c:602 : 638 spin_unlock_irq

4: mlx4/en_netdev.c : 448 
mlx4_en_xmit() -> mlx4_en_xmit_poll() -> spin_trylock_irq

5: smc91x.c 
It seems that there is a lots work to let smc91x work well with netpoll.


Thanks,
Dongdong

> 
