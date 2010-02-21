Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0BUQ5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:57:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58345 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0BUQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:57:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:57:05 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/8] firewire: ohci: remove unused dualbuffer IR code
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.cf210ba643f7dc5e@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was no longer used since 2.6.33, "firewire: ohci: always use
packet-per-buffer mode for isochronous reception" commit 090699c0.  If
anybody needs this code in the future for special purposes, it can be
brought back in.  But it must not be re-enabled by default; drivers
(kernelspace or userspace drivers) should only get this mode if they
explicitly request it.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |  184 ----------------------------------------
 include/linux/pci_ids.h |    1 -
 2 files changed, 1 insertion(+), 184 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -72,20 +72,6 @@ struct descriptor {
 	__le16 transfer_status;
 } __attribute__((aligned(16)));
 
-struct db_descriptor {
-	__le16 first_size;
-	__le16 control;
-	__le16 second_req_count;
-	__le16 first_req_count;
-	__le32 branch_address;
-	__le16 second_res_count;
-	__le16 first_res_count;
-	__le32 reserved0;
-	__le32 first_buffer;
-	__le32 second_buffer;
-	__le32 reserved1;
-} __attribute__((aligned(16)));
-
 #define CONTROL_SET(regs)	(regs)
 #define CONTROL_CLEAR(regs)	((regs) + 4)
 #define COMMAND_PTR(regs)	((regs) + 12)
@@ -187,7 +173,6 @@ struct fw_ohci {
 	int generation;
 	int request_generation;	/* for timestamping incoming requests */
 
-	bool use_dualbuffer;
 	bool old_uninorth;
 	bool bus_reset_packet_quirk;
 	bool iso_cycle_timer_quirk;
@@ -1863,52 +1848,6 @@ static void copy_iso_headers(struct iso_
 	ctx->header_length += ctx->base.header_size;
 }
 
-static int handle_ir_dualbuffer_packet(struct context *context,
-				       struct descriptor *d,
-				       struct descriptor *last)
-{
-	struct iso_context *ctx =
-		container_of(context, struct iso_context, context);
-	struct db_descriptor *db = (struct db_descriptor *) d;
-	__le32 *ir_header;
-	size_t header_length;
-	void *p, *end;
-
-	if (db->first_res_count != 0 && db->second_res_count != 0) {
-		if (ctx->excess_bytes <= le16_to_cpu(db->second_req_count)) {
-			/* This descriptor isn't done yet, stop iteration. */
-			return 0;
-		}
-		ctx->excess_bytes -= le16_to_cpu(db->second_req_count);
-	}
-
-	header_length = le16_to_cpu(db->first_req_count) -
-		le16_to_cpu(db->first_res_count);
-
-	p = db + 1;
-	end = p + header_length;
-	while (p < end) {
-		copy_iso_headers(ctx, p);
-		ctx->excess_bytes +=
-			(le32_to_cpu(*(__le32 *)(p + 4)) >> 16) & 0xffff;
-		p += max(ctx->base.header_size, (size_t)8);
-	}
-
-	ctx->excess_bytes -= le16_to_cpu(db->second_req_count) -
-		le16_to_cpu(db->second_res_count);
-
-	if (le16_to_cpu(db->control) & DESCRIPTOR_IRQ_ALWAYS) {
-		ir_header = (__le32 *) (db + 1);
-		ctx->base.callback(&ctx->base,
-				   le32_to_cpu(ir_header[0]) & 0xffff,
-				   ctx->header_length, ctx->header,
-				   ctx->base.callback_data);
-		ctx->header_length = 0;
-	}
-
-	return 1;
-}
-
 static int handle_ir_packet_per_buffer(struct context *context,
 				       struct descriptor *d,
 				       struct descriptor *last)
@@ -1995,10 +1934,7 @@ static struct fw_iso_context *ohci_alloc
 		channels = &ohci->ir_context_channels;
 		mask = &ohci->ir_context_mask;
 		list = ohci->ir_context_list;
-		if (ohci->use_dualbuffer)
-			callback = handle_ir_dualbuffer_packet;
-		else
-			callback = handle_ir_packet_per_buffer;
+		callback = handle_ir_packet_per_buffer;
 	}
 
 	spin_lock_irqsave(&ohci->lock, flags);
