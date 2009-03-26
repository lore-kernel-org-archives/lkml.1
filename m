Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZCZDVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZCZDVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZCZDVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:21:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33542
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbZCZDVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:21:03 -0400
Date: Wed, 25 Mar 2009 20:20:50 -0700 (PDT)
Message-Id: <20090325.202050.08183381.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: jarkao2@gmail.com, mingo@elte.hu, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090326024129.GA13982@gondor.apana.org.au>
References: <20090325122635.GA6489@gondor.apana.org.au>
	<20090325225456.GA3271@ami.dom.local>
	<20090326024129.GA13982@gondor.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 26 Mar 2009 10:41:29 +0800

> On Wed, Mar 25, 2009 at 11:54:56PM +0100, Jarek Poplawski wrote:
> > 
> > Of course it's too late for verifying this now, but (for the future)
> > I think, this scenario could be considered:
> > 
> > process_backlog()			netif_rx()
> > 
> > if (!skb)
> > local_irq_enable()
> > 					if (queue.qlen) //NO
> > 					napi_schedule() //NOTHING
> > 					__skb_queue_tail() //qlen > 0
> > napi_complete()
> > ...					...
> > 					Every next netif_rx() sees
> > 					qlen > 0, so napi is never
> > 					scheduled again.
> > 
> > Then, something like this might work...
> 
> Yes this is why my original patch that started all this is broken.
> However, this doesn't apply to my patch that open-codes __napi_complete.

There is still a difference compared to your fix Herbert.  Jarek's
patch flushes GRO first before the unlink.

I still believe that's critical, although like you I can't pinpoint
why.

I know that GRO ought to be disabled here, but what if for some reason
it isn't? :-)

Adam Richter has successfully tested Jarek's variant, and if Ingo's
tests show that it makes his problem go away too then I'm definitely
going with Jarek's patch.
