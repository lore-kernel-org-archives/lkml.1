Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYJHRvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYJHRvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYJHRvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:51:12 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:38677 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754582AbYJHRvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:51:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wjZbZUf+QvW4NCS3U6MkD5ttGF2tcQ97qt6J7VA672+8znAGDMmuKzz8nwNgXzwaajDG/sBTvxA/TMEcf+xqhAdFMXonwyFCc8FEoYp0lFb3KYnYuYurn2xgNXcqkyKqc1Yin3JuccUX4eEzfP4gn9IZ3unHGDVJQ5+iAiaR3cA=  ;
X-YMail-OSG: vo8_bMoVM1n0jwVVXhW8I7WBtysHE.Z63GwhlLar9ero.m45gqO8kXLQw.GjucJpS6bHvAnHtA7BkirJnPJoF.5Tju39YeMHAadt7wSEoN4v0fRey_Ea03CWjZ3O8rrXnoVPD3OHeIrrKw_uIkgaELe_
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [patch 2.6.27-rc8-git] add drivers/mfd/twl4030-core.c
Date: Wed, 8 Oct 2008 10:50:59 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
References: <200810061047.50127.david-b@pacbell.net> <20081008171814.GB4766@localdomain>
In-Reply-To: <20081008171814.GB4766@localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810081051.00132.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008, Samuel Ortiz wrote:
> Thanks, applied to my mfd tree.

Great!

> > +#if defined(CONFIG_TWL4030_BCI_BATTERY) || \
> > +     defined(CONFIG_TWL4030_BCI_BATTERY_MODUEL)
> 
> minor typo, you probably meant: CONFIG_TWL4030_BCI_BATTERY_MODULE

Yes, good catch.  You'll tweak?

Appended is that simple IRQ cleanup I mentioned.
(Get a load of the diffstat!)

There's more substantial IRQ stuff on the way, but
it won't be ready before the 2.6.28 merges start.

- Dave

================== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

twl4030-core irq simplification

Simplify twl4030 IRQ handling by removing a needless custom flow
handler.  The top level IRQs, from the PIH, are well suited for
handle_simple_irq() ... they can't be acked or masked.

Switching resolves some issues with how IRQs were dispatched.
Notably, abuse of desc->status, IRQ accounting, and handling
of various faults.

In short, use standard genirq code.

Drivers that request_irq() to the PIH will need to pay more
attention to things like setting IRQF_DISABLED (since it's
no longer ignored), and making I2C calls from handlers (you'll
need a lockdep workaround).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mfd/twl4030-core.c |   68 +--------------------------------------------
 1 file changed, 2 insertions(+), 66 deletions(-)

--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -535,68 +535,6 @@ EXPORT_SYMBOL(twl4030_i2c_read_u8);
 
 /*----------------------------------------------------------------------*/
 
-/*
- * do_twl4030_module_irq() is the desc->handle method for each of the twl4030
- * module interrupts that doesn't chain to another irq_chip (GPIO, power, etc).
- * It executes in kernel thread context.  On entry, cpu interrupts are disabled.
- */
-static void do_twl4030_module_irq(unsigned int irq, irq_desc_t *desc)
-{
-	struct irqaction *action;
-	const unsigned int cpu = smp_processor_id();
-
-	/*
-	 * Earlier this was desc->triggered = 1;
-	 */
-	desc->status |= IRQ_LEVEL;
-
-	/*
-	 * The desc->handle method would normally call the desc->chip->ack
-	 * method here, but we won't bother since our ack method is NULL.
-	 */
-
-	if (!desc->depth) {
-		kstat_cpu(cpu).irqs[irq]++;
-
-		action = desc->action;
-		if (action) {
-			int ret;
-			int status = 0;
-			int retval = 0;
-
-			local_irq_enable();
-
-			do {
-				/* Call the ISR with cpu interrupts enabled */
-				ret = action->handler(irq, action->dev_id);
-				if (ret == IRQ_HANDLED)
-					status |= action->flags;
-				retval |= ret;
-				action = action->next;
-			} while (action);
-
-			if (status & IRQF_SAMPLE_RANDOM)
-				add_interrupt_randomness(irq);
-
-			local_irq_disable();
-
-			if (retval != IRQ_HANDLED)
-				printk(KERN_ERR "ISR for TWL4030 module"
-					" irq %d can't handle interrupt\n",
-					irq);
-
-			/*
-			 * Here is where we should call the unmask method, but
-			 * again we won't bother since it is NULL.
-			 */
-		} else
-			printk(KERN_CRIT "TWL4030 module irq %d has no ISR"
-					" but can't be masked!\n", irq);
-	} else
-		printk(KERN_CRIT "TWL4030 module irq %d is disabled but can't"
-				" be masked!\n", irq);
-}
-
 static unsigned twl4030_irq_base;
 
 static struct completion irq_event;
@@ -611,7 +549,6 @@ static int twl4030_irq_thread(void *data)
 	static unsigned i2c_errors;
 	const static unsigned max_i2c_errors = 100;
 
-	daemonize("twl4030-irq");
 	current->flags |= PF_NOFREEZE;
 
 	while (!kthread_should_stop()) {
@@ -691,8 +628,7 @@ static struct task_struct * __init start_twl4030_irq_thread(long irq)
 	struct task_struct *thread;
 
 	init_completion(&irq_event);
-	thread = kthread_run(twl4030_irq_thread, (void *)irq,
-			     "twl4030 irq %ld", irq);
+	thread = kthread_run(twl4030_irq_thread, (void *)irq, "twl4030-irq");
 	if (!thread)
 		pr_err("%s: could not create twl4030 irq %ld thread!\n",
 		       DRIVER_NAME, irq);
@@ -1126,7 +1062,7 @@ static void twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	/* install an irq handler for each of the PIH modules */
 	for (i = irq_base; i < irq_end; i++) {
 		set_irq_chip_and_handler(i, &twl4030_irq_chip,
-				do_twl4030_module_irq);
+				handle_simple_irq);
 		activate_irq(i);
 	}
 

