Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbZE0BZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbZE0BZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbZE0BYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:24:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:52965 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072AbZE0BYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:24:40 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip 3/3] dma-debug: fix debug_dma_sync_sg_for_cpu and debug_dma_sync_sg_for_device
Date: Wed, 27 May 2009 09:43:03 +0900
Message-Id: <1243384983-3863-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1243384983-3863-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 May 2009 10:24:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA-mapping.txt says that debug_dma_sync_sg family must be called with
the _same_ one you passed into the dma_map_sg call, it should _NOT_ be
the 'count' value _returned_ from the dma_map_sg call.

debug_dma_sync_sg_for_cpu and debug_dma_sync_sg_for_device can't
handle this properly; they need to use the sg_mapped_ents in struct
dma_debug_entry as debug_dma_unmap_sg() does.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/dma-debug.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index df9e475..e10a981 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -799,13 +799,32 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 }
 EXPORT_SYMBOL(debug_dma_map_sg);
 
+static int get_nr_mapped_entries(struct device *dev, struct scatterlist *s)
+{
+	struct dma_debug_entry *entry;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+	int mapped_ents = 0;
+	struct dma_debug_entry ref;
+
+	ref.dev = dev;
+	ref.dev_addr = sg_dma_address(s);
+	ref.size = sg_dma_len(s),
+
+	bucket = get_hash_bucket(&ref, &flags);
+	entry = hash_bucket_find(bucket, &ref);
+	if (entry)
+		mapped_ents = entry->sg_mapped_ents;
+	put_hash_bucket(bucket, &flags);
+
+	return mapped_ents;
+}
+
 void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			int nelems, int dir)
 {
-	struct dma_debug_entry *entry;
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
-	unsigned long flags;
 
 	if (unlikely(global_disable))
 		return;
@@ -825,14 +844,9 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		if (mapped_ents && i >= mapped_ents)
 			break;
 
-		if (mapped_ents == 0) {
-			struct hash_bucket *bucket;
+		if (!i) {
 			ref.sg_call_ents = nelems;
-			bucket = get_hash_bucket(&ref, &flags);
-			entry = hash_bucket_find(bucket, &ref);
-			if (entry)
-				mapped_ents = entry->sg_mapped_ents;
-			put_hash_bucket(bucket, &flags);
+			mapped_ents = get_nr_mapped_entries(dev, s);
 		}
 
 		check_unmap(&ref);
@@ -934,12 +948,18 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 			       int nelems, int direction)
 {
 	struct scatterlist *s;
-	int i;
+	int mapped_ents = 0, i;
 
 	if (unlikely(global_disable))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
+		if (!i)
+			mapped_ents = get_nr_mapped_entries(dev, s);
+
+		if (i >= mapped_ents)
+			break;
+
 		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
 			   direction, true);
 	}
@@ -950,12 +970,18 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 				  int nelems, int direction)
 {
 	struct scatterlist *s;
-	int i;
+	int mapped_ents = 0, i;
 
 	if (unlikely(global_disable))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
+		if (!i)
+			mapped_ents = get_nr_mapped_entries(dev, s);
+
+		if (i >= mapped_ents)
+			break;
+
 		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
 			   direction, false);
 	}
-- 
1.6.0.6

