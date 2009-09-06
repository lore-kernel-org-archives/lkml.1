Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZIFQuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZIFQuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZIFQuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:50:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48870 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZIFQuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:50:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Sep 2009 18:50:29 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/6] firewire: core: fix race with parallel PCI device probe
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
In-Reply-To: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
Message-ID: <tkrat.81010d0d8bf7dd59@s5r6.in-berlin.de>
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config ROM buffer received from generate_config_rom is a globally
shared static buffer.  Extend the card_mutex protection in fw_add_card
until after the config ROM was copied into the card driver's buffer.
Otherwise, parallelized card driver probes may end up with ROM contents
that were meant for a different card.

firewire-ohci's card->driver->enable hook is safe to be called within
the card_mutex.  Furthermore, it is safe to reorder card_list update
versus card enable, which simplifies the code a little.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

Index: linux-2.6.31-rc9/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/core-card.c
+++ linux-2.6.31-rc9/drivers/firewire/core-card.c
@@ -449,16 +449,13 @@ int fw_card_add(struct fw_card *card,
 	card->guid = guid;
 
 	mutex_lock(&card_mutex);
-	config_rom = generate_config_rom(card, &length);
-	list_add_tail(&card->link, &card_list);
-	mutex_unlock(&card_mutex);
 
+	config_rom = generate_config_rom(card, &length);
 	ret = card->driver->enable(card, config_rom, length);
-	if (ret < 0) {
-		mutex_lock(&card_mutex);
-		list_del(&card->link);
-		mutex_unlock(&card_mutex);
-	}
+	if (ret == 0)
+		list_add_tail(&card->link, &card_list);
+
+	mutex_unlock(&card_mutex);
 
 	return ret;
 }

-- 
Stefan Richter
-=====-==--= =--= --==-
http://arcgraph.de/sr/

