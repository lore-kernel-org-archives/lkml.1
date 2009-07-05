Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZGEUq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZGEUq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 16:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZGEUqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 16:46:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35635 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZGEUqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 16:46:14 -0400
Message-ID: <4A5110B9.4030904@garzik.org>
Date: Sun, 05 Jul 2009 16:44:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: andi@firstfloor.org, arjan@infradead.org, matthew@wil.cx,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       douglas.w.styner@intel.com, chinang.ma@intel.com,
       terry.o.prickett@intel.com, matthew.r.wilcox@intel.com,
       Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com, netdev@vger.kernel.org
Subject: Re: >10% performance degradation since 2.6.18
References: <20090705040137.GA7747@gondor.apana.org.au>
In-Reply-To: <20090705040137.GA7747@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Jeff Garzik <jeff@garzik.org> wrote:
>> What's the best setup for power usage?
>> What's the best setup for performance?
>> Are they the same?
> 
> Yes.

Is this a blind guess, or is there real world testing across multiple 
setups behind this answer?

Consider a 2-package, quad-core system with 3 userland threads actively 
performing network communication, plus periodic, low levels of network 
activity from OS utilities (such as nightly 'yum upgrade').

That is essentially an under-utilized 8-CPU system.  For such a case, it 
seems like a power win to idle or power down a few cores, or maybe even 
an entire package.

Efficient power usage means scaling _down_ when activity decreases.  A 
blind "distribute network activity across all CPUs" policy does not 
appear to be responsive to that type of situation.


>> Is it most optimal to have the interrupt for socket $X occur on the same 
>> CPU as where the app is running?
> 
> Yes.

Same question:  blind guess, or do you have numbers?

Consider two competing CPU hogs:  a kernel with tons of netfilter tables 
and rules, plus an application that uses a lot of CPU.

Can you not reach a threshold where it makes more sense to split kernel 
and userland work onto different CPUs?


>> If yes, how to best handle when the scheduler moves app to another CPU?
>> Should we reprogram the NIC hardware flow steering mechanism at that point?
> 
> Not really.  For now the best thing to do is to pin everything
> down and not move at all, because we can't afford to move.
> 
> The only way for moving to work is if we had the ability to get
> the sockets to follow the processes.  That means, we must have
> one RX queue per socket.

That seems to presume it is impossible to reprogram the NIC RX queue 
selection rules?

If you can add a new 'flow' to a NIC hardware RX queue, surely you can 
imagine a remove + add operation for a migrated 'flow'...  and thus, at 
least on the NIC hardware level, flows can follow processes.

	Jeff


