Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYGLMua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYGLMua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYGLMuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:50:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49846 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYGLMuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:50:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Jul 2008 14:50:06 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 2/4] firewire: fully initialize fw_transaction before marking
 it pending
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
Message-ID: <tkrat.9a558c6224aca75b@s5r6.in-berlin.de>
References: <tkrat.3186168349c88b15@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In theory, card->flush_timer could already access a transaction between
fw_send_request()'s spin_unlock_irqrestore and the rest of what happens
in fw_send_request().  This would happen if the process which sends the
request is preempted and put to sleep right after spin_unlock_irqrestore
for longer than 100ms.

Therefore we fill in everything in struct fw_transaction at which the
flush_timer might look at before we lift the lock.

To do:  Ensure that the timer does not pick up the transaction before
the time of the AT request event plus split transaction timeout.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -279,11 +279,6 @@ fw_send_request(struct fw_card *card, st
 	card->current_tlabel = (card->current_tlabel + 1) & 0x1f;
 	card->tlabel_mask |= (1 << tlabel);
 
-	list_add_tail(&t->link, &card->transaction_list);
-
-	spin_unlock_irqrestore(&card->lock, flags);
-
-	/* Initialize rest of transaction, fill out packet and send it. */
 	t->node_id = node_id;
 	t->tlabel = tlabel;
 	t->callback = callback;
@@ -294,6 +289,10 @@ fw_send_request(struct fw_card *card, st
 			speed, offset, payload, length);
 	t->packet.callback = transmit_complete_callback;
 
+	list_add_tail(&t->link, &card->transaction_list);
+
+	spin_unlock_irqrestore(&card->lock, flags);
+
 	card->driver->send_request(card, &t->packet);
 }
 EXPORT_SYMBOL(fw_send_request);

-- 
Stefan Richter
-=====-==--- -=== -==--
http://arcgraph.de/sr/

