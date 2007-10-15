Return-Path: <linux-kernel-owner+w=401wt.eu-S1762507AbXJOWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507AbXJOWU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXJOWUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:20:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39707 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbXJOWUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:20:13 -0400
Message-ID: <4713E799.1070002@pobox.com>
Date: Mon, 15 Oct 2007 18:20:09 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: WARNING: at net/core/dev.c:2161 net_rx_action()
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu>
In-Reply-To: <20071015220357.GA7174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Mon, 15 Oct 2007 13:24:30 +0200
>>
>>> got this warning with Linus' latest -git tree:
>>>
>>>   WARNING: at net/core/dev.c:2161 net_rx_action()
>>>    [<80564db4>] net_rx_action+0xce/0x186
>>>    [<8011ba98>] __do_softirq+0x6c/0xcf
>>>    [<8011bb2d>] do_softirq+0x32/0x36
>>>    [<8011bcae>] irq_exit+0x35/0x40
>>>    [<80104fdb>] do_IRQ+0x5c/0x71
>>>    [<801048cd>] do_nmi+0x8f/0x238
>>>    [<801033a3>] common_interrupt+0x23/0x30
>>>    =======================
>> This is a driver bug, the work "budget" passed into a driver's 
>> ->poll() handler should never be exceeded.  That's what this warning 
>> assertion is checking.
>>
>> What ethernet card is in your system and what driver is being used to 
>> drive it?
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

FWIW, forcedeth has this funky disable_irq()-based locking mechanism 
that is currently the subject of some kernel.org bugzillas.  I would 
also check and make sure that isn't perturbing your results (even though 
it seems unrelated, based on what I read here).  That might include 
disabling MSI if it's enabled, and/or turning on spinlock debugging.

	Jeff




