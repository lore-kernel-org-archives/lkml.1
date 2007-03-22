Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbXCVVJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbXCVVJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbXCVVJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:09:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51609 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXCVVJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:09:50 -0400
Date: Thu, 22 Mar 2007 14:09:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix irqpoll on IA64 (timer interrupt != 0)
Message-Id: <20070322140922.a59bea5c.akpm@linux-foundation.org>
In-Reply-To: <20070320150027.GA18143@strauss.suse.de>
References: <20070320150027.GA18143@strauss.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 16:00:27 +0100
Bernhard Walle <bwalle@suse.de> wrote:

> On IA64, the timer interrupt is not (always?) zero as it is on x86 platforms.
> Also, the timer interrupt is CPU-local. Two things need to be changed to make
> the irqpoll option make also working on IA64:
> 
>   o Call note_interrupt() also on CPU-local interrupts in __do_IRQ().
>   o Set a variable timer_irq to the value of the timer interrupt
>     after the timer interrupt has been registered and assigned.
> 
> That requires changes in Linux-generic files. The default of timer_irq is 0, so
> the patch doesn't break i386/x86_64. However, other platforms also may also
> have a timer interrupt non-equal to zero, so they can also use the new
> set_timer_interrupt() function.

Couple of things..

I think the term 'timer_interrupt' is a bit generic-sounding.  Would it be
better to call it irqpoll_interrupt?  After all, some architecture might
want to use, umm, the keyboard interrupt to trigger IRQ polling ;)  

Also, the code presently passes the magic IRQ number into the generic IRQ
code.  I wonder if we'd get a more pleasing result if we were to make the
generic IRQ code call _out_ to the architecture:


diff -puN kernel/irq/spurious.c~a kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~a
+++ a/kernel/irq/spurious.c
@@ -135,6 +135,11 @@ report_bad_irq(unsigned int irq, struct 
 	}
 }
 
+bool __attribute__((weak)) arch_is_irqpoll_irq(unsigned int irq)
+{
+	return false;
+}
+
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
@@ -146,7 +151,8 @@ void note_interrupt(unsigned int irq, st
 
 	if (unlikely(irqfixup)) {
 		/* Don't punish working computers */
-		if ((irqfixup == 2 && irq == 0) || action_ret == IRQ_NONE) {
+		if ((irqfixup == 2 && arch_is_irqpoll_irq(irq)) ||
+				action_ret == IRQ_NONE) {
 			int ok = misrouted_irq(irq);
 			if (action_ret == IRQ_NONE)
 				desc->irqs_unhandled -= ok;
diff -puN include/linux/irq.h~a include/linux/irq.h
--- a/include/linux/irq.h~a
+++ a/include/linux/irq.h
@@ -314,6 +314,7 @@ static inline void generic_handle_irq(un
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   int action_ret);
+extern bool arch_is_irqpoll_irq(unsigned int irq);
 
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
_


Then, ia64 can implement arch_is_irqpoll_irq() and it can do whatever it
wants in there.

The __attribute__((weak)) thing adds a little bit of overhead, but I don't
think this is a fastpath?

