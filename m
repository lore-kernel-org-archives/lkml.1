Return-Path: <linux-kernel-owner+w=401wt.eu-S1161109AbXAZSAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161109AbXAZSAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161110AbXAZSAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:00:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33142 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbXAZSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:00:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 26 Jan 2007 19:00:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFT PATCH] ieee1394: ohci1394: serialize reset requests and irq
 handler
To: linux1394-devel@lists.sourceforge.net
cc: Robert Crocombe <rcrocomb@ieee.org>, linux-kernel@vger.kernel.org
Message-ID: <tkrat.5ef766da36a4a03a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ohci1394 has basically no protection against concurrent access to
registers.  I suspect this as a reason for bug "Host disappears on 1394
bus reset". http://bugzilla.kernel.org/show_bug.cgi?id=7569

The following changes are done here:
  - Use the ohci->event_lock to serialize the trigger for software-
    enforced bus resets against a large portion of the IRQ handler.
  - To accomplish this, cover much more regions of ohci_irq_handler
    by event_lock.  Needless to say, this has to be tested for a lot
    of scenarios.
  - Use spin_lock instead of spin_lock_irqsave in ohci_irq_handler.

It is somehow disturbing to see how the event_lock was originally taken
and released without discernable reason.

Todo:
  - Test.
  - Audit *all* of ohci1394's register accesses for the need of
    serialization by spinlocks + mmiowb.
  - Look into unifying ohci1394's internal locking to a single lock
    per host.
  - Audit the selfID complete event handling, including what happens
    higher up in ieee1394 core, for the possibility to move workload
    into tasklets or workqueue jobs.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Robert, does this do anything for your setup?  So far I only did a quick
test with a UP PC (kernel configured for SMP PREEMPT) and a FireWire HDD
and at least it didn't lock up...


 drivers/ieee1394/ohci1394.c |   51 ++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 28 deletions(-)


