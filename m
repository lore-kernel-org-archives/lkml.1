Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbXD0B3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbXD0B3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXD0B3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:29:13 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63846 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbXD0B3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:29:12 -0400
Subject: [PATCH -rt] Stop interrupt storm for fasteoi.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@mvista.com>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 21:28:47 -0400
Message-Id: <1177637327.23576.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I've spent several days banging my head on this bug, and I finally found
it. I originally thought we had a bug with the latency tracer, since it
seemed to only occur when I turned on latency tracing.  But I guess it
just changed the timings to cause the bug to happen. Now that I found
where the bug is, I don't know how it ever worked, even without the
tracing.

When taking an Ethernet interrupt, it was handled by handle_fasteoi_irq.

handle_fasteoi_irq, when the irq is handled by a thread, sets the irq
INPROGRESS and masks the irq.

Before leaving handle_fasteoi_irq, a call to desc->chip->eoi is called.

For the apic, this will call move_native_irq.

In the -rt kernel, move_native_irq masks the irq, moves it, and then
blindly unmasks it.  So when interrupts are turned on next, we take an
interrupt storm.

The other handlers besides handle_fasteoi_irq mask the irq regardless of
whether the irq is INPROGRESS.  But handle_fasteoi_irq will not mask it,
if the irq is already INPROGRESS, and just returns. So we keep taking
the same interrupt.

So, I change move_native_irq to not mask and unmask if the irq is
currently INPROGRESS.  But... I'm not sure if this is ok or not, since I
don't know all the uses to this.

My original patch was just to do a 

   +@@ -68,6 +68,9 @@ void move_native_irq(int irq)
         if (unlikely(desc->status & IRQ_DISABLED))
                 return;

        if (unlikely(desc->status & IRQ_INPROGRESS))
  +               return;
  +
         desc->chip->mask(irq);
         move_masked_irq(irq);
         desc->chip->unmask(irq);


But I thought that this might be too big of a hammer to this nail. So I
changed it to the patch below.


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rt1-i386/kernel/irq/migration.c
===================================================================
--- linux-2.6.21-rt1-i386.orig/kernel/irq/migration.c
+++ linux-2.6.21-rt1-i386/kernel/irq/migration.c
@@ -61,6 +61,7 @@ void move_masked_irq(int irq)
 void move_native_irq(int irq)
 {
 	struct irq_desc *desc = irq_desc + irq;
+	int mask = 1;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -68,8 +69,17 @@ void move_native_irq(int irq)
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->chip->mask(irq);
+	/*
+	 * If the irq is already in progress, it should be masked.
+	 * If we unmask it, we might cause an interrupt storm on RT.
+	 */
+	if (unlikely(desc->status & IRQ_INPROGRESS))
+		mask = 0;
+
+	if (mask)
+		desc->chip->mask(irq);
 	move_masked_irq(irq);
-	desc->chip->unmask(irq);
+	if (mask)
+		desc->chip->unmask(irq);
 }
 


