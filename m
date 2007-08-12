Return-Path: <linux-kernel-owner+w=401wt.eu-S936275AbXHLPq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936275AbXHLPq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935278AbXHLPoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:44:37 -0400
Received: from www.osadl.org ([213.239.205.134]:50309 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934221AbXHLPog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:44:36 -0400
Message-Id: <20070812152303.130044485@inhelltoy.tec.linutronix.de>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 15:46:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>
Subject: [patch 2/3] genirq: suppress resend of level interrupts
Content-Disposition: inline;
	filename=genirq-do-suppress-resend-of-level-type-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Level type interrupts are resent by the interrupt hardware when
they are still active at irq_enable().

Suppress the resend mechanism for interrupts marked as level.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/irq/resend.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/irq/resend.c
===================================================================
--- linux-2.6.orig/kernel/irq/resend.c	2007-08-12 17:18:04.000000000 +0200
+++ linux-2.6/kernel/irq/resend.c	2007-08-12 17:18:04.000000000 +0200
@@ -62,7 +62,12 @@ void check_irq_resend(struct irq_desc *d
 	 */
 	desc->chip->enable(irq);
 
-	if ((status & (IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
+	/*
+	 * We do not resend level type interrupts. Level type
+	 * interrupts are resent by hardware when they are still
+	 * active.
+	 */
+	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
 		if (!desc->chip || !desc->chip->retrigger ||

-- 

