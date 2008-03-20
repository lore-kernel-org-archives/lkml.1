Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbYCTWt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbYCTWt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYCTWtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:49:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42947 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbYCTWtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:49:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 20 Mar 2008 23:48:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: wait until PHY configuration packet was transmitted
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
Message-ID: <tkrat.47c2348a94015e02@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now exit fw_send_phy_config /after/ the PHY config packet has been
transmitted, instead of before.  A subsequent fw_core_initiate_bus_reset
will therefore not overlap with the transmission.  This is meant to make
the send PHY config packet + reset bus routine more deterministic.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |   49 ++++++++++++++----------------
 1 file changed, 24 insertions(+), 25 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -18,6 +18,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/completion.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -294,42 +295,40 @@ fw_send_request(struct fw_card *card, st
 }
 EXPORT_SYMBOL(fw_send_request);
 
+struct fw_phy_packet {
+	struct fw_packet packet;
+	struct completion done;
+};
+
 static void
 transmit_phy_packet_callback(struct fw_packet *packet,
 			     struct fw_card *card, int status)
 {
-	kfree(packet);
-}
-
-static void send_phy_packet(struct fw_card *card, u32 data, int generation)
-{
-	struct fw_packet *packet;
+	struct fw_phy_packet *p =
+			container_of(packet, struct fw_phy_packet, packet);
 
-	packet = kzalloc(sizeof(*packet), GFP_ATOMIC);
-	if (packet == NULL)
-		return;
-
-	packet->header[0] = data;
-	packet->header[1] = ~data;
-	packet->header_length = 8;
-	packet->payload_length = 0;
-	packet->speed = SCODE_100;
-	packet->generation = generation;
-	packet->callback = transmit_phy_packet_callback;
-
-	card->driver->send_request(card, packet);
+	complete(&p->done);
 }
 
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count)
 {
-	u32 q;
-
-	q = PHY_IDENTIFIER(PHY_PACKET_CONFIG) |
-		PHY_CONFIG_ROOT_ID(node_id) |
-		PHY_CONFIG_GAP_COUNT(gap_count);
+	struct fw_phy_packet p;
+	u32 data = PHY_IDENTIFIER(PHY_PACKET_CONFIG) |
+		   PHY_CONFIG_ROOT_ID(node_id) |
+		   PHY_CONFIG_GAP_COUNT(gap_count);
+
+	p.packet.header[0] = data;
+	p.packet.header[1] = ~data;
+	p.packet.header_length = 8;
+	p.packet.payload_length = 0;
+	p.packet.speed = SCODE_100;
+	p.packet.generation = generation;
+	p.packet.callback = transmit_phy_packet_callback;
+	init_completion(&p.done);
 
-	send_phy_packet(card, q, generation);
+	card->driver->send_request(card, &p.packet);
+	wait_for_completion(&p.done);
 }
 
 void fw_flush_transactions(struct fw_card *card)

-- 
Stefan Richter
-=====-==--- --== =-=--
http://arcgraph.de/sr/

