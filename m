Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYK2SBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYK2SBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYK2SBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:01:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52641 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYK2SBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:01:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 29 Nov 2008 19:00:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: reorder struct fw_card for better cache efficiency
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.c0ba1ba99cd6f8c3@s5r6.in-berlin.de>
Message-ID: <tkrat.1085fd9bce55f712@s5r6.in-berlin.de>
References: <tkrat.c0ba1ba99cd6f8c3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

topology_map is by far the largest member in struct fw_card.  Move it to
the very end of the struct so that card pointer dereferences have better
chances to hit the CPU cache.

This requires to increase the topology_map backing store to the size
specified in IEEE 1394, i.e. 256 rather than 255 quadlets.  Otherwise
the topology_map response handler may access invalid memory.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -235,13 +235,6 @@ struct fw_card {
 	int link_speed;
 	int config_rom_generation;
 
-	/*
-	 * We need to store up to 4 self ID for a maximum of 63
-	 * devices plus 3 words for the topology map header.
-	 */
-	u32 topology_map[252 + 3];
-	u32 broadcast_channel;
-
 	spinlock_t lock; /* Take this lock when handling the lists in
 			  * this struct. */
 	struct fw_node *local_node;
@@ -259,6 +252,9 @@ struct fw_card {
 	struct delayed_work work;
 	int bm_retries;
 	int bm_generation;
+
+	u32 broadcast_channel;
+	u32 topology_map[(CSR_TOPOLOGY_MAP_END - CSR_TOPOLOGY_MAP) / 4];
 };
 
 static inline struct fw_card *fw_card_get(struct fw_card *card)

-- 
Stefan Richter
-=====-==--- =-== ===-=
http://arcgraph.de/sr/

