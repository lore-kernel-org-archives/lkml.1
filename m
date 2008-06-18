Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYFRQVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYFRQVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYFRQU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:20:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52433 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYFRQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:20:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 18 Jun 2008 18:20:45 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: deadline for PHY config transmission
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <4858D304.80907@s5r6.in-berlin.de>
Message-ID: <tkrat.9d09a78f5e399feb@s5r6.in-berlin.de>
References: <tkrat.230a7a03785f244f@s5r6.in-berlin.de>
 <4858D304.80907@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the low-level driver failed to initialize a card properly without
noticing it, fw-core was blocked indefinitely when trying to send a
PHY config packet.  This hung up the events kernel thread, e.g. locked
up keyboard input.
https://bugzilla.redhat.com/show_bug.cgi?id=444694
https://bugzilla.redhat.com/show_bug.cgi?id=446763

This problem was introduced between 2.6.25 and 2.6.26-rc1 by commit
2a0a2590498be7b92e3e76409c9b8ee722e23c8f "firewire: wait until PHY
configuration packet was transmitted (fix bus reset loop)".

The solution is to wait with timeout.  I tested it with 7 different
working controllers and 1 non-working controller.  On the working ones,
the packet callback complete()s usually --- but not always --- before a
timeout of 10ms.  Hence I chose a safer timeout of 100ms.

On the few tests with the non-working controller ALi M5271, PHY config
packet transmission always timed out so far.  (Fw-ohci needs to be fixed
for this controller independently of this deadline fix.  Often the core
doesn't even attempt to send a phy config because not even self ID
reception works.)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |   47 +++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 14 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -20,6 +20,7 @@
 
 #include <linux/completion.h>
 #include <linux/kernel.h>
+#include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -300,37 +301,55 @@ EXPORT_SYMBOL(fw_send_request);
 struct fw_phy_packet {
 	struct fw_packet packet;
 	struct completion done;
+	struct kref kref;
 };
 
-static void
-transmit_phy_packet_callback(struct fw_packet *packet,
-			     struct fw_card *card, int status)
+static void phy_packet_release(struct kref *kref)
+{
+	struct fw_phy_packet *p =
+			container_of(kref, struct fw_phy_packet, kref);
+	kfree(p);
+}
+
+static void transmit_phy_packet_callback(struct fw_packet *packet,
+					 struct fw_card *card, int status)
 {
 	struct fw_phy_packet *p =
 			container_of(packet, struct fw_phy_packet, packet);
 
 	complete(&p->done);
+	kref_put(&p->kref, phy_packet_release);
 }
 
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count)
 {
-	struct fw_phy_packet p;
+	struct fw_phy_packet *p;
+	long timeout = DIV_ROUND_UP(HZ, 10);
 	u32 data = PHY_IDENTIFIER(PHY_PACKET_CONFIG) |
 		   PHY_CONFIG_ROOT_ID(node_id) |
 		   PHY_CONFIG_GAP_COUNT(gap_count);
 
-	p.packet.header[0] = data;
-	p.packet.header[1] = ~data;
-	p.packet.header_length = 8;
-	p.packet.payload_length = 0;
-	p.packet.speed = SCODE_100;
-	p.packet.generation = generation;
-	p.packet.callback = transmit_phy_packet_callback;
-	init_completion(&p.done);
+	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	if (p == NULL)
+		return;
+
+	p->packet.header[0] = data;
+	p->packet.header[1] = ~data;
+	p->packet.header_length = 8;
+	p->packet.payload_length = 0;
+	p->packet.speed = SCODE_100;
+	p->packet.generation = generation;
+	p->packet.callback = transmit_phy_packet_callback;
+	init_completion(&p->done);
+	kref_set(&p->kref, 2);
+
+	card->driver->send_request(card, &p->packet);
+	timeout = wait_for_completion_timeout(&p->done, timeout);
+	kref_put(&p->kref, phy_packet_release);
 
-	card->driver->send_request(card, &p.packet);
-	wait_for_completion(&p.done);
+	/* will leak p if the callback is never executed */
+	WARN_ON(timeout == 0);
 }
 
 void fw_flush_transactions(struct fw_card *card)

-- 
Stefan Richter
-=====-==--- -==- =--=-
http://arcgraph.de/sr/

