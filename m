Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbZDXMgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbZDXMgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZDXMgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:36:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:23368 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZDXMgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:36:09 -0400
X-BigFish: VPS-12(z21eWzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KILUZW-04-U61-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] dma-debug: remove broken dma memory leak detection for 2.6.30
Date: Fri, 24 Apr 2009 14:35:57 +0200
Message-ID: <1240576557-22442-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
X-OriginalArrivalTime: 24 Apr 2009 12:35:57.0458 (UTC) FILETIME=[377BD720:01C9C4D9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The feature needs some more work because the notfier which is used to
check for pending allocations is called before the device drivers
->remove() function. Therefore this feature reports false positives. A
real fix for this issue is to introduce a new notifier event which sent
_after_ the driver has deinitialized itself. That will done for the next
kernel version.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   53 +----------------------------------------------------
 1 files changed, 1 insertions(+), 52 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d3da7ed..69da09a 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -400,60 +400,9 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev)
-{
-	struct dma_debug_entry *entry;
-	unsigned long flags;
-	int count = 0, i;
-
-	for (i = 0; i < HASH_SIZE; ++i) {
-		spin_lock_irqsave(&dma_entry_hash[i].lock, flags);
-		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
-			if (entry->dev == dev)
-				count += 1;
-		}
-		spin_unlock_irqrestore(&dma_entry_hash[i].lock, flags);
-	}
-
-	return count;
-}
-
-static int dma_debug_device_change(struct notifier_block *nb,
-				    unsigned long action, void *data)
-{
-	struct device *dev = data;
-	int count;
-
-
-	switch (action) {
-	case BUS_NOTIFY_UNBIND_DRIVER:
-		count = device_dma_allocations(dev);
-		if (count == 0)
-			break;
-		err_printk(dev, NULL, "DMA-API: device driver has pending "
-				"DMA allocations while released from device "
-				"[count=%d]\n", count);
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 void dma_debug_add_bus(struct bus_type *bus)
 {
-	struct notifier_block *nb;
-
-	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
-	if (nb == NULL) {
-		printk(KERN_ERR "dma_debug_add_bus: out of memory\n");
-		return;
-	}
-
-	nb->notifier_call = dma_debug_device_change;
-
-	bus_register_notifier(bus, nb);
+	/* FIXME: register notifier */
 }
 
 /*
-- 
1.6.2.3


