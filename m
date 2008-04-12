Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYDLT0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYDLT0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYDLT0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:26:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40236 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbYDLT0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:26:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Apr 2008 21:26:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: work around generation bug in TI
 controllers (fix AV/C and more)
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.95472d87fa4e6c81@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the ohci1394 driver, fw-ohci uses the selfIDGeneration field of
bus reset packets to determine the generation of incoming requests as
per OHCI 1.1 clause 8.4.2.3.  This is more precise --- provided that the
controller inserts the correct generation.  Texas Instruments chips
often don't.

This prevented the transmission of response packets, which for example
broke AV/C transactions as used when communicating with miniDV cameras
and any other AV/C devices.

There is apparently no way to detect and adjust incorrect generations.
Therefore we ignore the generation of bus reset packets from TI chips
and use the generation of the self ID buffer instead.  Alas this is
received at a slightly wrong time.  In rare cases, this could cause us
to not respond to legitimate requests in rare cases, or to respond to
expired requests.  (The latter is less likely because the bus reset
packet AR event is typically handled before the self ID complete event.)

Bug reported by Mladen Kuntner, who was extraordinarily patient while
dealing with the driver maintainers.
https://bugzilla.redhat.com/show_bug.cgi?id=243081

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -571,14 +571,22 @@ static __le32 *handle_ar_packet(struct a
 	 * generation.  We only need this for requests; for responses
 	 * we use the unique tlabel for finding the matching
 	 * request.
+	 *
+	 * Alas TI chips often emit bus reset packets with a wrong
+	 * generation.  As a trade-off, we set the correct generation
+	 * at a slightly incorrect time (in bus_reset_tasklet).
 	 */
+	if (evt == OHCI1394_evt_bus_reset) {
+		struct pci_dev *dev = to_pci_dev(ohci->card.device);
+
+		if (dev->vendor != PCI_VENDOR_ID_TI)
+			ohci->request_generation = (p.header[2] >> 16) & 0xff;
 
-	if (evt == OHCI1394_evt_bus_reset)
-		ohci->request_generation = (p.header[2] >> 16) & 0xff;
-	else if (ctx == &ohci->ar_request_ctx)
+	} else if (ctx == &ohci->ar_request_ctx) {
 		fw_core_handle_request(&ohci->card, &p);
-	else
+	} else {
 		fw_core_handle_response(&ohci->card, &p);
+	}
 
 	return buffer + length + 1;
 }
@@ -1209,6 +1217,7 @@ at_context_transmit(struct context *ctx,
 static void bus_reset_tasklet(unsigned long data)
 {
 	struct fw_ohci *ohci = (struct fw_ohci *)data;
+	struct pci_dev *dev = to_pci_dev(ohci->card.device);
 	int self_id_count, i, j, reg;
 	int generation, new_generation;
 	unsigned long flags;
@@ -1285,6 +1294,9 @@ static void bus_reset_tasklet(unsigned l
 	context_stop(&ohci->at_response_ctx);
 	reg_write(ohci, OHCI1394_IntEventClear, OHCI1394_busReset);
 
+	if (dev->vendor == PCI_VENDOR_ID_TI)
+		ohci->request_generation = generation;
+
 	/*
 	 * This next bit is unrelated to the AT context stuff but we
 	 * have to do it under the spinlock also.  If a new config rom

-- 
Stefan Richter
-=====-==--- -=-- -==--
http://arcgraph.de/sr/

