Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbXJOWS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbXJOWS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXJOWSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:18:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37238
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbXJOWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:18:50 -0400
Date: Mon, 15 Oct 2007 15:18:49 -0700 (PDT)
Message-Id: <20071015.151849.21595903.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shemminger@linux-foundation.org, jgarzik@pobox.com
Subject: Re: WARNING: at net/core/dev.c:2161 net_rx_action()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071015220357.GA7174@elte.hu>
References: <20071015112430.GA30006@elte.hu>
	<20071015.125731.79447899.davem@davemloft.net>
	<20071015220357.GA7174@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Oct 2007 00:03:57 +0200

> * David Miller <davem@davemloft.net> wrote:
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Mon, 15 Oct 2007 13:24:30 +0200
> > 
> > > got this warning with Linus' latest -git tree:
> > > 
> > >   WARNING: at net/core/dev.c:2161 net_rx_action()
> > >    [<80564db4>] net_rx_action+0xce/0x186
> > >    [<8011ba98>] __do_softirq+0x6c/0xcf
> > >    [<8011bb2d>] do_softirq+0x32/0x36
> > >    [<8011bcae>] irq_exit+0x35/0x40
> > >    [<80104fdb>] do_IRQ+0x5c/0x71
> > >    [<801048cd>] do_nmi+0x8f/0x238
> > >    [<801033a3>] common_interrupt+0x23/0x30
> > >    =======================
> > 
> > This is a driver bug, the work "budget" passed into a driver's 
> > ->poll() handler should never be exceeded.  That's what this warning 
> > assertion is checking.
> > 
> > What ethernet card is in your system and what driver is being used to 
> > drive it?
> 
> it's forcedeth.
> 
> i've checked nv_napi_poll(), and i dont see how it could return larger 
> than 'limit' number of packets.
> 
> it could return packets == limit though:
> 
>                 pkts = nv_rx_process_optimized(dev, budget);
> ...
> 
>         if (pkts < budget) {
>                 /* re-enable receive interrupts */
>                 spin_lock_irqsave(&np->lock, flags);
> 
>                 __netif_rx_complete(dev, napi);
> 
> ...
>         return pkts;
> 
> shouldnt that be "pkts <= budget"? But even that shouldnt cause a larger 
> than limit return. Weird.

No, not in this case.  The driver must only netif_rx_complete()
if it consumed strictly less than "budget" worth of work.

> there are two networking cards in the system, the other one is a:
> 
>   eth1: RealTek RTL8139 at 0xf080e000, 00:c0:df:03:68:5d, IRQ 11
>   eth1:  Identified 8139 chip type 'RTL-8139B'
> 
> but this one should be inactive (not plugged into the network). Should i 
> try to get a debug print out of the actual 'weight' and 'work' integers, 
> and of the n->poll function address?

That might help.

I don't see any possible nv_rx_process{,_optimized}() can return "work
> budget" either.  But I do notice these loops unconditionally execute
at least once, perhaps budget is being passed erroneously in as zero?
