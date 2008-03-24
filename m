Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYCXT6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYCXT6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbYCXT6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:58:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51911 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbYCXT6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:58:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Mar 2008 20:56:40 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: unnecessary BM delay after generation rollover
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.7cb6088b953ca5bd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by Jarod Wilson:  The bus manager work was unnecessarily delayed
each time the bus generation counter rolled over.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c        |    2 +-
 drivers/firewire/fw-topology.c    |    2 +-
 drivers/firewire/fw-transaction.h |    9 +++++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -240,7 +240,7 @@ fw_card_bm_work(struct work_struct *work
 	root_id = root_node->node_id;
 	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
 
-	if (card->bm_generation + 1 == generation ||
+	if (is_next_generation(generation, card->bm_generation) ||
 	    (card->bm_generation != generation && grace)) {
 		/*
 		 * This first step is to figure out who is IRM and
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -518,7 +518,7 @@ fw_core_handle_bus_reset(struct fw_card 
 	 * previously processed one, we cannot reliably compare the
 	 * old and new topologies.
 	 */
-	if ((generation & 0xff) != ((card->generation + 1) & 0xff) &&
+	if (!is_next_generation(generation, card->generation) &&
 	    card->local_node != NULL) {
 		fw_notify("skipped bus generations, destroying all nodes\n");
 		fw_destroy_nodes(card);
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -261,6 +261,15 @@ struct fw_card {
 };
 
 /*
+ * Check whether new_generation is the immediate successor of old_generation.
+ * Take counter roll-over at 255 (as per to OHCI) into account.
+ */
+static inline bool is_next_generation(int new_generation, int old_generation)
+{
+	return (new_generation & 0xff) == ((old_generation + 1) & 0xff);
+}
+
+/*
  * The iso packet format allows for an immediate header/payload part
  * stored in 'header' immediately after the packet info plus an
  * indirect payload part that is pointer to by the 'payload' field.

-- 
Stefan Richter
-=====-==--- --== ==---
http://arcgraph.de/sr/

