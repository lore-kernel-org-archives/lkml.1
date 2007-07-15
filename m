Return-Path: <linux-kernel-owner+w=401wt.eu-S933042AbXGOBrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbXGOBrv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761469AbXGOBrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:47:43 -0400
Received: from mx33.mail.ru ([194.67.23.194]:24770 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760534AbXGOBrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:47:42 -0400
Date: Sun, 15 Jul 2007 05:43:04 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] pda_power: clean up irq, timer
Message-ID: <20070715014304.GA7474@zarina>
References: <46996A53.6000807@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <46996A53.6000807@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
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

This patch makes it easier to remove the 'irq' argument in the future,
in addition to cleaning up the driver today.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/power/pda_power.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 4e1eb04..8304506 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -101,32 +101,31 @@ static void update_charger(void)
 	return;
 }
 
-static void supply_timer_func(unsigned long irq)
+static void supply_timer_func(unsigned long power_supply_ptr)
 {
-	if (ac_irq && irq == ac_irq->start)
-		power_supply_changed(&pda_power_supplies[0]);
-	else if (usb_irq && irq == usb_irq->start)
-		power_supply_changed(&pda_power_supplies[1]);
+	void *power_supply = (void *) power_supply_ptr;
+
+	power_supply_changed(power_supply);
 	return;
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
 	return;
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
-- 
1.5.1.1-dirty

