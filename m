Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZCFP4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZCFP4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZCFPz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:55:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:35738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbZCFPzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:55:55 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, npiggin@suse.de,
       akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] percpu: move chunk area map extension out of area allocation
Date: Sat,  7 Mar 2009 00:54:41 +0900
Message-Id: <1236354883-25063-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236354883-25063-1-git-send-email-tj@kernel.org>
References: <1236354883-25063-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:54:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code reorganization for later changes

Separate out chunk area map extension into a separate function -
pcpu_extend_area_map() - and call it directly from pcpu_alloc() such
that pcpu_alloc_area() is guaranteed to have enough area map slots on
invocation.

With this change, pcpu_alloc_area() does only area allocation and the
only failure mode is when the chunk doens't have enough room, so
there's no need to distinguish it from memory allocation failures.
Make it return -1 on such cases instead of hacky -ENOSPC.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |  108 ++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f1d0e90..7d9bc35 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -307,6 +307,50 @@ static void pcpu_chunk_addr_insert(struct pcpu_chunk *new)
 }
 
 /**
+ * pcpu_extend_area_map - extend area map for allocation
+ * @chunk: target chunk
+ *
+ * Extend area map of @chunk so that it can accomodate an allocation.
+ * A single allocation can split an area into three areas, so this
+ * function makes sure that @chunk->map has at least two extra slots.
+ *
+ * RETURNS:
+ * 0 if noop, 1 if successfully extended, -errno on failure.
+ */
+static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
+{
+	int new_alloc;
+	int *new;
+	size_t size;
+
+	/* has enough? */
+	if (chunk->map_alloc >= chunk->map_used + 2)
+		return 0;
+
+	new_alloc = PCPU_DFL_MAP_ALLOC;
+	while (new_alloc < chunk->map_used + 2)
+		new_alloc *= 2;
+
+	new = pcpu_mem_alloc(new_alloc * sizeof(new[0]));
+	if (!new)
+		return -ENOMEM;
+
+	size = chunk->map_alloc * sizeof(chunk->map[0]);
+	memcpy(new, chunk->map, size);
+
+	/*
+	 * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the chunk is
+	 * one of the first chunks and still using static map.
+	 */
+	if (chunk->map_alloc >= PCPU_DFL_MAP_ALLOC)
+		pcpu_mem_free(chunk->map, size);
+
+	chunk->map_alloc = new_alloc;
+	chunk->map = new;
+	return 0;
+}
+
+/**
  * pcpu_split_block - split a map block
  * @chunk: chunk of interest
  * @i: index of map block to split
@@ -321,44 +365,16 @@ static void pcpu_chunk_addr_insert(struct pcpu_chunk *new)
  * depending on @head, is reduced by @tail bytes and @tail byte block
  * is inserted after the target block.
  *
- * RETURNS:
- * 0 on success, -errno on failure.
+ * @chunk->map must have enough free slots to accomodate the split.
  */
-static int pcpu_split_block(struct pcpu_chunk *chunk, int i, int head, int tail)
+static void pcpu_split_block(struct pcpu_chunk *chunk, int i,
+			     int head, int tail)
 {
 	int nr_extra = !!head + !!tail;
-	int target = chunk->map_used + nr_extra;
-
-	/* reallocation required? */
-	if (chunk->map_alloc < target) {
-		int new_alloc;
-		int *new;
-		size_t size;
-
-		new_alloc = PCPU_DFL_MAP_ALLOC;
-		while (new_alloc < target)
-			new_alloc *= 2;
-
-		new = pcpu_mem_alloc(new_alloc * sizeof(new[0]));
-		if (!new)
-			return -ENOMEM;
-
-		size = chunk->map_alloc * sizeof(chunk->map[0]);
-		memcpy(new, chunk->map, size);
-
-		/*
-		 * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the
-		 * chunk is one of the first chunks and still using
-		 * static map.
-		 */
-		if (chunk->map_alloc >= PCPU_DFL_MAP_ALLOC)
-			pcpu_mem_free(chunk->map, size);
 
-		chunk->map_alloc = new_alloc;
-		chunk->map = new;
-	}
+	BUG_ON(chunk->map_alloc < chunk->map_used + nr_extra);
 
-	/* insert a new subblock */
+	/* insert new subblocks */
 	memmove(&chunk->map[i + nr_extra], &chunk->map[i],
 		sizeof(chunk->map[0]) * (chunk->map_used - i));
 	chunk->map_used += nr_extra;
@@ -371,7 +387,6 @@ static int pcpu_split_block(struct pcpu_chunk *chunk, int i, int head, int tail)
 		chunk->map[i++] -= tail;
 		chunk->map[i] = tail;
 	}
-	return 0;
 }
 
 /**
@@ -384,8 +399,11 @@ static int pcpu_split_block(struct pcpu_chunk *chunk, int i, int head, int tail)
  * Note that this function only allocates the offset.  It doesn't
  * populate or map the area.
  *
+ * @chunk->map must have at least two free slots.
+ *
  * RETURNS:
- * Allocated offset in @chunk on success, -errno on failure.
+ * Allocated offset in @chunk on success, -1 if no matching area is
+ * found.
  */
 static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 {
@@ -433,8 +451,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 
 		/* split if warranted */
 		if (head || tail) {
-			if (pcpu_split_block(chunk, i, head, tail))
-				return -ENOMEM;
+			pcpu_split_block(chunk, i, head, tail);
 			if (head) {
 				i++;
 				off += head;
@@ -461,14 +478,8 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 	chunk->contig_hint = max_contig;	/* fully scanned */
 	pcpu_chunk_relocate(chunk, oslot);
 
-	/*
-	 * Tell the upper layer that this chunk has no area left.
-	 * Note that this is not an error condition but a notification
-	 * to upper layer that it needs to look at other chunks.
-	 * -ENOSPC is chosen as it isn't used in memory subsystem and
-	 * matches the meaning in a way.
-	 */
-	return -ENOSPC;
+	/* tell the upper layer that this chunk has no matching area */
+	return -1;
 }
 
 /**
@@ -755,7 +766,8 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 	/* serve reserved allocations from the reserved chunk if available */
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
-		if (size > chunk->contig_hint)
+		if (size > chunk->contig_hint ||
+		    pcpu_extend_area_map(chunk) < 0)
 			goto out_unlock;
 		off = pcpu_alloc_area(chunk, size, align);
 		if (off >= 0)
@@ -768,11 +780,11 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 		list_for_each_entry(chunk, &pcpu_slot[slot], list) {
 			if (size > chunk->contig_hint)
 				continue;
+			if (pcpu_extend_area_map(chunk) < 0)
+				goto out_unlock;
 			off = pcpu_alloc_area(chunk, size, align);
 			if (off >= 0)
 				goto area_found;
-			if (off != -ENOSPC)
-				goto out_unlock;
 		}
 	}
 
-- 
1.6.0.2

