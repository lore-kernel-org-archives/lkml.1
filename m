Return-Path: <linux-kernel-owner+w=401wt.eu-S934582AbXJSD1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582AbXJSD1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760588AbXJSD1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:27:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756614AbXJSD1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:27:46 -0400
Date: Thu, 18 Oct 2007 20:26:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] synchronize_irq needs a barrier
In-Reply-To: <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au> <1192745137.7367.40.camel@pasglop>
 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
 <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
 <20071019023219.GB8453@gondor.apana.org.au>
 <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2007, Linus Torvalds wrote:
>
> I *think* it should work with something like
> 
> 	for (;;) {
> 		smp_rmb();
> 		if (!spin_is_locked(&desc->lock)) {
> 			smp_rmb();
> 			if (!(desc->status & IRQ_INPROGRESS)
> 				break;
> 		}
> 		cpu_relax();
> 	}

I'm starting to doubt this. 

One of the issues is that we still need the smp_mb() in front of the loop 
(because we want to serialize the loop with any writes in the caller).

The other issue is that I don't think it's enough that we saw the 
descriptor lock unlocked, and then the IRQ_INPROGRESS bit clear. It might 
have been unlocked *while* the IRQ was in progress, but the interrupt 
handler is now in its last throes, and re-takes the spinlock and clears 
the IRQ_INPROGRESS thing. But we're not actually happy until we've seen 
the IRQ_INPROGRESS bit clear and the spinlock has been released *again*.

So those two tests should actually be the other way around: we want to see 
the IRQ_INPROGRESS bit clear first.

It's all just too damn subtle and clever. Something like this should not 
need to be that subtle. 

Maybe the rigth thing to do is to not rely on *any* ordering what-so-ever, 
and just make the rule be: "if you look at the IRQ_INPROGRESS bit, you'd 
better hold the descriptor spinlock", and not have any subtle ordering 
issues at all.

But that makes us have a loop with getting/releasing the lock all the 
time, and then we get back to horrid issues with cacheline bouncing and 
unfairness of cache accesses across cores (ie look at the issues we had 
with the runqueue starvation in wait_task_inactive()).

Those were fixed by starting out with the non-locked and totally unsafe 
versions, but then having one last "check with lock held, and repeat only 
if that says things went south". 

See commit fa490cfd15d7ce0900097cc4e60cfd7a76381138 and ponder. Maybe we 
should take the same approach here, and do something like

	repeat:
		/* Optimistic, no-locking loop */
		while (desc->status & IRQ_INPROGRESS)
			cpu_relax();

		/* Ok, that indicated we're done: double-check carefully */
		spin_lock_irqsave(&desc->lock, flags);
		status = desc->status;
		spin_unlock_irqrestore(&desc->lock, flags);

		/* Oops, that failed? */
		if (status & IRQ_INPROGRESS)
			goto repeat;

Hmm?

			Linus
