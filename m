Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbZLQEDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbZLQEDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761514AbZLQEDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:32 -0500
Received: from kroah.org ([198.145.64.141]:55171 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994AbZLQEDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:43 2009
Message-Id: <20091217035643.371242977@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jay Fenlason <fenlason@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [003/151] firewire: ohci: handle receive packets with a data length of zero
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
 drivers/firewire/ohci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2209,6 +2209,13 @@ static int ohci_queue_iso_receive_dualbu
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
@@ -2262,7 +2269,7 @@ static int ohci_queue_iso_receive_packet
 					unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
-	struct descriptor *d = NULL, *pd = NULL;
+	struct descriptor *d, *pd;
 	struct fw_iso_packet *p = packet;
 	dma_addr_t d_bus, page_bus;
 	u32 z, header_z, rest;
@@ -2300,8 +2307,9 @@ static int ohci_queue_iso_receive_packet
 		d->data_address = cpu_to_le32(d_bus + (z * sizeof(*d)));
 
 		rest = payload_per_buffer;
+		pd = d;
 		for (j = 1; j < z; j++) {
-			pd = d + j;
+			pd++;
 			pd->control = cpu_to_le16(DESCRIPTOR_STATUS |
 						  DESCRIPTOR_INPUT_MORE);
 


