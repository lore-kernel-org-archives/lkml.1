Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZFQE0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZFQE0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZFQE0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:26:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:41137 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZFQE0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:26:30 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       JBeulich@novell.com, cl@linux-foundation.org, davem@davemloft.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] percpu: reorder a few functions in mm/percpu.c
Date: Wed, 17 Jun 2009 13:26:06 +0900
Message-Id: <1245212769-29134-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245212769-29134-1-git-send-email-tj@kernel.org>
References: <1245212769-29134-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:26:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(de)populate functions are about to be reimplemented to drop
pcpu_chunk->page array.  Move a few functions so that the rewrite
patch doesn't have code movement making it more difficult to read.

[ Impact: code movement ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 mm/percpu.c |   90 +++++++++++++++++++++++++++++-----------------------------
 1 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 452d3f3..770db98 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -181,12 +181,6 @@ static int pcpu_page_idx(unsigned int cpu, int page_idx)
 	return cpu * pcpu_unit_pages + page_idx;
 }
 
-static struct page **pcpu_chunk_pagep(struct pcpu_chunk *chunk,
-				      unsigned int cpu, int page_idx)
-{
-	return &chunk->page[pcpu_page_idx(cpu, page_idx)];
-}
-
 static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 				     unsigned int cpu, int page_idx)
 {
@@ -194,6 +188,12 @@ static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 		(pcpu_page_idx(cpu, page_idx) << PAGE_SHIFT);
 }
 
+static struct page **pcpu_chunk_pagep(struct pcpu_chunk *chunk,
+				      unsigned int cpu, int page_idx)
+{
+	return &chunk->page[pcpu_page_idx(cpu, page_idx)];
+}
+
 static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 				     int page_idx)
 {
@@ -583,6 +583,45 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
 				       pcpu_chunk_addr(chunk, last, page_end));
 }
 
+static int __pcpu_map_pages(unsigned long addr, struct page **pages,
+			    int nr_pages)
+{
+	return map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
+					PAGE_KERNEL, pages);
+}
+
+/**
+ * pcpu_map - map pages into a pcpu_chunk
+ * @chunk: chunk of interest
+ * @page_start: page index of the first page to map
+ * @page_end: page index of the last page to map + 1
+ *
+ * For each cpu, map pages [@page_start,@page_end) into @chunk.
+ * vcache is flushed afterwards.
+ */
+static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
+{
+	unsigned int last = num_possible_cpus() - 1;
+	unsigned int cpu;
+	int err;
+
+	/* map must not be done on immutable chunk */
+	WARN_ON(chunk->immutable);
+
+	for_each_possible_cpu(cpu) {
+		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
+				       pcpu_chunk_pagep(chunk, cpu, page_start),
+				       page_end - page_start);
+		if (err < 0)
+			return err;
+	}
+
+	/* flush at once, please read comments in pcpu_unmap() */
+	flush_cache_vmap(pcpu_chunk_addr(chunk, 0, page_start),
+			 pcpu_chunk_addr(chunk, last, page_end));
+	return 0;
+}
+
 /**
  * pcpu_depopulate_chunk - depopulate and unmap an area of a pcpu_chunk
  * @chunk: chunk to depopulate
@@ -632,45 +671,6 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size,
 		pcpu_unmap(chunk, unmap_start, unmap_end, flush);
 }
 
-static int __pcpu_map_pages(unsigned long addr, struct page **pages,
-			    int nr_pages)
-{
-	return map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
-					PAGE_KERNEL, pages);
-}
-
-/**
- * pcpu_map - map pages into a pcpu_chunk
- * @chunk: chunk of interest
- * @page_start: page index of the first page to map
- * @page_end: page index of the last page to map + 1
- *
- * For each cpu, map pages [@page_start,@page_end) into @chunk.
- * vcache is flushed afterwards.
- */
-static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
-{
-	unsigned int last = num_possible_cpus() - 1;
-	unsigned int cpu;
-	int err;
-
-	/* map must not be done on immutable chunk */
-	WARN_ON(chunk->immutable);
-
-	for_each_possible_cpu(cpu) {
-		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
-				       pcpu_chunk_pagep(chunk, cpu, page_start),
-				       page_end - page_start);
-		if (err < 0)
-			return err;
-	}
-
-	/* flush at once, please read comments in pcpu_unmap() */
-	flush_cache_vmap(pcpu_chunk_addr(chunk, 0, page_start),
-			 pcpu_chunk_addr(chunk, last, page_end));
-	return 0;
-}
-
 /**
  * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
  * @chunk: chunk of interest
-- 
1.6.0.2