@@ -2061,8 +1997,6 @@ static int ohci_start_iso(struct fw_iso_
 	} else {
 		index = ctx - ohci->ir_context_list;
 		control = IR_CONTEXT_ISOCH_HEADER;
-		if (ohci->use_dualbuffer)
-			control |= IR_CONTEXT_DUAL_BUFFER_MODE;
 		match = (tags << 28) | (sync << 8) | ctx->base.channel;
 		if (cycle >= 0) {
 			match |= (cycle & 0x07fff) << 12;
@@ -2223,92 +2157,6 @@ static int ohci_queue_iso_transmit(struc
 	return 0;
 }
 
-static int ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
-					     struct fw_iso_packet *packet,
-					     struct fw_iso_buffer *buffer,
-					     unsigned long payload)
-{
-	struct iso_context *ctx = container_of(base, struct iso_context, base);
-	struct db_descriptor *db = NULL;
-	struct descriptor *d;
-	struct fw_iso_packet *p;
-	dma_addr_t d_bus, page_bus;
-	u32 z, header_z, length, rest;
-	int page, offset, packet_count, header_size;
-
-	/*
-	 * FIXME: Cycle lost behavior should be configurable: lose
-	 * packet, retransmit or terminate..
-	 */
-
-	p = packet;
-	z = 2;
-
-	/*
-	 * The OHCI controller puts the isochronous header and trailer in the
-	 * buffer, so we need at least 8 bytes.
-	 */
-	packet_count = p->header_length / ctx->base.header_size;
-	header_size = packet_count * max(ctx->base.header_size, (size_t)8);
-
-	/* Get header size in number of descriptors. */
-	header_z = DIV_ROUND_UP(header_size, sizeof(*d));
-	page     = payload >> PAGE_SHIFT;
-	offset   = payload & ~PAGE_MASK;
-	rest     = p->payload_length;
-	/*
-	 * The controllers I've tested have not worked correctly when
-	 * second_req_count is zero.  Rather than do something we know won't
-	 * work, return an error
-	 */
-	if (rest == 0)
-		return -EINVAL;
-
-	while (rest > 0) {
-		d = context_get_descriptors(&ctx->context,
-					    z + header_z, &d_bus);
-		if (d == NULL)
-			return -ENOMEM;
-
-		db = (struct db_descriptor *) d;
-		db->control = cpu_to_le16(DESCRIPTOR_STATUS |
-					  DESCRIPTOR_BRANCH_ALWAYS);
-		db->first_size =
-		    cpu_to_le16(max(ctx->base.header_size, (size_t)8));
-		if (p->skip && rest == p->payload_length) {
-			db->control |= cpu_to_le16(DESCRIPTOR_WAIT);
-			db->first_req_count = db->first_size;
-		} else {
-			db->first_req_count = cpu_to_le16(header_size);
-		}
-		db->first_res_count = db->first_req_count;
-		db->first_buffer = cpu_to_le32(d_bus + sizeof(*db));
-
-		if (p->skip && rest == p->payload_length)
-			length = 4;
-		else if (offset + rest < PAGE_SIZE)
-			length = rest;
-		else
-			length = PAGE_SIZE - offset;
-
-		db->second_req_count = cpu_to_le16(length);
-		db->second_res_count = db->second_req_count;
-		page_bus = page_private(buffer->pages[page]);
-		db->second_buffer = cpu_to_le32(page_bus + offset);
-
-		if (p->interrupt && length == rest)
-			db->control |= cpu_to_le16(DESCRIPTOR_IRQ_ALWAYS);
-
-		context_append(&ctx->context, d, z, header_z);
-		offset = (offset + length) & ~PAGE_MASK;
-		rest -= length;
-		if (offset == 0)
-			page++;
-	}
-
-	return 0;
-}
-
 static int ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
 					struct fw_iso_packet *packet,
 					struct fw_iso_buffer *buffer,
@@ -2399,9 +2247,6 @@ static int ohci_queue_iso(struct fw_iso_
 	spin_lock_irqsave(&ctx->context.ohci->lock, flags);
 	if (base->type == FW_ISO_CONTEXT_TRANSMIT)
 		ret = ohci_queue_iso_transmit(base, packet, buffer, payload);
-	else if (ctx->context.ohci->use_dualbuffer)
-		ret = ohci_queue_iso_receive_dualbuffer(base, packet,
-							buffer, payload);
 	else
 		ret = ohci_queue_iso_receive_packet_per_buffer(base, packet,
 							buffer, payload);
@@ -2456,10 +2301,6 @@ static void ohci_pmac_off(struct pci_dev
 #define ohci_pmac_off(dev)
 #endif /* CONFIG_PPC_PMAC */
 
-#define PCI_VENDOR_ID_AGERE		PCI_VENDOR_ID_ATT
-#define PCI_DEVICE_ID_AGERE_FW643	0x5901
-#define PCI_DEVICE_ID_TI_TSB43AB23	0x8024
-
 static int __devinit pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *ent)
 {
@@ -2508,29 +2349,6 @@ static int __devinit pci_probe(struct pc
 	}
 
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
-#if 0
-	/* FIXME: make it a context option or remove dual-buffer mode */
-	ohci->use_dualbuffer = version >= OHCI_VERSION_1_1;
-#endif
-
-	/* dual-buffer mode is broken if more than one IR context is active */
-	if (dev->vendor == PCI_VENDOR_ID_AGERE &&
-	    dev->device == PCI_DEVICE_ID_AGERE_FW643)
-		ohci->use_dualbuffer = false;
-
-	/* dual-buffer mode is broken */
-	if (dev->vendor == PCI_VENDOR_ID_RICOH &&
-	    dev->device == PCI_DEVICE_ID_RICOH_R5C832)
-		ohci->use_dualbuffer = false;
-
-/* x86-32 currently doesn't use highmem for dma_alloc_coherent */
-#if !defined(CONFIG_X86_32)
-	/* dual-buffer mode is broken with descriptor addresses above 2G */
-	if (dev->vendor == PCI_VENDOR_ID_TI &&
-	    (dev->device == PCI_DEVICE_ID_TI_TSB43AB22 ||
-	     dev->device == PCI_DEVICE_ID_TI_TSB43AB23))
-		ohci->use_dualbuffer = false;
-#endif
 
 #if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
 	ohci->old_uninorth = dev->vendor == PCI_VENDOR_ID_APPLE &&
Index: b/include/linux/pci_ids.h
===================================================================
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -770,7 +770,6 @@
 #define PCI_VENDOR_ID_TI		0x104c
 #define PCI_DEVICE_ID_TI_TVP4020	0x3d07
 #define PCI_DEVICE_ID_TI_4450		0x8011
-#define PCI_DEVICE_ID_TI_TSB43AB22	0x8023
 #define PCI_DEVICE_ID_TI_XX21_XX11	0x8031
 #define PCI_DEVICE_ID_TI_XX21_XX11_FM	0x8033
 #define PCI_DEVICE_ID_TI_XX21_XX11_SD	0x8034

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

