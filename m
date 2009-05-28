Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbZE1POQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbZE1POQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZE1POE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:14:04 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:55767
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751381AbZE1POD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:14:03 -0400
X-BigFish: VPS2(zz10d1Izz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KKD0Z3-04-ATT-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] dma-debug: re-add dma memory leak detection
Date: Thu, 28 May 2009 17:13:44 +0200
Message-ID: <1243523624-12591-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 28 May 2009 15:13:53.0645 (UTC) FILETIME=[E9C6B9D0:01C9DFA6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically a revert of commit 314eeac9 but now in a
fixed version.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index cdd205d..e47e1a0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -105,6 +105,11 @@ static const char *type2name[4] = { "single", "page",
 static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
 				   "DMA_FROM_DEVICE", "DMA_NONE" };
 
+/* little merge helper - remove it after the merge window */
+#ifndef BUS_NOTIFY_UNBOUND_DRIVER
+#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
+#endif
+
 /*
  * The access to some variables in this macro is racy. We can't use atomic_t
  * here because all these variables are exported to debugfs. Some of them even
@@ -458,9 +463,60 @@ out_err:
 	return -ENOMEM;
 }
 
+static int device_dma_allocations(struct device *dev)
+{
+	struct dma_debug_entry *entry;
+	unsigned long flags;
+	int count = 0, i;
+
+	for (i = 0; i < HASH_SIZE; ++i) {
+		spin_lock_irqsave(&dma_entry_hash[i].lock, flags);
+		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
+			if (entry->dev == dev)
+				count += 1;
+		}
+		spin_unlock_irqrestore(&dma_entry_hash[i].lock, flags);
+	}
+
+	return count;
+}
+
+static int dma_debug_device_change(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct device *dev = data;
+	int count;
+
+
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		count = device_dma_allocations(dev);
+		if (count == 0)
+			break;
+		err_printk(dev, NULL, "DMA-API: device driver has pending "
+				"DMA allocations while released from device "
+				"[count=%d]\n", count);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 void dma_debug_add_bus(struct bus_type *bus)
 {
-	/* FIXME: register notifier */
+	struct notifier_block *nb;
+
+	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
+	if (nb == NULL) {
+		printk(KERN_ERR "dma_debug_add_bus: out of memory\n");
+		return;
+	}
+
+	nb->notifier_call = dma_debug_device_change;
+
+	bus_register_notifier(bus, nb);
 }
 
 /*
-- 
1.6.3.1


