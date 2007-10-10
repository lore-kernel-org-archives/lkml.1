Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXJJUiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXJJUiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbXJJUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:37:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41641 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbXJJUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:37:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 10 Oct 2007 22:37:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.22.y.] firewire: fix unloading of fw-ohci while devices
 are attached
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.da18b1110ff68dcd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix panic in run_timer_softirq right after "modprobe -r firewire-ohci"
if a FireWire disk was attached and firewire-sbp2 loaded.

Same as commit 8a2d9ed3210464d22fccb9834970629c1c36fa36.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

(I somehow forgot to send this earlier.)

 drivers/firewire/fw-card.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.22.10/drivers/firewire/fw-card.c
===================================================================
--- linux-2.6.22.10.orig/drivers/firewire/fw-card.c
+++ linux-2.6.22.10/drivers/firewire/fw-card.c
@@ -507,9 +507,11 @@ fw_core_remove_card(struct fw_card *card
 	/* Set up the dummy driver. */
 	card->driver = &dummy_driver;
 
-	fw_flush_transactions(card);
-
 	fw_destroy_nodes(card);
+	flush_scheduled_work();
+
+	fw_flush_transactions(card);
+	del_timer_sync(&card->flush_timer);
 
 	fw_card_put(card);
 }

-- 
Stefan Richter
-=====-=-=== =-=- -=-=-
http://arcgraph.de/sr/

