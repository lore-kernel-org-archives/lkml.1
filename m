Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbXJWD1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbXJWD1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXJWD1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:27:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3043 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbXJWD1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:27:12 -0400
Date: Tue, 23 Oct 2007 11:26:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [IRQ]: Fix synchronize_irq races with IRQ handler
Message-ID: <20071023032625.GA26559@gondor.apana.org.au>
References: <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org> <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org> <20071019023219.GB8453@gondor.apana.org.au> <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org> <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org> <20071019042025.GA9617@gondor.apana.org.au> <20071019044806.GA10080@gondor.apana.org.au> <1192769910.7367.106.camel@pasglop> <1193001005.6745.34.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193001005.6745.34.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:10:05AM +1000, Benjamin Herrenschmidt wrote:
>
> Hrm... not on yet. Herbert, care to resend, looks like it fell down the
> wrong hole in Linus mailbox :-)

Thanks for the reminder Ben.  Here it is again:

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
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
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
 
