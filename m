Return-Path: <linux-kernel-owner+w=401wt.eu-S936567AbYD1QLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936567AbYD1QLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936361AbYD1QKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:10:50 -0400
Received: from www.tglx.de ([62.245.132.106]:39565 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935329AbYD1QKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:10:48 -0400
Date: Mon, 28 Apr 2008 18:10:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] let setup_irq reenable a shared irq
In-Reply-To: <20080428141116.GB9048@digi.com>
Message-ID: <alpine.LFD.1.10.0804281640220.3261@apollo.tec.linutronix.de>
References: <1209381171-5520-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <alpine.LFD.1.10.0804281443090.3261@apollo.tec.linutronix.de> <20080428141116.GB9048@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1028918151-1209397918=:3261"
Content-ID: <alpine.LFD.1.10.0804281806120.3261@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1028918151-1209397918=:3261
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.1.10.0804281806121.3261@apollo.tec.linutronix.de>

On Mon, 28 Apr 2008, Uwe Kleine-König wrote:
> > Oh no. There is lots of code in drivers, which does:
> > 
> >    disable_irq();
> >    do_some_protected_stuff();
> >    enable_irq();
> > 
> > So when the second driver is loaded on another CPU it would see the
> > IRQ_DISABLED bit set and unconditionally reenable the interrupt. 
> > 
> > This unprotects the protected operation and definitely triggers the
> > WARN_ON() in enable_irq() where we check for desc->depth == 0.
> mmpf.
> 
> It's not nice to use disable_irq()/enable_irq() in a driver, is it?

Well, it's not nice, but it's there (in rather large quantities)

> > Waht kind of scenario/devices do you have which trigger this ?
>
> It's a ns9215 SoC.  The rtc component has a clock flag that I need to
> set before accessing the address space.  After enabling the clock flag
> I get an irq if the rtc is up.  The rtc itself uses the same irq.  As I
> want to handle the clk enabling in platform code and the actual rtc in a
> driver I need a shared irq.
> Now the problem is that the rtc remembers its alarm flags over
> reboots[1] and starts asserting the irq when the platform code has
> requested the irq.
> 
> I currently see two ways to handle that:
>  1) find an alternative patch similar to the one I sent that don't break
>     driver code; or
>  2) let the platform code disable the rtc's irqs.
> 
> for 1) you need to remember the reason for disabling the irq (or fix all
> drivers not to use disable_irq()).  And 2) is ugly because I have to
> ioremap then.

1) makes a lot of sense, as we can see those stupid device/bios keeps
irq asserted problems once in a while. Giving the irq a new chance
when a new driver arrives is definitely not a bad idea. See patch
below.

Reworking all the drivers would be a nice but definitely non trivial
project and it needs the acceptance of all the affected subsystem
maintainers.

2) ioremap is not a really big deal, so that's not a good argument not
to put hardware back into the state which was found when we started
the box, especially when we know that it does stupid things
eventually.

Thanks,
	tglx

------------>

Subject: genirq: reenable a nobody cared disabled irq when a new driver arrives
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 28 Apr 2008 17:01:56 +0200

Uwe Kleine-Koenig has some strange hardware where one of the shared
interrupts can be asserted during boot before the appropriate driver
loads. Requesting the shared irq line from another driver results in a
spurious interrupt storm which finally disables the interrupt line.

I have seen similar behaviour on resume before (the hardware does not
work anymore so I can not verify) and this spurious irq issue is
raised on a regular base in bugreports.

Change the spurious disable logic to increment the disable depth and
mark the interrupt with an extra flag which allows us to reenable the
interrupt when a new driver arrives which requests the same irq
line. In the worst case this will disable the irq again via the
spurious trap, but there is a decent chance that the new driver is the
one which can handle the already asserted interrupt and makes the box
usable again.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h   |    1 +
 kernel/irq/manage.c   |   49 ++++++++++++++++++++++++++++++++-----------------
 kernel/irq/spurious.c |    4 ++--
 3 files changed, 35 insertions(+), 19 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -61,6 +61,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
 #define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
 #define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
+#define IRQ_SPURIOUS_DISABLED	0x00400000	/* IRQ was disabled by the spurious trap */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -149,6 +149,26 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
+static void __enable_irq(struct irq_desc *desc, unsigned int irq)
+{
+	switch (desc->depth) {
+	case 0:
+		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN_ON(1);
+		break;
+	case 1: {
+		unsigned int status = desc->status & ~IRQ_DISABLED;
+
+		/* Prevent probing on this irq: */
+		desc->status = status | IRQ_NOPROBE;
+		check_irq_resend(desc, irq);
+		/* fall-through */
+	}
+	default:
+		desc->depth--;
+	}
+}
+
 /**
  *	enable_irq - enable handling of an irq
  *	@irq: Interrupt to enable
@@ -168,22 +188,7 @@ void enable_irq(unsigned int irq)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	switch (desc->depth) {
-	case 0:
-		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
-		WARN_ON(1);
-		break;
-	case 1: {
-		unsigned int status = desc->status & ~IRQ_DISABLED;
-
-		/* Prevent probing on this irq: */
-		desc->status = status | IRQ_NOPROBE;
-		check_irq_resend(desc, irq);
-		/* fall-through */
-	}
-	default:
-		desc->depth--;
-	}
+	__enable_irq(desc, irq);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL(enable_irq);
@@ -364,7 +369,7 @@ int setup_irq(unsigned int irq, struct i
 			compat_irq_chip_set_default_handler(desc);
 
 		desc->status &= ~(IRQ_AUTODETECT | IRQ_WAITING |
-				  IRQ_INPROGRESS);
+				  IRQ_INPROGRESS | IRQ_SPURIOUS_DISABLED);
 
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
@@ -380,6 +385,16 @@ int setup_irq(unsigned int irq, struct i
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
+
+	/*
+	 * Check whether we disabled the irq via the spurious handler
+	 * before. Reenable it and give it another chance.
+	 */
+	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
+		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+		__enable_irq(desc, irq);
+	}
+
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	new->irq = irq;
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -209,8 +209,8 @@ void note_interrupt(unsigned int irq, st
 		 * Now kill the IRQ
 		 */
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->status |= IRQ_DISABLED;
-		desc->depth = 1;
+		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
+		desc->depth++;
 		desc->chip->disable(irq);
 	}
 	desc->irqs_unhandled = 0;
--8323328-1028918151-1209397918=:3261--
