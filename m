Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbZLQA7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbZLQA7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbZLQA7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:59:22 -0500
Received: from kroah.org ([198.145.64.141]:44470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbZLQAye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:54:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 16:47:07 2009
Message-Id: <20091217004707.341234770@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 16:45:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jay Fenlason <fenlason@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [03/18] firewire: ohci: handle receive packets with a data length of zero
In-Reply-To: <20091217005306.GA6230@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jay Fenlason <fenlason@redhat.com>

commit 8c0c0cc2d9f4c523fde04bdfe41e4380dec8ee54 upstream.

Queueing to receive an ISO packet with a payload length of zero
silently does nothing in dualbuffer mode, and crashes the kernel in
packet-per-buffer mode.  Return an error in dualbuffer mode, because
the DMA controller won't let us do what we want, and work correctly in
packet-per-buffer mode.

Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-ohci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -2146,6 +2146,13 @@ ohci_queue_iso_receive_dualbuffer(struct
 	page     = payload >> PAGE_SHIFT;
 	offset   = payload & ~PAGE_MASK;
 	rest     = p->payload_length;
+	/*
+	 * The controllers I've tested have not worked correctly when
+	 * second_req_count is zero.  Rather than do something we know won't
+	 * work, return an error
+	 */
+	if (rest == 0)
+		return -EINVAL;
 
 	/* FIXME: make packet-per-buffer/dual-buffer a context option */
 	while (rest > 0) {
@@ -2199,7 +2206,7 @@ ohci_queue_iso_receive_packet_per_buffer
 					 unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
-	struct descriptor *d = NULL, *pd = NULL;
+	struct descriptor *d, *pd;
 	struct fw_iso_packet *p = packet;
 	dma_addr_t d_bus, page_bus;
 	u32 z, header_z, rest;
@@ -2237,8 +2244,9 @@ ohci_queue_iso_receive_packet_per_buffer
 		d->data_address = cpu_to_le32(d_bus + (z * sizeof(*d)));
 
 		rest = payload_per_buffer;
+		pd = d;
 		for (j = 1; j < z; j++) {
-			pd = d + j;
+			pd++;
 			pd->control = cpu_to_le16(DESCRIPTOR_STATUS |
 						  DESCRIPTOR_INPUT_MORE);
 


