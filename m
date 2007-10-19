Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbXJSEsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbXJSEsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 00:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXJSEsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 00:48:17 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3201 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbXJSEsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 00:48:16 -0400
Date: Fri, 19 Oct 2007 12:48:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Message-ID: <20071019044806.GA10080@gondor.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au> <1192745137.7367.40.camel@pasglop> <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org> <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org> <20071019023219.GB8453@gondor.apana.org.au> <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org> <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org> <20071019042025.GA9617@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019042025.GA9617@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 12:20:25PM +0800, Herbert Xu wrote:
>
> That's why I think this patch is in fact the only one that
> solves all the races in this thread.  The case that it solves
> which the lock/unlock patch does not is the one where action
> flows downwards past the clearing of IRQ_INPROGRESS.  I missed
> this case earlier.

OK, here is the patch again with a changelog:

[IRQ]: Fix synchronize_irq races with IRQ handler

As it is some callers of synchronize_irq rely on memory barriers
to provide synchronisation against the IRQ handlers.  For example,
the tg3 driver does

	tp->irq_sync = 1;
	smp_mb();
	synchronize_irq();

and then in the IRQ handler:

	if (!tp->irq_sync)
		netif_rx_schedule(dev, &tp->napi);

Unfortunately memory barriers only work well when they come in
pairs.  Because we don't actually have memory barriers on the
IRQ path, the memory barrier before the synchronize_irq() doesn't
actually protect us.

In particular, synchronize_irq() may return followed by the
result of netif_rx_schedule being made visible.

This patch (mostly written by Linus) fixes this by using spin
locks instead of memory barries on the synchronize_irq() path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 80eab7a..1f31422 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -29,12 +29,28 @@
 void synchronize_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
+	unsigned int status;
 
 	if (irq >= NR_IRQS)
 		return;
 
-	while (desc->status & IRQ_INPROGRESS)
-		cpu_relax();
+	do {
+		unsigned long flags;
+
+		/*
+		 * Wait until we're out of the critical section.  This might
+		 * give the wrong answer due to the lack of memory barriers.
+		 */
+		while (desc->status & IRQ_INPROGRESS)
+			cpu_relax();
+
+		/* Ok, that indicated we're done: double-check carefully. */
+		spin_lock_irqsave(&desc->lock, flags);
+		status = desc->status;
+		spin_unlock_irqrestore(&desc->lock, flags);
+
+		/* Oops, that failed? */
+	} while (status & IRQ_INPROGRESS);
 }
 EXPORT_SYMBOL(synchronize_irq);
 
