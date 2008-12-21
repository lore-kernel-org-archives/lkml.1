Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbYLUPku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbYLUPku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYLUPkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:40:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50370 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbYLUPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:40:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Dec 2008 16:39:46 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: prevent creation of multiple IR DMA contexts for
 the same channel
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <494BAC87.2020501@s5r6.in-berlin.de>
Message-ID: <tkrat.1c127a174726e6a0@s5r6.in-berlin.de>
References: <494A5F34.7090300@mpifr-bonn.mpg.de>
 <494AE2E3.6030602@s5r6.in-berlin.de> <494B9356.2070000@mpifr-bonn.mpg.de>
 <494BA9C7.6070806@s5r6.in-berlin.de> <494BAC87.2020501@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From OHCI-1394 1.1 clause 10.4.3:  "If more than one IR DMA context
specifies receives for packets from the same isochronous channel, the
context destination for that channel's packets is undefined."

Any userspace client and in the future also kernelspace clients can
allocate IR DMA contexts for any channel.  We don't want them to
interfere with each other, hence it is preferable to return -EBUSY if
allocation of a second context for a channel is attempted.

Notes:
  - This limitation is OHCI-1394 specific, therefore its proper place of
    implementation is down in the low-level driver.

  - Since the <linux/firewire-cdev.h> ABI simply maps one userspace iso
    client context to one hardware iso context, this OHCI-1394
    limitation alas requires userspace to implement its own multiplexing
    of iso reception from the same channel to multiple clients when
    needed.

  - The limitation is independent of channel allocation at the IRM; the
    latter is really only important for the initiation of iso 
    transmission but not of iso reception.

  - We don't need to do the same for IT DMA because OHCI-1394 does not
    have any ties between IT contexts and channels.  Only the voluntary
    channel allocation protocol via the IRM, globally to the FireWire
    bus, can ensure proper isochronous transmit behaviour anyway.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

The same modification could or should be done to ohci1394 too.  So, if
anybody wants to see this in the old stack too, a patch would be
welcome.

 drivers/firewire/fw-iso.c         |    3 ++-
 drivers/firewire/fw-ohci.c        |   14 +++++++++++---
 drivers/firewire/fw-transaction.h |    2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

Index: linux/drivers/firewire/fw-iso.c
===================================================================
--- linux.orig/drivers/firewire/fw-iso.c
+++ linux/drivers/firewire/fw-iso.c
@@ -110,7 +110,8 @@ struct fw_iso_context *fw_iso_context_cr
 {
 	struct fw_iso_context *ctx;
 
-	ctx = card->driver->allocate_iso_context(card, type, header_size);
+	ctx = card->driver->allocate_iso_context(card,
+						 type, channel, header_size);
 	if (IS_ERR(ctx))
 		return ctx;
 
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -205,6 +205,7 @@ struct fw_ohci {
 
 	u32 it_context_mask;
 	struct iso_context *it_context_list;
+	u64 ir_context_channels;
 	u32 ir_context_mask;
 	struct iso_context *ir_context_list;
 };
@@ -1877,20 +1878,23 @@ static int handle_it_packet(struct conte
 }
 
 static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,
-						int type, size_t header_size)
+				int type, int channel, size_t header_size)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct iso_context *ctx, *list;
 	descriptor_callback_t callback;
+	u64 *channels, dont_care = ~0ULL;
 	u32 *mask, regs;
 	unsigned long flags;
 	int index, ret = -ENOMEM;
 
 	if (type == FW_ISO_CONTEXT_TRANSMIT) {
+		channels = &dont_care;
 		mask = &ohci->it_context_mask;
 		list = ohci->it_context_list;
 		callback = handle_it_packet;
 	} else {
+		channels = &ohci->ir_context_channels;
 		mask = &ohci->ir_context_mask;
 		list = ohci->ir_context_list;
 		if (ohci->use_dualbuffer)
@@ -1900,9 +1904,11 @@ static struct fw_iso_context *ohci_alloc
 	}
 
 	spin_lock_irqsave(&ohci->lock, flags);
-	index = ffs(*mask) - 1;
-	if (index >= 0)
+	index = *channels & 1ULL << channel ? ffs(*mask) - 1 : -1;
+	if (index >= 0) {
+		*channels &= ~(1ULL << channel);
 		*mask &= ~(1 << index);
+	}
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	if (index < 0)
@@ -2012,6 +2018,7 @@ static void ohci_free_iso_context(struct
 	} else {
 		index = ctx - ohci->ir_context_list;
 		ohci->ir_context_mask |= 1 << index;
+		ohci->ir_context_channels |= 1ULL << base->channel;
 	}
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
@@ -2424,6 +2431,7 @@ static int __devinit pci_probe(struct pc
 	ohci->it_context_list = kzalloc(size, GFP_KERNEL);
 
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskSet, ~0);
+	ohci->ir_context_channels = ~0ULL;
 	ohci->ir_context_mask = reg_read(ohci, OHCI1394_IsoXmitIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskClear, ~0);
 	size = sizeof(struct iso_context) * hweight32(ohci->ir_context_mask);
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -383,7 +383,7 @@ struct fw_card_driver {
 
 	struct fw_iso_context *
 	(*allocate_iso_context)(struct fw_card *card,
-				int type, size_t header_size);
+				int type, int channel, size_t header_size);
 	void (*free_iso_context)(struct fw_iso_context *ctx);
 
 	int (*start_iso)(struct fw_iso_context *ctx,

-- 
Stefan Richter
-=====-==--- ==-- =-=-=
http://arcgraph.de/sr/

