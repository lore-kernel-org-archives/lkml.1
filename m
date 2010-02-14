Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0BNRr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:47:56 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41360 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0BNRry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:47:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Feb 2010 18:47:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: ohci: enable cycle timer fix on ALi and NEC
 controllers
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
Message-ID: <tkrat.638ff24c1118a82a@s5r6.in-berlin.de>
References: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discussed in "read_cycle_timer backwards for sub-cycle 0000, 0001",
http://thread.gmane.org/gmane.linux.kernel.firewire.devel/13704

Known bad controllers:
  ALi M5271, listed by lspci as M5253 [10b9:5253]
  NEC OrangeLink [1033:00cd] (rev 03)
  NEC uPD72874 [1033:00f2] (rev 01)
  VIA VT6306 [1106:3044] (rev 46)
  VIA VT6308P, listed by lspci as rev c0

Reported-by: Pieter Palmers <pieterp@joow.be>
Reported-by: Håkan Johansson <f96hajo@chalmers.se>
Reported-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6.33-rc8/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/ohci.c
+++ linux-2.6.33-rc8/drivers/firewire/ohci.c
@@ -1817,13 +1817,14 @@ static u64 ohci_get_bus_time(struct fw_c
 		c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 	} else {
 		/*
-		 * VIA controllers have two bugs when updating the iso cycle
-		 * timer register:
-		 * 1) When the lowest six bits are wrapping around to zero,
+		 * Some controllers exhibit one or more of the following bugs
+		 * when updating the iso cycle timer register:
+		 *  - When the lowest six bits are wrapping around to zero,
 		 *    a read that happens at the same time will return garbage
 		 *    in the lowest ten bits.
-		 * 2) When the cycleOffset field wraps around to zero, the
+		 *  - When the cycleOffset field wraps around to zero, the
 		 *    cycleCount field is not incremented for about 60 ns.
+		 *  - Occasionally, the entire register reads zero.
 		 *
 		 * To catch these, we read the register three times and ensure
 		 * that the difference between each two consecutive reads is
@@ -2547,7 +2548,9 @@ static int __devinit pci_probe(struct pc
 #endif
 	ohci->bus_reset_packet_quirk = dev->vendor == PCI_VENDOR_ID_TI;
 
-	ohci->iso_cycle_timer_quirk = dev->vendor == PCI_VENDOR_ID_VIA;
+	ohci->iso_cycle_timer_quirk = dev->vendor == PCI_VENDOR_ID_AL	||
+				      dev->vendor == PCI_VENDOR_ID_NEC	||
+				      dev->vendor == PCI_VENDOR_ID_VIA;
 
 	ar_context_init(&ohci->ar_request_ctx, ohci,
 			OHCI1394_AsReqRcvContextControlSet);

-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/

