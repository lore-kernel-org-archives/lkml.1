Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbYEYJHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbYEYJHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYEYJHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:07:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59251 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbYEYJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:07:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 25 May 2008 11:06:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: don't respond to broadcast write requests
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.bb719a25961b8dbc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contrary to a comment in the source, request->ack of a broadcast write
request can be ACK_PENDING.  Hence the existing check is insufficient.

Debug dmesg before:
AR spd 0 tl 00, ffc0 -> ffff, ack_pending , QW req, fffff0000234 = ffffffff
AT spd 0 tl 00, ffff -> ffc0, ack_complete, W resp
And the requesting node reports an unsolicited response.

Debug dmesg after:
AR spd 0 tl 00, ffc0 -> ffff, ack_pending , QW req, fffff0000234 = ffffffff

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -54,6 +54,9 @@
 #define HEADER_GET_DATA_LENGTH(q)	(((q) >> 16) & 0xffff)
 #define HEADER_GET_EXTENDED_TCODE(q)	(((q) >> 0) & 0xffff)
 
+#define HEADER_DESTINATION_IS_BROADCAST(q) \
+	(((q) & HEADER_DESTINATION(0x3f)) == HEADER_DESTINATION(0x3f))
+
 #define PHY_CONFIG_GAP_COUNT(gap_count)	(((gap_count) << 16) | (1 << 22))
 #define PHY_CONFIG_ROOT_ID(node_id)	((((node_id) & 0x3f) << 24) | (1 << 23))
 #define PHY_IDENTIFIER(id)		((id) << 30)
@@ -604,12 +607,9 @@ allocate_request(struct fw_packet *p)
 void
 fw_send_response(struct fw_card *card, struct fw_request *request, int rcode)
 {
-	/*
-	 * Broadcast packets are reported as ACK_COMPLETE, so this
-	 * check is sufficient to ensure we don't send response to
-	 * broadcast packets or posted writes.
-	 */
-	if (request->ack != ACK_PENDING) {
+	/* unified transaction or broadcast transaction: don't respond */
+	if (request->ack != ACK_PENDING ||
+	    HEADER_DESTINATION_IS_BROADCAST(request->request_header[0])) {
 		kfree(request);
 		return;
 	}

-- 
Stefan Richter
-=====-==--- -=-= ==--=
http://arcgraph.de/sr/

