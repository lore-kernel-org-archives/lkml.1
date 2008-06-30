Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbYF3TBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbYF3TBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762570AbYF3TBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:01:36 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:15508 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762503AbYF3TBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:01:35 -0400
Date: Mon, 30 Jun 2008 23:01:32 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: [RT] MPIC edge sensitive issues with hardirq preemption (was: Re:
	[PATCH v2 -rt] ide: workaround buggy hardware issues with
	preemptable hardirqs)
Message-ID: <20080630190132.GA6492@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080628005436.GA1956@polina.dev.rtsoft.ru> <1214781974.20711.7.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1214781974.20711.7.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 09:26:14AM +1000, Benjamin Herrenschmidt wrote:
> On Sat, 2008-06-28 at 04:54 +0400, Anton Vorontsov wrote:
> > IDE interrupt handler relies on the fact that, if necessary, hardirqs
> > will re-trigger on ISR exit. The assumption is valid for level sensitive
> > interrupts.
> > 
> > But some hardware (namely ULi M5228 in the ULi M1575 "Super South Brige")
> > behaves in a strange way: it asserts interrupts as edge sensitive. And
> > because preemptable IRQ handler disables PIC's interrupt, PIC will likely
> > miss it.
> 
> Don't we replay edge IRQs that happen while soft-disabled ? Could be a
> bug in your PIC code not to do so...
	
Thanks for the idea. With hardirq preempton, fasteoi path does not replay
edge interrupts indeed (at least for MPIC).

Here how I tested this: I have external interrupt connected to the button
on this board, thus I registered irq handler which is doing exactly this
(irq is edge sensitive):

printk("handled\n"); mdelay(2000);

Without hardirq preemption: pressing button twice prints two messages.
With hardirq preemption: pressing button twice prints just one message.

This happens because:
- irq has come;
- fasteoi handler mask()s it, and wakes up the thread;
- thread calls irq handler;
- another IRQ is coming, but MPIC's IRQ is still masked and MPIC does not
  see it.
- thread unmasks the IRQ, second IRQ got lost.

But how this could be a bug in the PIC code? IMO this is a bug in the
kernel/irq code, since it assumes that fasteoi PIC will retrigger masked
edge sources... This isn't true for at least MPIC. To make this work for
all fasteoi PICs, we should mask edge sensitive interrupts very very
carefully.

Also...

I found that I completely messed with MPIC's sense types: my brain was
jammed with the idea that MPIC irq type 0 is low level sensitive, but the
true thing is that it is rising edge sensitive. (Ah, I know where I got
confused, type 0 is active-low for ISA PICs).

So in all my previous emails I was wrong when I was saying "mpic is
programmed to low level sensitive". It was programmed for rising edge
sensitive. An all my further reasonings were flawed because of this.

Re-programming MPIC to high level sensitive also makes IDE work. But
this doesn't mean that IRQ code is correct.

So, in the end, this isn't IDE issue... Much thanks to everyone for
ideas and help... instead of one bug, it seems I've found two. :-)
None in the IDE code.


Following patch fixes MPIC edge sensitive interrupts processing with
hardirqs preemption.

We're still using handle_fasteoi_irq, but passing control to
thread_edge_irq if interrupt is edge sensitive. Otherwise usual fasteoi
path handles the IRQ.

Plys, we're masking edge interrupt _and_ marking it as pending and masked
only if we're already handling one (exactly as we do with !preemptable
hardirqs). And the trick is that thread_edge_irq() will unmask it before
executing handle_IRQ_event.


So here is the patch, how does it look?

(quite weird that I have to pass irq trigger flags to desc->status,
but really, there is no other way. it seems safe though, because
all irqactions should conform only to one trigger type).


diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 9aa6b24..6c9f4ae 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -134,6 +134,10 @@ int set_irq_type(unsigned int irq, unsigned int type)
 	if (desc->chip->set_type) {
 		spin_lock_irqsave(&desc->lock, flags);
 		ret = desc->chip->set_type(irq, type);
+		if (!ret) {
+			desc->status &= ~IRQ_TYPE_SENSE_MASK;
+			desc->status |= type & IRQ_TYPE_SENSE_MASK;
+		}
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 	return ret;
@@ -430,7 +434,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	action = desc->action;
 	if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
 						 IRQ_DISABLED)))) {
-		desc->status |= IRQ_PENDING;
+		desc->status |= IRQ_PENDING | IRQ_MASKED;
 		if (desc->chip->mask)
 			desc->chip->mask(irq);
 		goto out;
@@ -439,9 +443,10 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	desc->status |= IRQ_INPROGRESS;
 	/*
 	 * In the threaded case we fall back to a mask+eoi sequence:
+	 * Though, we don't mask edge interrupts, thread may lose it then.
 	 */
 	if (redirect_hardirq(desc)) {
-		if (desc->chip->mask)
+		if (!(desc->status & IRQ_TYPE_EDGE_BOTH) && desc->chip->mask)
 			desc->chip->mask(irq);
 		goto out;
 	}
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c30aa1e..ffeb87f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -385,10 +385,11 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			if (desc->chip && desc->chip->set_type)
+			if (desc->chip && desc->chip->set_type) {
 				desc->chip->set_type(irq,
 						new->flags & IRQF_TRIGGER_MASK);
-			else
+				desc->status |= new->flags & IRQF_TRIGGER_MASK;
+			} else
 				/*
 				 * IRQF_TRIGGER_* but the PIC does not support
 				 * multiple flow-types?
@@ -772,9 +773,12 @@ static void do_hardirq(struct irq_desc *desc)
 		thread_simple_irq(desc);
 	else if (desc->handle_irq == handle_level_irq)
 		thread_level_irq(desc);
-	else if (desc->handle_irq == handle_fasteoi_irq)
-		thread_fasteoi_irq(desc);
-	else if (desc->handle_irq == handle_edge_irq)
+	else if (desc->handle_irq == handle_fasteoi_irq) {
+		if (desc->status & IRQ_TYPE_EDGE_BOTH)
+			thread_edge_irq(desc);
+		else
+			thread_fasteoi_irq(desc);
+	} else if (desc->handle_irq == handle_edge_irq)
 		thread_edge_irq(desc);
 	else
 		thread_do_irq(desc);
