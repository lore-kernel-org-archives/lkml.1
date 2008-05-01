Return-Path: <linux-kernel-owner+w=401wt.eu-S1765246AbYEAWhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765246AbYEAWhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYEAWhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:37:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57498 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYEAWhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:37:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 2 May 2008 00:36:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: blacklist dualbuffer for TSB43AB22A on
 ASUS boards
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f5c7b5be9496fcdd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to https://bugzilla.redhat.com/show_bug.cgi?id=435550 the
TI TSB43AB22A on an ASUSTeK M2NPV-VM motherboard does not work in
dual-buffer mode with dvgrab, but does so in packet-per-buffer mode.

Other TSB43AB22 or TSB43AB22A cards do not exhibit this problem.  The
least-cost "fix" for now is to force TSB43AB22A on ASUS boards into
packet-per-buffer mode in isochronous reception.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

(subject to retesting by the reporter)

 drivers/firewire/fw-ohci.c |   20 +++++++++++++-------
 include/linux/pci_ids.h    |    1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -171,7 +171,6 @@ struct iso_context {
 struct fw_ohci {
 	struct fw_card card;
 
-	u32 version;
 	__iomem char *registers;
 	dma_addr_t self_id_bus;
 	__le32 *self_id_cpu;
@@ -180,6 +179,8 @@ struct fw_ohci {
 	int generation;
 	int request_generation;	/* for timestamping incoming requests */
 	u32 bus_seconds;
+
+	bool use_dualbuffer;
 	bool old_uninorth;
 	bool bus_reset_packet_quirk;
 
@@ -1883,7 +1884,7 @@ ohci_allocate_iso_context(struct fw_card
 	} else {
 		mask = &ohci->ir_context_mask;
 		list = ohci->ir_context_list;
-		if (ohci->version >= OHCI_VERSION_1_1)
+		if (ohci->use_dualbuffer)
 			callback = handle_ir_dualbuffer_packet;
 		else
 			callback = handle_ir_packet_per_buffer;
@@ -1947,7 +1948,7 @@ static int ohci_start_iso(struct fw_iso_
 	} else {
 		index = ctx - ohci->ir_context_list;
 		control = IR_CONTEXT_ISOCH_HEADER;
-		if (ohci->version >= OHCI_VERSION_1_1)
+		if (ohci->use_dualbuffer)
 			control |= IR_CONTEXT_DUAL_BUFFER_MODE;
 		match = (tags << 28) | (sync << 8) | ctx->base.channel;
 		if (cycle >= 0) {
@@ -2277,7 +2278,7 @@ ohci_queue_iso(struct fw_iso_context *ba
 	spin_lock_irqsave(&ctx->context.ohci->lock, flags);
 	if (base->type == FW_ISO_CONTEXT_TRANSMIT)
 		retval = ohci_queue_iso_transmit(base, packet, buffer, payload);
-	else if (ctx->context.ohci->version >= OHCI_VERSION_1_1)
+	else if (ctx->context.ohci->use_dualbuffer)
 		retval = ohci_queue_iso_receive_dualbuffer(base, packet,
 							 buffer, payload);
 	else
@@ -2340,7 +2341,7 @@ static int __devinit
 pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 {
 	struct fw_ohci *ohci;
-	u32 bus_options, max_receive, link_speed;
+	u32 bus_options, max_receive, link_speed, version;
 	u64 guid;
 	int err;
 	size_t size;
@@ -2436,13 +2437,18 @@ pci_probe(struct pci_dev *dev, const str
 	guid = ((u64) reg_read(ohci, OHCI1394_GUIDHi) << 32) |
 		reg_read(ohci, OHCI1394_GUIDLo);
 
+	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
+	ohci->use_dualbuffer = version >= OHCI_VERSION_1_1 &&
+			!(dev->vendor == PCI_VENDOR_ID_TI &&
+			  dev->device == PCI_DEVICE_ID_TI_TSB43AB22 &&
+			  dev->subsystem_vendor == PCI_VENDOR_ID_ASUSTEK);
+
 	err = fw_card_add(&ohci->card, max_receive, link_speed, guid);
 	if (err < 0)
 		goto fail_self_id;
 
-	ohci->version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
 	fw_notify("Added fw-ohci device %s, OHCI version %x.%x\n",
-		  dev->dev.bus_id, ohci->version >> 16, ohci->version & 0xff);
+		  dev->dev.bus_id, version >> 16, version & 0xff);
 	return 0;
 
  fail_self_id:
Index: linux/include/linux/pci_ids.h
===================================================================
--- linux.orig/include/linux/pci_ids.h
+++ linux/include/linux/pci_ids.h
@@ -747,6 +747,7 @@
 #define PCI_VENDOR_ID_TI		0x104c
 #define PCI_DEVICE_ID_TI_TVP4020	0x3d07
 #define PCI_DEVICE_ID_TI_4450		0x8011
+#define PCI_DEVICE_ID_TI_TSB43AB22	0x8023
 #define PCI_DEVICE_ID_TI_XX21_XX11	0x8031
 #define PCI_DEVICE_ID_TI_XX21_XX11_FM	0x8033
 #define PCI_DEVICE_ID_TI_XX21_XX11_SD	0x8034

-- 
Stefan Richter
-=====-==--- -=-= ---=-
http://arcgraph.de/sr/

