Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZFHOfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZFHOfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZFHOeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:34:44 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:18313 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbZFHOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:34:43 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKXCHF-01-S4M-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/5] dma-debug: disable/enable irqs only once in device_dma_allocations
Date: Mon, 8 Jun 2009 16:34:09 +0200
Message-ID: <1244471650-4632-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
References: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Jun 2009 14:34:14.0506 (UTC) FILETIME=[323E2CA0:01C9E846]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to disable/enable irqs on each loop iteration. Just
disable irqs for the whole time the loop runs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 24c4a2c..27b369d 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -649,15 +649,19 @@ static int device_dma_allocations(struct device *dev)
 	unsigned long flags;
 	int count = 0, i;
 
+	local_irq_save(flags);
+
 	for (i = 0; i < HASH_SIZE; ++i) {
-		spin_lock_irqsave(&dma_entry_hash[i].lock, flags);
+		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
 			if (entry->dev == dev)
 				count += 1;
 		}
-		spin_unlock_irqrestore(&dma_entry_hash[i].lock, flags);
+		spin_unlock(&dma_entry_hash[i].lock);
 	}
 
+	local_irq_restore(flags);
+
 	return count;
 }
 
-- 
1.6.3.1


