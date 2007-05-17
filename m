Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbXEQKrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbXEQKrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXEQKr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:47:29 -0400
Received: from www.osadl.org ([213.239.205.134]:41102 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754858AbXEQKr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:47:29 -0400
Subject: Re: [PATCH] NOHZ: local_softirq_pending with tickless plip
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705161415350.10041@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0705161415350.10041@artax.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Thu, 17 May 2007 12:52:11 +0200
Message-Id: <1179399131.3764.50.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 15:00 +0200, Mikulas Patocka wrote:
> Hi
> 
> On one of my machines with tickless kernel and plip I get messages :

I bet this is a machine a P4 with Hyperthreading enabled ?

> NOHZ: local_softirq_pending 08
> 
> always when using plip (on other machine with tickless kernel and plip I 
> get no errors). Thebug happens both on 2.6.21 and 2.6.22-rc1
> 
> This patch fixes that. Note that plip calls netif_rx neither from hardware 
> interrupt nor from ksoftirqd, so there is no one who would wake 
> ksoftirqd then. netif_tx calls only 
> __raise_softirq_irqoff(NET_RX_SOFTIRQ), which sets softirq bit, but 
> doesn't wake ksoftirqd.

Dave, 

can we please get rid of __raise_softirq_irqoff() at all ? These micro
optimizations are causing more trouble than they are worth.

	tglx

> Mikulas
> 
> Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz
> 
> --- linux-2.6.22-rc1/net/core/dev.c_	Fri May 18 07:51:01 2007
> +++ linux-2.6.22-rc1/net/core/dev.c	Fri May 18 07:51:06 2007
> @@ -1117,7 +1117,7 @@
>   		dev->quota += dev->weight;
>   	else
>   		dev->quota = dev->weight;
> -	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
> +	raise_softirq_irqoff(NET_RX_SOFTIRQ);
>   	local_irq_restore(flags);
>   }
>   EXPORT_SYMBOL(__netif_rx_schedule);


