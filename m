Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbXJOWFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbXJOWFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbXJOWEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:04:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbXJOWEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:04:51 -0400
Date: Tue, 16 Oct 2007 00:03:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shemminger@linux-foundation.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: WARNING: at net/core/dev.c:2161 net_rx_action()
Message-ID: <20071015220357.GA7174@elte.hu>
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015.125731.79447899.davem@davemloft.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 15 Oct 2007 13:24:30 +0200
> 
> > got this warning with Linus' latest -git tree:
> > 
> >   WARNING: at net/core/dev.c:2161 net_rx_action()
> >    [<80564db4>] net_rx_action+0xce/0x186
> >    [<8011ba98>] __do_softirq+0x6c/0xcf
> >    [<8011bb2d>] do_softirq+0x32/0x36
> >    [<8011bcae>] irq_exit+0x35/0x40
> >    [<80104fdb>] do_IRQ+0x5c/0x71
> >    [<801048cd>] do_nmi+0x8f/0x238
> >    [<801033a3>] common_interrupt+0x23/0x30
> >    =======================
> 
> This is a driver bug, the work "budget" passed into a driver's 
> ->poll() handler should never be exceeded.  That's what this warning 
> assertion is checking.
> 
> What ethernet card is in your system and what driver is being used to 
> drive it?

it's forcedeth.

i've checked nv_napi_poll(), and i dont see how it could return larger 
than 'limit' number of packets.

it could return packets == limit though:

                pkts = nv_rx_process_optimized(dev, budget);
...

        if (pkts < budget) {
                /* re-enable receive interrupts */
                spin_lock_irqsave(&np->lock, flags);

                __netif_rx_complete(dev, napi);

...
        return pkts;

shouldnt that be "pkts <= budget"? But even that shouldnt cause a larger 
than limit return. Weird.

there are two networking cards in the system, the other one is a:

  eth1: RealTek RTL8139 at 0xf080e000, 00:c0:df:03:68:5d, IRQ 11
  eth1:  Identified 8139 chip type 'RTL-8139B'

but this one should be inactive (not plugged into the network). Should i 
try to get a debug print out of the actual 'weight' and 'work' integers, 
and of the n->poll function address?

	Ingo
