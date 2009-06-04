Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZFDTJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZFDTJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZFDTJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:09:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50548 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZFDTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:09:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 4 Jun 2009 21:08:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: access bus_seconds atomically
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f7ecdcae445a1fac@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the unlikely event that card->driver->get_bus_time() is called during
a cycle64Seconds interrupt, we could read garbage unless atomic accesses
are used.

The switch to atomic ops requires to change the 64 seconds counter from
unsigned to signed, but this shouldn't matter to the end result.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 
+#include <asm/atomic.h>
 #include <asm/page.h>
 #include <asm/system.h>
 
@@ -178,7 +179,7 @@ struct fw_ohci {
 	int node_id;
 	int generation;
 	int request_generation;	/* for timestamping incoming requests */
-	u32 bus_seconds;
+	atomic_t bus_seconds;
 
 	bool use_dualbuffer;
 	bool old_uninorth;
@@ -1434,7 +1435,7 @@ static irqreturn_t irq_handler(int irq, 
 	if (event & OHCI1394_cycle64Seconds) {
 		cycle_time = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 		if ((cycle_time & 0x80000000) == 0)
-			ohci->bus_seconds++;
+			atomic_inc(&ohci->bus_seconds);
 	}
 
 	return IRQ_HANDLED;
@@ -1770,7 +1771,7 @@ static u64 ohci_get_bus_time(struct fw_c
 	u64 bus_time;
 
 	cycle_time = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
-	bus_time = ((u64) ohci->bus_seconds << 32) | cycle_time;
+	bus_time = ((u64)atomic_read(&ohci->bus_seconds) << 32) | cycle_time;
 
 	return bus_time;
 }

-- 
Stefan Richter
-=====-==--= -==- --=--
http://arcgraph.de/sr/

