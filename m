Return-Path: <linux-kernel-owner+w=401wt.eu-S1764482AbXESVeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764482AbXESVeP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXESVeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:34:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43630
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755324AbXESVeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:34:02 -0400
Date: Sat, 19 May 2007 14:34:05 -0700 (PDT)
Message-Id: <20070519.143405.11626880.davem@davemloft.net>
To: tglx@linutronix.de
Cc: mikulas@artax.karlin.mff.cuni.cz, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOHZ: local_softirq_pending with tickless plip
From: David Miller <davem@davemloft.net>
In-Reply-To: <1179399131.3764.50.camel@chaos>
References: <Pine.LNX.4.64.0705161415350.10041@artax.karlin.mff.cuni.cz>
	<1179399131.3764.50.camel@chaos>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 May 2007 12:52:11 +0200

> On Wed, 2007-05-16 at 15:00 +0200, Mikulas Patocka wrote:
> > Hi
> > 
> > On one of my machines with tickless kernel and plip I get messages :
> 
> I bet this is a machine a P4 with Hyperthreading enabled ?
> 
> > NOHZ: local_softirq_pending 08
> > 
> > always when using plip (on other machine with tickless kernel and plip I 
> > get no errors). Thebug happens both on 2.6.21 and 2.6.22-rc1
> > 
> > This patch fixes that. Note that plip calls netif_rx neither from hardware 
> > interrupt nor from ksoftirqd, so there is no one who would wake 
> > ksoftirqd then. netif_tx calls only 
> > __raise_softirq_irqoff(NET_RX_SOFTIRQ), which sets softirq bit, but 
> > doesn't wake ksoftirqd.
> 
> Dave, 
> 
> can we please get rid of __raise_softirq_irqoff() at all ? These micro
> optimizations are causing more trouble than they are worth.

I looked some more and really I think this is a bug in plip,
netif_rx() should only be invoked from software or hardware
interrupts.

If you look, the function invoking netif_rx() is called plip_bh() and
indeed I believe with that kind of funtion name it did run from
software interrupts (of BH's as they used to be called) at one point
but someone changed it over to execute from a workqueue for some
reason.

We really shouldn't punish all callers of netif_rx() just because
one call site doesn't invoke it in the correct context.
