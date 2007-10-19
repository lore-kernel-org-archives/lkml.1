Return-Path: <linux-kernel-owner+w=401wt.eu-S1764202AbXJSELy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764202AbXJSELy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXJSELq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:11:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:60024 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXJSELq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:11:46 -0400
Subject: Re: [PATCH] synchronize_irq needs a barrier
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au>
	 <1192745137.7367.40.camel@pasglop>
	 <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org>
	 <1192749449.7367.51.camel@pasglop>
	 <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org>
	 <20071019023219.GB8453@gondor.apana.org.au>
	 <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 14:11:13 +1000
Message-Id: <1192767073.7367.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> 	repeat:
> 		/* Optimistic, no-locking loop */
> 		while (desc->status & IRQ_INPROGRESS)
> 			cpu_relax();
> 
> 		/* Ok, that indicated we're done: double-check carefully */
> 		spin_lock_irqsave(&desc->lock, flags);
> 		status = desc->status;
> 		spin_unlock_irqrestore(&desc->lock, flags);
> 
> 		/* Oops, that failed? */
> 		if (status & IRQ_INPROGRESS)
> 			goto repeat;
> 
> Hmm?

Paulus and I convinced ourselves that this would work. If we call our
variable that gets set before synchronize_irq and read in the IRQ
handler "foo", we get to:

	- writing foo can travel down at most to just before the unlock in the
code above

	- reading foo can travel up out of the IRQ handler at most just after
the lock in the code that sets IRQ_INPROGRESS.

The whole lock/set IRQ_INPROGRESS/unlock path can then only happen
before the locked section above, in which case we see and wait nicely
and all is good, or after, in which case the store to foo will be
visible to the IRQ handler as it will be ordered with the unlock in the
code above.

Pfiew !

So Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Thanks !

Ben.


