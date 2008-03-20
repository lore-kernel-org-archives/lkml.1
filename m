Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbYCTVFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbYCTVFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbYCTVFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:05:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41295 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYCTVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:05:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 20 Mar 2008 22:04:36 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: debug interrupt events
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
Message-ID: <tkrat.1ed152c64838f360@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds debug printks for asynchronous transmission and reception and
for self ID reception.  They can be enabled at module load time, and at
runtime via /sys/module/firewire_ohci/parameters/debug.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

Also added:  Logging of interrupt event codes and of cancelled AT
packets.

The code now depends on a Kconfig variable.  This makes it easier to
build firewire-ohci without the feature or to make it an option in the
future.  The variable is currently hidden and always on.

This feature inflates firewire-ohci.ko by 7 kB = 27% on x86-64 and by
4 kB = 23% on i686.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig   |    5 +
 drivers/firewire/fw-ohci.c |  182 +++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+)

Index: linux/drivers/firewire/Kconfig
===================================================================
--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -54,6 +54,11 @@ config FIREWIRE_OHCI
 	  directive, use "install modulename /bin/true" for the modules to be
 	  blacklisted.
 
+config FIREWIRE_OHCI_DEBUG
+	bool
+	depends on FIREWIRE_OHCI
+	default y
+
 config FIREWIRE_SBP2
 	tristate "Support for storage devices (SBP-2 protocol driver)"
 	depends on FIREWIRE && SCSI
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
 
