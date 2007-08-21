Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbXHUJQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbXHUJQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXHUJQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:16:00 -0400
Received: from mx10.go2.pl ([193.17.41.74]:39731 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbXHUJP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:15:58 -0400
Date: Tue, 21 Aug 2007 11:17:00 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: handle_fasteoi_irq vs IRQ_INPROGRESS && IRQ_DISABLED
Message-ID: <20070821091700.GB1778@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've still some doubts about these irq handlers and I hope somebody
could explain some of these (despite my problems with earlier such
explanations, sorry...):

1. According to some well-known Intel's manual (vol.3A page 8-41)
lapic can interrupt irq handler dispatching higher-priority irq; it
seems, such an event is possible during handle_IRQ_event, and would
be treated by "common" handlers with IRQ_INPROGRESS; but:

a) handle_level_irq and handle_edge_irq do unconditional ack-masking
and return; so, I wonder how, after finishing with this current one,
the higher-priority level type and masked irq could find it's way
home/cpu? (edge type would be retriggered, of course)

b) handle_fasteoi_irq acks but doesn't mask, so isn't it possible
this irq would be repeated by ioapic soon, maybe with some looping?
BTW: below is my patch proposal to exclude such thing at least when
IRQ_DISABLED.

2. I wonder, why handle_edge_irq kstat_cpu counter works different
than others (i.e. counts less).

Thanks,
Jarek P.

-------->

Don't let handle_fasteoi_irq() delay irq masking when IRQ_INPROGRESS
&& IRQ_DISABLED.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.23-rc2-/kernel/irq/chip.c 2.6.23-rc2/kernel/irq/chip.c
--- 2.6.23-rc2-/kernel/irq/chip.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc2/kernel/irq/chip.c	2007-08-21 08:50:36.000000000 +0200
@@ -392,7 +392,8 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	spin_lock(&desc->lock);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
+	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED))
+			== IRQ_INPROGRESS))
 		goto out;
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
