Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXGNXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXGNXMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761085AbXGNXMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:12:07 -0400
Received: from havoc.gtf.org ([69.61.125.42]:56697 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbXGNXMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:12:06 -0400
Date: Sat, 14 Jul 2007 19:12:04 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, Anton Vorontsov <cbou@mail.ru>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pda_power: clean up irq, timer, return usage
Message-ID: <20070714231204.GA23582@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Clean up pda_power interrupt handling:

Prior to this patch, the driver would pass information it needed
to the interrupt handler dev_id pointer, and then prompt forget it
ever did so, recreating that same information after a couple passes
through the timer-based state machine.

This patch removes the redundant checks by passing the
pda_power_supply[] pointer through the state machine.  The current
code passed 'irq' through the state machine, as an index to recreate
the pointer, when we could more simply pass around the pointer itself.

Additionally, bogus "return;" statements were removed.

This patch makes it easier to remove the 'irq' argument in the future,
in addition to cleaning up the driver today.

P.S.  Where are the MAINTAINERS entries for this driver, and
drivers/power in general?

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 4e1eb04..dacbe50 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -97,36 +97,31 @@ static void update_charger(void)
 		dev_dbg(dev, "charger off\n");
 		pdata->set_charge(0);
 	}
-
-	return;
 }
 
-static void supply_timer_func(unsigned long irq)
+static void supply_timer_func(unsigned long power_supply_ptr)
 {
-	if (ac_irq && irq == ac_irq->start)
-		power_supply_changed(&pda_power_supplies[0]);
-	else if (usb_irq && irq == usb_irq->start)
-		power_supply_changed(&pda_power_supplies[1]);
-	return;
+	void *power_supply = (void *) power_supply_ptr;
+
+	power_supply_changed(power_supply);
 }
 
-static void charger_timer_func(unsigned long irq)
+static void charger_timer_func(unsigned long power_supply_ptr)
 {
 	update_charger();
 
 	/* Okay, charger set. Now wait a bit before notifying supplicants,
 	 * charge power should stabilize. */
-	supply_timer.data = irq;
+	supply_timer.data = power_supply_ptr;
 	mod_timer(&supply_timer,
 		  jiffies + msecs_to_jiffies(pdata->wait_for_charger));
-	return;
 }
 
-static irqreturn_t power_changed_isr(int irq, void *unused)
+static irqreturn_t power_changed_isr(int irq, void *power_supply)
 {
 	/* Wait a bit before reading ac/usb line status and setting charger,
 	 * because ac/usb status readings may lag from irq. */
-	charger_timer.data = irq;
+	charger_timer.data = (unsigned long) power_supply;
 	mod_timer(&charger_timer,
 		  jiffies + msecs_to_jiffies(pdata->wait_for_status));
 	return IRQ_HANDLED;
@@ -252,7 +247,6 @@ static int __init pda_power_init(void)
 static void __exit pda_power_exit(void)
 {
 	platform_driver_unregister(&pda_power_pdrv);
-	return;
 }
 
 module_init(pda_power_init);
