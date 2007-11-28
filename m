Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbXK1PpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbXK1PpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXK1PpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:45:00 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7944 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbXK1Po7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:44:59 -0500
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling
	can/will stall forever
From: Daniel Walker <dwalker@mvista.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
	 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
	 <1196176294.13982.58.camel@localhost.localdomain>
	 <1196177122.23808.7.camel@imap.mvista.com>
	 <1196178834.23808.11.camel@imap.mvista.com>
	 <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 07:36:38 -0800
Message-Id: <1196264198.27964.12.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 15:38 +0100, Remy Bohmer wrote:
> Hello Daniel,
> 
> >  *      Note: The caller is expected to handle the ack, clear, mask and
> >  *      unmask issues if necessary.
> > So we shouldn't need any flow control unless there is some other
> > factors..
> 
> This comment can be misinterpreted, I think. Who is assumed to be the
> caller in this context? The 2 other routines in the driver that
> actually do the unmasking stuff besides only calling this routine? Is
> it allowed to call it directly or should it always be done through a
> wrapper that does all these special things?

The later I think .. 

> Either way, only masking interrupts, and never unmasking it, is a bug.
> If interrupts come and go slow enough you never run into this problem,
> and if this type is not used often, nobody will notice it.
> Usually interrupts needs clearence of the source before the hardware
> can generate a new one. GPIO interrupts are different, they are
> generated whenever a IO-level changes, there is no acknowledge or
> clearing of the interupt needed. These types of interrupts are never
> 'pending' from hardware point of view. So, with these type of
> interrupts, a new one can occur while the interrupt handler has not
> handled the previous one yet, and therefor these interrupt-types will
> show this bug.

Yeah, it's clear there needs to be an unmask for this special case..
I've attached a patch which only handles the special case.. Could you
test/review it..

> >
> > Additionally, we have a patch in the real time tree called
> > "irq-mask-fix.patch" which adds an "unmask" to handle_simple_irq, but as
> > the note says we don't need flow control..
> 
> You mean the Montavista real time tree?

No .. I wouldn't comment about an company specific tree. I was talking
about the broken out real time patches.

Daniel

--------


Remove the IRQ_PENDING flag if it's asserted, and unmask the irq. Also loop
around to account for the pending interrupt.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/irq/manage.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

Index: linux-2.6.23/kernel/irq/manage.c
===================================================================
--- linux-2.6.23.orig/kernel/irq/manage.c
+++ linux-2.6.23/kernel/irq/manage.c
@@ -646,7 +646,7 @@ __setup("hardirq-preempt=", hardirq_pree
 /*
  * threaded simple handler
  */
-static void thread_simple_irq(irq_desc_t *desc)
+static void thread_core_irq(irq_desc_t *desc)
 {
 	struct irqaction *action = desc->action;
 	unsigned int irq = desc - irq_desc;
@@ -664,13 +664,35 @@ static void thread_simple_irq(irq_desc_t
 }
 
 /*
+ * threaded fasteoi type irq handler
+ */
+static void thread_simple_irq(irq_desc_t *desc)
+{
+	unsigned int irq = desc - irq_desc;
+
+	do {
+		/*
+		 * When another irq arrived while we were handling
+		 * one, we could have masked the irq.
+		 * Renable it, if it was not disabled in meantime.
+		 */
+		if (unlikely(desc->status & IRQ_PENDING)) {
+			desc->status &= ~IRQ_PENDING;
+			desc->chip->unmask(irq);
+		}
+		thread_core_irq(desc);
+	} while ((desc->status & (IRQ_PENDING | IRQ_INPROGRESS)));
+
+}
+
+/*
  * threaded level type irq handler
  */
 static void thread_level_irq(irq_desc_t *desc)
 {
 	unsigned int irq = desc - irq_desc;
 
-	thread_simple_irq(desc);
+	thread_core_irq(desc);
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
 }
@@ -682,7 +704,7 @@ static void thread_fasteoi_irq(irq_desc_
 {
 	unsigned int irq = desc - irq_desc;
 
-	thread_simple_irq(desc);
+	thread_core_irq(desc);
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
 }