Index: linux-2.6.20-rc6/drivers/ieee1394/ohci1394.c
===================================================================
--- linux-2.6.20-rc6.orig/drivers/ieee1394/ohci1394.c	2007-01-26 16:59:45.000000000 +0100
+++ linux-2.6.20-rc6/drivers/ieee1394/ohci1394.c	2007-01-26 18:21:01.000000000 +0100
@@ -943,6 +943,7 @@ static int ohci_devctl(struct hpsb_host 
 
 	switch (cmd) {
 	case RESET_BUS:
+		spin_lock_irqsave(&ohci->event_lock, flags);
 		switch (arg) {
 		case SHORT_RESET:
 			phy_reg = get_phy_reg(ohci, 5);
@@ -990,6 +991,8 @@ static int ohci_devctl(struct hpsb_host 
 		default:
 			retval = -1;
 		}
+		mmiowb();
+		spin_unlock_irqrestore(&ohci->event_lock, flags);
 		break;
 
 	case GET_CYCLE_COUNTER:
@@ -2304,27 +2307,21 @@ static irqreturn_t ohci_irq_handler(int 
 	quadlet_t event, node_id;
 	struct ti_ohci *ohci = (struct ti_ohci *)dev_id;
 	struct hpsb_host *host = ohci->host;
-	int phyid = -1, isroot = 0;
-	unsigned long flags;
+	int phyid = -1, isroot = 0, call_selfid_complete = 0;
 
-	/* Read and clear the interrupt event register.  Don't clear
-	 * the busReset event, though. This is done when we get the
-	 * selfIDComplete interrupt. */
-	spin_lock_irqsave(&ohci->event_lock, flags);
-	event = reg_read(ohci, OHCI1394_IntEventClear);
-	reg_write(ohci, OHCI1394_IntEventClear, event & ~OHCI1394_busReset);
-	spin_unlock_irqrestore(&ohci->event_lock, flags);
-
-	if (!event)
-		return IRQ_NONE;
+	spin_lock(&ohci->event_lock);
 
-	/* If event is ~(u32)0 cardbus card was ejected.  In this case
-	 * we just return, and clean up in the ohci1394_pci_remove
-	 * function. */
-	if (event == ~(u32) 0) {
-		DBGMSG("Device removed.");
+	/* Read and clear the interrupt event register.  Don't clear the
+	 * busReset event though.  This is done when we get the selfIDComplete
+	 * interrupt.
+	 * If event is ~0, the CardBus card was ejected.  In this case we just
+	 * return and clean up in ohci1394_pci_remove. */
+	event = reg_read(ohci, OHCI1394_IntEventClear);
+	if (!event || !~event) {
+		spin_unlock(&ohci->event_lock);
 		return IRQ_NONE;
 	}
+	reg_write(ohci, OHCI1394_IntEventClear, event & ~OHCI1394_busReset);
 
 	DBGMSG("IntEvent: %08x", event);
 
@@ -2399,20 +2396,17 @@ static irqreturn_t ohci_irq_handler(int 
 		/* The busReset event bit can't be cleared during the
 		 * selfID phase, so we disable busReset interrupts, to
 		 * avoid burying the cpu in interrupt requests. */
-		spin_lock_irqsave(&ohci->event_lock, flags);
 		reg_write(ohci, OHCI1394_IntMaskClear, OHCI1394_busReset);
 
 		if (ohci->check_busreset) {
 			int loop_count = 0;
 
+			/* Remember kids: Don't do this at home. */
+			spin_unlock(&ohci->event_lock);
 			udelay(10);
-
 			while (reg_read(ohci, OHCI1394_IntEventSet) & OHCI1394_busReset) {
 				reg_write(ohci, OHCI1394_IntEventClear, OHCI1394_busReset);
-
-				spin_unlock_irqrestore(&ohci->event_lock, flags);
 				udelay(10);
-				spin_lock_irqsave(&ohci->event_lock, flags);
 
 				/* The loop counter check is to prevent the driver
 				 * from remaining in this state forever. For the
@@ -2428,8 +2422,8 @@ static irqreturn_t ohci_irq_handler(int 
 
 				loop_count++;
 			}
+			spin_lock(&ohci->event_lock);
 		}
-		spin_unlock_irqrestore(&ohci->event_lock, flags);
 		if (!host->in_bus_reset) {
 			DBGMSG("irq_handler: Bus reset requested");
 
@@ -2520,10 +2514,8 @@ static irqreturn_t ohci_irq_handler(int 
 
 			/* Clear the bus reset event and re-enable the
 			 * busReset interrupt.  */
-			spin_lock_irqsave(&ohci->event_lock, flags);
 			reg_write(ohci, OHCI1394_IntEventClear, OHCI1394_busReset);
 			reg_write(ohci, OHCI1394_IntMaskSet, OHCI1394_busReset);
-			spin_unlock_irqrestore(&ohci->event_lock, flags);
 
 			/* Turn on phys dma reception.
 			 *
@@ -2540,7 +2532,7 @@ static irqreturn_t ohci_irq_handler(int 
 			       reg_read(ohci, OHCI1394_PhyReqFilterHiSet),
 			       reg_read(ohci, OHCI1394_PhyReqFilterLoSet));
 
-			hpsb_selfid_complete(host, phyid, isroot);
+			call_selfid_complete = 1;
 		} else
 			PRINT(KERN_ERR,
 			      "SelfID received outside of bus reset sequence");
@@ -2552,9 +2544,12 @@ selfid_not_valid:
 	/* Make sure we handle everything, just in case we accidentally
 	 * enabled an interrupt that we didn't write a handler for.  */
 	if (event)
-		PRINT(KERN_ERR, "Unhandled interrupt(s) 0x%08x",
-		      event);
+		PRINT(KERN_ERR, "Unhandled interrupt(s) 0x%08x", event);
 
+	mmiowb();
+	spin_unlock(&ohci->event_lock);
+	if (call_selfid_complete)
+		hpsb_selfid_complete(host, phyid, isroot);
 	return IRQ_HANDLED;
 }
 

-- 
Stefan Richter
-=====-=-=== ---= ==-=-
http://arcgraph.de/sr/

