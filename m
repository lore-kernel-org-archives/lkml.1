Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZDZQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZDZQnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZDZQn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:43:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:43962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbZDZQnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:43:25 -0400
Date: Sun, 26 Apr 2009 16:42:42 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240576557-22442-1-git-send-email-joerg.roedel@amd.com>
References: <1240576557-22442-1-git-send-email-joerg.roedel@amd.com>
Subject: [tip:core/urgent] dma-debug: remove broken dma memory leak detection for 2.6.30
Message-ID: <tip-314eeac9e35d8b934dd7a09ed3a8e00d41977b84@git.kernel.org>
Git-Commit-ID: 314eeac9e35d8b934dd7a09ed3a8e00d41977b84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 26 Apr 2009 16:42:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  314eeac9e35d8b934dd7a09ed3a8e00d41977b84
Gitweb:     http://git.kernel.org/tip/314eeac9e35d8b934dd7a09ed3a8e00d41977b84
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Fri, 24 Apr 2009 14:35:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 26 Apr 2009 18:23:56 +0200

dma-debug: remove broken dma memory leak detection for 2.6.30

The feature needs some more work because the notfier which is used to
check for pending allocations is called before the device drivers
->remove() function. Therefore this feature reports false positives.

A real fix for this issue is to introduce a new notifier event which sent
_after_ the driver has deinitialized itself. That will done for the next
kernel version.

[ Impact: reduce the scope of CONFIG_DMA_API_DEBUG=y checks ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org
LKML-Reference: <1240576557-22442-1-git-send-email-joerg.roedel@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
