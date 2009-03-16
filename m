Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbZCPRG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbZCPRG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbZCPRGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:06:17 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:54383
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760280AbZCPRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:06:14 -0400
X-BigFish: VPS1(zzzz1202hzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KGLZH2-02-R4W-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] dma-debug: add a check dma memory leaks
Date: Mon, 16 Mar 2009 18:05:29 +0100
Message-ID: <1237223130-26519-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Mar 2009 17:05:30.0540 (UTC) FILETIME=[69480EC0:01C9A659]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow architectures to monitor busses for dma mem leakage

This patch adds checking code to detect if a device has pending DMA
operations when it is about to be unbound from its device driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |    7 +++++
 lib/dma-debug.c           |   55 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 46a11c1..e851d23 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -24,9 +24,12 @@
 
 struct device;
 struct scatterlist;
+struct bus_type;
 
 #ifdef CONFIG_DMA_API_DEBUG
 
+extern void dma_debug_add_bus(struct bus_type *bus);
+
 extern void dma_debug_init(u32 num_entries);
 
 extern void debug_dma_map_page(struct device *dev, struct page *page,
@@ -80,6 +83,10 @@ extern void debug_dma_dump_mappings(struct device *dev);
 
 #else /* CONFIG_DMA_API_DEBUG */
 
+void dma_debug_add_bus(struct bus_type *bus)
+{
+}
+
 static inline void dma_debug_init(u32 num_entries)
 {
 }
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index b6a303f..3b20ae9 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -400,6 +400,61 @@ out_err:
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
+	case BUS_NOTIFY_UNBIND_DRIVER:
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
+void dma_debug_add_bus(struct bus_type *bus)
+{
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
+}
 
 /*
  * Let the architectures decide how many entries should be preallocated.
-- 
1.5.6.4


