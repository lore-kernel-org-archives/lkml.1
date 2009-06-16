Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZFPIwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZFPIwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZFPIw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:52:29 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:44095 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZFPIw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:52:27 -0400
X-SpamScore: -4
X-BigFish: VPS-4(z78cMzzz1202hzzz32i17ch63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KLBPZ4-02-3FT-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] dma-debug: be more careful when building reference entries
Date: Tue, 16 Jun 2009 10:52:10 +0200
Message-ID: <1245142330-7067-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142330-7067-1-git-send-email-joerg.roedel@amd.com>
References: <1245142330-7067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:52:15.0030 (UTC) FILETIME=[BEFC9D60:01C9EE5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code is not very careful when it builds reference
dma_debug_entries which get passed to hash_bucket_find(). But since this
function changed to a best-fit algorithm these entries have to be more
acurate. This patch adds this higher level of accuracy.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |  134 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index c71e2dd..3b93129 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -874,72 +874,68 @@ static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
 				"[addr=%p] [size=%llu]\n", addr, size);
 }
 
-static void check_sync(struct device *dev, dma_addr_t addr,
-		       u64 size, u64 offset, int direction, bool to_cpu)
+static void check_sync(struct device *dev,
+		       struct dma_debug_entry *ref,
+		       bool to_cpu)
 {
-	struct dma_debug_entry ref = {
-		.dev            = dev,
-		.dev_addr       = addr,
-		.size           = size,
-		.direction      = direction,
-	};
 	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	bucket = get_hash_bucket(&ref, &flags);
+	bucket = get_hash_bucket(ref, &flags);
 
-	entry = hash_bucket_find(bucket, &ref);
+	entry = hash_bucket_find(bucket, ref);
 
 	if (!entry) {
 		err_printk(dev, NULL, "DMA-API: device driver tries "
 				"to sync DMA memory it has not allocated "
 				"[device address=0x%016llx] [size=%llu bytes]\n",
-				(unsigned long long)addr, size);
+				(unsigned long long)ref->dev_addr, ref->size);
 		goto out;
 	}
 
-	if ((offset + size) > entry->size) {
+	if (ref->size > entry->size) {
 		err_printk(dev, entry, "DMA-API: device driver syncs"
 				" DMA memory outside allocated range "
 				"[device address=0x%016llx] "
-				"[allocation size=%llu bytes] [sync offset=%llu] "
-				"[sync size=%llu]\n", entry->dev_addr, entry->size,
-				offset, size);
+				"[allocation size=%llu bytes] "
+				"[sync offset+size=%llu]\n",
+				entry->dev_addr, entry->size,
+				ref->size);
 	}
 
-	if (direction != entry->direction) {
+	if (ref->direction != entry->direction) {
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"DMA memory with different direction "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
+				(unsigned long long)ref->dev_addr, entry->size,
 				dir2name[entry->direction],
-				dir2name[direction]);
+				dir2name[ref->direction]);
 	}
 
 	if (entry->direction == DMA_BIDIRECTIONAL)
 		goto out;
 
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
-		      !(direction == DMA_TO_DEVICE))
+		      !(ref->direction == DMA_TO_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device read-only DMA memory for cpu "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
+				(unsigned long long)ref->dev_addr, entry->size,
 				dir2name[entry->direction],
-				dir2name[direction]);
+				dir2name[ref->direction]);
 
 	if (!to_cpu && !(entry->direction == DMA_TO_DEVICE) &&
-		       !(direction == DMA_FROM_DEVICE))
+		       !(ref->direction == DMA_FROM_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
 				"device write-only DMA memory to device "
 				"[device address=0x%016llx] [size=%llu bytes] "
 				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
+				(unsigned long long)ref->dev_addr, entry->size,
 				dir2name[entry->direction],
-				dir2name[direction]);
+				dir2name[ref->direction]);
 
 out:
 	put_hash_bucket(bucket, &flags);
@@ -1037,19 +1033,16 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 }
 EXPORT_SYMBOL(debug_dma_map_sg);
 
-static int get_nr_mapped_entries(struct device *dev, struct scatterlist *s)
+static int get_nr_mapped_entries(struct device *dev,
+				 struct dma_debug_entry *ref)
 {
-	struct dma_debug_entry *entry, ref;
+	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 	int mapped_ents;
 
-	ref.dev      = dev;
-	ref.dev_addr = sg_dma_address(s);
-	ref.size     = sg_dma_len(s),
-
-	bucket       = get_hash_bucket(&ref, &flags);
-	entry        = hash_bucket_find(bucket, &ref);
+	bucket       = get_hash_bucket(ref, &flags);
+	entry        = hash_bucket_find(bucket, ref);
 	mapped_ents  = 0;
 
 	if (entry)
@@ -1084,7 +1077,7 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			break;
 
 		if (!i)
-			mapped_ents = get_nr_mapped_entries(dev, s);
+			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
 		check_unmap(&ref);
 	}
@@ -1139,10 +1132,19 @@ EXPORT_SYMBOL(debug_dma_free_coherent);
 void debug_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 				   size_t size, int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, 0, direction, true);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, true);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_for_cpu);
 
@@ -1150,10 +1152,19 @@ void debug_dma_sync_single_for_device(struct device *dev,
 				      dma_addr_t dma_handle, size_t size,
 				      int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, 0, direction, false);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, false);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_for_device);
 
@@ -1162,10 +1173,19 @@ void debug_dma_sync_single_range_for_cpu(struct device *dev,
 					 unsigned long offset, size_t size,
 					 int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, offset, direction, true);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = offset + size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, true);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_range_for_cpu);
 
@@ -1174,10 +1194,19 @@ void debug_dma_sync_single_range_for_device(struct device *dev,
 					    unsigned long offset,
 					    size_t size, int direction)
 {
+	struct dma_debug_entry ref;
+
 	if (unlikely(global_disable))
 		return;
 
-	check_sync(dev, dma_handle, size, offset, direction, false);
+	ref.type         = dma_debug_single;
+	ref.dev          = dev;
+	ref.dev_addr     = dma_handle;
+	ref.size         = offset + size;
+	ref.direction    = direction;
+	ref.sg_call_ents = 0;
+
+	check_sync(dev, &ref, false);
 }
 EXPORT_SYMBOL(debug_dma_sync_single_range_for_device);
 
@@ -1191,14 +1220,24 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
+
+		struct dma_debug_entry ref = {
+			.type           = dma_debug_sg,
+			.dev            = dev,
+			.paddr          = sg_phys(s),
+			.dev_addr       = sg_dma_address(s),
+			.size           = sg_dma_len(s),
+			.direction      = direction,
+			.sg_call_ents   = nelems,
+		};
+
 		if (!i)
-			mapped_ents = get_nr_mapped_entries(dev, s);
+			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
 		if (i >= mapped_ents)
 			break;
 
-		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
-			   direction, true);
+		check_sync(dev, &ref, true);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_cpu);
@@ -1213,14 +1252,23 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
+
+		struct dma_debug_entry ref = {
+			.type           = dma_debug_sg,
+			.dev            = dev,
+			.paddr          = sg_phys(s),
+			.dev_addr       = sg_dma_address(s),
+			.size           = sg_dma_len(s),
+			.direction      = direction,
+			.sg_call_ents   = nelems,
+		};
 		if (!i)
-			mapped_ents = get_nr_mapped_entries(dev, s);
+			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
 		if (i >= mapped_ents)
 			break;
 
-		check_sync(dev, sg_dma_address(s), sg_dma_len(s), 0,
-			   direction, false);
+		check_sync(dev, &ref, false);
 	}
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
-- 
1.6.3.1


