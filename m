Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbYCJWam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbYCJWam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbYCJWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:30:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57408 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbYCJWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:30:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 10 Mar 2008 23:28:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: debug AT, AR, and selfID-complete events
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200803100047.05387.jwilson@redhat.com>
Message-ID: <tkrat.ebca3f78fa768606@s5r6.in-berlin.de>
References: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de>
 <200803100047.05387.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Mar, Jarod Wilson wrote:
> My vote would be to include this sort of thing with a run-time option to 
> enable the extra spew, since its a perfectly accepted standard for other 
> drivers. It ought to be extremely useful in determining whats going wrong 
> with end-user setups, particularly in cases where we can't reproduce the 
> problem (typically for lack of having the specific hardware in-house).


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: debug AT, AR, and selfID-complete events

This adds debug printks for asynchronous transmission and reception and
for self ID reception.  They can be enabled at module load time, and at
runtime via /sys/module/firewire_ohci/parameters/debug.

This code inflates firewire-ohci.ko by 6 kB = 24% on x86-64 and
by 4 kB = 20% on i686.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  Converted into runtime option, shortened some strings, added
payload dump of quadlet transactions and of selfID generation.

 drivers/firewire/fw-ohci.c |  139 +++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 
@@ -40,6 +41,16 @@
 #include "fw-ohci.h"
 #include "fw-transaction.h"
 
+#define OHCI_PARAM_DEBUG_SELFIDS     1
+#define OHCI_PARAM_DEBUG_AT_AR       2
+
+static int param_debug;
+module_param_named(debug, param_debug, int, 0644);
+MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
+	", self-IDs = "		__stringify(OHCI_PARAM_DEBUG_SELFIDS)
+	", AT and AR events = "	__stringify(OHCI_PARAM_DEBUG_AT_AR)
+	", or a combination)");
+
 #define DESCRIPTOR_OUTPUT_MORE		0
 #define DESCRIPTOR_OUTPUT_LAST		(1 << 12)
 #define DESCRIPTOR_INPUT_MORE		(2 << 12)
@@ -316,6 +327,88 @@ static int ar_context_add_page(struct ar
 	return 0;
 }
 
+static const char *evts[] = {
+	[0x00] = "evt_no_status",	[0x01] = "-reserved-",
+	[0x02] = "evt_long_packet",	[0x03] = "evt_missing_ack",
+	[0x04] = "evt_underrun",	[0x05] = "evt_overrun",
+	[0x06] = "evt_descriptor_read",	[0x07] = "evt_data_read",
+	[0x08] = "evt_data_write",	[0x09] = "evt_bus_reset",
+	[0x0a] = "evt_timeout",		[0x0b] = "evt_tcode_err",
+	[0x0c] = "-reserved-",		[0x0d] = "-reserved-",
+	[0x0e] = "evt_unknown",		[0x0f] = "evt_flushed",
+	[0x10] = "-reserved-",		[0x11] = "ack_complete",
+	[0x12] = "ack_pending ",	[0x13] = "-reserved-",
+	[0x14] = "ack_busy_X",		[0x15] = "ack_busy_A",
+	[0x16] = "ack_busy_B",		[0x17] = "-reserved-",
+	[0x18] = "-reserved-",		[0x19] = "-reserved-",
+	[0x1a] = "-reserved-",		[0x1b] = "ack_tardy",
+	[0x1c] = "-reserved-",		[0x1d] = "ack_data_error",
+	[0x1e] = "ack_type_error",	[0x1f] = "-reserved-",
+};
+static const char *tcodes[] = {
+	[0x0] = "QW req",		[0x1] = "BW req",
+	[0x2] = "W resp",		[0x3] = "-reserved-",
+	[0x4] = "QR req",		[0x5] = "BR req",
+	[0x6] = "QR resp",		[0x7] = "BR resp",
+	[0x8] = "cycle start",		[0x9] = "Lk req",
+	[0xa] = "async stream packet",	[0xb] = "Lk resp",
+	[0xc] = "-reserved-",		[0xd] = "-reserved-",
+	[0xe] = "link internal",	[0xf] = "-reserved-",
+};
+static const char *phys[] = {
+	[0x0] = "phy config packet",	[0x1] = "link-on packet",
+	[0x2] = "self-id packet",	[0x3] = "-reserved-",
+};
+
+static void debug_ar_at_event(char dir, int speed, u32 *header, int evt)
+{
+	int tcode = header[0] >> 4 & 0xf;
+	char specific[12];
+
+	evt &= 0x1f;
+	if (header[0] == ~header[1]) {
+		printk(KERN_DEBUG "A%c %s, %s, %08x\n",
+		       dir, evts[evt], phys[header[0] >> 30 & 0x3],
+		       header[0]);
+		return;
+	}
+
+	switch (tcode) {
+	case 0x0: case 0x6: case 0x8:
+		snprintf(specific, sizeof(specific), " = %08x",
+			 be32_to_cpu((__force __be32)header[3]));
+		break;
+	case 0x1: case 0x5: case 0x7: case 0x9: case 0xb:
+		snprintf(specific, sizeof(specific), " %x,%x",
+			 header[3] >> 16, header[3] & 0xffff);
+		break;
+	default:
+		specific[0] = '\0';
+	}
+
+	switch (tcode) {
+	case 0xe: case 0xa:
+		printk(KERN_DEBUG "A%c %s, %s\n",
+		       dir, evts[evt], tcodes[tcode]);
+		break;
+	case 0x0: case 0x1: case 0x4: case 0x5: case 0x9:
+		printk(KERN_DEBUG "A%c spd %x tl %02x, "
+		       "%04x -> %04x, %s, "
+		       "%s, %04x%08x%s\n",
+		       dir, speed, header[0] >> 10 & 0x3f,
+		       header[1] >> 16, header[0] >> 16, evts[evt],
+		       tcodes[tcode], header[1] & 0xffff, header[2], specific);
+		break;
+	default:
+		printk(KERN_DEBUG "A%c spd %x tl %02x, "
+		       "%04x -> %04x, %s, "
+		       "%s%s\n",
+		       dir, speed, header[0] >> 10 & 0x3f,
+		       header[1] >> 16, header[0] >> 16, evts[evt],
+		       tcodes[tcode], specific);
+	}
+}
+
 #if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
 #define cond_le32_to_cpu(v) \
 	(ohci->old_uninorth ? (__force __u32)(v) : le32_to_cpu(v))
