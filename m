Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYCKBRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYCKBRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYCKBRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:17:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37090 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYCKBRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:17:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 11 Mar 2008 02:16:08 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: untangle a mixed unsigned/signed
 expression
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ebca3f78fa768606@s5r6.in-berlin.de>
Message-ID: <tkrat.3e10d02dc42cb944@s5r6.in-berlin.de>
References: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de>
 <200803100047.05387.jwilson@redhat.com>
 <tkrat.ebca3f78fa768606@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My old C textbook says that the result of casting an unsigned to signed
is undefined if the former's value can't be represented in the latter's
type.  Maybe that book is too old...?

Anyway, this change makes it more explicit what is going on, i.e. that
p.ack is meant to become negative on some occasions.  (p.ack is an int.)
fw-ohci.s does actually not change due to 1st and 2nd hunk of this patch
(with gcc 4.1.2 i686 -O2).

The 3rd hunk makes an expression more readable.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

applies after patch "firewire: debug AT, AR, and selfID-complete events"

 drivers/firewire/fw-ohci.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -421,6 +421,7 @@ static __le32 *handle_ar_packet(struct a
 	struct fw_ohci *ohci = ctx->ohci;
 	struct fw_packet p;
 	u32 status, length, tcode;
+	int evt;
 
 	p.header[0] = cond_le32_to_cpu(buffer[0]);
 	p.header[1] = cond_le32_to_cpu(buffer[1]);
@@ -464,13 +465,14 @@ static __le32 *handle_ar_packet(struct a
 	length = (p.header_length + p.payload_length + 3) / 4;
 	status = cond_le32_to_cpu(buffer[length]);
 
-	p.ack        = ((status >> 16) & 0x1f) - 16;
+	evt          = (status >> 16) & 0x1f;
+	p.ack        = evt - 16;
 	p.speed      = (status >> 21) & 0x7;
 	p.timestamp  = status & 0xffff;
 	p.generation = ohci->request_generation;
 
 	if (unlikely(param_debug & OHCI_PARAM_DEBUG_AT_AR))
-		debug_ar_at_event('R', p.speed, p.header, status >> 16 & 0x1f);
+		debug_ar_at_event('R', p.speed, p.header, evt);
 
 	/*
 	 * The OHCI bus reset handler synthesizes a phy packet with
@@ -482,7 +484,7 @@ static __le32 *handle_ar_packet(struct a
 	 * request.
 	 */
 
-	if (p.ack + 16 == 0x09)
+	if (evt == OHCI1394_evt_bus_reset)
 		ohci->request_generation = (p.header[2] >> 16) & 0xff;
 	else if (ctx == &ohci->ar_request_ctx)
 		fw_core_handle_request(&ohci->card, &p);

-- 
Stefan Richter
-=====-==--- --== -=-==
http://arcgraph.de/sr/


