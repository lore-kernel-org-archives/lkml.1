Return-Path: <linux-kernel-owner+w=401wt.eu-S1765925AbXJSCdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765925AbXJSCdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762766AbXJSCdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:33:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2157 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758170AbXJSCdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:33:04 -0400
Date: Fri, 19 Oct 2007 10:32:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Message-ID: <20071019023219.GB8453@gondor.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au> <1192745137.7367.40.camel@pasglop> <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org> <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 04:39:59PM -0700, Linus Torvalds wrote:
>
> Basic notion: the only thing that serializes the IRQ_INPROGRESS flag is 
> the descriptor lock. And we don't have to (or even want to!) hold it while 
> waiting for the thing, but we want to *have*held*it* in between whatever 
> we're synchronizing with.

Thinking about this again and checking code I have come to the
conclusion that

1) There is a race (in some drivers) even with the full mb.
2) Linus's patch fixes it.
3) It's difficult to fix it elegantly in the driver.

In other words I think this patch is great :)

First of all let's agree on some basic assumptions:

* A pair of spin lock/unlock subsumes the effect of a full mb.
* A spin lock in general only equates to (SS/SL/LL).
* A spin unlock in general only equates to (SS/LS).

In particular, a load after a spin unlock may pass before the
spin unlock.

Here is the race (with tg3 as the only example that I know of).
The driver attempts to quiesce interrupts such that after the
call to synchronize_irq it is intended that no further IRQ
handler calls for that device will do any work besides acking
the IRQ.

Here is how it does it:

CPU0				CPU1
				spin lock
					load irq_sync
irq_sync = 1
smp_mb
synchronize_irq()
	while (IRQ_INPROGRESS)
		wait
	return
				set IRQ_INPROGRESS
				spin unlock
				tg3_msi
					ack IRQ
					if (irq_sync)
						return
					do work

The problem here is that load of irq_sync in the handler has
passed above the setting of IRQ_INPROGRESS.

Linus's patch fixes it because this becomes:

CPU0				CPU1
				spin lock
					load irq_sync
irq_sync = 1
smp_mb
synchronize_irq
				set IRQ_INPROGRESS
				spin unlock
	spin lock
	spin unlock
				tg3_msi
					ack IRQ
					if (irq_sync)
						return
					do work
	while (IRQ_INPROGRESS)
		wait
				spin lock
				clear IRQ_INPROGRESS
				spin unlock
	return

Even though we still do the work on the right we will now notice
the INPROGRESS flag on the left and wait.

It's hard to fix this in the drivers because they'd either have
to access the desc lock or add a full mb to the fast path on the
right.

Once this goes in we can also remove the smp_mb from tg3.c.  BTW,
a lot of drivers (including the fusion example Ben quoted) call
synchronize_irq before free_irq.  This is unnecessary because
the latter already calls it anyway.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