@@ -376,6 +469,9 @@ static __le32 *handle_ar_packet(struct a
 	p.timestamp  = status & 0xffff;
 	p.generation = ohci->request_generation;
 
+	if (unlikely(param_debug & OHCI_PARAM_DEBUG_AT_AR))
+		debug_ar_at_event('R', p.speed, p.header, status >> 16 & 0x1f);
+
 	/*
 	 * The OHCI bus reset handler synthesizes a phy packet with
 	 * the new generation number when a bus reset happens (see
@@ -824,6 +920,9 @@ static int handle_at_packet(struct conte
 	evt = le16_to_cpu(last->transfer_status) & 0x1f;
 	packet->timestamp = le16_to_cpu(last->res_count);
 
+	if (unlikely(param_debug & OHCI_PARAM_DEBUG_AT_AR))
+		debug_ar_at_event('T', packet->speed, packet->header, evt);
+
 	switch (evt) {
 	case OHCI1394_evt_timeout:
 		/* Async response transmit timed out. */
@@ -1005,6 +1104,43 @@ at_context_transmit(struct context *ctx,
 
 }
 
+static const char *speed[] = {
+	[0] = "S100", [1] = "S200", [2] = "S400",    [3] = "beta",
+};
+static const char *power[] = {
+	[0] = "+0W",  [1] = "+15W", [2] = "+30W",    [3] = "+45W",
+	[4] = "-3W",  [5] = " ?W",  [6] = "-3..-6W", [7] = "-3..-10W",
+};
+static const char port[] = { '.', '-', 'p', 'c', };
+
+static char _p(u32 *s, int shift)
+{
+	return port[*s >> shift & 3];
+}
+
+static void debug_selfids(int generation, int self_id_count, u32 *s)
+{
+	printk(KERN_DEBUG KBUILD_MODNAME ": %d selfIDs, generation %d\n",
+	       self_id_count, generation);
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
+
 static void bus_reset_tasklet(unsigned long data)
 {
 	struct fw_ohci *ohci = (struct fw_ohci *)data;
@@ -1115,6 +1251,9 @@ static void bus_reset_tasklet(unsigned l
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  free_rom, free_rom_bus);
 
+	if (unlikely(param_debug & OHCI_PARAM_DEBUG_SELFIDS))
+		debug_selfids(generation, self_id_count, ohci->self_id_buffer);
+
 	fw_core_handle_bus_reset(&ohci->card, ohci->node_id, generation,
 				 self_id_count, ohci->self_id_buffer);
 }


-- 
Stefan Richter
-=====-==--- --== -=-=-
http://arcgraph.de/sr/


