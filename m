Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0BUQ7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:59:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58377 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab0BUQ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:59:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:58:52 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 7/8] firewire: ohci: fix IR/IT context mask mixup
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.cf421c1f87e76626@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was present in firewire-ohci since day one:  The number of
available isochronous receive DMA contexts was mixed up with that of
available isochronous transmit DMA contexts.

This is harmless on a few chips which offer the same number of contexts
in both directions, but most chips nowadays implement only the standard
minimum of 4 IR contexts, but 8 IT contexts.  If a user attempted to run
a lot of IR contexts at once, results with more than four were therefore
unpredictable.  I suppose the controller would simply refuse to start
DMA of any unimplemented context.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2395,17 +2395,17 @@ static int __devinit pci_probe(struct pc
 		     OHCI1394_AsRspTrContextControlSet, handle_at_packet);
 
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskSet, ~0);
-	ohci->it_context_mask = reg_read(ohci, OHCI1394_IsoRecvIntMaskSet);
+	ohci->ir_context_channels = ~0ULL;
+	ohci->ir_context_mask = reg_read(ohci, OHCI1394_IsoRecvIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskClear, ~0);
-	size = sizeof(struct iso_context) * hweight32(ohci->it_context_mask);
-	ohci->it_context_list = kzalloc(size, GFP_KERNEL);
+	size = sizeof(struct iso_context) * hweight32(ohci->ir_context_mask);
+	ohci->ir_context_list = kzalloc(size, GFP_KERNEL);
 
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskSet, ~0);
-	ohci->ir_context_channels = ~0ULL;
-	ohci->ir_context_mask = reg_read(ohci, OHCI1394_IsoXmitIntMaskSet);
+	ohci->it_context_mask = reg_read(ohci, OHCI1394_IsoXmitIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskClear, ~0);
-	size = sizeof(struct iso_context) * hweight32(ohci->ir_context_mask);
-	ohci->ir_context_list = kzalloc(size, GFP_KERNEL);
+	size = sizeof(struct iso_context) * hweight32(ohci->it_context_mask);
+	ohci->it_context_list = kzalloc(size, GFP_KERNEL);
 
 	if (ohci->it_context_list == NULL || ohci->ir_context_list == NULL) {
 		err = -ENOMEM;

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

