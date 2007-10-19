Return-Path: <linux-kernel-owner+w=401wt.eu-S966139AbXJSD2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966139AbXJSD2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbXJSD2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:28:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2554 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762351AbXJSD2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:28:31 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: nickpiggin@yahoo.com.au (Nick Piggin)
Subject: Re: [PATCH] synchronize_irq needs a barrier
Cc: herbert@gondor.apana.org.au, torvalds@linux-foundation.org,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mingo@elte.hu,
       tglx@linutronix.de
Organization: Core
In-Reply-To: <200710191252.18272.nickpiggin@yahoo.com.au>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IiiX6-0002V0-00@gondolin.me.apana.org.au>
Date: Fri, 19 Oct 2007 11:28:20 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> First of all let's agree on some basic assumptions:
>>
>> * A pair of spin lock/unlock subsumes the effect of a full mb.
> 
> Not unless you mean a pair of spin lock/unlock as in
> 2 spin lock/unlock pairs (4 operations).
> 
> *X = 10;
> spin_lock(&lock);
> /* *Y speculatively loaded here */
> /* store to *X leaves CPU store queue here */
> spin_unlock(&lock);
> y = *Y;

Good point.

Although in this case we're still safe because in the worst
cases:

CPU0				CPU1
irq_sync = 1
synchronize_irq
	spin lock
	load IRQ_INPROGRESS
irq_sync sync is visible
	spin unlock
				spin lock
					load irq_sync
	while (IRQ_INPROGRESS)
		wait
	return
				set IRQ_INPROGRESS
				spin unlock
				tg3_msi
					ack IRQ
					if (irq_sync)
						return
				spin lock
				clear IRQ_INPROGRESS
				spin unlock

------------------------------------------------------------

CPU0				CPU1
				spin lock
					load irq_sync
irq_sync = 1
synchronize_irq
				set IRQ_INPROGRESS
				spin unlock
	spin lock
	load IRQ_INPROGRESS
irq_sync sync is visible
	spin unlock
	while (IRQ_INPROGRESS)
		wait
				tg3_msi
					ack IRQ
					if (irq_sync)
						return
					do work
				spin lock
				clear IRQ_INPROGRESS
				spin unlock
	return

So because we're using the same lock on both sides, it does
do the right thing even without the memory barrier.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
