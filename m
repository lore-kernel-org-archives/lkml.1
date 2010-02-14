Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0BNRuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:50:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41369 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0BNRuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:50:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Feb 2010 18:49:18 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4] firewire: remove incomplete Bus_Time CSR support
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
Message-ID: <tkrat.06b284b7903811c9@s5r6.in-berlin.de>
References: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of Bus_Time read access was buggy since it
did not ensure that Bus_Time.second_count_hi and second_count_lo came
from the same 128 seconds period.

Reported-by: Håkan Johansson <f96hajo@chalmers.se>

Instead of a fix, remove Bus_Time register support altogether.  The spec
requires all cycle master capable nodes to implement this (all Linux
nodes are cycle master capable) while it also says that it "may" be
initialized by the bus manager or by the IRM standing in for a bus
manager.  (Neither Linux' firewire-core nor ieee1394 nodemgr implement
this.)

Since we cannot rely on Bus_Time having been initialized by a bus
manager, it is better to return an error instead of a nonsensical value
on a read request to Bus_Time.

Alternatively, we could fix the Bus_Time read integrity bug _and_
implement (a) cycle master's write support of the register as well as
(b) bus manager's Bus_Time initialization service, i.e. preservation of
the Bus_Time when the cycle master node of a bus changes.  However, that
would be quite some code for a feature that is unreliable to begin with
and very likely unused in practice.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c        |    2 +-
 drivers/firewire/core-transaction.c |   17 ++++++-----------
 drivers/firewire/core.h             |    2 +-
 drivers/firewire/ohci.c             |   25 +++++++------------------
 4 files changed, 15 insertions(+), 31 deletions(-)

