Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYCIUuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYCIUuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYCIUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:49:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57014 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYCIUtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:49:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 9 Mar 2008 21:49:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: debug AT, AR, and selfID-complete events
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds debug printks for asynchronous transmission and reception and
for self ID reception.  The debug code is per default deactivated by #if
blocks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

I am undecided whether this is OK for mainline, and whether the debug
options should become a Kconfig option or runtime options.

It may be temporarily useful to the few driver developers.  Do we want
end users to provide us with debug logs of this kind?  Then it should
be one or two runtime options.


 drivers/firewire/fw-ohci.c |  113 +++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -40,6 +40,9 @@
 #include "fw-ohci.h"
 #include "fw-transaction.h"
 
+#define FIREWIRE_OHCI_DEBUG_AT_AR	0
+#define FIREWIRE_OHCI_DEBUG_SELFIDS	0
+
 #define DESCRIPTOR_OUTPUT_MORE		0
 #define DESCRIPTOR_OUTPUT_LAST		(1 << 12)
 #define DESCRIPTOR_INPUT_MORE		(2 << 12)
@@ -316,6 +319,71 @@ static int ar_context_add_page(struct ar
 	return 0;
 }
 
+#if FIREWIRE_OHCI_DEBUG_AT_AR
+static void debug_ar_at_event(char dir, int speed, u32 *header, int evt)
+{
+	static const char *evts[] = {
+		[0x00] = "evt_no_status",	[0x01] = "-reserved-",
+		[0x02] = "evt_long_packet",	[0x03] = "evt_missing_ack",
+		[0x04] = "evt_underrun",	[0x05] = "evt_overrun",
+		[0x06] = "evt_descriptor_read",	[0x07] = "evt_data_read",
+		[0x08] = "evt_data_write",	[0x09] = "evt_bus_reset",
+		[0x0a] = "evt_timeout",		[0x0b] = "evt_tcode_err",
+		[0x0c] = "-reserved-",		[0x0d] = "-reserved-",
+		[0x0e] = "evt_unknown",		[0x0f] = "evt_flushed",
+		[0x10] = "-reserved-",		[0x11] = "ack_complete",
+		[0x12] = "ack_pending ",	[0x13] = "-reserved-",
+		[0x14] = "ack_busy_X",		[0x15] = "ack_busy_A",
+		[0x16] = "ack_busy_B",		[0x17] = "-reserved-",
+		[0x18] = "-reserved-",		[0x19] = "-reserved-",
+		[0x1a] = "-reserved-",		[0x1b] = "ack_tardy",
+		[0x1c] = "-reserved-",		[0x1d] = "ack_data_error",
+		[0x1e] = "ack_type_error",	[0x1f] = "-reserved-",
+	};
+	static const char *tcodes[] = {
+		[0x0] = "quadlet write request", [0x1] = "block write request",
+		[0x2] = "write response",	 [0x3] = "-reserved-",
+		[0x4] = "quadlet read request",	 [0x5] = "block read request",
+		[0x6] = "quadlet read response", [0x7] = "block read response",
+		[0x8] = "cycle start",		 [0x9] = "lock request",
+		[0xa] = "async stream packet",	 [0xb] = "lock response",
+		[0xc] = "-reserved-",		 [0xd] = "-reserved-",
+		[0xe] = "link internal",	 [0xf] = "reserved",
+	};
+	static const char *phys[] = {
+		[0x0] = "phy config packet",	 [0x1] = "link-on packet",
+		[0x2] = "self-id packet",	 [0x3] = "-reserved-",
+	};
+	int tcode = header[0] >> 4 & 0xf;
+
+	evt &= 0x1f;
+	if (header[0] == ~header[1])
+		printk(KERN_DEBUG "A%c evt %02x: %s, %s, %08x\n",
+		       dir, evt, evts[evt], phys[header[0] >> 30 & 0x3],
+		       header[0]);
+	else if (tcode == 0xe)
+		printk(KERN_DEBUG "A%c evt %02x: %s, %s\n",
+		       dir, evt, evts[evt], tcodes[tcode]);
+	else if (tcode == 0x0 || tcode == 0x1 ||
+		 tcode == 0x4 || tcode == 0x5 || tcode == 0x9)
+		printk(KERN_DEBUG "A%c evt %02x: tcode %x spd %x tl %02x "
+		       "src %04x dest %04x: "
+		       "%s, %s, %04x%08x\n",
+		       dir, evt, tcode, speed, header[0] >> 10 & 0x3f,
+		       header[1] >> 16, header[0] >> 16,
+		       evts[evt], tcodes[tcode], header[1] & 0xffff, header[2]);
+	else
+		printk(KERN_DEBUG "A%c evt %02x: tcode %x spd %x tl %02x "
+		       "src %04x dest %04x: "
+		       "%s, %s\n",
+		       dir, evt, tcode, speed, header[0] >> 10 & 0x3f,
+		       header[1] >> 16, header[0] >> 16,
+		       evts[evt], tcodes[tcode]);
+}
+#else
+#define debug_ar_at_event(dir, speed, header, evt)
+#endif /* FIREWIRE_OHCI_DEBUG_AT_AR */
+
 #if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
 #define cond_le32_to_cpu(v) \
 	(ohci->old_uninorth ? (__force __u32)(v) : le32_to_cpu(v))
