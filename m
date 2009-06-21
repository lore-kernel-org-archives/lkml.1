Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZFUKz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZFUKz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 06:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZFUKzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 06:55:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZFUKzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 06:55:48 -0400
Date: Sun, 21 Jun 2009 12:55:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] core kernel fixes
Message-ID: <20090621105539.GA25722@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Left out the futex commit, it's being worked on.

 Thanks,

	Ingo

------------------>
Joerg Roedel (2):
      dma-debug: check for sg_call_ents in best-fit algorithm too
      dma-debug: be more careful when building reference entries

Peter Zijlstra (1):
      lockdep: Select frame pointers on x86


 lib/Kconfig.debug |    2 +-
 lib/dma-debug.c   |  149 +++++++++++++++++++++++++++++++++++------------------
 2 files changed, 99 insertions(+), 52 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6cdcf38..3be4b7c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -440,7 +440,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS && !PPC && !ARM_UNWIND && !S390
+	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390
 	select KALLSYMS
 	select KALLSYMS_ALL
 
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ad65fc0..3b93129 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -262,11 +262,12 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 		 */
 		matches += 1;
 		match_lvl = 0;
-		entry->size      == ref->size      ? ++match_lvl : match_lvl;
-		entry->type      == ref->type      ? ++match_lvl : match_lvl;
-		entry->direction == ref->direction ? ++match_lvl : match_lvl;
+		entry->size         == ref->size         ? ++match_lvl : 0;
+		entry->type         == ref->type         ? ++match_lvl : 0;
+		entry->direction    == ref->direction    ? ++match_lvl : 0;
+		entry->sg_call_ents == ref->sg_call_ents ? ++match_lvl : 0;
 
-		if (match_lvl == 3) {
+		if (match_lvl == 4) {
 			/* perfect-fit - return the result */
 			return entry;
 		} else if (match_lvl > last_lvl) {
@@ -873,72 +874,68 @@ static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
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
@@ -1036,19 +1033,16 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
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
@@ -1076,16 +1070,14 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			.dev_addr       = sg_dma_address(s),
 			.size           = sg_dma_len(s),
 			.direction      = dir,
-			.sg_call_ents   = 0,
+			.sg_call_ents   = nelems,
 		};
 
 		if (mapped_ents && i >= mapped_ents)
 			break;
 
-		if (!i) {
-			ref.sg_call_ents = nelems;
-			mapped_ents = get_nr_mapped_entries(dev, s);
-		}
+		if (!i)
+			mapped_ents = get_nr_mapped_entries(dev, &ref);
 
 		check_unmap(&ref);
 	}
@@ -1140,10 +1132,19 @@ EXPORT_SYMBOL(debug_dma_free_coherent);
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
 
@@ -1151,10 +1152,19 @@ void debug_dma_sync_single_for_device(struct device *dev,
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
 
@@ -1163,10 +1173,19 @@ void debug_dma_sync_single_range_for_cpu(struct device *dev,
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
 
@@ -1175,10 +1194,19 @@ void debug_dma_sync_single_range_for_device(struct device *dev,
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
 
@@ -1192,14 +1220,24 @@ void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
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
@@ -1214,14 +1252,23 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
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
