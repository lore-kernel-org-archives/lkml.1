Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYGVTgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYGVTgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYGVTf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:35:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43041 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYGVTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:35:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 22 Jul 2008 21:35:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: avoid memleak after phy config transmit failure
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.cd6a0cf7b54c3fa3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use only statically allocated data for PHY config packet transmission.
With the previous incarnation, some data wouldn't be freed if the packet
transmit callback was never called.

A theoretical drawback now is that, in PCs with more than one card,
card A may complete() for a waiter on card B.  But this is highly
unlikely and its impact not serious.  Bus manager B may reset bus B
before the PHY config went out, but the next phy config on B should be
fine.  However, with a timeout of 100ms, this situation is close to
impossible.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |   56 ++++++++++--------------------
 1 file changed, 20 insertions(+), 36 deletions(-)

Index: linux-2.6.26/drivers/firewire/fw-transaction.c
===================================================================
--- linux-2.6.26.orig/drivers/firewire/fw-transaction.c
+++ linux-2.6.26/drivers/firewire/fw-transaction.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
@@ -335,58 +336,41 @@ int fw_run_transaction(struct fw_card *c
 }
 EXPORT_SYMBOL(fw_run_transaction);
 
-struct fw_phy_packet {
-	struct fw_packet packet;
-	struct completion done;
-	struct kref kref;
-};
-
-static void phy_packet_release(struct kref *kref)
-{
-	struct fw_phy_packet *p =
-			container_of(kref, struct fw_phy_packet, kref);
-	kfree(p);
-}
+static DEFINE_MUTEX(phy_config_mutex);
+static DECLARE_COMPLETION(phy_config_done);
 
 static void transmit_phy_packet_callback(struct fw_packet *packet,
 					 struct fw_card *card, int status)
 {
-	struct fw_phy_packet *p =
-			container_of(packet, struct fw_phy_packet, packet);
-
-	complete(&p->done);
-	kref_put(&p->kref, phy_packet_release);
+	complete(&phy_config_done);
 }
 
+static struct fw_packet phy_config_packet = {
+	.header_length	= 8,
+	.payload_length	= 0,
+	.speed		= SCODE_100,
+	.callback	= transmit_phy_packet_callback,
+};
+
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count)
 {
-	struct fw_phy_packet *p;
 	long timeout = DIV_ROUND_UP(HZ, 10);
 	u32 data = PHY_IDENTIFIER(PHY_PACKET_CONFIG) |
 		   PHY_CONFIG_ROOT_ID(node_id) |
 		   PHY_CONFIG_GAP_COUNT(gap_count);
 
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL)
-		return;
+	mutex_lock(&phy_config_mutex);
+
+	phy_config_packet.header[0] = data;
+	phy_config_packet.header[1] = ~data;
+	phy_config_packet.generation = generation;
+	INIT_COMPLETION(phy_config_done);
 
-	p->packet.header[0] = data;
-	p->packet.header[1] = ~data;
-	p->packet.header_length = 8;
-	p->packet.payload_length = 0;
-	p->packet.speed = SCODE_100;
-	p->packet.generation = generation;
-	p->packet.callback = transmit_phy_packet_callback;
-	init_completion(&p->done);
-	kref_set(&p->kref, 2);
-
-	card->driver->send_request(card, &p->packet);
-	timeout = wait_for_completion_timeout(&p->done, timeout);
-	kref_put(&p->kref, phy_packet_release);
+	card->driver->send_request(card, &phy_config_packet);
+	wait_for_completion_timeout(&phy_config_done, timeout);
 
-	/* will leak p if the callback is never executed */
-	WARN_ON(timeout == 0);
+	mutex_unlock(&phy_config_mutex);
 }
 
 void fw_flush_transactions(struct fw_card *card)

-- 
Stefan Richter
-=====-==--- -=== =-==-
http://arcgraph.de/sr/

