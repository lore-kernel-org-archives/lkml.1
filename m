Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0CIXWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:22:24 -0500
Received: from www.tglx.de ([62.245.132.106]:43197 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab0CIXWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:22:21 -0500
Date: Wed, 10 Mar 2010 00:22:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot
 and handle_level_irq
In-Reply-To: <1268092679-18070-1-git-send-email-lars@metafoo.de>
Message-ID: <alpine.LFD.2.00.1003091959080.22855@localhost.localdomain>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cOn Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
>  
> -	desc->status |= IRQ_INPROGRESS;
> +	desc->status |= IRQ_INPROGRESS | IRQ_ONESHOT_INPROGRESS;
>  	raw_spin_unlock(&desc->lock);

That keeps the IRQ_ONESHOT_INPROGRESS dangling for non ONESHOT
interrupts. Not a big deal, but not pretty either.
  
The race between the thread and the irq handler exists indeed on SMP,
but I think there are more fundamental issues about the state which
need to be addressed.

The first thing is that we do not mark the status MASKED when we
actually mask the interrupt in mask_ack_irq(). 

That conditional MASKED after running the primary handler is really
horrible - I already ranted in private at the moron who committed that
crime :)

So the following patch fixes that and the SMP race scenario:

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d70394f..3e53334 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -359,6 +359,7 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 		if (desc->chip->ack)
 			desc->chip->ack(irq);
 	}
+	desc->status |= IRQ_MASKED;
 }
 
 /*
@@ -484,10 +485,11 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
-	if (unlikely(desc->status & IRQ_ONESHOT))
-		desc->status |= IRQ_MASKED;
-	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
+	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)) &&
+	    desc->chip->unmask) {
 		desc->chip->unmask(irq);
+		desc->status &= ~IRQ_MASKED;
+	}
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }

But that change opens up another race which is similar to the one you
pointed out:

 CPU0                            CPU1
 hande_level_irq(irq X)
   mask_ack_irq(irq X)
   handle_IRQ_event(irq X)
     wake_up(thread_handler)
                                 thread handler(irq X) runs
     interrupt irqY
       handle_*_irq(irq Y)
       .....
                                 finalize_oneshot(irq X)
                                   unmask(irq X)
     interrupt irq X
       handle_level_irq(irq X)
       mask_ack_irq(irq X)
     return from irq X due to IRQ_INPROGRESS

   return from irq Y

 return from irq X w/o unmask due to IRQ_ONESHOT

That's pretty unlikely, but possible. I know that your patch would
mitigate that problem, but I'm not happy about making it go away with
non obvious state magic. I think I know how to fix it, but I need some
sleep now.

Thanks,

	tglx


