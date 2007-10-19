Return-Path: <linux-kernel-owner+w=401wt.eu-S933923AbXJSCw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923AbXJSCw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758963AbXJSCws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:52:48 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:23398 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754472AbXJSCwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:52:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pNBJGYjEvtj5kYOVAxdD8+AIiJ2hM1uW5NYteaTvOsjA89VJ/SVDVAgoagIOcxGXMqTnhywHe1RsEh3m/jgxqql5ABEwT5v+cc9mRVmmhSYY+PAi4u3OtLcKSQ3owgGf3VUjDTDMh8ioxRibgCaMd4yjUfCbW2FNtFkZD9nb8rY=  ;
X-YMail-OSG: qhC5TDMVM1kio.QKdREmHSqfbzj.ZrKo0OZPvHUWh4N4BLX1Ji_4CAlMZYJ_AhNSBAE0F_7Tew--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Date: Fri, 19 Oct 2007 12:52:17 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org> <20071019023219.GB8453@gondor.apana.org.au>
In-Reply-To: <20071019023219.GB8453@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191252.18272.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 12:32, Herbert Xu wrote:

> First of all let's agree on some basic assumptions:
>
> * A pair of spin lock/unlock subsumes the effect of a full mb.

Not unless you mean a pair of spin lock/unlock as in
2 spin lock/unlock pairs (4 operations).

*X = 10;
spin_lock(&lock);
/* *Y speculatively loaded here */
/* store to *X leaves CPU store queue here */
spin_unlock(&lock);
y = *Y;

> * A spin lock in general only equates to (SS/SL/LL).
> * A spin unlock in general only equates to (SS/LS).

I don't use the sparc barriers, so they don't come naturally to
me ;)

I think both loads and stores can pass into the critical section
by having the spin_lock pass earlier ops, or by having spin_unlock
be passed by later ones.


> In particular, a load after a spin unlock may pass before the
> spin unlock.
>
> Here is the race (with tg3 as the only example that I know of).
> The driver attempts to quiesce interrupts such that after the
> call to synchronize_irq it is intended that no further IRQ
> handler calls for that device will do any work besides acking
> the IRQ.
>
> Here is how it does it:
>
> CPU0				CPU1
> 				spin lock
> 					load irq_sync
> irq_sync = 1
> smp_mb
> synchronize_irq()
> 	while (IRQ_INPROGRESS)
> 		wait
> 	return
> 				set IRQ_INPROGRESS
> 				spin unlock
> 				tg3_msi
> 					ack IRQ
> 					if (irq_sync)
> 						return
> 					do work
>
> The problem here is that load of irq_sync in the handler has
> passed above the setting of IRQ_INPROGRESS.
>
> Linus's patch fixes it because this becomes:
>
> CPU0				CPU1
> 				spin lock
> 					load irq_sync
> irq_sync = 1
> smp_mb
> synchronize_irq
> 				set IRQ_INPROGRESS
> 				spin unlock
> 	spin lock
> 	spin unlock
> 				tg3_msi
> 					ack IRQ
> 					if (irq_sync)
> 						return
> 					do work
> 	while (IRQ_INPROGRESS)
> 		wait
> 				spin lock
> 				clear IRQ_INPROGRESS
> 				spin unlock
> 	return
>
> Even though we still do the work on the right we will now notice
> the INPROGRESS flag on the left and wait.
>
> It's hard to fix this in the drivers because they'd either have
> to access the desc lock or add a full mb to the fast path on the
> right.
>
> Once this goes in we can also remove the smp_mb from tg3.c.  BTW,
> a lot of drivers (including the fusion example Ben quoted) call
> synchronize_irq before free_irq.  This is unnecessary because
> the latter already calls it anyway.
>
> Cheers,
