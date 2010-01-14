Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519Ab0ANWge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0ANWge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083Ab0ANWgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:36:31 -0500
Received: from kroah.org ([198.145.64.141]:60583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0ANW2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:38 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Krzysztof Halasa <khc@pm.waw.pl>, David Miller <davem@davemloft.net>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/52] dma-debug: allow DMA_BIDIRECTIONAL mappings to be synced with DMA_FROM_DEVICE and
Date: Thu, 14 Jan 2010 14:27:03 -0800
Message-Id: <1263508051-7868-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-23-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Halasa <khc@pm.waw.pl>

commit 42d53b4ff7d61487d18274ebdf1f70c1aef6f122 upstream.

There is no need to perform full BIDIR sync (copying the buffers in case
of swiotlb and similar schemes) if we know that the owner (CPU or device)
hasn't altered the data.

Addresses the false-positive reported at
http://bugzilla.kernel.org/show_bug.cgi?id=14169

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: David Miller <davem@davemloft.net>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dma-debug.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 5a77c7c..084e879 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -913,6 +913,9 @@ static void check_sync(struct device *dev,
 				ref->size);
 	}
 
+	if (entry->direction == DMA_BIDIRECTIONAL)
+		goto out;
+
 	if (ref->direction != entry->direction) {
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"DMA memory with different direction "
@@ -923,9 +926,6 @@ static void check_sync(struct device *dev,
 				dir2name[ref->direction]);
 	}
 
-	if (entry->direction == DMA_BIDIRECTIONAL)
-		goto out;
-
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
 		      !(ref->direction == DMA_TO_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
@@ -948,7 +948,6 @@ static void check_sync(struct device *dev,
 
 out:
 	put_hash_bucket(bucket, &flags);
-
 }
 
 void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
-- 
1.6.6