@@ -237,6 +238,179 @@ static inline struct fw_ohci *fw_ohci(st
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#ifdef CONFIG_FIREWIRE_OHCI_DEBUG
+
+#define OHCI_PARAM_DEBUG_IRQS		1
+#define OHCI_PARAM_DEBUG_SELFIDS	2
+#define OHCI_PARAM_DEBUG_AT_AR		4
+
+static int param_debug;
+module_param_named(debug, param_debug, int, 0644);
+MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
+	", IRQs = "		__stringify(OHCI_PARAM_DEBUG_IRQS)
+	", self-IDs = "		__stringify(OHCI_PARAM_DEBUG_SELFIDS)
+	", AT/AR events = "	__stringify(OHCI_PARAM_DEBUG_AT_AR)
+	", or a combination, or all = -1)");
+
+static void log_irqs(u32 evt)
+{
+	if (likely(!(param_debug & OHCI_PARAM_DEBUG_IRQS)))
+		return;
+
+	printk(KERN_DEBUG KBUILD_MODNAME ": IRQ %08x%s%s%s%s%s%s%s%s%s%s%s\n",
+	       evt,
+	       evt & OHCI1394_selfIDComplete	? " selfID"		: "",
+	       evt & OHCI1394_RQPkt		? " AR_req"		: "",
+	       evt & OHCI1394_RSPkt		? " AR_resp"		: "",
+	       evt & OHCI1394_reqTxComplete	? " AT_req"		: "",
+	       evt & OHCI1394_respTxComplete	? " AT_resp"		: "",
+	       evt & OHCI1394_isochRx		? " IR"			: "",
+	       evt & OHCI1394_isochTx		? " IT"			: "",
+	       evt & OHCI1394_postedWriteErr	? " postedWriteErr"	: "",
+	       evt & OHCI1394_cycleTooLong	? " cycleTooLong"	: "",
+	       evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
+	       evt & ~(OHCI1394_selfIDComplete | OHCI1394_RQPkt |
+		       OHCI1394_RSPkt | OHCI1394_reqTxComplete |
+		       OHCI1394_respTxComplete | OHCI1394_isochRx |
+		       OHCI1394_isochTx | OHCI1394_postedWriteErr |
+		       OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds)
+						? " ?"			: "");
+}
+
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
+static void log_selfids(int generation, int self_id_count, u32 *s)
+{
+	if (likely(!(param_debug & OHCI_PARAM_DEBUG_SELFIDS)))
+		return;
+
+	printk(KERN_DEBUG KBUILD_MODNAME ": %d selfIDs, generation %d\n",
+	       self_id_count, generation);
+
+	for (; self_id_count--; ++s)
+		if ((*s & 1 << 23) == 0)
+			printk(KERN_DEBUG "selfID 0: %08x, phy %d [%c%c%c] "
+			       "%s gc=%d %s %s%s%s\n",
+			       *s, *s >> 24 & 63, _p(s, 6), _p(s, 4), _p(s, 2),
+			       speed[*s >> 14 & 3], *s >> 16 & 63,
+			       power[*s >> 8 & 7], *s >> 22 & 1 ? "L" : "",
+			       *s >> 11 & 1 ? "c" : "", *s & 2 ? "i" : "");
+		else
+			printk(KERN_DEBUG "selfID n: %08x, phy %d "
+			       "[%c%c%c%c%c%c%c%c]\n",
+			       *s, *s >> 24 & 63,
+			       _p(s, 16), _p(s, 14), _p(s, 12), _p(s, 10),
+			       _p(s,  8), _p(s,  6), _p(s,  4), _p(s,  2));
+}
+
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
+	[0x20] = "pending/cancelled",
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
+static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
+{
+	int tcode = header[0] >> 4 & 0xf;
+	char specific[12];
+
+	if (likely(!(param_debug & OHCI_PARAM_DEBUG_AT_AR)))
+		return;
+
+	if (unlikely(evt >= ARRAY_SIZE(evts)))
+			evt = 0x1f;
+
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
+#else
+
+#define log_irqs(evt)
+#define log_selfids(generation, self_id_count, sid)
+#define log_ar_at_event(dir, speed, header, evt)
+
+#endif /* CONFIG_FIREWIRE_OHCI_DEBUG */
+
 static inline void reg_write(const struct fw_ohci *ohci, int offset, u32 data)
 {
 	writel(data, ohci->registers + offset);
@@ -368,6 +542,8 @@ static __le32 *handle_ar_packet(struct a
 	p.timestamp  = status & 0xffff;
 	p.generation = ohci->request_generation;
 
+	log_ar_at_event('R', p.speed, p.header, status >> 16 & 0x1f);
+
 	/*
 	 * The OHCI bus reset handler synthesizes a phy packet with
 	 * the new generation number when a bus reset happens (see
@@ -816,6 +992,8 @@ static int handle_at_packet(struct conte
 	evt = le16_to_cpu(last->transfer_status) & 0x1f;
 	packet->timestamp = le16_to_cpu(last->res_count);
 
+	log_ar_at_event('T', packet->speed, packet->header, evt);
+
 	switch (evt) {
 	case OHCI1394_evt_timeout:
 		/* Async response transmit timed out. */
@@ -1117,6 +1295,8 @@ static void bus_reset_tasklet(unsigned l
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  free_rom, free_rom_bus);
 
+	log_selfids(generation, self_id_count, ohci->self_id_buffer);
+
 	fw_core_handle_bus_reset(&ohci->card, ohci->node_id, generation,
 				 self_id_count, ohci->self_id_buffer);
 }
@@ -1133,6 +1313,7 @@ static irqreturn_t irq_handler(int irq, 
 		return IRQ_NONE;
 
 	reg_write(ohci, OHCI1394_IntEventClear, event);
+	log_irqs(event);
 
 	if (event & OHCI1394_selfIDComplete)
 		tasklet_schedule(&ohci->bus_reset_tasklet);
@@ -1435,6 +1616,7 @@ static int ohci_cancel_packet(struct fw_
 	if (packet->ack != 0)
 		goto out;
 
+	log_ar_at_event('T', packet->speed, packet->header, 0x20);
 	driver_data->packet = NULL;
 	packet->ack = RCODE_CANCELLED;
 	packet->callback(packet, &ohci->card, packet->ack);

-- 
Stefan Richter
-=====-==--- --== =-=--
http://arcgraph.de/sr/

