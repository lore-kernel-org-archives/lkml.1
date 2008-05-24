Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYEXOlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYEXOlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYEXOli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:41:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48228 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbYEXOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:41:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 May 2008 16:41:09 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: implement broadcast_channel CSR for 1394a
 compliance
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Message-ID: <tkrat.fdedc769e39362f9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See IEEE 1394a clause 8.3.2.3.11.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c        |    1 +
 drivers/firewire/fw-transaction.c |   20 +++++++++++++++++---
 drivers/firewire/fw-transaction.h |    4 ++++
 3 files changed, 22 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -403,6 +403,7 @@ fw_card_initialize(struct fw_card *card,
 	card->current_tlabel = 0;
 	card->tlabel_mask = 0;
 	card->color = 0;
+	card->broadcast_channel = BROADCAST_CHANNEL_INITIAL;
 
 	INIT_LIST_HEAD(&card->transaction_list);
 	spin_lock_init(&card->lock);
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -797,12 +797,13 @@ handle_registers(struct fw_card *card, s
 	int reg = offset & ~CSR_REGISTER_BASE;
 	unsigned long long bus_time;
 	__be32 *data = payload;
+	int rcode = RCODE_COMPLETE;
 
 	switch (reg) {
 	case CSR_CYCLE_TIME:
 	case CSR_BUS_TIME:
 		if (!TCODE_IS_READ_REQUEST(tcode) || length != 4) {
-			fw_send_response(card, request, RCODE_TYPE_ERROR);
+			rcode = RCODE_TYPE_ERROR;
 			break;
 		}
 
@@ -811,7 +812,17 @@ handle_registers(struct fw_card *card, s
 			*data = cpu_to_be32(bus_time);
 		else
 			*data = cpu_to_be32(bus_time >> 25);
-		fw_send_response(card, request, RCODE_COMPLETE);
+		break;
+
+	case CSR_BROADCAST_CHANNEL:
+		if (tcode == TCODE_READ_QUADLET_REQUEST)
+			*data = cpu_to_be32(card->broadcast_channel);
+		else if (tcode == TCODE_WRITE_QUADLET_REQUEST)
+			card->broadcast_channel =
+			    (be32_to_cpu(*data) & BROADCAST_CHANNEL_VALID) |
+			    BROADCAST_CHANNEL_INITIAL;
+		else
+			rcode = RCODE_TYPE_ERROR;
 		break;
 
 	case CSR_BUS_MANAGER_ID:
@@ -830,10 +841,13 @@ handle_registers(struct fw_card *card, s
 
 	case CSR_BUSY_TIMEOUT:
 		/* FIXME: Implement this. */
+
 	default:
-		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
+		rcode = RCODE_ADDRESS_ERROR;
 		break;
 	}
+
+	fw_send_response(card, request, rcode);
 }
 
 static struct fw_address_handler registers = {
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -80,6 +80,9 @@
 #define CSR_SPEED_MAP			0x2000
 #define CSR_SPEED_MAP_END		0x3000
 
+#define BROADCAST_CHANNEL_INITIAL	(1 << 31 | 31)
+#define BROADCAST_CHANNEL_VALID		(1 << 30)
+
 #define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
 #define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
 
@@ -236,6 +239,7 @@ struct fw_card {
 	 */
 	int self_id_count;
 	u32 topology_map[252 + 3];
+	u32 broadcast_channel;
 
 	spinlock_t lock; /* Take this lock when handling the lists in
 			  * this struct. */

-- 
Stefan Richter
-=====-==--- -=-= ==---
http://arcgraph.de/sr/

