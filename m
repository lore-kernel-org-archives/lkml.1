Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYGLMvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYGLMvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYGLMu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:50:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49851 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYGLMu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:50:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Jul 2008 14:50:42 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 3/4] firewire: small fw_fill_request cleanup
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
Message-ID: <tkrat.ff97577d2d7f3441@s5r6.in-berlin.de>
References: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - better name for a function argument
  - removal of a local variable which became unnecessary after
    "fully initialize fw_transaction before marking it pending"

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -151,7 +151,7 @@ transmit_complete_callback(struct fw_pac
 
 static void
 fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
-		int node_id, int source_id, int generation, int speed,
+		int destination_id, int source_id, int generation, int speed,
 		unsigned long long offset, void *payload, size_t length)
 {
 	int ext_tcode;
@@ -166,7 +166,7 @@ fw_fill_request(struct fw_packet *packet
 		HEADER_RETRY(RETRY_X) |
 		HEADER_TLABEL(tlabel) |
 		HEADER_TCODE(tcode) |
-		HEADER_DESTINATION(node_id);
+		HEADER_DESTINATION(destination_id);
 	packet->header[1] =
 		HEADER_OFFSET_HIGH(offset >> 32) | HEADER_SOURCE(source_id);
 	packet->header[2] =
@@ -252,7 +252,7 @@ fw_send_request(struct fw_card *card, st
 		fw_transaction_callback_t callback, void *callback_data)
 {
 	unsigned long flags;
-	int tlabel, source;
+	int tlabel;
 
 	/*
 	 * Bump the flush timer up 100ms first of all so we
@@ -268,7 +268,6 @@ fw_send_request(struct fw_card *card, st
 
 	spin_lock_irqsave(&card->lock, flags);
 
-	source = card->node_id;
 	tlabel = card->current_tlabel;
 	if (card->tlabel_mask & (1 << tlabel)) {
 		spin_unlock_irqrestore(&card->lock, flags);
@@ -284,9 +283,8 @@ fw_send_request(struct fw_card *card, st
 	t->callback = callback;
 	t->callback_data = callback_data;
 
-	fw_fill_request(&t->packet, tcode, t->tlabel,
-			node_id, source, generation,
-			speed, offset, payload, length);
+	fw_fill_request(&t->packet, tcode, t->tlabel, node_id, card->node_id,
+			generation, speed, offset, payload, length);
 	t->packet.callback = transmit_complete_callback;
 
 	list_add_tail(&t->link, &card->transaction_list);

-- 
Stefan Richter
-=====-==--- -=== -==--
http://arcgraph.de/sr/

