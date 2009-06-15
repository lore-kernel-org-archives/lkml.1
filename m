Return-Path: <linux-kernel-owner+w=401wt.eu-S935628AbZFOV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628AbZFOV2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935564AbZFOV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:28:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43325 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935561AbZFOV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:28:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 15 Jun 2009 23:28:03 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: fix iso context shutdown on card removal
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.b34ed6e8730b9efc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If isochronous contexts existed when firewire-ohci was unloaded, the
core iso shutdown functions crashed with NULL dereferences and buffers
etc. weren't released.

The fix works thus that we first copy the card driver's iso shutdown
hooks into the dummy driver, then fw_destroy_nodes notifies upper layers
of devices going away, these should shut down (including their iso
contexts), wait_for_completion(&card->done) will be triggered after
upper layers gave up all fw_device references, after which the card
driver's shutdown proceeds.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -458,17 +458,17 @@ int fw_card_add(struct fw_card *card,
 	return ret;
 }
 EXPORT_SYMBOL(fw_card_add);
 
 
 /*
- * The next few functions implements a dummy driver that use once a
- * card driver shuts down an fw_card.  This allows the driver to
- * cleanly unload, as all IO to the card will be handled by the dummy
- * driver instead of calling into the (possibly) unloaded module.  The
- * dummy driver just fails all IO.
+ * The next few functions implement a dummy driver that is used once a card
+ * driver shuts down an fw_card.  This allows the driver to cleanly unload,
+ * as all IO to the card will be handled (and failed) by the dummy driver
+ * instead of calling into the module.  Only functions for iso context
+ * shutdown still need to be provided by the card driver.
  */
 
 static int dummy_enable(struct fw_card *card, u32 *config_rom, size_t length)
 {
 	BUG();
 	return -1;
@@ -509,13 +509,13 @@ static int dummy_cancel_packet(struct fw
 static int dummy_enable_phys_dma(struct fw_card *card,
 				 int node_id, int generation)
 {
 	return -ENODEV;
 }
 
-static struct fw_card_driver dummy_driver = {
+static const struct fw_card_driver dummy_driver = {
 	.enable          = dummy_enable,
 	.update_phy_reg  = dummy_update_phy_reg,
 	.set_config_rom  = dummy_set_config_rom,
 	.send_request    = dummy_send_request,
 	.cancel_packet   = dummy_cancel_packet,
 	.send_response   = dummy_send_response,
@@ -528,22 +528,26 @@ void fw_card_release(struct kref *kref)
 
 	complete(&card->done);
 }
 
 void fw_core_remove_card(struct fw_card *card)
 {
+	struct fw_card_driver shutdown_driver = dummy_driver;
+
 	card->driver->update_phy_reg(card, 4,
 				     PHY_LINK_ACTIVE | PHY_CONTENDER, 0);
 	fw_core_initiate_bus_reset(card, 1);
 
 	mutex_lock(&card_mutex);
 	list_del_init(&card->link);
 	mutex_unlock(&card_mutex);
 
-	/* Set up the dummy driver. */
-	card->driver = &dummy_driver;
+	/* Switch off most of the card driver interface. */
+	shutdown_driver.free_iso_context = card->driver->free_iso_context;
+	shutdown_driver.stop_iso         = card->driver->stop_iso;
+	card->driver = &shutdown_driver;
 
 	fw_destroy_nodes(card);
 
 	/* Wait for all users, especially device workqueue jobs, to finish. */
 	fw_card_put(card);
 	wait_for_completion(&card->done);

-- 
Stefan Richter
-=====-==--= -==- -====
http://arcgraph.de/sr/

