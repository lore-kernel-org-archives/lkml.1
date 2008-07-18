Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbYGRWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbYGRWP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760204AbYGRWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:55574 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759447AbYGRWLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:51 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 11/12] ipwireless: Put packets to pool start
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:50 +0200
Message-ID: <20080718221150.19195.85883.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put packets to pool start, try to reuse cached memory.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 814ea32..d1e69de 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -563,9 +563,9 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 		if (!list_empty(&hw->rx_pool)) {
 			packet = list_first_entry(&hw->rx_pool,
 					struct ipw_rx_packet, queue);
-			list_del(&packet->queue);
 			hw->rx_pool_size--;
 			spin_unlock_irqrestore(&hw->lock, flags);
+			list_del(&packet->queue);
 		} else {
 			static int min_capacity = 256;
 			int new_capacity;
@@ -610,7 +610,7 @@ static void pool_free(struct ipw_hardware *hw, struct ipw_rx_packet *packet)
 		kfree(packet);
 	else {
 		hw->rx_pool_size++;
-		list_add_tail(&packet->queue, &hw->rx_pool);
+		list_add(&packet->queue, &hw->rx_pool);
 	}
 }
 