@@ -376,6 +444,8 @@ static __le32 *handle_ar_packet(struct a
 	p.timestamp  = status & 0xffff;
 	p.generation = ohci->request_generation;
 
+	debug_ar_at_event('R', p.speed, p.header, status >> 16 & 0x1f);
+
 	/*
 	 * The OHCI bus reset handler synthesizes a phy packet with
 	 * the new generation number when a bus reset happens (see
@@ -824,6 +894,8 @@ static int handle_at_packet(struct conte
 	evt = le16_to_cpu(last->transfer_status) & 0x1f;
 	packet->timestamp = le16_to_cpu(last->res_count);
 
+	debug_ar_at_event('T', packet->speed, packet->header, evt);
+
 	switch (evt) {
 	case OHCI1394_evt_timeout:
 		/* Async response transmit timed out. */
@@ -1005,6 +1077,45 @@ at_context_transmit(struct context *ctx,
 
 }
 
+#if FIREWIRE_OHCI_DEBUG_SELFIDS
+static char _p(u32 *s, int shift)
+{
+	static const char port_connected[] = { '.', '-', 'p', 'c', };
+
+	return port_connected[*s >> shift & 3];
+}
+
+static void debug_selfid_complete_event(int self_id_count, u32 *s)
+{
+	static const char *speed[] = {
+		[0] = "S100", [1] = "S200", [2] = "S400",    [3] = "beta",
+	};
+	static const char *power[] = {
+		[0] = "+0W",  [1] = "+15W", [2] = "+30W",    [3] = "+45W",
+		[4] = "-3W",  [5] = " ?W",  [6] = "-3..-6W", [7] = "-3..-10W",
+	};
+
+	for (; self_id_count--; ++s)
+		if ((*s & 1 << 23) == 0)
+			printk(KERN_DEBUG "selfID 0: %08x, phy %d [%c%c%c] "
+			       "%s gc=%d %s %s%s%s%s\n",
+			       *s, *s >> 24 & 63, _p(s, 6), _p(s, 4), _p(s, 2),
+			       speed[*s >> 14 & 3], *s >> 16 & 63,
+			       power[*s >> 8 & 7], *s >> 22 & 1 ? "L" : "",
+			       *s >> 11 & 1 ? "c" : "", *s & 2 ? "i" : "",
+			       *s & 1 ? "..." : "");
+		else
+			printk(KERN_DEBUG "selfID n: %08x, phy %d "
+			       "[%c%c%c%c%c%c%c%c]%s\n",
+			       *s, *s >> 24 & 63,
+			       _p(s, 16), _p(s, 14), _p(s, 12), _p(s, 10),
+			       _p(s,  8), _p(s,  6), _p(s,  4), _p(s,  2),
+			       *s & 1 ? "..." : "");
+}
+#else
+#define debug_selfid_complete_event(self_id_count, s)
+#endif /* FIREWIRE_OHCI_DEBUG_SELFIDS */
+
 static void bus_reset_tasklet(unsigned long data)
 {
 	struct fw_ohci *ohci = (struct fw_ohci *)data;
@@ -1115,6 +1226,8 @@ static void bus_reset_tasklet(unsigned l
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  free_rom, free_rom_bus);
 
+	debug_selfid_complete_event(self_id_count, ohci->self_id_buffer);
+
 	fw_core_handle_bus_reset(&ohci->card, ohci->node_id, generation,
 				 self_id_count, ohci->self_id_buffer);
 }

-- 
Stefan Richter
-=====-==--- --== -=--=
http://arcgraph.de/sr/

