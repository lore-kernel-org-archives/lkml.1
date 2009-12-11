Return-Path: <linux-kernel-owner+w=401wt.eu-S1762599AbZLKU7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762599AbZLKU7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762506AbZLKU7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:59:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37223 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761493AbZLKU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:59:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 11 Dec 2009 21:59:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.71d11155e1b4d897@s5r6.in-berlin.de>
Message-ID: <tkrat.c98ccacd8716c278@s5r6.in-berlin.de>
References: <tkrat.71d11155e1b4d897@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a FireWire subsystem fix.

Jay Fenlason (1):
      firewire: ohci: handle receive packets with a data length of zero

 drivers/firewire/ohci.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

Thanks.


commit 8c0c0cc2d9f4c523fde04bdfe41e4380dec8ee54
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Fri Dec 11 14:23:58 2009 -0500

    firewire: ohci: handle receive packets with a data length of zero
    
    Queueing to receive an ISO packet with a payload length of zero
    silently does nothing in dualbuffer mode, and crashes the kernel in
    packet-per-buffer mode.  Return an error in dualbuffer mode, because
    the DMA controller won't let us do what we want, and work correctly in
    packet-per-buffer mode.
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Cc: stable@kernel.org

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index a714775..553c74e 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2189,6 +2189,13 @@ static int ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
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
@@ -2242,7 +2249,7 @@ static int ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
 					unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
-	struct descriptor *d = NULL, *pd = NULL;
+	struct descriptor *d, *pd;
 	struct fw_iso_packet *p = packet;
 	dma_addr_t d_bus, page_bus;
 	u32 z, header_z, rest;
@@ -2280,8 +2287,9 @@ static int ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
 		d->data_address = cpu_to_le32(d_bus + (z * sizeof(*d)));
 
 		rest = payload_per_buffer;
+		pd = d;
 		for (j = 1; j < z; j++) {
-			pd = d + j;
+			pd++;
 			pd->control = cpu_to_le16(DESCRIPTOR_STATUS |
 						  DESCRIPTOR_INPUT_MORE);
 
-- 
Stefan Richter
-=====-==--= ==-- -=-==
http://arcgraph.de/sr/