Index: linux-2.6.33-rc8/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.33-rc8/drivers/firewire/core-cdev.c
@@ -1039,7 +1039,7 @@ static int ioctl_get_cycle_timer(struct 
 
 	local_irq_disable();
 
-	cycle_time = card->driver->get_bus_time(card);
+	cycle_time = card->driver->get_cycle_time(card);
 	do_gettimeofday(&tv);
 
 	local_irq_enable();
Index: linux-2.6.33-rc8/drivers/firewire/core-transaction.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/core-transaction.c
+++ linux-2.6.33-rc8/drivers/firewire/core-transaction.c
@@ -921,23 +921,15 @@ static void handle_registers(struct fw_c
 		void *payload, size_t length, void *callback_data)
 {
 	int reg = offset & ~CSR_REGISTER_BASE;
-	unsigned long long bus_time;
 	__be32 *data = payload;
 	int rcode = RCODE_COMPLETE;
 
 	switch (reg) {
 	case CSR_CYCLE_TIME:
-	case CSR_BUS_TIME:
-		if (!TCODE_IS_READ_REQUEST(tcode) || length != 4) {
-			rcode = RCODE_TYPE_ERROR;
-			break;
-		}
-
-		bus_time = card->driver->get_bus_time(card);
-		if (reg == CSR_CYCLE_TIME)
-			*data = cpu_to_be32(bus_time);
+		if (TCODE_IS_READ_REQUEST(tcode) && length == 4)
+			*data = cpu_to_be32(card->driver->get_cycle_time(card));
 		else
-			*data = cpu_to_be32(bus_time >> 25);
+			rcode = RCODE_TYPE_ERROR;
 		break;
 
 	case CSR_BROADCAST_CHANNEL:
@@ -968,6 +960,9 @@ static void handle_registers(struct fw_c
 	case CSR_BUSY_TIMEOUT:
 		/* FIXME: Implement this. */
 
+	case CSR_BUS_TIME:
+		/* Useless without initialization by the bus manager. */
+
 	default:
 		rcode = RCODE_ADDRESS_ERROR;
 		break;
Index: linux-2.6.33-rc8/drivers/firewire/core.h
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/core.h
+++ linux-2.6.33-rc8/drivers/firewire/core.h
@@ -70,7 +70,7 @@ struct fw_card_driver {
 	int (*enable_phys_dma)(struct fw_card *card,
 			       int node_id, int generation);
 
-	u64 (*get_bus_time)(struct fw_card *card);
+	u32 (*get_cycle_time)(struct fw_card *card);
 
 	struct fw_iso_context *
 	(*allocate_iso_context)(struct fw_card *card,
Index: linux-2.6.33-rc8/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/ohci.c
+++ linux-2.6.33-rc8/drivers/firewire/ohci.c
@@ -38,7 +38,6 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 
-#include <asm/atomic.h>
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <asm/system.h>
@@ -187,7 +186,6 @@ struct fw_ohci {
 	int node_id;
 	int generation;
 	int request_generation;	/* for timestamping incoming requests */
-	atomic_t bus_seconds;
 
 	bool use_dualbuffer;
 	bool old_uninorth;
@@ -276,7 +274,7 @@ static void log_irqs(u32 evt)
 	    !(evt & OHCI1394_busReset))
 		return;
 
-	fw_notify("IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
+	fw_notify("IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s%s\n", evt,
 	    evt & OHCI1394_selfIDComplete	? " selfID"		: "",
 	    evt & OHCI1394_RQPkt		? " AR_req"		: "",
 	    evt & OHCI1394_RSPkt		? " AR_resp"		: "",
@@ -286,7 +284,6 @@ static void log_irqs(u32 evt)
 	    evt & OHCI1394_isochTx		? " IT"			: "",
 	    evt & OHCI1394_postedWriteErr	? " postedWriteErr"	: "",
 	    evt & OHCI1394_cycleTooLong		? " cycleTooLong"	: "",
-	    evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
 	    evt & OHCI1394_cycleInconsistent	? " cycleInconsistent"	: "",
 	    evt & OHCI1394_regAccessFail	? " regAccessFail"	: "",
 	    evt & OHCI1394_busReset		? " busReset"		: "",
@@ -294,8 +291,7 @@ static void log_irqs(u32 evt)
 		    OHCI1394_RSPkt | OHCI1394_reqTxComplete |
 		    OHCI1394_respTxComplete | OHCI1394_isochRx |
 		    OHCI1394_isochTx | OHCI1394_postedWriteErr |
-		    OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds |
-		    OHCI1394_cycleInconsistent |
+		    OHCI1394_cycleTooLong | OHCI1394_cycleInconsistent |
 		    OHCI1394_regAccessFail | OHCI1394_busReset)
 						? " ?"			: "");
 }
@@ -1385,7 +1381,7 @@ static void bus_reset_tasklet(unsigned l
 static irqreturn_t irq_handler(int irq, void *data)
 {
 	struct fw_ohci *ohci = data;
-	u32 event, iso_event, cycle_time;
+	u32 event, iso_event;
 	int i;
 
 	event = reg_read(ohci, OHCI1394_IntEventClear);
@@ -1455,12 +1451,6 @@ static irqreturn_t irq_handler(int irq, 
 			fw_notify("isochronous cycle inconsistent\n");
 	}
 
-	if (event & OHCI1394_cycle64Seconds) {
-		cycle_time = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
-		if ((cycle_time & 0x80000000) == 0)
-			atomic_inc(&ohci->bus_seconds);
-	}
-
 	return IRQ_HANDLED;
 }
 
@@ -1554,8 +1544,7 @@ static int ohci_enable(struct fw_card *c
 		  OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
 		  OHCI1394_isochRx | OHCI1394_isochTx |
 		  OHCI1394_postedWriteErr | OHCI1394_cycleTooLong |
-		  OHCI1394_cycleInconsistent |
-		  OHCI1394_cycle64Seconds | OHCI1394_regAccessFail |
+		  OHCI1394_cycleInconsistent | OHCI1394_regAccessFail |
 		  OHCI1394_masterIntEnable);
 	if (param_debug & OHCI_PARAM_DEBUG_BUSRESETS)
 		reg_write(ohci, OHCI1394_IntMaskSet, OHCI1394_busReset);
@@ -1821,7 +1810,7 @@ static u32 cycle_timer_ticks(u32 cycle_t
  * error.  (A PCI read should take at least 20 ticks of the 24.576 MHz timer to
  * execute, so we have enough precision to compute the ratio of the differences.)
  */
-static u64 ohci_get_bus_time(struct fw_card *card)
+static u32 ohci_get_cycle_time(struct fw_card *card)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	u32 c0, c1, c2;
@@ -1849,7 +1838,7 @@ static u64 ohci_get_bus_time(struct fw_c
 			 && i++ < 20);
 	}
 
-	return ((u64)atomic_read(&ohci->bus_seconds) << 32) | c2;
+	return c2;
 }
 
 static void copy_iso_headers(struct iso_context *ctx, void *p)
@@ -2429,7 +2418,7 @@ static const struct fw_card_driver ohci_
 	.send_response		= ohci_send_response,
 	.cancel_packet		= ohci_cancel_packet,
 	.enable_phys_dma	= ohci_enable_phys_dma,
-	.get_bus_time		= ohci_get_bus_time,
+	.get_cycle_time		= ohci_get_cycle_time,
 
 	.allocate_iso_context	= ohci_allocate_iso_context,
 	.free_iso_context	= ohci_free_iso_context,

-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/

