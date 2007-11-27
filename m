Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbXK0PMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbXK0PMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbXK0PMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:12:34 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:48431 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbXK0PMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:12:32 -0500
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling
	can/will stall forever
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>
In-Reply-To: <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
	 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 10:11:34 -0500
Message-Id: <1196176294.13982.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Can you ACK or NACK this patch.  I know you play with a bunch of
hardware that this patch may affect.

Thanks,

-- Steve


On Mon, 2007-11-26 at 14:45 +0100, Remy Bohmer wrote:
> Attached the same patch, but it also cleans the manage.c code a bit,
> because the IRQ types 'simple IRQ', 'level-IRQ' and 'FastEOI' were
> handled differently while they should be handled the same.
> 
> Kind Regards,
> 
> Remy
> 
> 2007/11/26, Remy Bohmer <linux@bohmer.net>:
> > Hello,
> >
> > I use 2.6.23.1-rt5 on the Atmel AT91 series.
> > Interrupt threading on Preempt-RT and ARM works fine, except for
> > (edge-triggered) GPIO interrupts. There is a problem when a new
> > interrupt arives while the interrupt thread is handling the previous
> > interrupt. If this occurs the interrupt handling stalls forever.
> >
> > This is caused by a unbalanced interrupt mask/unmask problem in the kernel.
> > The attached patch fixes this. More information about this problem is
> > documented inside the patch itself.
> >
> > This patch is meant for Preempt-RT only.
> >
> > Kind Regards,
> >
> > Remy Bohmer
> >
> >

On ARM there is a problem where the interrupt handler stalls when they are 
coming faster than the kernel can handle.

The problem occurs when the routine handle_simple_irq() masks the interrupt 
when an IRQ-thread is handling the interrupt at the same time. (IRQ_INPROGRESS
is set). The interrupt thread, however does **never** a 
desc->chip->unmask(), so the interrupt becomes disabled forever.

IRQ_DISABLED is usually not set for this interrupt

This is in kernel/irq/chip.c, where the irq is masked when a IRQ-thread is
running: 
--------------------------------------------------------------------------
void fastcall
handle_simple_irq(unsigned int irq, struct irq_desc *desc)
{

....
....

	if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
						 IRQ_DISABLED)))) {
(!!)->		if (desc->chip->mask)
(!!)->			desc->chip->mask(irq);
		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
		desc->status |= IRQ_PENDING;
		goto out_unlock;
	}

....
....
}
--------------------------------------------------------------------------

Masking the interrupt seems valid, because the interrupt handler thread is 
still running, so it can handle the new pending interrupt. But, it has to be
umasked somewhere. The logical place is to do this in kernel/irq/manage.c, 
because this situation is also handled for the thread_level_irq() and 
thread_fasteoi_irq(), but not for thread_simple_irq(). This patch adds this
for these kind of interrupts also.

Signed-off-by: Remy Bohmer <linux@bohmer.net>
---
 kernel/irq/manage.c |   29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

Index: linux-2.6.23/kernel/irq/manage.c
===================================================================
--- linux-2.6.23.orig/kernel/irq/manage.c	2007-11-26 13:46:58.000000000 +0100
+++ linux-2.6.23/kernel/irq/manage.c	2007-11-26 14:43:32.000000000 +0100
@@ -646,28 +646,7 @@ static void thread_simple_irq(irq_desc_t
 			note_interrupt(irq, desc, action_ret);
 	}
 	desc->status &= ~IRQ_INPROGRESS;
-}
-
-/*
- * threaded level type irq handler
- */
-static void thread_level_irq(irq_desc_t *desc)
-{
-	unsigned int irq = desc - irq_desc;
-
-	thread_simple_irq(desc);
-	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(irq);
-}
-
-/*
- * threaded fasteoi type irq handler
- */
-static void thread_fasteoi_irq(irq_desc_t *desc)
-{
-	unsigned int irq = desc - irq_desc;
 
-	thread_simple_irq(desc);
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
 }
@@ -747,12 +726,10 @@ static void do_hardirq(struct irq_desc *
 	if (!(desc->status & IRQ_INPROGRESS))
 		goto out;
 
-	if (desc->handle_irq == handle_simple_irq)
+	if ((desc->handle_irq == handle_simple_irq) ||
+	    (desc->handle_irq == handle_level_irq)  ||
+	    (desc->handle_irq == handle_fasteoi_irq))
 		thread_simple_irq(desc);
-	else if (desc->handle_irq == handle_level_irq)
-		thread_level_irq(desc);
-	else if (desc->handle_irq == handle_fasteoi_irq)
-		thread_fasteoi_irq(desc);
 	else if (desc->handle_irq == handle_edge_irq)
 		thread_edge_irq(desc);
 	else


