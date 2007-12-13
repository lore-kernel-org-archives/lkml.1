Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbXLMG6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbXLMG6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761104AbXLMGzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55036 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760980AbXLMGzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:47 -0500
Date: Wed, 12 Dec 2007 22:51:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 07/60] Fix synchronize_irq races with IRQ handler
Message-ID: <20071213065121.GH6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-synchronize_irq-races-with-irq-handler.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

patch a98ce5c6feead6bfedefabd46cb3d7f5be148d9a in mainline.

Fix synchronize_irq races with IRQ handler

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/manage.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

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
 

-- 
