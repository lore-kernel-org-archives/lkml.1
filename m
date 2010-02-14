Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0BNRrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:47:15 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41351 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0BNRrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:47:14 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Feb 2010 18:46:27 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/4 resend] firewire: ohci: work around cycle timer bugs on
 VIA controllers
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
Message-ID: <tkrat.172c1afe35bf3d3a@s5r6.in-berlin.de>
References: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 20 Jan 2010 09:58:02 +0100
From: Clemens Ladisch <clemens@ladisch.de>

VIA controllers sometimes return an inconsistent value when reading the
isochronous cycle timer register.  To work around this, read the
register multiple times and add consistency checks.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: Pieter Palmers <pieterp@joow.be>
Reported-by: Håkan Johansson <f96hajo@chalmers.se>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   52 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 3 deletions(-)

Index: linux-2.6.33-rc8/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/ohci.c
+++ linux-2.6.33-rc8/drivers/firewire/ohci.c
@@ -192,6 +192,7 @@ struct fw_ohci {
 	bool use_dualbuffer;
 	bool old_uninorth;
 	bool bus_reset_packet_quirk;
+	bool iso_cycle_timer_quirk;
 
 	/*
 	 * Spinlock for accessing fw_ohci data.  Never call out of
@@ -1794,14 +1795,57 @@ static int ohci_enable_phys_dma(struct f
 #endif /* CONFIG_FIREWIRE_OHCI_REMOTE_DMA */
 }
 
+static inline u32 cycle_timer_ticks(u32 cycle_timer)
+{
+	u32 ticks;
+
+	ticks = cycle_timer & 0xfff;
+	ticks += 3072 * ((cycle_timer >> 12) & 0x1fff);
+	ticks += (3072 * 8000) * (cycle_timer >> 25);
+	return ticks;
+}
+
 static u64 ohci_get_bus_time(struct fw_card *card)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
-	u32 cycle_time;
+	u32 c0, c1, c2;
+	u32 t0, t1, t2;
+	s32 diff01, diff12;
 	u64 bus_time;
 
-	cycle_time = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
-	bus_time = ((u64)atomic_read(&ohci->bus_seconds) << 32) | cycle_time;
+	if (!ohci->iso_cycle_timer_quirk) {
+		c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
+	} else {
+		/*
+		 * VIA controllers have two bugs when updating the iso cycle
+		 * timer register:
+		 * 1) When the lowest six bits are wrapping around to zero,
+		 *    a read that happens at the same time will return garbage
+		 *    in the lowest ten bits.
+		 * 2) When the cycleOffset field wraps around to zero, the
+		 *    cycleCount field is not incremented for about 60 ns.
+		 *
+		 * To catch these, we read the register three times and ensure
+		 * that the difference between each two consecutive reads is
+		 * approximately the same, i.e., less than twice the other.
+		 * Furthermore, any negative difference indicates an error.
+		 * (A PCI read should take at least 20 ticks of the 24.576 MHz
+		 * timer to execute, so we have enough precision to compute the
+		 * ratio of the differences.)
+		 */
+		do {
+			c0 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
+			c1 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
+			c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
+			t0 = cycle_timer_ticks(c0);
+			t1 = cycle_timer_ticks(c1);
+			t2 = cycle_timer_ticks(c2);
+			diff01 = t1 - t0;
+			diff12 = t2 - t1;
+		} while (diff01 <= 0 || diff12 <= 0 ||
+			 diff01 / diff12 >= 2 || diff12 / diff01 >= 2);
+	}
+	bus_time = ((u64)atomic_read(&ohci->bus_seconds) << 32) | c2;
 
 	return bus_time;
 }
@@ -2503,6 +2547,8 @@ static int __devinit pci_probe(struct pc
 #endif
 	ohci->bus_reset_packet_quirk = dev->vendor == PCI_VENDOR_ID_TI;
 
+	ohci->iso_cycle_timer_quirk = dev->vendor == PCI_VENDOR_ID_VIA;
+
 	ar_context_init(&ohci->ar_request_ctx, ohci,
 			OHCI1394_AsReqRcvContextControlSet);
 

-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/

